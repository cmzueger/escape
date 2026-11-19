//! The Glass Aviary (medium, long): a glass bird house in sunshine; the
//! keeper has gone for seed. Twenty-four puzzles, most of them small: every
//! bird fed and settled before the doors open. Views: `AV1` (the entrance:
//! keeper's desk, nest box, bell, the shade crank, the perch stand), `AV2`
//! (the tropical corner: apple tree, parrot, nectar feeder, orchid with
//! misting valves, peacock), `AV3` (the pond: fish, kingfisher, tap, the
//! owl's dark corner, the canary's cage), `AV4` (the seed store).

use crate::bad;
use crate::house::{lines_json, piano, played, talk, Line};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{combine, moment, Recipe};

/// The pond's fish jumps for the last 3 seconds of every 9.
pub const FISH_CYCLE: u32 = 9;
pub const FISH_SHOW: u32 = 3;
/// Seed jars on the shelf (star, moon, sun): the canary's is the sun's.
pub const JARS: u8 = 3;
pub const SUN_JAR: u8 = 2;
/// Misting valves (three, 0 to 2 each): the gauge wants 5 in all.
pub const MIST: u8 = 5;
/// The dome's shade over the owl's corner (0 open to 3 closed).
pub const DARK: u8 = 3;
/// The canary's song on the whistle's four holes.
pub const SONG: [u8; 5] = [2, 0, 3, 1, 2];
/// Perch heights (0 to 3) for the six birds, from the keeper's plan (perches
/// 1 to 3 on the desk, 4 to 6 on the orchid's label).
pub const PERCHES: [u8; 6] = [3, 1, 2, 0, 2, 3];

const RECIPES: &[Recipe] = &[
    ("avknife", "avapple", "avslices", "got_slices", "avmsg.slices"),
    ("avsugar", "avwater", "avnectar", "got_nectar", "avmsg.nectar"),
];

pub static LINES: [Line; 2] = [
    Line {
        text: "avtalk.1",
        choices: &[("avsay.1a", 0), ("avsay.1b", 2), ("avsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "avtalk.2",
        choices: &[("avsay.2a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"song\":[{}],\"perches\":[{}],\"cycle\":{FISH_CYCLE},\"show\":{FISH_SHOW},\"mist\":{MIST},\"lines\":[{}]}}",
        nums_json(&SONG),
        nums_json(&PERCHES),
        lines_json(&LINES)
    )
}

const BIRDS: [&str; 5] = [
    "fed_king",
    "fed_parrot",
    "fed_canary",
    "fed_humming",
    "fed_peacock",
];

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let Some(r) = combine(s, words, RECIPES) {
        return Some(r);
    }
    match words {
        ["use", "avnet", "pond"] if s.has("avnet") => Some(Ok(if moment(s, FISH_CYCLE, FISH_SHOW) {
            s.take("avnet");
            s.give("avfish");
            s.set("got_fish");
            "avmsg.fish"
        } else {
            "avmsg.pond_still"
        }
        .into())),
        ["jar", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < JARS) {
            None => Err(bad("jar")),
            Some(_) if !s.flag("store_open") => Ok("avmsg.store_shut".into()),
            Some(_) if s.flag("got_seed") => Ok("avmsg.nothing".into()),
            Some(_) if !s.flag("told") => Ok("avmsg.jars_worn".into()),
            Some(SUN_JAR) => {
                s.set("got_seed");
                s.give("avseed");
                Ok("avmsg.seed".into())
            }
            Some(_) => Ok("avmsg.wrong_jar".into()),
        }),
        ["key", i] if !s.has("avwhistle") => Some(if i.parse::<u8>().is_ok_and(|k| k < 4) {
            Ok("avmsg.no_whistle".into())
        } else {
            Err(bad("key"))
        }),
        ["key", i] if i.parse::<u8>().is_ok_and(|k| k >= 4) => Some(Err(bad("key"))),
        ["tap", "bell"] => Some(Ok(
            if BIRDS.iter().all(|b| s.flag(b)) && s.flag("song_ok&perched") {
                s.set("done");
                "avmsg.doors".into()
            } else {
                "avmsg.bell_wait".into()
            },
        )),
        _ => piano(s, words).or_else(|| talk(s, words, &LINES, "fed_parrot", "av")),
    }
}

/// Minutes for three stars (from tools/knowledge.py, 2026-11-19).
pub const PAR_MINUTES: u32 = 14;

pub static SPEC: Spec = Spec {
    id: "aviary",
    prefix: "av",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_keys",
        "store_open",
        "got_net",
        "got_fish",
        "fed_king",
        "got_apple",
        "got_knife",
        "got_slices",
        "fed_parrot",
        "told",
        "got_seed",
        "fed_canary",
        "got_can",
        "got_water",
        "got_sugar",
        "got_nectar",
        "fed_humming",
        "bloom",
        "owl_awake",
        "got_whistle",
        "got_scoop",
        "got_grain",
        "fed_peacock",
        "song_ok",
        "perched",
        "done",
    ],
    items: &[
        "avkeys",
        "avnet",
        "avfish",
        "avapple",
        "avknife",
        "avslices",
        "avseed",
        "avcan",
        "avwater",
        "avsugar",
        "avnectar",
        "avscoop",
        "avgrain",
        "avwhistle",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "mist",
            size: 3,
            start: &[0, 0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "bloom",
        },
        Dial {
            name: "shade",
            size: 4,
            start: &[0],
            wrap: false,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "perches",
            size: 4,
            start: &[0, 0, 0, 0, 0, 0],
            wrap: true,
            needs: "bloom",
            needs_msg: "avmsg.plan_half",
            freeze: "perched",
        },
        Dial {
            name: "played",
            size: 9,
            start: &[0, 0, 0, 0, 0],
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
            spot: "nestbox",
            needs: "",
            locked_msg: "",
            got: "got_keys",
            give: &["avkeys"],
            msg: "avmsg.keys",
        },
        Pick {
            spot: "net",
            needs: "store_open",
            locked_msg: "avmsg.store_shut",
            got: "got_net",
            give: &["avnet"],
            msg: "avmsg.net",
        },
        Pick {
            spot: "tree",
            needs: "",
            locked_msg: "",
            got: "got_apple",
            give: &["avapple"],
            msg: "avmsg.apple",
        },
        Pick {
            spot: "knife",
            needs: "store_open",
            locked_msg: "avmsg.store_shut",
            got: "got_knife",
            give: &["avknife"],
            msg: "avmsg.knife",
        },
        Pick {
            spot: "can",
            needs: "",
            locked_msg: "",
            got: "got_can",
            give: &["avcan"],
            msg: "avmsg.can",
        },
        Pick {
            spot: "sugar",
            needs: "store_open",
            locked_msg: "avmsg.store_shut",
            got: "got_sugar",
            give: &["avsugar"],
            msg: "avmsg.sugar",
        },
        Pick {
            spot: "scoop",
            needs: "store_open",
            locked_msg: "avmsg.store_shut",
            got: "got_scoop",
            give: &["avscoop"],
            msg: "avmsg.scoop",
        },
        Pick {
            spot: "owlperch",
            needs: "owl_awake",
            locked_msg: "avmsg.owl_asleep",
            got: "got_whistle",
            give: &["avwhistle"],
            msg: "avmsg.whistle",
        },
    ],
    uses: &[
        Use {
            item: "avkeys",
            spot: "storedoor",
            needs: "",
            fail: "",
            keep: false,
            set: "store_open",
            give: &[],
            msg: "avmsg.store_open",
        },
        Use {
            item: "avfish",
            spot: "kingfisher",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_king",
            give: &[],
            msg: "avmsg.fed_king",
        },
        Use {
            item: "avslices",
            spot: "parrot",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_parrot",
            give: &[],
            msg: "avmsg.fed_parrot",
        },
        Use {
            item: "avseed",
            spot: "canary",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_canary",
            give: &[],
            msg: "avmsg.fed_canary",
        },
        Use {
            item: "avcan",
            spot: "tap",
            needs: "",
            fail: "",
            keep: false,
            set: "got_water",
            give: &["avwater"],
            msg: "avmsg.water",
        },
        Use {
            item: "avnectar",
            spot: "feeder",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_humming",
            give: &[],
            msg: "avmsg.fed_humming",
        },
        Use {
            item: "avscoop",
            spot: "sack",
            needs: "",
            fail: "",
            keep: false,
            set: "got_grain",
            give: &["avgrain"],
            msg: "avmsg.grain",
        },
        Use {
            item: "avgrain",
            spot: "peacock",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_peacock",
            give: &[],
            msg: "avmsg.fed_peacock",
        },
    ],
    checks: &[
        Check {
            flag: "bloom",
            cond: |s| s.val("mist").iter().sum::<u8>() == MIST,
            msg: "avmsg.bloom",
        },
        Check {
            flag: "owl_awake",
            cond: |s| s.val("shade")[0] == DARK,
            msg: "avmsg.owl_awake",
        },
        Check {
            flag: "song_ok",
            cond: |s| s.flag("fed_canary&got_whistle") && played(s, &SONG),
            msg: "avmsg.song_ok",
        },
        Check {
            flag: "perched",
            cond: |s| s.flag("bloom") && s.val("perches") == PERCHES,
            msg: "avmsg.perched",
        },
    ],
    looks: &[],
    flavour: &[
        "desk",
        "pond",
        "kingfisher",
        "parrot",
        "canary",
        "feeder",
        "orchid",
        "peacock",
        "owl",
        "storedoor",
        "sack",
        "stand",
        "dome",
        "tap",
        "jars",
        "crank",
        "plan",
        "cage",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_keys"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("store_open"),
            available: |s| s.flag("got_keys"),
        },
        Puzzle {
            solved: |s| s.flag("got_net"),
            available: |s| s.flag("store_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_fish"),
            available: |s| s.flag("got_net"),
        },
        Puzzle {
            solved: |s| s.flag("fed_king"),
            available: |s| s.flag("got_fish"),
        },
        Puzzle {
            solved: |s| s.flag("got_apple"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_knife"),
            available: |s| s.flag("store_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_slices"),
            available: |s| s.flag("got_apple&got_knife"),
        },
        Puzzle {
            solved: |s| s.flag("fed_parrot"),
            available: |s| s.flag("got_slices"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("fed_parrot"),
        },
        Puzzle {
            solved: |s| s.flag("got_seed"),
            available: |s| s.flag("told&store_open"),
        },
        Puzzle {
            solved: |s| s.flag("fed_canary"),
            available: |s| s.flag("got_seed"),
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
            solved: |s| s.flag("got_nectar"),
            available: |s| s.flag("got_water&got_sugar"),
        },
        Puzzle {
            solved: |s| s.flag("fed_humming"),
            available: |s| s.flag("got_nectar"),
        },
        Puzzle {
            solved: |s| s.flag("bloom"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("owl_awake"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_whistle"),
            available: |s| s.flag("owl_awake"),
        },
        Puzzle {
            solved: |s| s.flag("got_grain"),
            available: |s| s.flag("got_scoop"),
        },
        Puzzle {
            solved: |s| s.flag("fed_peacock"),
            available: |s| s.flag("got_grain"),
        },
        Puzzle {
            solved: |s| s.flag("song_ok"),
            available: |s| s.flag("fed_canary&got_whistle"),
        },
        Puzzle {
            solved: |s| s.flag("perched"),
            available: |s| s.flag("bloom"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| BIRDS.iter().all(|b| s.flag(b)) && s.flag("song_ok&perched"),
        },
    ],
    hint_views: &[
        ("AV1", &[0, 17, 22, 23]),
        ("AV2", &[5, 7, 8, 9, 15, 16, 20]),
        ("AV3", &[3, 4, 12, 13, 18, 11, 21]),
        ("AV4", &[1, 2, 6, 10, 14, 19]),
        ("avdesk", &[9, 22]),
        ("avperches", &[22]),
        ("avshade", &[17]),
        ("avparrot", &[8, 9]),
        ("avorchid", &[16, 22]),
        ("avcage", &[11, 21]),
        ("avjars", &[10]),
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
    fn every_bird_settles() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap nestbox");
        msg(&mut r, "use avkeys storedoor");
        for spot in ["net", "knife", "sugar", "scoop", "tree", "can"] {
            msg(&mut r, &format!("tap {spot}"));
        }
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "use avnet pond"), "avmsg.pond_still");
        msg(&mut r, &format!("time {}", FISH_CYCLE - 1));
        msg(&mut r, "use avnet pond");
        msg(&mut r, "use avfish kingfisher");
        msg(&mut r, "use avapple avknife");
        msg(&mut r, "use avslices parrot");
        assert_eq!(msg(&mut r, "jar 2"), "avmsg.jars_worn");
        say_all(&mut r, &[1, 0]);
        assert_eq!(msg(&mut r, "jar 0"), "avmsg.wrong_jar");
        msg(&mut r, &format!("jar {SUN_JAR}"));
        msg(&mut r, "use avseed canary");
        msg(&mut r, "use avcan tap");
        msg(&mut r, "use avwater avsugar");
        msg(&mut r, "use avnectar feeder");
        turn_to(&mut r, "mist", &[2, 2, 1], 3);
        assert!(r.flag("bloom"));
        for _ in 0..DARK {
            msg(&mut r, "turn shade 0 +1");
        }
        msg(&mut r, "tap owlperch");
        msg(&mut r, "use avscoop sack");
        msg(&mut r, "use avgrain peacock");
        for k in SONG {
            msg(&mut r, &format!("key {k}"));
        }
        assert!(r.flag("song_ok"));
        assert_eq!(msg(&mut r, "tap bell"), "avmsg.bell_wait");
        turn_to(&mut r, "perches", &PERCHES, 4);
        msg(&mut r, "tap bell");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
