//! Gondola 12 (medium): a cable car stopped halfway on a snowy morning, on
//! its way down to the valley. Six puzzles. Views: `Q1` (front window,
//! emergency panel, door) and `Q2` (bench and backpack, piste map, sunny
//! side window with a wooden sculpture on a turntable, first-aid box).
//!
//! The sculpture is built so that its shadow shows a different digit from
//! the front and from the side (and mirrored digits from behind); the
//! turntable's base marks which shadow belongs to which wheel of the first-aid
//! box. The emergency drive must head for the nearer station.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The piste map's three numbered runs, in the backpack lock's colours
/// (blue, red, black).
pub const PISTES: [u8; 3] = [4, 8, 2];
/// The sculpture's two silhouettes, 3 wide by 5 high, top row first: from
/// the front a 2, from the side a 4. From behind the front one is mirrored
/// (a 5). Turntable positions 0..3 show front, side, behind, other side.
pub const FRONT: [&str; 5] = ["111", "001", "111", "100", "111"];
pub const SIDE: [&str; 5] = ["101", "101", "111", "001", "001"];
/// The first-aid box's wheels, marked with one, two and three dots, take
/// the shadows at the base marks with one, two and three dots: positions 0,
/// 1 and 2.
pub const SHADOW_CODE: [u8; 3] = [2, 4, 5];
/// Pylons along the line, numbered from the valley station; the cabin hangs
/// between `AHEAD` (downhill, the way it was going) and the next one up.
pub const PYLONS: u8 = 9;
pub const AHEAD: u8 = 7;
/// The direction lever: down to the valley, stop, up to the top station.
pub const DOWN: u8 = 0;
pub const UP: u8 = 2;

/// Spans to each station from between pylon `AHEAD` and `AHEAD + 1`.
pub fn spans() -> (u8, u8) {
    (AHEAD, PYLONS - AHEAD)
}

fn clues() -> String {
    let rows = |v: &[&str]| v.iter().map(|r| format!("\"{r}\"")).collect::<Vec<_>>().join(",");
    format!(
        "{{\"ok\":true,\"pistes\":[{}],\"front\":[{}],\"side\":[{}],\"pylons\":{PYLONS},\"ahead\":{AHEAD}}}",
        nums_json(&PISTES),
        rows(&FRONT),
        rows(&SIDE)
    )
}

/// `start`: the panel's green button.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words != ["start"] {
        return None;
    }
    let dir = s.val("dir")[0];
    let (down, up) = spans();
    let near = if up < down { UP } else { DOWN };
    Some(Ok(if !s.flag("fuse_in") {
        "qmsg.panel_dead"
    } else if s.val("brake")[0] == 0 {
        "qmsg.brake_on"
    } else if dir == 1 {
        "qmsg.dir_stop"
    } else if dir != near {
        s.val_mut("dir")[0] = 1;
        "qmsg.too_far"
    } else {
        s.set("done");
        "qmsg.going"
    }
    .into()))
}

/// Minutes for three stars (planned with the owner, 2026-11-17).
pub const PAR_MINUTES: u32 = 12;

pub static SPEC: Spec = Spec {
    id: "gondola",
    prefix: "q",
    par_minutes: PAR_MINUTES,
    flags: &[
        "bag_open",
        "got_bag",
        "kit_open",
        "got_kit",
        "cover_off",
        "fuse_in",
        "brake_off",
        "done",
    ],
    items: &["multitool", "qfuse"],
    locks: &[
        Lock {
            name: "bag",
            size: 10,
            start: &[0, 0, 0],
            code: || PISTES.to_vec(),
            flag: "bag_open",
            msg: "qmsg.bag_open",
            needs: "",
        },
        Lock {
            name: "kit",
            size: 10,
            start: &[0, 0, 0],
            code: || SHADOW_CODE.to_vec(),
            flag: "kit_open",
            msg: "qmsg.kit_open",
            needs: "",
        },
    ],
    dials: &[
        Dial {
            name: "turn",
            size: 4,
            start: &[3],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "brake",
            size: 2,
            start: &[0],
            wrap: false,
            needs: "fuse_in",
            needs_msg: "qmsg.panel_dead",
            freeze: "done",
        },
        Dial {
            name: "dir",
            size: 3,
            start: &[1],
            wrap: false,
            needs: "fuse_in",
            needs_msg: "qmsg.panel_dead",
            freeze: "done",
        },
    ],
    picks: &[
        Pick {
            spot: "bag",
            needs: "bag_open",
            locked_msg: "qmsg.bag_locked",
            got: "got_bag",
            give: &["multitool"],
            msg: "qmsg.multitool",
        },
        Pick {
            spot: "kit",
            needs: "kit_open",
            locked_msg: "qmsg.kit_locked",
            got: "got_kit",
            give: &["qfuse"],
            msg: "qmsg.fuse",
        },
    ],
    uses: &[
        Use {
            item: "multitool",
            spot: "panel",
            needs: "",
            fail: "",
            keep: false,
            set: "cover_off",
            give: &[],
            msg: "qmsg.cover_off",
        },
        Use {
            item: "qfuse",
            spot: "panel|fuseslot",
            needs: "cover_off",
            fail: "qmsg.cover_on",
            keep: false,
            set: "fuse_in",
            give: &[],
            msg: "qmsg.fuse_in",
        },
    ],
    checks: &[Check {
        flag: "brake_off",
        cond: |s| s.flag("fuse_in") && s.val("brake")[0] == 1,
        msg: "qmsg.brake_off",
    }],
    looks: &[
        Look {
            spot: "panel",
            flag: "cover_off",
            set: "qmsg.panel_open",
            unset: "qmsg.cover_on",
        },
        Look {
            spot: "fuseslot",
            flag: "fuse_in",
            set: "qmsg.fuse_ok",
            unset: "qmsg.fuse_empty",
        },
    ],
    flavour: &[
        "skis",
        "bench",
        "valley",
        "door",
        "sun",
        "sculpture",
        "pylon",
        "card",
        "map",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("bag_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("kit_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("cover_off"),
            available: |s| s.flag("got_bag"),
        },
        Puzzle {
            solved: |s| s.flag("fuse_in"),
            available: |s| s.flag("got_kit") && s.flag("cover_off"),
        },
        Puzzle {
            solved: |s| s.flag("brake_off"),
            available: |s| s.flag("fuse_in"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("fuse_in"),
        },
    ],
    hint_views: &[
        ("Q1", &[2, 3, 4, 5]),
        ("Q2", &[0, 1]),
        ("qmap", &[0, 5]),
        ("qbag", &[0]),
        ("qsill", &[1]),
        ("qkit", &[1, 4]),
        ("qpanel", &[2, 3, 4, 5]),
        ("qwindow", &[5]),
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
    fn the_shadows_make_the_code() {
        let mirror = |rows: &[&str]| {
            rows.iter()
                .map(|r| r.chars().rev().collect::<String>())
                .collect::<Vec<_>>()
        };
        // From behind, the 2 becomes a 5 (as on a seven-segment display).
        assert_eq!(mirror(&FRONT), ["111", "100", "111", "001", "111"]);
        // Every row of each silhouette has a block, so one sculpture casts both.
        assert!(FRONT
            .iter()
            .zip(SIDE)
            .all(|(f, s)| f.contains('1') && s.contains('1')));
        let (down, up) = spans();
        assert!(
            up < down,
            "the top station is nearer although the cabin was going down"
        );
    }

    #[test]
    fn the_gondola_reaches_a_station() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "bag", &PISTES, 10);
        msg(&mut r, "tap bag");
        turn_to(&mut r, "kit", &SHADOW_CODE, 10);
        msg(&mut r, "tap kit");
        assert_eq!(msg(&mut r, "use qfuse panel"), "qmsg.cover_on");
        msg(&mut r, "use multitool panel");
        assert_eq!(msg(&mut r, "start"), "qmsg.panel_dead");
        msg(&mut r, "use qfuse panel");
        assert_eq!(msg(&mut r, "start"), "qmsg.brake_on");
        assert_eq!(msg(&mut r, "turn brake 0 +1"), "qmsg.brake_off");
        assert_eq!(msg(&mut r, "start"), "qmsg.dir_stop");
        msg(&mut r, "turn dir 0 -1");
        assert_eq!(msg(&mut r, "start"), "qmsg.too_far");
        assert_eq!(r.val("dir"), [1]);
        msg(&mut r, "turn dir 0 +1");
        assert_eq!(msg(&mut r, "start"), "qmsg.going");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
