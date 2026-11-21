//! Rain on Gale Street (hard): a detective's office in 1947, locked from
//! outside by someone who wants a case closed. Eight puzzles. Views: `I1`
//! (the office: desk with lamp, pad and typewriter, filing cabinet, safe,
//! case board, window with blinds and a red neon sign outside) and `I2`
//! (the reception: coat stand, radio, tram timetable, the door with its
//! frosted glass).
//!
//! Red light hides red ink; the door's glass reads backwards from inside.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The numbers on the pad, scribbled over in red.
pub const PAD: [u8; 4] = [6, 0, 4, 7];
/// The street number (police band) and its mirror image.
pub const BAND: [u8; 2] = [4, 7];
/// The three coats (0 pink carnation, 1 red carnation, 2 none).
pub const COAT: usize = 1;
/// The minute she left the hotel: 22:58.
pub const LEFT: [u8; 4] = [2, 2, 5, 8];
/// The tram: last departure from the depot (minutes after midnight) and
/// the minutes to each stop; the Ambassador is the fourth.
pub const DEPOT: u32 = 22 * 60 + 41;
pub const STOPS: [u32; 6] = [4, 9, 12, 17, 21, 26];
pub const HOTEL_STOP: usize = 3;

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"pad\":[{}],\"band\":[{}],\"depot\":{DEPOT},\"stops\":[{}],\"hotel\":{HOTEL_STOP}}}",
        nums_json(&PAD),
        nums_json(&BAND),
        nums_json(&STOPS.map(|m| m as u8))
    )
}

/// Holding the carbon paper or the ribbon against the desk lamp.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let (item, flag, msg) = match words {
        ["use", "icarbon", "lamp"] => ("icarbon", "carbon_read", "imsg.carbon_read"),
        ["use", "iribbon", "lamp"] => ("iribbon", "ribbon_read", "imsg.ribbon_read"),
        _ => return None,
    };
    if !s.has(item) {
        return None;
    }
    Some(Ok(if s.val("lamp")[0] == 0 {
        "imsg.lamp_off".into()
    } else {
        s.set(flag);
        if item == "iribbon" {
            s.take(item);
        }
        msg.into()
    }))
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 23;

pub static SPEC: Spec = Spec {
    id: "noir",
    prefix: "i",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_carbon",
        "carbon_read",
        "pad_read",
        "cabinet_open",
        "got_ribbon",
        "ribbon_read",
        "got_statement",
        "radio_on",
        "safe_open",
        "got_opener",
        "sheet_under",
        "key_pushed",
        "got_doorkey",
        "done",
    ],
    items: &["icarbon", "iribbon", "iopener", "idoorkey"],
    locks: &[
        Lock {
            name: "cabinet",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || PAD.to_vec(),
            flag: "cabinet_open",
            msg: "imsg.cabinet_open",
            needs: "carbon_read&pad_read",
        },
        Lock {
            name: "radio",
            size: 10,
            start: &[0, 0],
            code: || BAND.to_vec(),
            flag: "radio_on",
            msg: "imsg.bulletin",
            needs: "",
        },
        Lock {
            name: "safe",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || LEFT.to_vec(),
            flag: "safe_open",
            msg: "imsg.safe_open",
            needs: "cabinet_open&got_statement&radio_on",
        },
    ],
    dials: &[
        Dial {
            name: "lamp",
            size: 2,
            start: &[1],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "blinds",
            size: 3,
            start: &[0],
            wrap: false,
            needs: "",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "carbon",
            needs: "",
            locked_msg: "",
            got: "got_carbon",
            give: &["icarbon"],
            msg: "imsg.carbon",
        },
        Pick {
            spot: "ribbon",
            needs: "",
            locked_msg: "",
            got: "got_ribbon",
            give: &["iribbon"],
            msg: "imsg.ribbon",
        },
        Pick {
            spot: "coat1",
            needs: "ribbon_read",
            locked_msg: "imsg.coat",
            got: "got_statement",
            give: &[],
            msg: "imsg.statement",
        },
        Pick {
            spot: "opener",
            needs: "safe_open",
            locked_msg: "imsg.safe_shut",
            got: "got_opener",
            give: &["iopener"],
            msg: "imsg.opener",
        },
        Pick {
            spot: "sheet",
            needs: "key_pushed",
            locked_msg: "imsg.sheet_empty",
            got: "got_doorkey",
            give: &["idoorkey"],
            msg: "imsg.doorkey",
        },
    ],
    uses: &[
        Use {
            item: "icarbon",
            spot: "door",
            needs: "carbon_read",
            fail: "imsg.carbon_keep",
            keep: false,
            set: "sheet_under",
            give: &[],
            msg: "imsg.sheet_under",
        },
        Use {
            item: "iopener",
            spot: "keyhole",
            needs: "sheet_under",
            fail: "imsg.no_sheet",
            keep: false,
            set: "key_pushed",
            give: &[],
            msg: "imsg.key_drops",
        },
        Use {
            item: "idoorkey",
            spot: "door|keyhole",
            needs: "",
            fail: "",
            keep: false,
            set: "done",
            give: &[],
            msg: "imsg.door_open",
        },
    ],
    checks: &[Check {
        flag: "pad_read",
        cond: |s| s.val("lamp")[0] == 0 && s.val("blinds")[0] == 2,
        msg: "",
    }],
    looks: &[
        Look {
            spot: "cabinet",
            flag: "cabinet_open",
            set: "imsg.file",
            unset: "imsg.cabinet_locked",
        },
        Look {
            spot: "radio",
            flag: "radio_on",
            set: "imsg.bulletin",
            unset: "imsg.radio",
        },
    ],
    flavour: &[
        "pad",
        "board",
        "timetable",
        "glass",
        "coat0",
        "coat2",
        "typewriter",
        "window",
        "neon",
        "ruby",
        "bin",
        "lamp",
        "safe",
        "phone",
        "readings",
        "note",
        "keyhole",
        "door",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_carbon"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("carbon_read"),
            available: |s| s.flag("got_carbon"),
        },
        Puzzle {
            solved: |s| s.flag("cabinet_open"),
            available: |s| s.flag("carbon_read"),
        },
        Puzzle {
            solved: |s| s.flag("ribbon_read"),
            available: |s| s.flag("got_ribbon"),
        },
        Puzzle {
            solved: |s| s.flag("got_statement"),
            available: |s| s.flag("ribbon_read"),
        },
        Puzzle {
            solved: |s| s.flag("radio_on"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("safe_open"),
            available: |s| s.flag("cabinet_open&got_statement&radio_on"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_opener&got_carbon"),
        },
    ],
    hint_views: &[
        ("I1", &[0, 1, 2, 3, 6]),
        ("I2", &[4, 5, 6, 7]),
        ("ibin", &[0]),
        ("idesk", &[1, 2, 3]),
        ("iblinds", &[2]),
        ("icabinet", &[2, 6]),
        ("itype", &[3]),
        ("icoats", &[4]),
        ("iradio", &[5]),
        ("iglass", &[5]),
        ("itimetable", &[6]),
        ("iboard", &[6]),
        ("isafe", &[6]),
        ("idoor", &[7]),
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
    fn the_detective_walks_out() {
        let mut r = State::new(&SPEC);
        assert_eq!(DEPOT + STOPS[HOTEL_STOP], 22 * 60 + 58);
        msg(&mut r, "tap carbon");
        msg(&mut r, "use icarbon lamp");
        assert!(r.flag("carbon_read") && r.has("icarbon"));
        turn_to(&mut r, "cabinet", &PAD, 10);
        assert!(!r.flag("cabinet_open"), "the numbers are not readable yet");
        msg(&mut r, "flip lamp 0");
        msg(&mut r, "turn blinds 0 +1");
        msg(&mut r, "turn blinds 0 +1");
        assert!(r.flag("pad_read"));
        msg(&mut r, "turn cabinet 0 +1");
        msg(&mut r, "turn cabinet 0 -1");
        assert!(r.flag("cabinet_open"));
        msg(&mut r, "tap ribbon");
        assert_eq!(msg(&mut r, "use iribbon lamp"), "imsg.lamp_off");
        msg(&mut r, "flip lamp 0");
        msg(&mut r, "use iribbon lamp");
        assert_eq!(
            msg(&mut r, "tap coat0"),
            "imsg.coat0",
            "the pink carnation is a decoy"
        );
        msg(&mut r, "tap coat1");
        turn_to(&mut r, "radio", &[7, 4], 10);
        assert!(!r.flag("radio_on"), "the glass reads backwards from inside");
        turn_to(&mut r, "radio", &BAND, 10);
        turn_to(&mut r, "safe", &LEFT, 10);
        msg(&mut r, "tap opener");
        assert_eq!(msg(&mut r, "use iopener keyhole"), "imsg.no_sheet");
        msg(&mut r, "use icarbon door");
        msg(&mut r, "use iopener keyhole");
        msg(&mut r, "tap sheet");
        msg(&mut r, "use idoorkey door");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
