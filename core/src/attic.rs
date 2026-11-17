//! The Attic (easy): grandmother's attic, the trapdoor has fallen shut.
//! Six puzzles. Views: `K1` (trapdoor, trunk, music box) and `K2` (toy
//! train, photo album, wardrobe).

use crate::kit::{no_extra, no_hook, Lock, Look, Pick, Puzzle, Spec, Use};
use crate::nums_json;

/// Candles on the birthday cakes of the album's three photos, in order.
pub const CANDLES: [u8; 3] = [5, 8, 3];
/// The numbers on the toy train's wagons behind the engine; the wagon from
/// the trunk is the missing one.
pub const WAGONS: [u8; 4] = [2, 7, 9, 4];
pub const MISSING: usize = 2;

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"candles\":[{}],\"wagons\":[{}],\"missing\":{MISSING}}}",
        nums_json(&CANDLES),
        nums_json(&WAGONS)
    )
}

/// Minutes for three stars (set from the owner's play tests, 2026-11-17).
pub const PAR_MINUTES: u32 = 5;

pub static SPEC: Spec = Spec {
    id: "attic",
    prefix: "k",
    par_minutes: PAR_MINUTES,
    flags: &[
        "trunk_open",
        "got_trunk",
        "music_on",
        "got_mkey",
        "wagon_on",
        "ward_open",
        "got_pole",
        "unlocked",
        "done",
    ],
    items: &["mcrank", "wagon", "mkey", "pole"],
    locks: &[
        Lock {
            name: "trunk",
            size: 10,
            start: &[0, 0, 0],
            code: || CANDLES.to_vec(),
            flag: "trunk_open",
            msg: "kmsg.trunk_open",
            needs: "",
        },
        Lock {
            name: "ward",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || WAGONS.to_vec(),
            flag: "ward_open",
            msg: "kmsg.ward_open",
            needs: "wagon_on",
        },
    ],
    dials: &[],
    picks: &[
        Pick {
            spot: "trunk",
            needs: "trunk_open",
            locked_msg: "kmsg.trunk_locked",
            got: "got_trunk",
            give: &["mcrank", "wagon"],
            msg: "kmsg.trunk_take",
        },
        Pick {
            spot: "musicbox",
            needs: "music_on",
            locked_msg: "kmsg.music_still",
            got: "got_mkey",
            give: &["mkey"],
            msg: "kmsg.mkey",
        },
        Pick {
            spot: "wardrobe",
            needs: "ward_open",
            locked_msg: "kmsg.ward_locked",
            got: "got_pole",
            give: &["pole"],
            msg: "kmsg.pole",
        },
    ],
    uses: &[
        Use {
            item: "mcrank",
            spot: "musicbox",
            needs: "",
            fail: "",
            keep: false,
            set: "music_on",
            give: &[],
            msg: "kmsg.music_on",
        },
        Use {
            item: "wagon",
            spot: "train",
            needs: "",
            fail: "",
            keep: false,
            set: "wagon_on",
            give: &[],
            msg: "kmsg.wagon_on",
        },
        Use {
            item: "mkey",
            spot: "trapdoor",
            needs: "",
            fail: "",
            keep: false,
            set: "unlocked",
            give: &[],
            msg: "kmsg.unlocked",
        },
        Use {
            item: "pole",
            spot: "trapdoor",
            needs: "unlocked",
            fail: "kmsg.trap_locked",
            keep: false,
            set: "done",
            give: &[],
            msg: "kmsg.trap_open",
        },
    ],
    checks: &[],
    looks: &[
        Look {
            spot: "trapdoor",
            flag: "unlocked",
            set: "kmsg.trap_reach",
            unset: "kmsg.trap_locked",
        },
        Look {
            spot: "train",
            flag: "wagon_on",
            set: "kmsg.train_whole",
            unset: "kmsg.train_gap",
        },
    ],
    flavour: &["dormer", "horse", "dummy", "dust", "photos"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("trunk_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("music_on"),
            available: |s| s.flag("got_trunk"),
        },
        Puzzle {
            solved: |s| s.flag("wagon_on"),
            available: |s| s.flag("got_trunk"),
        },
        Puzzle {
            solved: |s| s.flag("ward_open"),
            available: |s| s.flag("wagon_on"),
        },
        Puzzle {
            solved: |s| s.flag("unlocked"),
            available: |s| s.flag("got_mkey"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_pole"),
        },
    ],
    hint_views: &[
        ("K1", &[0, 1, 4, 5]),
        ("K2", &[0, 2, 3]),
        ("album", &[0]),
        ("ktrunk", &[0]),
        ("ktrain", &[2, 3]),
        ("kward", &[3]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook: no_hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to, State};

    #[test]
    fn the_attic_can_be_left() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "trunk", &CANDLES, 10);
        msg(&mut r, "tap trunk");
        assert_eq!(msg(&mut r, "tap musicbox"), "kmsg.music_still");
        msg(&mut r, "use mcrank musicbox");
        msg(&mut r, "tap musicbox");
        turn_to(&mut r, "ward", &WAGONS, 10);
        assert!(!r.flag("ward_open"), "the wardrobe waits for the whole train");
        msg(&mut r, "turn ward 0 +1");
        msg(&mut r, "use wagon train");
        assert_eq!(msg(&mut r, "turn ward 0 -1"), "kmsg.ward_open");
        msg(&mut r, "tap wardrobe");
        assert_eq!(msg(&mut r, "use pole trapdoor"), "kmsg.trap_locked");
        msg(&mut r, "use mkey trapdoor");
        assert_eq!(msg(&mut r, "use pole trapdoor"), "kmsg.trap_open");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
