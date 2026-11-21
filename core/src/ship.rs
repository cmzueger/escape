//! Albatross (medium): the wheelhouse of a 1950s steamer in a storm, the
//! crew below and the ship listing. Five puzzles. Views: `V1` (wheel,
//! engine telegraph, windows on the storm and two lighthouses, the ship's
//! bell, the inclinometer, the log book) and `V2` (chart table, signal
//! locker, ballast panel with its diagram, the captain's cabinet).
//!
//! The ballast: three tanks (port, centre, starboard). Opening a valve
//! between two tanks lets the water settle level between them (an odd unit
//! stays in the fuller one); the centre tank can be flooded from the sea or
//! pumped dry. The ballast diagram is three plans printed over each other in
//! red, green and blue; coloured glass hides the strokes of its own colour.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// Engraved small on the ship's bell (the locker's lock shows a bell); the
/// brass plaque by the door shows the year of a refit instead.
pub const BELL_YEAR: [u8; 4] = [1, 9, 3, 8];
pub const PLAQUE_YEAR: [u8; 4] = [1, 9, 5, 1];
/// The diagram's three plans (port, centre, starboard), in red, green, blue.
/// The log book's last entry has a pennant of today's plan's colour.
pub const PLANS: [[u8; 3]; 3] = [[2, 6, 2], [5, 3, 5], [4, 5, 4]];
pub const TODAY: usize = 2;
pub const TANKS_START: [u8; 3] = [8, 5, 3];
pub const FULL: u8 = 8;
/// Two lighthouses through the windows: flashes in a group, left and right.
pub const SEEN: (u8, u8) = (2, 4);
/// The chart's three positions: the left and right lighthouse seen from
/// there, and the course to steer to the harbour.
pub const POSITIONS: [(u8, u8, [u8; 3]); 3] = [(4, 2, [0, 9, 5]), (2, 4, [3, 1, 0]), (3, 1, [1, 7, 0])];

fn settle(a: u8, b: u8) -> (u8, u8) {
    let (hi, lo) = ((a + b).div_ceil(2), (a + b) / 2);
    if a >= b {
        (hi, lo)
    } else {
        (lo, hi)
    }
}

/// One ballast operation: `pc`, `cs` (open the valve between two tanks),
/// `flood`, `pump` (the centre tank).
pub fn ballast(t: &[u8], op: &str) -> Option<Vec<u8>> {
    let mut t = t.to_vec();
    match op {
        "pc" => (t[0], t[1]) = settle(t[0], t[1]),
        "cs" => (t[1], t[2]) = settle(t[1], t[2]),
        "flood" => t[1] = FULL,
        "pump" => t[1] = 0,
        _ => return None,
    }
    Some(t)
}

pub fn course() -> Vec<u8> {
    POSITIONS
        .iter()
        .find(|(l, r, _)| (*l, *r) == SEEN)
        .map(|p| p.2.to_vec())
        .unwrap_or_default()
}

fn clues() -> String {
    let plans = PLANS
        .iter()
        .map(|p| format!("[{}]", nums_json(p)))
        .collect::<Vec<_>>()
        .join(",");
    let positions = POSITIONS
        .iter()
        .map(|(l, r, c)| format!("[{l},{r},[{}]]", nums_json(c)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"bell\":[{}],\"plaque\":[{}],\"plans\":[{plans}],\"today\":{TODAY},\"seen\":[{},{}],\"positions\":[{positions}]}}",
        nums_json(&BELL_YEAR),
        nums_json(&PLAQUE_YEAR),
        SEEN.0,
        SEEN.1
    )
}

/// `tank <pc|cs|flood|pump>`.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let ["tank", op] = words else {
        return None;
    };
    Some(if s.flag("level") {
        Ok(String::new())
    } else {
        match ballast(s.val("tanks"), op) {
            Some(t) => {
                *s.val_mut("tanks") = t;
                Ok(format!("smsg.tank_{op}"))
            }
            None => Err(bad("tank")),
        }
    })
}

/// Minutes for three stars (from tools/estimate.py, 2026-11-18).
pub const PAR_MINUTES: u32 = 6;

pub static SPEC: Spec = Spec {
    id: "ship",
    prefix: "s",
    par_minutes: PAR_MINUTES,
    flags: &[
        "locker_open",
        "got_locker",
        "glass_in",
        "level",
        "got_cab",
        "course_set",
        "done",
    ],
    items: &["filters", "telhandle"],
    locks: &[
        Lock {
            name: "locker",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || BELL_YEAR.to_vec(),
            flag: "locker_open",
            msg: "smsg.locker_open",
            needs: "",
        },
        Lock {
            name: "course",
            size: 10,
            start: &[0, 0, 0],
            code: course,
            flag: "course_set",
            msg: "smsg.course_set",
            needs: "level",
        },
    ],
    dials: &[
        Dial {
            name: "filt",
            size: 2,
            start: &[0, 0, 0],
            wrap: true,
            needs: "glass_in",
            needs_msg: "smsg.diagram_blur",
            freeze: "",
        },
        Dial {
            name: "tanks",
            size: FULL + 1,
            start: &TANKS_START,
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "locker",
            needs: "locker_open",
            locked_msg: "smsg.locker_locked",
            got: "got_locker",
            give: &["filters"],
            msg: "smsg.filters",
        },
        Pick {
            spot: "cabinet",
            needs: "level",
            locked_msg: "smsg.cab_jammed",
            got: "got_cab",
            give: &["telhandle"],
            msg: "smsg.telhandle",
        },
    ],
    uses: &[
        Use {
            item: "filters",
            spot: "diagram",
            needs: "",
            fail: "",
            keep: false,
            set: "glass_in",
            give: &[],
            msg: "smsg.glass_in",
        },
        Use {
            item: "telhandle",
            spot: "telegraph",
            needs: "course_set",
            fail: "smsg.no_course",
            keep: false,
            set: "done",
            give: &[],
            msg: "smsg.ahead",
        },
    ],
    checks: &[Check {
        flag: "level",
        cond: |s| s.flag("glass_in") && s.val("tanks") == PLANS[TODAY],
        msg: "smsg.level",
    }],
    looks: &[
        Look {
            spot: "telegraph",
            flag: "got_cab",
            set: "smsg.telegraph_ready",
            unset: "smsg.telegraph",
        },
        Look {
            spot: "diagram",
            flag: "glass_in",
            set: "smsg.diagram",
            unset: "smsg.diagram_blur",
        },
        Look {
            spot: "inclinometer",
            flag: "level",
            set: "smsg.upright",
            unset: "smsg.listing",
        },
    ],
    flavour: &[
        "bell", "plaque", "log", "chart", "wheel", "lights", "storm", "lamp", "panel",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("locker_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("glass_in"),
            available: |s| s.flag("got_locker"),
        },
        Puzzle {
            solved: |s| s.flag("level"),
            available: |s| s.flag("glass_in"),
        },
        Puzzle {
            solved: |s| s.flag("course_set"),
            available: |s| s.flag("level"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_cab") && s.flag("course_set"),
        },
    ],
    hint_views: &[
        ("V1", &[0, 3, 4]),
        ("V2", &[1, 2, 3]),
        ("vbell", &[0]),
        ("vlocker", &[0]),
        ("vdiagram", &[1, 2]),
        ("vlog", &[2]),
        ("vballast", &[2]),
        ("vwindow", &[3]),
        ("vchart", &[3]),
        ("vcompass", &[3]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    /// Fewest operations to today's plan: eight, and never a dead end.
    #[test]
    fn the_ballast_takes_eight_operations() {
        let ops = ["pc", "cs", "flood", "pump"];
        let goal = PLANS[TODAY].to_vec();
        let explore = |from: Vec<u8>| {
            let mut dist = std::collections::HashMap::from([(from.clone(), 0)]);
            let mut todo = std::collections::VecDeque::from([from]);
            while let Some(t) = todo.pop_front() {
                for op in ops {
                    let n = ballast(&t, op).unwrap();
                    if !dist.contains_key(&n) {
                        dist.insert(n.clone(), dist[&t] + 1);
                        todo.push_back(n);
                    }
                }
            }
            dist
        };
        let dist = explore(TANKS_START.to_vec());
        assert_eq!(dist.get(&goal), Some(&8));
        for t in dist.keys() {
            assert!(explore(t.clone()).contains_key(&goal), "dead end at {t:?}");
        }
        for (i, p) in PLANS.iter().enumerate() {
            assert_eq!(p[0], p[2], "plan {i} keeps the ship upright");
        }
    }

    #[test]
    fn the_mirrored_position_is_a_decoy() {
        assert_eq!(course(), vec![3, 1, 0]);
        assert!(POSITIONS.iter().any(|(l, r, _)| (*r, *l) == SEEN));
    }

    #[test]
    fn the_ship_reaches_harbour() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "locker", &BELL_YEAR, 10);
        msg(&mut r, "tap locker");
        assert_eq!(msg(&mut r, "turn filt 0 +1"), "smsg.diagram_blur");
        msg(&mut r, "use filters diagram");
        msg(&mut r, "flip filt 0");
        msg(&mut r, "flip filt 1");
        let mut last = String::new();
        for op in WAY {
            last = msg(&mut r, &format!("tank {op}"));
        }
        assert_eq!(last, "smsg.level");
        msg(&mut r, "tap cabinet");
        assert_eq!(msg(&mut r, "use telhandle telegraph"), "smsg.no_course");
        turn_to(&mut r, "course", &course(), 10);
        msg(&mut r, "use telhandle telegraph");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }

    /// A shortest way to today's plan (also used by the client test).
    const WAY: [&str; 8] = ["pc", "pump", "cs", "pc", "pump", "cs", "flood", "cs"];
}
