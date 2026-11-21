//! The Quiet House · 1905 (easy): Marie, the young maid, on the night Clara
//! vanished. Six puzzles. Views: `H1` (the parlour: piano, tiled stove,
//! clock, door) and `H2` (Clara's room: bed, window, wardrobe, desk with the
//! music box).

use crate::house::{piano, played, tune_json};
use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The music box's tune, as piano keys (Clara's coloured stickers).
pub const TUNE: [u8; 5] = [4, 2, 0, 2, 4];
/// Clara's clef stickers: dots on the small (clock), medium (stove tile) and
/// large (bed's headboard) one.
pub const CLEFS: [u8; 3] = [3, 7, 1];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"tune\":{},\"box\":{},\"clefs\":[{}]}}",
        tune_json(&TUNE),
        tune_json(&TUNE),
        nums_json(&CLEFS)
    )
}

/// The piano, and `listen box` (the music box, once wound).
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words == ["listen", "box"] {
        return Some(Ok(if s.flag("wound") {
            "hmsg.box_plays"
        } else {
            "hmsg.box_still"
        }
        .into()));
    }
    piano(s, words)
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 5;

pub static SPEC: Spec = Spec {
    id: "house1905",
    prefix: "h",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_crank",
        "wound",
        "tune_ok",
        "got_wkey",
        "ward_open",
        "hat_open",
        "got_hat",
        "done",
    ],
    items: &["hcrank", "wkey", "hdoorkey"],
    locks: &[Lock {
        name: "hat",
        size: 10,
        start: &[0, 0, 0],
        code: || CLEFS.to_vec(),
        flag: "hat_open",
        msg: "hmsg.hat_open",
        needs: "ward_open",
    }],
    dials: &[Dial {
        name: "played",
        size: 9,
        start: &[0, 0, 0, 0, 0],
        wrap: false,
        needs: "never",
        needs_msg: "",
        freeze: "",
    }],
    picks: &[
        Pick {
            spot: "pillow",
            needs: "",
            locked_msg: "",
            got: "got_crank",
            give: &["hcrank"],
            msg: "hmsg.crank",
        },
        Pick {
            spot: "pianolid",
            needs: "tune_ok",
            locked_msg: "hmsg.lid_shut",
            got: "got_wkey",
            give: &["wkey"],
            msg: "hmsg.wkey",
        },
        Pick {
            spot: "hatbox",
            needs: "hat_open",
            locked_msg: "hmsg.hat_locked",
            got: "got_hat",
            give: &["hdoorkey"],
            msg: "hmsg.farewell",
        },
    ],
    uses: &[
        Use {
            item: "hcrank",
            spot: "musicbox",
            needs: "",
            fail: "",
            keep: false,
            set: "wound",
            give: &[],
            msg: "hmsg.box_plays",
        },
        Use {
            item: "wkey",
            spot: "wardrobe",
            needs: "",
            fail: "",
            keep: false,
            set: "ward_open",
            give: &[],
            msg: "hmsg.ward_open",
        },
        Use {
            item: "hdoorkey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "hmsg.door_open",
        },
    ],
    checks: &[Check {
        flag: "tune_ok",
        cond: |s| s.flag("wound") && played(s, &TUNE),
        msg: "hmsg.tune_ok",
    }],
    looks: &[
        Look {
            spot: "musicbox",
            flag: "wound",
            set: "hmsg.box_plays",
            unset: "hmsg.box_still",
        },
        Look {
            spot: "wardrobe",
            flag: "ward_open",
            set: "hmsg.ward_inside",
            unset: "hmsg.ward_locked",
        },
        Look {
            spot: "door",
            flag: "done",
            set: "hmsg.door_open",
            unset: "hmsg.door_locked",
        },
    ],
    flavour: &["clock", "stove", "bed", "window", "desk", "piano", "lamp", "note"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_crank"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("wound"),
            available: |s| s.flag("got_crank"),
        },
        Puzzle {
            solved: |s| s.flag("tune_ok"),
            available: |s| s.flag("wound"),
        },
        Puzzle {
            solved: |s| s.flag("ward_open"),
            available: |s| s.flag("got_wkey"),
        },
        Puzzle {
            solved: |s| s.flag("hat_open"),
            available: |s| s.flag("ward_open"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_hat"),
        },
    ],
    hint_views: &[
        ("H1", &[2, 4, 5]),
        ("H2", &[0, 1, 3, 4]),
        ("hbox", &[1, 2]),
        ("hpiano", &[2]),
        ("hbed", &[0, 4]),
        ("hclock", &[4]),
        ("hstove", &[4]),
        ("hhat", &[4]),
        ("hnote", &[5]),
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

    #[test]
    fn marie_gets_out() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "listen box"), "hmsg.box_still");
        msg(&mut r, "tap pillow");
        msg(&mut r, "use hcrank musicbox");
        assert_eq!(msg(&mut r, "listen box"), "hmsg.box_plays");
        for k in [1, 4, 2, 0, 2] {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(!r.flag("tune_ok"));
        msg(&mut r, "key 4");
        assert!(r.flag("tune_ok"));
        msg(&mut r, "tap pianolid");
        turn_to(&mut r, "hat", &CLEFS, 10);
        assert!(!r.flag("hat_open"), "the hatbox is in the locked wardrobe");
        msg(&mut r, "turn hat 0 +1");
        msg(&mut r, "use wkey wardrobe");
        msg(&mut r, "turn hat 0 -1");
        msg(&mut r, "tap hatbox");
        msg(&mut r, "use hdoorkey door");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
