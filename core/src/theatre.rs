//! Curtain Call (medium): backstage after the last performance, eight
//! puzzles. Views: `T1` the wings, `T2` the stage, `T3` the dressing room.

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json, strs_json};

/// The digit painted on the backdrop that each mixed light shows.
pub const MIX_DIGITS: [(&str, u8); 3] = [("yellow", 4), ("magenta", 8), ("cyan", 2)];
/// The cues on the call sheet, in order.
pub const CUES: [&str; 3] = ["magenta", "yellow", "cyan"];
/// The follow spot's mark in the prompt book: column and row of the stage's
/// three by three (0 0 is stage left, upstage).
pub const MARK: [u8; 2] = [2, 0];
/// The masks on the wall, left to right, and the acts' order on the poster.
pub const MASKS: [&str; 5] = ["happy", "sad", "angry", "surprised", "sleepy"];
pub const ACTS: [&str; 4] = ["angry", "happy", "sleepy", "sad"];
/// The costumes on the rack with their tags, and the dots on the mirror.
pub const COSTUMES: [(&str, u8); 5] = [
    ("red", 3),
    ("yellow", 6),
    ("blue", 1),
    ("violet", 9),
    ("white", 5),
];
pub const DOTS: [&str; 4] = ["blue", "red", "white", "yellow"];
/// The mirror's six bulbs at the start; each switch flips its bulb and the next.
const BULBS_START: [u8; 6] = [0, 0, 0, 1, 0, 1];

/// The mixed colour of the three lamps (red, green, blue), or "".
pub fn mix(lamps: &[u8]) -> &'static str {
    match lamps {
        [1, 1, 0] => "yellow",
        [1, 0, 1] => "magenta",
        [0, 1, 1] => "cyan",
        [1, 1, 1] => "white",
        [1, 0, 0] => "red",
        [0, 1, 0] => "green",
        [0, 0, 1] => "blue",
        _ => "",
    }
}

fn trunk_code() -> Vec<u8> {
    CUES.iter()
        .map(|c| MIX_DIGITS.iter().find(|(m, _)| m == c).expect("a mixed colour").1)
        .collect()
}

pub fn door_code() -> Vec<u8> {
    DOTS.iter()
        .map(|c| COSTUMES.iter().find(|(k, _)| k == c).expect("a costume").1)
        .collect()
}

fn act_order() -> Vec<u8> {
    ACTS.iter()
        .map(|a| MASKS.iter().position(|m| m == a).expect("a mask") as u8 + 1)
        .collect()
}

fn clues() -> String {
    let pairs = |list: &[(&str, u8)]| {
        list.iter()
            .map(|(c, d)| format!("{{\"colour\":\"{c}\",\"digit\":{d}}}"))
            .collect::<Vec<_>>()
            .join(",")
    };
    format!(
        "{{\"ok\":true,\"mix_digits\":[{}],\"cues\":[{}],\"mark\":[{}],\"masks\":[{}],\"acts\":[{}],\"costumes\":[{}],\"dots\":[{}]}}",
        pairs(&MIX_DIGITS),
        strs_json(&CUES),
        nums_json(&MARK),
        strs_json(&MASKS),
        strs_json(&ACTS),
        pairs(&COSTUMES),
        strs_json(&DOTS)
    )
}

fn extra(s: &State) -> String {
    format!(
        ",\"mix\":\"{}\"",
        if s.flag("desk_on") {
            mix(s.val("lamps"))
        } else {
            ""
        }
    )
}

/// `mask <0..4>`: presses a mask; four in the acts' order open the niche.
/// `bulb <0..5>`: a mirror switch; flips its bulb and the next one round.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    let index = |max: usize| {
        words
            .get(1)
            .and_then(|w| w.parse::<usize>().ok())
            .filter(|i| *i < max)
    };
    match words[0] {
        "mask" => Some(match index(MASKS.len()) {
            None => Err(bad("mask")),
            Some(_) if !s.flag("mask_on") => Ok("tmsg.mask_gap".into()),
            Some(_) if s.flag("masks_open") => Ok(String::new()),
            Some(i) => {
                let mut pressed = s.val("pressed").to_vec();
                let at = pressed.iter().position(|p| *p == 0).unwrap_or(0);
                pressed[at] = i as u8 + 1;
                let reply = if at < 3 {
                    ""
                } else if pressed == act_order() {
                    s.set("masks_open");
                    "tmsg.masks_open"
                } else {
                    pressed.fill(0);
                    "tmsg.masks_wrong"
                };
                *s.val_mut("pressed") = pressed;
                Ok(reply.into())
            }
        }),
        "bulb" => Some(match index(6) {
            None => Err(bad("bulb")),
            Some(_) if s.flag("mirror_lit") => Ok(String::new()),
            Some(i) => {
                let bulbs = s.val_mut("bulbs");
                bulbs[i] ^= 1;
                bulbs[(i + 1) % 6] ^= 1;
                Ok(String::new())
            }
        }),
        _ => None,
    }
}

pub static SPEC: Spec = Spec {
    id: "theatre",
    prefix: "t",
    par_minutes: 25,
    flags: &[
        "got_plug",
        "desk_on",
        "trunk_open",
        "got_trunk",
        "bar_down",
        "trap_open",
        "got_mask",
        "mask_on",
        "masks_open",
        "got_key",
        "mirror_lit",
        "key_in",
        "done",
    ],
    items: &["plug", "crank", "mask", "key"],
    locks: &[
        Lock {
            name: "trunk",
            size: 10,
            start: &[0, 0, 0],
            code: trunk_code,
            flag: "trunk_open",
            msg: "tmsg.trunk_open",
            needs: "",
        },
        Lock {
            name: "door",
            size: 10,
            start: &[0, 0, 0, 0],
            code: door_code,
            flag: "done",
            msg: "tmsg.door_open",
            needs: "key_in",
        },
    ],
    dials: &[
        Dial {
            name: "lamps",
            size: 2,
            start: &[0, 0, 0],
            wrap: true,
            needs: "desk_on",
            needs_msg: "tmsg.desk_dead",
            freeze: "",
        },
        Dial {
            name: "spot",
            size: 3,
            start: &[0, 2],
            wrap: false,
            needs: "bar_down",
            needs_msg: "tmsg.spot_high",
            freeze: "trap_open",
        },
        Dial {
            name: "pressed",
            size: 6,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "bulbs",
            size: 2,
            start: &BULBS_START,
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "props",
            needs: "",
            locked_msg: "",
            got: "got_plug",
            give: &["plug"],
            msg: "tmsg.plug",
        },
        Pick {
            spot: "trunk",
            needs: "trunk_open",
            locked_msg: "tmsg.trunk_locked",
            got: "got_trunk",
            give: &["crank"],
            msg: "tmsg.trunk_take",
        },
        Pick {
            spot: "trap",
            needs: "trap_open",
            locked_msg: "tmsg.trap_shut",
            got: "got_mask",
            give: &["mask"],
            msg: "tmsg.mask",
        },
        Pick {
            spot: "niche",
            needs: "masks_open",
            locked_msg: "tmsg.niche_shut",
            got: "got_key",
            give: &["key"],
            msg: "tmsg.key",
        },
    ],
    uses: &[
        Use {
            item: "plug",
            spot: "desk",
            needs: "",
            fail: "",
            keep: false,
            set: "desk_on",
            give: &[],
            msg: "tmsg.desk_on",
        },
        Use {
            item: "crank",
            spot: "winch",
            needs: "",
            fail: "",
            keep: false,
            set: "bar_down",
            give: &[],
            msg: "tmsg.bar_down",
        },
        Use {
            item: "mask",
            spot: "masks|gap",
            needs: "",
            fail: "",
            keep: false,
            set: "mask_on",
            give: &[],
            msg: "tmsg.mask_on",
        },
        Use {
            item: "key",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "key_in",
            give: &[],
            msg: "tmsg.key_in",
        },
    ],
    checks: &[
        Check {
            flag: "trap_open",
            cond: |s| s.flag("bar_down") && s.val("spot") == MARK,
            msg: "tmsg.trap_open",
        },
        Check {
            flag: "mirror_lit",
            cond: |s| s.val("bulbs").iter().all(|b| *b == 1),
            msg: "tmsg.mirror_lit",
        },
    ],
    looks: &[
        Look {
            spot: "desk",
            flag: "desk_on",
            set: "tmsg.desk_ready",
            unset: "tmsg.desk_dead",
        },
        Look {
            spot: "winch",
            flag: "bar_down",
            set: "tmsg.winch_done",
            unset: "tmsg.winch",
        },
        Look {
            spot: "door",
            flag: "key_in",
            set: "tmsg.door_code",
            unset: "tmsg.door_locked",
        },
        Look {
            spot: "gap",
            flag: "mask_on",
            set: "tmsg.masks",
            unset: "tmsg.mask_gap",
        },
    ],
    flavour: &["ropes", "curtain", "ghostlight", "backdrop", "rack", "chair"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("desk_on"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("trunk_open"),
            available: |s| s.flag("desk_on"),
        },
        Puzzle {
            solved: |s| s.flag("bar_down"),
            available: |s| s.flag("got_trunk"),
        },
        Puzzle {
            solved: |s| s.flag("trap_open"),
            available: |s| s.flag("bar_down"),
        },
        Puzzle {
            solved: |s| s.flag("masks_open"),
            available: |s| s.flag("got_mask"),
        },
        Puzzle {
            solved: |s| s.flag("mirror_lit"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("key_in"),
            available: |s| s.flag("got_key"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("mirror_lit"),
        },
    ],
    hint_views: &[
        ("T1", &[0, 2, 1]),
        ("T2", &[0, 1, 3]),
        ("T3", &[5, 4, 6, 7]),
        ("tdesk", &[0, 1, 3]),
        ("ttrunk", &[1, 3]),
        ("sheet", &[1]),
        ("rack", &[7]),
        ("masks", &[4]),
        ("poster", &[4]),
        ("mirror", &[5, 7]),
        ("tdoor", &[6, 7]),
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
    fn the_stage_door_opens() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "flip lamps 0"), "tmsg.desk_dead");
        msg(&mut r, "tap props");
        assert_eq!(msg(&mut r, "use plug desk"), "tmsg.desk_on");
        msg(&mut r, "flip lamps 0");
        msg(&mut r, "flip lamps 2");
        assert!(r.call("state").contains("\"mix\":\"magenta\""));
        assert_eq!(trunk_code(), [8, 4, 2]);
        turn_to(&mut r, "trunk", &trunk_code(), 10);
        assert_eq!(msg(&mut r, "tap trunk"), "tmsg.trunk_take");
        assert_eq!(msg(&mut r, "turn spot 0 +1"), "tmsg.spot_high");
        msg(&mut r, "use crank winch");
        for c in ["turn spot 0 +1", "turn spot 0 +1", "turn spot 1 -1"] {
            assert_eq!(msg(&mut r, c), "");
        }
        assert_eq!(msg(&mut r, "turn spot 1 -1"), "tmsg.trap_open");
        assert_eq!(msg(&mut r, "mask 0"), "tmsg.mask_gap");
        msg(&mut r, "tap trap");
        msg(&mut r, "use mask gap");
        for m in [0, 1, 2] {
            msg(&mut r, &format!("mask {m}"));
        }
        assert_eq!(msg(&mut r, "mask 3"), "tmsg.masks_wrong");
        assert_eq!(act_order(), [3, 1, 5, 2]);
        for m in [2, 0, 4] {
            msg(&mut r, &format!("mask {m}"));
        }
        assert_eq!(msg(&mut r, "mask 1"), "tmsg.masks_open");
        msg(&mut r, "tap niche");
        msg(&mut r, "bulb 0");
        msg(&mut r, "bulb 2");
        assert_eq!(msg(&mut r, "bulb 3"), "tmsg.mirror_lit");
        assert_eq!(door_code(), [1, 3, 5, 6]);
        turn_to(&mut r, "door", &door_code(), 10);
        assert!(!r.done, "the door needs its key first");
        msg(&mut r, "turn door 0 +1");
        assert_eq!(msg(&mut r, "use key door"), "tmsg.key_in");
        assert_eq!(msg(&mut r, "turn door 0 -1"), "tmsg.door_open");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
