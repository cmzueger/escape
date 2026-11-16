//! A room described as data: flags, items, locks, dials, things to pick up
//! and to use, conditions that latch, and a hook for the odd mechanism.
//! The rooms of the second set are built with it (see [`crate::orangery`],
//! [`crate::theatre`], [`crate::chess`]).
//!
//! Commands besides the common ones (see the crate):
//! - `turn <lock or dial> <index> <+1|-1>`: a wheel of a lock, or a dial
//! - `flip <dial> <index>`: a dial with two positions, switched over
//! - whatever the room's hook adds

use crate::{bad, names_json, nums_json, step};

pub type Reply = Result<String, String>;

/// A combination lock: when its wheels show `code`, `flag` is set.
pub struct Lock {
    pub name: &'static str,
    /// Positions per wheel.
    pub size: u8,
    pub start: &'static [u8],
    pub code: fn() -> Vec<u8>,
    pub flag: &'static str,
    pub msg: &'static str,
    /// A flag without which the right code does nothing.
    pub needs: &'static str,
}

/// Free positions (sliders, switches, pointers) that conditions read.
pub struct Dial {
    pub name: &'static str,
    pub size: u8,
    pub start: &'static [u8],
    pub wrap: bool,
    /// A flag without which it cannot be moved, and what is said then.
    pub needs: &'static str,
    pub needs_msg: &'static str,
    /// A flag after which it no longer moves.
    pub freeze: &'static str,
}

/// Something to take by tapping.
pub struct Pick {
    pub spot: &'static str,
    pub needs: &'static str,
    pub locked_msg: &'static str,
    pub got: &'static str,
    pub give: &'static [&'static str],
    pub msg: &'static str,
}

/// An item used on a hotspot (several spots: `"a|b"`).
pub struct Use {
    pub item: &'static str,
    pub spot: &'static str,
    pub needs: &'static str,
    pub fail: &'static str,
    pub keep: bool,
    pub set: &'static str,
    pub give: &'static [&'static str],
    pub msg: &'static str,
}

/// A condition that sets a flag for good once it holds.
pub struct Check {
    pub flag: &'static str,
    pub cond: fn(&State) -> bool,
    pub msg: &'static str,
}

/// What a tap says depending on a flag.
pub struct Look {
    pub spot: &'static str,
    pub flag: &'static str,
    pub set: &'static str,
    pub unset: &'static str,
}

pub struct Puzzle {
    pub solved: fn(&State) -> bool,
    pub available: fn(&State) -> bool,
}

pub struct Spec {
    pub id: &'static str,
    /// In front of `msg.nothing`, `msg.no_use` and the flavour texts.
    pub prefix: &'static str,
    pub par_minutes: u32,
    pub flags: &'static [&'static str],
    pub items: &'static [&'static str],
    pub locks: &'static [Lock],
    pub dials: &'static [Dial],
    pub picks: &'static [Pick],
    pub uses: &'static [Use],
    pub checks: &'static [Check],
    pub looks: &'static [Look],
    /// Hotspots that only say `<prefix>msg.<spot>`.
    pub flavour: &'static [&'static str],
    pub puzzles: &'static [Puzzle],
    /// Which puzzles a hint asked for in a view is about, in order.
    pub hint_views: &'static [(&'static str, &'static [usize])],
    /// The flag that ends the room.
    pub done_flag: &'static str,
    pub clues: fn() -> String,
    /// Extra fields for the state (`,"name":value…`) and extra commands.
    pub extra: fn(&State) -> String,
    pub hook: fn(&mut State, &[&str]) -> Option<Reply>,
}

#[derive(Clone, Debug, PartialEq)]
pub struct State {
    pub flags: u64,
    pub inv: u32,
    /// Locks first, then dials.
    pub vals: Vec<Vec<u8>>,
    pub hints: Vec<u8>,
    pub secs: u32,
    pub done: bool,
    spec: &'static Spec,
}

impl PartialEq for Spec {
    fn eq(&self, other: &Self) -> bool {
        self.id == other.id
    }
}

impl std::fmt::Debug for Spec {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "Spec({})", self.id)
    }
}

fn index(list: &[&str], name: &str) -> Option<usize> {
    list.iter().position(|n| *n == name)
}

const BASE36: &[u8] = b"0123456789abcdefghijklmnopqrstuvwxyz";

impl State {
    pub fn new(spec: &'static Spec) -> Self {
        let vals = spec
            .locks
            .iter()
            .map(|l| l.start.to_vec())
            .chain(spec.dials.iter().map(|d| d.start.to_vec()));
        State {
            flags: 0,
            inv: 0,
            vals: vals.collect(),
            hints: vec![0; spec.puzzles.len()],
            secs: 0,
            done: false,
            spec,
        }
    }

    pub fn id(&self) -> &'static str {
        self.spec.id
    }

    /// True for "" (no condition) and for a flag that is set.
    pub fn flag(&self, name: &str) -> bool {
        name.is_empty() || index(self.spec.flags, name).is_some_and(|i| self.flags & (1 << i) != 0)
    }

    pub fn set(&mut self, name: &str) {
        if !name.is_empty() {
            self.flags |= 1 << index(self.spec.flags, name).unwrap_or_else(|| panic!("flag {name}"));
        }
    }

    pub fn has(&self, item: &str) -> bool {
        index(self.spec.items, item).is_some_and(|i| self.inv & (1 << i) != 0)
    }

    pub fn give(&mut self, item: &str) {
        self.inv |= 1 << index(self.spec.items, item).unwrap_or_else(|| panic!("item {item}"));
    }

    pub fn take(&mut self, item: &str) {
        self.inv &= !(1 << index(self.spec.items, item).unwrap_or_else(|| panic!("item {item}")));
    }

    fn slot(&self, name: &str) -> Option<usize> {
        self.spec.locks.iter().position(|l| l.name == name).or_else(|| {
            self.spec
                .dials
                .iter()
                .position(|d| d.name == name)
                .map(|i| i + self.spec.locks.len())
        })
    }

    /// The positions of a lock or dial.
    pub fn val(&self, name: &str) -> &[u8] {
        &self.vals[self.slot(name).unwrap_or_else(|| panic!("dial {name}"))]
    }

    pub fn val_mut(&mut self, name: &str) -> &mut Vec<u8> {
        let i = self.slot(name).unwrap_or_else(|| panic!("dial {name}"));
        &mut self.vals[i]
    }

    pub fn solved(&self) -> Vec<bool> {
        self.spec.puzzles.iter().map(|p| (p.solved)(self)).collect()
    }

    pub fn halves(&self) -> u8 {
        crate::halves(&self.hints, self.secs, self.spec.par_minutes)
    }

    fn key(&self, what: &str) -> String {
        format!("{}msg.{what}", self.spec.prefix)
    }

    fn hint_puzzle(&self, view: &str) -> usize {
        let solved = self.solved();
        let open = |p: usize| (self.spec.puzzles[p].available)(self) && !solved[p];
        let wanted = self
            .spec
            .hint_views
            .iter()
            .find(|(v, _)| *v == view)
            .map(|(_, p)| *p)
            .unwrap_or(&[]);
        wanted
            .iter()
            .copied()
            .find(|p| open(*p))
            .or_else(|| (0..solved.len()).find(|p| open(*p)))
            .unwrap_or(solved.len() - 1)
    }

    fn tap(&mut self, spot: &str) -> Reply {
        let spec = self.spec;
        if let Some(p) = spec.picks.iter().find(|p| p.spot == spot) {
            return Ok(if !self.flag(p.needs) {
                p.locked_msg.to_string()
            } else if self.flag(p.got) {
                self.key("nothing")
            } else {
                self.set(p.got);
                for item in p.give {
                    self.give(item);
                }
                p.msg.to_string()
            });
        }
        if let Some(l) = spec.looks.iter().find(|l| l.spot == spot) {
            return Ok(if self.flag(l.flag) { l.set } else { l.unset }.to_string());
        }
        if spec.flavour.contains(&spot) {
            return Ok(self.key(spot));
        }
        Err(bad(spot))
    }

    fn use_item(&mut self, item: &str, spot: &str) -> Reply {
        if !self.has(item) {
            return Err(format!("not carried: {item}"));
        }
        let spec = self.spec;
        let Some(u) = spec
            .uses
            .iter()
            .find(|u| u.item == item && u.spot.split('|').any(|s| s == spot))
        else {
            return Ok(self.key("no_use"));
        };
        if !self.flag(u.needs) {
            return Ok(u.fail.to_string());
        }
        if !u.keep {
            self.take(item);
        }
        self.set(u.set);
        for got in u.give {
            self.give(got);
        }
        Ok(u.msg.to_string())
    }

    fn turn(&mut self, name: &str, wheel: Option<&str>, by: i8) -> Reply {
        let spec = self.spec;
        let slot = self.slot(name).ok_or_else(|| bad(name))?;
        let i: usize = wheel
            .and_then(|w| w.parse().ok())
            .filter(|i| *i < self.vals[slot].len())
            .ok_or_else(|| bad("index"))?;
        if let Some(lock) = spec.locks.iter().find(|l| l.name == name) {
            if self.flag(lock.flag) && !lock.flag.is_empty() {
                return Ok(String::new());
            }
            self.vals[slot][i] = (self.vals[slot][i] as i8 + by).rem_euclid(lock.size as i8) as u8;
            if self.vals[slot] == (lock.code)() && self.flag(lock.needs) {
                self.set(lock.flag);
                return Ok(lock.msg.to_string());
            }
            return Ok(String::new());
        }
        let dial = &spec.dials[slot - spec.locks.len()];
        if !self.flag(dial.needs) {
            return Ok(dial.needs_msg.to_string());
        }
        if !dial.freeze.is_empty() && self.flag(dial.freeze) {
            return Ok(String::new());
        }
        let next = self.vals[slot][i] as i8 + by;
        self.vals[slot][i] = if dial.wrap {
            next.rem_euclid(dial.size as i8)
        } else {
            next.clamp(0, dial.size as i8 - 1)
        } as u8;
        Ok(String::new())
    }

    pub fn save(&self) -> String {
        let vals = self
            .vals
            .iter()
            .map(|v| {
                v.iter()
                    .map(|d| BASE36[usize::from(*d) % 36] as char)
                    .collect::<String>()
            })
            .collect::<Vec<_>>()
            .join("-");
        let hints = self.hints.iter().map(|h| h.to_string()).collect::<String>();
        format!(
            "K1.{}.{:x}.{:x}.{}.{}.{}.{}",
            self.spec.id,
            self.flags,
            self.inv,
            vals,
            hints,
            self.secs,
            u8::from(self.done)
        )
    }

    pub fn load(spec: &'static Spec, text: &str) -> Result<State, String> {
        let err = || "bad save".to_string();
        let p: Vec<&str> = text.trim().split('.').collect();
        if p.len() != 8 || p[0] != "K1" || p[1] != spec.id {
            return Err(err());
        }
        let mut state = State::new(spec);
        state.flags = u64::from_str_radix(p[2], 16)
            .ok()
            .filter(|f| *f < 1 << spec.flags.len())
            .ok_or_else(err)?;
        state.inv = u32::from_str_radix(p[3], 16)
            .ok()
            .filter(|f| *f < 1 << spec.items.len())
            .ok_or_else(err)?;
        let sizes = spec
            .locks
            .iter()
            .map(|l| l.size)
            .chain(spec.dials.iter().map(|d| d.size))
            .collect::<Vec<_>>();
        let groups: Vec<&str> = p[4].split('-').collect();
        if groups.len() != state.vals.len() {
            return Err(err());
        }
        for (k, group) in groups.iter().enumerate() {
            let read = group
                .bytes()
                .map(|b| {
                    BASE36
                        .iter()
                        .position(|c| *c == b)
                        .map(|d| d as u8)
                        .filter(|d| *d < sizes[k])
                })
                .collect::<Option<Vec<u8>>>()
                .ok_or_else(err)?;
            if read.len() != state.vals[k].len() {
                return Err(err());
            }
            state.vals[k] = read;
        }
        let hints = p[5].bytes().map(|b| b.wrapping_sub(b'0')).collect::<Vec<u8>>();
        if hints.len() != state.hints.len() || hints.iter().any(|h| *h > 3) {
            return Err(err());
        }
        state.hints = hints;
        state.secs = p[6].parse().map_err(|_| err())?;
        state.done = p[7] == "1";
        Ok(state)
    }

    pub fn state_json(&self) -> String {
        let spec = self.spec;
        let names = spec
            .locks
            .iter()
            .map(|l| l.name)
            .chain(spec.dials.iter().map(|d| d.name));
        let vals = names
            .zip(&self.vals)
            .map(|(n, v)| format!("\"{n}\":[{}],", nums_json(v)))
            .collect::<String>();
        let solved = self.solved();
        format!(
            "{{\"room\":\"{}\",\"flags\":[{}],\"inv\":[{}],{}\"hints\":[{}],\"solved\":[{}],\"act\":{},\"secs\":{},\"done\":{},\"halves\":{}{}}}",
            spec.id,
            names_json(spec.flags, self.flags as u32),
            names_json(spec.items, self.inv),
            vals,
            nums_json(&self.hints),
            solved.iter().map(|b| b.to_string()).collect::<Vec<_>>().join(","),
            1 + solved.iter().filter(|s| **s).count(),
            self.secs,
            self.done,
            self.halves(),
            (spec.extra)(self)
        )
    }

    /// Runs one command and returns the JSON answer.
    pub fn call(&mut self, command: &str) -> String {
        let spec = self.spec;
        let words: Vec<&str> = command.split_whitespace().collect();
        let mut w = words.iter().copied();
        // The room's own mechanisms come first (never once it is solved).
        let hooked = if self.done || words.is_empty() {
            None
        } else {
            (spec.hook)(self, &words)
        };
        let result: Reply = match w.next() {
            _ if hooked.is_some() => hooked.unwrap_or_else(|| Ok(String::new())),
            Some("new") => {
                *self = State::new(spec);
                Ok(String::new())
            }
            Some("state") => Ok(String::new()),
            Some("clues") => return (spec.clues)(),
            Some("save") => return format!("{{\"ok\":true,\"save\":\"{}\"}}", self.save()),
            Some("load") => State::load(spec, w.next().unwrap_or("")).map(|room| {
                *self = room;
                String::new()
            }),
            Some("time") => w
                .next()
                .and_then(|s| s.parse::<u32>().ok())
                .ok_or_else(|| bad("time"))
                .map(|s| {
                    if !self.done {
                        self.secs = self.secs.max(s);
                    }
                    String::new()
                }),
            Some(kind @ ("hint" | "hintinfo")) => {
                let p = self.hint_puzzle(w.next().unwrap_or(""));
                if kind == "hint" && self.hints[p] < 3 && !self.done {
                    self.hints[p] += 1;
                }
                return format!(
                    "{{\"ok\":true,\"puzzle\":{},\"level\":{},\"state\":{}}}",
                    p + 1,
                    self.hints[p],
                    self.state_json()
                );
            }
            Some(_) if self.done => Ok(String::new()),
            Some("tap") => w.next().ok_or_else(|| bad("tap")).and_then(|s| self.tap(s)),
            Some("use") => match (w.next(), w.next()) {
                (Some(item), Some(spot)) => self.use_item(item, spot),
                _ => Err(bad("use")),
            },
            Some("turn") => match w.next() {
                Some(name) => {
                    let wheel = w.next();
                    step(w.next()).and_then(|by| self.turn(name, wheel, by))
                }
                None => Err(bad("turn")),
            },
            Some("flip") => match w.next() {
                Some(name) if spec.dials.iter().any(|d| d.name == name && d.size == 2) => {
                    self.turn(name, w.next(), 1)
                }
                _ => Err(bad("flip")),
            },
            Some(other) => Err(bad(other)),
            None => Err(bad("empty")),
        };
        match result {
            Ok(mut msg) => {
                for check in spec.checks {
                    if !self.flag(check.flag) && (check.cond)(self) {
                        self.set(check.flag);
                        msg = check.msg.to_string();
                    }
                }
                if self.flag(spec.done_flag) {
                    self.done = true;
                }
                format!(
                    "{{\"ok\":true,\"msg\":\"{msg}\",\"state\":{}}}",
                    self.state_json()
                )
            }
            Err(e) => format!("{{\"ok\":false,\"error\":\"{}\"}}", e.replace(['"', '\\'], "'")),
        }
    }
}

pub fn no_extra(_: &State) -> String {
    String::new()
}

pub fn no_hook(_: &mut State, _: &[&str]) -> Option<Reply> {
    None
}

/// For tests: the message of an answer, which must be ok.
#[cfg(test)]
pub fn msg(room: &mut State, command: &str) -> String {
    let answer = room.call(command);
    assert!(answer.starts_with("{\"ok\":true"), "{command}: {answer}");
    let start = answer.find("\"msg\":\"").map(|i| i + 7).unwrap_or(0);
    answer[start..].split('"').next().unwrap().to_string()
}

/// For tests: turns a lock's or dial's wheels from where they are to `to`.
#[cfg(test)]
pub fn turn_to(room: &mut State, name: &str, to: &[u8], size: u8) {
    for (i, d) in to.iter().enumerate() {
        let from = room.val(name)[i];
        for _ in 0..(*d + size - from) % size {
            room.call(&format!("turn {name} {i} +1"));
        }
    }
}
