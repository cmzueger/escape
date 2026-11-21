//! Graf Alpina (medium): the chart room of a zeppelin over the Alps at
//! dusk, drifting off course. Five puzzles. Views: `Z1` (the big windows,
//! the binnacle compass, the radio desk with a telegram, a wall clock) and
//! `Z2` (the captain's cabinet, a photograph, the code book, the chart with
//! its paperweight, the gas valves).
//!
//! The compass: the earth pulls the needle north, the engines a little west,
//! and two magnets set in the binnacle's four slots pull (or, turned round,
//! push). The needle must point along the course from the telegram.

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// The photograph shows the airship over a town; its church clock says this
/// (the cabinet's lock shows a church). The wall clock is a decoy.
pub const CHURCH: (u8, u8) = (7, 35);
pub const WALL_CLOCK: (u8, u8) = (4, 20);
/// The code book's surviving page: three symbols with their digits. A symbol
/// is a ring with a notch; the notch at one of ten places, clockwise from the
/// top, is the digit.
pub const SAMPLES: [u8; 3] = [3, 7, 0];
/// The telegram: the new course, in that code.
pub const COURSE: [u8; 3] = [2, 2, 5];
/// Through the binoculars, once the airship has turned: the ground crew's
/// white panels by the mooring mast.
pub const PANELS: [u8; 3] = [6, 1, 8];
/// The compass: earth (north), engines (east, north), magnet strength.
pub const EARTH: i32 = 3;
pub const ENGINES: (i32, i32) = (-1, 0);
pub const MAGNET: i32 = 2;
/// Slots north, east, south, west: 0 empty, 1 pulling, 2 pushing.
const SLOT_DIRS: [(i32, i32); 4] = [(0, 1), (1, 0), (0, -1), (-1, 0)];

/// The needle's direction in degrees (0 north, clockwise), or `None` when
/// the pulls cancel.
pub fn needle(slots: &[u8]) -> Option<u32> {
    let (mut x, mut y) = (ENGINES.0, EARTH + ENGINES.1);
    for (s, (dx, dy)) in slots.iter().zip(SLOT_DIRS) {
        let k = match s {
            1 => MAGNET,
            2 => -MAGNET,
            _ => 0,
        };
        x += k * dx;
        y += k * dy;
    }
    if x == 0 && y == 0 {
        return None;
    }
    let deg = (x as f64).atan2(y as f64).to_degrees().rem_euclid(360.0);
    Some(deg.round() as u32 % 360)
}

fn course() -> u32 {
    COURSE.iter().fold(0, |n, d| n * 10 + u32::from(*d))
}

fn magnets_in(s: &State) -> usize {
    usize::from(s.flag("mag1_in")) + usize::from(s.flag("mag2_in"))
}

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"church\":[{},{}],\"wall_clock\":[{},{}],\"samples\":[{}],\"telegram\":[{}],\"panels\":[{}]}}",
        CHURCH.0,
        CHURCH.1,
        WALL_CLOCK.0,
        WALL_CLOCK.1,
        nums_json(&SAMPLES),
        nums_json(&COURSE),
        nums_json(&PANELS)
    )
}

/// `slot <0..3>`: an empty slot takes a magnet (if one is free), a pulling
/// one is turned round, a pushing one is taken out.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let ["slot", i] = words else {
        return None;
    };
    Some(match i.parse::<usize>().ok().filter(|i| *i < 4) {
        None => Err(bad("slot")),
        Some(_) if s.flag("aligned") => Ok(String::new()),
        Some(i) => {
            let placed = s.val("slots").iter().filter(|v| **v != 0).count();
            let v = s.val("slots")[i];
            if v == 0 && placed >= magnets_in(s) {
                Ok("zmsg.no_magnet".into())
            } else {
                s.val_mut("slots")[i] = (v + 1) % 3;
                Ok(String::new())
            }
        }
    })
}

/// The needle for the client: `,"needle":342`.
fn extra(s: &State) -> String {
    format!(",\"needle\":{}", needle(s.val("slots")).unwrap_or(0))
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 11;

pub static SPEC: Spec = Spec {
    id: "zeppelin",
    prefix: "z",
    par_minutes: PAR_MINUTES,
    flags: &[
        "cab_open",
        "got_cab",
        "got_horseshoe",
        "mag1_in",
        "mag2_in",
        "course_set",
        "aligned",
        "bino",
        "done",
    ],
    items: &["zmagnet", "binoculars", "horseshoe"],
    locks: &[
        Lock {
            name: "cab",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || vec![0, CHURCH.0, CHURCH.1 / 10, CHURCH.1 % 10],
            flag: "cab_open",
            msg: "zmsg.cab_open",
            needs: "",
        },
        Lock {
            name: "course",
            size: 10,
            start: &[0, 0, 0],
            code: || COURSE.to_vec(),
            flag: "course_set",
            msg: "zmsg.course_set",
            needs: "",
        },
        Lock {
            name: "valve",
            size: 10,
            start: &[0, 0, 0],
            code: || PANELS.to_vec(),
            flag: "done",
            msg: "zmsg.descend",
            needs: "aligned&bino",
        },
    ],
    dials: &[Dial {
        name: "slots",
        size: 3,
        start: &[0, 0, 0, 0],
        wrap: true,
        needs: "never",
        needs_msg: "",
        freeze: "",
    }],
    picks: &[
        Pick {
            spot: "cabinet",
            needs: "cab_open",
            locked_msg: "zmsg.cab_locked",
            got: "got_cab",
            give: &["zmagnet", "binoculars"],
            msg: "zmsg.cab_take",
        },
        Pick {
            spot: "paperweight",
            needs: "",
            locked_msg: "",
            got: "got_horseshoe",
            give: &["horseshoe"],
            msg: "zmsg.horseshoe",
        },
    ],
    uses: &[
        Use {
            item: "zmagnet",
            spot: "compass",
            needs: "",
            fail: "",
            keep: false,
            set: "mag1_in",
            give: &[],
            msg: "zmsg.magnet_in",
        },
        Use {
            item: "horseshoe",
            spot: "compass",
            needs: "",
            fail: "",
            keep: false,
            set: "mag2_in",
            give: &[],
            msg: "zmsg.magnet_in",
        },
        Use {
            item: "binoculars",
            spot: "window",
            needs: "",
            fail: "",
            keep: false,
            set: "bino",
            give: &[],
            msg: "zmsg.binoculars",
        },
    ],
    checks: &[Check {
        flag: "aligned",
        cond: |s| s.flag("course_set") && needle(s.val("slots")) == Some(course()),
        msg: "zmsg.aligned",
    }],
    looks: &[
        Look {
            spot: "compass",
            flag: "aligned",
            set: "zmsg.compass_true",
            unset: "zmsg.compass",
        },
        Look {
            spot: "window",
            flag: "aligned",
            set: "zmsg.valley",
            unset: "zmsg.glaciers",
        },
        Look {
            spot: "valves",
            flag: "done",
            set: "zmsg.descend",
            unset: "zmsg.valves",
        },
    ],
    flavour: &[
        "clock", "photo", "telegram", "book", "chart", "radio", "lamp", "wheel",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("cab_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_horseshoe"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("course_set"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("aligned"),
            available: |s| s.flag("course_set") && s.flag("mag1_in") && s.flag("mag2_in"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("aligned") && s.flag("bino"),
        },
    ],
    hint_views: &[
        ("Z1", &[2, 3, 4]),
        ("Z2", &[0, 1, 4]),
        ("zphoto", &[0]),
        ("zcab", &[0]),
        ("ztelegram", &[2]),
        ("zbook", &[2]),
        ("zcompass", &[3, 2]),
        ("zwindow", &[4]),
        ("zvalves", &[4]),
        ("zchart", &[1]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    #[test]
    fn one_setting_of_two_magnets_holds_the_course() {
        let mut hits = vec![];
        for code in 0..81u32 {
            let slots: Vec<u8> = (0..4).map(|k| (code / 3u32.pow(k) % 3) as u8).collect();
            let placed = slots.iter().filter(|v| **v != 0).count();
            if placed <= 2 && needle(&slots) == Some(course()) {
                hits.push((placed, slots));
            }
        }
        assert_eq!(hits, vec![(2, vec![2, 0, 1, 0])]);
        assert_ne!(needle(&[0, 0, 0, 0]), Some(course()));
    }

    #[test]
    fn the_airship_can_land() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "cab", &[0, 7, 3, 5], 10);
        msg(&mut r, "tap cabinet");
        msg(&mut r, "tap paperweight");
        assert_eq!(msg(&mut r, "slot 0"), "zmsg.no_magnet");
        msg(&mut r, "use zmagnet compass");
        msg(&mut r, "use horseshoe compass");
        msg(&mut r, "slot 0");
        msg(&mut r, "slot 0");
        msg(&mut r, "slot 2");
        assert!(!r.flag("aligned"), "the course is not set yet");
        turn_to(&mut r, "course", &COURSE, 10);
        assert!(r.flag("aligned"));
        turn_to(&mut r, "valve", &PANELS, 10);
        assert!(!r.done, "the valves wait for a look through the binoculars");
        msg(&mut r, "turn valve 0 +1");
        msg(&mut r, "use binoculars window");
        msg(&mut r, "turn valve 0 -1");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
