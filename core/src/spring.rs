//! Puffin Island · Spring (series episode 1): nesting time. Maggie, the
//! island keeper, is laid up with a sprained ankle; the puffins land at dusk
//! and the supply boat is due. Views: `PS1` (the jetty: the gap, the
//! boathouse, the boat, the bell), `PS2` (Maggie's cottage: her bed, boots,
//! coat, the stove and Pip's box, the chart and tide clock, the shelf and
//! almanac), `PS3` (the cliffs: the flagpole, the puffin ledge, the bird
//! rock out at sea), `PS4` (the meadow: well, vegetable patch, woodpile,
//! the sheep pen and its gates).

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::island::{dir, moved, now, row, Course, Move};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{combine, sequence, Recipe};

/// The sea between the jetty (bottom left) and the bird rock (top right);
/// the tide runs east.
pub static SEA: Course = Course {
    w: 6,
    h: 5,
    blocked: &[1, 3, 12, 18, 19, 28],
    thin: &[],
    start: 24,
    goal: 5,
    drift: (1, 0),
};
/// The fish takes the bait for the last 3 seconds of every 8.
pub const BITE: (u32, u32) = (8, 3);
/// The meadow's gates (0 left, 1 right) that lead the lamb into its pen.
pub const GATES: [u8; 3] = [1, 0, 0];
/// The patch's rows (shade by the wall, middle, sunny side): seed packets
/// 0 carrot, 1 bean, 2 cabbage, 3 onion.
pub const ROWS: [u8; 3] = [2, 0, 1];
/// The three flags to hoist (of six), top to bottom.
pub const FLAGS: [u8; 3] = [4, 1, 3];
/// The puffin call on the bone whistle: 0 short, 1 long.
pub const CALL: [u8; 4] = [1, 0, 1, 1];

const RECIPES: &[Recipe] = &[("psline", "psworms", "psrod", "got_rod", "psmsg.rod")];

pub static LINES: [Line; 3] = [
    Line {
        text: "pstalk.1",
        choices: &[("pssay.1a", 2), ("pssay.1b", 0), ("pssay.1c", 0)],
        sets: "",
    },
    Line {
        text: "pstalk.2",
        choices: &[("pssay.2a", 0), ("pssay.2b", 3), ("pssay.2c", 0)],
        sets: "",
    },
    Line {
        text: "pstalk.3",
        choices: &[("pssay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"sea\":{},\"bite\":[{},{}],\"rows\":[{}],\"flags\":[{}],\"call\":[{}],\"lines\":[{}]}}",
        SEA.json(),
        BITE.0,
        BITE.1,
        nums_json(&ROWS),
        nums_json(&FLAGS),
        nums_json(&CALL),
        lines_json(&LINES)
    )
}

/// Where the lamb ends up with the gates as they stand.
pub fn lamb_goes(g: &[u8]) -> &'static str {
    match (g[0], g[1], g[2]) {
        (0, 0, _) => "garden",
        (0, _, _) => "bog",
        (_, _, 0) => "pen",
        _ => "cliff",
    }
}

const READY: &str = "jetty_fixed&pip_fed&lamb_in&watered&flags_ok&called";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let Some(r) = combine(s, words, RECIPES) {
        return Some(r);
    }
    match words {
        ["row", d] => Some(match dir(d) {
            None => Err(bad("row")),
            Some(_) if !s.flag("oars_in") => Ok("psmsg.no_oars".into()),
            Some(_) if s.flag("at_rock") => Ok("psmsg.rowed".into()),
            Some(d) => {
                let m = row(s, "boat", &SEA, d);
                if m == Move::Arrived {
                    s.set("at_rock");
                }
                moved(m, "ps", "row")
            }
        }),
        ["use", "psrod", "jetty"] if s.has("psrod") => Some(Ok(if !s.flag("jetty_fixed") {
            "psmsg.gap_first"
        } else if now(s, BITE.0, BITE.1) {
            s.take("psrod");
            s.give("psfish");
            s.set("got_fish");
            "psmsg.fish"
        } else {
            "psmsg.no_bite"
        }
        .into())),
        ["lamb"] => Some(Ok(if s.flag("lamb_in") {
            "psmsg.nothing".into()
        } else {
            match lamb_goes(s.val("gates")) {
                "pen" => {
                    s.set("lamb_in");
                    "psmsg.lamb_pen".into()
                }
                other => format!("psmsg.lamb_{other}"),
            }
        })),
        ["call", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 2) {
            None => Err(bad("call")),
            Some(_) if !s.has("pswhistle") => Ok("psmsg.no_whistle".into()),
            Some(_) if s.flag("called") => Ok(String::new()),
            Some(c) => match sequence(s, "calls", &CALL, c) {
                (true, _) => {
                    s.set("called");
                    Ok("psmsg.puffins".into())
                }
                _ => Ok(String::new()),
            },
        }),
        ["tap", "bell"] => Some(Ok(if s.flag(READY) {
            s.set("done");
            "psmsg.boat_comes"
        } else {
            "psmsg.not_ready"
        }
        .into())),
        _ => talk(s, words, &LINES, "pip_home", "ps"),
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 10;

pub static SPEC: Spec = Spec {
    id: "spring",
    prefix: "ps",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_key",
        "boathouse_open",
        "got_planks",
        "planks_laid",
        "jetty_fixed",
        "oars_in",
        "at_rock",
        "got_pip",
        "pip_home",
        "dug",
        "got_line",
        "got_rod",
        "got_fish",
        "pip_fed",
        "lamb_in",
        "got_seeds",
        "sown",
        "got_can",
        "got_water",
        "watered",
        "told",
        "flags_ok",
        "got_whistle",
        "called",
        "done",
    ],
    items: &[
        "pskey",
        "psoars",
        "pstools",
        "psspade",
        "psplanks",
        "pspip",
        "psworms",
        "psline",
        "psrod",
        "psfish",
        "psseeds",
        "pscan",
        "pswater",
        "pswhistle",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "boat",
            size: 30,
            start: &[24],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "gates",
            size: 2,
            start: &[0, 0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "lamb_in",
        },
        Dial {
            name: "rows",
            size: 4,
            start: &[3, 3, 3],
            wrap: true,
            needs: "got_seeds&dug",
            needs_msg: "psmsg.rows_wait",
            freeze: "sown",
        },
        Dial {
            name: "pennants",
            size: 6,
            start: &[0, 0, 0],
            wrap: true,
            needs: "told",
            needs_msg: "psmsg.flags_which",
            freeze: "flags_ok",
        },
        Dial {
            name: "calls",
            size: 6,
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
            spot: "boots",
            needs: "",
            locked_msg: "",
            got: "got_key",
            give: &["pskey"],
            msg: "psmsg.key",
        },
        Pick {
            spot: "woodpile",
            needs: "",
            locked_msg: "",
            got: "got_planks",
            give: &["psplanks"],
            msg: "psmsg.planks",
        },
        Pick {
            spot: "nest",
            needs: "at_rock",
            locked_msg: "psmsg.nest_far",
            got: "got_pip",
            give: &["pspip"],
            msg: "psmsg.pip",
        },
        Pick {
            spot: "coat",
            needs: "",
            locked_msg: "",
            got: "got_line",
            give: &["psline"],
            msg: "psmsg.line",
        },
        Pick {
            spot: "seedtin",
            needs: "",
            locked_msg: "",
            got: "got_seeds",
            give: &["psseeds"],
            msg: "psmsg.seeds",
        },
        Pick {
            spot: "can",
            needs: "",
            locked_msg: "",
            got: "got_can",
            give: &["pscan"],
            msg: "psmsg.can",
        },
        Pick {
            spot: "whistle",
            needs: "",
            locked_msg: "",
            got: "got_whistle",
            give: &["pswhistle"],
            msg: "psmsg.whistle",
        },
    ],
    uses: &[
        Use {
            item: "pskey",
            spot: "boathouse",
            needs: "",
            fail: "",
            keep: false,
            set: "boathouse_open",
            give: &["psoars", "pstools", "psspade"],
            msg: "psmsg.boathouse",
        },
        Use {
            item: "psplanks",
            spot: "gap",
            needs: "",
            fail: "",
            keep: false,
            set: "planks_laid",
            give: &[],
            msg: "psmsg.planks_laid",
        },
        Use {
            item: "pstools",
            spot: "gap",
            needs: "planks_laid",
            fail: "psmsg.no_planks",
            keep: false,
            set: "jetty_fixed",
            give: &[],
            msg: "psmsg.jetty_fixed",
        },
        Use {
            item: "psoars",
            spot: "boat",
            needs: "",
            fail: "",
            keep: false,
            set: "oars_in",
            give: &[],
            msg: "psmsg.oars_in",
        },
        Use {
            item: "pspip",
            spot: "box",
            needs: "",
            fail: "",
            keep: false,
            set: "pip_home",
            give: &[],
            msg: "psmsg.pip_home",
        },
        Use {
            item: "psspade",
            spot: "patch",
            needs: "",
            fail: "",
            keep: false,
            set: "dug",
            give: &["psworms"],
            msg: "psmsg.dug",
        },
        Use {
            item: "psfish",
            spot: "box",
            needs: "pip_home",
            fail: "",
            keep: false,
            set: "pip_fed",
            give: &[],
            msg: "psmsg.pip_fed",
        },
        Use {
            item: "psseeds",
            spot: "patch",
            needs: "",
            fail: "",
            keep: true,
            set: "",
            give: &[],
            msg: "psmsg.which_rows",
        },
        Use {
            item: "pscan",
            spot: "well",
            needs: "",
            fail: "",
            keep: false,
            set: "got_water",
            give: &["pswater"],
            msg: "psmsg.water",
        },
        Use {
            item: "pswater",
            spot: "patch",
            needs: "sown",
            fail: "psmsg.sow_first",
            keep: false,
            set: "watered",
            give: &[],
            msg: "psmsg.watered",
        },
    ],
    checks: &[
        Check {
            flag: "sown",
            cond: |s| s.flag("got_seeds&dug") && s.val("rows") == ROWS,
            msg: "psmsg.sown",
        },
        Check {
            flag: "flags_ok",
            cond: |s| s.flag("told") && s.val("pennants") == FLAGS,
            msg: "psmsg.flags_ok",
        },
    ],
    looks: &[],
    flavour: &[
        "maggie",
        "stove",
        "chart",
        "tideclock",
        "almanac",
        "shelf",
        "jetty",
        "boat",
        "boathouse",
        "gap",
        "bell",
        "cliffs",
        "puffins",
        "rock",
        "flagpole",
        "signals",
        "well",
        "patch",
        "pen",
        "gates",
        "box",
        "sea",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("boathouse_open"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("got_planks"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("planks_laid"),
            available: |s| s.flag("got_planks"),
        },
        Puzzle {
            solved: |s| s.flag("jetty_fixed"),
            available: |s| s.flag("planks_laid&boathouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("oars_in"),
            available: |s| s.flag("boathouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("at_rock"),
            available: |s| s.flag("oars_in"),
        },
        Puzzle {
            solved: |s| s.flag("got_pip"),
            available: |s| s.flag("at_rock"),
        },
        Puzzle {
            solved: |s| s.flag("pip_home"),
            available: |s| s.flag("got_pip"),
        },
        Puzzle {
            solved: |s| s.flag("dug"),
            available: |s| s.flag("boathouse_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_line"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_rod"),
            available: |s| s.flag("got_line&dug"),
        },
        Puzzle {
            solved: |s| s.flag("got_fish"),
            available: |s| s.flag("got_rod&jetty_fixed"),
        },
        Puzzle {
            solved: |s| s.flag("pip_fed"),
            available: |s| s.flag("got_fish&pip_home"),
        },
        Puzzle {
            solved: |s| s.flag("lamb_in"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("sown"),
            available: |s| s.flag("got_seeds&dug"),
        },
        Puzzle {
            solved: |s| s.flag("got_can"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_water"),
            available: |s| s.flag("got_can"),
        },
        Puzzle {
            solved: |s| s.flag("watered"),
            available: |s| s.flag("got_water&sown"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("pip_home"),
        },
        Puzzle {
            solved: |s| s.flag("flags_ok"),
            available: |s| s.flag("told"),
        },
        Puzzle {
            solved: |s| s.flag("called"),
            available: |s| s.flag("got_whistle"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY),
        },
    ],
    hint_views: &[
        ("PS1", &[1, 3, 4, 5, 6, 12, 22]),
        ("PS2", &[0, 8, 10, 13, 19]),
        ("PS3", &[20, 21]),
        ("PS4", &[2, 9, 14, 15, 16, 17, 18]),
        ("psboat", &[6, 7]),
        ("psmaggie", &[19]),
        ("psalmanac", &[15, 21]),
        ("pschart", &[6]),
        ("psflags", &[20]),
        ("psgates", &[14]),
        ("pspatch", &[15, 18]),
        ("psledge", &[21]),
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

    /// The way to the bird rock, read off the chart with the tide.
    const WAY: &str = "ennnn";

    #[test]
    fn the_supply_boat_comes() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap boots");
        msg(&mut r, "use pskey boathouse");
        msg(&mut r, "tap woodpile");
        assert_eq!(msg(&mut r, "use pstools gap"), "psmsg.no_planks");
        msg(&mut r, "use psplanks gap");
        msg(&mut r, "use pstools gap");
        msg(&mut r, "use psoars boat");
        // Straight up from the jetty, the tide takes the boat onto a rock.
        assert_eq!(msg(&mut r, "row n"), "psmsg.row_back");
        for d in WAY.chars() {
            msg(&mut r, &format!("row {d}"));
        }
        assert!(r.flag("at_rock"));
        msg(&mut r, "tap nest");
        msg(&mut r, "use pspip box");
        msg(&mut r, "use psspade patch");
        msg(&mut r, "tap coat");
        msg(&mut r, "use psworms psline");
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "use psrod jetty"), "psmsg.no_bite");
        msg(&mut r, &format!("time {}", BITE.0 - 1));
        msg(&mut r, "use psrod jetty");
        msg(&mut r, "use psfish box");
        assert_eq!(msg(&mut r, "lamb"), "psmsg.lamb_garden");
        turn_to(&mut r, "gates", &GATES, 2);
        msg(&mut r, "lamb");
        assert!(r.flag("lamb_in"));
        msg(&mut r, "tap seedtin");
        turn_to(&mut r, "rows", &ROWS, 4);
        assert!(r.flag("sown"));
        msg(&mut r, "tap can");
        msg(&mut r, "use pscan well");
        msg(&mut r, "use pswater patch");
        say_all(&mut r, &[0, 1, 0]);
        assert!(r.flag("told"));
        turn_to(&mut r, "pennants", &FLAGS, 6);
        assert!(r.flag("flags_ok"));
        assert_eq!(msg(&mut r, "tap bell"), "psmsg.not_ready");
        msg(&mut r, "tap whistle");
        for c in CALL {
            msg(&mut r, &format!("call {c}"));
        }
        msg(&mut r, "tap bell");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
