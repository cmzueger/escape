//! The 8:15 to Nowhere (hard): a model railway club; the founder's last
//! layout. Eleven puzzles. Views: `RC1` (the club room: the layout with the
//! shed and turntable, yard, two points, the dairy, the tunnel into the wall,
//! the notice board, the telephone) and `RC2` (the workshop: the layout out
//! of the tunnel, two points, the post office, the bookcase, the workbench).
//!
//! A run follows the points: P1 yard or main line; P2 dairy or tunnel; in
//! the workshop P3 post office or on; P4 back to the shed or to Nowhere.

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::kit::{Check, Dial, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The engines on turntable tracks 1 to 4: green, red, blue, black. The
/// logic grid (Finch's notes and Mrs Hollis) makes the black one, on track
/// 4, the 8:15.
pub const ENGINE: u8 = 4;
/// The yard: three tracks (capacity 3, 3, 2), listed from the buffer to the
/// points; wagons 1 passengers, 2 mail, 3 coal, 4 timber, 5 oil.
pub const CAPS: [usize; 3] = [3, 3, 2];
pub const YARD_START: [[u8; 3]; 3] = [[4, 1, 3], [2, 5, 0], [0, 0, 0]];
/// The 8:15: passengers behind the engine, then mail, coal at the back.
pub const CONSIST: [u8; 3] = [3, 2, 1];
/// The book on the tunnel sign (of eight on the shelf).
pub const BOOK: u8 = 5;

/// The yard as lists (buffer to points).
pub fn yard(s: &State) -> Vec<Vec<u8>> {
    let v = s.val("yard");
    let mut at = 0;
    CAPS.iter()
        .map(|c| {
            let t: Vec<u8> = v[at..at + c].iter().copied().filter(|w| *w != 0).collect();
            at += c;
            t
        })
        .collect()
}

fn set_yard(s: &mut State, tracks: &[Vec<u8>]) {
    let mut cells = Vec::new();
    for (t, c) in tracks.iter().zip(CAPS) {
        let mut row = t.clone();
        row.resize(c, 0);
        cells.extend(row);
    }
    *s.val_mut("yard") = cells;
}

pub static LINES: [Line; 3] = [
    Line {
        text: "rctalk.1",
        choices: &[("rcsay.1a", 0), ("rcsay.1b", 2), ("rcsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "rctalk.2",
        choices: &[("rcsay.2a", 3), ("rcsay.2b", 0)],
        sets: "",
    },
    Line {
        text: "rctalk.3",
        choices: &[("rcsay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"caps\":[{}],\"book\":{BOOK},\"lines\":[{}]}}",
        nums_json(&[3, 3, 2]),
        lines_json(&LINES)
    )
}

/// Where a run ends: "yard", "dairy", "post", "loop", "gap", "nowhere".
pub fn destination(s: &State) -> &'static str {
    let (p1, p2) = (s.val("points1")[0], s.val("points1")[1]);
    let (p3, p4) = (s.val("points2")[0], s.val("points2")[1]);
    if p1 == 0 {
        "yard"
    } else if p2 == 0 {
        "dairy"
    } else if p3 == 0 {
        "post"
    } else if p4 == 0 {
        "loop"
    } else if !s.flag("bridge_in") {
        "gap"
    } else {
        "nowhere"
    }
}

fn extra(s: &State) -> String {
    format!(",\"dest\":\"{}\"", destination(s))
}

fn run(s: &mut State) -> &'static str {
    if !s.flag("engine_out") {
        return "rcmsg.no_engine";
    }
    s.val_mut("runs")[0] = s.val("runs")[0] % 9 + 1;
    match destination(s) {
        "yard" => "rcmsg.to_yard",
        "dairy" if !s.flag("milk_ok") => {
            s.set("milk_ok");
            "rcmsg.milk_ok"
        }
        "dairy" => "rcmsg.dairy_again",
        "post" if !s.flag("milk_ok") => "rcmsg.milk_lost",
        "post" if !s.flag("post_ok") => {
            s.set("post_ok");
            "rcmsg.post_ok"
        }
        "post" => "rcmsg.post_again",
        "loop" => "rcmsg.loop",
        "gap" if !s.flag("branch_open") => "rcmsg.buffer",
        "gap" => "rcmsg.gap",
        _ => {
            if s.flag("consist_ok&engine_ok") && s.val("turn")[0] == ENGINE {
                s.set("done");
                "rcmsg.nowhere"
            } else {
                "rcmsg.not_815"
            }
        }
    }
}

/// `run`, `shunt <from> <to>` in the yard, `book <i>` on the shelf, and
/// the telephone.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["run"] => Some(Ok(run(s).into())),
        ["shunt", a, b] => {
            let (Some(a), Some(b)) = (a.parse::<usize>().ok(), b.parse::<usize>().ok()) else {
                return Some(Err(bad("shunt")));
            };
            if a > 2 || b > 2 || a == b {
                return Some(Err(bad("shunt")));
            }
            if !s.flag("powered") {
                return Some(Ok("rcmsg.no_power".into()));
            }
            if s.flag("consist_ok") {
                return Some(Ok("rcmsg.consist_done".into()));
            }
            let mut t = yard(s);
            if t[a].is_empty() {
                return Some(Ok("rcmsg.track_empty".into()));
            }
            if t[b].len() >= CAPS[b] {
                return Some(Ok("rcmsg.track_full".into()));
            }
            let w = t[a].pop().unwrap_or(0);
            t[b].push(w);
            set_yard(s, &t);
            Some(Ok(String::new()))
        }
        ["book", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 8) {
            None => Err(bad("book")),
            Some(_) if s.flag("branch_open") => Ok("rcmsg.shelf_open".into()),
            Some(i) if i == BOOK && s.flag("post_ok") => {
                s.set("branch_open");
                s.give("rcbook");
                Ok("rcmsg.branch".into())
            }
            Some(_) => Ok("rcmsg.just_a_book".into()),
        }),
        _ => talk(s, words, &LINES, "powered", "rc"),
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 22;

pub static SPEC: Spec = Spec {
    id: "railway",
    prefix: "rc",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_key",
        "powered",
        "engine_out",
        "milk_ok",
        "post_ok",
        "told",
        "got_notes",
        "got_board",
        "engine_ok",
        "branch_open",
        "consist_ok",
        "bridge_in",
        "done",
    ],
    items: &["rckey", "rcboard", "rcbook"],
    locks: &[],
    dials: &[
        Dial {
            name: "turn",
            size: 5,
            start: &[0],
            wrap: true,
            needs: "powered",
            needs_msg: "rcmsg.no_power",
            freeze: "",
        },
        Dial {
            name: "points1",
            size: 2,
            start: &[0, 0],
            wrap: true,
            needs: "powered",
            needs_msg: "rcmsg.no_power",
            freeze: "",
        },
        Dial {
            name: "points2",
            size: 2,
            start: &[1, 0],
            wrap: true,
            needs: "powered",
            needs_msg: "rcmsg.no_power",
            freeze: "",
        },
        Dial {
            name: "yard",
            size: 6,
            start: &[4, 1, 3, 2, 5, 0, 0, 0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "runs",
            size: 10,
            start: &[0],
            wrap: true,
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
            spot: "clocktower",
            needs: "",
            locked_msg: "",
            got: "got_key",
            give: &["rckey"],
            msg: "rcmsg.key",
        },
        Pick {
            spot: "notebook",
            needs: "",
            locked_msg: "",
            got: "got_notes",
            give: &[],
            msg: "rcmsg.notes",
        },
        Pick {
            spot: "headboard",
            needs: "",
            locked_msg: "",
            got: "got_board",
            give: &["rcboard"],
            msg: "rcmsg.board",
        },
    ],
    uses: &[
        Use {
            item: "rckey",
            spot: "controller",
            needs: "",
            fail: "",
            keep: false,
            set: "powered",
            give: &[],
            msg: "rcmsg.powered",
        },
        Use {
            item: "rcboard",
            spot: "engine4",
            needs: "told&got_notes",
            fail: "rcmsg.not_sure",
            keep: false,
            set: "engine_ok",
            give: &[],
            msg: "rcmsg.board_on",
        },
        Use {
            item: "rcboard",
            spot: "engine1|engine2|engine3",
            needs: "never",
            fail: "rcmsg.wrong_engine",
            keep: true,
            set: "",
            give: &[],
            msg: "",
        },
        Use {
            item: "rcbook",
            spot: "gap",
            needs: "",
            fail: "",
            keep: false,
            set: "bridge_in",
            give: &[],
            msg: "rcmsg.bridge",
        },
    ],
    checks: &[
        Check {
            flag: "engine_out",
            cond: |s| s.flag("powered") && s.val("turn")[0] != 0,
            msg: "rcmsg.engine_out",
        },
        Check {
            flag: "consist_ok",
            cond: |s| s.flag("powered") && yard(s)[0] == CONSIST,
            msg: "rcmsg.consist_ok",
        },
    ],
    looks: &[Look {
        spot: "gap",
        flag: "bridge_in",
        set: "rcmsg.gap_bridged",
        unset: "rcmsg.gap_open",
    }],
    flavour: &[
        "station",
        "letter",
        "board",
        "portrait",
        "phone",
        "dairy",
        "post",
        "tunnel",
        "bookcase",
        "bench",
        "controller",
        "engine1",
        "engine2",
        "engine3",
        "engine4",
        "yardsign",
        "sign",
        "clock",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_key"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("powered"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.flag("engine_out"),
            available: |s| s.flag("powered"),
        },
        Puzzle {
            solved: |s| s.flag("milk_ok"),
            available: |s| s.flag("engine_out"),
        },
        Puzzle {
            solved: |s| s.flag("post_ok"),
            available: |s| s.flag("milk_ok"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("powered"),
        },
        Puzzle {
            solved: |s| s.flag("engine_ok"),
            available: |s| s.flag("told&got_notes&got_board"),
        },
        Puzzle {
            solved: |s| s.flag("branch_open"),
            available: |s| s.flag("post_ok"),
        },
        Puzzle {
            solved: |s| s.flag("consist_ok"),
            available: |s| s.flag("powered"),
        },
        Puzzle {
            solved: |s| s.flag("bridge_in"),
            available: |s| s.flag("branch_open"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("consist_ok&engine_ok&bridge_in"),
        },
    ],
    hint_views: &[
        ("RC1", &[0, 1, 2, 3, 5, 8, 10]),
        ("RC2", &[4, 6, 7, 9, 10]),
        ("rcstation", &[0]),
        ("rccontrol", &[1, 3, 4, 10]),
        ("rcturntable", &[2, 6, 10]),
        ("rcyard", &[8]),
        ("rcletter", &[8, 10]),
        ("rcphone", &[5]),
        ("rcpoints", &[4, 10]),
        ("rcsign", &[7]),
        ("rcshelf", &[7]),
        ("rcbench", &[6]),
        ("rcgap", &[9]),
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
    use crate::kit::msg;
    use std::collections::{HashSet, VecDeque};

    /// The fewest shunting moves to the 8:15, and one way there.
    fn shunting() -> Vec<(usize, usize)> {
        let start: Vec<Vec<u8>> = YARD_START
            .iter()
            .map(|t| t.iter().copied().filter(|w| *w != 0).collect())
            .collect();
        let mut seen = HashSet::new();
        let mut todo = VecDeque::from([(start.clone(), vec![])]);
        seen.insert(start);
        while let Some((t, path)) = todo.pop_front() {
            if t[0] == CONSIST {
                return path;
            }
            for a in 0..3 {
                for b in 0..3 {
                    if a != b && !t[a].is_empty() && t[b].len() < CAPS[b] {
                        let mut u = t.clone();
                        let w = u[a].pop().unwrap();
                        u[b].push(w);
                        if seen.insert(u.clone()) {
                            let mut p: Vec<(usize, usize)> = path.clone();
                            p.push((a, b));
                            todo.push_back((u, p));
                        }
                    }
                }
            }
        }
        panic!("no way to the 8:15");
    }

    /// Finch's logic grid has one answer: the 8:15 is the black engine.
    #[test]
    fn the_grid_has_one_answer() {
        // Colours 0 green 1 red 2 blue 3 black; names 0 Comet 1 Duchess 2
        // Lark 3 Atlas; slots 0 6:40 1 7:05 2 7:30 3 8:15.
        let perms: Vec<Vec<usize>> = (0..24)
            .map(|mut n| {
                let mut pool = vec![0, 1, 2, 3];
                let mut p = vec![];
                for k in (1..=4).rev() {
                    p.push(pool.remove(n % k));
                    n /= k;
                }
                p
            })
            .collect();
        let mut answers = HashSet::new();
        for name in &perms {
            for slot in &perms {
                // name[colour], slot[colour]
                let colour_of = |n: usize| name.iter().position(|x| *x == n).unwrap();
                let ok = colour_of(0) == 2
                    && slot[colour_of(3)] == 0
                    && slot[3] > slot[1]
                    && slot[colour_of(1)] == 2
                    && name[0] != 3
                    && slot[0] != 1
                    && slot[colour_of(2)] > slot[colour_of(0)]
                    && slot[0] < slot[3];
                if ok {
                    answers.insert(slot.iter().position(|x| *x == 3).unwrap());
                }
            }
        }
        assert_eq!(answers, HashSet::from([usize::from(ENGINE) - 1]));
    }

    #[test]
    fn the_815_leaves() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap clocktower");
        assert_eq!(msg(&mut r, "run"), "rcmsg.no_engine");
        msg(&mut r, "use rckey controller");
        msg(&mut r, "turn turn 0 +1");
        assert!(r.flag("engine_out"));
        msg(&mut r, "turn points1 0 +1");
        assert_eq!(msg(&mut r, "run"), "rcmsg.milk_ok");
        msg(&mut r, "turn points1 1 +1");
        msg(&mut r, "turn points2 0 +1");
        assert_eq!(msg(&mut r, "run"), "rcmsg.post_ok");
        assert_eq!(msg(&mut r, "book 2"), "rcmsg.just_a_book");
        msg(&mut r, &format!("book {BOOK}"));
        say_all(&mut r, &[1, 0, 0]);
        assert!(r.flag("told"));
        msg(&mut r, "tap notebook");
        msg(&mut r, "tap headboard");
        assert_eq!(msg(&mut r, "use rcboard engine2"), "rcmsg.wrong_engine");
        msg(&mut r, "use rcboard engine4");
        let moves = shunting();
        assert_eq!(moves.len(), 11, "the yard takes eleven moves at best");
        for (a, b) in moves {
            msg(&mut r, &format!("shunt {a} {b}"));
        }
        assert!(r.flag("consist_ok"));
        msg(&mut r, "turn points2 0 +1");
        msg(&mut r, "turn points2 1 +1");
        assert_eq!(msg(&mut r, "run"), "rcmsg.gap");
        msg(&mut r, "use rcbook gap");
        assert_eq!(msg(&mut r, "run"), "rcmsg.not_815", "not with the shunter");
        for _ in 1..ENGINE {
            msg(&mut r, "turn turn 0 +1");
        }
        assert_eq!(msg(&mut r, "run"), "rcmsg.nowhere");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
