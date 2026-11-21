//! Hut 2847 (easy): the room, its nine puzzles, hints and score.
//!
//! The clients (Godot through `godot/`, the web build through `web/`) send
//! text commands to [`Hut::call`] and draw what the JSON answer says. All
//! solutions live here; the picture clues are drawn from [`clues_json`], so
//! the client cannot disagree with the rules.
//!
//! Commands:
//! - `new`: a fresh room
//! - `state`
//! - `tap <hotspot>`: look at, take or open something
//! - `use <item> <hotspot>`: use an inventory item on something
//! - `dial <cup|safe> <wheel> <+1|-1>`: turn a wheel of a combination lock
//! - `clock <h|m> <+1|-1>`: move a hand of the cuckoo clock (minutes in fives)
//! - `baro <+1|-1>`: turn the barometer's ring by one step
//! - `wire <cell>`: turn a cable tile a quarter turn
//! - `tune <c|m|f> <+1|-1>`: the radio's coarse, medium and fine knobs
//! - `key <s|l>`: a short or long signal on the morse key
//! - `time <seconds>`: the play time so far (the client keeps the clock)
//! - `hintinfo <view>`: which puzzle a hint would be for, and its level
//! - `hint <view>`: reveals the next hint for that puzzle (costs half a star)
//! - `save`: `{"ok":true,"save":"…"}`; `load <save>`
//! - `clues`: what the pictures in the room must show
//!
//! Other answers are `{"ok":true,"msg":"…","state":{…}}` (`msg` is a
//! translation key or empty) or `{"ok":false,"error":"…"}`.

/// Things that have happened in the room.
pub const FLAGS: [&str; 22] = [
    "lamp_lit",
    "got_matches",
    "cup_open",
    "got_kindling",
    "got_log",
    "stove_wood",
    "stove_kindling",
    "stove_lit",
    "got_bucket",
    "bucket_melted",
    "door2_open",
    "clock_open",
    "got_dkey",
    "drawer_open",
    "map_overlay",
    "safe_open",
    "got_fuse",
    "baro_open",
    "got_crank",
    "fuse_in",
    "crank_on",
    "tuned",
];

/// Everything that can be carried.
pub const ITEMS: [&str; 9] = [
    "matches", "kindling", "log", "bucket", "key", "dkey", "paper", "fuse", "crank",
];

/// Objects counted for the cupboard lock, in the order of the note on it.
pub const COUNT_ORDER: [&str; 3] = ["hat", "mug", "axe"];
pub const COUNTS: [u8; 3] = [4, 7, 3];

/// The hut's altitude in metres: on the sign over the door and on the map,
/// and the radio's frequency.
pub const ALTITUDE: u16 = 2847;

/// Log book rows: day, weather, pressure (hPa), hour, minute. The row with
/// the bird doodle ([`LOG_BIRD`]) gives the cuckoo clock's time.
pub const LOG: [(u8, &str, u16, u8, u8); 5] = [
    (11, "sun", 1030, 7, 10),
    (12, "cloud", 1015, 12, 40),
    (13, "rain", 1000, 18, 5),
    (14, "snow", 985, 9, 30),
    (15, "storm", 970, 16, 25),
];
pub const LOG_BIRD: usize = 4;

/// Altitudes printed on the map, and the tracing paper's holes in order:
/// (label, character). The digits under the holes open the strongbox.
pub const MAP_LABELS: [&str; 5] = ["2847", "3196", "2410", "1935", "2638"];
pub const MAP_HOLES: [(usize, usize); 4] = [(1, 3), (2, 2), (3, 1), (4, 2)];

/// The barometer's ring has 24 steps of 5 hPa; it starts this many steps off.
pub const BARO_STEPS: i8 = 24;
const BARO_START: i8 = 7;

/// The radio's cable board: 3 rows of 5 tiles. `I` straight, `L` corner,
/// `T` junction. Power comes in at the left of the first tile and must
/// leave at the right of the last one.
pub const WIRE_COLS: usize = 5;
pub const WIRE_ROWS: usize = 3;
pub const WIRE_TILES: [char; 15] = [
    'L', 'T', 'L', 'I', 'L', //
    'L', 'I', 'L', 'L', 'I', //
    'I', 'L', 'T', 'I', 'L',
];
const WIRE_START: [u8; 15] = [0, 1, 3, 0, 1, 2, 0, 0, 2, 1, 1, 3, 0, 0, 2];
#[cfg(test)]
const WIRE_SOLVED: [u8; 15] = [2, 1, 1, 1, 2, 0, 1, 3, 2, 0, 1, 3, 0, 0, 0];

/// The rescue station's signal, to be repeated on the morse key.
pub const SIGNAL: &str = "lsslsl";

const FREQ_START: u16 = 3150;
pub const PAR_MINUTES: u32 = 4;

/// Hotspots that only say something.
const FLAVOUR: [&str; 12] = [
    "window", "sign", "bunk", "hats", "mugs", "axes", "poster", "bed", "boots", "photo", "table", "antenna",
];

/// Hotspots that can be found without light.
const IN_THE_DARK: [&str; 5] = ["coat", "lamp", "window", "door_out", "sign"];

#[derive(Clone, Debug, PartialEq)]
pub struct Hut {
    flags: u32,
    inv: u16,
    cup: [u8; 3],
    safe: [u8; 4],
    clock: (u8, u8),
    baro: i8,
    wire: [u8; 15],
    freq: u16,
    keyed: String,
    hints: [u8; 9],
    secs: u32,
    done: bool,
}

impl Default for Hut {
    fn default() -> Self {
        Self::new()
    }
}

use crate::{bad, digits, step};

type Reply = Result<&'static str, String>;

fn index(list: &[&str], name: &str) -> Option<usize> {
    list.iter().position(|n| *n == name)
}

/// A tile's cable ends after `rot` quarter turns clockwise (N=1 E=2 S=4 W=8).
fn tile_mask(tile: char, rot: u8) -> u8 {
    let base: u8 = match tile {
        'I' => 0b0101,
        'L' => 0b0011,
        'T' => 0b0111,
        _ => 0,
    };
    let r = rot % 4;
    ((base << r) | (base >> (4 - r))) & 15
}

/// Whether the cable board connects its left entry to its right exit.
pub fn wired(rot: &[u8; 15]) -> bool {
    let mask = |i: usize| tile_mask(WIRE_TILES[i], rot[i]);
    if mask(0) & 8 == 0 {
        return false;
    }
    let mut seen = [false; 15];
    let mut todo = vec![0usize];
    seen[0] = true;
    while let Some(i) = todo.pop() {
        let (r, c) = (i / WIRE_COLS, i % WIRE_COLS);
        let m = mask(i);
        let mut go = |ok: bool, j: usize, out: u8, back: u8| {
            if ok && m & out != 0 && mask(j) & back != 0 && !seen[j] {
                seen[j] = true;
                todo.push(j);
            }
        };
        go(r > 0, i.wrapping_sub(WIRE_COLS), 1, 4);
        go(c + 1 < WIRE_COLS, i + 1, 2, 8);
        go(r + 1 < WIRE_ROWS, i + WIRE_COLS, 4, 1);
        go(c > 0, i.wrapping_sub(1), 8, 2);
    }
    seen[14] && mask(14) & 2 != 0
}

/// The strongbox code: the map digits under the tracing paper's holes.
pub fn safe_code() -> [u8; 4] {
    MAP_HOLES.map(|(label, ch)| MAP_LABELS[label].as_bytes()[ch] - b'0')
}

impl Hut {
    pub fn new() -> Self {
        Hut {
            flags: 0,
            inv: 0,
            cup: [0; 3],
            safe: [0; 4],
            clock: (12, 0),
            baro: BARO_START,
            wire: WIRE_START,
            freq: FREQ_START,
            keyed: String::new(),
            hints: [0; 9],
            secs: 0,
            done: false,
        }
    }

    pub fn flag(&self, name: &str) -> bool {
        index(&FLAGS, name).is_some_and(|i| self.flags & (1 << i) != 0)
    }

    fn set(&mut self, name: &str) {
        let i = index(&FLAGS, name).expect("known flag");
        self.flags |= 1 << i;
    }

    pub fn has(&self, item: &str) -> bool {
        index(&ITEMS, item).is_some_and(|i| self.inv & (1 << i) != 0)
    }

    fn give(&mut self, item: &str) {
        self.inv |= 1 << index(&ITEMS, item).expect("known item");
    }

    fn take(&mut self, item: &str) {
        self.inv &= !(1 << index(&ITEMS, item).expect("known item"));
    }

    pub fn done(&self) -> bool {
        self.done
    }

    /// Radio powered: fuse in, cables connected, crank attached.
    pub fn power(&self) -> bool {
        self.flag("fuse_in") && self.flag("crank_on") && wired(&self.wire)
    }

    /// Which of the nine puzzles are solved.
    pub fn solved(&self) -> [bool; 9] {
        [
            self.flag("lamp_lit"),
            self.flag("cup_open"),
            self.flag("door2_open"),
            self.flag("got_dkey"),
            self.flag("safe_open"),
            self.flag("baro_open"),
            self.power(),
            self.flag("tuned"),
            self.done,
        ]
    }

    fn available(&self) -> [bool; 9] {
        let light = self.flag("lamp_lit");
        let room2 = self.flag("door2_open");
        [
            true,
            light,
            light,
            room2,
            room2,
            room2,
            room2,
            self.power(),
            self.flag("tuned"),
        ]
    }

    pub fn act(&self) -> u8 {
        let s = self.solved();
        if !s[2] {
            1
        } else if !(s[3] && s[4] && s[5]) {
            2
        } else {
            3
        }
    }

    /// The score in half stars: 6 for 15 minutes without hints, one less
    /// for each hint and each started 10 minutes over; at least one star.
    pub fn halves(&self) -> u8 {
        crate::halves(&self.hints, self.secs, PAR_MINUTES)
    }

    /// The puzzle (0..9) a hint asked for in `view` is about.
    fn hint_puzzle(&self, view: &str) -> (usize, &'static str) {
        let solved = self.solved();
        let available = self.available();
        let wanted: &[usize] = match view {
            "lock" | "C" => &[1, 2],
            "A" => &[0, 2],
            "B" => &[2],
            "clock" => &[3],
            "logbook" => &[3, 5],
            "map" | "safe" | "E" => &[4, 3],
            "baro" => &[5],
            "D" => &[3, 5, 6],
            "wiring" => &[6],
            "radio" => &[6, 7, 8],
            _ => &[],
        };
        crate::pick_hint(wanted, &available, &solved)
    }

    fn tap(&mut self, spot: &str) -> Reply {
        // In the dark only a few things can be found (unknown hotspots are still refused).
        if !self.flag("lamp_lit") && !IN_THE_DARK.contains(&spot) {
            return self.clone().tap_lit(spot).map(|_| "msg.too_dark");
        }
        self.tap_lit(spot)
    }

    fn tap_lit(&mut self, spot: &str) -> Reply {
        Ok(match spot {
            "coat" => {
                if self.flag("got_matches") {
                    "msg.coat_empty"
                } else {
                    self.set("got_matches");
                    self.give("matches");
                    "msg.coat_matches"
                }
            }
            "lamp" => {
                if self.flag("lamp_lit") {
                    "msg.lamp_on"
                } else {
                    "msg.lamp_dark"
                }
            }
            "door_out" => "msg.door_frozen",
            "cupboard" => {
                if !self.flag("cup_open") {
                    "msg.cup_locked"
                } else if self.flag("got_kindling") {
                    "msg.cup_empty"
                } else {
                    self.set("got_kindling");
                    self.give("kindling");
                    "msg.kindling"
                }
            }
            "woodbox" => {
                if self.flag("got_log") {
                    "msg.woodbox_more"
                } else {
                    self.set("got_log");
                    self.give("log");
                    "msg.wood"
                }
            }
            "bucket" => {
                if self.flag("got_bucket") {
                    "msg.nothing"
                } else {
                    self.set("got_bucket");
                    self.give("bucket");
                    "msg.bucket"
                }
            }
            "stove" => {
                if self.flag("stove_lit") {
                    "msg.stove_on"
                } else {
                    "msg.stove_cold"
                }
            }
            "door2" => {
                if self.flag("door2_open") {
                    "msg.door2_open"
                } else {
                    "msg.door2_locked"
                }
            }
            "cuckoo" => {
                if !self.flag("clock_open") {
                    "msg.cuckoo_shut"
                } else if self.flag("got_dkey") {
                    "msg.nothing"
                } else {
                    self.set("got_dkey");
                    self.give("dkey");
                    "msg.dkey"
                }
            }
            "drawer" => {
                if self.flag("drawer_open") {
                    "msg.nothing"
                } else {
                    "msg.drawer_locked"
                }
            }
            "map" => {
                if self.flag("map_overlay") {
                    "msg.map_overlay"
                } else {
                    "msg.map"
                }
            }
            "safe" => {
                if !self.flag("safe_open") {
                    "msg.safe_locked"
                } else if self.flag("got_fuse") {
                    "msg.nothing"
                } else {
                    self.set("got_fuse");
                    self.give("fuse");
                    "msg.fuse"
                }
            }
            "baro_crank" => {
                if !self.flag("baro_open") {
                    "msg.baro_shut"
                } else if self.flag("got_crank") {
                    "msg.nothing"
                } else {
                    self.set("got_crank");
                    self.give("crank");
                    "msg.crank"
                }
            }
            "radio" | "radio_back" => {
                if self.power() {
                    "msg.radio_on"
                } else {
                    "msg.radio_dead"
                }
            }
            "fuse_slot" => {
                if self.flag("fuse_in") {
                    "msg.nothing"
                } else {
                    "msg.need_fuse"
                }
            }
            "crank_slot" => {
                if self.flag("crank_on") {
                    "msg.nothing"
                } else {
                    "msg.need_crank"
                }
            }
            other if FLAVOUR.contains(&other) => match other {
                "window" => "msg.window",
                "sign" => "msg.sign",
                "bunk" => "msg.bunk",
                "hats" => "msg.hats",
                "mugs" => "msg.mugs",
                "axes" => "msg.axes",
                "poster" => "msg.poster",
                "bed" => "msg.bed",
                "boots" => "msg.boots",
                "photo" => "msg.photo",
                "table" => "msg.table",
                _ => "msg.antenna",
            },
            other => return Err(bad(other)),
        })
    }

    fn use_item(&mut self, item: &str, spot: &str) -> Reply {
        if !self.has(item) {
            return Err(format!("not carried: {item}"));
        }
        if !self.flag("lamp_lit") && !IN_THE_DARK.contains(&spot) {
            return Ok("msg.too_dark");
        }
        Ok(match (item, spot) {
            ("matches", "lamp") => {
                if self.flag("lamp_lit") {
                    "msg.lamp_on"
                } else {
                    self.set("lamp_lit");
                    "msg.lamp_lit"
                }
            }
            ("log", "stove") => {
                self.take("log");
                self.set("stove_wood");
                "msg.stove_wood"
            }
            ("kindling", "stove") => {
                self.take("kindling");
                self.set("stove_kindling");
                "msg.stove_kindling"
            }
            ("matches", "stove") => {
                if self.flag("stove_lit") {
                    "msg.stove_on"
                } else if self.flag("stove_wood") && self.flag("stove_kindling") {
                    self.take("matches");
                    self.set("stove_lit");
                    "msg.stove_lit"
                } else {
                    "msg.stove_need"
                }
            }
            ("bucket", "stove") => {
                if self.flag("stove_lit") {
                    self.take("bucket");
                    self.set("bucket_melted");
                    self.give("key");
                    "msg.bucket_melt"
                } else {
                    "msg.bucket_cold"
                }
            }
            ("key", "door2") => {
                self.take("key");
                self.set("door2_open");
                "msg.door2_unlocked"
            }
            ("key", "door_out") => "msg.key_wrong",
            ("dkey", "drawer") => {
                self.take("dkey");
                self.set("drawer_open");
                self.give("paper");
                "msg.drawer_open"
            }
            ("paper", "map") => {
                self.take("paper");
                self.set("map_overlay");
                "msg.map_overlay"
            }
            ("fuse", "fuse_slot" | "radio_back" | "radio") => {
                self.take("fuse");
                self.set("fuse_in");
                self.powered("msg.fuse_in")
            }
            ("crank", "crank_slot" | "radio" | "radio_back") => {
                self.take("crank");
                self.set("crank_on");
                self.powered("msg.crank_on")
            }
            _ => "msg.no_use",
        })
    }

    /// `msg`, or the news that the radio now has power.
    fn powered(&self, msg: &'static str) -> &'static str {
        if self.power() {
            "msg.power"
        } else {
            msg
        }
    }

    fn dial(&mut self, lock: &str, wheel: Option<&str>, by: i8) -> Reply {
        let wheel: usize = wheel.and_then(|w| w.parse().ok()).ok_or_else(|| bad("wheel"))?;
        let turn = |d: &mut u8| *d = ((*d as i8 + by).rem_euclid(10)) as u8;
        match lock {
            "cup" if self.flag("cup_open") => Ok(""),
            "cup" => {
                turn(self.cup.get_mut(wheel).ok_or_else(|| bad("wheel"))?);
                if self.cup == COUNTS {
                    self.set("cup_open");
                    return Ok("msg.cup_open");
                }
                Ok("")
            }
            "safe" if self.flag("safe_open") => Ok(""),
            "safe" => {
                turn(self.safe.get_mut(wheel).ok_or_else(|| bad("wheel"))?);
                if self.safe == safe_code() {
                    self.set("safe_open");
                    return Ok("msg.safe_open");
                }
                Ok("")
            }
            other => Err(bad(other)),
        }
    }

    fn clock(&mut self, hand: Option<&str>, by: i8) -> Reply {
        if self.flag("clock_open") {
            return Ok("");
        }
        match hand {
            Some("h") => self.clock.0 = ((self.clock.0 as i8 - 1 + by).rem_euclid(12) + 1) as u8,
            Some("m") => self.clock.1 = ((self.clock.1 as i8 + 5 * by).rem_euclid(60)) as u8,
            _ => return Err(bad("hand")),
        }
        let (_, _, _, h, m) = LOG[LOG_BIRD];
        if self.clock == ((h - 1) % 12 + 1, m) {
            self.set("clock_open");
            return Ok("msg.clock_open");
        }
        Ok("")
    }

    fn baro(&mut self, by: i8) -> Reply {
        if self.flag("baro_open") {
            return Ok("");
        }
        self.baro = (self.baro + by).rem_euclid(BARO_STEPS);
        if self.baro == 0 {
            self.set("baro_open");
            return Ok("msg.baro_open");
        }
        Ok("")
    }

    fn wire(&mut self, cell: Option<&str>) -> Reply {
        let cell: usize = cell
            .and_then(|c| c.parse().ok())
            .filter(|c| *c < 15)
            .ok_or_else(|| bad("cell"))?;
        if wired(&self.wire) {
            return Ok("");
        }
        self.wire[cell] = (self.wire[cell] + 1) % 4;
        if wired(&self.wire) {
            return Ok(if self.power() { "msg.power" } else { "msg.wired" });
        }
        Ok("")
    }

    fn tune(&mut self, knob: Option<&str>, by: i8) -> Reply {
        if !self.power() {
            return Ok("msg.radio_dead");
        }
        if self.flag("tuned") {
            return Ok("");
        }
        let size: i32 = match knob {
            Some("c") => 100,
            Some("m") => 10,
            Some("f") => 1,
            _ => return Err(bad("knob")),
        };
        self.freq = (i32::from(self.freq) - 2000 + size * i32::from(by)).rem_euclid(2000) as u16 + 2000;
        if self.freq == ALTITUDE {
            self.set("tuned");
            return Ok("msg.tuned");
        }
        Ok("")
    }

    fn key(&mut self, signal: Option<&str>) -> Reply {
        if !self.flag("tuned") {
            return Ok(if self.power() {
                "msg.key_static"
            } else {
                "msg.radio_dead"
            });
        }
        if self.done {
            return Ok("");
        }
        match signal {
            Some("s") => self.keyed.push('s'),
            Some("l") => self.keyed.push('l'),
            _ => return Err(bad("signal")),
        }
        if self.keyed.len() < SIGNAL.len() {
            return Ok("");
        }
        if self.keyed == SIGNAL {
            self.done = true;
            return Ok("msg.signal_ok");
        }
        self.keyed.clear();
        Ok("msg.signal_wrong")
    }

    pub fn save(&self) -> String {
        let join = |v: &[u8]| v.iter().map(|d| d.to_string()).collect::<String>();
        format!(
            "1.{:x}.{:x}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}",
            self.flags,
            self.inv,
            join(&self.cup),
            join(&self.safe),
            self.clock.0,
            self.clock.1,
            self.baro,
            join(&self.wire),
            self.freq,
            if self.keyed.is_empty() { "-" } else { &self.keyed },
            join(&self.hints),
            self.secs,
            u8::from(self.done)
        )
    }

    pub fn load(text: &str) -> Result<Hut, String> {
        let err = || "bad save".to_string();
        let p: Vec<&str> = text.trim().split('.').collect();
        if p.len() != 14 || p[0] != "1" {
            return Err(err());
        }
        let room = Hut {
            flags: u32::from_str_radix(p[1], 16)
                .ok()
                .filter(|f| *f < 1 << FLAGS.len())
                .ok_or_else(err)?,
            inv: u16::from_str_radix(p[2], 16)
                .ok()
                .filter(|f| *f < 1 << ITEMS.len())
                .ok_or_else(err)?,
            cup: digits(p[3], 9).ok_or_else(err)?,
            safe: digits(p[4], 9).ok_or_else(err)?,
            clock: (
                p[5].parse()
                    .ok()
                    .filter(|h| (1..=12).contains(h))
                    .ok_or_else(err)?,
                p[6].parse()
                    .ok()
                    .filter(|m| *m < 60 && m % 5 == 0)
                    .ok_or_else(err)?,
            ),
            baro: p[7]
                .parse()
                .ok()
                .filter(|b| (0..BARO_STEPS).contains(b))
                .ok_or_else(err)?,
            wire: digits(p[8], 3).ok_or_else(err)?,
            freq: p[9]
                .parse()
                .ok()
                .filter(|f| (2000..4000).contains(f))
                .ok_or_else(err)?,
            keyed: match p[10] {
                "-" => String::new(),
                k if k.len() <= SIGNAL.len() && k.bytes().all(|b| b == b's' || b == b'l') => k.to_string(),
                _ => return Err(err()),
            },
            hints: digits(p[11], 3).ok_or_else(err)?,
            secs: p[12].parse().map_err(|_| err())?,
            done: p[13] == "1",
        };
        Ok(room)
    }

    pub fn state_json(&self) -> String {
        let names = |list: &[&str], bits: u32| {
            list.iter()
                .enumerate()
                .filter(|(i, _)| bits & (1 << i) != 0)
                .map(|(_, n)| format!("\"{n}\""))
                .collect::<Vec<_>>()
                .join(",")
        };
        let nums = |v: &[u8]| v.iter().map(|d| d.to_string()).collect::<Vec<_>>().join(",");
        let solved = self.solved().map(|b| b.to_string()).join(",");
        // Steps the barometer's ring is off, -11..12.
        let off = if self.baro > BARO_STEPS / 2 {
            self.baro - BARO_STEPS
        } else {
            self.baro
        };
        format!(
            "{{\"flags\":[{}],\"inv\":[{}],\"cup\":[{}],\"safe\":[{}],\"clock\":[{},{}],\"baro\":{},\"wire\":[{}],\"wired\":{},\"power\":{},\"freq\":{},\"keyed\":\"{}\",\"hints\":[{}],\"solved\":[{}],\"act\":{},\"secs\":{},\"done\":{},\"halves\":{}}}",
            names(&FLAGS, self.flags),
            names(&ITEMS, u32::from(self.inv)),
            nums(&self.cup),
            nums(&self.safe),
            self.clock.0,
            self.clock.1,
            off,
            nums(&self.wire),
            wired(&self.wire),
            self.power(),
            self.freq,
            self.keyed,
            nums(&self.hints),
            solved,
            self.act(),
            self.secs,
            self.done,
            self.halves()
        )
    }

    fn answer(&self, msg: &str) -> String {
        format!(
            "{{\"ok\":true,\"msg\":\"{msg}\",\"state\":{}}}",
            self.state_json()
        )
    }

    /// Runs one command and returns the JSON answer.
    pub fn call(&mut self, command: &str) -> String {
        let mut w = command.split_whitespace();
        let result: Reply = match w.next() {
            Some("new") => {
                *self = Hut::new();
                Ok("")
            }
            Some("state") => Ok(""),
            Some("clues") => return clues_json(),
            Some("save") => return format!("{{\"ok\":true,\"save\":\"{}\"}}", self.save()),
            Some("load") => Hut::load(w.next().unwrap_or("")).map(|room| {
                *self = room;
                ""
            }),
            Some("time") => w
                .next()
                .and_then(|s| s.parse::<u32>().ok())
                .ok_or_else(|| bad("time"))
                .map(|s| {
                    if !self.done {
                        self.secs = self.secs.max(s);
                    }
                    ""
                }),
            Some(kind @ ("hint" | "hintinfo")) => {
                let (p, note) = self.hint_puzzle(w.next().unwrap_or(""));
                if kind == "hint" && self.hints[p] < 3 && !self.done {
                    self.hints[p] += 1;
                }
                return crate::hint_json(p, note, self.hints[p], &self.state_json());
            }
            Some(_) if self.done => Ok(""),
            Some("tap") => w.next().ok_or_else(|| bad("tap")).and_then(|s| self.tap(s)),
            Some("use") => match (w.next(), w.next()) {
                (Some(item), Some(spot)) => self.use_item(item, spot),
                _ => Err(bad("use")),
            },
            Some("dial") => match w.next() {
                Some(lock) => {
                    let wheel = w.next();
                    step(w.next()).and_then(|by| self.dial(lock, wheel, by))
                }
                None => Err(bad("dial")),
            },
            Some("clock") => {
                let hand = w.next();
                step(w.next()).and_then(|by| self.clock(hand, by))
            }
            Some("baro") => step(w.next()).and_then(|by| self.baro(by)),
            Some("wire") => self.wire(w.next()),
            Some("tune") => {
                let knob = w.next();
                step(w.next()).and_then(|by| self.tune(knob, by))
            }
            Some("key") => self.key(w.next()),
            other => Err(bad(other.unwrap_or("empty"))),
        };
        match result {
            Ok(msg) => self.answer(msg),
            Err(e) => format!("{{\"ok\":false,\"error\":\"{}\"}}", e.replace(['"', '\\'], "'")),
        }
    }
}

/// What the room's pictures must show (the client draws from this).
pub fn clues_json() -> String {
    let strs = |v: &[&str]| v.iter().map(|s| format!("\"{s}\"")).collect::<Vec<_>>().join(",");
    let log = LOG
        .iter()
        .enumerate()
        .map(|(i, (day, weather, hpa, h, m))| {
            format!(
                "{{\"day\":{day},\"weather\":\"{weather}\",\"hpa\":{hpa},\"h\":{h},\"m\":{m},\"bird\":{}}}",
                i == LOG_BIRD
            )
        })
        .collect::<Vec<_>>()
        .join(",");
    let holes = MAP_HOLES
        .iter()
        .map(|(l, c)| format!("[{l},{c}]"))
        .collect::<Vec<_>>()
        .join(",");
    let tiles = WIRE_TILES
        .iter()
        .map(|t| format!("\"{t}\""))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"count_order\":[{}],\"counts\":{{\"hat\":{},\"mug\":{},\"axe\":{}}},\"altitude\":{},\"log\":[{}],\"map_labels\":[{}],\"map_holes\":[{}],\"wire_tiles\":[{}],\"signal\":\"{}\"}}",
        strs(&COUNT_ORDER),
        COUNTS[0],
        COUNTS[1],
        COUNTS[2],
        ALTITUDE,
        log,
        strs(&MAP_LABELS),
        holes,
        tiles,
        SIGNAL
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn msg(room: &mut Hut, command: &str) -> String {
        let answer = room.call(command);
        assert!(answer.starts_with("{\"ok\":true"), "{command}: {answer}");
        let start = answer.find("\"msg\":\"").map(|i| i + 7).unwrap_or(0);
        answer[start..].split('"').next().unwrap().to_string()
    }

    fn turn_to(room: &mut Hut, lock: &str, code: &[u8]) {
        for (i, d) in code.iter().enumerate() {
            for _ in 0..*d {
                room.call(&format!("dial {lock} {i} +1"));
            }
        }
    }

    /// Plays act 1; returns the room with the warden's door open.
    fn act1() -> Hut {
        let mut r = Hut::new();
        assert_eq!(msg(&mut r, "tap woodbox"), "msg.too_dark");
        assert_eq!(msg(&mut r, "tap coat"), "msg.coat_matches");
        assert_eq!(msg(&mut r, "use matches lamp"), "msg.lamp_lit");
        turn_to(&mut r, "cup", &COUNTS);
        assert!(r.flag("cup_open"));
        assert_eq!(msg(&mut r, "tap cupboard"), "msg.kindling");
        assert_eq!(msg(&mut r, "tap woodbox"), "msg.wood");
        assert_eq!(msg(&mut r, "tap bucket"), "msg.bucket");
        assert_eq!(msg(&mut r, "use bucket stove"), "msg.bucket_cold");
        assert_eq!(msg(&mut r, "use matches stove"), "msg.stove_need");
        msg(&mut r, "use log stove");
        msg(&mut r, "use kindling stove");
        assert_eq!(msg(&mut r, "use matches stove"), "msg.stove_lit");
        assert_eq!(msg(&mut r, "use bucket stove"), "msg.bucket_melt");
        assert_eq!(r.act(), 1);
        assert_eq!(msg(&mut r, "use key door2"), "msg.door2_unlocked");
        assert_eq!(r.act(), 2);
        r
    }

    fn act2(mut r: Hut) -> Hut {
        // Clock: the bird's row, 16:25, is 4:25 on the dial (from 12:00).
        for _ in 0..4 {
            r.call("clock h +1");
        }
        for _ in 0..5 {
            r.call("clock m +1");
        }
        assert!(r.flag("clock_open"));
        assert_eq!(msg(&mut r, "tap cuckoo"), "msg.dkey");
        assert_eq!(msg(&mut r, "use dkey drawer"), "msg.drawer_open");
        assert_eq!(msg(&mut r, "use paper map"), "msg.map_overlay");
        assert_eq!(safe_code(), [6, 1, 9, 3]);
        turn_to(&mut r, "safe", &safe_code());
        assert_eq!(msg(&mut r, "tap safe"), "msg.fuse");
        if !r.flag("baro_open") {
            for _ in 0..BARO_START {
                r.call("baro -1");
            }
            assert_eq!(msg(&mut r, "tap baro_crank"), "msg.crank");
        }
        assert_eq!(r.act(), 3);
        r
    }

    fn solve_wires(r: &mut Hut) {
        for (i, want) in WIRE_SOLVED.iter().enumerate() {
            while r.wire[i] != *want && !wired(&r.wire) {
                r.call(&format!("wire {i}"));
            }
        }
    }

    fn act3(mut r: Hut) -> Hut {
        assert_eq!(msg(&mut r, "tune c +1"), "msg.radio_dead");
        msg(&mut r, "use fuse fuse_slot");
        if r.has("crank") {
            msg(&mut r, "use crank crank_slot");
        }
        solve_wires(&mut r);
        assert!(r.power());
        assert_eq!(msg(&mut r, "key s"), "msg.key_static");
        // 3150 → 2850 → 2847.
        for c in [
            "tune c -1",
            "tune c -1",
            "tune c -1",
            "tune f -1",
            "tune f -1",
            "tune f -1",
        ] {
            r.call(c);
        }
        assert_eq!(r.freq, ALTITUDE);
        assert!(r.flag("tuned"));
        for s in "llllll".chars() {
            r.call(&format!("key {s}"));
        }
        assert!(!r.done());
        for s in SIGNAL.chars() {
            r.call(&format!("key {s}"));
        }
        assert!(r.done());
        r
    }

    #[test]
    fn the_room_can_be_escaped() {
        let r = act3(act2(act1()));
        assert_eq!(r.solved(), [true; 9]);
        assert_eq!(r.halves(), 6);
        assert_eq!(r.inv, 0, "nothing is left over");
    }

    #[test]
    fn acts_two_and_three_in_another_order() {
        let mut r = act1();
        for _ in 0..(BARO_STEPS - BARO_START) {
            r.call("baro +1");
        }
        assert!(r.flag("baro_open"));
        msg(&mut r, "tap baro_crank");
        msg(&mut r, "use crank radio");
        solve_wires(&mut r);
        assert!(!r.power(), "no fuse yet");
        assert_eq!(r.act(), 2);
        let r = act3(act2(r));
        assert!(r.done());
    }

    #[test]
    fn the_cable_board_starts_open_and_has_a_solution() {
        assert!(!wired(&WIRE_START));
        assert!(wired(&WIRE_SOLVED));
        // Each tile of the solution matters where the path runs.
        for i in [0, 5, 6, 7, 2, 3, 4, 9, 14] {
            let mut w = WIRE_SOLVED;
            w[i] = (w[i] + 1) % 4;
            assert!(!wired(&w), "tile {i}");
        }
    }

    #[test]
    fn clues_are_consistent() {
        assert_eq!(COUNTS, [4, 7, 3]);
        assert_eq!(MAP_LABELS[0], ALTITUDE.to_string());
        let (_, weather, hpa, h, m) = LOG[LOG_BIRD];
        assert_eq!((weather, hpa, h, m), ("storm", 970, 16, 25));
        // The log's pressures are evenly spaced, as on the barometer's ring.
        for pair in LOG.windows(2) {
            assert_eq!(pair[0].2 - pair[1].2, 15);
        }
        assert!(clues_json().contains("\"altitude\":2847"));
    }

    #[test]
    fn score() {
        let mut r = Hut::new();
        assert_eq!(r.halves(), 6);
        r.call("time 240");
        assert_eq!(r.halves(), 6);
        r.call("time 241");
        assert_eq!(r.halves(), 5);
        r.call("time 277");
        assert_eq!(r.halves(), 4);
        let a = r.call("hint A");
        assert!(a.contains("\"puzzle\":1,\"level\":1"), "{a}");
        assert_eq!(r.halves(), 3);
        r.call("time 99999");
        assert_eq!(r.halves(), 2);
        // A fourth hint for the same puzzle does not exist.
        for _ in 0..5 {
            r.call("hint A");
        }
        assert_eq!(r.hints[0], 3);
    }

    #[test]
    fn hints_follow_the_view() {
        let mut r = act1();
        assert!(r.call("hintinfo clock").contains("\"puzzle\":4"));
        assert!(r.call("hintinfo baro").contains("\"puzzle\":6"));
        assert!(r.call("hintinfo map").contains("\"puzzle\":5"));
        assert!(r.call("hintinfo radio").contains("\"puzzle\":7"));
        assert!(r.call("hintinfo A").contains("\"puzzle\":4"));
        assert_eq!(r.hints, [0; 9]);
    }

    #[test]
    fn save_and_load() {
        let mut r = act2(act1());
        r.call("hint radio");
        r.call("time 754");
        r.call("wire 3");
        let saved = r.save();
        let mut other = Hut::new();
        assert!(other.call(&format!("load {saved}")).starts_with("{\"ok\":true"));
        assert_eq!(other, r);
        assert_eq!(Hut::load(&Hut::new().save()).unwrap(), Hut::new());
        for bad in [
            "",
            "1.zz",
            "2.0.0.000.0000.12.0.7.000000000000000.3150.-.000000000.0.0",
            "1.0.0.000.0000.13.0.7.000000000000000.3150.-.000000000.0.0",
        ] {
            assert!(Hut::load(bad).is_err(), "{bad}");
        }
        let done = act3(r);
        assert_eq!(Hut::load(&done.save()).unwrap(), done);
    }

    #[test]
    fn bad_commands_are_refused() {
        let mut r = Hut::new();
        for c in [
            "",
            "fly",
            "tap",
            "tap moon",
            "use matches lamp",
            "dial cup 9 +1",
            "dial cup 0 5",
            "wire 15",
            "clock x +1",
        ] {
            assert!(r.call(c).starts_with("{\"ok\":false"), "{c}");
        }
        assert_eq!(r, Hut::new());
    }
}
