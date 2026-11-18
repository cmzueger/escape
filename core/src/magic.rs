//! The Great Vaudini (medium): an illusionist's dressing room in 1925, the
//! apprentice's test. Eight puzzles. Views: `F1` (the dressing room: mirror
//! with bulbs, costume rack, trunk, the Cabinet of Wonders, poster, dressing
//! table) and `F2` (the wings: Pepper's ghost glass, the alcove's lamp
//! switch, the sawing box, the chained stage door).
//!
//! The alcove lies between the two rooms: its lamp makes the dressing
//! mirror see-through and lights the ghost in the wings' glass.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// The cabinet's panels: crown, moon, star, sun, key, eye.
pub const PANELS: u8 = 6;
/// The incantation's order (the star is never named).
pub const ORDER: [u8; 5] = [0, 1, 4, 3, 5];
/// The deck: eight faces, and the corner of each card's dot (0 none, 1 top
/// left, 2 top right, 3 bottom right, 4 bottom left).
pub const FACES: [u8; 8] = [3, 7, 9, 2, 5, 1, 8, 4];
pub const DOTS: [u8; 8] = [0, 2, 0, 1, 3, 0, 4, 0];
/// Pepper's ghost: the number in the backdrop's windows at each of the
/// handle's five positions (10, 11, 12, 1 and 2 o'clock); the poster's
/// clock shows 1 o'clock.
pub const GHOST: [[u8; 3]; 5] = [[9, 1, 6], [2, 4, 7], [7, 0, 2], [5, 8, 3], [3, 6, 1]];
pub const TILT: u8 = 3;
/// The sawing box's three parts, as the sketch in the alcove shows them.
pub const SAW: [u8; 3] = [2, 0, 3];

/// The padlock's code: the faces of the dotted cards, corner by corner.
pub fn deck_code() -> Vec<u8> {
    (1..=4)
        .map(|corner| FACES[DOTS.iter().position(|d| *d == corner).unwrap()])
        .collect()
}

fn clues() -> String {
    let ghost = GHOST
        .iter()
        .map(|g| format!("[{}]", nums_json(g)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"faces\":[{}],\"dots\":[{}],\"ghost\":[{ghost}],\"tilt\":{TILT},\"saw\":[{}]}}",
        nums_json(&FACES),
        nums_json(&DOTS),
        nums_json(&SAW)
    )
}

/// The cabinet: `panel <0..5>`; a wrong panel starts the incantation over.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let ["panel", p] = words {
        return Some(match p.parse::<u8>().ok().filter(|p| *p < PANELS) {
            None => Err(bad("panel")),
            Some(_) if s.flag("cabinet_open") => Ok("vmsg.cabinet_inside".into()),
            Some(_) if !s.flag("trunk_open") => Ok("vmsg.panel".into()),
            Some(p) => {
                let at = s.val("seq")[0] as usize;
                let next = if ORDER[at] == p {
                    at + 1
                } else if ORDER[0] == p {
                    1
                } else {
                    0
                };
                s.val_mut("seq")[0] = next as u8;
                if next == ORDER.len() {
                    s.set("cabinet_open");
                    s.give("vdeck");
                    Ok("vmsg.cabinet_open".into())
                } else if next == 0 {
                    Ok("vmsg.panel_back".into())
                } else {
                    Ok("vmsg.panel_click".into())
                }
            }
        });
    }
    None
}

/// Minutes for three stars (from tools/estimate.py, 2026-11-18).
pub const PAR_MINUTES: u32 = 14;

pub static SPEC: Spec = Spec {
    id: "magic",
    prefix: "v",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_vkey",
        "trunk_open",
        "cabinet_open",
        "spread",
        "pad1",
        "seen_sketch",
        "seen_ghost",
        "pad2",
        "saw_ok",
        "got_rabbit",
        "done",
    ],
    items: &["vkey", "vdeck", "vpadkey"],
    locks: &[
        Lock {
            name: "pad1",
            size: 10,
            start: &[0, 0, 0, 0],
            code: deck_code,
            flag: "pad1",
            msg: "vmsg.pad_open",
            needs: "spread&trunk_open",
        },
        Lock {
            name: "pad2",
            size: 10,
            start: &[0, 0, 0],
            code: || GHOST[TILT as usize].to_vec(),
            flag: "pad2",
            msg: "vmsg.pad_open",
            needs: "seen_ghost",
        },
    ],
    dials: &[
        Dial {
            name: "seq",
            size: 6,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "cards",
            size: 2,
            start: &[0; 8],
            wrap: true,
            needs: "spread",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "bulbs",
            size: 2,
            start: &[1],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "lamp",
            size: 2,
            start: &[0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "tilt",
            size: 5,
            start: &[0],
            wrap: false,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "saw",
            size: 4,
            start: &[0, 0, 0],
            wrap: true,
            needs: "seen_sketch",
            needs_msg: "vmsg.saw_stuck",
            freeze: "saw_ok",
        },
    ],
    picks: &[
        Pick {
            spot: "lining",
            needs: "",
            locked_msg: "",
            got: "got_vkey",
            give: &["vkey"],
            msg: "vmsg.vkey",
        },
        Pick {
            spot: "rabbit",
            needs: "saw_ok",
            locked_msg: "vmsg.box_shut",
            got: "got_rabbit",
            give: &["vpadkey"],
            msg: "vmsg.rabbit",
        },
    ],
    uses: &[
        Use {
            item: "vkey",
            spot: "trunk",
            needs: "",
            fail: "",
            keep: false,
            set: "trunk_open",
            give: &[],
            msg: "vmsg.trunk_open",
        },
        Use {
            item: "vdeck",
            spot: "table",
            needs: "",
            fail: "",
            keep: false,
            set: "spread",
            give: &[],
            msg: "vmsg.spread",
        },
        Use {
            item: "vpadkey",
            spot: "chain",
            needs: "pad1&pad2",
            fail: "vmsg.chain_holds",
            keep: false,
            set: "done",
            give: &[],
            msg: "vmsg.chain_falls",
        },
    ],
    checks: &[
        Check {
            flag: "seen_sketch",
            cond: |s| s.val("bulbs")[0] == 0 && s.val("lamp")[0] == 1,
            msg: "",
        },
        Check {
            flag: "seen_ghost",
            cond: |s| s.val("lamp")[0] == 1 && s.val("tilt")[0] == TILT,
            msg: "",
        },
        Check {
            flag: "saw_ok",
            cond: |s| s.flag("seen_sketch") && s.val("saw") == SAW,
            msg: "vmsg.saw_ok",
        },
    ],
    looks: &[
        Look {
            spot: "trunk",
            flag: "trunk_open",
            set: "vmsg.trunk_inside",
            unset: "vmsg.trunk_locked",
        },
        Look {
            spot: "table",
            flag: "spread",
            set: "vmsg.cards",
            unset: "vmsg.table",
        },
    ],
    flavour: &[
        "poster", "costume", "script", "letter", "mirror", "glass", "backdrop", "bell", "chain", "cabinet",
        "box",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_vkey"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("trunk_open"),
            available: |s| s.flag("got_vkey"),
        },
        Puzzle {
            solved: |s| s.flag("cabinet_open"),
            available: |s| s.flag("trunk_open"),
        },
        Puzzle {
            solved: |s| s.flag("pad1"),
            available: |s| s.flag("spread&trunk_open"),
        },
        Puzzle {
            solved: |s| s.flag("seen_sketch"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("pad2"),
            available: |s| s.flag("seen_ghost"),
        },
        Puzzle {
            solved: |s| s.flag("saw_ok"),
            available: |s| s.flag("seen_sketch"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("pad1&pad2&got_rabbit"),
        },
    ],
    hint_views: &[
        ("F1", &[0, 1, 2, 3, 4]),
        ("F2", &[4, 5, 6, 7]),
        ("frack", &[0]),
        ("ftrunk", &[1, 2, 3]),
        ("fscript", &[2]),
        ("fletter", &[3]),
        ("fcabinet", &[2]),
        ("ftable", &[3]),
        ("fmirror", &[4, 6]),
        ("fposter", &[5]),
        ("fglass", &[5]),
        ("fswitch", &[4, 5]),
        ("fbox", &[6]),
        ("fdoor", &[3, 5, 7]),
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
    fn the_apprentice_passes() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap lining");
        assert_eq!(
            msg(&mut r, "panel 0"),
            "vmsg.panel",
            "the cabinet waits for the script"
        );
        msg(&mut r, "use vkey trunk");
        msg(&mut r, "panel 0");
        msg(&mut r, "panel 1");
        assert_eq!(
            msg(&mut r, "panel 2"),
            "vmsg.panel_back",
            "the star is never named"
        );
        for p in ORDER {
            msg(&mut r, &format!("panel {p}"));
        }
        assert!(r.flag("cabinet_open"));
        msg(&mut r, "use vdeck table");
        assert_eq!(deck_code(), vec![2, 7, 5, 8]);
        turn_to(&mut r, "pad1", &deck_code(), 10);
        assert!(r.flag("pad1"));
        msg(&mut r, "flip lamp 0");
        assert!(
            !r.flag("seen_sketch"),
            "the mirror only shows itself while its bulbs burn"
        );
        msg(&mut r, "flip bulbs 0");
        assert!(r.flag("seen_sketch"));
        turn_to(&mut r, "pad2", &GHOST[0], 10);
        assert!(!r.flag("pad2"), "another angle, another number");
        for _ in 0..TILT {
            msg(&mut r, "turn tilt 0 +1");
        }
        turn_to(&mut r, "pad2", &GHOST[TILT as usize], 10);
        assert!(r.flag("pad2"));
        assert_eq!(msg(&mut r, "tap rabbit"), "vmsg.box_shut");
        turn_to(&mut r, "saw", &SAW, 4);
        msg(&mut r, "tap rabbit");
        msg(&mut r, "use vpadkey chain");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
