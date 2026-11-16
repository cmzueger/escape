//! Locked In: the escape rooms, their puzzles, hints and scores.
//!
//! The clients (Godot through `godot/`, the web build through `web/`) send
//! text commands to [`Room::call`] and draw what the JSON answer says. All
//! solutions live here; the picture clues are drawn from each room's
//! `clues`, so the client cannot disagree with the rules.
//!
//! Commands for every room:
//! - `rooms`: the catalogue (id, difficulty 1..3, target minutes, puzzles)
//! - `room <id>`: enters a room, fresh
//! - `new`: the current room again, fresh
//! - `state`, `clues`
//! - `tap <hotspot>`: look at, take or open something
//! - `use <item> <hotspot or item>`: use an inventory item on something
//! - `time <seconds>`: the play time so far (the client keeps the clock)
//! - `hintinfo <view>`: which puzzle a hint would be for, and its level
//! - `hint <view>`: reveals the next hint for that puzzle (costs half a star)
//! - `save`: `{"ok":true,"save":"…"}`; `load <save>` (of the current room)
//!
//! Each room adds commands for its mechanisms (see [`hut`], [`light`], [`obs`];
//! the rooms of the second set are described as data for [`kit`]).
//! Answers are `{"ok":true,"msg":"…","state":{…}}` (`msg` is a translation
//! key or empty) or `{"ok":false,"error":"…"}`.

pub mod chess;
pub mod hut;
pub mod kit;
pub mod light;
pub mod obs;
pub mod orangery;
pub mod theatre;

/// The catalogue: id, difficulty (1 easy, 2 medium, 3 hard), target minutes
/// for three stars, number of puzzles.
pub const ROOMS: [(&str, u8, u32, usize); 6] = [
    ("hut", 1, hut::PAR_MINUTES, 9),
    ("light", 2, light::PAR_MINUTES, 10),
    ("obs", 3, obs::PAR_MINUTES, 10),
    ("orangery", 1, 15, 8),
    ("theatre", 2, 25, 8),
    ("chess", 3, 35, 7),
];

/// A further 10 minutes over the target cost half a star each.
const OVERTIME_STEP: u32 = 10 * 60;

/// The score in half stars: 6 within the target without hints, one less for
/// each hint and each started 10 minutes over; at least one star.
pub fn halves(hints: &[u8], secs: u32, par_minutes: u32) -> u8 {
    let hints: u32 = hints.iter().map(|h| u32::from(*h)).sum();
    let over = secs.saturating_sub(par_minutes * 60).div_ceil(OVERTIME_STEP);
    6u32.saturating_sub(hints + over).max(2) as u8
}

/// `["a","b"]` for the names whose bit is set.
pub(crate) fn names_json(list: &[&str], bits: u32) -> String {
    list.iter()
        .enumerate()
        .filter(|(i, _)| bits & (1 << i) != 0)
        .map(|(_, n)| format!("\"{n}\""))
        .collect::<Vec<_>>()
        .join(",")
}

pub(crate) fn nums_json(v: &[u8]) -> String {
    v.iter().map(|d| d.to_string()).collect::<Vec<_>>().join(",")
}

pub(crate) fn strs_json(v: &[&str]) -> String {
    v.iter().map(|s| format!("\"{s}\"")).collect::<Vec<_>>().join(",")
}

pub(crate) fn digits_text(v: &[u8]) -> String {
    v.iter().map(|d| d.to_string()).collect()
}

/// `N` digits, each at most `max`.
pub(crate) fn digits<const N: usize>(s: &str, max: u8) -> Option<[u8; N]> {
    let v: Vec<u8> = s.bytes().map(|b| b.wrapping_sub(b'0')).collect();
    let a: [u8; N] = v.try_into().ok()?;
    a.iter().all(|d| *d <= max).then_some(a)
}

pub(crate) fn bad(what: &str) -> String {
    format!("bad command: {what}")
}

pub(crate) fn step(word: Option<&str>) -> Result<i8, String> {
    match word {
        Some("+1") | Some("1") => Ok(1),
        Some("-1") => Ok(-1),
        other => Err(bad(other.unwrap_or("missing step"))),
    }
}

/// The room being played.
#[derive(Clone, Debug, PartialEq)]
pub enum Room {
    Hut(hut::Hut),
    Light(light::Light),
    Obs(obs::Obs),
    Kit(kit::State),
}

impl Default for Room {
    fn default() -> Self {
        Self::new()
    }
}

impl Room {
    pub fn new() -> Self {
        Room::Hut(hut::Hut::new())
    }

    pub fn id(&self) -> &'static str {
        match self {
            Room::Hut(_) => "hut",
            Room::Light(_) => "light",
            Room::Obs(_) => "obs",
            Room::Kit(room) => room.id(),
        }
    }

    /// Runs one command and returns the JSON answer.
    pub fn call(&mut self, command: &str) -> String {
        let mut w = command.split_whitespace();
        match w.next() {
            Some("rooms") => {
                let list = ROOMS
                    .iter()
                    .map(|(id, level, par, puzzles)| {
                        format!("{{\"id\":\"{id}\",\"difficulty\":{level},\"minutes\":{par},\"puzzles\":{puzzles}}}")
                    })
                    .collect::<Vec<_>>()
                    .join(",");
                format!("{{\"ok\":true,\"rooms\":[{list}]}}")
            }
            Some("room") => {
                match w.next() {
                    Some("hut") => *self = Room::Hut(hut::Hut::new()),
                    Some("light") => *self = Room::Light(light::Light::new()),
                    Some("obs") => *self = Room::Obs(obs::Obs::new()),
                    Some("orangery") => *self = Room::Kit(kit::State::new(&orangery::SPEC)),
                    Some("theatre") => *self = Room::Kit(kit::State::new(&theatre::SPEC)),
                    Some("chess") => *self = Room::Kit(kit::State::new(&chess::SPEC)),
                    other => {
                        return format!("{{\"ok\":false,\"error\":\"no room {}\"}}", other.unwrap_or(""))
                    }
                }
                self.call("state")
            }
            _ => match self {
                Room::Hut(room) => room.call(command),
                Room::Light(room) => room.call(command),
                Room::Obs(room) => room.call(command),
                Room::Kit(room) => room.call(command),
            },
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn catalogue_and_rooms() {
        let mut r = Room::new();
        assert!(r
            .call("rooms")
            .contains("{\"id\":\"light\",\"difficulty\":2,\"minutes\":25,\"puzzles\":10}"));
        assert!(r.call("tap coat").contains("msg.coat_matches"));
        assert!(r.call("room light").starts_with("{\"ok\":true"));
        assert_eq!(r.id(), "light");
        assert!(r.call("tap coat").starts_with("{\"ok\":false"));
        assert!(r.call("room obs").contains("\"room\":\"obs\""));
        for id in ["orangery", "theatre", "chess"] {
            assert!(r
                .call(&format!("room {id}"))
                .contains(&format!("\"room\":\"{id}\"")));
            assert_eq!(r.id(), id);
            assert!(r.call("clues").starts_with("{\"ok\":true"));
        }
        assert!(r.call("room cellar").starts_with("{\"ok\":false"));
        assert!(r.call("room hut").contains("\"inv\":[]"));
    }

    #[test]
    fn scores() {
        assert_eq!(halves(&[0; 9], 900, 15), 6);
        assert_eq!(halves(&[0; 9], 901, 15), 5);
        assert_eq!(halves(&[1, 0, 2], 0, 25), 3);
        assert_eq!(halves(&[3, 3, 3], 99999, 25), 2);
    }
}
