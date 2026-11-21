//! Puffin Island · Summer (series episode 2): the storm. A squall is coming,
//! Tom's dinghy is caught at the sea stack and Ewan's fishing boat is still
//! out. Views: `PU1` (the harbour: the jetty mended in spring, lobster pots,
//! the harbour wall, the horn), `PU2` (the lighthouse: its door, the store,
//! the lamp room), `PU3` (the hay field and barn), `PU4` (the headland: the
//! wind sock, the sea stack with Tom).

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::island::{kite, now};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{combine, sequence, Recipe};

/// Pip sits on the harbour wall for the last 3 seconds of every 10.
pub const PIP: (u32, u32) = (10, 3);
/// Gusts blow for the last 2 seconds of every 5.
pub const GUST: (u32, u32) = (5, 2);
/// The kite's height when the line reaches the stack.
pub const KITE_TOP: u8 = 5;
/// The lens (0 to 7) that throws the beam onto Ewan's boat.
pub const LENS: u8 = 6;
/// The shutter's message to Ewan: 0 short, 1 long.
pub const FLASHES: [u8; 5] = [0, 1, 1, 0, 1];
/// The bales into the loft, by their marks (0 to 3), as the barn's sign
/// shows the stack.
pub const BALES: [u8; 4] = [2, 0, 3, 1];

const RECIPES: &[Recipe] = &[
    ("pukite", "pusewing", "pumended", "mended", "pumsg.mended"),
    ("pumended", "putwine", "puflyer", "rigged", "pumsg.rigged"),
];

pub static LINES: [Line; 3] = [
    Line {
        text: "putalk.1",
        choices: &[("pusay.1a", 0), ("pusay.1b", 2), ("pusay.1c", 0)],
        sets: "",
    },
    Line {
        text: "putalk.2",
        choices: &[("pusay.2a", 3), ("pusay.2b", 0), ("pusay.2c", 0)],
        sets: "",
    },
    Line {
        text: "putalk.3",
        choices: &[("pusay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"pip\":[{},{}],\"gust\":[{},{}],\"top\":{KITE_TOP},\"lens\":{LENS},\"flashes\":[{}],\"bales\":[{}],\"lines\":[{}]}}",
        PIP.0,
        PIP.1,
        GUST.0,
        GUST.1,
        nums_json(&FLASHES),
        nums_json(&BALES),
        lines_json(&LINES)
    )
}

const READY: &str = "tom_safe&signalled&hay_in&beam_ok";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let Some(r) = combine(s, words, RECIPES) {
        return Some(r);
    }
    match words {
        ["tap", "wall"] => Some(Ok(if s.flag("got_screw") {
            "pumsg.wall".into()
        } else if now(s, PIP.0, PIP.1) {
            s.set("got_screw");
            s.give("puscrew");
            "pumsg.pip_screw".into()
        } else {
            "pumsg.wall".into()
        })),
        ["kite", how @ ("out" | "in")] => Some(Ok(if !s.has("puflyer") {
            "pumsg.no_kite".into()
        } else if s.flag("tom_safe") {
            String::new()
        } else {
            let gust = now(s, GUST.0, GUST.1);
            let before = s.val("kite")[0];
            if kite(s, "kite", *how == "out", gust, KITE_TOP) {
                s.take("puflyer");
                s.set("tom_safe");
                "pumsg.line_across".into()
            } else if s.val("kite")[0] < before {
                "pumsg.kite_dips".into()
            } else {
                String::new()
            }
        })),
        ["flash", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 2) {
            None => Err(bad("flash")),
            Some(_) if !s.flag("lit") => Ok("pumsg.lamp_dark".into()),
            Some(_) if !s.flag("told") => Ok("pumsg.what_message".into()),
            Some(_) if s.flag("signalled") => Ok(String::new()),
            Some(f) => match sequence(s, "flashed", &FLASHES, f) {
                (true, _) => {
                    s.set("signalled");
                    Ok("pumsg.signalled".into())
                }
                _ => Ok(String::new()),
            },
        }),
        ["bale", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 4) {
            None => Err(bad("bale")),
            Some(_) if !s.flag("barn_open") => Ok("pumsg.barn_shut".into()),
            Some(_) if s.flag("hay_in") => Ok(String::new()),
            Some(b) => match sequence(s, "stacked", &BALES, b) {
                (true, _) => {
                    s.set("hay_in");
                    Ok("pumsg.hay_in".into())
                }
                (false, true) => Ok("pumsg.bale_up".into()),
                (false, false) => Ok("pumsg.stack_falls".into()),
            },
        }),
        ["tap", "horn"] => Some(Ok(if s.flag(READY) {
            s.set("done");
            "pumsg.ewan_home"
        } else {
            "pumsg.not_ready"
        }
        .into())),
        _ => talk(s, words, &LINES, "tom_safe", "pu"),
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 8;

pub static SPEC: Spec = Spec {
    id: "summer",
    prefix: "pu",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_key",
        "lighthouse_open",
        "got_oil",
        "oiled",
        "got_screw",
        "screwed",
        "barn_open",
        "got_matches",
        "lit",
        "beam_ok",
        "got_kite",
        "got_sewing",
        "mended",
        "got_twine",
        "rigged",
        "tom_safe",
        "told",
        "signalled",
        "hay_in",
        "done",
    ],
    items: &[
        "pukey",
        "puoil",
        "puscrew",
        "pumatches",
        "pukite",
        "pusewing",
        "pumended",
        "putwine",
        "puflyer",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "lens",
            size: 8,
            start: &[1],
            wrap: true,
            needs: "screwed&lit",
            needs_msg: "pumsg.lens_stuck",
            freeze: "beam_ok",
        },
        Dial {
            name: "kite",
            size: 6,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "flashed",
            size: 6,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "stacked",
            size: 5,
            start: &[0],
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
            spot: "pots",
            needs: "",
            locked_msg: "",
            got: "got_key",
            give: &["pukey"],
            msg: "pumsg.key",
        },
        Pick {
            spot: "store",
            needs: "lighthouse_open",
            locked_msg: "pumsg.door_locked",
            got: "got_oil",
            give: &["puoil"],
            msg: "pumsg.oil",
        },
        Pick {
            spot: "sewingbox",
            needs: "lighthouse_open",
            locked_msg: "pumsg.door_locked",
            got: "got_sewing",
            give: &["pusewing"],
            msg: "pumsg.sewing",
        },
        Pick {
            spot: "barndoor",
            needs: "",
            locked_msg: "",
            got: "barn_open",
            give: &[],
            msg: "pumsg.barn",
        },
        Pick {
            spot: "matchbox",
            needs: "barn_open",
            locked_msg: "pumsg.barn_shut",
            got: "got_matches",
            give: &["pumatches"],
            msg: "pumsg.matches",
        },
        Pick {
            spot: "oldkite",
            needs: "barn_open",
            locked_msg: "pumsg.barn_shut",
            got: "got_kite",
            give: &["pukite"],
            msg: "pumsg.kite",
        },
        Pick {
            spot: "twine",
            needs: "barn_open",
            locked_msg: "pumsg.barn_shut",
            got: "got_twine",
            give: &["putwine"],
            msg: "pumsg.twine",
        },
    ],
    uses: &[
        Use {
            item: "pukey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "lighthouse_open",
            give: &[],
            msg: "pumsg.door_open",
        },
        Use {
            item: "puoil",
            spot: "lamp",
            needs: "",
            fail: "",
            keep: false,
            set: "oiled",
            give: &[],
            msg: "pumsg.oiled",
        },
        Use {
            item: "puscrew",
            spot: "lens",
            needs: "lighthouse_open",
            fail: "pumsg.door_locked",
            keep: false,
            set: "screwed",
            give: &[],
            msg: "pumsg.screwed",
        },
        Use {
            item: "pumatches",
            spot: "lamp",
            needs: "oiled",
            fail: "pumsg.no_oil",
            keep: false,
            set: "lit",
            give: &[],
            msg: "pumsg.lit",
        },
    ],
    checks: &[Check {
        flag: "beam_ok",
        cond: |s| s.flag("screwed&lit") && s.val("lens")[0] == LENS,
        msg: "pumsg.beam_ok",
    }],
    looks: &[],
    flavour: &[
        "jetty",
        "horn",
        "clouds",
        "lighthouse",
        "door",
        "lamp",
        "lens",
        "shutter",
        "codecard",
        "barn",
        "bales",
        "sign",
        "windsock",
        "stack",
        "tom",
        "sea",
        "headland",
        "almanac",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lighthouse_open"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("got_oil"),
            available: |s| s.flag("lighthouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("oiled"),
            available: |s| s.flag("got_oil"),
        },
        Puzzle {
            solved: |s| s.flag("got_screw"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("screwed"),
            available: |s| s.flag("got_screw&lighthouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("barn_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_matches"),
            available: |s| s.flag("barn_open"),
        },
        Puzzle {
            solved: |s| s.flag("lit"),
            available: |s| s.flag("got_matches&oiled"),
        },
        Puzzle {
            solved: |s| s.flag("beam_ok"),
            available: |s| s.flag("screwed&lit"),
        },
        Puzzle {
            solved: |s| s.flag("got_kite"),
            available: |s| s.flag("barn_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_sewing"),
            available: |s| s.flag("lighthouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("mended"),
            available: |s| s.flag("got_kite&got_sewing"),
        },
        Puzzle {
            solved: |s| s.flag("got_twine"),
            available: |s| s.flag("barn_open"),
        },
        Puzzle {
            solved: |s| s.flag("rigged"),
            available: |s| s.flag("mended&got_twine"),
        },
        Puzzle {
            solved: |s| s.flag("tom_safe"),
            available: |s| s.flag("rigged"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("tom_safe"),
        },
        Puzzle {
            solved: |s| s.flag("signalled"),
            available: |s| s.flag("told&lit"),
        },
        Puzzle {
            solved: |s| s.flag("hay_in"),
            available: |s| s.flag("barn_open"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY),
        },
    ],
    hint_views: &[
        ("PU1", &[0, 4, 19]),
        ("PU2", &[1, 2, 3, 5, 8, 9, 11, 17]),
        ("PU3", &[6, 7, 10, 13, 18]),
        ("PU4", &[12, 14, 15, 16]),
        ("pulamp", &[3, 5, 8, 9, 17]),
        ("pukite", &[15]),
        ("putom", &[16]),
        ("pubarn", &[7, 10, 13, 18]),
        ("pualmanac", &[15, 17]),
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
    fn ewan_comes_home() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap pots");
        msg(&mut r, "use pukey door");
        msg(&mut r, "tap store");
        msg(&mut r, "use puoil lamp");
        msg(&mut r, "tap sewingbox");
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "tap wall"), "pumsg.wall");
        msg(&mut r, &format!("time {}", PIP.0 - 1));
        msg(&mut r, "tap wall");
        msg(&mut r, "use puscrew lens");
        msg(&mut r, "tap barndoor");
        for spot in ["matchbox", "oldkite", "twine"] {
            msg(&mut r, &format!("tap {spot}"));
        }
        msg(&mut r, "use pumatches lamp");
        turn_to(&mut r, "lens", &[LENS], 8);
        assert!(r.flag("beam_ok"));
        msg(&mut r, "use pusewing pukite");
        msg(&mut r, "use putwine pumended");
        // In the calm the kite dips; with each gust it climbs.
        msg(&mut r, "time 10");
        msg(&mut r, "kite out");
        let mut t = 10;
        while !r.flag("tom_safe") {
            t += 1;
            msg(&mut r, &format!("time {t}"));
            let gust = t % GUST.0 >= GUST.0 - GUST.1;
            msg(&mut r, if gust { "kite out" } else { "kite in" });
            assert!(t < 60);
        }
        say_all(&mut r, &[1, 0, 0]);
        assert!(r.flag("told"));
        for f in FLASHES {
            msg(&mut r, &format!("flash {f}"));
        }
        assert_eq!(msg(&mut r, "bale 0"), "pumsg.stack_falls");
        for b in BALES {
            msg(&mut r, &format!("bale {b}"));
        }
        msg(&mut r, "tap horn");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
