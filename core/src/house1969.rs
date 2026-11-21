//! The Quiet House · 1969 (medium): you rent Clara's old room from Mrs Jost.
//! Five puzzles. Views: `U1` (the living room: piano, tiled stove, record
//! player) and `U2` (the student room: window onto the courtyard, desk,
//! intercom).
//!
//! The tune is split: an old record plays its first half (only at the
//! right speed), the broken music box its second half. Berta's sketch of the
//! courtyard was drawn from the other side, so it is mirrored.

use crate::house::{lines_json, piano, played, talk, tune_json, Line};
use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

pub const RECORD_HALF: [u8; 4] = [4, 2, 0, 2];
pub const BOX_HALF: [u8; 4] = [4, 5, 7, 4];
/// The record player's speeds (33, 45, 78); the shellac record wants 78.
pub const SPEED: u8 = 2;
/// The courtyard's nine windows (top row first, as seen from this room) and
/// the three numbered flowerpots in each; Berta marked the top-left window
/// of her sketch, drawn from the other side: the top-right one here.
pub const POTS: [[u8; 3]; 9] = [
    [9, 1, 3],
    [4, 4, 0],
    [5, 2, 8],
    [2, 7, 1],
    [6, 0, 6],
    [3, 3, 9],
    [8, 1, 2],
    [0, 5, 7],
    [1, 9, 4],
];
pub const SKETCH_MARK: usize = 0;
pub const MARKED: usize = 2;

pub fn tune() -> Vec<u8> {
    [RECORD_HALF, BOX_HALF].concat()
}

pub static LINES: [Line; 4] = [
    Line {
        text: "utalk.1",
        choices: &[("usay.1a", 0), ("usay.1b", 2), ("usay.1c", 0)],
        sets: "",
    },
    Line {
        text: "utalk.2",
        choices: &[("usay.2a", 0), ("usay.2b", 0), ("usay.2c", 3)],
        sets: "",
    },
    Line {
        text: "utalk.3",
        choices: &[("usay.3a", 4), ("usay.3b", 0), ("usay.3c", 0)],
        sets: "",
    },
    Line {
        text: "utalk.4",
        choices: &[("usay.4a", 0)],
        sets: "done",
    },
];

fn clues() -> String {
    let pots = POTS
        .iter()
        .map(|p| format!("[{}]", nums_json(p)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"record\":{},\"box\":{},\"speed\":{SPEED},\"pots\":[{pots}],\"sketch\":{SKETCH_MARK},\"lines\":[{}]}}",
        tune_json(&RECORD_HALF),
        tune_json(&BOX_HALF),
        lines_json(&LINES)
    )
}

/// `listen record`, `listen box`, the piano, the intercom.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["listen", "record"] => Some(Ok(if s.val("speed")[0] == SPEED {
            s.set("heard");
            "umsg.record_plays"
        } else {
            "umsg.record_wrong"
        }
        .into())),
        ["listen", "box"] => Some(Ok("umsg.box_plays".into())),
        _ => piano(s, words).or_else(|| talk(s, words, &LINES, "intercom", "u")),
    }
}

/// Minutes for three stars (from tools/estimate.py, 2026-11-18).
pub const PAR_MINUTES: u32 = 6;

pub static SPEC: Spec = Spec {
    id: "house1969",
    prefix: "u",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_notes",
        "heard",
        "tune_ok",
        "got_glass",
        "glass_on",
        "drawer_open",
        "got_handset",
        "intercom",
        "done",
    ],
    items: &["uglass", "handset"],
    locks: &[Lock {
        name: "drawer",
        size: 10,
        start: &[0, 0, 0],
        code: || POTS[MARKED].to_vec(),
        flag: "drawer_open",
        msg: "umsg.drawer_open",
        needs: "glass_on&got_notes",
    }],
    dials: &[
        Dial {
            name: "speed",
            size: 3,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
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
            msg: "umsg.notes",
        },
        Pick {
            spot: "bench",
            needs: "tune_ok",
            locked_msg: "umsg.bench_shut",
            got: "got_glass",
            give: &["uglass"],
            msg: "umsg.glass",
        },
        Pick {
            spot: "drawer",
            needs: "drawer_open",
            locked_msg: "umsg.drawer_locked",
            got: "got_handset",
            give: &["handset"],
            msg: "umsg.handset",
        },
    ],
    uses: &[
        Use {
            item: "uglass",
            spot: "court",
            needs: "",
            fail: "",
            keep: false,
            set: "glass_on",
            give: &[],
            msg: "umsg.glass_on",
        },
        Use {
            item: "handset",
            spot: "intercom",
            needs: "",
            fail: "",
            keep: false,
            set: "intercom",
            give: &[],
            msg: "umsg.intercom_on",
        },
    ],
    checks: &[Check {
        flag: "tune_ok",
        cond: |s| s.flag("heard") && played(s, &tune()),
        msg: "umsg.tune_ok",
    }],
    looks: &[
        Look {
            spot: "intercom",
            flag: "intercom",
            set: "umsg.intercom_ready",
            unset: "umsg.intercom_dead",
        },
        Look {
            spot: "court",
            flag: "glass_on",
            set: "umsg.court_close",
            unset: "umsg.court",
        },
    ],
    flavour: &[
        "stove", "tv", "poster", "sleeve", "sketch", "door", "lamp", "notes",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_notes"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("heard"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("tune_ok"),
            available: |s| s.flag("heard"),
        },
        Puzzle {
            solved: |s| s.flag("drawer_open"),
            available: |s| s.flag("glass_on") && s.flag("got_notes"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("intercom"),
        },
    ],
    hint_views: &[
        ("U1", &[0, 1, 2]),
        ("U2", &[3, 4]),
        ("ustove", &[0]),
        ("unotes", &[3, 4]),
        ("urecord", &[1, 2]),
        ("ubox", &[2]),
        ("upiano", &[2]),
        ("ucourt", &[3]),
        ("udesk", &[3]),
        ("uintercom", &[4]),
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
    fn the_student_gets_out() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap tile");
        assert_eq!(msg(&mut r, "listen record"), "umsg.record_wrong");
        msg(&mut r, "turn speed 0 +1");
        msg(&mut r, "turn speed 0 +1");
        assert_eq!(msg(&mut r, "listen record"), "umsg.record_plays");
        for k in tune() {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(r.flag("tune_ok"));
        msg(&mut r, "tap bench");
        turn_to(&mut r, "drawer", &POTS[SKETCH_MARK], 10);
        assert!(!r.flag("drawer_open"), "not before looking through the glasses");
        msg(&mut r, "use uglass court");
        turn_to(&mut r, "drawer", &POTS[SKETCH_MARK], 10);
        msg(&mut r, "turn drawer 0 +1");
        msg(&mut r, "turn drawer 0 -1");
        assert!(!r.flag("drawer_open"), "the unmirrored window is a decoy");
        turn_to(&mut r, "drawer", &POTS[MARKED], 10);
        msg(&mut r, "tap drawer");
        msg(&mut r, "use handset intercom");
        say_all(&mut r, &[0]);
        assert!(!r.done);
        say_all(&mut r, &[1, 2, 0]);
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
