//! The Alchemist's Cellar (hard): six puzzles about doing things in the
//! right way and order. Views: `A1` the workbench, `A2` the vault wall.

use crate::kit::{Check, Dial, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json, strs_json};

/// The six signs: the four elements, sun and moon.
pub const SIGNS: [&str; 6] = ["fire", "water", "air", "earth", "sun", "moon"];
/// The wall chart: the colour that belongs to each element.
pub const SIGN_COLOURS: [(&str, &str); 4] = [
    ("fire", "orange"),
    ("water", "green"),
    ("air", "violet"),
    ("earth", "brown"),
];
/// The book's first page: the three vials, in order, as elements.
pub const FORMULA: [&str; 3] = ["air", "water", "fire"];
/// The primaries on the shelf (bits 1, 2, 4) and what they mix to.
pub const PRIMARIES: [&str; 3] = ["red", "yellow", "blue"];
pub fn mixed(bits: u8) -> &'static str {
    ["", "red", "yellow", "orange", "blue", "violet", "green", "brown"][usize::from(bits & 7)]
}
/// The scales: the nugget's weight and the three weights.
pub const NUGGET: u8 = 5;
pub const WEIGHTS: [u8; 3] = [1, 3, 9];
/// The floor disc's three rings must show these signs under the mark; each
/// ring carries the six signs in a different order.
pub const RINGS: [[&str; 6]; 3] = [
    ["sun", "fire", "moon", "water", "air", "earth"],
    ["earth", "moon", "air", "sun", "water", "fire"],
    ["water", "air", "earth", "fire", "moon", "sun"],
];
pub const TODAY: [&str; 3] = ["moon", "sun", "earth"];
/// The furnace: what goes in, in this order, and then the bellows as
/// often as the metal weighs.
pub const STEPS: [&str; 3] = ["crucible", "nugget", "elixir"];

fn vial_targets() -> Vec<u8> {
    FORMULA
        .iter()
        .map(|sign| {
            let colour = SIGN_COLOURS
                .iter()
                .find(|(s, _)| s == sign)
                .expect("an element")
                .1;
            (0..8u8)
                .find(|bits| mixed(*bits) == colour)
                .expect("a mixable colour")
        })
        .collect()
}

pub fn ring_targets() -> Vec<u8> {
    (0..3)
        .map(|k| {
            RINGS[k]
                .iter()
                .position(|s| *s == TODAY[k])
                .expect("a sign on the ring") as u8
        })
        .collect()
}

/// Right pan minus left pan (the nugget lies left); pans: 0 off, 1 left, 2 right.
pub fn tilt(pans: &[u8]) -> i16 {
    let side = |want: u8| {
        pans.iter()
            .zip(WEIGHTS)
            .filter(|(p, _)| **p == want)
            .map(|(_, w)| i16::from(w))
            .sum::<i16>()
    };
    side(2) - side(1) - i16::from(NUGGET)
}

fn clues() -> String {
    let pairs = SIGN_COLOURS
        .iter()
        .map(|(s, c)| format!("{{\"sign\":\"{s}\",\"colour\":\"{c}\"}}"))
        .collect::<Vec<_>>();
    let rings = RINGS
        .iter()
        .map(|r| format!("[{}]", strs_json(r)))
        .collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"signs\":[{}],\"sign_colours\":[{}],\"formula\":[{}],\"primaries\":[{}],\"weights\":[{}],\"rings\":[{}],\"today\":[{}],\"steps\":[{}]}}",
        strs_json(&SIGNS),
        pairs.join(","),
        strs_json(&FORMULA),
        strs_json(&PRIMARIES),
        nums_json(&WEIGHTS),
        rings.join(","),
        strs_json(&TODAY),
        strs_json(&STEPS)
    )
}

fn extra(s: &State) -> String {
    let colours = s.val("vials").iter().map(|b| mixed(*b)).collect::<Vec<_>>();
    format!(
        ",\"vial_colours\":[{}],\"tilt\":{},\"heat\":{},\"step\":{}",
        strs_json(&colours),
        if s.flag("got_cab") {
            tilt(s.val("pans")).signum()
        } else {
            -1
        },
        s.val("furnace")[1],
        s.val("furnace")[0]
    )
}

/// `mix <vial 0..2> <primary 0..2>`: a dash of a primary into a vial;
/// `empty <vial>`; `bellows`: one stroke; `use <crucible|nugget|elixir>
/// furnace`: the furnace's steps, which must come in order.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let num = |i: usize, max: usize| {
        words
            .get(i)
            .and_then(|w| w.parse::<usize>().ok())
            .filter(|n| *n < max)
    };
    match words[0] {
        "mix" | "empty" if s.flag("cab_open") => Some(Ok(String::new())),
        "mix" => Some(match (num(1, 3), num(2, 3)) {
            (Some(v), Some(p)) => {
                s.val_mut("vials")[v] |= 1 << p;
                Ok(String::new())
            }
            _ => Err(bad("mix")),
        }),
        "empty" => Some(match num(1, 3) {
            Some(v) => {
                s.val_mut("vials")[v] = 0;
                Ok(String::new())
            }
            None => Err(bad("empty")),
        }),
        "use"
            if words.len() == 3 && words[2] == "furnace" && STEPS.contains(&words[1]) && s.has(words[1]) =>
        {
            let step = usize::from(s.val("furnace")[0]);
            Some(Ok(if step < STEPS.len() && STEPS[step] == words[1] {
                s.take(words[1]);
                s.val_mut("furnace")[0] += 1;
                format!("amsg.step_{}", words[1])
            } else {
                "amsg.step_wrong".into()
            }))
        }
        "bellows" => Some(Ok(if s.flag("gold") {
            String::new()
        } else if !s.flag("got_bellows") {
            "amsg.bellows_torn".into()
        } else if usize::from(s.val("furnace")[0]) < STEPS.len() {
            "amsg.bellows_early".into()
        } else {
            let heat = s.val("furnace")[1] + 1;
            if heat > NUGGET {
                // Too hot: it boils over and cools; the strokes start again.
                s.val_mut("furnace")[1] = 0;
                "amsg.too_hot".into()
            } else {
                s.val_mut("furnace")[1] = heat;
                String::new()
            }
        })),
        "tap" if words.get(1) == Some(&"furnace") && !s.flag("gold") => {
            let ready = usize::from(s.val("furnace")[0]) == STEPS.len() && s.val("furnace")[1] == NUGGET;
            Some(Ok(if ready {
                s.set("gold");
                s.give("goldkey");
                "amsg.gold".into()
            } else if s.val("furnace")[1] > 0 {
                s.val_mut("furnace")[1] = 0;
                "amsg.too_cold".into()
            } else {
                "amsg.furnace".into()
            }))
        }
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 5;

pub static SPEC: Spec = Spec {
    id: "alch",
    prefix: "a",
    par_minutes: PAR_MINUTES,
    flags: &[
        "cab_open",
        "got_cab",
        "balanced",
        "got_bellows",
        "rings_ok",
        "got_crucible",
        "got_elixir",
        "gold",
        "done",
    ],
    items: &["nugget", "bellows", "crucible", "elixir", "goldkey"],
    locks: &[],
    dials: &[
        Dial {
            name: "vials",
            size: 8,
            start: &[0, 0, 0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "pans",
            size: 3,
            start: &[0, 0, 0],
            wrap: true,
            needs: "got_cab",
            needs_msg: "amsg.scales_empty",
            freeze: "balanced",
        },
        Dial {
            name: "rings",
            size: 6,
            start: &[2, 5, 1],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "rings_ok",
        },
        Dial {
            name: "furnace",
            size: 10,
            start: &[0, 0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "cabinet",
            needs: "cab_open",
            locked_msg: "amsg.cab_locked",
            got: "got_cab",
            give: &["nugget"],
            msg: "amsg.cab_take",
        },
        Pick {
            spot: "scaledrawer",
            needs: "balanced",
            locked_msg: "amsg.drawer_shut",
            got: "got_bellows",
            give: &["bellows"],
            msg: "amsg.bellows",
        },
        Pick {
            spot: "hatch",
            needs: "rings_ok",
            locked_msg: "amsg.hatch_shut",
            got: "got_crucible",
            give: &["crucible"],
            msg: "amsg.crucible",
        },
        Pick {
            spot: "vialrack",
            needs: "cab_open",
            locked_msg: "amsg.vials_unready",
            got: "got_elixir",
            give: &["elixir"],
            msg: "amsg.elixir",
        },
    ],
    uses: &[
        Use {
            item: "bellows",
            spot: "furnace|bellows",
            needs: "",
            fail: "",
            keep: true,
            set: "",
            give: &[],
            msg: "amsg.bellows_hint",
        },
        Use {
            item: "goldkey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "amsg.door_open",
        },
    ],
    checks: &[
        Check {
            flag: "cab_open",
            cond: |s| s.val("vials") == vial_targets(),
            msg: "amsg.cab_open",
        },
        Check {
            flag: "balanced",
            cond: |s| s.flag("got_cab") && tilt(s.val("pans")) == 0,
            msg: "amsg.balanced",
        },
        Check {
            flag: "rings_ok",
            cond: |s| s.val("rings") == ring_targets(),
            msg: "amsg.rings_ok",
        },
    ],
    looks: &[Look {
        spot: "door",
        flag: "",
        set: "amsg.door",
        unset: "amsg.door",
    }],
    flavour: &["skull", "candles", "jars", "owl", "chartwall", "book"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("cab_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("balanced"),
            available: |s| s.flag("got_cab"),
        },
        Puzzle {
            solved: |s| s.flag("rings_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| usize::from(s.val("furnace")[0]) == STEPS.len(),
            available: |s| s.flag("got_crucible") && s.flag("got_cab"),
        },
        Puzzle {
            solved: |s| s.flag("gold"),
            available: |s| usize::from(s.val("furnace")[0]) == STEPS.len(),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("gold"),
        },
    ],
    hint_views: &[
        ("A1", &[0, 1, 3, 4]),
        ("A2", &[2, 0, 5]),
        ("vials", &[0]),
        ("abook", &[0, 2, 3, 4]),
        ("achart", &[0]),
        ("scales", &[1]),
        ("disc", &[2]),
        ("furnace", &[3, 4]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::msg;

    #[test]
    fn the_puzzles_have_one_answer() {
        assert_eq!(vial_targets(), [5, 6, 3]);
        assert_eq!(ring_targets(), [2, 3, 2]);
        // Only one way to balance the nugget.
        let mut ways = Vec::new();
        for a in 0..3u8 {
            for b in 0..3u8 {
                for c in 0..3u8 {
                    if tilt(&[a, b, c]) == 0 {
                        ways.push([a, b, c]);
                    }
                }
            }
        }
        assert_eq!(ways, [[1, 1, 2]]);
    }

    #[test]
    fn gold_is_made() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "tap cabinet"), "amsg.cab_locked");
        // Violet, green, orange: red + blue, yellow + blue, red + yellow.
        for c in [
            "mix 0 0", "mix 0 2", "mix 1 1", "mix 1 0", "empty 1", "mix 1 1", "mix 1 2", "mix 2 0",
        ] {
            assert_eq!(msg(&mut r, c), "");
        }
        assert_eq!(msg(&mut r, "mix 2 1"), "amsg.cab_open");
        msg(&mut r, "tap cabinet");
        msg(&mut r, "tap vialrack");
        assert_eq!(msg(&mut r, "bellows"), "amsg.bellows_torn");
        for c in ["turn pans 0 +1", "turn pans 1 +1", "turn pans 2 +1"] {
            msg(&mut r, c);
        }
        assert_eq!(msg(&mut r, "turn pans 2 +1"), "amsg.balanced");
        msg(&mut r, "tap scaledrawer");
        // Rings from 2, 5, 1 to 2, 3, 2.
        msg(&mut r, "turn rings 1 -1");
        msg(&mut r, "turn rings 1 -1");
        assert_eq!(msg(&mut r, "turn rings 2 +1"), "amsg.rings_ok");
        msg(&mut r, "tap hatch");
        assert_eq!(msg(&mut r, "use nugget furnace"), "amsg.step_wrong");
        assert_eq!(msg(&mut r, "bellows"), "amsg.bellows_early");
        assert_eq!(msg(&mut r, "use crucible furnace"), "amsg.step_crucible");
        msg(&mut r, "use nugget furnace");
        msg(&mut r, "use elixir furnace");
        for _ in 0..3 {
            msg(&mut r, "bellows");
        }
        assert_eq!(msg(&mut r, "tap furnace"), "amsg.too_cold");
        for _ in 0..5 {
            assert_eq!(msg(&mut r, "bellows"), "");
        }
        assert_eq!(msg(&mut r, "tap furnace"), "amsg.gold");
        assert_eq!(msg(&mut r, "use goldkey door"), "amsg.door_open");
        assert!(r.done && r.solved().iter().all(|s| *s));
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
