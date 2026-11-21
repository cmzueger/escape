//! Base 70° South (hard): a polar research station in a white-out; the
//! airlock is locked and the radio is dead. Six puzzles. Views: `R1` (radio
//! desk with its teleprinter, duty board, log book, wall map) and `R2` (the
//! frozen store with its crates, the generator, the airlock).
//!
//! The duty board: four researchers (beard, hat, glasses, scarf) on four
//! shifts (dawn, day, dusk, night); the log book's picture notes allow only
//! one rota. The crates: a sliding-block store, the red crate must come out
//! at the right. The map hides the radio's frequency in invisible ink.

use crate::kit::{no_extra, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// Each researcher's shift (beard, hat, glasses, scarf → dawn 0 .. night 3).
pub const ROTA: [u8; 4] = [2, 0, 3, 1];
/// The log book's notes: `[kind, a, b]` with kind 0 "a's shift is directly
/// before b's", 1 "a's shift is earlier than b's", 2 "a is not on shift b".
pub const NOTES: [[u8; 3]; 4] = [[0, 0, 2], [1, 1, 0], [2, 1, 1], [2, 3, 3]];
/// The teleprinter's message once the base answers: four faces. The
/// airlock's code is their shifts, counted from dawn as 1.
pub const MESSAGE: [u8; 4] = [2, 3, 0, 1];
/// The frequency in invisible ink on the map; printed grid numbers are decoys.
pub const FREQ: [u8; 3] = [7, 4, 6];
pub const PRINTED: [u8; 4] = [2, 1, 5, 8];
/// The store: 6 by 6; crates (x, y, length, lying); crate 0 is the red one,
/// it leaves at the right of its row.
pub const STORE: u8 = 6;
pub const CRATES: [(u8, u8, u8, bool); 8] = [
    (0, 2, 2, true),
    (4, 3, 2, true),
    (4, 0, 3, false),
    (2, 2, 2, false),
    (2, 5, 2, true),
    (0, 4, 2, true),
    (3, 4, 2, true),
    (1, 1, 3, true),
];

/// The duty board's wheels: which face is on each shift.
pub fn board_code() -> Vec<u8> {
    (0..4u8)
        .map(|shift| ROTA.iter().position(|s| *s == shift).unwrap() as u8)
        .collect()
}

pub fn airlock_code() -> Vec<u8> {
    MESSAGE.iter().map(|f| ROTA[usize::from(*f)] + 1).collect()
}

/// Whether a rota agrees with every note.
pub fn fits(rota: &[u8]) -> bool {
    NOTES.iter().all(|[kind, a, b]| {
        let (sa, sb) = (rota[usize::from(*a)], rota[usize::from(*b)]);
        match kind {
            0 => sb == sa + 1,
            1 => sa < sb,
            _ => sa != *b,
        }
    })
}

fn start_positions() -> Vec<u8> {
    CRATES.iter().flat_map(|(x, y, _, _)| [*x, *y]).collect()
}

fn cells(at: &[u8], i: usize) -> Vec<(u8, u8)> {
    let (_, _, len, lying) = CRATES[i];
    let (x, y) = (at[i * 2], at[i * 2 + 1]);
    (0..len)
        .map(|k| if lying { (x + k, y) } else { (x, y + k) })
        .collect()
}

/// Moves crate `i` one step; `None` when it cannot go that way.
pub fn slide(at: &[u8], i: usize, dir: (i8, i8)) -> Option<Vec<u8>> {
    let lying = CRATES[i].3;
    if (lying && dir.1 != 0) || (!lying && dir.0 != 0) {
        return None;
    }
    let mut next = at.to_vec();
    let nx = at[i * 2] as i8 + dir.0;
    let ny = at[i * 2 + 1] as i8 + dir.1;
    if nx < 0 || ny < 0 {
        return None;
    }
    next[i * 2] = nx as u8;
    next[i * 2 + 1] = ny as u8;
    let mine = cells(&next, i);
    let inside = mine.iter().all(|(x, y)| *x < STORE && *y < STORE);
    let free = (0..CRATES.len())
        .filter(|j| *j != i)
        .all(|j| cells(&next, j).iter().all(|c| !mine.contains(c)));
    (inside && free).then_some(next)
}

pub fn red_out(at: &[u8]) -> bool {
    at[0] + CRATES[0].2 == STORE
}

fn clues() -> String {
    let notes = NOTES
        .iter()
        .map(|n| format!("[{}]", nums_json(n)))
        .collect::<Vec<_>>()
        .join(",");
    let crates = CRATES
        .iter()
        .map(|(_, _, l, lying)| format!("[{l},{}]", u8::from(*lying)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"notes\":[{notes}],\"message\":[{}],\"freq\":[{}],\"printed\":[{}],\"store\":{STORE},\"crates\":[{crates}]}}",
        nums_json(&MESSAGE),
        nums_json(&FREQ),
        nums_json(&PRINTED)
    )
}

/// `crate <i>` picks a crate, `push <n|e|s|w>` moves it a step,
/// `crate reset` puts the store back as it was.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["crate", "reset"] => Some(if s.flag("crates_done") {
            Ok(String::new())
        } else {
            *s.val_mut("crates") = start_positions();
            Ok("rmsg.crates_reset".into())
        }),
        ["crate", i] => Some(
            match i.parse::<u8>().ok().filter(|i| usize::from(*i) < CRATES.len()) {
                None => Err(bad("crate")),
                Some(i) => {
                    s.val_mut("sel")[0] = i;
                    Ok(String::new())
                }
            },
        ),
        ["push", way] => Some(match crate::toyshop::direction(way) {
            None => Err(bad("push")),
            Some(_) if s.flag("crates_done") => Ok(String::new()),
            Some(dir) => {
                let i = usize::from(s.val("sel")[0]);
                match slide(s.val("crates"), i, dir) {
                    None => Ok("rmsg.crate_stuck".into()),
                    Some(next) => {
                        let out = red_out(&next);
                        *s.val_mut("crates") = next;
                        if out {
                            s.set("crates_done");
                            Ok("rmsg.crates_done".into())
                        } else {
                            Ok(String::new())
                        }
                    }
                }
            }
        }),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 16;

pub static SPEC: Spec = Spec {
    id: "polar",
    prefix: "r",
    par_minutes: PAR_MINUTES,
    flags: &[
        "board_open",
        "got_board",
        "uv_seen",
        "crates_done",
        "got_crate",
        "power",
        "printed",
        "done",
    ],
    items: &["uvlamp", "rfuse"],
    locks: &[
        Lock {
            name: "board",
            size: 4,
            start: &[0, 0, 0, 0],
            code: board_code,
            flag: "board_open",
            msg: "rmsg.board_open",
            needs: "",
        },
        Lock {
            name: "radio",
            size: 10,
            start: &[0, 0, 0],
            code: || FREQ.to_vec(),
            flag: "printed",
            msg: "rmsg.printed",
            needs: "power&uv_seen",
        },
        Lock {
            name: "airlock",
            size: 10,
            start: &[0, 0, 0, 0],
            code: airlock_code,
            flag: "done",
            msg: "rmsg.airlock_open",
            needs: "printed",
        },
    ],
    dials: &[
        Dial {
            name: "crates",
            size: STORE,
            start: &[0, 2, 4, 3, 4, 0, 2, 2, 2, 5, 0, 4, 3, 4, 1, 1],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "sel",
            size: 8,
            start: &[0],
            wrap: true,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "board",
            needs: "board_open",
            locked_msg: "rmsg.board_locked",
            got: "got_board",
            give: &["uvlamp"],
            msg: "rmsg.uvlamp",
        },
        Pick {
            spot: "redcrate",
            needs: "crates_done",
            locked_msg: "rmsg.crates_blocked",
            got: "got_crate",
            give: &["rfuse"],
            msg: "rmsg.rfuse",
        },
    ],
    uses: &[
        Use {
            item: "uvlamp",
            spot: "map",
            needs: "",
            fail: "",
            keep: false,
            set: "uv_seen",
            give: &[],
            msg: "rmsg.uv",
        },
        Use {
            item: "rfuse",
            spot: "generator",
            needs: "",
            fail: "",
            keep: false,
            set: "power",
            give: &[],
            msg: "rmsg.power",
        },
    ],
    checks: &[],
    looks: &[
        Look {
            spot: "generator",
            flag: "power",
            set: "rmsg.humming",
            unset: "rmsg.generator",
        },
        Look {
            spot: "radio",
            flag: "power",
            set: "rmsg.radio_on",
            unset: "rmsg.radio_dead",
        },
        Look {
            spot: "map",
            flag: "uv_seen",
            set: "rmsg.map_uv",
            unset: "rmsg.map",
        },
        Look {
            spot: "airlock",
            flag: "printed",
            set: "rmsg.airlock_ready",
            unset: "rmsg.airlock",
        },
    ],
    flavour: &["log", "teleprinter", "window", "bunks", "skis", "stove", "photo"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("board_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("uv_seen"),
            available: |s| s.flag("got_board"),
        },
        Puzzle {
            solved: |s| s.flag("crates_done"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("power"),
            available: |s| s.flag("got_crate"),
        },
        Puzzle {
            solved: |s| s.flag("printed"),
            available: |s| s.flag("power") && s.flag("uv_seen"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("printed"),
        },
    ],
    hint_views: &[
        ("R1", &[0, 1, 4, 5]),
        ("R2", &[2, 3, 5]),
        ("rboard", &[0]),
        ("rlog", &[0]),
        ("rmap", &[1, 4]),
        ("rradio", &[4, 5]),
        ("rcrates", &[2]),
        ("rairlock", &[5]),
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

    #[test]
    fn the_notes_allow_one_rota_and_each_is_needed() {
        let mut rotas = vec![];
        for code in 0..256u32 {
            let r: Vec<u8> = (0..4).map(|k| (code >> (2 * k) & 3) as u8).collect();
            let distinct = (0..4).all(|i| (0..4).all(|j| i == j || r[i] != r[j]));
            if distinct && fits(&r) {
                rotas.push(r);
            }
        }
        assert_eq!(rotas, vec![ROTA.to_vec()]);
        assert_eq!(board_code(), vec![1, 3, 0, 2]);
        assert_eq!(airlock_code(), vec![4, 2, 3, 1]);
    }

    /// The fewest single steps to get the red crate out.
    #[test]
    fn the_store_takes_twenty_two_steps() {
        let start = start_positions();
        let ways = ["n", "e", "s", "w"].map(|w| crate::toyshop::direction(w).unwrap());
        let mut dist = std::collections::HashMap::from([(start.clone(), 0)]);
        let mut todo = std::collections::VecDeque::from([start]);
        let mut best = None;
        while let Some(at) = todo.pop_front() {
            if red_out(&at) {
                best = Some(dist[&at]);
                break;
            }
            for i in 0..CRATES.len() {
                for d in ways {
                    if let Some(n) = slide(&at, i, d) {
                        if !dist.contains_key(&n) {
                            dist.insert(n.clone(), dist[&at] + 1);
                            todo.push_back(n);
                        }
                    }
                }
            }
        }
        assert_eq!(best, Some(22));
    }

    #[test]
    fn the_station_can_be_left() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "board", &board_code(), 4);
        msg(&mut r, "tap board");
        msg(&mut r, "use uvlamp map");
        for (i, w) in WAY {
            msg(&mut r, &format!("crate {i}"));
            msg(&mut r, &format!("push {w}"));
        }
        assert!(r.flag("crates_done"));
        msg(&mut r, "tap redcrate");
        turn_to(&mut r, "radio", &FREQ, 10);
        assert!(!r.flag("printed"), "no power yet");
        msg(&mut r, "turn radio 0 +1");
        msg(&mut r, "use rfuse generator");
        msg(&mut r, "turn radio 0 -1");
        turn_to(&mut r, "airlock", &airlock_code(), 10);
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }

    /// A shortest way out for the red crate: (crate, direction) per step.
    pub const WAY: [(u8, &str); 22] = [
        (1, "w"),
        (3, "s"),
        (4, "e"),
        (3, "s"),
        (1, "w"),
        (1, "w"),
        (1, "w"),
        (2, "s"),
        (3, "n"),
        (3, "n"),
        (4, "w"),
        (6, "w"),
        (2, "s"),
        (2, "s"),
        (7, "e"),
        (7, "e"),
        (3, "n"),
        (3, "n"),
        (0, "e"),
        (0, "e"),
        (0, "e"),
        (0, "e"),
    ];
}
