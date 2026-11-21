//! The Grandmaster's Study (hard): seven puzzles about how chess pieces
//! move; a chart in the room teaches the moves. Views: `C1` the table,
//! `C2` the library wall, `C3` the desk and the door.
//!
//! Squares are (file, rank), both from 0: a1 is (0, 0).

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

pub type Square = (i8, i8);

/// The squares a piece attacks on a board of `size`, stopping at `blockers`.
pub fn attacks(piece: char, from: Square, blockers: &[Square], size: i8) -> Vec<Square> {
    let on = |s: Square| (0..size).contains(&s.0) && (0..size).contains(&s.1);
    let rook = [(1, 0), (-1, 0), (0, 1), (0, -1)];
    let bishop = [(1, 1), (1, -1), (-1, 1), (-1, -1)];
    let mut out = Vec::new();
    let mut slide = |dirs: &[Square]| {
        for d in dirs {
            let mut s = (from.0 + d.0, from.1 + d.1);
            while on(s) {
                out.push(s);
                if blockers.contains(&s) {
                    break;
                }
                s = (s.0 + d.0, s.1 + d.1);
            }
        }
    };
    match piece {
        'R' => slide(&rook),
        'B' => slide(&bishop),
        'Q' => {
            slide(&rook);
            slide(&bishop);
        }
        'N' => {
            for d in [
                (1, 2),
                (2, 1),
                (2, -1),
                (1, -2),
                (-1, -2),
                (-2, -1),
                (-2, 1),
                (-1, 2),
            ] {
                let s = (from.0 + d.0, from.1 + d.1);
                if on(s) {
                    out.push(s);
                }
            }
        }
        _ => {}
    }
    out
}

/// The travel board on the desk: a rook, a bishop and a pawn of the same
/// colour. Exactly one empty square can be reached by both rook and bishop.
pub const TRAVEL: [(char, Square); 3] = [('R', (1, 5)), ('B', (6, 1)), ('P', (1, 6))];

pub fn meeting_square() -> Vec<Square> {
    let blockers: Vec<Square> = TRAVEL.iter().map(|(_, s)| *s).collect();
    let rook = attacks('R', TRAVEL[0].1, &blockers, 8);
    attacks('B', TRAVEL[1].1, &blockers, 8)
        .into_iter()
        .filter(|s| rook.contains(s) && !blockers.contains(s))
        .collect()
}

/// The score sheet's four squares; the bookshelf is a board of eight files
/// and three ranks, and the book on each square carries a digit.
pub const SHEET: [(char, Square); 4] = [('N', (2, 2)), ('B', (5, 0)), ('R', (0, 1)), ('Q', (7, 2))];
pub const SHELF: [[u8; 8]; 3] = [
    [3, 8, 1, 6, 0, 9, 4, 2],
    [5, 2, 7, 3, 8, 1, 6, 0],
    [9, 4, 2, 5, 1, 7, 3, 8],
];

fn safe_code() -> Vec<u8> {
    SHEET
        .iter()
        .map(|(_, (f, r))| SHELF[*r as usize][*f as usize])
        .collect()
}

/// The squares engraved on the clock; its switches want dark (1) or light (0).
pub const CLOCK_SQUARES: [Square; 5] = [(1, 3), (4, 3), (6, 0), (2, 7), (7, 4)];

pub fn shades() -> Vec<u8> {
    // a1 is dark: file plus rank even.
    CLOCK_SQUARES
        .iter()
        .map(|(f, r)| u8::from((f + r) % 2 == 0))
        .collect()
}

/// The tiled panel of the trophy cabinet: digits on five by five tiles
/// (row 0 at the top), the knight's start (column, row) and its three jumps.
pub const TILES: [[u8; 5]; 5] = [
    [4, 1, 7, 3, 9],
    [8, 6, 2, 5, 0],
    [1, 9, 4, 7, 3],
    [5, 2, 8, 0, 6],
    [7, 3, 1, 9, 4],
];
pub const KNIGHT_START: (i8, i8) = (1, 3);
pub const JUMPS: [(i8, i8); 3] = [(1, -2), (2, 1), (-1, 2)];

fn cabinet_code() -> Vec<u8> {
    let mut at = KNIGHT_START;
    let mut code = vec![TILES[at.1 as usize][at.0 as usize]];
    for j in JUMPS {
        at = (at.0 + j.0, at.1 + j.1);
        code.push(TILES[at.1 as usize][at.0 as usize]);
    }
    code
}

/// The small board of four by four with three black pieces; the white king
/// may only stand where none of them attacks.
pub const MINI: [(char, Square); 3] = [('Q', (1, 1)), ('R', (0, 2)), ('B', (3, 0))];

pub fn safe_squares() -> Vec<Square> {
    let blockers: Vec<Square> = MINI.iter().map(|(_, s)| *s).collect();
    let hit: Vec<Square> = MINI
        .iter()
        .flat_map(|(p, s)| attacks(*p, *s, &blockers, 4))
        .collect();
    (0..16)
        .map(|i| (i % 4, i / 4))
        .filter(|s| !hit.contains(s) && !blockers.contains(s))
        .collect()
}

/// The big board: the black king and the three marked squares (slots 0..2).
/// Rook, bishop and knight must all attack the king.
pub const BLACK_KING: Square = (4, 4);
pub const MARKED: [Square; 3] = [(7, 7), (2, 3), (4, 0)];
const PIECES: [(&str, char); 3] = [("rook", 'R'), ("bishop", 'B'), ("knight", 'N')];

fn all_check(slots: &[u8]) -> bool {
    slots.iter().enumerate().all(|(i, piece)| {
        *piece > 0 && attacks(PIECES[usize::from(*piece) - 1].1, MARKED[i], &[], 8).contains(&BLACK_KING)
    })
}

fn squares_json(list: &[(char, Square)]) -> String {
    list.iter()
        .map(|(p, (f, r))| format!("[\"{p}\",{f},{r}]"))
        .collect::<Vec<_>>()
        .join(",")
}

fn clues() -> String {
    let rows = |grid: &[&[u8]]| {
        grid.iter()
            .map(|r| format!("[{}]", nums_json(r)))
            .collect::<Vec<_>>()
            .join(",")
    };
    let pairs = |list: &[Square]| {
        list.iter()
            .map(|(a, b)| format!("[{a},{b}]"))
            .collect::<Vec<_>>()
            .join(",")
    };
    format!(
        "{{\"ok\":true,\"travel\":[{}],\"sheet\":[{}],\"shelf\":[{}],\"clock_squares\":[{}],\"tiles\":[{}],\"knight_start\":[{},{}],\"jumps\":[{}],\"mini\":[{}],\"black_king\":[{},{}],\"marked\":[{}],\"king_home\":[{},{}]}}",
        squares_json(&TRAVEL),
        squares_json(&SHEET),
        rows(&SHELF.iter().map(|r| &r[..]).collect::<Vec<_>>()),
        pairs(&CLOCK_SQUARES),
        rows(&TILES.iter().map(|r| &r[..]).collect::<Vec<_>>()),
        KNIGHT_START.0,
        KNIGHT_START.1,
        pairs(&JUMPS),
        squares_json(&MINI),
        BLACK_KING.0,
        BLACK_KING.1,
        pairs(&MARKED),
        safe_squares()[0].0,
        safe_squares()[0].1
    )
}

fn extra(s: &State) -> String {
    format!(",\"checks\":{}", all_check(s.val("slots")))
}

/// `king <file> <rank>`: sets the white king on the small board.
/// `use <rook|bishop|knight> sq<0..2>` and `tap sq<0..2>`: a piece onto a
/// marked square of the big board, or off it again.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let slot = |w: Option<&&str>| {
        w.and_then(|w| w.strip_prefix("sq"))
            .and_then(|n| n.parse::<usize>().ok())
            .filter(|i| *i < 3)
    };
    match words {
        ["king", file, rank] => Some(match (file.parse::<i8>(), rank.parse::<i8>()) {
            (Ok(f), Ok(r)) if (0..4).contains(&f) && (0..4).contains(&r) => {
                if s.flag("king_safe") {
                    Ok(String::new())
                } else if !s.has("wking") {
                    Ok("cmsg.mini".into())
                } else if safe_squares().contains(&(f, r)) {
                    s.take("wking");
                    s.set("king_safe");
                    Ok("cmsg.king_safe".into())
                } else {
                    Ok("cmsg.king_attacked".into())
                }
            }
            _ => Err(bad("king")),
        }),
        ["use", piece, _] if slot(words.get(2)).is_some() => {
            let i = slot(words.get(2))?;
            let which = PIECES.iter().position(|(name, _)| name == piece)?;
            if !s.has(piece) {
                return None;
            }
            Some(Ok(if s.flag("king_down") {
                String::new()
            } else if s.val("slots")[i] != 0 {
                "cmsg.square_taken".into()
            } else {
                s.take(piece);
                s.val_mut("slots")[i] = which as u8 + 1;
                "cmsg.piece_on".into()
            }))
        }
        ["tap", _] if slot(words.get(1)).is_some() => {
            let i = slot(words.get(1))?;
            let piece = s.val("slots")[i];
            Some(Ok(if s.flag("king_down") || piece == 0 {
                "cmsg.marked".into()
            } else {
                s.give(PIECES[usize::from(piece) - 1].0);
                s.val_mut("slots")[i] = 0;
                "cmsg.piece_off".into()
            }))
        }
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 21;

pub static SPEC: Spec = Spec {
    id: "chess",
    prefix: "c",
    par_minutes: PAR_MINUTES,
    flags: &[
        "drawer_open",
        "got_drawer",
        "safe_open",
        "got_safe",
        "clock_open",
        "got_clock",
        "cab_open",
        "got_cab",
        "king_safe",
        "got_key1",
        "king_down",
        "got_key2",
        "k1_in",
        "k2_in",
        "done",
    ],
    items: &["rook", "bishop", "knight", "wking", "key1", "key2"],
    locks: &[
        Lock {
            name: "drawer",
            size: 8,
            start: &[0, 0],
            code: || {
                let m = meeting_square()[0];
                vec![m.0 as u8, m.1 as u8]
            },
            flag: "drawer_open",
            msg: "cmsg.drawer_open",
            needs: "",
        },
        Lock {
            name: "safe",
            size: 10,
            start: &[0, 0, 0, 0],
            code: safe_code,
            flag: "safe_open",
            msg: "cmsg.safe_open",
            needs: "got_drawer",
        },
        Lock {
            name: "cabinet",
            size: 10,
            start: &[0, 0, 0, 0],
            code: cabinet_code,
            flag: "cab_open",
            msg: "cmsg.cab_open",
            needs: "",
        },
    ],
    dials: &[
        Dial {
            name: "shades",
            size: 2,
            start: &[0, 0, 0, 0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "clock_open",
        },
        Dial {
            name: "slots",
            size: 4,
            start: &[0, 0, 0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "drawer",
            needs: "drawer_open",
            locked_msg: "cmsg.drawer_locked",
            got: "got_drawer",
            give: &["rook"],
            msg: "cmsg.drawer_take",
        },
        Pick {
            spot: "safe",
            needs: "safe_open",
            locked_msg: "cmsg.safe_locked",
            got: "got_safe",
            give: &["bishop"],
            msg: "cmsg.safe_take",
        },
        Pick {
            spot: "clock",
            needs: "clock_open",
            locked_msg: "cmsg.clock_shut",
            got: "got_clock",
            give: &["knight"],
            msg: "cmsg.clock_take",
        },
        Pick {
            spot: "cabinet",
            needs: "cab_open",
            locked_msg: "cmsg.cab_locked",
            got: "got_cab",
            give: &["wking"],
            msg: "cmsg.cab_take",
        },
        Pick {
            spot: "minidrawer",
            needs: "king_safe",
            locked_msg: "cmsg.mini_shut",
            got: "got_key1",
            give: &["key1"],
            msg: "cmsg.key1",
        },
        Pick {
            spot: "kingbase",
            needs: "king_down",
            locked_msg: "cmsg.king_stands",
            got: "got_key2",
            give: &["key2"],
            msg: "cmsg.key2",
        },
    ],
    uses: &[
        Use {
            item: "key1",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "k1_in",
            give: &[],
            msg: "cmsg.key_in",
        },
        Use {
            item: "key2",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "k2_in",
            give: &[],
            msg: "cmsg.key_in",
        },
    ],
    checks: &[
        Check {
            flag: "clock_open",
            cond: |s| s.val("shades") == shades(),
            msg: "cmsg.clock_open",
        },
        Check {
            flag: "king_down",
            cond: |s| all_check(s.val("slots")),
            msg: "cmsg.king_down",
        },
        Check {
            flag: "done",
            cond: |s| s.flag("k1_in") && s.flag("k2_in"),
            msg: "cmsg.door_open",
        },
    ],
    looks: &[Look {
        spot: "door",
        flag: "k1_in",
        set: "cmsg.door_one",
        unset: "cmsg.door_locked",
    }],
    flavour: &[
        "chart", "portrait", "fire", "books", "lamp", "armchair", "trophies", "travel",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("drawer_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("safe_open"),
            available: |s| s.flag("got_drawer"),
        },
        Puzzle {
            solved: |s| s.flag("clock_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("cab_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("king_safe"),
            available: |s| s.flag("got_cab"),
        },
        Puzzle {
            solved: |s| s.flag("king_down"),
            available: |s| s.flag("got_drawer"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_key1") || s.flag("got_key2"),
        },
    ],
    hint_views: &[
        ("C1", &[5, 2, 4]),
        ("C2", &[1, 3]),
        ("C3", &[0, 6]),
        ("travel", &[0]),
        ("cdrawer", &[0]),
        ("csheet", &[1]),
        ("shelf", &[1]),
        ("csafe", &[1]),
        ("cclock", &[2]),
        ("tiles", &[3]),
        ("mini", &[4]),
        ("bigboard", &[5]),
        ("chart", &[0, 5, 4]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    #[test]
    fn every_chess_puzzle_has_one_answer() {
        assert_eq!(meeting_square(), [(2, 5)]);
        assert_eq!(safe_squares(), [(2, 3)]);
        assert_eq!(shades(), [1, 0, 1, 0, 0]);
        assert_eq!(safe_code(), [2, 9, 5, 8]);
        assert_eq!(cabinet_code(), [2, 2, 3, 9]);
        // Only one way to put rook, bishop and knight on the marked squares.
        let mut ways = Vec::new();
        for a in 1..=3u8 {
            for b in 1..=3u8 {
                for c in 1..=3u8 {
                    if a != b && b != c && a != c && all_check(&[a, b, c]) {
                        ways.push([a, b, c]);
                    }
                }
            }
        }
        assert_eq!(ways, [[2, 3, 1]]);
        // The knight's jumps stay on the tiles.
        let mut at = KNIGHT_START;
        for j in JUMPS {
            at = (at.0 + j.0, at.1 + j.1);
            assert!((0..5).contains(&at.0) && (0..5).contains(&at.1));
        }
    }

    #[test]
    fn the_study_can_be_left() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "drawer", &[2, 5], 8);
        assert_eq!(msg(&mut r, "tap drawer"), "cmsg.drawer_take");
        turn_to(&mut r, "safe", &safe_code(), 10);
        msg(&mut r, "tap safe");
        msg(&mut r, "flip shades 0");
        assert_eq!(msg(&mut r, "flip shades 2"), "cmsg.clock_open");
        msg(&mut r, "tap clock");
        turn_to(&mut r, "cabinet", &cabinet_code(), 10);
        assert_eq!(msg(&mut r, "king 2 3"), "cmsg.mini");
        msg(&mut r, "tap cabinet");
        assert_eq!(msg(&mut r, "king 3 3"), "cmsg.king_attacked");
        assert_eq!(msg(&mut r, "king 2 3"), "cmsg.king_safe");
        assert_eq!(msg(&mut r, "tap minidrawer"), "cmsg.key1");
        assert_eq!(msg(&mut r, "use rook sq0"), "cmsg.piece_on");
        assert_eq!(msg(&mut r, "use bishop sq0"), "cmsg.square_taken");
        assert_eq!(msg(&mut r, "tap sq0"), "cmsg.piece_off");
        msg(&mut r, "use bishop sq0");
        msg(&mut r, "use knight sq1");
        assert_eq!(msg(&mut r, "tap kingbase"), "cmsg.king_stands");
        assert_eq!(msg(&mut r, "use rook sq2"), "cmsg.king_down");
        msg(&mut r, "tap kingbase");
        assert_eq!(msg(&mut r, "use key1 door"), "cmsg.key_in");
        assert_eq!(msg(&mut r, "use key2 door"), "cmsg.door_open");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
