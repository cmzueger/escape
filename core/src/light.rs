//! Gale Rock Light (medium): a lighthouse of four floors, ten puzzles.
//!
//! The keeper is gone and a ship is heading for the rocks: climb the tower
//! and relight the lamp. Floors are the views `L1` (store room) to `L4`
//! (lamp room); the hatches between them are the gates.
//!
//! Commands besides the common ones (see the crate):
//! - `dial <chest|hatch2|locker|bearing> <wheel> <+1|-1>`: a wheel of a lock
//!   or of the bearing counter (the chest's wheels show six symbols)
//! - `oil <fill|pour|empty> <a|b>`: the oil cans (a holds 5 litres, b 3;
//!   `pour a` pours a into b)
//! - `pin <0..7>`: sets or pulls a pin of the shutter drum
//! - `valve <a|b|c>`: opens a valve one step (each moves two gauges)

use crate::{bad, digits, digits_text, names_json, nums_json, step, strs_json};

pub const PAR_MINUTES: u32 = 25;

pub const FLAGS: [&str; 20] = [
    "got_magnet",
    "got_rope",
    "got_key",
    "hatch1_open",
    "chest_open",
    "got_chest",
    "got_matches",
    "hatch2_open",
    "locker_open",
    "got_locker",
    "hatch3_open",
    "got_gear_b",
    "got_gear_d",
    "can_taken",
    "oil_in",
    "wound",
    "tried_lamp",
    "seen_l2",
    "seen_l3",
    "seen_l4",
];

pub const ITEMS: [&str; 12] = [
    "magnet", "rope", "line", "key", "crank", "handle", "matches", "can", "gear_a", "gear_b", "gear_c",
    "gear_d",
];

/// The symbols on the sea chest's wheels.
pub const SYMBOLS: [&str; 6] = ["anchor", "star", "fish", "bell", "wheel", "wave"];
/// The framed photos in the keeper's room, left to right: year and the
/// symbol carved into the frame. Oldest first opens the chest.
pub const PHOTOS: [(u16, &str); 4] = [(1903, "fish"), (1871, "bell"), (1924, "anchor"), (1889, "wave")];

/// The tide table: day, then high, low, high, low water. The calendar's
/// ringed day and the plaque on the hatch (low water, moon) pick one time.
pub const TIDES: [(u8, [&str; 4]); 6] = [
    (14, ["0105", "0720", "1330", "1945"]),
    (15, ["0150", "0805", "1415", "2030"]),
    (16, ["0238", "0852", "1503", "2117"]),
    (17, ["0325", "0940", "1550", "2205"]),
    (18, ["0412", "1028", "1639", "2254"]),
    (19, ["0501", "1117", "1728", "2343"]),
];
pub const TODAY: u8 = 17;
/// The column the plaque means: the second low water (the one at night).
pub const TIDE_COLUMN: usize = 3;

/// The hoist of signal flags chalked on the slate, top to bottom, as the
/// digits the flag chart gives them.
pub const HOIST: [u8; 4] = [7, 3, 0, 5];

/// Where the ship shows in the window when lightning strikes (degrees).
pub const BEARING: u16 = 235;

/// The lamp's reservoir wants exactly this many litres.
pub const OIL_LITRES: u8 = 4;
const CAN_A: u8 = 5;
const CAN_B: u8 = 3;

/// Clockwork: gear radii (a, b, c, d), the fixed wheels at both ends, and
/// the distances from wheel to peg to peg to peg to wheel.
pub const GEAR_RADII: [u8; 4] = [20, 30, 40, 50];
pub const END_RADIUS: u8 = 30;
pub const PEG_GAPS: [u8; 4] = [70, 60, 70, 80];

/// The lights on the sea chart with their flash patterns (eight beats).
/// The drum turns the other way, so its pins are the pattern reversed.
pub const LIGHTS: [(&str, &str); 3] = [
    ("Gale Rock", "11010000"),
    ("Seal Point", "10100000"),
    ("Orme Head", "11100000"),
];

/// The burner's three gauges: where they start and where they must be.
const GAUGES_START: [u8; 3] = [3, 2, 1];
pub const GAUGE_GREEN: u8 = 2;
/// Which gauges each valve moves.
pub const VALVES: [[usize; 2]; 3] = [[0, 1], [1, 2], [0, 2]];

const FLAVOUR: [&str; 12] = [
    "crates",
    "ring",
    "ropes",
    "photos",
    "calendar",
    "bed",
    "stove",
    "telescope",
    "flaglocker",
    "lens",
    "sea",
    "tools",
];

#[derive(Clone, Debug, PartialEq)]
pub struct Light {
    flags: u32,
    inv: u16,
    chest: [u8; 4],
    hatch2: [u8; 4],
    locker: [u8; 4],
    bearing: [u8; 3],
    cans: [u8; 2],
    /// Litres in the can being carried.
    carried: u8,
    /// The gear on each peg: 0 none, 1..4 gear a..d.
    pegs: [u8; 3],
    pins: u8,
    gauges: [u8; 3],
    hints: [u8; 10],
    secs: u32,
    done: bool,
}

impl Default for Light {
    fn default() -> Self {
        Self::new()
    }
}

type Reply = Result<&'static str, String>;

fn index(list: &[&str], name: &str) -> Option<usize> {
    list.iter().position(|n| *n == name)
}

/// The chest's wheels when open: the frames' symbols, oldest photo first.
pub fn chest_code() -> [u8; 4] {
    let mut photos = PHOTOS;
    photos.sort();
    photos.map(|(_, symbol)| index(&SYMBOLS, symbol).expect("known symbol") as u8)
}

pub fn hatch2_code() -> [u8; 4] {
    let row = TIDES
        .iter()
        .find(|(day, _)| *day == TODAY)
        .expect("today is in the table");
    digits(row.1[TIDE_COLUMN], 9).expect("four digits")
}

fn bearing_digits() -> [u8; 3] {
    [
        (BEARING / 100) as u8,
        (BEARING / 10 % 10) as u8,
        (BEARING % 10) as u8,
    ]
}

/// The drum's pins for Gale Rock, as bits (pin 0 is bit 0).
pub fn drum_pins() -> u8 {
    LIGHTS[0]
        .1
        .bytes()
        .rev()
        .enumerate()
        .fold(0, |bits, (i, b)| bits | (u8::from(b == b'1') << i))
}

/// Whether the gears on the pegs carry the turn from wheel to wheel.
pub fn meshed(pegs: &[u8; 3]) -> bool {
    let radius = |peg: u8| (peg > 0).then(|| GEAR_RADII[usize::from(peg) - 1]);
    let (Some(a), Some(b), Some(c)) = (radius(pegs[0]), radius(pegs[1]), radius(pegs[2])) else {
        return false;
    };
    [END_RADIUS + a, a + b, b + c, c + END_RADIUS] == PEG_GAPS
}

impl Light {
    pub fn new() -> Self {
        Light {
            flags: 0,
            inv: 0,
            chest: [0; 4],
            hatch2: [0; 4],
            locker: [0; 4],
            bearing: [0, 9, 0],
            cans: [0, 0],
            carried: 0,
            pegs: [0; 3],
            pins: 0,
            gauges: GAUGES_START,
            hints: [0; 10],
            secs: 0,
            done: false,
        }
    }

    pub fn flag(&self, name: &str) -> bool {
        index(&FLAGS, name).is_some_and(|i| self.flags & (1 << i) != 0)
    }

    fn set(&mut self, name: &str) {
        self.flags |= 1 << index(&FLAGS, name).expect("known flag");
    }

    fn unset(&mut self, name: &str) {
        self.flags &= !(1 << index(&FLAGS, name).expect("known flag"));
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

    fn pressure(&self) -> bool {
        self.gauges == [GAUGE_GREEN; 3]
    }

    /// Oil in, clockwork wound, burner under pressure.
    fn ready(&self) -> bool {
        self.flag("oil_in") && self.flag("wound") && self.pressure()
    }

    /// Which of the ten puzzles are solved.
    pub fn solved(&self) -> [bool; 10] {
        [
            self.flag("hatch1_open"),
            self.flag("chest_open"),
            self.flag("hatch2_open"),
            self.flag("hatch3_open"),
            self.bearing == bearing_digits(),
            self.flag("oil_in"),
            self.flag("wound"),
            self.pins == drum_pins(),
            self.pressure(),
            self.done,
        ]
    }

    fn available(&self) -> [bool; 10] {
        let (f2, f3, f4) = (
            self.flag("hatch1_open"),
            self.flag("hatch2_open"),
            self.flag("hatch3_open"),
        );
        [true, f2, f2, f3, f3, f4, f4, f4, f4, f4]
    }

    /// The highest floor reached, 1..4.
    pub fn act(&self) -> u8 {
        1 + u8::from(self.flag("hatch1_open"))
            + u8::from(self.flag("hatch2_open"))
            + u8::from(self.flag("hatch3_open"))
    }

    pub fn halves(&self) -> u8 {
        crate::halves(&self.hints, self.secs, PAR_MINUTES)
    }

    fn hint_puzzle(&self, view: &str) -> (usize, &'static str) {
        let solved = self.solved();
        let available = self.available();
        let wanted: &[usize] = match view {
            "L1" => &[0, 5],
            "oil" => &[5],
            "L2" => &[2, 1],
            "chest" => &[1],
            "tide" | "hatch2" => &[2],
            "L3" => &[3, 4, 7],
            "flags" | "slate" | "locker" => &[3],
            "window" => &[4],
            "seachart" => &[7],
            "L4" => &[6, 8, 5, 7, 4, 9],
            "gears" => &[6],
            "drum" => &[7],
            "valves" => &[8],
            "bearing" => &[4],
            _ => &[],
        };
        crate::pick_hint(wanted, &available, &solved)
    }

    fn pick(&mut self, flag: &'static str, item: &'static str, msg: &'static str) -> &'static str {
        if self.flag(flag) {
            "lmsg.nothing"
        } else {
            self.set(flag);
            self.give(item);
            msg
        }
    }

    fn tap(&mut self, spot: &str) -> Reply {
        Ok(match spot {
            "magnet" => self.pick("got_magnet", "magnet", "lmsg.magnet"),
            "rope" => self.pick("got_rope", "rope", "lmsg.rope"),
            "gear_b" => self.pick("got_gear_b", "gear_b", "lmsg.gear"),
            "gear_d" => self.pick("got_gear_d", "gear_d", "lmsg.gear"),
            "matches" => self.pick("got_matches", "matches", "lmsg.matches"),
            "grating" => {
                if self.flag("got_key") {
                    "lmsg.nothing"
                } else {
                    "lmsg.grating"
                }
            }
            "hatch1" => {
                if self.flag("hatch1_open") {
                    ""
                } else {
                    "lmsg.hatch1_locked"
                }
            }
            "barrel" => "lmsg.barrel",
            "can" => {
                if self.flag("oil_in") || self.flag("can_taken") {
                    "lmsg.nothing"
                } else {
                    self.set("can_taken");
                    self.carried = self.cans[0];
                    self.cans[0] = 0;
                    self.give("can");
                    "lmsg.can"
                }
            }
            "chest" => {
                if !self.flag("chest_open") {
                    "lmsg.chest_locked"
                } else if self.flag("got_chest") {
                    "lmsg.nothing"
                } else {
                    self.set("got_chest");
                    self.give("crank");
                    self.give("gear_c");
                    "lmsg.chest_take"
                }
            }
            "hatch2" => {
                if self.flag("hatch2_open") {
                    ""
                } else {
                    "lmsg.hatch2_locked"
                }
            }
            "locker" => {
                if !self.flag("locker_open") {
                    "lmsg.locker_locked"
                } else if self.flag("got_locker") {
                    "lmsg.nothing"
                } else {
                    self.set("got_locker");
                    self.give("handle");
                    self.give("gear_a");
                    "lmsg.locker_take"
                }
            }
            "hatch3" => {
                if self.flag("hatch3_open") {
                    ""
                } else {
                    "lmsg.hatch3_stuck"
                }
            }
            "reservoir" => {
                if self.flag("oil_in") {
                    "lmsg.reservoir_full"
                } else {
                    "lmsg.reservoir"
                }
            }
            "lamp" => {
                if self.ready() {
                    "lmsg.lamp_ready"
                } else {
                    "lmsg.lamp_cold"
                }
            }
            "clockwork" | "crank_slot" => {
                if self.flag("wound") {
                    "lmsg.wound"
                } else {
                    "lmsg.clockwork"
                }
            }
            "peg0" | "peg1" | "peg2" => {
                let peg = usize::from(spot.as_bytes()[3] - b'0');
                if self.flag("wound") || self.pegs[peg] == 0 {
                    ""
                } else {
                    self.give(ITEMS[8 + usize::from(self.pegs[peg]) - 1]);
                    self.pegs[peg] = 0;
                    "lmsg.gear_off"
                }
            }
            other if FLAVOUR.contains(&other) => match other {
                "crates" => "lmsg.crates",
                "ring" => "lmsg.ring",
                "ropes" => "lmsg.ropes",
                "photos" => "lmsg.photos",
                "calendar" => "lmsg.calendar",
                "bed" => "lmsg.bed",
                "stove" => "lmsg.stove",
                "telescope" => "lmsg.telescope",
                "flaglocker" => "lmsg.flaglocker",
                "lens" => "lmsg.lens",
                "sea" => "lmsg.sea",
                _ => "lmsg.tools",
            },
            other => return Err(bad(other)),
        })
    }

    fn use_item(&mut self, item: &str, spot: &str) -> Reply {
        if !self.has(item) {
            return Err(format!("not carried: {item}"));
        }
        Ok(match (item, spot) {
            ("magnet", "rope") | ("rope", "magnet") => {
                self.take("magnet");
                self.take("rope");
                self.give("line");
                "lmsg.line"
            }
            ("magnet", "grating") => "lmsg.magnet_short",
            ("rope", "grating") => "lmsg.rope_bare",
            ("line", "grating") => {
                self.take("line");
                self.set("got_key");
                self.give("key");
                "lmsg.key"
            }
            ("key", "hatch1") => {
                self.take("key");
                self.set("hatch1_open");
                "lmsg.hatch1_open"
            }
            ("handle", "hatch3") => {
                self.take("handle");
                self.set("hatch3_open");
                "lmsg.hatch3_open"
            }
            ("gear_a" | "gear_b" | "gear_c" | "gear_d", "peg0" | "peg1" | "peg2") => {
                let peg = usize::from(spot.as_bytes()[3] - b'0');
                if self.pegs[peg] != 0 {
                    "lmsg.peg_taken"
                } else {
                    self.take(item);
                    self.pegs[peg] = item.as_bytes()[5] - b'a' + 1;
                    "lmsg.gear_on"
                }
            }
            ("crank", "crank_slot" | "clockwork") => {
                if meshed(&self.pegs) {
                    self.take("crank");
                    self.set("wound");
                    "lmsg.wind"
                } else {
                    "lmsg.crank_free"
                }
            }
            ("can", "reservoir") => {
                self.take("can");
                self.unset("can_taken");
                if self.carried == OIL_LITRES {
                    self.set("oil_in");
                    self.carried = 0;
                    "lmsg.oil_in"
                } else {
                    // Back to the store room, empty.
                    let msg = if self.carried < OIL_LITRES {
                        "lmsg.oil_little"
                    } else {
                        "lmsg.oil_much"
                    };
                    self.carried = 0;
                    msg
                }
            }
            ("can", "barrel") => {
                self.take("can");
                self.unset("can_taken");
                self.cans[0] = self.carried;
                self.carried = 0;
                "lmsg.can_back"
            }
            ("matches", "lamp") => {
                if !self.ready() {
                    "lmsg.lamp_not_ready"
                } else if self.pins != drum_pins() || self.bearing != bearing_digits() {
                    self.set("tried_lamp");
                    "lmsg.lamp_wrong"
                } else {
                    self.take("matches");
                    self.done = true;
                    "lmsg.lamp_lit"
                }
            }
            ("matches", "stove") => "lmsg.stove",
            _ => "lmsg.no_use",
        })
    }

    fn dial(&mut self, lock: &str, wheel: Option<&str>, by: i8) -> Reply {
        let wheel: usize = wheel.and_then(|w| w.parse().ok()).ok_or_else(|| bad("wheel"))?;
        let turn = |d: &mut u8, size: i8| *d = ((*d as i8 + by).rem_euclid(size)) as u8;
        match lock {
            "chest" if self.flag("chest_open") => Ok(""),
            "chest" => {
                turn(
                    self.chest.get_mut(wheel).ok_or_else(|| bad("wheel"))?,
                    SYMBOLS.len() as i8,
                );
                if self.chest == chest_code() {
                    self.set("chest_open");
                    return Ok("lmsg.chest_open");
                }
                Ok("")
            }
            "hatch2" if self.flag("hatch2_open") => Ok(""),
            "hatch2" => {
                turn(self.hatch2.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 10);
                if self.hatch2 == hatch2_code() {
                    self.set("hatch2_open");
                    return Ok("lmsg.hatch2_open");
                }
                Ok("")
            }
            "locker" if self.flag("locker_open") => Ok(""),
            "locker" => {
                turn(self.locker.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 10);
                if self.locker == HOIST {
                    self.set("locker_open");
                    return Ok("lmsg.locker_open");
                }
                Ok("")
            }
            "bearing" => {
                // The first wheel only goes to 3 (0 to 359 degrees).
                let size = if wheel == 0 { 4 } else { 10 };
                turn(self.bearing.get_mut(wheel).ok_or_else(|| bad("wheel"))?, size);
                Ok("")
            }
            other => Err(bad(other)),
        }
    }

    fn oil(&mut self, what: Option<&str>, can: Option<&str>) -> Reply {
        let i = match can {
            Some("a") => 0,
            Some("b") => 1,
            _ => return Err(bad("can")),
        };
        if i == 0 && self.flag("can_taken") || self.flag("oil_in") {
            return Ok("lmsg.nothing");
        }
        let size = [CAN_A, CAN_B];
        match what {
            Some("fill") => self.cans[i] = size[i],
            Some("empty") => self.cans[i] = 0,
            Some("pour") => {
                let j = 1 - i;
                if j == 0 && self.flag("can_taken") {
                    return Ok("lmsg.nothing");
                }
                let moved = self.cans[i].min(size[j] - self.cans[j]);
                self.cans[i] -= moved;
                self.cans[j] += moved;
            }
            _ => return Err(bad("oil")),
        }
        Ok("")
    }

    fn pin(&mut self, pin: Option<&str>) -> Reply {
        let pin: u8 = pin
            .and_then(|p| p.parse().ok())
            .filter(|p| *p < 8)
            .ok_or_else(|| bad("pin"))?;
        self.pins ^= 1 << pin;
        Ok("")
    }

    fn valve(&mut self, valve: Option<&str>) -> Reply {
        let v = match valve {
            Some("a") => 0,
            Some("b") => 1,
            Some("c") => 2,
            _ => return Err(bad("valve")),
        };
        if self.pressure() {
            return Ok("");
        }
        for g in VALVES[v] {
            self.gauges[g] = (self.gauges[g] + 1) % 4;
        }
        Ok(if self.pressure() { "lmsg.pressure" } else { "" })
    }

    pub fn save(&self) -> String {
        format!(
            "L1.{:x}.{:x}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}",
            self.flags,
            self.inv,
            digits_text(&self.chest),
            digits_text(&self.hatch2),
            digits_text(&self.locker),
            digits_text(&self.bearing),
            digits_text(&self.cans),
            self.carried,
            digits_text(&self.pegs),
            self.pins,
            digits_text(&self.gauges),
            digits_text(&self.hints),
            self.secs,
            u8::from(self.done)
        )
    }

    pub fn load(text: &str) -> Result<Light, String> {
        let err = || "bad save".to_string();
        let p: Vec<&str> = text.trim().split('.').collect();
        if p.len() != 15 || p[0] != "L1" {
            return Err(err());
        }
        let room = Light {
            flags: u32::from_str_radix(p[1], 16)
                .ok()
                .filter(|f| *f < 1 << FLAGS.len())
                .ok_or_else(err)?,
            inv: u16::from_str_radix(p[2], 16)
                .ok()
                .filter(|f| *f < 1 << ITEMS.len())
                .ok_or_else(err)?,
            chest: digits(p[3], 5).ok_or_else(err)?,
            hatch2: digits(p[4], 9).ok_or_else(err)?,
            locker: digits(p[5], 9).ok_or_else(err)?,
            bearing: digits(p[6], 9).filter(|b: &[u8; 3]| b[0] < 4).ok_or_else(err)?,
            cans: digits(p[7], CAN_A)
                .filter(|c: &[u8; 2]| c[1] <= CAN_B)
                .ok_or_else(err)?,
            carried: p[8].parse().ok().filter(|c| *c <= CAN_A).ok_or_else(err)?,
            pegs: digits(p[9], 4).ok_or_else(err)?,
            pins: p[10].parse().map_err(|_| err())?,
            gauges: digits(p[11], 3).ok_or_else(err)?,
            hints: digits(p[12], 3).ok_or_else(err)?,
            secs: p[13].parse().map_err(|_| err())?,
            done: p[14] == "1",
        };
        Ok(room)
    }

    pub fn state_json(&self) -> String {
        let solved = self.solved().map(|b| b.to_string()).join(",");
        let pins = (0..8)
            .map(|i| u8::from(self.pins & (1 << i) != 0).to_string())
            .collect::<Vec<_>>()
            .join(",");
        format!(
            "{{\"room\":\"light\",\"flags\":[{}],\"inv\":[{}],\"chest\":[{}],\"hatch2\":[{}],\"locker\":[{}],\"bearing\":[{}],\"cans\":[{}],\"carried\":{},\"pegs\":[{}],\"meshed\":{},\"pins\":[{}],\"gauges\":[{}],\"pressure\":{},\"ready\":{},\"hints\":[{}],\"solved\":[{}],\"act\":{},\"secs\":{},\"done\":{},\"halves\":{}}}",
            names_json(&FLAGS, self.flags),
            names_json(&ITEMS, u32::from(self.inv)),
            nums_json(&self.chest),
            nums_json(&self.hatch2),
            nums_json(&self.locker),
            nums_json(&self.bearing),
            nums_json(&self.cans),
            self.carried,
            nums_json(&self.pegs),
            meshed(&self.pegs),
            pins,
            nums_json(&self.gauges),
            self.pressure(),
            self.ready(),
            nums_json(&self.hints),
            solved,
            self.act(),
            self.secs,
            self.done,
            self.halves()
        )
    }

    /// Runs one command and returns the JSON answer.
    pub fn call(&mut self, command: &str) -> String {
        let mut w = command.split_whitespace();
        let result: Reply = match w.next() {
            Some("new") => {
                *self = Light::new();
                Ok("")
            }
            Some("state") => Ok(""),
            Some("clues") => return clues_json(),
            Some("save") => return format!("{{\"ok\":true,\"save\":\"{}\"}}", self.save()),
            Some("load") => Light::load(w.next().unwrap_or("")).map(|room| {
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
            Some("oil") => {
                let what = w.next();
                self.oil(what, w.next())
            }
            Some("pin") => self.pin(w.next()),
            Some("valve") => self.valve(w.next()),
            other => Err(bad(other.unwrap_or("empty"))),
        };
        match result {
            Ok(msg) => format!(
                "{{\"ok\":true,\"msg\":\"{msg}\",\"state\":{}}}",
                self.state_json()
            ),
            Err(e) => format!("{{\"ok\":false,\"error\":\"{}\"}}", e.replace(['"', '\\'], "'")),
        }
    }
}

/// What the lighthouse's pictures must show (the client draws from this).
pub fn clues_json() -> String {
    let photos = PHOTOS
        .iter()
        .map(|(year, symbol)| format!("{{\"year\":{year},\"symbol\":\"{symbol}\"}}"))
        .collect::<Vec<_>>();
    let tides = TIDES
        .iter()
        .map(|(day, times)| format!("{{\"day\":{day},\"times\":[{}]}}", strs_json(times)))
        .collect::<Vec<_>>();
    let lights = LIGHTS
        .iter()
        .map(|(name, pattern)| format!("{{\"name\":\"{name}\",\"pattern\":\"{pattern}\"}}"))
        .collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"symbols\":[{}],\"photos\":[{}],\"tides\":[{}],\"today\":{},\"tide_column\":{},\"hoist\":[{}],\"bearing\":{},\"oil_litres\":{},\"can_sizes\":[{},{}],\"gear_radii\":[{}],\"end_radius\":{},\"peg_gaps\":[{}],\"lights\":[{}],\"gauge_green\":{},\"valves\":[{}]}}",
        strs_json(&SYMBOLS),
        photos.join(","),
        tides.join(","),
        TODAY,
        TIDE_COLUMN,
        nums_json(&HOIST),
        BEARING,
        OIL_LITRES,
        CAN_A,
        CAN_B,
        nums_json(&GEAR_RADII),
        END_RADIUS,
        nums_json(&PEG_GAPS),
        lights.join(","),
        GAUGE_GREEN,
        VALVES.iter().map(|v| format!("[{},{}]", v[0], v[1])).collect::<Vec<_>>().join(",")
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn msg(room: &mut Light, command: &str) -> String {
        let answer = room.call(command);
        assert!(answer.starts_with("{\"ok\":true"), "{command}: {answer}");
        let start = answer.find("\"msg\":\"").map(|i| i + 7).unwrap_or(0);
        answer[start..].split('"').next().unwrap().to_string()
    }

    fn turn_to(room: &mut Light, lock: &str, from: &[u8], code: &[u8], size: u8) {
        for (i, d) in code.iter().enumerate() {
            for _ in 0..(*d + size - from[i]) % size {
                room.call(&format!("dial {lock} {i} +1"));
            }
        }
    }

    fn floor1() -> Light {
        let mut r = Light::new();
        assert_eq!(msg(&mut r, "tap grating"), "lmsg.grating");
        msg(&mut r, "tap magnet");
        assert_eq!(msg(&mut r, "use magnet grating"), "lmsg.magnet_short");
        msg(&mut r, "tap rope");
        assert_eq!(msg(&mut r, "use rope magnet"), "lmsg.line");
        assert_eq!(msg(&mut r, "use line grating"), "lmsg.key");
        assert_eq!(msg(&mut r, "use key hatch1"), "lmsg.hatch1_open");
        assert_eq!(msg(&mut r, "tap gear_b"), "lmsg.gear");
        r
    }

    fn floor2(mut r: Light) -> Light {
        assert_eq!(chest_code(), [3, 5, 2, 0]);
        turn_to(&mut r, "chest", &[0; 4], &chest_code(), 6);
        assert!(r.flag("chest_open"));
        assert_eq!(msg(&mut r, "tap chest"), "lmsg.chest_take");
        msg(&mut r, "tap matches");
        assert_eq!(hatch2_code(), [2, 2, 0, 5]);
        turn_to(&mut r, "hatch2", &[0; 4], &hatch2_code(), 10);
        assert!(r.flag("hatch2_open"));
        r
    }

    fn floor3(mut r: Light) -> Light {
        turn_to(&mut r, "locker", &[0; 4], &HOIST, 10);
        assert_eq!(msg(&mut r, "tap locker"), "lmsg.locker_take");
        assert_eq!(msg(&mut r, "use handle hatch3"), "lmsg.hatch3_open");
        assert_eq!(r.act(), 4);
        r
    }

    /// 4 litres in the 5 litre can: fill a, pour into b, empty b, pour,
    /// fill a, pour.
    fn measure(r: &mut Light) {
        for c in [
            "oil fill a",
            "oil pour a",
            "oil empty b",
            "oil pour a",
            "oil fill a",
            "oil pour a",
        ] {
            r.call(c);
        }
        assert_eq!(r.cans, [4, 3]);
    }

    fn floor4(mut r: Light) -> Light {
        assert_eq!(msg(&mut r, "use matches lamp"), "lmsg.lamp_not_ready");
        // Oil: a wrong amount first.
        r.call("oil fill a");
        msg(&mut r, "tap can");
        assert_eq!(msg(&mut r, "use can reservoir"), "lmsg.oil_much");
        assert!(!r.has("can") && r.cans == [0, 0]);
        measure(&mut r);
        msg(&mut r, "tap can");
        assert_eq!(msg(&mut r, "use can reservoir"), "lmsg.oil_in");
        // Clockwork: a wrong order does not turn.
        msg(&mut r, "tap gear_d");
        msg(&mut r, "use gear_a peg0");
        assert_eq!(msg(&mut r, "use gear_c peg0"), "lmsg.peg_taken");
        assert_eq!(msg(&mut r, "use crank crank_slot"), "lmsg.crank_free");
        assert_eq!(msg(&mut r, "tap peg0"), "lmsg.gear_off");
        msg(&mut r, "use gear_c peg0");
        msg(&mut r, "use gear_a peg1");
        msg(&mut r, "use gear_d peg2");
        assert_eq!(msg(&mut r, "use crank crank_slot"), "lmsg.wind");
        assert!(r.has("gear_b"), "one gear is left over");
        // Pressure: a once, b three times, c twice.
        for c in ["valve a", "valve b", "valve b", "valve b", "valve c"] {
            assert_eq!(msg(&mut r, c), "");
        }
        assert_eq!(msg(&mut r, "valve c"), "lmsg.pressure");
        assert_eq!(msg(&mut r, "use matches lamp"), "lmsg.lamp_wrong");
        // Drum: Gale Rock's pattern, reversed.
        assert_eq!(drum_pins(), 0b1101_0000);
        for pin in [4, 6, 7] {
            r.call(&format!("pin {pin}"));
        }
        assert_eq!(msg(&mut r, "use matches lamp"), "lmsg.lamp_wrong");
        turn_to(&mut r, "bearing", &[0, 9, 0], &[2, 3, 5], 10);
        assert_eq!(r.solved()[..9], [true; 9]);
        assert_eq!(msg(&mut r, "use matches lamp"), "lmsg.lamp_lit");
        assert!(r.done());
        r
    }

    #[test]
    fn the_lamp_can_be_lit() {
        let r = floor4(floor3(floor2(floor1())));
        assert_eq!(r.solved(), [true; 10]);
        assert_eq!(r.halves(), 6);
        assert_eq!(names_json(&ITEMS, u32::from(r.inv)), "\"gear_b\"");
    }

    #[test]
    fn only_one_gear_train_meshes() {
        let mut good = 0;
        for a in 0..=4u8 {
            for b in 0..=4u8 {
                for c in 0..=4u8 {
                    if meshed(&[a, b, c]) {
                        good += 1;
                        assert_eq!([a, b, c], [3, 1, 4]);
                    }
                }
            }
        }
        assert_eq!(good, 1);
    }

    #[test]
    fn clues_are_consistent() {
        assert_eq!(LIGHTS[0].0, "Gale Rock");
        // No light on the chart has the drum's reversed pattern by itself.
        for (_, pattern) in LIGHTS {
            assert_eq!(pattern.len(), 8);
            assert_ne!(pattern.chars().rev().collect::<String>(), pattern);
        }
        // The hoist's digits differ, so every flag is looked up.
        let mut hoist = HOIST.to_vec();
        hoist.dedup();
        assert_eq!(hoist.len(), 4);
        assert!(clues_json().contains("\"bearing\":235"));
        // The valves can reach green from the start (a, b three times, c twice).
        let mut g = GAUGES_START;
        for (v, times) in [(0, 1), (1, 3), (2, 2)] {
            for _ in 0..times {
                for i in VALVES[v] {
                    g[i] = (g[i] + 1) % 4;
                }
            }
        }
        assert_eq!(g, [GAUGE_GREEN; 3]);
    }

    #[test]
    fn hints_follow_the_view() {
        let mut r = floor3(floor2(floor1()));
        assert!(r.call("hintinfo gears").contains("\"puzzle\":7"));
        assert!(r.call("hintinfo window").contains("\"puzzle\":5"));
        assert!(r.call("hintinfo oil").contains("\"puzzle\":6"));
        assert!(r.call("hintinfo L1").contains("\"puzzle\":6"));
        assert!(r.call("hint drum").contains("\"puzzle\":8,\"level\":1"));
        assert_eq!(r.halves(), 5);
    }

    #[test]
    fn save_and_load() {
        let mut r = floor3(floor2(floor1()));
        measure(&mut r);
        r.call("tap can");
        r.call("pin 3");
        r.call("time 612");
        let mut other = Light::new();
        assert!(other
            .call(&format!("load {}", r.save()))
            .starts_with("{\"ok\":true"));
        assert_eq!(other, r);
        assert_eq!(Light::load(&Light::new().save()).unwrap(), Light::new());
        assert!(Light::load("1.0.0").is_err());
        assert!(Light::load(&crate::hut::Hut::new().save()).is_err());
        let done = floor4({
            let mut r = r;
            r.call("use can barrel");
            r.call("oil empty a");
            r.call("oil empty b");
            r.call("pin 3");
            r
        });
        assert_eq!(Light::load(&done.save()).unwrap(), done);
    }

    #[test]
    fn bad_commands_are_refused() {
        let mut r = Light::new();
        for c in [
            "",
            "fly",
            "tap",
            "tap moon",
            "use key hatch1",
            "dial chest 9 +1",
            "pin 8",
            "valve d",
            "oil boil a",
        ] {
            assert!(r.call(c).starts_with("{\"ok\":false"), "{c}");
        }
        assert_eq!(r, Light::new());
    }
}
