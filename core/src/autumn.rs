//! Puffin Island · Autumn (series episode 3): harvest and the regatta. The
//! island's market day; Maggie's apple pie for the judges and the yearly boat
//! race. Views: `PA1` (the orchard: apple trees, the hen house, the shed,
//! the scarecrow), `PA2` (the cider house: press, oven, the spring patch's
//! harvest), `PA3` (the market on the jetty: the trader, the judges' table,
//! the crew), `PA4` (the bay: the regatta boats, the drum, Pip fishing).

use crate::house::{lines_json, talk, Line};
use crate::island::{now, stroke};
use crate::kit::{no_extra, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::set9::{combine, Recipe};

/// The wind shakes the trees for the last 2 seconds of every 6.
pub const WIND: (u32, u32) = (6, 2);
/// The press's screw (0 to 7): too loose gives no juice, too tight bursts.
pub const PRESS: u8 = 5;
/// The pie is golden for the last 3 seconds of every 9.
pub const GOLDEN: (u32, u32) = (9, 3);
/// The drum beats for 1 second in 2; strokes needed to win, strokes before
/// the other boat has won.
pub const BEAT: (u32, u32) = (2, 1);
pub const RACE: (u8, u8) = (6, 10);

const RECIPES: &[Recipe] = &[
    ("paflour", "paeggs", "padough", "got_dough", "pamsg.dough"),
    ("padough", "paapples", "papie", "got_pie", "pamsg.pie"),
];

pub static LINES: [Line; 3] = [
    Line {
        text: "patalk.1",
        choices: &[("pasay.1a", 0), ("pasay.1b", 0), ("pasay.1c", 2)],
        sets: "",
    },
    Line {
        text: "patalk.2",
        choices: &[("pasay.2a", 3), ("pasay.2b", 0), ("pasay.2c", 0)],
        sets: "",
    },
    Line {
        text: "patalk.3",
        choices: &[("pasay.3a", 0)],
        sets: "traded",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"wind\":[{},{}],\"press\":{PRESS},\"golden\":[{},{}],\"beat\":[{},{}],\"race\":[{},{}],\"lines\":[{}]}}",
        WIND.0,
        WIND.1,
        GOLDEN.0,
        GOLDEN.1,
        BEAT.0,
        BEAT.1,
        RACE.0,
        RACE.1,
        lines_json(&LINES)
    )
}

const READY: &str = "ribbon&won";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let Some(r) = combine(s, words, RECIPES) {
        return Some(r);
    }
    match words {
        ["tap", "tree"] => Some(Ok(if s.flag("got_apples") {
            "pamsg.tree".into()
        } else if !s.flag("net_spread") {
            "pamsg.no_net".into()
        } else if now(s, WIND.0, WIND.1) {
            s.set("got_apples");
            s.give("paapples");
            "pamsg.apples".into()
        } else {
            "pamsg.tree_still".into()
        })),
        ["tap", "oven"] if s.flag("baking") && !s.flag("baked") => Some(Ok(if now(s, GOLDEN.0, GOLDEN.1) {
            s.set("baked");
            s.give("pabaked");
            "pamsg.golden".into()
        } else {
            "pamsg.not_yet".into()
        })),
        ["tap", "crank"] => Some(Ok(if !s.flag("in_press") {
            "pamsg.press_empty".into()
        } else if s.flag("pressed") {
            "pamsg.nothing".into()
        } else {
            match s.val("screw")[0] {
                v if v == PRESS => {
                    s.set("pressed");
                    "pamsg.juice".into()
                }
                v if v > PRESS => {
                    s.val_mut("screw")[0] = 0;
                    "pamsg.too_tight".into()
                }
                _ => "pamsg.too_loose".into(),
            }
        })),
        ["stroke"] => Some(Ok(if !s.flag("aboard") {
            "pamsg.not_aboard".into()
        } else if s.flag("won") {
            String::new()
        } else {
            let beat = now(s, BEAT.0, BEAT.1);
            match stroke(s, "race", beat, RACE.0, RACE.1) {
                "won" => {
                    s.set("won");
                    "pamsg.won".into()
                }
                other => format!("pamsg.{other}"),
            }
        })),
        ["tap", "cup"] => Some(Ok(if s.flag(READY) {
            s.set("done");
            "pamsg.cup".into()
        } else {
            "pamsg.not_ready".into()
        })),
        _ => {
            let r = talk(s, words, &LINES, "got_cider", "pa");
            flour_for_cider(s);
            r
        }
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 9;

pub static SPEC: Spec = Spec {
    id: "autumn",
    prefix: "pa",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_key",
        "shed_open",
        "net_spread",
        "got_apples",
        "got_basket",
        "in_press",
        "pressed",
        "got_bottles",
        "got_cider",
        "traded",
        "got_eggs",
        "got_dough",
        "got_pie",
        "baking",
        "baked",
        "ribbon",
        "got_veg",
        "aboard",
        "won",
        "done",
    ],
    items: &[
        "pakey",
        "panet",
        "pabasket",
        "paapples",
        "pabottles",
        "pacider",
        "paflour",
        "paeggs",
        "padough",
        "papie",
        "pabaked",
        "paveg",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "screw",
            size: 8,
            start: &[0],
            wrap: false,
            needs: "in_press",
            needs_msg: "pamsg.press_empty",
            freeze: "pressed",
        },
        Dial {
            name: "race",
            size: 12,
            start: &[0, 0],
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
            spot: "scarecrow",
            needs: "",
            locked_msg: "",
            got: "got_key",
            give: &["pakey"],
            msg: "pamsg.key",
        },
        Pick {
            spot: "henhouse",
            needs: "",
            locked_msg: "",
            got: "got_eggs",
            give: &["paeggs"],
            msg: "pamsg.eggs",
        },
        Pick {
            spot: "bottles",
            needs: "",
            locked_msg: "",
            got: "got_bottles",
            give: &["pabottles"],
            msg: "pamsg.bottles",
        },
    ],
    uses: &[
        Use {
            item: "pakey",
            spot: "shed",
            needs: "",
            fail: "",
            keep: false,
            set: "shed_open",
            give: &["panet", "pabasket"],
            msg: "pamsg.shed",
        },
        Use {
            item: "panet",
            spot: "tree",
            needs: "",
            fail: "",
            keep: false,
            set: "net_spread",
            give: &[],
            msg: "pamsg.net",
        },
        Use {
            item: "paapples",
            spot: "press",
            needs: "",
            fail: "",
            keep: true,
            set: "in_press",
            give: &[],
            msg: "pamsg.in_press",
        },
        Use {
            item: "pabottles",
            spot: "press",
            needs: "pressed",
            fail: "pamsg.no_juice",
            keep: false,
            set: "got_cider",
            give: &["pacider"],
            msg: "pamsg.cider",
        },
        Use {
            item: "pabasket",
            spot: "patch",
            needs: "",
            fail: "",
            keep: false,
            set: "got_veg",
            give: &["paveg"],
            msg: "pamsg.veg",
        },
        Use {
            item: "papie",
            spot: "oven",
            needs: "",
            fail: "",
            keep: false,
            set: "baking",
            give: &[],
            msg: "pamsg.baking",
        },
        Use {
            item: "pabaked",
            spot: "judges",
            needs: "",
            fail: "",
            keep: false,
            set: "ribbon",
            give: &[],
            msg: "pamsg.ribbon",
        },
        Use {
            item: "paveg",
            spot: "crew",
            needs: "",
            fail: "",
            keep: false,
            set: "aboard",
            give: &[],
            msg: "pamsg.aboard",
        },
    ],
    checks: &[],
    looks: &[],
    flavour: &[
        "orchard",
        "shed",
        "press",
        "screwgauge",
        "oven",
        "patch",
        "trader",
        "judges",
        "crew",
        "boats",
        "drum",
        "pip",
        "bay",
        "market",
        "almanac",
        "maggie",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("shed_open"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("net_spread"),
            available: |s| s.flag("shed_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_apples"),
            available: |s| s.flag("net_spread"),
        },
        Puzzle {
            solved: |s| s.flag("in_press"),
            available: |s| s.flag("got_apples"),
        },
        Puzzle {
            solved: |s| s.flag("pressed"),
            available: |s| s.flag("in_press"),
        },
        Puzzle {
            solved: |s| s.flag("got_bottles"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_cider"),
            available: |s| s.flag("pressed&got_bottles"),
        },
        Puzzle {
            solved: |s| s.flag("traded"),
            available: |s| s.flag("got_cider"),
        },
        Puzzle {
            solved: |s| s.flag("got_eggs"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_dough"),
            available: |s| s.flag("traded&got_eggs"),
        },
        Puzzle {
            solved: |s| s.flag("got_pie"),
            available: |s| s.flag("got_dough&got_apples"),
        },
        Puzzle {
            solved: |s| s.flag("baking"),
            available: |s| s.flag("got_pie"),
        },
        Puzzle {
            solved: |s| s.flag("baked"),
            available: |s| s.flag("baking"),
        },
        Puzzle {
            solved: |s| s.flag("ribbon"),
            available: |s| s.flag("baked"),
        },
        Puzzle {
            solved: |s| s.flag("got_veg"),
            available: |s| s.flag("shed_open"),
        },
        Puzzle {
            solved: |s| s.flag("aboard"),
            available: |s| s.flag("got_veg"),
        },
        Puzzle {
            solved: |s| s.flag("won"),
            available: |s| s.flag("aboard"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag(READY),
        },
    ],
    hint_views: &[
        ("PA1", &[0, 1, 2, 3, 9]),
        ("PA2", &[4, 5, 6, 7, 12, 13, 15]),
        ("PA3", &[8, 14, 16, 18]),
        ("PA4", &[17]),
        ("papress", &[5]),
        ("patrader", &[8, 10]),
        ("parace", &[17]),
        ("paalmanac", &[3, 5, 13, 17]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

/// The trader gives flour for cider (the last line of the conversation).
pub fn flour_for_cider(s: &mut State) {
    if s.flag("traded") && s.has("pacider") {
        s.take("pacider");
        s.give("paflour");
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::house::say_all;
    use crate::kit::msg;

    #[test]
    fn the_cup_is_won() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap scarecrow");
        msg(&mut r, "use pakey shed");
        assert_eq!(msg(&mut r, "tap tree"), "pamsg.no_net");
        msg(&mut r, "use panet tree");
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "tap tree"), "pamsg.tree_still");
        msg(&mut r, &format!("time {}", WIND.0 - 1));
        msg(&mut r, "tap tree");
        msg(&mut r, "use paapples press");
        for _ in 0..PRESS + 1 {
            msg(&mut r, "turn screw 0 +1");
        }
        assert_eq!(msg(&mut r, "tap crank"), "pamsg.too_tight");
        for _ in 0..PRESS {
            msg(&mut r, "turn screw 0 +1");
        }
        msg(&mut r, "tap crank");
        msg(&mut r, "tap bottles");
        msg(&mut r, "use pabottles press");
        say_all(&mut r, &[2, 0, 0]);
        assert!(r.has("paflour"));
        msg(&mut r, "tap henhouse");
        msg(&mut r, "use paflour paeggs");
        msg(&mut r, "use paapples padough");
        msg(&mut r, "use papie oven");
        msg(&mut r, "time 10");
        assert_eq!(msg(&mut r, "tap oven"), "pamsg.not_yet");
        msg(&mut r, &format!("time {}", GOLDEN.0 * 2 - 1));
        msg(&mut r, "tap oven");
        msg(&mut r, "use pabaked judges");
        msg(&mut r, "use pabasket patch");
        msg(&mut r, "use paveg crew");
        let mut t = 30;
        while !r.flag("won") {
            t += 1;
            msg(&mut r, &format!("time {t}"));
            if t % BEAT.0 >= BEAT.0 - BEAT.1 {
                msg(&mut r, "stroke");
            }
            assert!(t < 60);
        }
        msg(&mut r, "tap cup");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
