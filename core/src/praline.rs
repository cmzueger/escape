//! Praline Works (medium): a 1920s chocolate factory at night, the office
//! door locked. Six puzzles. Views: `P1` (tempering kettle, conveyor, mould
//! cabinet, tilting tray) and `P2` (tiled wall with an enamel sign, the
//! workers' lockers and time cards, the wrapping machine, the office door).
//!
//! The tray: tilting it rolls both pralines at once until something stops
//! them; a praline that rolls over an empty mould drops in. The recipe card
//! is torn in four: each piece goes in its corner of the frame and is
//! turned until the card reads.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// Time cards: the four workers' symbols (cup, bicycle, hat, umbrella) and
/// their clock-in times; the locked locker is the hat's.
pub const TIMES: [(u8, u8); 4] = [(6, 30), (8, 15), (7, 45), (7, 10)];
pub const LOCKER: usize = 2;
/// Praline shapes (heart, star, shell, leaf, bean, square) and their
/// wrapper colours on the enamel sign (red, gold, green, blue, violet,
/// silver): shape i has colour i. The wrapping machine's four reels, left to
/// right, are these colours; the mould cabinet wants the matching shapes.
pub const REELS: [u8; 4] = [2, 0, 3, 1];
/// The tray: 5 by 5, pegs, the two pralines' starts, the two moulds.
pub const TRAY: u8 = 5;
pub const TRAY_PEGS: [(u8, u8); 4] = [(0, 4), (1, 0), (2, 2), (4, 3)];
pub const PRALINES: [u8; 4] = [2, 0, 0, 1];
pub const MOULDS: [(u8, u8); 2] = [(1, 1), (1, 2)];
/// The torn card's pieces start turned like this (quarter turns).
pub const TORN: [u8; 4] = [1, 3, 2, 1];
/// The recipe: heat, cool, warm again (degrees), as the kettle's wheels.
pub const TEMPS: [u8; 3] = [45, 27, 31];

pub fn kettle_code() -> Vec<u8> {
    TEMPS.iter().flat_map(|t| [t / 10, t % 10]).collect()
}

fn in_mould(p: (u8, u8)) -> bool {
    MOULDS.contains(&p)
}

/// Tilts the tray: both pralines roll (the one in front first); a praline in
/// a mould stays there. Positions are `[ax, ay, bx, by]`.
pub fn tilt(at: &[u8], dir: (i8, i8)) -> Vec<u8> {
    let mut ps = [(at[0], at[1]), (at[2], at[3])];
    let mut order = [0usize, 1];
    let ahead = |p: (u8, u8)| p.0 as i16 * dir.0 as i16 + p.1 as i16 * dir.1 as i16;
    order.sort_by_key(|i| -ahead(ps[*i]));
    let mut fixed = [in_mould(ps[0]), in_mould(ps[1])];
    for i in order {
        if fixed[i] {
            continue;
        }
        let other = ps[1 - i];
        let (mut x, mut y) = (ps[i].0 as i8, ps[i].1 as i8);
        loop {
            let (nx, ny) = (x + dir.0, y + dir.1);
            let next = (nx as u8, ny as u8);
            if !(0..TRAY as i8).contains(&nx)
                || !(0..TRAY as i8).contains(&ny)
                || TRAY_PEGS.contains(&next)
                || (other == next && !fixed[1 - i])
            {
                break;
            }
            (x, y) = (nx, ny);
            if in_mould(next) && other != next {
                fixed[i] = true;
                break;
            }
        }
        ps[i] = (x as u8, y as u8);
    }
    vec![ps[0].0, ps[0].1, ps[1].0, ps[1].1]
}

pub fn tray_full(at: &[u8]) -> bool {
    in_mould((at[0], at[1])) && in_mould((at[2], at[3]))
}

fn clues() -> String {
    let cells = |v: &[(u8, u8)]| {
        v.iter()
            .map(|(x, y)| format!("[{x},{y}]"))
            .collect::<Vec<_>>()
            .join(",")
    };
    format!(
        "{{\"ok\":true,\"times\":[{}],\"locker\":{LOCKER},\"reels\":[{}],\"tray\":{TRAY},\"pegs\":[{}],\"moulds\":[{}],\"temps\":[{}]}}",
        cells(&TIMES),
        nums_json(&REELS),
        cells(&TRAY_PEGS),
        cells(&MOULDS),
        nums_json(&TEMPS)
    )
}

const PLACED: [&str; 4] = ["placed1", "placed2", "placed3", "placed4"];

/// `tilt <n|e|s|w|reset>` (the tray), `rotate <0..3>` (a piece of the card).
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["tilt", way] => Some(if s.flag("tray_done") {
            Ok(String::new())
        } else if *way == "reset" {
            *s.val_mut("tray") = PRALINES.to_vec();
            Ok("pmsg.tray_reset".into())
        } else if let Some(dir) = crate::toyshop::direction(way) {
            let next = tilt(s.val("tray"), dir);
            let full = tray_full(&next);
            *s.val_mut("tray") = next;
            if full {
                s.set("tray_done");
                Ok("pmsg.tray_done".into())
            } else {
                Ok(String::new())
            }
        } else {
            Err(bad("tilt"))
        }),
        ["rotate", i] => Some(match i.parse::<usize>().ok().filter(|i| *i < 4) {
            None => Err(bad("rotate")),
            Some(i) if !s.flag(PLACED[i]) => Ok("pmsg.piece_missing".into()),
            Some(_) if s.flag("recipe_ok") => Ok(String::new()),
            Some(i) => {
                let v = s.val_mut("rot");
                v[i] = (v[i] + 1) % 4;
                Ok(String::new())
            }
        }),
        _ => None,
    }
}

/// Minutes for three stars (planned with the owner, 2026-11-17).
pub const PAR_MINUTES: u32 = 4;

pub static SPEC: Spec = Spec {
    id: "praline",
    prefix: "p",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_torn1",
        "locker_open",
        "got_locker",
        "cab_open",
        "got_cab",
        "tray_done",
        "got_tray",
        "placed1",
        "placed2",
        "placed3",
        "placed4",
        "recipe_ok",
        "tempered",
        "got_okey",
        "done",
    ],
    items: &["torn1", "torn2", "torn3", "torn4", "okey"],
    locks: &[
        Lock {
            name: "locker",
            size: 10,
            start: &[0, 0, 0],
            code: || {
                let (h, m) = TIMES[LOCKER];
                vec![h, m / 10, m % 10]
            },
            flag: "locker_open",
            msg: "pmsg.locker_open",
            needs: "",
        },
        Lock {
            name: "cab",
            size: 6,
            start: &[0, 0, 0, 0],
            code: || REELS.to_vec(),
            flag: "cab_open",
            msg: "pmsg.cab_open",
            needs: "",
        },
        Lock {
            name: "kettle",
            size: 10,
            start: &[2, 0, 2, 0, 2, 0],
            code: kettle_code,
            flag: "tempered",
            msg: "pmsg.tempered",
            needs: "recipe_ok",
        },
    ],
    dials: &[
        Dial {
            name: "tray",
            size: TRAY,
            start: &PRALINES,
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "rot",
            size: 4,
            start: &TORN,
            wrap: true,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "floor",
            needs: "",
            locked_msg: "",
            got: "got_torn1",
            give: &["torn1"],
            msg: "pmsg.torn1",
        },
        Pick {
            spot: "locker",
            needs: "locker_open",
            locked_msg: "pmsg.locker_locked",
            got: "got_locker",
            give: &["torn2"],
            msg: "pmsg.torn2",
        },
        Pick {
            spot: "cabinet",
            needs: "cab_open",
            locked_msg: "pmsg.cab_locked",
            got: "got_cab",
            give: &["torn3"],
            msg: "pmsg.torn3",
        },
        Pick {
            spot: "trayhatch",
            needs: "tray_done",
            locked_msg: "pmsg.trayhatch_shut",
            got: "got_tray",
            give: &["torn4"],
            msg: "pmsg.torn4",
        },
        Pick {
            spot: "conveyor",
            needs: "tempered",
            locked_msg: "pmsg.conveyor_still",
            got: "got_okey",
            give: &["okey"],
            msg: "pmsg.okey",
        },
    ],
    uses: &[
        Use {
            item: "torn1",
            spot: "recipe|piece0|piece1|piece2|piece3",
            needs: "",
            fail: "",
            keep: false,
            set: "placed1",
            give: &[],
            msg: "pmsg.piece_in",
        },
        Use {
            item: "torn2",
            spot: "recipe|piece0|piece1|piece2|piece3",
            needs: "",
            fail: "",
            keep: false,
            set: "placed2",
            give: &[],
            msg: "pmsg.piece_in",
        },
        Use {
            item: "torn3",
            spot: "recipe|piece0|piece1|piece2|piece3",
            needs: "",
            fail: "",
            keep: false,
            set: "placed3",
            give: &[],
            msg: "pmsg.piece_in",
        },
        Use {
            item: "torn4",
            spot: "recipe|piece0|piece1|piece2|piece3",
            needs: "",
            fail: "",
            keep: false,
            set: "placed4",
            give: &[],
            msg: "pmsg.piece_in",
        },
        Use {
            item: "okey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "pmsg.door_open",
        },
    ],
    checks: &[Check {
        flag: "recipe_ok",
        cond: |s| PLACED.iter().all(|p| s.flag(p)) && s.val("rot").iter().all(|r| *r == 0),
        msg: "pmsg.recipe_ok",
    }],
    looks: &[
        Look {
            spot: "kettle",
            flag: "tempered",
            set: "pmsg.kettle_done",
            unset: "pmsg.kettle",
        },
        Look {
            spot: "door",
            flag: "done",
            set: "pmsg.door_open",
            unset: "pmsg.door_locked",
        },
        Look {
            spot: "recipe",
            flag: "recipe_ok",
            set: "pmsg.recipe_read",
            unset: "pmsg.recipe_frame",
        },
    ],
    flavour: &[
        "sign", "machine", "cards", "lockers", "tiles", "lamp", "copper", "clock",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("locker_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("cab_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("tray_done"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("recipe_ok"),
            available: |s| {
                s.flag("got_torn1") && s.flag("got_locker") && s.flag("got_cab") && s.flag("got_tray")
            },
        },
        Puzzle {
            solved: |s| s.flag("tempered"),
            available: |s| s.flag("recipe_ok"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_okey"),
        },
    ],
    hint_views: &[
        ("P1", &[2, 1, 4]),
        ("P2", &[0, 1, 3, 5]),
        ("pcards", &[0]),
        ("plocker", &[0]),
        ("psign", &[1]),
        ("pcab", &[1]),
        ("ptray", &[2]),
        ("precipe", &[3]),
        ("pkettle", &[4]),
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

    /// One shortest way to fill both moulds.
    pub const TRAY_WAY: [&str; 6] = ["e", "s", "w", "s", "w", "n"];

    #[test]
    fn the_tray_takes_six_tilts() {
        let ways = ["n", "e", "s", "w"].map(|w| crate::toyshop::direction(w).unwrap());
        let mut dist = std::collections::HashMap::from([(PRALINES.to_vec(), 0)]);
        let mut todo = std::collections::VecDeque::from([PRALINES.to_vec()]);
        let mut best = None;
        while let Some(at) = todo.pop_front() {
            if tray_full(&at) {
                best = best.or(Some(dist[&at]));
                continue;
            }
            for d in ways {
                let next = tilt(&at, d);
                if !dist.contains_key(&next) {
                    dist.insert(next.clone(), dist[&at] + 1);
                    todo.push_back(next);
                }
            }
        }
        assert_eq!(best, Some(6));
    }

    #[test]
    fn the_office_can_be_reached() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap floor");
        turn_to(&mut r, "locker", &[7, 4, 5], 10);
        msg(&mut r, "tap locker");
        turn_to(&mut r, "cab", &REELS, 6);
        msg(&mut r, "tap cabinet");
        let mut last = String::new();
        for w in TRAY_WAY {
            last = msg(&mut r, &format!("tilt {w}"));
        }
        assert_eq!(last, "pmsg.tray_done");
        msg(&mut r, "tap trayhatch");
        assert_eq!(msg(&mut r, "rotate 0"), "pmsg.piece_missing");
        for (i, piece) in ["torn1", "torn2", "torn3", "torn4"].iter().enumerate() {
            msg(&mut r, &format!("use {piece} recipe"));
            for _ in 0..(4 - TORN[i]) % 4 {
                msg(&mut r, &format!("rotate {i}"));
            }
        }
        assert!(r.flag("recipe_ok"));
        turn_to(&mut r, "kettle", &kettle_code(), 10);
        msg(&mut r, "tap conveyor");
        msg(&mut r, "use okey door");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
