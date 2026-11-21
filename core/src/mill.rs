//! Harvest Moon (hard): a windmill at the harvest festival; the first flour
//! must reach the village before the moon rises. Twelve puzzles. Views:
//! `MI1` (the meal floor: sacks, the hoist's hook, the brake rope, the meal
//! chute and its bins, the loading door, the cart) and `MI2` (the stone
//! floor: the millstones and gears, the window onto the sails and fields,
//! the cap's winding wheel, the hoist clutch, the miller's slate).
//!
//! Sails, gears, stones and flour move: the sails turn once the cap faces
//! the wind, the cloths are set and the brake is off; the stones turn by the
//! gears' ratio; flour runs down the chute where its flaps lead.

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::kit::{Check, Dial, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The cap's eight directions (0 north, clockwise); the wind comes from the
/// west: the gusts blow the poplars' leaves to the east.
pub const WIND: u8 = 6;
/// Sail cloths (0 bare, 1 half, 2 full): the sun sails full, the moon sails
/// half; sails 0 and 2 carry the sun.
pub const CLOTHS: [u8; 4] = [2, 1, 2, 1];
/// Gears on the rack (teeth) for the wallower and the stone nut; the brake
/// wheel has 48 teeth, the great spur wheel 96. The stones must turn 18
/// times for each turn of the sails.
pub const RACK: [u32; 3] = [12, 16, 24];
pub const RATIO: u32 = 18;
/// The five sacks (farm marks barn, cow, apple, well, oak) and the order the
/// festival bread needs them in: wheat (apple), spelt (barn), rye (well).
pub const SACKS: u8 = 5;
pub const ORDER: [u8; 3] = [2, 0, 3];
/// The meal chute's three flaps (0 left, 1 right): fine flour into the
/// festival sack, the bran into the bran sack.
pub const FLAPS: [u8; 3] = [1, 0, 1];

/// Turns of the stones per turn of the sails.
pub fn ratio(s: &State) -> u32 {
    let g = s.val("gears");
    (48 / RACK[usize::from(g[0])]) * (96 / RACK[usize::from(g[1])])
}

pub static LINES: [Line; 3] = [
    Line {
        text: "mitalk.1",
        choices: &[("misay.1a", 2), ("misay.1b", 0), ("misay.1c", 0)],
        sets: "",
    },
    Line {
        text: "mitalk.2",
        choices: &[("misay.2a", 0), ("misay.2b", 3)],
        sets: "",
    },
    Line {
        text: "mitalk.3",
        choices: &[("misay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"wind\":{WIND},\"rack\":[{}],\"ratio\":{RATIO},\"sun\":[0,2],\"lines\":[{}]}}",
        nums_json(&RACK.map(|t| t as u8)),
        lines_json(&LINES)
    )
}

fn extra(s: &State) -> String {
    format!(",\"ratio\":{}", ratio(s))
}

/// The brake rope, the hoist (`hoist <sack>`), and Greta at the door.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["tap", "brakerope"] => Some(Ok(if s.flag("turning") {
            "mimsg.turning".into()
        } else if s.flag("facing&cloth_ok") {
            s.set("turning");
            "mimsg.brake_off".into()
        } else if s.flag("facing") {
            "mimsg.sails_flap".into()
        } else {
            "mimsg.sails_still".into()
        })),
        ["hoist", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < SACKS) {
            None => Err(bad("hoist")),
            Some(_) if s.flag("hoisted") => Ok("mimsg.hopper_full".into()),
            Some(_) if !s.flag("hoist_ready") => Ok("mimsg.hoist_still".into()),
            Some(k) => {
                let at = usize::from(s.val("loaded")[0]);
                if ORDER[at] == k {
                    s.val_mut("loaded")[0] += 1;
                    if at + 1 == ORDER.len() {
                        s.set("hoisted");
                        Ok("mimsg.hoisted".into())
                    } else {
                        Ok("mimsg.sack_up".into())
                    }
                } else {
                    s.val_mut("loaded")[0] = 0;
                    Ok("mimsg.wrong_sack".into())
                }
            }
        }),
        _ => talk(s, words, &LINES, "facing", "mi"),
    }
}

/// Minutes for three stars (from tools/knowledge.py, 2026-11-18).
pub const PAR_MINUTES: u32 = 15;

pub static SPEC: Spec = Spec {
    id: "mill",
    prefix: "mi",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_crank",
        "crank_on",
        "facing",
        "told",
        "cloth_ok",
        "turning",
        "gears_ok",
        "hoist_ready",
        "hoisted",
        "ground",
        "got_flour",
        "got_bran",
        "door_open",
        "done",
    ],
    items: &["micrank", "miflour", "mibran"],
    locks: &[],
    dials: &[
        Dial {
            name: "cap",
            size: 8,
            start: &[1],
            wrap: true,
            needs: "crank_on",
            needs_msg: "mimsg.no_handle",
            freeze: "turning",
        },
        Dial {
            name: "cloth",
            size: 3,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "told",
            needs_msg: "mimsg.cloth_how",
            freeze: "turning",
        },
        Dial {
            name: "gears",
            size: 3,
            start: &[0, 2],
            wrap: true,
            needs: "turning",
            needs_msg: "mimsg.gears_still",
            freeze: "gears_ok",
        },
        Dial {
            name: "clutch",
            size: 2,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "traps",
            size: 2,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "loaded",
            size: 4,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "flaps",
            size: 2,
            start: &[0, 0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "ground",
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
            spot: "sacks",
            needs: "",
            locked_msg: "",
            got: "got_crank",
            give: &["micrank"],
            msg: "mimsg.crank",
        },
        Pick {
            spot: "festival",
            needs: "ground",
            locked_msg: "mimsg.festival_empty",
            got: "got_flour",
            give: &["miflour"],
            msg: "mimsg.flour",
        },
        Pick {
            spot: "bransack",
            needs: "ground",
            locked_msg: "mimsg.bran_empty",
            got: "got_bran",
            give: &["mibran"],
            msg: "mimsg.bran",
        },
    ],
    uses: &[
        Use {
            item: "micrank",
            spot: "wheel",
            needs: "",
            fail: "",
            keep: false,
            set: "crank_on",
            give: &[],
            msg: "mimsg.crank_on",
        },
        Use {
            item: "mibran",
            spot: "counterweight",
            needs: "",
            fail: "",
            keep: false,
            set: "door_open",
            give: &[],
            msg: "mimsg.door_open",
        },
        Use {
            item: "miflour",
            spot: "cart",
            needs: "door_open",
            fail: "mimsg.door_shut",
            keep: false,
            set: "done",
            give: &[],
            msg: "mimsg.cart_rolls",
        },
    ],
    checks: &[
        Check {
            flag: "facing",
            cond: |s| s.flag("crank_on") && s.val("cap")[0] == WIND,
            msg: "mimsg.facing",
        },
        Check {
            flag: "cloth_ok",
            cond: |s| s.flag("told") && s.val("cloth") == CLOTHS,
            msg: "",
        },
        Check {
            flag: "gears_ok",
            cond: |s| s.flag("turning") && ratio(s) == RATIO,
            msg: "mimsg.gears_ok",
        },
        Check {
            flag: "hoist_ready",
            cond: |s| s.flag("gears_ok") && s.val("clutch")[0] == 1 && s.val("traps")[0] == 1,
            msg: "mimsg.hoist_ready",
        },
        Check {
            flag: "ground",
            cond: |s| {
                if s.flag("hoisted") && s.val("flaps") == FLAPS {
                    s.flag("gears_ok")
                } else {
                    false
                }
            },
            msg: "mimsg.ground",
        },
    ],
    looks: &[Look {
        spot: "loadingdoor",
        flag: "door_open",
        set: "mimsg.door_wide",
        unset: "mimsg.loadingdoor",
    }],
    flavour: &[
        "window",
        "slate",
        "song",
        "stones",
        "chute",
        "bins",
        "door",
        "cart",
        "counterweight",
        "rack",
        "poplars",
        "sails",
        "wheel",
        "hopper",
        "hook",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_crank"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("crank_on"),
            available: |s| s.flag("got_crank"),
        },
        Puzzle {
            solved: |s| s.flag("facing"),
            available: |s| s.flag("crank_on"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("facing"),
        },
        Puzzle {
            solved: |s| s.flag("cloth_ok"),
            available: |s| s.flag("told"),
        },
        Puzzle {
            solved: |s| s.flag("turning"),
            available: |s| s.flag("facing&cloth_ok"),
        },
        Puzzle {
            solved: |s| s.flag("gears_ok"),
            available: |s| s.flag("turning"),
        },
        Puzzle {
            solved: |s| s.flag("hoist_ready"),
            available: |s| s.flag("gears_ok"),
        },
        Puzzle {
            solved: |s| s.flag("hoisted"),
            available: |s| s.flag("hoist_ready"),
        },
        Puzzle {
            solved: |s| s.flag("ground"),
            available: |s| s.flag("hoisted"),
        },
        Puzzle {
            solved: |s| s.flag("door_open"),
            available: |s| s.flag("got_bran"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("door_open&got_flour"),
        },
    ],
    hint_views: &[
        ("MI1", &[0, 5, 7, 8, 9, 10, 11]),
        ("MI2", &[1, 2, 3, 4, 6, 7]),
        ("misacks", &[0, 8]),
        ("miwheel", &[1, 2]),
        ("miwindow", &[2, 4]),
        ("midoor", &[3, 10, 11]),
        ("migears", &[6]),
        ("mislate", &[8]),
        ("michute", &[9]),
        ("mihoist", &[7]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::house::say_all;
    use crate::kit::{msg, turn_to};
    use std::collections::HashSet;

    /// The sacks' grain follows from the slate's clues, one way only.
    #[test]
    fn the_slate_has_one_answer() {
        // Farms 0 barn 1 cow 2 apple 3 well 4 oak; grains 0 wheat 1 rye 2
        // barley 3 oats 4 spelt; grain[farm].
        let mut answers = HashSet::new();
        for n in 0..120 {
            let mut pool = vec![0, 1, 2, 3, 4];
            let mut g = vec![];
            let mut m = n;
            for k in (1..=5).rev() {
                g.push(pool.remove(m % k));
                m /= k;
            }
            let ok = g[3] == 1
                && (g[0] == 3 || g[0] == 4)
                && g[4] != 0
                && g[1] != 0
                && g[4] != 4
                && g[4] != 3
                && g[1] != 4;
            if ok {
                let farm = |grain: u8| g.iter().position(|x| *x == grain).unwrap() as u8;
                answers.insert([farm(0), farm(4), farm(1)]);
            }
        }
        assert_eq!(answers, HashSet::from([ORDER]));
    }

    #[test]
    fn the_flour_reaches_the_festival() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap sacks");
        msg(&mut r, "use micrank wheel");
        turn_to(&mut r, "cap", &[WIND], 8);
        assert!(r.flag("facing"));
        assert_eq!(msg(&mut r, "tap brakerope"), "mimsg.sails_flap");
        say_all(&mut r, &[0, 1, 0]);
        assert!(r.flag("told"));
        turn_to(&mut r, "cloth", &CLOTHS, 3);
        msg(&mut r, "tap brakerope");
        assert!(r.flag("turning"));
        let mut hits = 0;
        for a in 0..3u8 {
            for b in 0..3u8 {
                let mut t = r.clone();
                t.val_mut("gears").copy_from_slice(&[a, b]);
                hits += u32::from(ratio(&t) == RATIO);
            }
        }
        assert_eq!(hits, 1, "one pair of gears gives the right speed");
        turn_to(&mut r, "gears", &[1, 1], 3);
        assert!(r.flag("gears_ok"));
        msg(&mut r, "flip clutch 0");
        assert_eq!(
            msg(&mut r, "hoist 2"),
            "mimsg.hoist_still",
            "the trapdoors are shut"
        );
        msg(&mut r, "flip traps 0");
        assert_eq!(msg(&mut r, "hoist 1"), "mimsg.wrong_sack");
        for k in ORDER {
            msg(&mut r, &format!("hoist {k}"));
        }
        assert!(r.flag("hoisted") && !r.flag("ground"));
        turn_to(&mut r, "flaps", &FLAPS, 2);
        assert!(r.flag("ground"));
        msg(&mut r, "tap festival");
        msg(&mut r, "tap bransack");
        assert_eq!(msg(&mut r, "use miflour cart"), "mimsg.door_shut");
        msg(&mut r, "use mibran counterweight");
        msg(&mut r, "use miflour cart");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
