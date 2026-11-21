//! Night Train (medium): a sealed sleeping compartment, six puzzles.
//! Views: `N1` (seats, luggage rack, window) and `N2` (table, panel, door).

use crate::kit::{Check, Dial, Lock, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::{bad, nums_json, strs_json};

/// The stations of the line in order, each with its sign and the time the
/// train leaves it (hour, minute).
pub const LINE: [(&str, u8, u8); 5] = [
    ("lake", 6, 15),
    ("bridge", 6, 58),
    ("tower", 7, 42),
    ("mill", 8, 27),
    ("peak", 9, 5),
];
/// The sign on the suitcase's tag: its lock is that station's time.
pub const TAG: &str = "tower";
/// The ticket: seat number and the journey (from, to).
pub const SEATS: [u8; 4] = [21, 22, 23, 24];
pub const SEAT: u8 = 23;
pub const JOURNEY: (&str, &str) = ("bridge", "peak");
/// The holes the conductor's punch makes, row by row (three by three).
pub const PUNCH: [u8; 9] = [1, 0, 1, 0, 1, 0, 1, 1, 0];

fn case_code() -> Vec<u8> {
    let (_, h, m) = LINE
        .iter()
        .find(|(s, _, _)| *s == TAG)
        .expect("the tag's station");
    vec![*h, m / 10, m % 10]
}

/// The briefcase's wheels: the stations of the journey in order, as their
/// places on the line.
pub fn brief_code() -> Vec<u8> {
    let at = |name: &str| LINE.iter().position(|(s, _, _)| *s == name).expect("a station");
    (at(JOURNEY.0)..=at(JOURNEY.1)).map(|i| i as u8).collect()
}

fn clues() -> String {
    let line = LINE
        .iter()
        .map(|(s, h, m)| format!("{{\"sign\":\"{s}\",\"h\":{h},\"m\":{m}}}"))
        .collect::<Vec<_>>();
    format!(
        "{{\"ok\":true,\"line\":[{}],\"tag\":\"{TAG}\",\"seats\":[{}],\"seat\":{SEAT},\"journey\":[{}],\"punch\":[{}]}}",
        line.join(","),
        nums_json(&SEATS),
        strs_json(&[JOURNEY.0, JOURNEY.1]),
        nums_json(&PUNCH)
    )
}

fn extra(s: &State) -> String {
    format!(",\"seat_up\":{}", s.flag("seat_up"))
}

/// `seat <0..3>`: lifts a seat; only the ticket's seat hides something.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    if words[0] != "seat" {
        return None;
    }
    Some(
        match words
            .get(1)
            .and_then(|w| w.parse::<usize>().ok())
            .filter(|i| *i < SEATS.len())
        {
            None => Err(bad("seat")),
            Some(_) if s.flag("seat_up") => Ok("nmsg.nothing".into()),
            Some(i) if SEATS[i] == SEAT && s.flag("got_case") => {
                s.set("seat_up");
                Ok("nmsg.seat_up".into())
            }
            Some(_) => Ok("nmsg.seat_empty".into()),
        },
    )
}

/// Minutes for three stars (set from the owner's play tests, 2026-11-17).
pub const PAR_MINUTES: u32 = 4;

pub static SPEC: Spec = Spec {
    id: "train",
    prefix: "n",
    par_minutes: PAR_MINUTES,
    flags: &[
        "case_open",
        "got_case",
        "seat_up",
        "brief_open",
        "got_brief",
        "punched",
        "panel_open",
        "handle_in",
        "done",
    ],
    items: &["punch", "brake"],
    locks: &[
        Lock {
            name: "case",
            size: 10,
            start: &[0, 0, 0],
            code: case_code,
            flag: "case_open",
            msg: "nmsg.case_open",
            needs: "",
        },
        Lock {
            name: "brief",
            size: 5,
            start: &[0, 0, 0, 0],
            code: brief_code,
            flag: "brief_open",
            msg: "nmsg.brief_open",
            needs: "seat_up",
        },
    ],
    dials: &[Dial {
        name: "panel",
        size: 2,
        start: &[0, 0, 0, 0, 0, 0, 0, 0, 0],
        wrap: true,
        needs: "",
        needs_msg: "",
        freeze: "panel_open",
    }],
    picks: &[
        Pick {
            spot: "suitcase",
            needs: "case_open",
            locked_msg: "nmsg.case_locked",
            got: "got_case",
            give: &["punch"],
            msg: "nmsg.case_take",
        },
        Pick {
            spot: "briefcase",
            needs: "brief_open",
            locked_msg: "nmsg.brief_locked",
            got: "got_brief",
            give: &["brake"],
            msg: "nmsg.handle",
        },
    ],
    uses: &[
        Use {
            item: "punch",
            spot: "ticket",
            needs: "",
            fail: "",
            keep: false,
            set: "punched",
            give: &[],
            msg: "nmsg.punched",
        },
        Use {
            item: "brake",
            spot: "socket|panel",
            needs: "panel_open",
            fail: "nmsg.no_socket",
            keep: false,
            set: "handle_in",
            give: &[],
            msg: "nmsg.handle_in",
        },
    ],
    checks: &[
        Check {
            flag: "panel_open",
            cond: |s| s.flag("punched") && s.val("panel") == PUNCH,
            msg: "nmsg.panel_open",
        },
        Check {
            flag: "done",
            cond: |s| s.flag("handle_in"),
            msg: "nmsg.handle_in",
        },
    ],
    looks: &[
        Look {
            spot: "door",
            flag: "",
            set: "nmsg.door",
            unset: "nmsg.door",
        },
        Look {
            spot: "socket",
            flag: "panel_open",
            set: "nmsg.socket",
            unset: "nmsg.panel",
        },
    ],
    flavour: &["window", "lamp", "coat", "blind", "bags", "ticket"],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("case_open"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("seat_up"),
            available: |s| s.flag("got_case"),
        },
        Puzzle {
            solved: |s| s.flag("brief_open"),
            available: |s| s.flag("seat_up"),
        },
        Puzzle {
            solved: |s| s.flag("punched"),
            available: |s| s.flag("got_case"),
        },
        Puzzle {
            solved: |s| s.flag("panel_open"),
            available: |s| s.flag("punched"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("got_brief"),
        },
    ],
    hint_views: &[
        ("N1", &[0, 1, 2]),
        ("N2", &[3, 4, 5, 0]),
        ("ncase", &[0]),
        ("timetable", &[0, 2]),
        ("nticket", &[1, 2, 3]),
        ("nbrief", &[2]),
        ("npanel", &[4, 5]),
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
    fn the_compartment_opens() {
        let mut r = State::new(&SPEC);
        assert_eq!(case_code(), [7, 4, 2]);
        assert_eq!(msg(&mut r, "seat 2"), "nmsg.seat_empty");
        turn_to(&mut r, "case", &case_code(), 10);
        msg(&mut r, "tap suitcase");
        assert_eq!(msg(&mut r, "seat 0"), "nmsg.seat_empty");
        assert_eq!(brief_code(), [1, 2, 3, 4]);
        turn_to(&mut r, "brief", &brief_code(), 5);
        assert!(!r.flag("brief_open"), "the briefcase is still under the seat");
        msg(&mut r, "turn brief 0 +1");
        assert_eq!(msg(&mut r, "seat 2"), "nmsg.seat_up");
        assert_eq!(msg(&mut r, "turn brief 0 -1"), "nmsg.brief_open");
        msg(&mut r, "tap briefcase");
        assert_eq!(msg(&mut r, "use brake socket"), "nmsg.no_socket");
        assert_eq!(msg(&mut r, "use punch ticket"), "nmsg.punched");
        for (i, hole) in PUNCH.iter().enumerate() {
            if *hole == 1 {
                msg(&mut r, &format!("flip panel {i}"));
            }
        }
        assert!(r.flag("panel_open"));
        msg(&mut r, "use brake socket");
        assert!(r.done && r.solved().iter().all(|s| *s));
        assert_eq!(State::load(&SPEC, &r.save()).unwrap(), r);
    }
}
