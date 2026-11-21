//! The Dragon's Egg (tenth set): thieves stole the dragon's egg and, fleeing,
//! left it caged behind the sleeping dragon. The village child brings it
//! back to the nest before it cools. Views: `DG1` (the mountain door in the
//! snow: rune lock, mine cart, lantern post), `DG2` (the hoard hall: the
//! dragon on its gold, hanging bells, the cage, thieves' notes), `DG3` (the
//! lava hall: two mirrors, a crystal, the obsidian floor), `DG4` (the nest
//! ledge: a crag, a steam vent, the nest).

use crate::bad;
use crate::island::{dir, moved, skate, Course};
use crate::kit::{no_extra, Check, Dial, Lock, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{moment, sequence};

/// The rune lock: the dwarves' tally marks on the cart, row by row.
pub const RUNES: [u8; 4] = [3, 1, 4, 2];
/// The lullaby carved over the door, bell by bell (0 to 3, left to right).
pub const LULLABY: [u8; 5] = [0, 2, 1, 3, 2];
/// The dragon snores for the last 3 seconds of every 6; a step taken while
/// it breathes in quietly opens its eye.
pub const SNORE: (u32, u32) = (6, 3);
/// Stones across the hoard to the cage.
pub const STONES: u8 = 5;
/// The cage's key ring: 0 crown, 1 skull, 2 star, 3 moon. Of the three
/// thieves' notes only one is true: the skull.
pub const KEY: u8 = 1;
/// The mirrors that throw the lava's glow onto the crystal (4 positions).
pub const MIRRORS: [u8; 2] = [1, 3];
/// The steam vent puffs for the last 2 seconds of every 8.
pub const VENT: (u32, u32) = (8, 2);

/// The obsidian floor: one slides until a pillar or the wall stops you;
/// cracks (seen only in the crystal's light) break.
pub static FLOOR: Course = Course {
    w: 7,
    h: 5,
    blocked: &[2, 12, 19, 23, 31],
    thin: &[6, 22, 30, 33],
    start: 14,
    goal: 20,
    drift: (0, 0),
};

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"runes\":[{}],\"lullaby\":[{}],\"snore\":[{},{}],\"stones\":{STONES},\"mirrors\":[{}],\"vent\":[{},{}],\"floor\":{},\"cracks\":{}}}",
        nums_json(&RUNES),
        nums_json(&LULLABY),
        SNORE.0,
        SNORE.1,
        nums_json(&MIRRORS),
        VENT.0,
        VENT.1,
        FLOOR.json(),
        FLOOR.thin_json()
    )
}

const READY: &str = "warmed&rope_up";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let at_cage = |s: &State| s.val("sneak")[0] == STONES;
    match words {
        ["bell", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 4) {
            None => Err(bad("bell")),
            Some(_) if s.flag("lulled") => Ok(String::new()),
            Some(b) => match sequence(s, "lull", &LULLABY, b) {
                (true, _) => {
                    s.set("lulled");
                    Ok("dgmsg.lulled".into())
                }
                _ => Ok(String::new()),
            },
        }),
        ["step"] => Some(Ok(if !s.has("dglit") {
            "dgmsg.too_dark".into()
        } else if !s.flag("lulled") {
            "dgmsg.restless".into()
        } else if at_cage(s) {
            String::new()
        } else if moment(s, SNORE.0, SNORE.1) {
            s.val_mut("sneak")[0] += 1;
            if at_cage(s) {
                s.set("crossed");
                "dgmsg.at_cage".into()
            } else {
                "dgmsg.tiptoe".into()
            }
        } else {
            s.val_mut("sneak")[0] = 0;
            "dgmsg.eye_opens".into()
        })),
        ["key", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 4) {
            None => Err(bad("key")),
            Some(_) if s.flag("cage_open") => Ok(String::new()),
            Some(_) if !at_cage(s) => Ok("dgmsg.cage_far".into()),
            Some(KEY) => {
                s.set("cage_open");
                Ok("dgmsg.cage_open".into())
            }
            Some(_) => {
                s.val_mut("sneak")[0] = 0;
                Ok("dgmsg.key_jams".into())
            }
        }),
        ["tap", "scale"] => Some(Ok(if s.flag("got_scale") {
            "dgmsg.nothing".into()
        } else if !at_cage(s) && !s.flag("cage_open") {
            "dgmsg.scale_far".into()
        } else {
            s.set("got_scale");
            s.give("dgscale");
            "dgmsg.scale".into()
        })),
        ["use", "dgegg", "dgscale"] | ["use", "dgscale", "dgegg"] if s.has("dgegg") && s.has("dgscale") => {
            s.take("dgegg");
            s.take("dgscale");
            s.give("dgwrapped");
            s.set("wrapped");
            Some(Ok("dgmsg.wrapped".into()))
        }
        ["slide", d] => Some(match dir(d) {
            None => Err(bad("slide")),
            Some(_) if !s.flag("floor_lit") => Ok("dgmsg.floor_dark".into()),
            Some(_) if s.flag("across") => Ok(String::new()),
            Some(dv) => {
                let m = skate(s, "floor", &FLOOR, dv);
                if s.val("floor")[0] == FLOOR.goal {
                    s.set("across");
                }
                moved(m, "dg", "slide")
            }
        }),
        ["hold"] => Some(Ok(if s.flag("warmed") {
            String::new()
        } else if !s.has("dgwrapped") {
            "dgmsg.nothing_to_warm".into()
        } else if !s.flag("rope_up") {
            "dgmsg.vent_far".into()
        } else if moment(s, VENT.0, VENT.1) {
            s.take("dgwrapped");
            s.give("dghot");
            s.set("warmed");
            "dgmsg.warmed".into()
        } else {
            "dgmsg.vent_quiet".into()
        })),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 8;

const fn counter(name: &'static str, size: u8, start: &'static [u8]) -> Dial {
    Dial {
        name,
        size,
        start,
        wrap: false,
        needs: "never",
        needs_msg: "",
        freeze: "",
    }
}

pub static SPEC: Spec = Spec {
    id: "dragon",
    prefix: "dg",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_torch",
        "torch_lit",
        "door_open",
        "lulled",
        "crossed",
        "cage_open",
        "got_egg",
        "got_scale",
        "wrapped",
        "got_rope",
        "floor_lit",
        "across",
        "rope_up",
        "warmed",
        "done",
    ],
    items: &[
        "dgtorch",
        "dglit",
        "dgegg",
        "dgscale",
        "dgwrapped",
        "dgrope",
        "dghot",
    ],
    locks: &[Lock {
        name: "runes",
        size: 6,
        start: &[0, 0, 0, 0],
        code: || RUNES.to_vec(),
        flag: "door_open",
        msg: "dgmsg.door_open",
        needs: "",
    }],
    dials: &[
        counter("lull", 6, &[0]),
        counter("sneak", 6, &[0]),
        Dial {
            name: "mirrors",
            size: 4,
            start: &[0, 0],
            wrap: true,
            needs: "crossed",
            needs_msg: "dgmsg.hall_dark",
            freeze: "floor_lit",
        },
        counter("floor", 35, &[14]),
    ],
    picks: &[
        Pick {
            spot: "torches",
            needs: "",
            locked_msg: "",
            got: "got_torch",
            give: &["dgtorch"],
            msg: "dgmsg.torch",
        },
        Pick {
            spot: "cage",
            needs: "cage_open",
            locked_msg: "dgmsg.cage_locked",
            got: "got_egg",
            give: &["dgegg"],
            msg: "dgmsg.egg",
        },
        Pick {
            spot: "cart",
            needs: "",
            locked_msg: "",
            got: "got_rope",
            give: &["dgrope"],
            msg: "dgmsg.rope",
        },
    ],
    uses: &[
        Use {
            item: "dgtorch",
            spot: "lantern",
            needs: "",
            fail: "",
            keep: false,
            set: "torch_lit",
            give: &["dglit"],
            msg: "dgmsg.torch_lit",
        },
        Use {
            item: "dgrope",
            spot: "crag",
            needs: "across",
            fail: "dgmsg.crag_far",
            keep: false,
            set: "rope_up",
            give: &[],
            msg: "dgmsg.rope_up",
        },
        Use {
            item: "dghot",
            spot: "nest",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "dgmsg.home",
        },
    ],
    checks: &[Check {
        flag: "floor_lit",
        cond: |s| s.flag("crossed") && s.val("mirrors") == MIRRORS,
        msg: "dgmsg.floor_lit",
    }],
    looks: &[],
    flavour: &[
        "door", "tallies", "carving", "snow", "dragon", "gold", "notes", "bells", "lava", "crystal", "nest",
        "vent", "valley", "crag", "lantern",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_torch"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("torch_lit"),
            available: |s| s.flag("got_torch"),
        },
        Puzzle {
            solved: |s| s.flag("door_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lulled"),
            available: |s| s.flag("door_open"),
        },
        Puzzle {
            solved: |s| s.flag("crossed"),
            available: |s| s.flag("lulled&torch_lit"),
        },
        Puzzle {
            solved: |s| s.flag("cage_open"),
            available: |s| s.flag("crossed"),
        },
        Puzzle {
            solved: |s| s.flag("got_egg"),
            available: |s| s.flag("cage_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_scale"),
            available: |s| s.flag("crossed"),
        },
        Puzzle {
            solved: |s| s.flag("wrapped"),
            available: |s| s.flag("got_egg&got_scale"),
        },
        Puzzle {
            solved: |s| s.flag("got_rope"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("floor_lit"),
            available: |s| s.flag("crossed"),
        },
        Puzzle {
            solved: |s| s.flag("across"),
            available: |s| s.flag("floor_lit"),
        },
        Puzzle {
            solved: |s| s.flag("rope_up"),
            available: |s| s.flag("across&got_rope"),
        },
        Puzzle {
            solved: |s| s.flag("warmed"),
            available: |s| s.flag("wrapped&rope_up"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY),
        },
    ],
    hint_views: &[
        ("DG1", &[0, 1, 2, 9]),
        ("DG2", &[3, 4, 5, 6, 7, 8]),
        ("DG3", &[10, 11]),
        ("DG4", &[12, 13, 14]),
        ("dgrunes", &[2]),
        ("dgcart", &[2, 9]),
        ("dgbells", &[3]),
        ("dghoard", &[4, 5, 7]),
        ("dgnotes", &[5]),
        ("dgmirrors", &[10]),
        ("dgfloor", &[11]),
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

    fn snoring(r: &mut State, t: &mut u32) {
        *t = (*t / SNORE.0 + 1) * SNORE.0 + SNORE.0 - 1;
        msg(r, &format!("time {t}"));
    }

    #[test]
    fn the_egg_goes_home() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap torches");
        msg(&mut r, "use dgtorch lantern");
        turn_to(&mut r, "runes", &RUNES, 6);
        assert!(r.flag("door_open"));
        assert_eq!(msg(&mut r, "step"), "dgmsg.restless");
        for b in LULLABY {
            msg(&mut r, &format!("bell {b}"));
        }
        assert!(r.flag("lulled"));
        let mut t = 0;
        snoring(&mut r, &mut t);
        msg(&mut r, "step");
        msg(&mut r, &format!("time {}", t + 1));
        assert_eq!(msg(&mut r, "step"), "dgmsg.eye_opens");
        for _ in 0..STONES {
            snoring(&mut r, &mut t);
            msg(&mut r, "step");
        }
        assert!(r.flag("crossed"));
        assert_eq!(msg(&mut r, "key 0"), "dgmsg.key_jams");
        for _ in 0..STONES {
            snoring(&mut r, &mut t);
            msg(&mut r, "step");
        }
        msg(&mut r, &format!("key {KEY}"));
        msg(&mut r, "tap cage");
        msg(&mut r, "tap scale");
        msg(&mut r, "use dgscale dgegg");
        msg(&mut r, "tap cart");
        turn_to(&mut r, "mirrors", &MIRRORS, 4);
        assert!(r.flag("floor_lit"));
        // The short way crosses a crack.
        for d in ["e", "n"] {
            msg(&mut r, &format!("slide {d}"));
        }
        assert_eq!(msg(&mut r, "slide e"), "dgmsg.slide_back");
        for d in ["e", "n", "w", "s", "e", "n"] {
            msg(&mut r, &format!("slide {d}"));
        }
        assert!(r.flag("across"), "{:?}", r.val("floor"));
        msg(&mut r, "use dgrope crag");
        msg(&mut r, &format!("time {}", t + 50));
        msg(&mut r, "hold");
        let t = (t + 50) / VENT.0 * VENT.0 + 2 * VENT.0 - 1;
        msg(&mut r, &format!("time {t}"));
        msg(&mut r, "hold");
        msg(&mut r, "use dghot nest");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
