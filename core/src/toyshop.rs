//! Tinker & Sons (hard): a toy shop on a Christmas evening, locked up with
//! you inside. Seven puzzles. Views: `Y1` (window display with the tree and
//! a clockwork train, the counter with the till, the door) and `Y2` (the
//! wall of little drawers, the dollhouse, the wooden labyrinth game, the
//! nutcracker).
//!
//! The dollhouse is a tiny copy of the shop: what happens in one shows in
//! the other. The labyrinth's ball rolls until something stops it and
//! drops into the hole when it rolls over it. The four presents under the
//! tree are labelled by deduction from the shopkeeper's order notes.

use crate::bad;
use crate::kit::{no_extra, Check, Dial, Look, Pick, Puzzle, Reply, Spec, State, Use};

/// The wall of drawers: 3 rows of 4; the dollhouse's copy has this one ajar.
pub const DRAWERS: u8 = 12;
pub const AJAR: u8 = 6;
/// The labyrinth: 6 by 6, wooden pegs, the ball's start and the hole.
pub const MAZE: u8 = 6;
pub const PEGS: [(u8, u8); 7] = [(1, 1), (5, 0), (4, 2), (2, 3), (1, 4), (2, 4), (5, 4)];
pub const BALL_START: (u8, u8) = (0, 5);
pub const HOLE: (u8, u8) = (3, 4);
/// The presents: children (cap, pigtails, glasses, bonnet) and toys (teddy,
/// drum, horse, kite). The notes cross out these child-toy pairs; exactly
/// one way to give each child a toy is left.
pub const CROSSED: [(u8, u8); 6] = [(0, 0), (0, 2), (2, 0), (2, 2), (2, 3), (3, 2)];
pub const GIFTS: [u8; 4] = [3, 2, 1, 0];

/// Rolls the ball one way: `None` when it drops into the hole.
pub fn roll(from: (u8, u8), dir: (i8, i8)) -> Option<(u8, u8)> {
    let (mut x, mut y) = (from.0 as i8, from.1 as i8);
    loop {
        let (nx, ny) = (x + dir.0, y + dir.1);
        if !(0..MAZE as i8).contains(&nx)
            || !(0..MAZE as i8).contains(&ny)
            || PEGS.contains(&(nx as u8, ny as u8))
        {
            return Some((x as u8, y as u8));
        }
        (x, y) = (nx, ny);
        if (x as u8, y as u8) == HOLE {
            return None;
        }
    }
}

pub fn direction(word: &str) -> Option<(i8, i8)> {
    match word {
        "n" => Some((0, -1)),
        "e" => Some((1, 0)),
        "s" => Some((0, 1)),
        "w" => Some((-1, 0)),
        _ => None,
    }
}

fn clues() -> String {
    let cells = |v: &[(u8, u8)]| {
        v.iter()
            .map(|(x, y)| format!("[{x},{y}]"))
            .collect::<Vec<_>>()
            .join(",")
    };
    format!(
        "{{\"ok\":true,\"drawers\":{DRAWERS},\"ajar\":{AJAR},\"maze\":{MAZE},\"pegs\":[{}],\"hole\":[{},{}],\"crossed\":[{}]}}",
        cells(&PEGS),
        HOLE.0,
        HOLE.1,
        cells(&CROSSED)
    )
}

/// `drawer <0..11>`, `tilt <n|e|s|w|reset>`.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["drawer", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < DRAWERS) {
            None => Err(bad("drawer")),
            Some(AJAR) if !s.flag("got_wind") => {
                s.set("got_wind");
                s.give("windkey");
                Ok("ymsg.windkey".into())
            }
            Some(_) => Ok("ymsg.drawer_empty".into()),
        }),
        ["tilt", way] => Some(if !s.flag("marble_in") {
            Ok("ymsg.maze_empty".into())
        } else if s.flag("maze_done") {
            Ok(String::new())
        } else if *way == "reset" {
            *s.val_mut("ball") = vec![BALL_START.0, BALL_START.1];
            Ok("ymsg.maze_reset".into())
        } else if let Some(dir) = direction(way) {
            let at = s.val("ball");
            match roll((at[0], at[1]), dir) {
                Some((x, y)) => {
                    *s.val_mut("ball") = vec![x, y];
                    Ok(String::new())
                }
                None => {
                    *s.val_mut("ball") = vec![HOLE.0, HOLE.1];
                    s.set("maze_done");
                    Ok("ymsg.maze_done".into())
                }
            }
        } else {
            Err(bad("tilt"))
        }),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 5;

pub static SPEC: Spec = Spec {
    id: "toyshop",
    prefix: "y",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_wind",
        "train_on",
        "got_walnut",
        "got_marble",
        "marble_in",
        "maze_done",
        "got_star",
        "tree_lit",
        "gifts_ok",
        "got_shopkey",
        "done",
    ],
    items: &["windkey", "walnut", "marble", "star", "shopkey"],
    locks: &[],
    dials: &[
        Dial {
            name: "gifts",
            size: 4,
            start: &[0, 1, 2, 3],
            wrap: true,
            needs: "tree_lit",
            needs_msg: "ymsg.too_dark",
            freeze: "gifts_ok",
        },
        Dial {
            name: "ball",
            size: MAZE,
            start: &[BALL_START.0, BALL_START.1],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "station",
            needs: "train_on",
            locked_msg: "ymsg.station",
            got: "got_walnut",
            give: &["walnut"],
            msg: "ymsg.walnut",
        },
        Pick {
            spot: "mazebox",
            needs: "maze_done",
            locked_msg: "ymsg.mazebox_shut",
            got: "got_star",
            give: &["star"],
            msg: "ymsg.star",
        },
        Pick {
            spot: "till",
            needs: "gifts_ok",
            locked_msg: "ymsg.till_shut",
            got: "got_shopkey",
            give: &["shopkey"],
            msg: "ymsg.shopkey",
        },
    ],
    uses: &[
        Use {
            item: "windkey",
            spot: "train",
            needs: "",
            fail: "",
            keep: false,
            set: "train_on",
            give: &[],
            msg: "ymsg.train_on",
        },
        Use {
            item: "walnut",
            spot: "nutcracker",
            needs: "",
            fail: "",
            keep: false,
            set: "got_marble",
            give: &["marble"],
            msg: "ymsg.marble",
        },
        Use {
            item: "marble",
            spot: "maze",
            needs: "",
            fail: "",
            keep: false,
            set: "marble_in",
            give: &[],
            msg: "ymsg.marble_in",
        },
        Use {
            item: "star",
            spot: "tree",
            needs: "",
            fail: "",
            keep: false,
            set: "tree_lit",
            give: &[],
            msg: "ymsg.tree_lit",
        },
        Use {
            item: "shopkey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "ymsg.door_open",
        },
    ],
    checks: &[Check {
        flag: "gifts_ok",
        cond: |s| s.flag("tree_lit") && s.val("gifts") == GIFTS,
        msg: "ymsg.till_open",
    }],
    looks: &[
        Look {
            spot: "train",
            flag: "train_on",
            set: "ymsg.train_runs",
            unset: "ymsg.train_still",
        },
        Look {
            spot: "tree",
            flag: "tree_lit",
            set: "ymsg.tree_shines",
            unset: "ymsg.tree_dark",
        },
        Look {
            spot: "maze",
            flag: "marble_in",
            set: "ymsg.maze_ready",
            unset: "ymsg.maze_empty",
        },
        Look {
            spot: "door",
            flag: "done",
            set: "ymsg.door_open",
            unset: "ymsg.door_locked",
        },
        Look {
            spot: "nutcracker",
            flag: "got_marble",
            set: "ymsg.nutcracker_done",
            unset: "ymsg.nutcracker",
        },
    ],
    flavour: &["bear", "rocker", "snow", "bell", "dollhouse", "notes", "shelf"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_wind"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("train_on"),
            available: |s| s.flag("got_wind"),
        },
        Puzzle {
            solved: |s| s.flag("got_marble"),
            available: |s| s.flag("got_walnut"),
        },
        Puzzle {
            solved: |s| s.flag("maze_done"),
            available: |s| s.flag("got_marble"),
        },
        Puzzle {
            solved: |s| s.flag("tree_lit"),
            available: |s| s.flag("got_star"),
        },
        Puzzle {
            solved: |s| s.flag("gifts_ok"),
            available: |s| s.flag("tree_lit"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_shopkey"),
        },
    ],
    hint_views: &[
        ("Y1", &[1, 4, 5, 6]),
        ("Y2", &[0, 2, 3]),
        ("ydoll", &[0]),
        ("ydrawers", &[0]),
        ("ytrain", &[1, 4]),
        ("ymaze", &[3]),
        ("ygifts", &[5]),
        ("ynotes", &[5]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    /// Fewest tilts from the start to the hole, and that the hole stays
    /// reachable from everywhere the ball can get to.
    #[test]
    fn the_labyrinth_is_fair() {
        let ways = ["n", "e", "s", "w"].map(|w| direction(w).unwrap());
        let mut dist = std::collections::HashMap::from([(BALL_START, 0)]);
        let mut todo = std::collections::VecDeque::from([BALL_START]);
        let mut best = None;
        while let Some(at) = todo.pop_front() {
            for d in ways {
                match roll(at, d) {
                    None => best = best.or(Some(dist[&at] + 1)),
                    Some(next) if !dist.contains_key(&next) => {
                        dist.insert(next, dist[&at] + 1);
                        todo.push_back(next);
                    }
                    _ => {}
                }
            }
        }
        assert_eq!(best, Some(7));
        for at in dist.keys() {
            let mut seen = std::collections::HashSet::from([*at]);
            let mut todo = vec![*at];
            let mut out = false;
            while let Some(p) = todo.pop() {
                for d in ways {
                    match roll(p, d) {
                        None => out = true,
                        Some(n) if seen.insert(n) => todo.push(n),
                        _ => {}
                    }
                }
            }
            assert!(out, "no way to the hole from {at:?}");
        }
    }

    #[test]
    fn the_notes_leave_one_answer() {
        let mut answers = vec![];
        for a in 0..4u8 {
            for b in 0..4u8 {
                for c in 0..4u8 {
                    let Some(d) = 6u8.checked_sub(a + b + c) else {
                        continue;
                    };
                    let p = [a, b, c, d];
                    let distinct = (0..4).all(|i| (0..4).all(|j| i == j || p[i] != p[j]));
                    if d < 4 && distinct && CROSSED.iter().all(|(k, t)| p[*k as usize] != *t) {
                        answers.push(p);
                    }
                }
            }
        }
        assert_eq!(answers, vec![GIFTS]);
    }

    #[test]
    fn the_shop_can_be_left() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "drawer 0"), "ymsg.drawer_empty");
        assert_eq!(msg(&mut r, "drawer 6"), "ymsg.windkey");
        msg(&mut r, "use windkey train");
        msg(&mut r, "tap station");
        msg(&mut r, "use walnut nutcracker");
        assert_eq!(msg(&mut r, "tilt n"), "ymsg.maze_empty");
        msg(&mut r, "use marble maze");
        msg(&mut r, "tilt e");
        assert_eq!(msg(&mut r, "tilt reset"), "ymsg.maze_reset");
        let mut last = String::new();
        for w in SOLUTION {
            last = msg(&mut r, &format!("tilt {w}"));
        }
        assert_eq!(last, "ymsg.maze_done");
        msg(&mut r, "tap mazebox");
        assert_eq!(msg(&mut r, "turn gifts 0 +1"), "ymsg.too_dark");
        msg(&mut r, "use star tree");
        turn_to(&mut r, "gifts", &GIFTS, 4);
        assert!(r.flag("gifts_ok"));
        msg(&mut r, "tap till");
        msg(&mut r, "use shopkey door");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }

    /// One shortest way through the labyrinth (also used by the client test).
    const SOLUTION: [&str; 7] = ["n", "e", "s", "e", "s", "w", "s"];
}
