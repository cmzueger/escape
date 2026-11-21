//! The Night Gallery (hard): the Egyptian wing after closing, six puzzles
//! around an invented script. Views: `M1` (sarcophagus, tablet, scales)
//! and `M2` (display case, moon dial, frieze, door).

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json, strs_json};

/// The six glyphs and the number the tablet's tally marks give each.
pub const GLYPHS: [&str; 6] = ["eye", "bird", "wave", "sun", "reed", "scarab"];
pub const VALUES: [u8; 6] = [3, 5, 1, 6, 2, 4];
/// The glyphs on the display case's label.
pub const LABEL: [&str; 3] = ["wave", "reed", "bird"];
/// The scales: the feather's weight in tally marks, and the jars' glyphs.
pub const FEATHER: u8 = 7;
pub const JARS: [&str; 4] = ["eye", "sun", "scarab", "bird"];
/// The frieze over the dial: the sun disc rests above this glyph.
pub const SUN_OVER: &str = "bird";
/// The procession on the sarcophagus's frieze as drawn, left to right. The
/// figures walk to the right: the first of them is the rightmost.
pub const PROCESSION: [&str; 4] = ["reed", "eye", "scarab", "wave"];
/// The papyrus in the sarcophagus: four numbers for the door's glyphs.
pub const PAPYRUS: [u8; 4] = [4, 6, 3, 5];

fn glyph(name: &str) -> usize {
    GLYPHS.iter().position(|g| *g == name).expect("a glyph")
}

fn case_code() -> Vec<u8> {
    LABEL.iter().map(|g| VALUES[glyph(g)]).collect()
}

fn sarc_code() -> Vec<u8> {
    PROCESSION.iter().rev().map(|g| glyph(g) as u8).collect()
}

pub fn door_order() -> Vec<u8> {
    PAPYRUS
        .iter()
        .map(|n| VALUES.iter().position(|v| v == n).expect("a glyph of that value") as u8 + 1)
        .collect()
}

fn jar_sum(jars: &[u8]) -> u8 {
    jars.iter()
        .zip(JARS)
        .filter(|(on, _)| **on == 1)
        .map(|(_, g)| VALUES[glyph(g)])
        .sum()
}

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"glyphs\":[{}],\"values\":[{}],\"label\":[{}],\"feather\":{FEATHER},\"jars\":[{}],\"sun_over\":\"{SUN_OVER}\",\"procession\":[{}],\"papyrus\":[{}]}}",
        strs_json(&GLYPHS),
        nums_json(&VALUES),
        strs_json(&LABEL),
        strs_json(&JARS),
        strs_json(&PROCESSION),
        nums_json(&PAPYRUS)
    )
}

fn extra(s: &State) -> String {
    let lean = if s.flag("feather_on") {
        (i16::from(jar_sum(s.val("jars"))) - i16::from(FEATHER)).signum()
    } else {
        1
    };
    format!(",\"lean\":{lean}")
}

/// `glyph <0..5>`: presses a glyph of the door; four in the papyrus's order open it.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words[0] != "glyph" {
        return None;
    }
    Some(
        match words
            .get(1)
            .and_then(|w| w.parse::<usize>().ok())
            .filter(|i| *i < GLYPHS.len())
        {
            None => Err(bad("glyph")),
            Some(_) if !s.flag("key_in") => Ok("mmsg.door_dead".into()),
            Some(i) => {
                let mut pressed = s.val("pressed").to_vec();
                let at = pressed.iter().position(|p| *p == 0).unwrap_or(0);
                pressed[at] = i as u8 + 1;
                let reply = if at < 3 {
                    ""
                } else if pressed == door_order() {
                    s.set("done");
                    "mmsg.door_open"
                } else {
                    pressed.fill(0);
                    "mmsg.door_wrong"
                };
                *s.val_mut("pressed") = pressed;
                Ok(reply.into())
            }
        },
    )
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 10;

pub static SPEC: Spec = Spec {
    id: "museum",
    prefix: "m",
    par_minutes: PAR_MINUTES,
    flags: &[
        "case_open",
        "got_feather",
        "feather_on",
        "balanced",
        "got_disc",
        "disc_on",
        "niche_open",
        "got_skey",
        "sarc_open",
        "key_in",
        "done",
    ],
    items: &["feather", "disc", "scarabkey"],
    locks: &[
        Lock {
            name: "case",
            size: 10,
            start: &[0, 0, 0],
            code: case_code,
            flag: "case_open",
            msg: "mmsg.case_open",
            needs: "",
        },
        Lock {
            name: "sarc",
            size: 6,
            start: &[0, 0, 0, 0],
            code: sarc_code,
            flag: "sarc_open",
            msg: "mmsg.sarc_open",
            needs: "",
        },
    ],
    dials: &[
        Dial {
            name: "jars",
            size: 2,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "feather_on",
            needs_msg: "mmsg.scales_bare",
            freeze: "balanced",
        },
        Dial {
            name: "ring",
            size: 6,
            start: &[3],
            wrap: true,
            needs: "disc_on",
            needs_msg: "mmsg.dial_bare",
            freeze: "niche_open",
        },
        Dial {
            name: "pressed",
            size: 7,
            start: &[0, 0, 0, 0],
            wrap: true,
            needs: "done",
            needs_msg: "",
            freeze: "",
        },
    ],
    picks: &[
        Pick {
            spot: "case",
            needs: "case_open",
            locked_msg: "mmsg.case_locked",
            got: "got_feather",
            give: &["feather"],
            msg: "mmsg.feather",
        },
        Pick {
            spot: "scalebox",
            needs: "balanced",
            locked_msg: "mmsg.scalebox_shut",
            got: "got_disc",
            give: &["disc"],
            msg: "mmsg.disc",
        },
        Pick {
            spot: "niche",
            needs: "niche_open",
            locked_msg: "mmsg.niche_shut",
            got: "got_skey",
            give: &["scarabkey"],
            msg: "mmsg.scarabkey",
        },
    ],
    uses: &[
        Use {
            item: "feather",
            spot: "scales|scalebox",
            needs: "",
            fail: "",
            keep: false,
            set: "feather_on",
            give: &[],
            msg: "mmsg.feather_on",
        },
        Use {
            item: "disc",
            spot: "dial|niche",
            needs: "",
            fail: "",
            keep: false,
            set: "disc_on",
            give: &[],
            msg: "mmsg.disc_on",
        },
        Use {
            item: "scarabkey",
            spot: "door",
            needs: "",
            fail: "",
            keep: false,
            set: "key_in",
            give: &[],
            msg: "mmsg.key_in",
        },
    ],
    checks: &[
        Check {
            flag: "balanced",
            cond: |s| s.flag("feather_on") && jar_sum(s.val("jars")) == FEATHER,
            msg: "mmsg.balanced",
        },
        Check {
            flag: "niche_open",
            cond: |s| s.flag("disc_on") && usize::from(s.val("ring")[0]) == glyph(SUN_OVER),
            msg: "mmsg.niche_open",
        },
    ],
    looks: &[
        Look {
            spot: "door",
            flag: "key_in",
            set: "mmsg.door_ready",
            unset: "mmsg.door",
        },
        Look {
            spot: "sarcophagus",
            flag: "sarc_open",
            set: "mmsg.papyrus",
            unset: "mmsg.sarc",
        },
        Look {
            spot: "scales",
            flag: "feather_on",
            set: "mmsg.scales",
            unset: "mmsg.scales_bare",
        },
        Look {
            spot: "dial",
            flag: "disc_on",
            set: "mmsg.dial",
            unset: "mmsg.dial_bare",
        },
    ],
    flavour: &["statue", "skylight", "rope", "guardchair", "vase"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("case_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("balanced"),
            available: |s| s.flag("got_feather"),
        },
        Puzzle {
            solved: |s| s.flag("niche_open"),
            available: |s| s.flag("got_disc"),
        },
        Puzzle {
            solved: |s| s.flag("sarc_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("key_in"),
            available: |s| s.flag("got_skey"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("key_in") && s.flag("sarc_open"),
        },
    ],
    hint_views: &[
        ("M1", &[3, 1, 0]),
        ("M2", &[0, 2, 4, 5]),
        ("mtablet", &[0, 1, 5]),
        ("mcase", &[0]),
        ("mscales", &[1]),
        ("mdial", &[2]),
        ("mfrieze", &[2, 3]),
        ("msarc", &[3, 5]),
        ("mdoor", &[4, 5]),
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
    fn the_puzzles_have_one_answer() {
        assert_eq!(case_code(), [1, 2, 5]);
        assert_eq!(sarc_code(), [2, 5, 0, 4]);
        assert_eq!(door_order(), [6, 4, 1, 2]);
        let ways = (0u8..16)
            .filter(|set| jar_sum(&[set & 1, set >> 1 & 1, set >> 2 & 1, set >> 3 & 1]) == FEATHER)
            .collect::<Vec<_>>();
        assert_eq!(ways, [0b0101]);
    }

    #[test]
    fn the_gallery_can_be_left() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "case", &case_code(), 10);
        msg(&mut r, "tap case");
        assert_eq!(msg(&mut r, "flip jars 0"), "mmsg.scales_bare");
        msg(&mut r, "use feather scales");
        msg(&mut r, "flip jars 0");
        assert_eq!(msg(&mut r, "flip jars 2"), "mmsg.balanced");
        msg(&mut r, "tap scalebox");
        assert_eq!(msg(&mut r, "turn ring 0 +1"), "mmsg.dial_bare");
        msg(&mut r, "use disc dial");
        msg(&mut r, "turn ring 0 -1");
        assert_eq!(msg(&mut r, "turn ring 0 -1"), "mmsg.niche_open");
        msg(&mut r, "tap niche");
        turn_to(&mut r, "sarc", &sarc_code(), 6);
        assert!(r.flag("sarc_open"));
        assert_eq!(msg(&mut r, "glyph 0"), "mmsg.door_dead");
        msg(&mut r, "use scarabkey door");
        for g in [0, 1, 2] {
            msg(&mut r, &format!("glyph {g}"));
        }
        assert_eq!(msg(&mut r, "glyph 3"), "mmsg.door_wrong");
        for g in [5, 3, 0] {
            msg(&mut r, &format!("glyph {g}"));
        }
        assert_eq!(msg(&mut r, "glyph 1"), "mmsg.door_open");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
