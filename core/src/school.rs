//! Detention (medium, long): a village school in 1925, kept in after
//! lessons. The teacher left a list of tasks; the door opens when all are
//! done. Twenty-four puzzles, most of them small. Views: `SC1` (the
//! blackboard: board, abacus, clock, wall map, numeral chart), `SC2` (the
//! pupils' desks: inkwells, name cards, bookshelf, coat pegs), `SC3` (the
//! teacher's desk and stove: task list, register, drawer, harmonium, globe,
//! bell rope), `SC4` (the back: cupboard, window with the pump and the
//! church tower, plant, rabbit hutch, lost property).

use crate::bad;
use crate::house::{lines_json, piano, played, talk, tune_json, Line};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::sequence;

/// The three sums on the board, answered on the abacus.
pub const SUMS: [u8; 3] = [7, 6, 8];
/// Name cards on the five desks (card shown on each), from the register's
/// seating plan.
pub const SEATS: [u8; 5] = [3, 0, 4, 2, 1];
/// The church clock through the window: hour (0 = twelve) and minutes / 5.
pub const CLOCK: [u8; 2] = [3, 9];
/// The globe turned to the pen-friend's country (0 to 7).
pub const GLOBE: u8 = 5;
/// The numeral on each of the five books (1 to 5); the shelf wants them in
/// order, slot by slot (which book stands in it).
pub const NUMERALS: [u8; 5] = [3, 5, 1, 4, 2];
pub const BOOKS: [u8; 5] = [2, 4, 0, 3, 1];
/// The class trip's three stops on the wall map (towns 0 to 5).
pub const ROUTE: [u8; 3] = [4, 1, 5];
/// The stove's damper wide open.
pub const DAMPER: u8 = 2;
/// The school song on the harmonium (keys 0 to 7).
pub const SONG: [u8; 7] = [0, 2, 4, 5, 4, 2, 0];
/// The Sunday peal on the bell rope: 0 short, 1 long.
pub const PEAL: [u8; 5] = [1, 0, 0, 1, 1];
/// The class photo's tiles at the start (0 the gap); solved 1 to 8, gap last.
pub const TILES: [u8; 9] = [1, 8, 3, 4, 5, 2, 7, 6, 0];
pub const TILES_DONE: [u8; 9] = [1, 2, 3, 4, 5, 6, 7, 8, 0];
/// Which peg (0 to 4) each lost thing belongs on: scarf, cap, mitten.
pub const PEGS: [u8; 3] = [3, 0, 4];
const LOST: [(&str, &str); 3] = [
    ("scscarf", "hung_scarf"),
    ("sccap", "hung_cap"),
    ("scmitten", "hung_mitten"),
];

pub static LINES: [Line; 3] = [
    Line {
        text: "sctalk.1",
        choices: &[("scsay.1a", 0), ("scsay.1b", 2), ("scsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "sctalk.2",
        choices: &[("scsay.2a", 0), ("scsay.2b", 0), ("scsay.2c", 3)],
        sets: "",
    },
    Line {
        text: "sctalk.3",
        choices: &[("scsay.3a", 0)],
        sets: "told",
    },
];

/// Every task on the teacher's list, in the list's order.
pub const TASKS: [&str; 15] = [
    "board_clean",
    "abacus_ok",
    "inked",
    "seats_ok",
    "clock_ok",
    "globe_ok",
    "watered",
    "books_ok",
    "fed_rabbit",
    "route_ok",
    "lit",
    "song_ok",
    "bell_ok",
    "hung_scarf&hung_cap&hung_mitten",
    "sharpened",
];

fn clues() -> String {
    let tasks = TASKS
        .iter()
        .map(|t| format!("\"{t}\""))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"sums\":[{}],\"seats\":[{}],\"clock\":[{}],\"globe\":{GLOBE},\"numerals\":[{}],\"route\":[{}],\"song\":{},\"peal\":[{}],\"pegs\":[{}],\"tasks\":[{tasks}],\"lines\":[{}]}}",
        nums_json(&SUMS),
        nums_json(&SEATS),
        nums_json(&CLOCK),
        nums_json(&NUMERALS),
        nums_json(&ROUTE),
        tune_json(&SONG),
        nums_json(&PEAL),
        nums_json(&PEGS),
        lines_json(&LINES)
    )
}

fn all_tasks(s: &State) -> bool {
    TASKS.iter().all(|t| s.flag(t))
}

fn slide(s: &mut State, i: usize) -> Reply {
    if !s.flag("told") {
        return Ok("scmsg.photo_fixed".into());
    }
    if s.flag("photo_ok") {
        return Ok(String::new());
    }
    let t = s.val_mut("tiles");
    let gap = t.iter().position(|x| *x == 0).unwrap_or(8);
    let (r, c, gr, gc) = (i / 3, i % 3, gap / 3, gap % 3);
    if r.abs_diff(gr) + c.abs_diff(gc) == 1 {
        t.swap(i, gap);
    }
    Ok(String::new())
}

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["use", "scdoorkey", "door"] if s.has("scdoorkey") => Some(Ok(if all_tasks(s) {
            s.set("done");
            "scmsg.door_open"
        } else {
            "scmsg.door_tasks"
        }
        .into())),
        ["use", a, b]
            if s.has("scfull")
                && s.has("scsponge")
                && [*a, *b].contains(&"scfull")
                && [*a, *b].contains(&"scsponge") =>
        {
            s.take("scsponge");
            s.give("scwet");
            s.set("wet");
            Some(Ok("scmsg.wet".into()))
        }
        ["use", a, b]
            if [*a, *b] == ["scpencils", "scsharpener"] || [*a, *b] == ["scsharpener", "scpencils"] =>
        {
            if !s.has("scpencils") || !s.has("scsharpener") {
                return None;
            }
            s.take("scpencils");
            s.take("scsharpener");
            s.set("sharpened");
            Some(Ok("scmsg.sharpened".into()))
        }
        ["use", "scmatches", "stove"] if s.has("scmatches") => Some(Ok(if s.val("damper")[0] == DAMPER {
            s.take("scmatches");
            s.set("lit");
            "scmsg.lit"
        } else {
            "scmsg.smoke"
        }
        .into())),
        ["use", item, peg] if peg.starts_with("peg") && s.has(item) => {
            let (k, (_, flag)) = LOST.iter().enumerate().find(|(_, (name, _))| name == item)?;
            let p = peg[3..].parse::<u8>().ok().filter(|p| *p < 5)?;
            Some(Ok(if p == PEGS[k] {
                s.take(item);
                s.set(flag);
                "scmsg.hung"
            } else {
                "scmsg.wrong_peg"
            }
            .into()))
        }
        ["tap", peg] if peg.starts_with("peg") => Some(Ok("scmsg.peg".into())),
        ["slide", i] => Some(match i.parse::<usize>().ok().filter(|i| *i < 9) {
            None => Err(bad("slide")),
            Some(i) => slide(s, i),
        }),
        ["ring", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 2) {
            None => Err(bad("ring")),
            Some(_) if s.flag("bell_ok") => Ok(String::new()),
            Some(pull) => match sequence(s, "rung", &PEAL, pull) {
                (true, _) => {
                    s.set("bell_ok");
                    Ok("scmsg.peal".into())
                }
                _ => Ok(String::new()),
            },
        }),
        _ => piano(s, words).or_else(|| talk(s, words, &LINES, "lit", "sc")),
    }
}

/// Minutes for three stars (from tools/knowledge.py, 2026-11-19).
pub const PAR_MINUTES: u32 = 20;

pub static SPEC: Spec = Spec {
    id: "school",
    prefix: "sc",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_key",
        "cupboard_open",
        "got_cupboard",
        "got_can",
        "got_water",
        "wet",
        "board_clean",
        "abacus_ok",
        "got_drawer",
        "inked",
        "seats_ok",
        "wound",
        "clock_ok",
        "globe_ok",
        "watered",
        "books_ok",
        "fed_rabbit",
        "got_pin",
        "pinned",
        "route_ok",
        "lit",
        "song_ok",
        "bell_ok",
        "told",
        "photo_ok",
        "got_doorkey",
        "got_lost",
        "hung_scarf",
        "hung_cap",
        "hung_mitten",
        "sharpened",
        "done",
    ],
    items: &[
        "sckey",
        "scsponge",
        "scink",
        "sccarrot",
        "scpencils",
        "sccan",
        "scfull",
        "scwet",
        "scclockkey",
        "scmatches",
        "scsharpener",
        "scpin",
        "scscarf",
        "sccap",
        "scmitten",
        "scdoorkey",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "abacus",
            size: 10,
            start: &[0, 0, 0],
            wrap: true,
            needs: "board_clean",
            needs_msg: "scmsg.no_sums",
            freeze: "abacus_ok",
        },
        Dial {
            name: "seats",
            size: 5,
            start: &[0, 1, 2, 3, 4],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "seats_ok",
        },
        Dial {
            name: "clock",
            size: 12,
            start: &[7, 2],
            wrap: true,
            needs: "wound",
            needs_msg: "scmsg.clock_stopped",
            freeze: "clock_ok",
        },
        Dial {
            name: "globe",
            size: 8,
            start: &[0],
            wrap: true,
            needs: "seats_ok",
            needs_msg: "scmsg.globe_why",
            freeze: "globe_ok",
        },
        Dial {
            name: "books",
            size: 5,
            start: &[0, 1, 2, 3, 4],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "books_ok",
        },
        Dial {
            name: "route",
            size: 6,
            start: &[0, 0, 0],
            wrap: true,
            needs: "pinned",
            needs_msg: "scmsg.pin_missing",
            freeze: "route_ok",
        },
        Dial {
            name: "damper",
            size: 3,
            start: &[0],
            wrap: false,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "tiles",
            size: 9,
            start: &TILES,
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "rung",
            size: 6,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "played",
            size: 9,
            start: &[0; 7],
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
            spot: "pot",
            needs: "",
            locked_msg: "",
            got: "got_key",
            give: &["sckey"],
            msg: "scmsg.key",
        },
        Pick {
            spot: "shelves",
            needs: "cupboard_open",
            locked_msg: "scmsg.cupboard_locked",
            got: "got_cupboard",
            give: &["scsponge", "scink", "sccarrot", "scpencils"],
            msg: "scmsg.cupboard_things",
        },
        Pick {
            spot: "can",
            needs: "",
            locked_msg: "",
            got: "got_can",
            give: &["sccan"],
            msg: "scmsg.can",
        },
        Pick {
            spot: "drawer",
            needs: "abacus_ok",
            locked_msg: "scmsg.drawer_locked",
            got: "got_drawer",
            give: &["scclockkey", "scmatches", "scsharpener"],
            msg: "scmsg.drawer",
        },
        Pick {
            spot: "straw",
            needs: "fed_rabbit",
            locked_msg: "scmsg.rabbit_sits",
            got: "got_pin",
            give: &["scpin"],
            msg: "scmsg.pin",
        },
        Pick {
            spot: "frame",
            needs: "photo_ok",
            locked_msg: "scmsg.frame_tight",
            got: "got_doorkey",
            give: &["scdoorkey"],
            msg: "scmsg.doorkey",
        },
        Pick {
            spot: "lostbox",
            needs: "",
            locked_msg: "",
            got: "got_lost",
            give: &["scscarf", "sccap", "scmitten"],
            msg: "scmsg.lost",
        },
    ],
    uses: &[
        Use {
            item: "sckey",
            spot: "cupboard",
            needs: "",
            fail: "",
            keep: false,
            set: "cupboard_open",
            give: &[],
            msg: "scmsg.cupboard",
        },
        Use {
            item: "sccan",
            spot: "pump",
            needs: "",
            fail: "",
            keep: false,
            set: "got_water",
            give: &["scfull"],
            msg: "scmsg.water",
        },
        Use {
            item: "scwet",
            spot: "board",
            needs: "",
            fail: "",
            keep: false,
            set: "board_clean",
            give: &[],
            msg: "scmsg.board_clean",
        },
        Use {
            item: "scink",
            spot: "inkwells",
            needs: "",
            fail: "",
            keep: false,
            set: "inked",
            give: &[],
            msg: "scmsg.inked",
        },
        Use {
            item: "scclockkey",
            spot: "clock",
            needs: "",
            fail: "",
            keep: false,
            set: "wound",
            give: &[],
            msg: "scmsg.wound",
        },
        Use {
            item: "scfull",
            spot: "plant",
            needs: "wet",
            fail: "scmsg.save_water",
            keep: false,
            set: "watered",
            give: &[],
            msg: "scmsg.watered",
        },
        Use {
            item: "sccarrot",
            spot: "hutch",
            needs: "",
            fail: "",
            keep: false,
            set: "fed_rabbit",
            give: &[],
            msg: "scmsg.fed_rabbit",
        },
        Use {
            item: "scpin",
            spot: "map",
            needs: "",
            fail: "",
            keep: false,
            set: "pinned",
            give: &[],
            msg: "scmsg.pin_route",
        },
    ],
    checks: &[
        Check {
            flag: "abacus_ok",
            cond: |s| s.flag("board_clean") && s.val("abacus") == SUMS,
            msg: "scmsg.abacus_ok",
        },
        Check {
            flag: "seats_ok",
            cond: |s| s.val("seats") == SEATS,
            msg: "scmsg.seats_ok",
        },
        Check {
            flag: "clock_ok",
            cond: |s| s.flag("wound") && s.val("clock") == CLOCK,
            msg: "scmsg.clock_ok",
        },
        Check {
            flag: "globe_ok",
            cond: |s| s.flag("seats_ok") && s.val("globe")[0] == GLOBE,
            msg: "scmsg.globe_ok",
        },
        Check {
            flag: "books_ok",
            cond: |s| s.val("books") == BOOKS,
            msg: "scmsg.books_ok",
        },
        Check {
            flag: "route_ok",
            cond: |s| s.flag("pinned") && s.val("route") == ROUTE,
            msg: "scmsg.route_ok",
        },
        Check {
            flag: "song_ok",
            cond: |s| played(s, &SONG),
            msg: "scmsg.song_ok",
        },
        Check {
            flag: "photo_ok",
            cond: |s| s.flag("told") && s.val("tiles") == TILES_DONE,
            msg: "scmsg.photo_ok",
        },
    ],
    looks: &[],
    flavour: &[
        "abacus",
        "chart",
        "register",
        "tasks",
        "harmonium",
        "globe",
        "bellrope",
        "window",
        "church",
        "hutch",
        "books",
        "cards",
        "desks",
        "photo",
        "door",
        "cupboard",
        "pump",
        "plant",
        "map",
        "stove",
        "damper",
        "board",
        "clock",
        "inkwells",
        "pegs",
        "letter",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("cupboard_open"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("got_cupboard"),
            available: |s| s.flag("cupboard_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_water"),
            available: |s| s.flag("got_can"),
        },
        Puzzle {
            solved: |s| s.flag("wet"),
            available: |s| s.flag("got_cupboard&got_water"),
        },
        Puzzle {
            solved: |s| s.flag("board_clean"),
            available: |s| s.flag("wet"),
        },
        Puzzle {
            solved: |s| s.flag("abacus_ok"),
            available: |s| s.flag("board_clean"),
        },
        Puzzle {
            solved: |s| s.flag("inked"),
            available: |s| s.flag("got_cupboard"),
        },
        Puzzle {
            solved: |s| s.flag("seats_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("clock_ok"),
            available: |s| s.flag("wound"),
        },
        Puzzle {
            solved: |s| s.flag("globe_ok"),
            available: |s| s.flag("seats_ok"),
        },
        Puzzle {
            solved: |s| s.flag("watered"),
            available: |s| s.flag("got_water&wet"),
        },
        Puzzle {
            solved: |s| s.flag("books_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("fed_rabbit"),
            available: |s| s.flag("got_cupboard"),
        },
        Puzzle {
            solved: |s| s.flag("got_pin"),
            available: |s| s.flag("fed_rabbit"),
        },
        Puzzle {
            solved: |s| s.flag("route_ok"),
            available: |s| s.flag("got_pin"),
        },
        Puzzle {
            solved: |s| s.flag("lit"),
            available: |s| s.flag("got_drawer"),
        },
        Puzzle {
            solved: |s| s.flag("song_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("bell_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("lit"),
        },
        Puzzle {
            solved: |s| s.flag("photo_ok"),
            available: |s| s.flag("told"),
        },
        Puzzle {
            solved: |s| s.flag("hung_scarf&hung_cap&hung_mitten"),
            available: |s| s.flag("got_lost"),
        },
        Puzzle {
            solved: |s| s.flag("sharpened"),
            available: |s| s.flag("got_cupboard&got_drawer"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_doorkey") && all_tasks(s),
        },
    ],
    hint_views: &[
        ("SC1", &[5, 6, 9, 15]),
        ("SC2", &[7, 8, 12, 21, 23]),
        ("SC3", &[6, 10, 16, 17, 18, 20, 22]),
        ("SC4", &[0, 1, 2, 3, 4, 11, 13, 14, 16, 19]),
        ("scboard", &[5, 6]),
        ("scabacus", &[6]),
        ("scclock", &[9]),
        ("scmap", &[15]),
        ("scdesks", &[7, 8, 10]),
        ("scletter", &[10]),
        ("scshelf", &[12]),
        ("scpegs", &[21]),
        ("sctasks", &[23]),
        ("scregister", &[8, 15, 19]),
        ("scharmonium", &[17]),
        ("scglobe", &[10]),
        ("scbell", &[18]),
        ("scphoto", &[20, 23]),
        ("scstove", &[16]),
        ("scwindow", &[3, 9, 19]),
        ("schutch", &[13, 14]),
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

    /// The tiles to slide, by number, to put the photo right.
    const SLIDES: [u8; 14] = [2, 5, 8, 3, 5, 2, 6, 8, 2, 5, 3, 2, 5, 6];

    #[test]
    fn every_task_is_done() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap pot");
        msg(&mut r, "use sckey cupboard");
        msg(&mut r, "tap shelves");
        msg(&mut r, "tap can");
        msg(&mut r, "use sccan pump");
        assert_eq!(msg(&mut r, "use scfull plant"), "scmsg.save_water");
        msg(&mut r, "use scsponge scfull");
        msg(&mut r, "use scwet board");
        turn_to(&mut r, "abacus", &SUMS, 10);
        assert!(r.flag("abacus_ok"));
        msg(&mut r, "tap drawer");
        msg(&mut r, "use scink inkwells");
        turn_to(&mut r, "seats", &SEATS, 5);
        msg(&mut r, "use scclockkey clock");
        turn_to(&mut r, "clock", &CLOCK, 12);
        turn_to(&mut r, "globe", &[GLOBE], 8);
        msg(&mut r, "use scfull plant");
        turn_to(&mut r, "books", &BOOKS, 5);
        msg(&mut r, "use sccarrot hutch");
        msg(&mut r, "tap straw");
        msg(&mut r, "use scpin map");
        turn_to(&mut r, "route", &ROUTE, 6);
        assert_eq!(msg(&mut r, "use scmatches stove"), "scmsg.smoke");
        msg(&mut r, "turn damper 0 +1");
        msg(&mut r, "turn damper 0 +1");
        msg(&mut r, "use scmatches stove");
        for k in SONG {
            msg(&mut r, &format!("key {k}"));
        }
        msg(&mut r, "ring 0");
        for p in PEAL {
            msg(&mut r, &format!("ring {p}"));
        }
        say_all(&mut r, &[1, 2, 0]);
        for t in SLIDES {
            let at = r.val("tiles").iter().position(|x| *x == t).unwrap();
            msg(&mut r, &format!("slide {at}"));
        }
        assert!(r.flag("photo_ok"));
        msg(&mut r, "tap frame");
        msg(&mut r, "tap lostbox");
        assert_eq!(msg(&mut r, "use scscarf peg0"), "scmsg.wrong_peg");
        for ((item, _), peg) in LOST.iter().zip(PEGS) {
            msg(&mut r, &format!("use {item} peg{peg}"));
        }
        assert_eq!(msg(&mut r, "use scdoorkey door"), "scmsg.door_tasks");
        msg(&mut r, "use scpencils scsharpener");
        msg(&mut r, "use scdoorkey door");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
