//! Col Sidereal (hard): an observatory on a pass, ten layered puzzles.
//!
//! The astronomer is gone and the door's time lock only opens once the
//! night's observation is recorded. Views: the study (`S1` desk wall, `S2`
//! library, `S3` chart wall) and the dome above (`D1` telescope, `D2` dome
//! wheel, `D3` orrery).
//!
//! Commands besides the common ones (see the crate):
//! - `dial <drawer|cabinet|box|door> <wheel> <+1|-1>`: a wheel of a lock
//!   (the drawer's wheels show the eight constellations)
//! - `lamp <0..5>`: a switch of the switchboard (flips its lamp and both
//!   neighbours)
//! - `dome <+1|-1>`: turns the dome by one of its eight positions
//! - `planet <0..2> <+1|-1>`: moves a planet of the orrery
//! - `weight <0..4>`: hangs a counterweight on the bar or takes it off
//! - `ra <+1|-1>`, `dec <+1|-1>`: the telescope's setting circles
//! - `plani <+1|-1>`: turns the planisphere's disc (a tool, not a lock)

use crate::{bad, digits, digits_text, names_json, nums_json, step, strs_json};

pub const PAR_MINUTES: u32 = 30;

pub const FLAGS: [&str; 15] = [
    "drawer_open",
    "got_drawer",
    "page_in",
    "gate_open",
    "cabinet_open",
    "got_cabinet",
    "fuse_in",
    "power",
    "box_open",
    "got_box",
    "atlas_open",
    "orrery_open",
    "got_weights",
    "eye_on",
    "weights_on",
];
/// One more, after the others so that old numbering never shifts.
const EXPOSED: &str = "exposed";

pub const ITEMS: [&str; 7] = ["gkey", "page", "eyepiece", "fuse", "plate", "akey", "weights"];

/// The eight constellations, named by the shape their stars draw. Their
/// order is the order of the plaques around the dome (position 0..7); the
/// dome's rail shows the hour `3 * position` under each.
pub const SHAPES: [&str; 8] = ["arc", "w", "kite", "hook", "cross", "y", "tri", "arrow"];
/// The digit that moonlight shows on each plaque.
pub const PLAQUE_DIGITS: [u8; 8] = [4, 9, 1, 6, 3, 8, 2, 7];
/// Declination of each constellation in the atlas (its right ascension is
/// the hour under its plaque).
pub const DECLINATIONS: [i8; 8] = [40, 60, -10, 20, -30, 10, 50, 0];

/// The books on the shelf, left to right: colour and the constellation on
/// the spine. The note over the desk names three colours.
pub const BOOKS: [(&str, &str); 8] = [
    ("blue", "w"),
    ("orange", "kite"),
    ("red", "hook"),
    ("grey", "arrow"),
    ("green", "tri"),
    ("violet", "cross"),
    ("white", "y"),
    ("yellow", "arc"),
];
pub const NOTE_COLOURS: [&str; 3] = ["green", "red", "white"];

/// The two stopped clocks (hour, minute): sun time and star time. The
/// cabinet's plaque asks for sun time minus star time.
pub const SUN_CLOCK: (u8, u8) = (10, 25);
pub const STAR_CLOCK: (u8, u8) = (4, 50);

/// The switchboard's six lamps at the start (bit i = lamp i).
const LAMPS_START: u8 = 0b01_1000;
const LAMPS_ALL: u8 = 0b11_1111;

/// The comet's path on the wall map, through four constellations.
pub const PATH: [&str; 4] = ["kite", "y", "arc", "cross"];

/// The notebook's second page: each planet with a digit; the plaque with
/// that digit names the constellation the planet stands in.
pub const PLANETS: [(&str, u8); 3] = [("red", 6), ("ringed", 2), ("grey", 7)];
const PLANETS_START: [u8; 3] = [1, 4, 2];

/// The counterweights, and what hangs on the other end of the telescope.
pub const WEIGHTS: [u8; 5] = [4, 7, 9, 12, 15];
pub const EYEPIECE_WEIGHT: u8 = 8;
pub const CAMERA_WEIGHT: u8 = 15;

/// Tonight's observation in the notebook: day, month, hour.
pub const TONIGHT: (u8, u8, u8) = (14, 11, 23);
/// The planisphere's disc: the constellation at each eighth of a turn,
/// clockwise from its zero mark. The disc turns in 24 steps of one hour.
pub const DISC: [&str; 8] = ["tri", "hook", "w", "arrow", "arc", "cross", "y", "kite"];
const PLANI_START: u8 = 5;
const DOME_START: u8 = 6;
const DEC_START: u8 = 3;

/// The four constellations beside the comet on the photograph.
pub const PHOTO: [&str; 4] = ["w", "tri", "hook", "arrow"];

const FLAVOUR: [&str; 11] = [
    "note", "lamp", "chair", "globe", "rug", "ladder", "stool", "slit", "books", "mapcase", "plaques",
];

#[derive(Clone, Debug, PartialEq)]
pub struct Obs {
    flags: u32,
    inv: u16,
    drawer: [u8; 3],
    cabinet: [u8; 4],
    box_lock: [u8; 4],
    door: [u8; 4],
    lamps: u8,
    dome: u8,
    planets: [u8; 3],
    weights: u8,
    ra: u8,
    dec: u8,
    plani: u8,
    hints: [u8; 10],
    secs: u32,
    done: bool,
}

impl Default for Obs {
    fn default() -> Self {
        Self::new()
    }
}

type Reply = Result<&'static str, String>;

fn index(list: &[&str], name: &str) -> Option<usize> {
    list.iter().position(|n| *n == name)
}

fn shape(name: &str) -> usize {
    index(&SHAPES, name).expect("known constellation")
}

fn digits_of(shapes: &[&str; 4]) -> [u8; 4] {
    shapes.map(|s| PLAQUE_DIGITS[shape(s)])
}

/// The drawer's wheels: the constellations on the books of the note's colours.
pub fn drawer_code() -> [u8; 3] {
    NOTE_COLOURS.map(|colour| {
        let (_, on_spine) = BOOKS
            .iter()
            .find(|(c, _)| *c == colour)
            .expect("a book of that colour");
        shape(on_spine) as u8
    })
}

/// Sun time minus star time, as hhmm.
pub fn cabinet_code() -> [u8; 4] {
    let minutes = (u32::from(SUN_CLOCK.0) * 60 + u32::from(SUN_CLOCK.1) + 24 * 60
        - u32::from(STAR_CLOCK.0) * 60
        - u32::from(STAR_CLOCK.1))
        % (24 * 60);
    let (h, m) = (minutes / 60, minutes % 60);
    [(h / 10) as u8, (h % 10) as u8, (m / 10) as u8, (m % 10) as u8]
}

pub fn box_code() -> [u8; 4] {
    digits_of(&PATH)
}

pub fn door_code() -> [u8; 4] {
    digits_of(&PHOTO)
}

/// Where each planet must stand: the plaque with its digit.
pub fn planet_places() -> [u8; 3] {
    PLANETS.map(|(_, digit)| {
        PLAQUE_DIGITS
            .iter()
            .position(|d| *d == digit)
            .expect("a plaque with that digit") as u8
    })
}

/// The planisphere's turn (0..24) that puts tonight's hour on tonight's month.
pub fn plani_turn() -> u8 {
    // Months stand every 30 degrees on the fixed ring, hours every 15 on the disc.
    let month_angle = (i32::from(TONIGHT.1) - 1) * 30;
    let hour_angle = i32::from(TONIGHT.2) * 15;
    ((month_angle - hour_angle).rem_euclid(360) / 15) as u8
}

/// The constellation the planisphere shows at its top mark for a turn.
pub fn plani_shows(turn: u8) -> Option<usize> {
    // Disc entry k stands at k * 45 degrees; the top is at 0.
    let at_top = (360 - i32::from(turn) * 15).rem_euclid(360);
    (at_top % 45 == 0).then(|| shape(DISC[(at_top / 45) as usize]))
}

/// Tonight's target: the constellation on the meridian.
pub fn target() -> usize {
    plani_shows(plani_turn()).expect("tonight's turn shows a constellation")
}

fn dec_degrees(step: u8) -> i8 {
    -30 + 10 * step as i8
}

impl Obs {
    pub fn new() -> Self {
        Obs {
            flags: 0,
            inv: 0,
            drawer: [0; 3],
            cabinet: [0; 4],
            box_lock: [0; 4],
            door: [0; 4],
            lamps: LAMPS_START,
            dome: DOME_START,
            planets: PLANETS_START,
            weights: 0,
            ra: 0,
            dec: DEC_START,
            plani: PLANI_START,
            hints: [0; 10],
            secs: 0,
            done: false,
        }
    }

    fn bit(name: &str) -> u32 {
        if name == EXPOSED {
            1 << FLAGS.len()
        } else {
            1 << index(&FLAGS, name).expect("known flag")
        }
    }

    pub fn flag(&self, name: &str) -> bool {
        self.flags & Self::bit(name) != 0
    }

    fn set(&mut self, name: &str) {
        self.flags |= Self::bit(name);
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

    fn weight_sum(&self) -> u8 {
        (0..WEIGHTS.len())
            .filter(|i| self.weights & (1 << i) != 0)
            .map(|i| WEIGHTS[i])
            .sum()
    }

    fn balanced(&self) -> bool {
        self.flag("eye_on") && self.flag("weights_on") && self.weight_sum() == EYEPIECE_WEIGHT + CAMERA_WEIGHT
    }

    fn circles(&self) -> bool {
        usize::from(self.ra) == target() * 3 && dec_degrees(self.dec) == DECLINATIONS[target()]
    }

    fn slit_right(&self) -> bool {
        usize::from(self.dome) == target()
    }

    /// The plaque the moonbeam falls on: across from the slit.
    pub fn lit_plaque(&self) -> u8 {
        (self.dome + 4) % 8
    }

    pub fn solved(&self) -> [bool; 10] {
        [
            self.flag("drawer_open"),
            self.flag("cabinet_open"),
            self.flag("power"),
            self.flag("box_open"),
            self.flag("orrery_open"),
            self.balanced(),
            self.circles(),
            self.slit_right(),
            self.flag(EXPOSED),
            self.done,
        ]
    }

    fn available(&self) -> [bool; 10] {
        let dome = self.flag("gate_open");
        let turning = dome && self.flag("power");
        let scope = self.flag("box_open");
        [
            true,
            true,
            self.flag("cabinet_open"),
            turning,
            turning && self.flag("page_in"),
            self.flag("got_weights"),
            scope && self.flag("atlas_open"),
            scope && self.flag("atlas_open"),
            scope,
            self.flag(EXPOSED),
        ]
    }

    /// 1 the study, 2 the dome reached, 3 the dome turns, 4 the photograph taken.
    pub fn act(&self) -> u8 {
        1 + u8::from(self.flag("gate_open")) + u8::from(self.flag("power")) + u8::from(self.flag(EXPOSED))
    }

    pub fn halves(&self) -> u8 {
        crate::halves(&self.hints, self.secs, PAR_MINUTES)
    }

    fn hint_puzzle(&self, view: &str) -> (usize, &'static str) {
        let solved = self.solved();
        let available = self.available();
        let wanted: &[usize] = match view {
            "S1" => &[0, 1, 9],
            "notes" => &[0, 4, 6],
            "drawer" | "books" => &[0],
            "clocks" | "cabinet" => &[1],
            "S2" => &[0, 1, 6],
            "S3" => &[2, 3],
            "board" => &[2],
            "skymap" | "box" => &[3],
            "D1" => &[5, 6, 8],
            "D2" => &[3, 7],
            "D3" => &[4, 3],
            "orrery" => &[4],
            "balance" => &[5],
            "plani" | "atlas" => &[6, 7],
            "scope" => &[5, 6, 7, 8],
            "plate" | "door" => &[9],
            _ => &[],
        };
        crate::pick_hint(wanted, &available, &solved)
    }

    fn tap(&mut self, spot: &str) -> Reply {
        Ok(match spot {
            "drawer" => {
                if !self.flag("drawer_open") {
                    "omsg.drawer_locked"
                } else if self.flag("got_drawer") {
                    "omsg.nothing"
                } else {
                    self.set("got_drawer");
                    self.give("gkey");
                    self.give("page");
                    "omsg.drawer_take"
                }
            }
            "notebook" => {
                if self.flag("page_in") {
                    "omsg.notebook_whole"
                } else {
                    "omsg.notebook_torn"
                }
            }
            "gate" => {
                if self.flag("gate_open") {
                    ""
                } else {
                    "omsg.gate_locked"
                }
            }
            "cabinet" => {
                if !self.flag("cabinet_open") {
                    "omsg.cabinet_locked"
                } else if self.flag("got_cabinet") {
                    "omsg.nothing"
                } else {
                    self.set("got_cabinet");
                    self.give("eyepiece");
                    self.give("fuse");
                    "omsg.cabinet_take"
                }
            }
            "atlas" => {
                if self.flag("atlas_open") {
                    ""
                } else {
                    "omsg.atlas_locked"
                }
            }
            "fuse_slot" => {
                if self.flag("fuse_in") {
                    "omsg.nothing"
                } else {
                    "omsg.fuse_missing"
                }
            }
            "wheel" => {
                if self.flag("power") {
                    "omsg.wheel"
                } else {
                    "omsg.wheel_dead"
                }
            }
            "box" => {
                if !self.flag("box_open") {
                    "omsg.box_locked"
                } else if self.flag("got_box") {
                    "omsg.nothing"
                } else {
                    self.set("got_box");
                    self.give("plate");
                    self.give("akey");
                    "omsg.box_take"
                }
            }
            "orrery_drawer" => {
                if !self.flag("orrery_open") {
                    "omsg.orrery_shut"
                } else if self.flag("got_weights") {
                    "omsg.nothing"
                } else {
                    self.set("got_weights");
                    self.give("weights");
                    "omsg.weights"
                }
            }
            "eyepiece" => {
                if !self.flag("eye_on") {
                    "omsg.eye_missing"
                } else if !self.balanced() {
                    "omsg.scope_sags"
                } else if !self.slit_right() {
                    "omsg.see_dome"
                } else if !self.circles() {
                    "omsg.see_stars"
                } else {
                    "omsg.see_comet"
                }
            }
            "bar" => {
                if self.flag("weights_on") {
                    ""
                } else {
                    "omsg.bar_empty"
                }
            }
            "camera" => {
                if self.flag(EXPOSED) {
                    ""
                } else {
                    "omsg.camera_empty"
                }
            }
            "door" => "omsg.door_locked",
            other if FLAVOUR.contains(&other) => match other {
                "note" => "omsg.note",
                "lamp" => "omsg.lamp",
                "chair" => "omsg.chair",
                "globe" => "omsg.globe",
                "rug" => "omsg.rug",
                "ladder" => "omsg.ladder",
                "stool" => "omsg.stool",
                "slit" => "omsg.slit",
                "books" => "omsg.books",
                "mapcase" => "omsg.mapcase",
                _ => "omsg.plaques",
            },
            other => return Err(bad(other)),
        })
    }

    fn use_item(&mut self, item: &str, spot: &str) -> Reply {
        if !self.has(item) {
            return Err(format!("not carried: {item}"));
        }
        Ok(match (item, spot) {
            ("gkey", "gate") => {
                self.take("gkey");
                self.set("gate_open");
                "omsg.gate_open"
            }
            ("page", "notebook") => {
                self.take("page");
                self.set("page_in");
                "omsg.page_in"
            }
            ("fuse", "fuse_slot" | "board") => {
                self.take("fuse");
                self.set("fuse_in");
                if self.lamps == LAMPS_ALL {
                    self.set("power");
                    "omsg.power"
                } else {
                    "omsg.fuse_in"
                }
            }
            ("akey", "atlas") => {
                self.take("akey");
                self.set("atlas_open");
                "omsg.atlas_open"
            }
            ("eyepiece", "eyepiece" | "scope") => {
                self.take("eyepiece");
                self.set("eye_on");
                "omsg.eye_on"
            }
            ("weights", "bar" | "balance" | "scope") => {
                self.take("weights");
                self.set("weights_on");
                "omsg.weights_on"
            }
            ("plate", "camera" | "scope") => {
                if !self.flag("eye_on") {
                    "omsg.eye_missing"
                } else if !self.balanced() {
                    "omsg.scope_sags"
                } else if !self.slit_right() {
                    "omsg.see_dome"
                } else if !self.circles() {
                    "omsg.see_stars"
                } else {
                    self.take("plate");
                    self.set(EXPOSED);
                    "omsg.exposed"
                }
            }
            _ => "omsg.no_use",
        })
    }

    fn dial(&mut self, lock: &str, wheel: Option<&str>, by: i8) -> Reply {
        let wheel: usize = wheel.and_then(|w| w.parse().ok()).ok_or_else(|| bad("wheel"))?;
        let turn = |d: &mut u8, size: i8| *d = ((*d as i8 + by).rem_euclid(size)) as u8;
        match lock {
            "drawer" if self.flag("drawer_open") => Ok(""),
            "drawer" => {
                turn(self.drawer.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 8);
                if self.drawer == drawer_code() {
                    self.set("drawer_open");
                    return Ok("omsg.drawer_open");
                }
                Ok("")
            }
            "cabinet" if self.flag("cabinet_open") => Ok(""),
            "cabinet" => {
                turn(self.cabinet.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 10);
                if self.cabinet == cabinet_code() {
                    self.set("cabinet_open");
                    return Ok("omsg.cabinet_open");
                }
                Ok("")
            }
            "box" if self.flag("box_open") => Ok(""),
            "box" => {
                turn(self.box_lock.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 10);
                if self.box_lock == box_code() {
                    self.set("box_open");
                    return Ok("omsg.box_open");
                }
                Ok("")
            }
            "door" => {
                turn(self.door.get_mut(wheel).ok_or_else(|| bad("wheel"))?, 10);
                // The time lock only listens once the observation is recorded.
                if self.door == door_code() && self.flag(EXPOSED) {
                    self.done = true;
                    return Ok("omsg.door_open");
                }
                Ok("")
            }
            other => Err(bad(other)),
        }
    }

    fn lamp(&mut self, lamp: Option<&str>) -> Reply {
        let i: i8 = lamp
            .and_then(|p| p.parse().ok())
            .filter(|p| (0..6).contains(p))
            .ok_or_else(|| bad("lamp"))?;
        if self.flag("power") {
            return Ok("");
        }
        if !self.flag("fuse_in") {
            return Ok("omsg.board_dead");
        }
        for j in [i - 1, i, i + 1] {
            if (0..6).contains(&j) {
                self.lamps ^= 1 << j;
            }
        }
        if self.lamps == LAMPS_ALL {
            self.set("power");
            return Ok("omsg.power");
        }
        Ok("")
    }

    fn turn_dome(&mut self, by: i8) -> Reply {
        if !self.flag("power") {
            return Ok("omsg.wheel_dead");
        }
        // The dome keeps turning after the photograph: its moonbeam is the
        // decoder for the door's code too.
        self.dome = (self.dome as i8 + by).rem_euclid(8) as u8;
        Ok("")
    }

    fn planet(&mut self, which: Option<&str>, by: i8) -> Reply {
        let i: usize = which
            .and_then(|p| p.parse().ok())
            .filter(|p| *p < 3)
            .ok_or_else(|| bad("planet"))?;
        if self.flag("orrery_open") {
            return Ok("");
        }
        self.planets[i] = (self.planets[i] as i8 + by).rem_euclid(8) as u8;
        if self.planets == planet_places() {
            self.set("orrery_open");
            return Ok("omsg.orrery_open");
        }
        Ok("")
    }

    fn weight(&mut self, which: Option<&str>) -> Reply {
        let i: u8 = which
            .and_then(|p| p.parse().ok())
            .filter(|p| usize::from(*p) < WEIGHTS.len())
            .ok_or_else(|| bad("weight"))?;
        if !self.flag("weights_on") {
            return Ok("omsg.bar_empty");
        }
        if self.flag(EXPOSED) {
            return Ok("");
        }
        self.weights ^= 1 << i;
        Ok(if self.balanced() { "omsg.balanced" } else { "" })
    }

    pub fn save(&self) -> String {
        format!(
            "O1.{:x}.{:x}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}.{}",
            self.flags,
            self.inv,
            digits_text(&self.drawer),
            digits_text(&self.cabinet),
            digits_text(&self.box_lock),
            digits_text(&self.door),
            self.lamps,
            self.dome,
            digits_text(&self.planets),
            self.weights,
            self.ra,
            self.dec,
            self.plani,
            digits_text(&self.hints),
            self.secs,
            u8::from(self.done)
        )
    }

    pub fn load(text: &str) -> Result<Obs, String> {
        let err = || "bad save".to_string();
        let p: Vec<&str> = text.trim().split('.').collect();
        if p.len() != 17 || p[0] != "O1" {
            return Err(err());
        }
        let small = |s: &str, below: u8| s.parse::<u8>().ok().filter(|v| *v < below).ok_or_else(err);
        Ok(Obs {
            flags: u32::from_str_radix(p[1], 16)
                .ok()
                .filter(|f| *f < 1 << (FLAGS.len() + 1))
                .ok_or_else(err)?,
            inv: u16::from_str_radix(p[2], 16)
                .ok()
                .filter(|f| *f < 1 << ITEMS.len())
                .ok_or_else(err)?,
            drawer: digits(p[3], 7).ok_or_else(err)?,
            cabinet: digits(p[4], 9).ok_or_else(err)?,
            box_lock: digits(p[5], 9).ok_or_else(err)?,
            door: digits(p[6], 9).ok_or_else(err)?,
            lamps: small(p[7], 64)?,
            dome: small(p[8], 8)?,
            planets: digits(p[9], 7).ok_or_else(err)?,
            weights: small(p[10], 32)?,
            ra: small(p[11], 24)?,
            dec: small(p[12], 10)?,
            plani: small(p[13], 24)?,
            hints: digits(p[14], 3).ok_or_else(err)?,
            secs: p[15].parse().map_err(|_| err())?,
            done: p[16] == "1",
        })
    }

    pub fn state_json(&self) -> String {
        let mut flags = names_json(&FLAGS, self.flags);
        if self.flag(EXPOSED) {
            flags.push_str(if flags.is_empty() {
                "\"exposed\""
            } else {
                ",\"exposed\""
            });
        }
        let bits = |v: u8, n: usize| (0..n).map(|i| u8::from(v & (1 << i) != 0)).collect::<Vec<_>>();
        let solved = self.solved().map(|b| b.to_string()).join(",");
        format!(
            "{{\"room\":\"obs\",\"flags\":[{}],\"inv\":[{}],\"drawer\":[{}],\"cabinet\":[{}],\"box\":[{}],\"door\":[{}],\"lamps\":[{}],\"dome\":{},\"lit\":{},\"planets\":[{}],\"weights\":[{}],\"sum\":{},\"balanced\":{},\"ra\":{},\"dec\":{},\"plani\":{},\"hints\":[{}],\"solved\":[{}],\"act\":{},\"secs\":{},\"done\":{},\"halves\":{}}}",
            flags,
            names_json(&ITEMS, u32::from(self.inv)),
            nums_json(&self.drawer),
            nums_json(&self.cabinet),
            nums_json(&self.box_lock),
            nums_json(&self.door),
            nums_json(&bits(self.lamps, 6)),
            self.dome,
            self.lit_plaque(),
            nums_json(&self.planets),
            nums_json(&bits(self.weights, WEIGHTS.len())),
            self.weight_sum(),
            self.balanced(),
            self.ra,
            dec_degrees(self.dec),
            self.plani,
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
                *self = Obs::new();
                Ok("")
            }
            Some("state") => Ok(""),
            Some("clues") => return clues_json(),
            Some("save") => return format!("{{\"ok\":true,\"save\":\"{}\"}}", self.save()),
            Some("load") => Obs::load(w.next().unwrap_or("")).map(|room| {
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
            Some("lamp") => self.lamp(w.next()),
            Some("dome") => step(w.next()).and_then(|by| self.turn_dome(by)),
            Some("planet") => {
                let which = w.next();
                step(w.next()).and_then(|by| self.planet(which, by))
            }
            Some("weight") => self.weight(w.next()),
            Some("ra") => step(w.next()).map(|by| {
                if !self.flag(EXPOSED) {
                    self.ra = (self.ra as i8 + by).rem_euclid(24) as u8;
                }
                ""
            }),
            Some("dec") => step(w.next()).map(|by| {
                if !self.flag(EXPOSED) {
                    self.dec = (self.dec as i8 + by).clamp(0, 9) as u8;
                }
                ""
            }),
            Some("plani") => step(w.next()).map(|by| {
                self.plani = (self.plani as i8 + by).rem_euclid(24) as u8;
                ""
            }),
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

/// What the observatory's pictures must show (the client draws from this).
pub fn clues_json() -> String {
    let books = BOOKS
        .iter()
        .map(|(colour, s)| format!("{{\"colour\":\"{colour}\",\"shape\":\"{s}\"}}"))
        .collect::<Vec<_>>();
    let planets = PLANETS
        .iter()
        .map(|(name, digit)| format!("{{\"planet\":\"{name}\",\"digit\":{digit}}}"))
        .collect::<Vec<_>>();
    let decs = DECLINATIONS.iter().map(|d| d.to_string()).collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"shapes\":[{}],\"plaque_digits\":[{}],\"declinations\":[{}],\"books\":[{}],\"note_colours\":[{}],\"sun_clock\":[{},{}],\"star_clock\":[{},{}],\"path\":[{}],\"planets\":[{}],\"weights\":[{}],\"eyepiece_weight\":{},\"camera_weight\":{},\"tonight\":[{},{},{}],\"disc\":[{}],\"photo\":[{}]}}",
        strs_json(&SHAPES),
        nums_json(&PLAQUE_DIGITS),
        decs.join(","),
        books.join(","),
        strs_json(&NOTE_COLOURS),
        SUN_CLOCK.0,
        SUN_CLOCK.1,
        STAR_CLOCK.0,
        STAR_CLOCK.1,
        strs_json(&PATH),
        planets.join(","),
        nums_json(&WEIGHTS),
        EYEPIECE_WEIGHT,
        CAMERA_WEIGHT,
        TONIGHT.0,
        TONIGHT.1,
        TONIGHT.2,
        strs_json(&DISC),
        strs_json(&PHOTO)
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    fn msg(room: &mut Obs, command: &str) -> String {
        let answer = room.call(command);
        assert!(answer.starts_with("{\"ok\":true"), "{command}: {answer}");
        let start = answer.find("\"msg\":\"").map(|i| i + 7).unwrap_or(0);
        answer[start..].split('"').next().unwrap().to_string()
    }

    fn turn_to(room: &mut Obs, lock: &str, code: &[u8], size: u8) {
        for (i, d) in code.iter().enumerate() {
            for _ in 0..*d % size {
                room.call(&format!("dial {lock} {i} +1"));
            }
        }
    }

    fn times(room: &mut Obs, command: &str, n: usize) {
        for _ in 0..n {
            room.call(command);
        }
    }

    #[test]
    fn the_codes() {
        assert_eq!(drawer_code(), [6, 3, 5]);
        assert_eq!(cabinet_code(), [0, 5, 3, 5]);
        assert_eq!(box_code(), [1, 8, 4, 3]);
        assert_eq!(planet_places(), [3, 6, 7]);
        assert_eq!(plani_turn(), 21);
        assert_eq!(SHAPES[target()], "hook");
        assert_eq!(door_code(), [9, 2, 6, 7]);
        // Only one set of counterweights balances the telescope.
        let fits = (0u8..32)
            .filter(|set| {
                (0..5)
                    .filter(|i| set & (1 << i) != 0)
                    .map(|i| WEIGHTS[i])
                    .sum::<u8>()
                    == 23
            })
            .collect::<Vec<_>>();
        assert_eq!(fits, [0b01011]);
        // Every constellation is on a book, on the disc and has its own digit.
        for s in SHAPES {
            assert!(BOOKS.iter().any(|(_, b)| *b == s) && DISC.contains(&s));
        }
        let mut digits = PLAQUE_DIGITS.to_vec();
        digits.sort();
        digits.dedup();
        assert_eq!(digits.len(), 8);
    }

    fn study() -> Obs {
        let mut r = Obs::new();
        assert_eq!(msg(&mut r, "tap gate"), "omsg.gate_locked");
        turn_to(&mut r, "drawer", &drawer_code(), 8);
        assert_eq!(msg(&mut r, "tap drawer"), "omsg.drawer_take");
        assert_eq!(msg(&mut r, "use page notebook"), "omsg.page_in");
        assert_eq!(msg(&mut r, "use gkey gate"), "omsg.gate_open");
        turn_to(&mut r, "cabinet", &cabinet_code(), 10);
        assert_eq!(msg(&mut r, "tap cabinet"), "omsg.cabinet_take");
        assert_eq!(msg(&mut r, "dome +1"), "omsg.wheel_dead");
        assert_eq!(msg(&mut r, "lamp 2"), "omsg.board_dead");
        assert_eq!(msg(&mut r, "use fuse fuse_slot"), "omsg.fuse_in");
        r.call("lamp 0");
        r.call("lamp 3");
        assert_eq!(msg(&mut r, "lamp 4"), "omsg.power");
        assert_eq!(r.act(), 3);
        r
    }

    fn dome(mut r: Obs) -> Obs {
        // Every plaque can be lit.
        let mut seen = Vec::new();
        for _ in 0..8 {
            r.call("dome +1");
            seen.push(r.lit_plaque());
        }
        seen.sort();
        assert_eq!(seen, [0, 1, 2, 3, 4, 5, 6, 7]);
        turn_to(&mut r, "box", &box_code(), 10);
        assert_eq!(msg(&mut r, "tap box"), "omsg.box_take");
        assert_eq!(msg(&mut r, "use akey atlas"), "omsg.atlas_open");
        // Orrery: from 1, 4, 2 to 3, 6, 7.
        times(&mut r, "planet 0 +1", 2);
        times(&mut r, "planet 1 +1", 2);
        times(&mut r, "planet 2 -1", 3);
        assert!(r.flag("orrery_open"));
        assert_eq!(msg(&mut r, "tap orrery_drawer"), "omsg.weights");
        r
    }

    fn observe(mut r: Obs) -> Obs {
        assert_eq!(msg(&mut r, "use plate camera"), "omsg.eye_missing");
        msg(&mut r, "use eyepiece eyepiece");
        assert_eq!(msg(&mut r, "weight 0"), "omsg.bar_empty");
        msg(&mut r, "use weights bar");
        assert_eq!(msg(&mut r, "tap eyepiece"), "omsg.scope_sags");
        r.call("weight 0");
        r.call("weight 1");
        assert_eq!(msg(&mut r, "weight 3"), "omsg.balanced");
        assert_eq!(msg(&mut r, "tap eyepiece"), "omsg.see_dome");
        // The slit to the hook's plaque (position 3) from position 6.
        times(&mut r, "dome -1", 3);
        assert_eq!(msg(&mut r, "tap eyepiece"), "omsg.see_stars");
        times(&mut r, "ra +1", 9);
        times(&mut r, "dec +1", 2);
        assert_eq!(msg(&mut r, "tap eyepiece"), "omsg.see_comet");
        turn_to(&mut r, "door", &door_code(), 10);
        assert!(!r.done(), "the door waits for the photograph");
        r.call("dial door 0 +1");
        assert_eq!(msg(&mut r, "use plate camera"), "omsg.exposed");
        // The moonbeam still reads the plaques for the door's code.
        let at = r.dome;
        r.call("dome +1");
        assert_eq!(r.dome, (at + 1) % 8, "the dome turns after the photograph");
        r.call("dome -1");
        assert_eq!(msg(&mut r, "dial door 0 -1"), "omsg.door_open");
        assert!(r.done());
        r
    }

    #[test]
    fn the_observation_can_be_made() {
        let r = observe(dome(study()));
        assert_eq!(r.solved(), [true; 10]);
        assert_eq!(r.halves(), 6);
        assert_eq!(r.inv, 0);
    }

    #[test]
    fn the_planisphere_is_a_tool() {
        let mut r = Obs::new();
        let mut shown = Vec::new();
        for _ in 0..24 {
            r.call("plani +1");
            shown.push(plani_shows(r.plani));
        }
        assert_eq!(shown.iter().flatten().count(), 8);
        assert_eq!(plani_shows(plani_turn()), Some(3));
    }

    #[test]
    fn hints_follow_the_view() {
        let mut r = dome(study());
        assert!(r.call("hintinfo balance").contains("\"puzzle\":6"));
        assert!(r.call("hintinfo plani").contains("\"puzzle\":7"));
        assert!(r.call("hintinfo D2").contains("\"puzzle\":8"));
        assert!(r.call("hint scope").contains("\"puzzle\":6,\"level\":1"));
        assert_eq!(r.halves(), 5);
    }

    #[test]
    fn save_and_load() {
        let mut r = dome(study());
        r.call("plani -1");
        r.call("time 1300");
        let mut other = Obs::new();
        assert!(other
            .call(&format!("load {}", r.save()))
            .starts_with("{\"ok\":true"));
        assert_eq!(other, r);
        assert_eq!(Obs::load(&Obs::new().save()).unwrap(), Obs::new());
        assert!(Obs::load(&crate::light::Light::new().save()).is_err());
        let done = observe(r);
        assert_eq!(Obs::load(&done.save()).unwrap(), done);
    }

    #[test]
    fn bad_commands_are_refused() {
        let mut r = Obs::new();
        for c in [
            "",
            "fly",
            "tap moon",
            "use fuse board",
            "dial drawer 3 +1",
            "lamp 6",
            "planet 3 +1",
            "weight 5",
            "ra 2",
        ] {
            assert!(r.call(c).starts_with("{\"ok\":false"), "{c}");
        }
        assert_eq!(r, Obs::new());
    }
}
