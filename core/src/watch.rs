//! The Watchmaker (medium): an old workshop, five puzzles about time.
//! Views: `W1` (bench, wall of clocks, drawers) and `W2` (the tall clock,
//! the shop door).

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The four wall clocks (hour, minute); only one pendulum swings.
pub const CLOCKS: [(u8, u8); 4] = [(3, 50), (8, 35), (11, 5), (6, 20)];
pub const SWINGING: usize = 1;
/// The time engraved, very small, inside the pocket watch's back.
pub const ENGRAVED: (u8, u8) = (4, 10);
/// The order of the parts on the diagram.
pub const PARTS: [&str; 3] = ["spring", "gearw", "balance"];
/// The number inside the lid of the running watch.
pub const LID: [u8; 3] = [6, 1, 8];

fn drawer_code() -> Vec<u8> {
    let (h, m) = CLOCKS[SWINGING];
    vec![h / 10, h % 10, m / 10, m % 10]
}

fn clues() -> String {
    let clocks = CLOCKS
        .iter()
        .map(|(h, m)| format!("[{h},{m}]"))
        .collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"clocks\":[{}],\"swinging\":{SWINGING},\"engraved\":[{},{}],\"parts\":[\"spring\",\"gearw\",\"balance\"],\"lid\":[{}]}}",
        clocks.join(","),
        ENGRAVED.0,
        ENGRAVED.1,
        nums_json(&LID)
    )
}

fn extra(s: &State) -> String {
    format!(",\"built\":{}", s.val("built")[0])
}

/// `use <part> watch`: the parts go in in the diagram's order.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words.len() != 3
        || words[0] != "use"
        || words[2] != "watch"
        || !PARTS.contains(&words[1])
        || !s.has(words[1])
    {
        return None;
    }
    let built = usize::from(s.val("built")[0]);
    Some(Ok(if PARTS[built] == words[1] {
        s.take(words[1]);
        s.val_mut("built")[0] += 1;
        if built + 1 == PARTS.len() {
            s.set("watch_runs");
            "wmsg.watch_runs".into()
        } else {
            "wmsg.part_in".into()
        }
    } else {
        "wmsg.part_wrong".into()
    }))
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 4;

pub static SPEC: Spec = Spec {
    id: "watch",
    prefix: "w",
    par_minutes: PAR_MINUTES,
    flags: &[
        "drawer_open",
        "got_drawer",
        "seen",
        "case_open",
        "got_case",
        "got_gear",
        "watch_runs",
        "done",
    ],
    items: &["loupe", "spring", "gearw", "balance"],
    locks: &[
        Lock {
            name: "drawer",
            size: 10,
            start: &[0, 0, 0, 0],
            code: drawer_code,
            flag: "drawer_open",
            msg: "wmsg.drawer_open",
            needs: "",
        },
        Lock {
            name: "door",
            size: 10,
            start: &[0, 0, 0],
            code: || LID.to_vec(),
            flag: "done",
            msg: "wmsg.door_open",
            needs: "watch_runs",
        },
    ],
    dials: &[
        Dial {
            name: "tall",
            size: 12,
            start: &[0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "case_open",
        },
        Dial {
            name: "built",
            size: 4,
            start: &[0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "drawer",
            needs: "drawer_open",
            locked_msg: "wmsg.drawer_locked",
            got: "got_drawer",
            give: &["loupe", "spring"],
            msg: "wmsg.drawer_take",
        },
        Pick {
            spot: "tallcase",
            needs: "case_open",
            locked_msg: "wmsg.case_shut",
            got: "got_case",
            give: &["balance"],
            msg: "wmsg.balance",
        },
        Pick {
            spot: "loosegear",
            needs: "",
            locked_msg: "",
            got: "got_gear",
            give: &["gearw"],
            msg: "wmsg.gear",
        },
    ],
    uses: &[Use {
        item: "loupe",
        spot: "watch",
        needs: "",
        fail: "",
        keep: false,
        set: "seen",
        give: &[],
        msg: "wmsg.seen",
    }],
    checks: &[Check {
        flag: "case_open",
        cond: |s| s.flag("seen") && s.val("tall") == [ENGRAVED.0 % 12, ENGRAVED.1 / 5],
        msg: "wmsg.case_open",
    }],
    looks: &[
        Look {
            spot: "watch",
            flag: "watch_runs",
            set: "wmsg.watch_lid",
            unset: "wmsg.watch",
        },
        Look {
            spot: "door",
            flag: "",
            set: "wmsg.door",
            unset: "wmsg.door",
        },
    ],
    flavour: &["tools", "stool", "cat", "sign", "lampw"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("drawer_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("seen"),
            available: |s| s.flag("got_drawer"),
        },
        Puzzle {
            solved: |s| s.flag("case_open"),
            available: |s| s.flag("seen"),
        },
        Puzzle {
            solved: |s| s.flag("watch_runs"),
            available: |s| s.flag("got_case"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("watch_runs"),
        },
    ],
    hint_views: &[
        ("W1", &[0, 1, 3]),
        ("W2", &[2, 4]),
        ("wclocks", &[0]),
        ("wdrawer", &[0]),
        ("wwatch", &[1, 3, 4]),
        ("wplan", &[3]),
        ("wtall", &[2]),
        ("wdoor", &[4]),
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
    fn the_workshop_can_be_left() {
        let mut r = State::new(&SPEC);
        assert_eq!(drawer_code(), [0, 8, 3, 5]);
        turn_to(&mut r, "drawer", &drawer_code(), 10);
        msg(&mut r, "tap drawer");
        msg(&mut r, "tap loosegear");
        turn_to(&mut r, "tall", &[4, 2], 12);
        assert!(!r.flag("case_open"), "nobody has read the engraving yet");
        msg(&mut r, "turn tall 0 +1");
        assert_eq!(msg(&mut r, "use loupe watch"), "wmsg.seen");
        assert_eq!(msg(&mut r, "turn tall 0 -1"), "wmsg.case_open");
        msg(&mut r, "tap tallcase");
        assert_eq!(msg(&mut r, "use balance watch"), "wmsg.part_wrong");
        assert_eq!(msg(&mut r, "use spring watch"), "wmsg.part_in");
        msg(&mut r, "use gearw watch");
        assert_eq!(msg(&mut r, "use balance watch"), "wmsg.watch_runs");
        turn_to(&mut r, "door", &LID, 10);
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
