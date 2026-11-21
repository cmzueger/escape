//! The Moon-Viewing Garden (tenth set): a Japanese tea garden on the night
//! of the harvest moon. The hostess, Ms Aoki, has hurt her wrist; the guest
//! makes the garden ready so that the moon may rise over the moon gate.
//! Views: `MG1` (the veranda: alcove with scrolls, tea chest, brazier and
//! kettle, painted screen), `MG2` (the koi pond: bridge, paper boat, stone
//! lantern on its island), `MG3` (the dry garden: gravel, rocks, fox
//! shrine), `MG4` (the bamboo grove: deer scarer, stone basin, charcoal
//! shed, the moon gate).

use crate::bad;
use crate::island::{dir, moved, row, Course};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{moment, sequence};

/// The gravel around the three rocks, six beds (0 straight lines, 1 rings,
/// 2 waves), as the scroll in the alcove shows them.
pub const GRAVEL: [u8; 6] = [1, 0, 2, 2, 1, 0];
/// The koi to feed in the order of the painted screen (0 red, 1 white,
/// 2 gold, 3 black).
pub const KOI: [u8; 4] = [2, 0, 3, 1];
/// The tea, step by step as the second scroll draws it: 0 the cloth,
/// 1 the tea scoop, 2 the water ladle, 3 the whisk, 4 the bowl turned.
pub const TEA: [u8; 5] = [0, 1, 2, 3, 4];
/// The deer scarer tips and pours for the last 2 seconds of every 7.
pub const SCARER: (u32, u32) = (7, 2);
/// The moon gate's three rings (8 phases each; 4 is the full moon). Turning
/// one ring turns the next one with it (the last turns the first).
pub const RINGS_START: [u8; 3] = [3, 1, 6];
pub const FULL: u8 = 4;

/// The pond seen from above: the paper boat fanned from the bank to the
/// lantern's island; the current pushes it east after each wave of the fan.
pub static POND: Course = Course {
    w: 7,
    h: 5,
    blocked: &[7, 10, 16, 25, 32],
    thin: &[],
    start: 21,
    goal: 13,
    drift: (1, 0),
};

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"gravel\":[{}],\"koi\":[{}],\"tea\":[{}],\"scarer\":[{},{}],\"full\":{FULL},\"pond\":{}}}",
        nums_json(&GRAVEL),
        nums_json(&KOI),
        nums_json(&TEA),
        SCARER.0,
        SCARER.1,
        POND.json()
    )
}

const READY: &str = "raked&tea_served&lantern_lit&gate_aligned";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["koi", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 4) {
            None => Err(bad("koi")),
            Some(_) if s.flag("koi_fed") => Ok(String::new()),
            Some(_) if !s.has("mgfood") => Ok("mgmsg.koi_hungry".into()),
            Some(k) => match sequence(s, "fed", &KOI, k) {
                (true, _) => {
                    s.take("mgfood");
                    s.set("koi_fed");
                    Ok("mgmsg.koi_fed".into())
                }
                (false, true) => Ok("mgmsg.koi_eats".into()),
                (false, false) => Ok("mgmsg.koi_squabble".into()),
            },
        }),
        ["catch"] => Some(Ok(if s.flag("water_caught") {
            String::new()
        } else if !s.has("mgladle") {
            "mgmsg.no_ladle".into()
        } else if moment(s, SCARER.0, SCARER.1) {
            s.take("mgladle");
            s.give("mgwater");
            s.set("water_caught");
            "mgmsg.caught".into()
        } else {
            "mgmsg.not_pouring".into()
        })),
        ["tea", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 5) {
            None => Err(bad("tea")),
            Some(_) if s.flag("tea_served") => Ok(String::new()),
            Some(_) if !s.flag("chest_open") => Ok("mgmsg.no_teaset".into()),
            Some(_) if !s.flag("kettle_full&fire_lit") => Ok("mgmsg.no_hot_water".into()),
            Some(k) => match sequence(s, "steps", &TEA, k) {
                (true, _) => {
                    s.set("tea_served");
                    s.give("mgfan");
                    Ok("mgmsg.tea_served".into())
                }
                (false, true) => Ok("mgmsg.tea_step".into()),
                (false, false) => Ok("mgmsg.tea_wrong".into()),
            },
        }),
        ["fan", d] => Some(match dir(d) {
            None => Err(bad("fan")),
            Some(_) if !s.flag("boat_ready") => Ok("mgmsg.boat_dark".into()),
            Some(_) if !s.has("mgfan") => Ok("mgmsg.no_fan".into()),
            Some(_) if s.flag("lantern_lit") => Ok(String::new()),
            Some(dv) => {
                let m = row(s, "boat", &POND, dv);
                if s.val("boat")[0] == POND.goal {
                    s.set("lantern_lit");
                }
                moved(m, "mg", "boat")
            }
        }),
        ["ring", i] => Some(match i.parse::<usize>().ok().filter(|i| *i < 3) {
            None => Err(bad("ring")),
            Some(_) if !s.flag("lantern_lit") => Ok("mgmsg.gate_dark".into()),
            Some(_) if s.flag("gate_aligned") => Ok(String::new()),
            Some(r) => {
                let v = s.val_mut("rings");
                v[r] = (v[r] + 1) % 8;
                v[(r + 1) % 3] = (v[(r + 1) % 3] + 1) % 8;
                Ok(String::new())
            }
        }),
        ["tap", "gong"] => Some(Ok(if s.flag(READY) {
            s.set("done");
            "mgmsg.moonrise"
        } else {
            "mgmsg.not_ready"
        }
        .into())),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 10;

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
    id: "moon",
    prefix: "mg",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_rake",
        "raked",
        "got_chestkey",
        "chest_open",
        "got_food",
        "koi_fed",
        "got_candles",
        "got_ladle",
        "water_caught",
        "got_charcoal",
        "got_matches",
        "coal_in",
        "fire_lit",
        "kettle_full",
        "tea_served",
        "candles_lit",
        "boat_ready",
        "lantern_lit",
        "gate_aligned",
        "done",
    ],
    items: &[
        "mgrake",
        "mgchestkey",
        "mgfood",
        "mgcandles",
        "mgladle",
        "mgwater",
        "mgcharcoal",
        "mgmatches",
        "mglit",
        "mgfan",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "gravel",
            size: 3,
            start: &[0, 0, 0, 0, 0, 0],
            wrap: true,
            needs: "got_rake",
            needs_msg: "mgmsg.no_rake",
            freeze: "raked",
        },
        counter("fed", 5, &[0]),
        counter("steps", 6, &[0]),
        counter("boat", 35, &[21]),
        counter("rings", 8, &RINGS_START),
    ],
    picks: &[
        Pick {
            spot: "bamboo",
            needs: "",
            locked_msg: "",
            got: "got_rake",
            give: &["mgrake"],
            msg: "mgmsg.rake",
        },
        Pick {
            spot: "glint",
            needs: "raked",
            locked_msg: "mgmsg.gravel_flat",
            got: "got_chestkey",
            give: &["mgchestkey"],
            msg: "mgmsg.chestkey",
        },
        Pick {
            spot: "offering",
            needs: "",
            locked_msg: "",
            got: "got_food",
            give: &["mgfood"],
            msg: "mgmsg.food",
        },
        Pick {
            spot: "candlebox",
            needs: "koi_fed",
            locked_msg: "mgmsg.koi_crowd",
            got: "got_candles",
            give: &["mgcandles"],
            msg: "mgmsg.candles",
        },
        Pick {
            spot: "ladle",
            needs: "",
            locked_msg: "",
            got: "got_ladle",
            give: &["mgladle"],
            msg: "mgmsg.ladle",
        },
        Pick {
            spot: "shed",
            needs: "",
            locked_msg: "",
            got: "got_charcoal",
            give: &["mgcharcoal"],
            msg: "mgmsg.charcoal",
        },
        Pick {
            spot: "matchbox",
            needs: "",
            locked_msg: "",
            got: "got_matches",
            give: &["mgmatches"],
            msg: "mgmsg.matches",
        },
    ],
    uses: &[
        Use {
            item: "mgchestkey",
            spot: "chest",
            needs: "",
            fail: "",
            keep: false,
            set: "chest_open",
            give: &[],
            msg: "mgmsg.chest_open",
        },
        Use {
            item: "mgcharcoal",
            spot: "brazier",
            needs: "",
            fail: "",
            keep: false,
            set: "coal_in",
            give: &[],
            msg: "mgmsg.coal_in",
        },
        Use {
            item: "mgmatches",
            spot: "brazier",
            needs: "coal_in",
            fail: "mgmsg.no_coal",
            keep: false,
            set: "fire_lit",
            give: &[],
            msg: "mgmsg.fire_lit",
        },
        Use {
            item: "mgwater",
            spot: "kettle",
            needs: "",
            fail: "",
            keep: false,
            set: "kettle_full",
            give: &[],
            msg: "mgmsg.kettle_full",
        },
        Use {
            item: "mgcandles",
            spot: "brazier",
            needs: "fire_lit",
            fail: "mgmsg.brazier_cold",
            keep: false,
            set: "candles_lit",
            give: &["mglit"],
            msg: "mgmsg.candles_lit",
        },
        Use {
            item: "mglit",
            spot: "paperboat",
            needs: "",
            fail: "",
            keep: false,
            set: "boat_ready",
            give: &[],
            msg: "mgmsg.boat_ready",
        },
    ],
    checks: &[
        Check {
            flag: "raked",
            cond: |s| s.flag("got_rake") && s.val("gravel") == GRAVEL,
            msg: "mgmsg.raked",
        },
        Check {
            flag: "gate_aligned",
            cond: |s| s.flag("lantern_lit") && s.val("rings").iter().all(|r| *r == FULL),
            msg: "mgmsg.gate_aligned",
        },
    ],
    looks: &[],
    flavour: &[
        "aoki",
        "scroll",
        "screen",
        "chest",
        "brazier",
        "kettle",
        "teaset",
        "pond",
        "bridge",
        "paperboat",
        "stonelantern",
        "gravel",
        "rocks",
        "shrine",
        "scarer",
        "basin",
        "gate",
        "chime",
        "moon",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_rake"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("raked"),
            available: |s| s.flag("got_rake"),
        },
        Puzzle {
            solved: |s| s.flag("got_chestkey"),
            available: |s| s.flag("raked"),
        },
        Puzzle {
            solved: |s| s.flag("chest_open"),
            available: |s| s.flag("got_chestkey"),
        },
        Puzzle {
            solved: |s| s.flag("got_food"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("koi_fed"),
            available: |s| s.flag("got_food"),
        },
        Puzzle {
            solved: |s| s.flag("got_candles"),
            available: |s| s.flag("koi_fed"),
        },
        Puzzle {
            solved: |s| s.flag("got_ladle"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("water_caught"),
            available: |s| s.flag("got_ladle"),
        },
        Puzzle {
            solved: |s| s.flag("got_charcoal"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_matches"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("coal_in"),
            available: |s| s.flag("got_charcoal"),
        },
        Puzzle {
            solved: |s| s.flag("fire_lit"),
            available: |s| s.flag("coal_in&got_matches"),
        },
        Puzzle {
            solved: |s| s.flag("kettle_full"),
            available: |s| s.flag("water_caught"),
        },
        Puzzle {
            solved: |s| s.flag("tea_served"),
            available: |s| s.flag("chest_open&kettle_full&fire_lit"),
        },
        Puzzle {
            solved: |s| s.flag("candles_lit"),
            available: |s| s.flag("got_candles&fire_lit"),
        },
        Puzzle {
            solved: |s| s.flag("boat_ready"),
            available: |s| s.flag("candles_lit"),
        },
        Puzzle {
            solved: |s| s.flag("lantern_lit"),
            available: |s| s.flag("boat_ready&tea_served"),
        },
        Puzzle {
            solved: |s| s.flag("gate_aligned"),
            available: |s| s.flag("lantern_lit"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY),
        },
    ],
    hint_views: &[
        ("MG1", &[10, 3, 11, 12, 13, 14, 15]),
        ("MG2", &[5, 6, 16]),
        ("MG3", &[1, 2, 4]),
        ("MG4", &[0, 7, 8, 9, 18, 19]),
        ("mgscroll", &[1, 14]),
        ("mggravel", &[1, 2]),
        ("mgpond", &[17]),
        ("mgkoi", &[5]),
        ("mggate", &[18]),
        ("mgtea", &[14]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::msg;

    #[test]
    fn the_moon_rises() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "turn gravel 0 +1"), "mgmsg.no_rake");
        msg(&mut r, "tap bamboo");
        for (i, g) in GRAVEL.iter().enumerate() {
            for _ in 0..*g {
                msg(&mut r, &format!("turn gravel {i} +1"));
            }
        }
        assert!(r.flag("raked"));
        msg(&mut r, "tap glint");
        msg(&mut r, "use mgchestkey chest");
        msg(&mut r, "tap offering");
        assert_eq!(msg(&mut r, &format!("koi {}", KOI[1])), "mgmsg.koi_squabble");
        for k in KOI {
            msg(&mut r, &format!("koi {k}"));
        }
        assert!(r.flag("koi_fed"));
        msg(&mut r, "tap candlebox");
        msg(&mut r, "tap ladle");
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "catch"), "mgmsg.not_pouring");
        msg(&mut r, &format!("time {}", SCARER.0 - 1));
        msg(&mut r, "catch");
        msg(&mut r, "tap shed");
        msg(&mut r, "tap matchbox");
        msg(&mut r, "use mgcharcoal brazier");
        msg(&mut r, "use mgmatches brazier");
        msg(&mut r, "use mgwater kettle");
        for k in TEA {
            msg(&mut r, &format!("tea {k}"));
        }
        assert!(r.flag("tea_served") && r.has("mgfan"));
        msg(&mut r, "use mgcandles brazier");
        msg(&mut r, "use mglit paperboat");
        // A lily pad sends the boat back to the bank.
        assert_eq!(msg(&mut r, "fan w"), "mgmsg.boat_back");
        for d in ROUTE {
            msg(&mut r, &format!("fan {d}"));
        }
        assert!(r.flag("lantern_lit"), "boat at {}", r.val("boat")[0]);
        for (ring, times) in [(0, 3), (2, 6)] {
            for _ in 0..times {
                msg(&mut r, &format!("ring {ring}"));
            }
        }
        assert!(r.flag("gate_aligned"), "{:?}", r.val("rings"));
        msg(&mut r, "tap gong");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }

    /// The fan's strokes from the bank to the island (the current adds one
    /// step east after each).
    const ROUTE: [&str; 5] = ["n", "n", "n", "e", "s"];
}
