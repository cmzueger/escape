//! Lookout (medium): a kids' club treehouse in autumn; the hatch in the floor
//! is locked with the club's padlock. Five puzzles. Views: `E1` (hatch, club
//! chest, dartboard, periscope) and `E2` (signal lamp, mirror board, map).
//!
//! The mirror board: the lamp shines in from the left; each mirror is turned
//! between `/` and `\`. The beam must reach the glass marble of the club's
//! "alarm", which then springs the secret drawer.

use crate::kit::{no_hook, Check, Dial, Lock, Look, Pick, Puzzle, Spec, State, Use};
use crate::nums_json;

/// The three darts, in the chest wheels' colours (red, yellow, blue): the
/// numbers of the segments they are in.
pub const DARTS: [u8; 3] = [7, 3, 9];
/// The mirror board: columns, rows, the lamp's row (it shines in from the
/// left), the mirrors' cells, and the marble's cell.
pub const GRID: (u8, u8) = (6, 4);
pub const LAMP_ROW: u8 = 1;
pub const MIRRORS: [(u8, u8); 4] = [(2, 1), (2, 3), (5, 3), (5, 0)];
pub const MARBLE: (u8, u8) = (1, 0);
/// The periscope's eight directions; the friends' treehouse (beside the
/// big pine, with the club's orange flag) is in `FRIENDS`, and its board
/// shows dice. Another treehouse (small pine, blue flag) shows other dice.
pub const FRIENDS: u8 = 2;
pub const DICE: [u8; 4] = [5, 2, 6, 4];
pub const DECOY_DIR: u8 = 5;
pub const DECOY: [u8; 4] = [1, 4, 4, 2];

/// The beam's cells from the lamp, and whether it reaches the marble.
/// Mirror 0 is `/`, 1 is `\`.
pub fn beam(mirrors: &[u8]) -> (Vec<(u8, u8)>, bool) {
    let (mut x, mut y) = (0i8, LAMP_ROW as i8);
    let (mut dx, mut dy) = (1i8, 0i8);
    let mut path = Vec::new();
    while (0..GRID.0 as i8).contains(&x) && (0..GRID.1 as i8).contains(&y) && path.len() < 64 {
        let cell = (x as u8, y as u8);
        path.push(cell);
        if cell == MARBLE {
            return (path, true);
        }
        if let Some(i) = MIRRORS.iter().position(|m| *m == cell) {
            (dx, dy) = if mirrors[i] == 0 { (-dy, -dx) } else { (dy, dx) };
        }
        x += dx;
        y += dy;
    }
    (path, false)
}

fn clues() -> String {
    let cells = |v: &[(u8, u8)]| {
        v.iter()
            .map(|(x, y)| format!("[{x},{y}]"))
            .collect::<Vec<_>>()
            .join(",")
    };
    format!(
        "{{\"ok\":true,\"darts\":[{}],\"grid\":[{},{}],\"lamp_row\":{LAMP_ROW},\"mirrors\":[{}],\"marble\":[{},{}],\"friends\":{FRIENDS},\"dice\":[{}],\"decoy_dir\":{DECOY_DIR},\"decoy\":[{}]}}",
        nums_json(&DARTS),
        GRID.0,
        GRID.1,
        cells(&MIRRORS),
        MARBLE.0,
        MARBLE.1,
        nums_json(&DICE),
        nums_json(&DECOY)
    )
}

/// The beam for the client: `,"beam":[[x,y],…],"hit":true`.
fn extra(s: &State) -> String {
    let (path, hit) = beam(s.val("mirrors"));
    let cells = path
        .iter()
        .map(|(x, y)| format!("[{x},{y}]"))
        .collect::<Vec<_>>()
        .join(",");
    format!(",\"beam\":[{cells}],\"hit\":{hit}")
}

/// Minutes for three stars (planned with the owner, 2026-11-17).
pub const PAR_MINUTES: u32 = 3;

pub static SPEC: Spec = Spec {
    id: "tree",
    prefix: "e",
    par_minutes: PAR_MINUTES,
    flags: &[
        "chest_open",
        "got_chest",
        "lamp_on",
        "beam_ok",
        "got_knob",
        "knob_on",
        "done",
    ],
    items: &["battery", "knob"],
    locks: &[
        Lock {
            name: "chest",
            size: 10,
            start: &[0, 0, 0],
            code: || DARTS.to_vec(),
            flag: "chest_open",
            msg: "emsg.chest_open",
            needs: "",
        },
        Lock {
            name: "hatch",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || DICE.to_vec(),
            flag: "done",
            msg: "emsg.hatch_open",
            needs: "knob_on",
        },
    ],
    dials: &[
        Dial {
            name: "mirrors",
            size: 2,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "beam_ok",
        },
        Dial {
            name: "peri",
            size: 8,
            start: &[6],
            wrap: true,
            needs: "knob_on",
            needs_msg: "emsg.peri_stuck",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "chest",
            needs: "chest_open",
            locked_msg: "emsg.chest_locked",
            got: "got_chest",
            give: &["battery"],
            msg: "emsg.battery",
        },
        Pick {
            spot: "alarm",
            needs: "beam_ok",
            locked_msg: "emsg.alarm",
            got: "got_knob",
            give: &["knob"],
            msg: "emsg.knob",
        },
    ],
    uses: &[
        Use {
            item: "battery",
            spot: "lamp",
            needs: "",
            fail: "",
            keep: false,
            set: "lamp_on",
            give: &[],
            msg: "emsg.lamp_on",
        },
        Use {
            item: "knob",
            spot: "periscope",
            needs: "",
            fail: "",
            keep: false,
            set: "knob_on",
            give: &[],
            msg: "emsg.knob_on",
        },
    ],
    checks: &[Check {
        flag: "beam_ok",
        cond: |s| s.flag("lamp_on") && beam(s.val("mirrors")).1,
        msg: "emsg.beam_ok",
    }],
    looks: &[
        Look {
            spot: "lamp",
            flag: "lamp_on",
            set: "emsg.lamp_lit",
            unset: "emsg.lamp_dark",
        },
        Look {
            spot: "periscope",
            flag: "knob_on",
            set: "emsg.peri_turn",
            unset: "emsg.peri_stuck",
        },
        Look {
            spot: "hatch",
            flag: "done",
            set: "emsg.hatch_open",
            unset: "emsg.hatch_locked",
        },
    ],
    flavour: &["window", "comics", "flag", "leaves", "blanket", "map", "darts"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("chest_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lamp_on"),
            available: |s| s.flag("got_chest"),
        },
        Puzzle {
            solved: |s| s.flag("beam_ok"),
            available: |s| s.flag("lamp_on"),
        },
        Puzzle {
            solved: |s| s.flag("knob_on"),
            available: |s| s.flag("got_knob"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("knob_on"),
        },
    ],
    hint_views: &[
        ("E1", &[0, 3, 4]),
        ("E2", &[1, 2]),
        ("edarts", &[0]),
        ("echest", &[0]),
        ("ebeam", &[2, 1]),
        ("eperi", &[3, 4]),
        ("emap", &[4]),
        ("ehatch", &[4]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook: no_hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::{msg, turn_to};

    #[test]
    fn one_mirror_setting_reaches_the_marble() {
        let hits: Vec<u8> = (0..16u8)
            .filter(|m| beam(&[m & 1, (m >> 1) & 1, (m >> 2) & 1, (m >> 3) & 1]).1)
            .collect();
        assert_eq!(hits, vec![0b1011]);
        assert!(!beam(&[0, 0, 0, 0]).1, "the start is not solved");
    }

    #[test]
    fn the_treehouse_can_be_left() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "chest", &DARTS, 10);
        msg(&mut r, "tap chest");
        assert_eq!(msg(&mut r, "turn peri 0 +1"), "emsg.peri_stuck");
        turn_to(&mut r, "mirrors", &[1, 1, 0, 1], 2);
        assert!(!r.flag("beam_ok"), "no beam without the lamp");
        msg(&mut r, "turn mirrors 0 +1");
        msg(&mut r, "use battery lamp");
        assert_eq!(msg(&mut r, "turn mirrors 0 -1"), "emsg.beam_ok");
        assert!(r.call("state").contains("\"hit\":true"));
        msg(&mut r, "tap alarm");
        msg(&mut r, "use knob periscope");
        turn_to(&mut r, "peri", &[FRIENDS], 8);
        turn_to(&mut r, "hatch", &DICE, 10);
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
