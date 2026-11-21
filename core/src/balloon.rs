//! The Great Balloon Race (tenth set): 1909, a gas balloon race. Fly the
//! village's mail to the right farm and land on its white cross. The winds
//! blow another way at each height: smoke below, kites in the middle,
//! clouds above. Views: `BL1` (the launch field: judge's table, tool tent,
//! gas cart, sand pile), `BL2` (the basket: instruments, map case, hamper,
//! pigeon, ropes), `BL3` (looking down: the map below), `BL4` (the sky:
//! chimney smoke, a kite, the clouds, a rival balloon).
//!
//! The flight (`drift`, `sand`, `valve`, `hook`): a drift moves one square
//! with the wind of the height you are at (1 low, 2 middle, 3 high); sand
//! climbs one height (only two bags), the valve sinks one, and at the lowest
//! height it lands. A landing anywhere but on the right cross with the mail,
//! or a drift off the map, and the judges' cart brings you back to start.

use crate::bad;
use crate::kit::{no_extra, Dial, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::sequence;

pub const W: u8 = 8;
pub const H: u8 = 6;
pub const START: u8 = 40;
/// Winds at heights 1, 2, 3: east, north, west.
pub const WINDS: [(i8, i8); 3] = [(1, 0), (0, -1), (-1, 0)];
pub const BAGS: u8 = 2;
pub const CHURCH: u8 = 27;
/// The four fields with a white cross, and what is drawn by each: (cows,
/// river, bees, mill).
pub const FIELDS: [(u8, [bool; 4]); 4] = [
    (14, [false, false, true, true]),
    (9, [true, false, false, true]),
    (39, [false, true, true, false]),
    (26, [true, false, true, false]),
];
/// The race card: not by the river, no cows: the first field.
pub const FIELD: usize = 0;
/// The mooring ropes, let go in the order of the rigging card (0 to 3).
pub const ROPES: [u8; 4] = [2, 0, 3, 1];

fn clues() -> String {
    let fields = FIELDS
        .iter()
        .map(|(c, a)| {
            format!(
                "[{c},{},{},{},{}]",
                u8::from(a[0]),
                u8::from(a[1]),
                u8::from(a[2]),
                u8::from(a[3])
            )
        })
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"w\":{W},\"h\":{H},\"start\":{START},\"church\":{CHURCH},\"bags\":{BAGS},\"winds\":[{}],\"fields\":[{fields}],\"ropes\":[{}]}}",
        WINDS
            .iter()
            .map(|(x, y)| format!("[{x},{y}]"))
            .collect::<Vec<_>>()
            .join(","),
        nums_json(&ROPES)
    )
}

fn reset(s: &mut State) {
    let v = s.val_mut("flight");
    v[0] = START;
    v[1] = 1;
    v[2] = BAGS;
}

fn field_cell() -> u8 {
    FIELDS[FIELD].0
}

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let flying = |s: &State| s.flag("ropes_free") && !s.flag("landed");
    match words {
        ["rope", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 4) {
            None => Err(bad("rope")),
            Some(_) if s.flag("ropes_free") => Ok(String::new()),
            Some(_) if !s.flag("inflated&ballast_in&compass_ok") => Ok("blmsg.not_ready".into()),
            Some(r) => match sequence(s, "ropes", &ROPES, r) {
                (true, _) => {
                    s.set("ropes_free");
                    reset(s);
                    Ok("blmsg.lift_off".into())
                }
                (false, true) => Ok("blmsg.rope_off".into()),
                (false, false) => Ok("blmsg.lurch".into()),
            },
        }),
        ["drift"] => Some(Ok(if !flying(s) {
            "blmsg.not_flying".into()
        } else {
            let [at, alt, _] = [s.val("flight")[0], s.val("flight")[1], s.val("flight")[2]];
            let (dx, dy) = WINDS[usize::from(alt - 1)];
            let x = (at % W) as i8 + dx;
            let y = (at / W) as i8 + dy;
            if x < 0 || y < 0 || x >= W as i8 || y >= H as i8 {
                reset(s);
                "blmsg.off_map".into()
            } else {
                s.val_mut("flight")[0] = y as u8 * W + x as u8;
                String::new()
            }
        })),
        ["sand"] => Some(Ok(if !flying(s) {
            "blmsg.not_flying".into()
        } else if s.val("flight")[2] == 0 {
            "blmsg.no_sand".into()
        } else if s.val("flight")[1] == 3 {
            "blmsg.ceiling".into()
        } else {
            let v = s.val_mut("flight");
            v[1] += 1;
            v[2] -= 1;
            "blmsg.climb".into()
        })),
        ["valve"] => Some(Ok(if !flying(s) {
            "blmsg.not_flying".into()
        } else if s.val("flight")[1] > 1 {
            s.val_mut("flight")[1] -= 1;
            "blmsg.sink".into()
        } else if s.val("flight")[0] != field_cell() || !s.flag("field_marked") {
            reset(s);
            "blmsg.wrong_field".into()
        } else if !s.flag("got_mail") {
            reset(s);
            "blmsg.no_mail".into()
        } else {
            s.set("landed");
            "blmsg.landed".into()
        })),
        ["hook"] => Some(Ok(if !flying(s) {
            "blmsg.not_flying".into()
        } else if s.flag("got_mail") {
            String::new()
        } else if s.val("flight")[0] == CHURCH && s.val("flight")[1] == 1 {
            s.set("got_mail");
            "blmsg.mail".into()
        } else {
            "blmsg.hook_misses".into()
        })),
        ["tap", spot] if spot.starts_with("field") && spot.len() == 6 => {
            let i = spot[5..].parse::<usize>().ok().filter(|i| *i < FIELDS.len());
            Some(match i {
                None => Err(bad(spot)),
                Some(_) if !s.flag("saw_fields") => Ok("blmsg.too_far".into()),
                Some(_) if !s.flag("got_card") => Ok("blmsg.which_field".into()),
                Some(FIELD) => {
                    s.set("field_marked");
                    Ok("blmsg.field_marked".into())
                }
                Some(_) => Ok("blmsg.not_that_field".into()),
            })
        }
        ["send"] => Some(Ok(if !s.has("blpigeon") {
            "blmsg.no_pigeon".into()
        } else if !s.flag("landed&toasted") {
            "blmsg.not_yet".into()
        } else if s.val("note") == [FIELDS[FIELD].0 % W, FIELDS[FIELD].0 / W] {
            s.take("blpigeon");
            s.set("done");
            "blmsg.pigeon_flies".into()
        } else {
            "blmsg.pigeon_back".into()
        })),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 10;

pub static SPEC: Spec = Spec {
    id: "balloon",
    prefix: "bl",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_card",
        "got_wrench",
        "inflated",
        "got_sand",
        "ballast_in",
        "compass_ok",
        "ropes_free",
        "got_binoculars",
        "saw_fields",
        "field_marked",
        "got_mail",
        "landed",
        "got_champagne",
        "toasted",
        "got_pigeon",
        "done",
    ],
    items: &["blwrench", "blsand", "blbinoculars", "blchampagne", "blpigeon"],
    locks: &[],
    dials: &[
        Dial {
            name: "ropes",
            size: 5,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "flight",
            size: 48,
            start: &[START, 1, BAGS],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "note",
            size: 8,
            start: &[0, 0],
            wrap: true,
            needs: "landed",
            needs_msg: "blmsg.nothing_to_tell",
            freeze: "done",
        },
    ],
    picks: &[
        Pick {
            spot: "card",
            needs: "",
            locked_msg: "",
            got: "got_card",
            give: &[],
            msg: "blmsg.card",
        },
        Pick {
            spot: "toolbox",
            needs: "",
            locked_msg: "",
            got: "got_wrench",
            give: &["blwrench"],
            msg: "blmsg.wrench",
        },
        Pick {
            spot: "sandpile",
            needs: "",
            locked_msg: "",
            got: "got_sand",
            give: &["blsand"],
            msg: "blmsg.sand",
        },
        Pick {
            spot: "magnet",
            needs: "",
            locked_msg: "",
            got: "compass_ok",
            give: &[],
            msg: "blmsg.magnet",
        },
        Pick {
            spot: "binocase",
            needs: "",
            locked_msg: "",
            got: "got_binoculars",
            give: &["blbinoculars"],
            msg: "blmsg.binoculars",
        },
        Pick {
            spot: "hamper",
            needs: "",
            locked_msg: "",
            got: "got_champagne",
            give: &["blchampagne"],
            msg: "blmsg.champagne",
        },
        Pick {
            spot: "pigeon",
            needs: "",
            locked_msg: "",
            got: "got_pigeon",
            give: &["blpigeon"],
            msg: "blmsg.pigeon",
        },
    ],
    uses: &[
        Use {
            item: "blwrench",
            spot: "gascart",
            needs: "",
            fail: "",
            keep: false,
            set: "inflated",
            give: &[],
            msg: "blmsg.inflated",
        },
        Use {
            item: "blsand",
            spot: "basket",
            needs: "",
            fail: "",
            keep: false,
            set: "ballast_in",
            give: &[],
            msg: "blmsg.ballast",
        },
        Use {
            item: "blbinoculars",
            spot: "ground",
            needs: "ropes_free",
            fail: "blmsg.on_ground",
            keep: false,
            set: "saw_fields",
            give: &[],
            msg: "blmsg.saw_fields",
        },
        Use {
            item: "blchampagne",
            spot: "farmer",
            needs: "landed",
            fail: "",
            keep: false,
            set: "toasted",
            give: &[],
            msg: "blmsg.toasted",
        },
    ],
    checks: &[],
    looks: &[],
    flavour: &[
        "judge",
        "tent",
        "gascart",
        "basket",
        "envelope",
        "rigging",
        "altimeter",
        "compass",
        "smoke",
        "kite",
        "clouds",
        "rival",
        "ground",
        "farmer",
        "crowd",
        "birds",
        "racecard",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_card"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_wrench"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("inflated"),
            available: |s| s.flag("got_wrench"),
        },
        Puzzle {
            solved: |s| s.flag("got_sand"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("ballast_in"),
            available: |s| s.flag("got_sand"),
        },
        Puzzle {
            solved: |s| s.flag("compass_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("ropes_free"),
            available: |s| s.flag("inflated&ballast_in&compass_ok"),
        },
        Puzzle {
            solved: |s| s.flag("got_binoculars"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("saw_fields"),
            available: |s| s.flag("got_binoculars&ropes_free"),
        },
        Puzzle {
            solved: |s| s.flag("field_marked"),
            available: |s| s.flag("saw_fields&got_card"),
        },
        Puzzle {
            solved: |s| s.flag("got_mail"),
            available: |s| s.flag("ropes_free"),
        },
        Puzzle {
            solved: |s| s.flag("landed"),
            available: |s| s.flag("field_marked&got_mail"),
        },
        Puzzle {
            solved: |s| s.flag("got_champagne"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("toasted"),
            available: |s| s.flag("landed&got_champagne"),
        },
        Puzzle {
            solved: |s| s.flag("got_pigeon"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("toasted&got_pigeon"),
        },
    ],
    hint_views: &[
        ("BL1", &[0, 1, 2, 3, 4, 13]),
        ("BL2", &[5, 6, 7, 12, 14, 15]),
        ("BL3", &[8, 9, 10, 11]),
        ("BL4", &[10, 11]),
        ("blcard", &[9]),
        ("blrigging", &[6]),
        ("blmap", &[9, 10, 11]),
        ("blnote", &[15]),
    ],
    done_flag: "done",
    clues,
    extra: no_extra,
    hook,
};

#[cfg(test)]
mod tests {
    use super::*;
    use crate::kit::msg;

    pub const FLIGHT: [&str; 16] = [
        "drift", "drift", "drift", "sand", "drift", "drift", "valve", "hook", "drift", "drift", "drift",
        "sand", "drift", "drift", "valve", "valve",
    ];

    #[test]
    fn the_mail_comes_down_on_the_cross() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap card");
        msg(&mut r, "tap toolbox");
        msg(&mut r, "use blwrench gascart");
        msg(&mut r, "tap sandpile");
        msg(&mut r, "use blsand basket");
        assert_eq!(msg(&mut r, "rope 2"), "blmsg.not_ready");
        msg(&mut r, "tap magnet");
        assert_eq!(msg(&mut r, "rope 0"), "blmsg.lurch");
        for k in ROPES {
            msg(&mut r, &format!("rope {k}"));
        }
        assert!(r.flag("ropes_free"));
        msg(&mut r, "tap binocase");
        msg(&mut r, "use blbinoculars ground");
        assert_eq!(msg(&mut r, "tap field2"), "blmsg.not_that_field");
        msg(&mut r, "tap field0");
        // Landing on the right cross without the mail: back to start.
        assert_eq!(msg(&mut r, "drift"), "");
        assert_eq!(msg(&mut r, "valve"), "blmsg.wrong_field");
        assert_eq!(r.val("flight"), &[START, 1, BAGS]);
        for c in FLIGHT {
            msg(&mut r, c);
        }
        assert!(r.flag("got_mail") && r.flag("landed"), "{:?}", r.val("flight"));
        msg(&mut r, "tap hamper");
        msg(&mut r, "use blchampagne farmer");
        msg(&mut r, "tap pigeon");
        assert_eq!(msg(&mut r, "send"), "blmsg.pigeon_back");
        for _ in 0..FIELDS[FIELD].0 % W {
            msg(&mut r, "turn note 0 +1");
        }
        for _ in 0..FIELDS[FIELD].0 / W {
            msg(&mut r, "turn note 1 +1");
        }
        msg(&mut r, "send");
        assert!(r.done && r.solved().iter().all(|s| *s));
    }
}
