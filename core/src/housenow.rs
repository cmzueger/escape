//! The Quiet House · today (hard): the last of the family renovates Number
//! 7 and finds what Clara left. Six puzzles. Views: `X1` (the living room
//! under dust sheets: piano, tiled stove, telephone) and `X2` (Clara's room,
//! stripped: window onto the courtyard, the renovation plan, the walls).
//!
//! The roof seen from the courtyard is the plan's mirror image; the chimney
//! that never smokes belongs to a flue behind a bricked-up niche.

use crate::house::{lines_json, piano, played, talk, tune_json, Line};
use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The tune; Clara played it backwards on her last night.
pub const TUNE: [u8; 8] = [4, 2, 0, 2, 4, 5, 7, 4];
/// The archive in Paris (number on the record sleeve) and Clara's birth
/// year (she was 12 in 1905).
pub const PARIS: [u8; 4] = [0, 1, 4, 2];
pub const BORN: [u8; 4] = [1, 8, 9, 3];
/// The six wall segments of Clara's room (left to right on the plan); the
/// hidden flue is behind this one.
pub const WALLS: usize = 6;
pub const NICHE: usize = 3;
/// The three flues on the plan (left to right): the stove's, the
/// neighbour's, the hidden one. Seen from the courtyard they are mirrored.
pub const FLUES: [u8; 3] = [0, 1, 2];

pub fn backwards() -> Vec<u8> {
    TUNE.iter().rev().copied().collect()
}

pub static LINES: [Line; 3] = [
    Line {
        text: "xtalk.1",
        choices: &[("xsay.1a", 2), ("xsay.1b", 0), ("xsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "xtalk.2",
        choices: &[("xsay.2a", 0), ("xsay.2b", 3)],
        sets: "",
    },
    Line {
        text: "xtalk.3",
        choices: &[("xsay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"tune\":{},\"paris\":[{}],\"walls\":{WALLS},\"niche\":{NICHE},\"lines\":[{}]}}",
        tune_json(&TUNE),
        nums_json(&PARIS),
        lines_json(&LINES)
    )
}

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let ["tap", spot] = words {
        if spot
            .strip_prefix("wall")
            .and_then(|i| i.parse::<usize>().ok())
            .is_some_and(|i| i < WALLS)
        {
            return Some(Ok("xmsg.wall".into()));
        }
    }
    piano(s, words).or_else(|| talk(s, words, &LINES, "dialled", "x"))
}

macro_rules! wall {
    ($spot:literal) => {
        Use {
            item: "hammer",
            spot: $spot,
            needs: "",
            fail: "",
            keep: true,
            set: "",
            give: &[],
            msg: "xmsg.solid",
        }
    };
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 12;

pub static SPEC: Spec = Spec {
    id: "housenow",
    prefix: "x",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_notes",
        "tune_ok",
        "got_xkey",
        "got_tools",
        "draught",
        "fire",
        "niche_open",
        "dialled",
        "told",
        "done",
    ],
    items: &["xkey", "hammer", "matches"],
    locks: &[
        Lock {
            name: "phone",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || PARIS.to_vec(),
            flag: "dialled",
            msg: "xmsg.dialled",
            needs: "got_notes",
        },
        Lock {
            name: "box",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || BORN.to_vec(),
            flag: "done",
            msg: "xmsg.box_open",
            needs: "told&niche_open",
        },
    ],
    dials: &[
        Dial {
            name: "damper",
            size: 2,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "fire",
        },
        Dial {
            name: "played",
            size: 9,
            start: &[0, 0, 0, 0, 0, 0, 0, 0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "talk",
            size: 8,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "tile",
            needs: "",
            locked_msg: "",
            got: "got_notes",
            give: &[],
            msg: "xmsg.notes",
        },
        Pick {
            spot: "pianolid",
            needs: "tune_ok",
            locked_msg: "xmsg.lid_shut",
            got: "got_xkey",
            give: &["xkey"],
            msg: "xmsg.xkey",
        },
    ],
    uses: &[
        Use {
            item: "xkey",
            spot: "toolbox",
            needs: "",
            fail: "",
            keep: false,
            set: "got_tools",
            give: &["hammer", "matches"],
            msg: "xmsg.tools",
        },
        Use {
            item: "matches",
            spot: "stove",
            needs: "draught",
            fail: "xmsg.smoky",
            keep: false,
            set: "fire",
            give: &[],
            msg: "xmsg.fire",
        },
        Use {
            item: "hammer",
            spot: "wall3",
            needs: "fire",
            fail: "xmsg.solid",
            keep: false,
            set: "niche_open",
            give: &[],
            msg: "xmsg.niche",
        },
        wall!("wall0"),
        wall!("wall1"),
        wall!("wall2"),
        wall!("wall4"),
        wall!("wall5"),
    ],
    checks: &[
        Check {
            flag: "tune_ok",
            cond: |s| s.flag("got_notes") && played(s, &backwards()),
            msg: "xmsg.tune_ok",
        },
        Check {
            flag: "draught",
            cond: |s| s.val("damper")[0] == 1,
            msg: "",
        },
    ],
    looks: &[
        Look {
            spot: "stove",
            flag: "fire",
            set: "xmsg.stove_warm",
            unset: "xmsg.stove_cold",
        },
        Look {
            spot: "court",
            flag: "fire",
            set: "xmsg.court_smoke",
            unset: "xmsg.court",
        },
        Look {
            spot: "toolbox",
            flag: "got_tools",
            set: "xmsg.toolbox_open",
            unset: "xmsg.toolbox_locked",
        },
    ],
    flavour: &[
        "plan", "ladder", "sheet", "notes", "radiator", "window", "wall", "piano",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_notes"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("tune_ok"),
            available: |s| s.flag("got_notes"),
        },
        Puzzle {
            solved: |s| s.flag("fire"),
            available: |s| s.flag("got_tools"),
        },
        Puzzle {
            solved: |s| s.flag("niche_open"),
            available: |s| s.flag("fire"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("got_notes"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("told") && s.flag("niche_open"),
        },
    ],
    hint_views: &[
        ("X1", &[0, 1, 2, 4]),
        ("X2", &[3, 5]),
        ("xstove", &[0, 2]),
        ("xnotes", &[1, 4, 5]),
        ("xpiano", &[1]),
        ("xcourt", &[3]),
        ("xplan", &[3]),
        ("xwall", &[3, 5]),
        ("xphone", &[4]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::house::say_all;
    use crate::kit::{msg, turn_to};

    #[test]
    fn clara_is_found() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap tile");
        for k in TUNE {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(!r.flag("tune_ok"), "forwards is not how she played it last");
        for k in backwards() {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(r.flag("tune_ok"));
        msg(&mut r, "tap pianolid");
        msg(&mut r, "use xkey toolbox");
        assert_eq!(msg(&mut r, "use matches stove"), "xmsg.smoky");
        msg(&mut r, "turn damper 0 +1");
        msg(&mut r, "use matches stove");
        assert_eq!(msg(&mut r, "use hammer wall2"), "xmsg.solid");
        msg(&mut r, "use hammer wall3");
        turn_to(&mut r, "phone", &PARIS, 10);
        say_all(&mut r, &[0, 0]);
        assert!(!r.flag("told"));
        say_all(&mut r, &[0, 1, 0]);
        turn_to(&mut r, "box", &BORN, 10);
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
