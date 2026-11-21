//! Hall of Mirrors (medium, long): a funfair at night, closed with the
//! lights still on. Twenty-four puzzles: through the mirror maze, wake the
//! carousel and call the attendant. Views: `HM1` (the entrance: ticket
//! booth with the maze plan, turnstile, Zelda the fortune machine, the
//! balloon stall's poster), `HM2` (the mirror maze, one cell at a time),
//! `HM3` (the funhouse: crooked mirrors, the strength tester, the prize
//! cabinet, the balloon stall, the candy-floss cart, the curtain), `HM4`
//! (the carousel: horses, organ, brake lever, fuse box, spotlights,
//! generator, the clown).

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::kit::{no_extra, Check, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{moment, sequence};

/// The maze, 5 by 5 cells (row by row), each the open sides: north 1, east
/// 2, south 4, west 8. In at the bottom middle, out at the centre.
pub const MAZE: [u8; 25] = [
    6, 10, 8, 6, 12, 5, 6, 12, 5, 5, 5, 5, 3, 9, 5, 5, 7, 8, 6, 13, 3, 9, 2, 9, 1,
];
pub const MAZE_START: u8 = 22;
pub const MAZE_CENTRE: u8 = 12;
/// The strength tester's lamp blinks for the last 2 seconds of every 7.
pub const TESTER_CYCLE: u32 = 7;
pub const TESTER_SHOW: u32 = 2;
/// Horse heights (0 to 3) from the stars' sizes in the crooked picture.
pub const HORSES: [u8; 4] = [2, 0, 3, 1];
/// The generator's chalk mark, seen from above (0 to 5).
pub const GENERATOR: u8 = 4;
/// Fuses: motor, lights, music, popcorn, fan; at most three at once.
pub const FUSES: [u8; 5] = [1, 1, 1, 0, 0];
pub const FUSE_LIMIT: u8 = 3;
/// The two spotlight mirrors' angles (0 to 7) that put the beam on the sensor.
pub const SPOTS: [u8; 2] = [5, 2];
/// Balloon colours popped in the poster's order.
pub const BALLOONS: [u8; 5] = [3, 0, 4, 1, 2];
/// The organ card with the saddle's sign (0 to 3); the sign shows on the
/// golden horse for the last 2 seconds of every 6 while it turns.
pub const CARD: u8 = 1;
pub const SADDLE_CYCLE: u32 = 6;
pub const SADDLE_SHOW: u32 = 2;

pub static LINES: [Line; 3] = [
    Line {
        text: "hmtalk.1",
        choices: &[("hmsay.1a", 0), ("hmsay.1b", 2), ("hmsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "hmtalk.2",
        choices: &[("hmsay.2a", 0), ("hmsay.2b", 0), ("hmsay.2c", 3)],
        sets: "",
    },
    Line {
        text: "hmtalk.3",
        choices: &[("hmsay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"maze\":[{}],\"start\":{MAZE_START},\"centre\":{MAZE_CENTRE},\"horses\":[{}],\"generator\":{GENERATOR},\"spots\":[{}],\"balloons\":[{}],\"card\":{CARD},\"tester\":[{TESTER_CYCLE},{TESTER_SHOW}],\"saddle\":[{SADDLE_CYCLE},{SADDLE_SHOW}],\"lines\":[{}]}}",
        nums_json(&MAZE),
        nums_json(&HORSES),
        nums_json(&SPOTS),
        nums_json(&BALLOONS),
        lines_json(&LINES)
    )
}

fn step_maze(s: &mut State, dir: &str) -> Reply {
    let (bit, dr, dc): (u8, i8, i8) = match dir {
        "n" => (1, -1, 0),
        "e" => (2, 0, 1),
        "s" => (4, 1, 0),
        "w" => (8, 0, -1),
        _ => return Err(bad("step")),
    };
    if !s.flag("in_maze") {
        return Ok("hmmsg.turnstile_shut".into());
    }
    let at = s.val("pos")[0];
    if MAZE[usize::from(at)] & bit == 0 {
        return Ok("hmmsg.bump".into());
    }
    let (r, c) = ((at / 5) as i8 + dr, (at % 5) as i8 + dc);
    let next = (r * 5 + c) as u8;
    s.val_mut("pos")[0] = next;
    if next == MAZE_CENTRE && !s.flag("centre") {
        s.set("centre");
        return Ok("hmmsg.centre".into());
    }
    Ok(String::new())
}

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["step", dir] => Some(step_maze(s, dir)),
        ["use", "hmmallet", "tester"] if s.has("hmmallet") => {
            Some(Ok(if moment(s, TESTER_CYCLE, TESTER_SHOW) {
                s.take("hmmallet");
                s.give("hmtoken");
                s.set("got_token");
                "hmmsg.token"
            } else {
                "hmmsg.tester_weak"
            }
            .into()))
        }
        ["tap", "periscope"] => Some(Ok(if !s.flag("curtain_open") {
            "hmmsg.nothing"
        } else {
            s.set("saw_mark");
            "hmmsg.periscope"
        }
        .into())),
        ["tap", "squatmirror"] => {
            s.set("darts_seen");
            Some(Ok("hmmsg.squatmirror".into()))
        }
        ["flip", "fuses", i] => Some(match i.parse::<usize>().ok().filter(|i| *i < FUSES.len()) {
            None => Err(bad("index")),
            Some(_) if !s.flag("gen_ok") => Ok("hmmsg.no_power".into()),
            Some(_) if s.flag("fuses_ok") => Ok(String::new()),
            Some(i) => {
                let f = s.val_mut("fuses");
                f[i] = 1 - f[i];
                if f.iter().sum::<u8>() > FUSE_LIMIT {
                    f.iter_mut().for_each(|x| *x = 0);
                    Ok("hmmsg.trip".into())
                } else {
                    Ok(String::new())
                }
            }
        }),
        ["balloon", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 5) {
            None => Err(bad("balloon")),
            Some(_) if !s.has("hmdarts") => Ok(if s.flag("got_mirror") {
                "hmmsg.nothing"
            } else {
                "hmmsg.no_darts"
            }
            .into()),
            Some(b) => match sequence(s, "pops", &BALLOONS, b) {
                (true, _) => {
                    s.take("hmdarts");
                    s.give("hmmirror");
                    s.set("got_mirror");
                    Ok("hmmsg.prize".into())
                }
                (false, true) => Ok("hmmsg.pop".into()),
                (false, false) => Ok("hmmsg.refill".into()),
            },
        }),
        ["tap", "carousel"] => Some(Ok(if !s.flag("turning") {
            "hmmsg.carousel_still"
        } else if moment(s, SADDLE_CYCLE, SADDLE_SHOW) {
            s.set("spotted");
            "hmmsg.saddle"
        } else {
            "hmmsg.carousel_turns"
        }
        .into())),
        ["tap", "crank"] => Some(Ok(if !s.flag("spotted") {
            "hmmsg.organ_silent"
        } else if s.flag("music") {
            "hmmsg.nothing"
        } else if s.val("card")[0] == CARD {
            s.set("music");
            "hmmsg.music"
        } else {
            "hmmsg.organ_wrong"
        }
        .into())),
        _ => talk(s, words, &LINES, "zelda_on", "hm"),
    }
}

/// Minutes for three stars (about 1.3 times the owner's time, 2026-11-21).
pub const PAR_MINUTES: u32 = 13;

pub static SPEC: Spec = Spec {
    id: "mirrors",
    prefix: "hm",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_coin",
        "in_maze",
        "centre",
        "got_key",
        "cabinet_open",
        "got_token",
        "zelda_on",
        "told",
        "unwarped",
        "horses_ok",
        "curtain_open",
        "saw_mark",
        "gen_ok",
        "fuses_ok",
        "darts_seen",
        "got_darts",
        "got_mirror",
        "mirror_in",
        "beam_ok",
        "turning",
        "spotted",
        "music",
        "got_sugar",
        "got_stick",
        "sugar_in",
        "got_floss",
        "done",
    ],
    items: &[
        "hmcoin",
        "hmkey",
        "hmmallet",
        "hmcylinder",
        "hmtoken",
        "hmdarts",
        "hmmirror",
        "hmsugar",
        "hmstick",
        "hmfloss",
    ],
    locks: &[],
    dials: &[
        Dial {
            name: "pos",
            size: 25,
            start: &[MAZE_START],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "horses",
            size: 4,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "unwarped&told",
            needs_msg: "hmmsg.horses_stuck",
            freeze: "horses_ok",
        },
        Dial {
            name: "generator",
            size: 6,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "gen_ok",
        },
        Dial {
            name: "fuses",
            size: 2,
            start: &[0, 0, 0, 0, 0],
            wrap: true,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "spots",
            size: 8,
            start: &[0, 0],
            wrap: true,
            needs: "mirror_in",
            needs_msg: "hmmsg.spot_empty",
            freeze: "beam_ok",
        },
        Dial {
            name: "pops",
            size: 6,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "card",
            size: 4,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "music",
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
            spot: "coin",
            needs: "",
            locked_msg: "",
            got: "got_coin",
            give: &["hmcoin"],
            msg: "hmmsg.coin",
        },
        Pick {
            spot: "brasskey",
            needs: "centre",
            locked_msg: "hmmsg.nothing",
            got: "got_key",
            give: &["hmkey"],
            msg: "hmmsg.key",
        },
        Pick {
            spot: "curtain",
            needs: "",
            locked_msg: "",
            got: "curtain_open",
            give: &[],
            msg: "hmmsg.curtain",
        },
        Pick {
            spot: "shelf",
            needs: "darts_seen",
            locked_msg: "hmmsg.shelf_high",
            got: "got_darts",
            give: &["hmdarts"],
            msg: "hmmsg.darts",
        },
        Pick {
            spot: "sugar",
            needs: "",
            locked_msg: "",
            got: "got_sugar",
            give: &["hmsugar"],
            msg: "hmmsg.sugar",
        },
        Pick {
            spot: "sticks",
            needs: "",
            locked_msg: "",
            got: "got_stick",
            give: &["hmstick"],
            msg: "hmmsg.stick",
        },
        Pick {
            spot: "lever",
            needs: "fuses_ok&beam_ok&horses_ok",
            locked_msg: "hmmsg.brake_held",
            got: "turning",
            give: &[],
            msg: "hmmsg.turning",
        },
    ],
    uses: &[
        Use {
            item: "hmcoin",
            spot: "turnstile",
            needs: "",
            fail: "",
            keep: false,
            set: "in_maze",
            give: &[],
            msg: "hmmsg.turnstile",
        },
        Use {
            item: "hmkey",
            spot: "cabinet",
            needs: "",
            fail: "",
            keep: false,
            set: "cabinet_open",
            give: &["hmmallet", "hmcylinder"],
            msg: "hmmsg.cabinet",
        },
        Use {
            item: "hmtoken",
            spot: "zelda",
            needs: "",
            fail: "",
            keep: false,
            set: "zelda_on",
            give: &[],
            msg: "hmmsg.zelda_on",
        },
        Use {
            item: "hmcylinder",
            spot: "drawing",
            needs: "",
            fail: "",
            keep: false,
            set: "unwarped",
            give: &[],
            msg: "hmmsg.unwarped",
        },
        Use {
            item: "hmmirror",
            spot: "spotlight",
            needs: "",
            fail: "",
            keep: false,
            set: "mirror_in",
            give: &[],
            msg: "hmmsg.mirror_in",
        },
        Use {
            item: "hmsugar",
            spot: "machine",
            needs: "gen_ok",
            fail: "hmmsg.machine_cold",
            keep: false,
            set: "sugar_in",
            give: &[],
            msg: "hmmsg.sugar_in",
        },
        Use {
            item: "hmstick",
            spot: "machine",
            needs: "sugar_in",
            fail: "hmmsg.machine_empty",
            keep: false,
            set: "got_floss",
            give: &["hmfloss"],
            msg: "hmmsg.floss",
        },
        Use {
            item: "hmfloss",
            spot: "clown",
            needs: "music",
            fail: "hmmsg.clown_still",
            keep: false,
            set: "done",
            give: &[],
            msg: "hmmsg.attendant",
        },
    ],
    checks: &[
        Check {
            flag: "horses_ok",
            cond: |s| s.flag("unwarped&told") && s.val("horses") == HORSES,
            msg: "hmmsg.horses_ok",
        },
        Check {
            flag: "gen_ok",
            cond: |s| s.flag("saw_mark") && s.val("generator")[0] == GENERATOR,
            msg: "hmmsg.gen_ok",
        },
        Check {
            flag: "fuses_ok",
            cond: |s| s.val("fuses") == FUSES,
            msg: "hmmsg.fuses_ok",
        },
        Check {
            flag: "beam_ok",
            cond: |s| s.flag("mirror_in&fuses_ok") && s.val("spots") == SPOTS,
            msg: "hmmsg.beam_ok",
        },
    ],
    looks: &[],
    flavour: &[
        "booth",
        "plan",
        "poster",
        "zelda",
        "turnstile",
        "cabinet",
        "tester",
        "drawing",
        "wavymirror",
        "machine",
        "clown",
        "organ",
        "fusebox",
        "spotlight",
        "sensor",
        "generator",
        "horses",
        "stall",
        "maze",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_coin"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("in_maze"),
            available: |s| s.flag("got_coin"),
        },
        Puzzle {
            solved: |s| s.flag("centre"),
            available: |s| s.flag("in_maze"),
        },
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |s| s.flag("centre"),
        },
        Puzzle {
            solved: |s| s.flag("cabinet_open"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("got_token"),
            available: |s| s.flag("cabinet_open"),
        },
        Puzzle {
            solved: |s| s.flag("zelda_on"),
            available: |s| s.flag("got_token"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("zelda_on"),
        },
        Puzzle {
            solved: |s| s.flag("unwarped"),
            available: |s| s.flag("cabinet_open"),
        },
        Puzzle {
            solved: |s| s.flag("horses_ok"),
            available: |s| s.flag("unwarped&told"),
        },
        Puzzle {
            solved: |s| s.flag("saw_mark"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("gen_ok"),
            available: |s| s.flag("saw_mark"),
        },
        Puzzle {
            solved: |s| s.flag("fuses_ok"),
            available: |s| s.flag("gen_ok"),
        },
        Puzzle {
            solved: |s| s.flag("got_darts"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_mirror"),
            available: |s| s.flag("got_darts"),
        },
        Puzzle {
            solved: |s| s.flag("mirror_in"),
            available: |s| s.flag("got_mirror"),
        },
        Puzzle {
            solved: |s| s.flag("beam_ok"),
            available: |s| s.flag("mirror_in&fuses_ok"),
        },
        Puzzle {
            solved: |s| s.flag("turning"),
            available: |s| s.flag("fuses_ok&beam_ok&horses_ok"),
        },
        Puzzle {
            solved: |s| s.flag("spotted"),
            available: |s| s.flag("turning"),
        },
        Puzzle {
            solved: |s| s.flag("music"),
            available: |s| s.flag("spotted"),
        },
        Puzzle {
            solved: |s| s.flag("got_sugar"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_stick"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_floss"),
            available: |s| s.flag("got_sugar&got_stick&gen_ok"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_floss&music"),
        },
    ],
    hint_views: &[
        ("HM1", &[0, 1, 6, 7, 14]),
        ("HM2", &[2, 3]),
        ("HM3", &[4, 5, 8, 10, 13, 14, 20, 21, 22]),
        ("HM4", &[9, 11, 12, 15, 16, 17, 18, 19, 23]),
        ("hmbooth", &[2]),
        ("hmposter", &[14]),
        ("hmzelda", &[6, 7]),
        ("hmdrawing", &[8, 9]),
        ("hmperiscope", &[10, 11]),
        ("hmstall", &[13, 14]),
        ("hmcart", &[20, 21, 22]),
        ("hmhorses", &[9]),
        ("hmgen", &[11]),
        ("hmfuses", &[12]),
        ("hmspots", &[15, 16]),
        ("hmorgan", &[19]),
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

    /// The way through the maze, read off the plan.
    pub const WAY: &str = "enennnwssw";

    #[test]
    fn the_attendant_comes() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "step n"), "hmmsg.turnstile_shut");
        msg(&mut r, "tap coin");
        msg(&mut r, "use hmcoin turnstile");
        assert_eq!(msg(&mut r, "step w"), "hmmsg.bump");
        for d in WAY.chars() {
            msg(&mut r, &format!("step {d}"));
        }
        assert!(r.flag("centre"));
        msg(&mut r, "tap brasskey");
        msg(&mut r, "use hmkey cabinet");
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "use hmmallet tester"), "hmmsg.tester_weak");
        msg(&mut r, &format!("time {}", TESTER_CYCLE - 1));
        msg(&mut r, "use hmmallet tester");
        msg(&mut r, "use hmtoken zelda");
        say_all(&mut r, &[1, 2, 0]);
        assert!(r.flag("told"));
        msg(&mut r, "use hmcylinder drawing");
        turn_to(&mut r, "horses", &HORSES, 4);
        assert!(r.flag("horses_ok"));
        msg(&mut r, "tap curtain");
        msg(&mut r, "tap periscope");
        turn_to(&mut r, "generator", &[GENERATOR], 6);
        assert!(r.flag("gen_ok"));
        for i in [3, 4, 0, 1] {
            msg(&mut r, &format!("flip fuses {i}"));
        }
        assert_eq!(r.val("fuses"), &[0, 0, 0, 0, 0]);
        for i in 0..3 {
            msg(&mut r, &format!("flip fuses {i}"));
        }
        assert!(r.flag("fuses_ok"));
        assert_eq!(msg(&mut r, "tap shelf"), "hmmsg.shelf_high");
        msg(&mut r, "tap squatmirror");
        msg(&mut r, "tap shelf");
        assert_eq!(msg(&mut r, "balloon 1"), "hmmsg.refill");
        for b in BALLOONS {
            msg(&mut r, &format!("balloon {b}"));
        }
        msg(&mut r, "use hmmirror spotlight");
        turn_to(&mut r, "spots", &SPOTS, 8);
        assert!(r.flag("beam_ok"));
        msg(&mut r, "tap lever");
        msg(&mut r, "time 7");
        assert_eq!(msg(&mut r, "tap carousel"), "hmmsg.carousel_turns");
        msg(&mut r, &format!("time {}", SADDLE_CYCLE * 2 - 1));
        msg(&mut r, "tap carousel");
        turn_to(&mut r, "card", &[CARD], 4);
        msg(&mut r, "tap crank");
        assert!(r.flag("music"));
        msg(&mut r, "tap sugar");
        msg(&mut r, "tap sticks");
        msg(&mut r, "use hmsugar machine");
        msg(&mut r, "use hmstick machine");
        msg(&mut r, "use hmfloss clown");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
