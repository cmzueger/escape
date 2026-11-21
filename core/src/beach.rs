//! Low Tide (easy): a bathing hut whose door has swollen shut, six puzzles.
//! Views: `B1` (door, locker, shelf) and `B2` (window, bench, kites).

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, strs_json};

/// Shells of each kind lying about (the shell box's plaque asks for them
/// in this order), split over the two walls.
pub const SHELLS: [(&str, u8, u8); 3] = [("spiral", 3, 1), ("scallop", 1, 1), ("star", 2, 4)];
/// The kite on each hook's string, left to right, and the one on the
/// paper from the bottle.
pub const KITES: [&str; 3] = ["blue", "red", "green"];
pub const WANTED_KITE: &str = "green";
/// The mark (1..6) the water stands at on the tide post.
pub const TIDE_MARK: u8 = 4;

fn box_code() -> Vec<u8> {
    SHELLS.iter().map(|(_, a, b)| a + b).collect()
}

fn clues() -> String {
    let shells = SHELLS
        .iter()
        .map(|(k, a, b)| format!("{{\"kind\":\"{k}\",\"b1\":{a},\"b2\":{b}}}"))
        .collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"shells\":[{}],\"kites\":[{}],\"wanted_kite\":\"{WANTED_KITE}\",\"tide_mark\":{TIDE_MARK}}}",
        shells.join(","),
        strs_json(&KITES)
    )
}

/// `pull <0..2>`: pulls the string on a hook; the right one brings its kite down.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words[0] != "pull" {
        return None;
    }
    Some(
        match words
            .get(1)
            .and_then(|w| w.parse::<usize>().ok())
            .filter(|i| *i < 3)
        {
            None => Err(bad("pull")),
            Some(_) if s.flag("kite_down") => Ok(String::new()),
            Some(i) if KITES[i] == WANTED_KITE && s.flag("bottle_open") => {
                s.set("kite_down");
                s.give("key");
                Ok("bmsg.kite_down".into())
            }
            Some(_) => Ok("bmsg.kite_wrong".into()),
        },
    )
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 3;

pub static SPEC: Spec = Spec {
    id: "beach",
    prefix: "b",
    par_minutes: PAR_MINUTES,
    flags: &[
        "box_open",
        "got_box",
        "bottle_open",
        "kite_down",
        "locker_open",
        "got_locker",
        "hand_on",
        "clock_open",
        "got_token",
        "dug",
        "tin_open",
        "got_dkey",
        "done",
    ],
    items: &["corkscrew", "key", "spade", "hand", "token", "dkey"],
    locks: &[Lock {
        name: "box",
        size: 10,
        start: &[0, 0, 0],
        code: box_code,
        flag: "box_open",
        msg: "bmsg.box_open",
        needs: "",
    }],
    dials: &[Dial {
        name: "tide",
        size: 6,
        start: &[0],
        wrap: true,
        needs: "hand_on",
        needs_msg: "bmsg.clock_bare",
        freeze: "clock_open",
    }],
    picks: &[
        Pick {
            spot: "shellbox",
            needs: "box_open",
            locked_msg: "bmsg.box_locked",
            got: "got_box",
            give: &["corkscrew"],
            msg: "bmsg.corkscrew",
        },
        Pick {
            spot: "locker",
            needs: "locker_open",
            locked_msg: "bmsg.locker_locked",
            got: "got_locker",
            give: &["spade", "hand"],
            msg: "bmsg.locker_take",
        },
        Pick {
            spot: "clockbox",
            needs: "clock_open",
            locked_msg: "bmsg.clock_shut",
            got: "got_token",
            give: &["token"],
            msg: "bmsg.token",
        },
        Pick {
            spot: "tin",
            needs: "tin_open",
            locked_msg: "bmsg.tin_shut",
            got: "got_dkey",
            give: &["dkey"],
            msg: "bmsg.dkey",
        },
    ],
    uses: &[
        Use {
            item: "corkscrew",
            spot: "bottle",
            needs: "",
            fail: "",
            keep: false,
            set: "bottle_open",
            give: &[],
            msg: "bmsg.bottle_open",
        },
        Use {
            item: "key",
            spot: "locker",
            needs: "",
            fail: "",
            keep: false,
            set: "locker_open",
            give: &[],
            msg: "bmsg.locker_open",
        },
        Use {
            item: "hand",
            spot: "tideclock|clockbox",
            needs: "",
            fail: "",
            keep: false,
            set: "hand_on",
            give: &[],
            msg: "bmsg.hand_on",
        },
        Use {
            item: "spade",
            spot: "sand",
            needs: "",
            fail: "",
            keep: false,
            set: "dug",
            give: &[],
            msg: "bmsg.dug",
        },
        Use {
            item: "token",
            spot: "tin|sand",
            needs: "dug",
            fail: "bmsg.no_slot",
            keep: false,
            set: "tin_open",
            give: &[],
            msg: "bmsg.tin_open",
        },
        Use {
            item: "dkey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "bmsg.door_open",
        },
    ],
    checks: &[Check {
        flag: "clock_open",
        cond: |s| s.flag("hand_on") && s.val("tide")[0] == TIDE_MARK - 1,
        msg: "bmsg.clock_open",
    }],
    looks: &[
        Look {
            spot: "bottle",
            flag: "bottle_open",
            set: "bmsg.paper",
            unset: "bmsg.bottle",
        },
        Look {
            spot: "sand",
            flag: "dug",
            set: "bmsg.tin_shut",
            unset: "bmsg.sand",
        },
        Look {
            spot: "door",
            flag: "",
            set: "bmsg.door",
            unset: "bmsg.door",
        },
        Look {
            spot: "tideclock",
            flag: "hand_on",
            set: "bmsg.clock",
            unset: "bmsg.clock_bare",
        },
    ],
    flavour: &["shells", "buoys", "sea", "post", "towel", "net"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("box_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("bottle_open"),
            available: |s| s.flag("got_box"),
        },
        Puzzle {
            solved: |s| s.flag("kite_down"),
            available: |s| s.flag("bottle_open"),
        },
        Puzzle {
            solved: |s| s.flag("clock_open"),
            available: |s| s.flag("got_locker"),
        },
        Puzzle {
            solved: |s| s.flag("tin_open"),
            available: |s| s.flag("got_locker"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_dkey"),
        },
    ],
    hint_views: &[
        ("B1", &[1, 3, 5, 0]),
        ("B2", &[0, 2, 4]),
        ("bbox", &[0]),
        ("bbottle", &[1, 2]),
        ("kites", &[2]),
        ("tideclock", &[3]),
        ("bwindow", &[3, 0]),
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
    fn the_beach_hut_can_be_left() {
        let mut r = State::new(&SPEC);
        assert_eq!(box_code(), [4, 2, 6]);
        assert_eq!(msg(&mut r, "pull 2"), "bmsg.kite_wrong");
        turn_to(&mut r, "box", &box_code(), 10);
        msg(&mut r, "tap shellbox");
        assert_eq!(msg(&mut r, "use corkscrew bottle"), "bmsg.bottle_open");
        assert_eq!(msg(&mut r, "pull 0"), "bmsg.kite_wrong");
        assert_eq!(msg(&mut r, "pull 2"), "bmsg.kite_down");
        msg(&mut r, "use key locker");
        msg(&mut r, "tap locker");
        assert_eq!(msg(&mut r, "turn tide 0 +1"), "bmsg.clock_bare");
        msg(&mut r, "use hand tideclock");
        msg(&mut r, "turn tide 0 +1");
        msg(&mut r, "turn tide 0 +1");
        assert_eq!(msg(&mut r, "turn tide 0 +1"), "bmsg.clock_open");
        msg(&mut r, "tap clockbox");
        assert_eq!(msg(&mut r, "use token sand"), "bmsg.no_slot");
        msg(&mut r, "use spade sand");
        assert_eq!(msg(&mut r, "use token tin"), "bmsg.tin_open");
        msg(&mut r, "tap tin");
        assert_eq!(msg(&mut r, "use dkey door"), "bmsg.door_open");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
