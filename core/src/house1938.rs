//! The Quiet House · 1938 (medium): Berta, the housekeeper, the year the
//! house is to be sold. Five puzzles. Views: `J1` (the parlour: piano, tiled
//! stove, telephone, fuse box, panelling, door) and `J2` (Clara's old room,
//! now Berta's sewing room: window onto the courtyard).
//!
//! The courtyard: the stairwell window opposite reflects the parlour when
//! its lamp is lit, as a mirror image.

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// Marie's telephone number, on her note behind the stove tile.
pub const PHONE: [u8; 4] = [3, 8, 1, 5];
/// The fuse box: kitchen, parlour, stairs, shop; more than two on blows it.
pub const FUSES_START: [u8; 4] = [1, 0, 1, 1];
pub const PARLOUR: usize = 1;
/// The parlour's six panels, left to right; the marked one.
pub const PANELS: u8 = 6;
pub const MARKED: u8 = 1;

pub static LINES: [Line; 4] = [
    Line {
        text: "jtalk.1",
        choices: &[("jsay.1a", 2), ("jsay.1b", 0), ("jsay.1c", 0)],
        sets: "",
    },
    Line {
        text: "jtalk.2",
        choices: &[("jsay.2a", 3), ("jsay.2b", 4), ("jsay.2c", 0)],
        sets: "",
    },
    Line {
        text: "jtalk.3",
        choices: &[("jsay.3a", 0), ("jsay.3b", 4)],
        sets: "",
    },
    Line {
        text: "jtalk.4",
        choices: &[("jsay.4a", 0)],
        sets: "told",
    },
];

pub fn lamp(fuses: &[u8]) -> bool {
    fuses[PARLOUR] == 1 && fuses.iter().filter(|f| **f == 1).count() <= 2
}

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"phone\":[{}],\"panels\":{PANELS},\"marked\":{MARKED},\"lines\":[{}]}}",
        nums_json(&PHONE),
        lines_json(&LINES)
    )
}

/// The conversation and `panel <0..5>`.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if let ["panel", i] = words {
        return Some(match i.parse::<u8>().ok().filter(|i| *i < PANELS) {
            None => Err(bad("panel")),
            Some(_) if s.flag("got_box") => Ok("jmsg.nothing".into()),
            Some(i) if i == MARKED && s.flag("told") && s.flag("lamp_on") => {
                s.set("got_box");
                s.give("jkey");
                Ok("jmsg.panel_open".into())
            }
            Some(_) => Ok("jmsg.panel_solid".into()),
        });
    }
    talk(s, words, &LINES, "dialled", "j")
}

/// Minutes for three stars (from tools/estimate.py, 2026-11-18).
pub const PAR_MINUTES: u32 = 8;

pub static SPEC: Spec = Spec {
    id: "house1938",
    prefix: "j",
    par_minutes: PAR_MINUTES,
    flags: &["got_note", "dialled", "told", "lamp_on", "got_box", "done"],
    items: &["jkey"],
    locks: &[Lock {
        name: "phone",
        size: 10,
        start: &[0, 0, 0, 0],
        code: || PHONE.to_vec(),
        flag: "dialled",
        msg: "jmsg.dialled",
        needs: "got_note",
    }],
    dials: &[
        Dial {
            name: "fuses",
            size: 2,
            start: &FUSES_START,
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "lamp_on",
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
    picks: &[Pick {
        spot: "tile",
        needs: "",
        locked_msg: "",
        got: "got_note",
        give: &[],
        msg: "jmsg.note",
    }],
    uses: &[Use {
        item: "jkey",
        spot: "door",
        needs: "",
        fail: "",
        keep: false,
        set: "done",
        give: &[],
        msg: "jmsg.door_open",
    }],
    checks: &[Check {
        flag: "lamp_on",
        cond: |s| lamp(s.val("fuses")),
        msg: "jmsg.lamp_on",
    }],
    looks: &[
        Look {
            spot: "lamp",
            flag: "lamp_on",
            set: "jmsg.lamp_lit",
            unset: "jmsg.lamp_dark",
        },
        Look {
            spot: "door",
            flag: "done",
            set: "jmsg.door_open",
            unset: "jmsg.door_locked",
        },
    ],
    flavour: &[
        "stove", "piano", "window", "sewing", "radio", "photo", "note", "court",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_note"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("got_note"),
        },
        Puzzle {
            solved: |s| s.flag("lamp_on"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_box"),
            available: |s| s.flag("told") && s.flag("lamp_on"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_box"),
        },
    ],
    hint_views: &[
        ("J1", &[0, 1, 2, 3, 4]),
        ("J2", &[3]),
        ("jstove", &[0]),
        ("jnote", &[1]),
        ("jphone", &[1]),
        ("jfuses", &[2]),
        ("jcourt", &[3]),
        ("jpanels", &[3]),
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
    fn berta_finds_the_music_box() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "call"), "jmsg.no_line");
        msg(&mut r, "tap tile");
        turn_to(&mut r, "phone", &PHONE, 10);
        say_all(&mut r, &[1]);
        assert_eq!(r.val("talk"), [0], "a wrong answer ends the call");
        say_all(&mut r, &[0, 0, 1]);
        assert!(r.flag("told"));
        assert_eq!(
            msg(&mut r, "panel 1"),
            "jmsg.panel_solid",
            "dark without the lamp"
        );
        msg(&mut r, "flip fuses 1");
        assert!(!r.flag("lamp_on"), "three circuits blow the fuse");
        msg(&mut r, "flip fuses 2");
        msg(&mut r, "flip fuses 3");
        assert!(r.flag("lamp_on"), "kitchen and parlour, two circuits");
        assert_eq!(
            msg(&mut r, "panel 4"),
            "jmsg.panel_solid",
            "the mirror image is a decoy"
        );
        assert_eq!(msg(&mut r, "panel 1"), "jmsg.panel_open");
        msg(&mut r, "use jkey door");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
