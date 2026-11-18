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

pub mod alch;
pub mod attic;
pub mod beach;
pub mod chess;
pub mod gondola;
pub mod house;
pub mod house1905;
pub mod house1938;
pub mod house1969;
pub mod housenow;
pub mod hut;
pub mod kit;
pub mod light;
pub mod museum;
pub mod obs;
pub mod orangery;
pub mod polar;
pub mod praline;
pub mod ship;
pub mod theatre;
pub mod toyshop;
pub mod train;
pub mod tree;
pub mod watch;
pub mod zeppelin;

/// The catalogue: id, the kind of each puzzle in order, target minutes for
/// three stars. Kinds: A action (use the obvious item), B lookup (one clue
/// into a lock), C combine (two sources, an order, a count), F find (a clue
/// that is easy to miss: hidden, small, only seen at a moment), D mechanism
/// (a contraption, trying works), M hard mechanism (needs planning), E
/// deduction (one twist), X hard deduction (a longer chain or grid).
/// The difficulty shown follows from the kinds ([`difficulty`]); the time
/// is separate (`tools/estimate.py` estimates it from the kinds).
pub const ROOMS: [(&str, &str, u32); 23] = [
    ("hut", "ACABCDDBB", hut::PAR_MINUTES),
    ("light", "ACCBFMDEDA", light::PAR_MINUTES),
    ("obs", "CCMEEDXCAC", obs::PAR_MINUTES),
    ("orangery", "AAACADAC", orangery::PAR_MINUTES),
    ("theatre", "ADACCMAC", theatre::PAR_MINUTES),
    ("chess", "ECEDXXA", chess::PAR_MINUTES),
    ("beach", "CACCAA", beach::PAR_MINUTES),
    ("train", "BBCABA", train::PAR_MINUTES),
    ("alch", "DMCBCA", alch::PAR_MINUTES),
    ("attic", "BAABAA", attic::PAR_MINUTES),
    ("watch", "FABBB", watch::PAR_MINUTES),
    ("museum", "CDCECA", museum::PAR_MINUTES),
    ("tree", "BADAC", tree::PAR_MINUTES),
    ("gondola", "BDAAAE", gondola::PAR_MINUTES),
    ("praline", "BCMDBA", praline::PAR_MINUTES),
    ("toyshop", "FAAMAEA", toyshop::PAR_MINUTES),
    ("zeppelin", "FFEMF", zeppelin::PAR_MINUTES),
    ("ship", "FDMEA", ship::PAR_MINUTES),
    ("polar", "XFMABE", polar::PAR_MINUTES),
    ("house1905", "FADAFA", house1905::PAR_MINUTES),
    ("house1938", "FCDEA", house1938::PAR_MINUTES),
    ("house1969", "FDCEC", house1969::PAR_MINUTES),
    ("housenow", "FEDXEB", housenow::PAR_MINUTES),
];

/// 1 easy, 2 medium, 3 hard: how hard the thinking is, not how long it
/// takes. Points: F and D one, M and E two, X four; medium from 4, hard
/// from 8.
pub fn difficulty(kinds: &str) -> u8 {
    let points: u32 = kinds
        .chars()
        .map(|k| match k {
            'F' | 'D' => 1,
            'M' | 'E' => 2,
            'X' => 4,
            _ => 0,
        })
        .sum();
    match points {
        8.. => 3,
        4.. => 2,
        _ => 1,
    }
}

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

/// The puzzle a hint is for, asked in a view whose puzzles are `wanted`:
/// the first open one there, else the first open one in the room. The note
/// says why: `here`, `later` (the view's puzzle is not ready yet), `done`
/// (everything in this view is solved) or empty (the view names no puzzle).
pub(crate) fn pick_hint(wanted: &[usize], available: &[bool], solved: &[bool]) -> (usize, &'static str) {
    let open = |p: usize| available[p] && !solved[p];
    if let Some(p) = wanted.iter().copied().find(|p| open(*p)) {
        return (p, "here");
    }
    let p = (0..solved.len()).find(|p| open(*p)).unwrap_or(solved.len() - 1);
    let note = if wanted.is_empty() {
        ""
    } else if wanted.iter().all(|p| solved[*p]) {
        "done"
    } else {
        "later"
    };
    (p, note)
}

/// The answer to `hint` and `hintinfo`.
pub(crate) fn hint_json(puzzle: usize, note: &str, level: u8, state: &str) -> String {
    format!(
        "{{\"ok\":true,\"puzzle\":{},\"level\":{level},\"where\":\"{note}\",\"state\":{state}}}",
        puzzle + 1
    )
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
                    .map(|(id, kinds, par)| {
                        format!(
                            "{{\"id\":\"{id}\",\"difficulty\":{},\"minutes\":{par},\"puzzles\":{}}}",
                            difficulty(kinds),
                            kinds.len()
                        )
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
                    Some("beach") => *self = Room::Kit(kit::State::new(&beach::SPEC)),
                    Some("train") => *self = Room::Kit(kit::State::new(&train::SPEC)),
                    Some("alch") => *self = Room::Kit(kit::State::new(&alch::SPEC)),
                    Some("attic") => *self = Room::Kit(kit::State::new(&attic::SPEC)),
                    Some("watch") => *self = Room::Kit(kit::State::new(&watch::SPEC)),
                    Some("museum") => *self = Room::Kit(kit::State::new(&museum::SPEC)),
                    Some("tree") => *self = Room::Kit(kit::State::new(&tree::SPEC)),
                    Some("gondola") => *self = Room::Kit(kit::State::new(&gondola::SPEC)),
                    Some("praline") => *self = Room::Kit(kit::State::new(&praline::SPEC)),
                    Some("toyshop") => *self = Room::Kit(kit::State::new(&toyshop::SPEC)),
                    Some("zeppelin") => *self = Room::Kit(kit::State::new(&zeppelin::SPEC)),
                    Some("ship") => *self = Room::Kit(kit::State::new(&ship::SPEC)),
                    Some("polar") => *self = Room::Kit(kit::State::new(&polar::SPEC)),
                    Some("house1905") => *self = Room::Kit(kit::State::new(&house1905::SPEC)),
                    Some("house1938") => *self = Room::Kit(kit::State::new(&house1938::SPEC)),
                    Some("house1969") => *self = Room::Kit(kit::State::new(&house1969::SPEC)),
                    Some("housenow") => *self = Room::Kit(kit::State::new(&housenow::SPEC)),
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
            .contains("{\"id\":\"light\",\"difficulty\":2,\"minutes\":15,\"puzzles\":10}"));
        // Every kit room lists one kind per puzzle.
        for (spec, kinds) in [
            (&orangery::SPEC, ROOMS[3].1),
            (&theatre::SPEC, ROOMS[4].1),
            (&chess::SPEC, ROOMS[5].1),
            (&beach::SPEC, ROOMS[6].1),
            (&train::SPEC, ROOMS[7].1),
            (&alch::SPEC, ROOMS[8].1),
            (&attic::SPEC, ROOMS[9].1),
            (&watch::SPEC, ROOMS[10].1),
            (&museum::SPEC, ROOMS[11].1),
            (&tree::SPEC, ROOMS[12].1),
            (&gondola::SPEC, ROOMS[13].1),
            (&praline::SPEC, ROOMS[14].1),
            (&toyshop::SPEC, ROOMS[15].1),
            (&zeppelin::SPEC, ROOMS[16].1),
            (&ship::SPEC, ROOMS[17].1),
            (&polar::SPEC, ROOMS[18].1),
            (&house1905::SPEC, ROOMS[19].1),
            (&house1938::SPEC, ROOMS[20].1),
            (&house1969::SPEC, ROOMS[21].1),
            (&housenow::SPEC, ROOMS[22].1),
        ] {
            assert_eq!(spec.puzzles.len(), kinds.len(), "{}", spec.id);
        }
        assert_eq!(hut::Hut::new().solved().len(), ROOMS[0].1.len());
        assert!(r.call("tap coat").contains("msg.coat_matches"));
        assert!(r.call("room light").starts_with("{\"ok\":true"));
        assert_eq!(r.id(), "light");
        assert!(r.call("tap coat").starts_with("{\"ok\":false"));
        assert!(r.call("room obs").contains("\"room\":\"obs\""));
        for id in [
            "orangery",
            "theatre",
            "chess",
            "beach",
            "train",
            "alch",
            "attic",
            "watch",
            "museum",
            "tree",
            "gondola",
            "praline",
            "toyshop",
            "zeppelin",
            "ship",
            "polar",
            "house1905",
            "house1938",
            "house1969",
            "housenow",
        ] {
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
    fn hints_say_why() {
        let mut r = Room::new();
        r.call("room chess");
        // The small board needs a piece found later: the hint is for another
        // puzzle, and says so.
        let info = r.call("hintinfo mini");
        assert!(
            info.contains("\"where\":\"later\"") && info.contains("\"puzzle\":1,"),
            "{info}"
        );
        assert!(r.call("hintinfo travel").contains("\"where\":\"here\""));
        assert!(r.call("hintinfo nowhere").contains("\"where\":\"\""));
        r.call("room light");
        assert!(r.call("hintinfo seachart").contains("\"where\":\"later\""));
    }

    /// No room can be shortcut by a player who knows every answer: each
    /// puzzle needs the ones before it, and every item has a use.
    #[test]
    fn no_shortcuts() {
        let digits = |cmd: &str, n: usize| (0..n).map(|i| format!("{cmd} {i}")).collect::<Vec<_>>();
        let tilts = || {
            ["n", "e", "s", "w", "reset"]
                .map(|w| format!("tilt {w}"))
                .to_vec()
        };
        let mut king = vec![];
        for f in 0..4 {
            for r in 0..4 {
                king.push(format!("king {f} {r}"));
            }
        }
        let mut mix = vec!["bellows".to_string()];
        for v in 0..3 {
            mix.push(format!("empty {v}"));
            for p in 0..3 {
                mix.push(format!("mix {v} {p}"));
            }
        }
        type Room<'a> = (&'static kit::Spec, Vec<String>, Vec<&'a str>, Vec<&'a str>);
        let rooms: Vec<Room> = vec![
            (&orangery::SPEC, vec![], vec![], vec![]),
            (
                &theatre::SPEC,
                [digits("mask", 5), digits("bulb", 6)].concat(),
                vec![],
                vec![],
            ),
            (
                &chess::SPEC,
                king,
                vec!["sq0", "sq1", "sq2"],
                vec!["rook", "bishop", "knight", "wking"],
            ),
            (&beach::SPEC, digits("pull", 3), vec![], vec![]),
            (&train::SPEC, digits("seat", 4), vec![], vec![]),
            (
                &alch::SPEC,
                mix,
                vec!["furnace"],
                vec!["crucible", "nugget", "elixir"],
            ),
            (&attic::SPEC, vec![], vec![], vec![]),
            (
                &watch::SPEC,
                vec![],
                vec!["watch"],
                vec!["spring", "gearw", "balance"],
            ),
            (&museum::SPEC, digits("glyph", 6), vec![], vec![]),
            (&tree::SPEC, vec![], vec![], vec![]),
            (&gondola::SPEC, vec!["start".into()], vec![], vec![]),
            (
                &praline::SPEC,
                [tilts(), digits("rotate", 4)].concat(),
                vec![],
                vec![],
            ),
            (
                &toyshop::SPEC,
                [tilts(), digits("drawer", 12)].concat(),
                vec![],
                vec![],
            ),
            (&zeppelin::SPEC, digits("slot", 4), vec![], vec![]),
            (
                &ship::SPEC,
                ["pc", "cs", "flood", "pump"]
                    .map(|o| format!("tank {o}"))
                    .to_vec(),
                vec![],
                vec![],
            ),
            (
                &polar::SPEC,
                [
                    digits("crate", 8),
                    ["n", "e", "s", "w"].map(|w| format!("push {w}")).to_vec(),
                    vec!["crate reset".into()],
                ]
                .concat(),
                vec![],
                vec![],
            ),
            (
                &house1905::SPEC,
                [digits("key", 8), vec!["listen box".into()]].concat(),
                vec![],
                vec![],
            ),
            (
                &house1938::SPEC,
                [digits("panel", 6), digits("say", 3), vec!["call".into()]].concat(),
                vec![],
                vec![],
            ),
            (
                &house1969::SPEC,
                [
                    digits("key", 8),
                    digits("say", 3),
                    vec!["call".into(), "listen box".into(), "listen record".into()],
                ]
                .concat(),
                vec![],
                vec![],
            ),
            (
                &housenow::SPEC,
                [digits("key", 8), digits("say", 3), vec!["call".into()]].concat(),
                vec![],
                vec![],
            ),
        ];
        let mut problems = vec![];
        for (spec, commands, spots, hook_items) in rooms {
            let commands: Vec<&str> = commands.iter().map(|c| c.as_str()).collect();
            if let Err(e) = kit::omniscient_walk(spec, &commands, &spots, &hook_items) {
                problems.push(e);
            }
        }
        assert!(problems.is_empty(), "{problems:#?}");
    }

    #[test]
    fn scores() {
        assert_eq!(halves(&[0; 9], 900, 15), 6);
        assert_eq!(halves(&[0; 9], 901, 15), 5);
        assert_eq!(halves(&[1, 0, 2], 0, 25), 3);
        assert_eq!(halves(&[3, 3, 3], 99999, 25), 2);
    }
}
