//! The Night Edition (hard): a newspaper's print works in 1890, an hour
//! before the presses run. Nine puzzles. Views: `O1` (the composing room:
//! type case and composing stick, time cards, lockers, house rules, waste
//! bin, Monday's paper) and `O2` (the press hall: paper reels, the paper
//! path, the ink fountain, the watchman's desk, the press).
//!
//! Type prints mirrored: the composing stick holds the line backwards.

use crate::kit::{no_extra, Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json};

/// The time cards: clock number, in (minutes after midnight), out (or 0).
pub const CARDS: [([u8; 3], u32, u32); 5] = [
    ([4, 1, 8], 18 * 60 + 2, 22 * 60 + 20),
    ([9, 5, 1], 22 * 60 + 3, 0),
    ([2, 6, 3], 22 * 60 + 7, 0),
    ([7, 3, 5], 22 * 60 + 31, 0),
    ([1, 0, 2], 18 * 60, 22 * 60 + 20),
];
/// The foreman's card.
pub const FOREMAN: usize = 2;
/// The sum in the reporter's notebook: the missing line.
pub const FIGURE: [u8; 5] = [4, 7, 5, 2, 0];
/// An empty place in the composing stick.
pub const EMPTY: u8 = 10;
/// The three reels' watermarks (0 crown of three, 1 anchor, 2 crown of five).
pub const MARKS: [u8; 3] = [0, 1, 2];
pub const GOOD_REEL: u8 = 2;
/// The paper path over (1) or under (0) six rollers.
pub const WEB: [u8; 6] = [1, 0, 0, 1, 1, 0];
/// The ink keys at the start, and the grey wanted (of five).
pub const INK_START: [u8; 5] = [0, 4, 1, 3, 2];
pub const GREY: u8 = 2;
/// The ads signed H.: Monday's (the decoy) and Tuesday's.
pub const MONDAY: [u8; 4] = [5, 8, 1, 6];
pub const TUESDAY: [u8; 4] = [3, 1, 4, 2];

/// What the stick must hold: the figure, backwards.
pub fn set_line() -> Vec<u8> {
    FIGURE.iter().rev().copied().collect()
}

fn clues() -> String {
    let cards = CARDS
        .iter()
        .map(|(n, i, o)| format!("[[{}],{i},{o}]", nums_json(n)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"cards\":[{cards}],\"figure\":[{}],\"marks\":[{}],\"web\":[{}],\"grey\":{GREY},\"monday\":[{}],\"tuesday\":[{}]}}",
        nums_json(&FIGURE),
        nums_json(&MARKS),
        nums_json(&WEB),
        nums_json(&MONDAY),
        nums_json(&TUESDAY)
    )
}

/// The type case (`sort <0..9>`, `clear`), the proof press (`proof`) and
/// the reels (`mount <0..2>`).
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["sort", d] => Some(match d.parse::<u8>().ok().filter(|d| *d < 10) {
            None => Err(bad("sort")),
            Some(_) if s.flag("forme_full") => Ok("dmsg.stick_done".into()),
            Some(d) => {
                let stick = s.val_mut("stick");
                match stick.iter().position(|v| *v == EMPTY) {
                    Some(i) => {
                        stick[i] = d;
                        Ok(String::new())
                    }
                    None => Ok("dmsg.stick_full".into()),
                }
            }
        }),
        ["clear"] => {
            if !s.flag("forme_full") {
                s.val_mut("stick").iter_mut().for_each(|v| *v = EMPTY);
            }
            Some(Ok(String::new()))
        }
        ["proof"] => Some(Ok(if s.val("stick").contains(&EMPTY) {
            "dmsg.proof_short"
        } else if s.val("stick") == set_line() {
            "dmsg.proof_good"
        } else {
            "dmsg.proof"
        }
        .into())),
        ["mount", r] => Some(match r.parse::<u8>().ok().filter(|r| *r < 3) {
            None => Err(bad("mount")),
            Some(_) if s.flag("reel_ok") => Ok("dmsg.reel_fixed".into()),
            Some(r) => {
                s.val_mut("reel")[0] = r;
                Ok("dmsg.mounted".into())
            }
        }),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 17;

macro_rules! mark {
    ($spot:literal, $msg:literal, $set:literal, $keep:literal) => {
        Use {
            item: "dlantern",
            spot: $spot,
            needs: "",
            fail: "",
            keep: $keep,
            set: $set,
            give: &[],
            msg: $msg,
        }
    };
}

pub static SPEC: Spec = Spec {
    id: "press",
    prefix: "d",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_letter",
        "locker_open",
        "got_forme",
        "line_ok",
        "forme_full",
        "got_lantern",
        "mark0",
        "mark1",
        "mark2",
        "reel_ok",
        "web_ok",
        "ink_ok",
        "plate_on",
        "drawer_open",
        "got_key",
        "done",
    ],
    items: &["dforme", "dlantern", "dpresskey"],
    locks: &[
        Lock {
            name: "locker",
            size: 10,
            start: &[0, 0, 0],
            code: || CARDS[FOREMAN].0.to_vec(),
            flag: "locker_open",
            msg: "dmsg.locker_open",
            needs: "got_letter",
        },
        Lock {
            name: "drawer",
            size: 10,
            start: &[0, 0, 0, 0],
            code: || TUESDAY.to_vec(),
            flag: "drawer_open",
            msg: "dmsg.drawer_open",
            needs: "got_letter",
        },
    ],
    dials: &[
        Dial {
            name: "stick",
            size: 11,
            start: &[EMPTY; 5],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "reel",
            size: 3,
            start: &[0],
            wrap: true,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "web",
            size: 2,
            start: &[0, 0, 0, 0, 0, 0],
            wrap: true,
            needs: "reel_ok&locker_open",
            needs_msg: "dmsg.web_wait",
            freeze: "web_ok",
        },
        Dial {
            name: "ink",
            size: 5,
            start: &INK_START,
            wrap: false,
            needs: "web_ok",
            needs_msg: "dmsg.ink_wait",
            freeze: "ink_ok",
        },
    ],
    picks: &[
        Pick {
            spot: "letter",
            needs: "",
            locked_msg: "",
            got: "got_letter",
            give: &[],
            msg: "dmsg.letter",
        },
        Pick {
            spot: "forme",
            needs: "locker_open",
            locked_msg: "dmsg.locker_shut",
            got: "got_forme",
            give: &["dforme"],
            msg: "dmsg.forme",
        },
        Pick {
            spot: "lantern",
            needs: "",
            locked_msg: "",
            got: "got_lantern",
            give: &["dlantern"],
            msg: "dmsg.lantern",
        },
        Pick {
            spot: "pkey",
            needs: "drawer_open",
            locked_msg: "dmsg.drawer_shut",
            got: "got_key",
            give: &["dpresskey"],
            msg: "dmsg.key",
        },
    ],
    uses: &[
        mark!("reel0", "dmsg.mark0", "mark0", true),
        mark!("reel1", "dmsg.mark1", "mark1", true),
        mark!("reel2", "dmsg.mark2", "mark2", false),
        Use {
            item: "dforme",
            spot: "stick",
            needs: "line_ok",
            fail: "dmsg.line_wrong",
            keep: true,
            set: "forme_full",
            give: &[],
            msg: "dmsg.forme_full",
        },
        Use {
            item: "dforme",
            spot: "cylinder",
            needs: "forme_full",
            fail: "dmsg.forme_gap",
            keep: false,
            set: "plate_on",
            give: &[],
            msg: "dmsg.plate_on",
        },
        Use {
            item: "dpresskey",
            spot: "press",
            needs: "plate_on&ink_ok",
            fail: "dmsg.not_ready",
            keep: false,
            set: "done",
            give: &[],
            msg: "dmsg.rolls",
        },
    ],
    checks: &[
        Check {
            flag: "line_ok",
            cond: |s| s.flag("got_forme") && s.val("stick") == set_line(),
            msg: "dmsg.proof_good",
        },
        Check {
            flag: "reel_ok",
            cond: |s| s.flag("mark2") && s.val("reel")[0] == GOOD_REEL,
            msg: "dmsg.reel_ok",
        },
        Check {
            flag: "web_ok",
            cond: |s| s.flag("reel_ok&locker_open") && s.val("web") == WEB,
            msg: "dmsg.web_ok",
        },
        Check {
            flag: "ink_ok",
            cond: |s| s.flag("web_ok") && s.val("ink").iter().all(|k| *k == GREY),
            msg: "dmsg.ink_ok",
        },
    ],
    looks: &[
        Look {
            spot: "lockers",
            flag: "locker_open",
            set: "dmsg.locker_inside",
            unset: "dmsg.lockers",
        },
        Look {
            spot: "press",
            flag: "plate_on",
            set: "dmsg.press_ready",
            unset: "dmsg.press",
        },
    ],
    flavour: &[
        "rules", "cards", "log", "notebook", "monday", "tuesday", "chart", "manual", "case", "lamp", "clock",
        "door", "reels", "bin", "reel0", "reel1", "reel2", "stick", "cylinder",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_letter"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("locker_open"),
            available: |s| s.flag("got_letter"),
        },
        Puzzle {
            solved: |s| s.flag("forme_full"),
            available: |s| s.flag("got_forme"),
        },
        Puzzle {
            solved: |s| s.flag("reel_ok"),
            available: |s| s.flag("got_lantern"),
        },
        Puzzle {
            solved: |s| s.flag("web_ok"),
            available: |s| s.flag("reel_ok&locker_open"),
        },
        Puzzle {
            solved: |s| s.flag("ink_ok"),
            available: |s| s.flag("web_ok"),
        },
        Puzzle {
            solved: |s| s.flag("plate_on"),
            available: |s| s.flag("forme_full"),
        },
        Puzzle {
            solved: |s| s.flag("drawer_open"),
            available: |s| s.flag("got_letter"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("plate_on&ink_ok&got_key"),
        },
    ],
    hint_views: &[
        ("O1", &[0, 1, 2, 6]),
        ("O2", &[3, 4, 5, 7, 8]),
        ("dbin", &[0]),
        ("dcards", &[1]),
        ("dlog", &[1]),
        ("dlocker", &[1, 2]),
        ("dstick", &[2]),
        ("dnotebook", &[2]),
        ("drules", &[3, 5]),
        ("dreels", &[3]),
        ("dchart", &[4]),
        ("dweb", &[4]),
        ("dfount", &[5]),
        ("dpress", &[6, 8]),
        ("dmonday", &[7]),
        ("ddesk", &[3, 7, 8]),
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
    fn the_edition_rolls() {
        let mut r = State::new(&SPEC);
        turn_to(&mut r, "locker", &CARDS[FOREMAN].0, 10);
        assert!(!r.flag("locker_open"), "not before the letter says whose locker");
        msg(&mut r, "tap letter");
        turn_to(&mut r, "locker", &CARDS[1].0, 10);
        assert!(!r.flag("locker_open"), "the proofreader's card is a decoy");
        turn_to(&mut r, "locker", &CARDS[FOREMAN].0, 10);
        assert!(r.flag("locker_open"));
        msg(&mut r, "tap forme");
        for d in FIGURE {
            msg(&mut r, &format!("sort {d}"));
        }
        assert_eq!(msg(&mut r, "proof"), "dmsg.proof", "type prints mirrored");
        msg(&mut r, "clear");
        for d in set_line() {
            msg(&mut r, &format!("sort {d}"));
        }
        assert!(r.flag("line_ok"));
        msg(&mut r, "use dforme stick");
        msg(&mut r, "tap lantern");
        msg(&mut r, "use dlantern reel0");
        msg(&mut r, "mount 0");
        assert!(!r.flag("reel_ok"), "a crown of three points is a decoy");
        msg(&mut r, "use dlantern reel2");
        msg(&mut r, "mount 2");
        assert!(r.flag("reel_ok"));
        for (i, w) in WEB.iter().enumerate() {
            if *w == 1 {
                msg(&mut r, &format!("flip web {i}"));
            }
        }
        assert!(r.flag("web_ok"));
        let ink = r.val("ink").to_vec();
        for (i, k) in ink.iter().enumerate() {
            let by = if *k < GREY { "+1" } else { "-1" };
            for _ in 0..k.abs_diff(GREY) {
                msg(&mut r, &format!("turn ink {i} {by}"));
            }
        }
        assert!(r.flag("ink_ok"));
        msg(&mut r, "use dforme cylinder");
        turn_to(&mut r, "drawer", &MONDAY, 10);
        assert!(!r.flag("drawer_open"), "Monday's ad is a decoy");
        turn_to(&mut r, "drawer", &TUESDAY, 10);
        msg(&mut r, "tap pkey");
        msg(&mut r, "use dpresskey press");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
    }
}
