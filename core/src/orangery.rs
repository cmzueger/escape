//! The Orangery (easy): a greenhouse in the evening sun, eight puzzles.
//! Views: `G1` (the bench wall with the door) and `G2` (pond, sundial, shed).

#[cfg(test)]
use crate::kit::State;
use crate::kit::{no_extra, no_hook, Check, Dial, Lock, Look, Pick, Puzzle, Spec, Use};
use crate::strs_json;

/// What the seed cabinet's plaque asks for: the sundial's hour, the lilies
/// on the pond, the butterflies over the bench.
pub const SUN_HOUR: u8 = 7;
pub const LILIES: u8 = 5;
pub const BUTTERFLIES: u8 = 3;
/// The colours on the door's wheels.
pub const COLOURS: [&str; 6] = ["red", "yellow", "blue", "white", "violet", "orange"];
/// The grown flower's blossoms from the top down; the bottle's note says to
/// read them from the bottom up.
pub const BLOSSOMS: [&str; 4] = ["white", "red", "violet", "yellow"];
/// The valves that send water to the fountain: open, shut, open.
pub const VALVES: [u8; 3] = [1, 0, 1];

fn cabinet_code() -> Vec<u8> {
    vec![SUN_HOUR, LILIES, BUTTERFLIES]
}

pub fn door_code() -> Vec<u8> {
    BLOSSOMS
        .iter()
        .rev()
        .map(|c| COLOURS.iter().position(|k| k == c).expect("a wheel colour") as u8)
        .collect()
}

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"sun_hour\":{SUN_HOUR},\"lilies\":{LILIES},\"butterflies\":{BUTTERFLIES},\"colours\":[{}],\"blossoms\":[{}]}}",
        strs_json(&COLOURS),
        strs_json(&BLOSSOMS)
    )
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 4;

pub static SPEC: Spec = Spec {
    id: "orangery",
    prefix: "g",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_can",
        "bloomed",
        "shed_open",
        "got_shed",
        "gnomon_on",
        "cab_open",
        "got_cab",
        "dug",
        "planted",
        "grown",
        "wheel_on",
        "fountain",
        "got_bottle",
        "done",
    ],
    items: &["wcan", "fullcan", "skey", "trowel", "gnomon", "bulb", "wheel"],
    locks: &[
        Lock {
            name: "cab",
            size: 10,
            start: &[0, 0, 0],
            code: cabinet_code,
            flag: "cab_open",
            msg: "gmsg.cab_open",
            needs: "",
        },
        Lock {
            name: "door",
            size: 6,
            start: &[0, 0, 0, 0],
            code: door_code,
            flag: "done",
            msg: "gmsg.door_open",
            needs: "grown&got_bottle",
        },
    ],
    dials: &[Dial {
        name: "valves",
        size: 2,
        start: &[0, 1, 1],
        wrap: true,
        needs: "wheel_on",
        needs_msg: "gmsg.valves_stuck",
        freeze: "fountain",
    }],
    picks: &[
        Pick {
            spot: "wcan",
            needs: "",
            locked_msg: "",
            got: "got_can",
            give: &["wcan"],
            msg: "gmsg.can",
        },
        Pick {
            spot: "shed",
            needs: "shed_open",
            locked_msg: "gmsg.shed_locked",
            got: "got_shed",
            give: &["trowel", "gnomon"],
            msg: "gmsg.shed_take",
        },
        Pick {
            spot: "cabinet",
            needs: "cab_open",
            locked_msg: "gmsg.cab_locked",
            got: "got_cab",
            give: &["bulb", "wheel"],
            msg: "gmsg.cab_take",
        },
        Pick {
            spot: "bottle",
            needs: "fountain",
            locked_msg: "gmsg.bottle_far",
            got: "got_bottle",
            give: &[],
            msg: "gmsg.bottle",
        },
    ],
    uses: &[
        Use {
            item: "wcan",
            spot: "tap",
            needs: "",
            fail: "",
            keep: false,
            set: "",
            give: &["fullcan"],
            msg: "gmsg.can_full",
        },
        Use {
            item: "fullcan",
            spot: "wilted",
            needs: "",
            fail: "",
            keep: false,
            set: "bloomed",
            give: &["wcan", "skey"],
            msg: "gmsg.bloomed",
        },
        Use {
            item: "wcan",
            spot: "wilted|pot",
            needs: "nothing",
            fail: "gmsg.can_empty",
            keep: true,
            set: "",
            give: &[],
            msg: "",
        },
        Use {
            item: "skey",
            spot: "shed",
            needs: "",
            fail: "",
            keep: false,
            set: "shed_open",
            give: &[],
            msg: "gmsg.shed_open",
        },
        Use {
            item: "gnomon",
            spot: "sundial",
            needs: "",
            fail: "",
            keep: false,
            set: "gnomon_on",
            give: &[],
            msg: "gmsg.gnomon_on",
        },
        Use {
            item: "trowel",
            spot: "pot",
            needs: "",
            fail: "",
            keep: false,
            set: "dug",
            give: &[],
            msg: "gmsg.dug",
        },
        Use {
            item: "bulb",
            spot: "pot",
            needs: "dug",
            fail: "gmsg.pot_hard",
            keep: false,
            set: "planted",
            give: &[],
            msg: "gmsg.planted",
        },
        Use {
            item: "fullcan",
            spot: "pot",
            needs: "planted",
            fail: "gmsg.pot_empty",
            keep: false,
            set: "grown",
            give: &["wcan"],
            msg: "gmsg.grown",
        },
        Use {
            item: "wheel",
            spot: "pipes|valve0|valve1|valve2",
            needs: "",
            fail: "",
            keep: false,
            set: "wheel_on",
            give: &[],
            msg: "gmsg.wheel_on",
        },
    ],
    checks: &[Check {
        flag: "fountain",
        cond: |s| s.flag("wheel_on") && s.val("valves") == VALVES,
        msg: "gmsg.fountain",
    }],
    looks: &[
        Look {
            spot: "wilted",
            flag: "bloomed",
            set: "gmsg.flower_fine",
            unset: "gmsg.wilted",
        },
        Look {
            spot: "sundial",
            flag: "gnomon_on",
            set: "gmsg.sundial_on",
            unset: "gmsg.sundial_bare",
        },
        Look {
            spot: "pot",
            flag: "grown",
            set: "gmsg.pot_grown",
            unset: "gmsg.pot",
        },
        Look {
            spot: "tap",
            flag: "",
            set: "gmsg.tap",
            unset: "gmsg.tap",
        },
        Look {
            spot: "pipes",
            flag: "fountain",
            set: "gmsg.pipes_run",
            unset: "gmsg.pipes",
        },
    ],
    flavour: &["butterflies", "lilies", "flowers", "sun", "bench", "fish"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("bloomed"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("shed_open"),
            available: |s| s.flag("bloomed"),
        },
        Puzzle {
            solved: |s| s.flag("gnomon_on"),
            available: |s| s.flag("got_shed"),
        },
        Puzzle {
            solved: |s| s.flag("cab_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("grown"),
            available: |s| s.flag("got_cab"),
        },
        Puzzle {
            solved: |s| s.flag("fountain"),
            available: |s| s.flag("got_cab"),
        },
        Puzzle {
            solved: |s| s.flag("got_bottle"),
            available: |s| s.flag("fountain"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("grown"),
        },
    ],
    hint_views: &[
        ("G1", &[0, 3, 4, 7]),
        ("G2", &[1, 2, 5, 6]),
        ("gcab", &[3]),
        ("sundial", &[2, 3]),
        ("pipes", &[5]),
        ("pond", &[6, 5]),
        ("gdoor", &[7]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook: no_hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    #[test]
    fn the_orangery_can_be_left() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "tap shed"), "gmsg.shed_locked");
        msg(&mut r, "tap wcan");
        assert_eq!(msg(&mut r, "use wcan wilted"), "gmsg.can_empty");
        assert_eq!(msg(&mut r, "use wcan tap"), "gmsg.can_full");
        assert_eq!(msg(&mut r, "use fullcan wilted"), "gmsg.bloomed");
        assert_eq!(msg(&mut r, "use skey shed"), "gmsg.shed_open");
        assert_eq!(msg(&mut r, "tap shed"), "gmsg.shed_take");
        assert_eq!(msg(&mut r, "use gnomon sundial"), "gmsg.gnomon_on");
        turn_to(&mut r, "cab", &[7, 5, 3], 10);
        assert_eq!(msg(&mut r, "tap cabinet"), "gmsg.cab_take");
        assert_eq!(msg(&mut r, "use bulb pot"), "gmsg.pot_hard");
        msg(&mut r, "use trowel pot");
        msg(&mut r, "use bulb pot");
        msg(&mut r, "use wcan tap");
        assert_eq!(msg(&mut r, "use fullcan pot"), "gmsg.grown");
        assert_eq!(msg(&mut r, "flip valves 0"), "gmsg.valves_stuck");
        msg(&mut r, "use wheel pipes");
        assert_eq!(msg(&mut r, "tap bottle"), "gmsg.bottle_far");
        msg(&mut r, "flip valves 0");
        assert_eq!(msg(&mut r, "flip valves 1"), "gmsg.fountain");
        assert_eq!(msg(&mut r, "tap bottle"), "gmsg.bottle");
        assert_eq!(door_code(), [1, 4, 0, 3]);
        turn_to(&mut r, "door", &door_code(), 6);
        assert!(r.done);
        assert!(r.solved().iter().all(|s| *s));
        assert_eq!(r.halves(), 6);
        let saved = r.save();
        assert_eq!(State::load(&SPEC, &saved).unwrap(), r);
        assert!(State::load(&crate::theatre::SPEC, &saved).is_err());
    }
}
