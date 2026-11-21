//! Puffin Island · Winter (series episode 4): the northern lights. The
//! longest night, the lighthouse lamp is out and a ship is due; the spare
//! oil is in the ice cave across the frozen lake. Views: `PW1` (the frozen
//! lake), `PW2` (the snowed-in cottage: Maggie, the stove, the coal scuttle,
//! the skates, the almanac), `PW3` (the lamp room: lamp, lens panels,
//! clockwork, the chart of lights), `PW4` (the ice cave: icicles, the oil
//! barrel).

use crate::bad;
use crate::house::{lines_json, piano, played, talk, tune_json, Line};
use crate::island::{dir, moved, skate, Course, Move};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::set9::{combine, Recipe};

/// The lake, 7 by 6: snowbanks stop the skater, thin ice (only in the
/// almanac) breaks. From the cottage's shore (bottom left) to the cave
/// (top right).
pub static LAKE: Course = Course {
    w: 7,
    h: 6,
    blocked: &[2, 7, 19, 20, 33, 36, 37],
    thin: &[11, 23, 26, 27],
    start: 35,
    goal: 6,
    drift: (0, 0),
};
/// The carol the icicles ring (icicles 0 to 4, left to right).
pub const CAROL: [u8; 5] = [2, 4, 1, 3, 0];
/// The lens panels start frosted at these turns; each turn moves a panel and
/// its right-hand neighbour (the last moves the first).
pub const PANELS: [u8; 3] = [1, 3, 2];
/// The light's character on the chart (patterns 0 to 5).
pub const PATTERN: u8 = 4;

const RECIPES: &[Recipe] = &[("pwlantern", "pwdry", "pwlit", "lantern_lit", "pwmsg.lantern_lit")];

pub static LINES: [Line; 3] = [
    Line {
        text: "pwtalk.1",
        choices: &[("pwsay.1a", 2), ("pwsay.1b", 0), ("pwsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "pwtalk.2",
        choices: &[("pwsay.2a", 0), ("pwsay.2b", 0), ("pwsay.2c", 3)],
        sets: "",
    },
    Line {
        text: "pwtalk.3",
        choices: &[("pwsay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"lake\":{},\"thin\":{},\"carol\":{},\"pattern\":{PATTERN},\"lines\":[{}]}}",
        LAKE.json(),
        LAKE.thin_json(),
        tune_json(&CAROL),
        lines_json(&LINES)
    )
}

const READY: &str = "oiled&lens_ok&wound&pattern_ok";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let Some(r) = combine(s, words, RECIPES) {
        return Some(r);
    }
    match words {
        ["skate", d] => Some(match dir(d) {
            None => Err(bad("skate")),
            Some(_) if !s.has("pwskates") => Ok("pwmsg.no_skates".into()),
            Some(_) if s.flag("across") => Ok("pwmsg.skated".into()),
            Some(d) => {
                let m = skate(s, "skater", &LAKE, d);
                if m == Move::Arrived {
                    s.set("across");
                }
                moved(m, "pw", "skate")
            }
        }),
        ["key", i] if i.parse::<u8>().is_ok_and(|k| k < 5) => Some(if !s.flag("cave_lit") {
            Ok("pwmsg.too_dark".into())
        } else {
            piano(s, words).unwrap_or_else(|| Ok(String::new()))
        }),
        ["key", _] => Some(Err(bad("key"))),
        ["panel", i] => Some(match i.parse::<usize>().ok().filter(|i| *i < 3) {
            None => Err(bad("panel")),
            Some(_) if s.flag("lens_ok") => Ok(String::new()),
            Some(i) => {
                let p = s.val_mut("panels");
                p[i] = (p[i] + 1) % 4;
                p[(i + 1) % 3] = (p[(i + 1) % 3] + 1) % 4;
                Ok(String::new())
            }
        }),
        ["use", "pwlit", "lamp"] if s.has("pwlit") => Some(Ok(if s.flag(READY) {
            s.set("done");
            "pwmsg.light".into()
        } else {
            "pwmsg.not_ready".into()
        })),
        _ => talk(s, words, &LINES, "dug_out", "pw"),
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 9;

pub static SPEC: Spec = Spec {
    id: "winter",
    prefix: "pw",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_shovel",
        "dug_out",
        "got_skates",
        "got_matches",
        "dried",
        "got_lantern",
        "lantern_lit",
        "told",
        "across",
        "cave_lit",
        "freed",
        "got_can",
        "got_oil",
        "oiled",
        "lens_ok",
        "got_crank",
        "wound",
        "pattern_ok",
        "done",
    ],
    items: &[
        "pwshovel",
        "pwskates",
        "pwwet",
        "pwdry",
        "pwlantern",
        "pwlit",
        "pwcan",
        "pwoil",
        "pwcrank",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "skater",
            size: 42,
            start: &[35],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "played",
            size: 9,
            start: &[0; 5],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "panels",
            size: 4,
            start: &PANELS,
            wrap: true,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "pattern",
            size: 6,
            start: &[0],
            wrap: true,
            needs: "oiled",
            needs_msg: "pwmsg.lamp_cold",
            freeze: "pattern_ok",
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
            spot: "scuttle",
            needs: "",
            locked_msg: "",
            got: "got_shovel",
            give: &["pwshovel"],
            msg: "pwmsg.shovel",
        },
        Pick {
            spot: "skates",
            needs: "",
            locked_msg: "",
            got: "got_skates",
            give: &["pwskates"],
            msg: "pwmsg.skates",
        },
        Pick {
            spot: "drawer",
            needs: "",
            locked_msg: "",
            got: "got_matches",
            give: &["pwwet"],
            msg: "pwmsg.wet",
        },
        Pick {
            spot: "lanternhook",
            needs: "",
            locked_msg: "",
            got: "got_lantern",
            give: &["pwlantern"],
            msg: "pwmsg.lantern",
        },
        Pick {
            spot: "oilcan",
            needs: "freed",
            locked_msg: "pwmsg.behind_ice",
            got: "got_can",
            give: &["pwcan"],
            msg: "pwmsg.can",
        },
        Pick {
            spot: "crank",
            needs: "dug_out",
            locked_msg: "pwmsg.snowed_in",
            got: "got_crank",
            give: &["pwcrank"],
            msg: "pwmsg.crank",
        },
    ],
    uses: &[
        Use {
            item: "pwshovel",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "dug_out",
            give: &[],
            msg: "pwmsg.dug_out",
        },
        Use {
            item: "pwwet",
            spot: "stove",
            needs: "",
            fail: "",
            keep: false,
            set: "dried",
            give: &["pwdry"],
            msg: "pwmsg.dried",
        },
        Use {
            item: "pwlit",
            spot: "cave",
            needs: "across",
            fail: "pwmsg.cave_far",
            keep: true,
            set: "cave_lit",
            give: &[],
            msg: "pwmsg.cave_lit",
        },
        Use {
            item: "pwcan",
            spot: "barrel",
            needs: "",
            fail: "",
            keep: false,
            set: "got_oil",
            give: &["pwoil"],
            msg: "pwmsg.oil",
        },
        Use {
            item: "pwoil",
            spot: "lamp",
            needs: "",
            fail: "",
            keep: false,
            set: "oiled",
            give: &[],
            msg: "pwmsg.oiled",
        },
        Use {
            item: "pwcrank",
            spot: "clockwork",
            needs: "",
            fail: "",
            keep: false,
            set: "wound",
            give: &[],
            msg: "pwmsg.wound",
        },
    ],
    checks: &[
        Check {
            flag: "freed",
            cond: |s| s.flag("cave_lit&told") && played(s, &CAROL),
            msg: "pwmsg.icicles_fall",
        },
        Check {
            flag: "lens_ok",
            cond: |s| s.val("panels") == [0, 0, 0],
            msg: "pwmsg.lens_ok",
        },
        Check {
            flag: "pattern_ok",
            cond: |s| s.flag("oiled") && s.val("pattern")[0] == PATTERN,
            msg: "pwmsg.pattern_ok",
        },
    ],
    looks: &[],
    flavour: &[
        "maggie",
        "stove",
        "door",
        "almanac",
        "window",
        "lake",
        "shore",
        "lamp",
        "lens",
        "clockwork",
        "chart",
        "aurora",
        "cave",
        "icicles",
        "barrel",
        "ship",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_shovel"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("dug_out"),
            available: |s| s.flag("got_shovel"),
        },
        Puzzle {
            solved: |s| s.flag("got_skates"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_matches"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("dried"),
            available: |s| s.flag("got_matches"),
        },
        Puzzle {
            solved: |s| s.flag("got_lantern"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lantern_lit"),
            available: |s| s.flag("dried&got_lantern"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("dug_out"),
        },
        Puzzle {
            solved: |s| s.flag("across"),
            available: |s| s.flag("got_skates"),
        },
        Puzzle {
            solved: |s| s.flag("cave_lit"),
            available: |s| s.flag("across&lantern_lit"),
        },
        Puzzle {
            solved: |s| s.flag("freed"),
            available: |s| s.flag("cave_lit&told"),
        },
        Puzzle {
            solved: |s| s.flag("got_can"),
            available: |s| s.flag("freed"),
        },
        Puzzle {
            solved: |s| s.flag("got_oil"),
            available: |s| s.flag("got_can"),
        },
        Puzzle {
            solved: |s| s.flag("oiled"),
            available: |s| s.flag("got_oil"),
        },
        Puzzle {
            solved: |s| s.flag("lens_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_crank"),
            available: |s| s.flag("dug_out"),
        },
        Puzzle {
            solved: |s| s.flag("wound"),
            available: |s| s.flag("got_crank"),
        },
        Puzzle {
            solved: |s| s.flag("pattern_ok"),
            available: |s| s.flag("oiled"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY) && s.flag("lantern_lit"),
        },
    ],
    hint_views: &[
        ("PW1", &[8]),
        ("PW2", &[0, 1, 2, 3, 4, 5, 6, 7]),
        ("PW3", &[13, 14, 15, 16, 17, 18]),
        ("PW4", &[9, 10, 11, 12]),
        ("pwlake", &[8]),
        ("pwalmanac", &[8, 10, 17]),
        ("pwmaggie", &[7]),
        ("pwicicles", &[10]),
        ("pwlens", &[14]),
        ("pwchart", &[17]),
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

    /// The way across the lake, around the thin ice the almanac marks.
    const WAY: &str = "neswne";
    /// Turns of each lens panel that clear the frost.
    const TURNS: [usize; 3] = [1, 0, 2];

    #[test]
    fn the_lamp_burns() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap scuttle");
        msg(&mut r, "use pwshovel door");
        msg(&mut r, "tap skates");
        msg(&mut r, "tap drawer");
        msg(&mut r, "use pwwet stove");
        msg(&mut r, "tap lanternhook");
        msg(&mut r, "use pwdry pwlantern");
        say_all(&mut r, &[0, 2, 0]);
        assert!(r.flag("told"));
        // The short way (north, east, north) crosses thin ice.
        msg(&mut r, "skate n");
        msg(&mut r, "skate e");
        assert_eq!(msg(&mut r, "skate n"), "pwmsg.skate_back");
        for d in WAY.chars() {
            msg(&mut r, &format!("skate {d}"));
        }
        assert!(r.flag("across"));
        assert_eq!(msg(&mut r, "key 0"), "pwmsg.too_dark");
        msg(&mut r, "use pwlit cave");
        for k in CAROL {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(r.flag("freed"));
        msg(&mut r, "tap oilcan");
        msg(&mut r, "use pwcan barrel");
        msg(&mut r, "use pwoil lamp");
        for (i, n) in TURNS.iter().enumerate() {
            for _ in 0..*n {
                msg(&mut r, &format!("panel {i}"));
            }
        }
        assert!(r.flag("lens_ok"));
        msg(&mut r, "tap crank");
        msg(&mut r, "use pwcrank clockwork");
        assert_eq!(msg(&mut r, "use pwlit lamp"), "pwmsg.not_ready");
        turn_to(&mut r, "pattern", &[PATTERN], 6);
        msg(&mut r, "use pwlit lamp");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
