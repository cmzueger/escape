//! Midnight in Serenissima: carnival night in a city of canals. The golden
//! mask of the carnival is stolen from the stage on the piazza; it must be
//! back before midnight, when the fireworks rise from their barge.
//!
//! A city of twenty places (`SR0` … `SR19`, see `views_city.gd`) walked
//! street by street; the client sends `walk i` on every step, and the rules
//! keep where the player is (`at`) and which places were seen (`seen`), for
//! the map. Close-ups `sr…`. Small games: rings thrown at a turning bottle
//! stand, glass blown when it glows right, a gondola poled through the
//! canals by the boatman's song, rockets lit in the order of the procession.

use crate::bad;
use crate::island::{moved, row, Course};
use crate::kit::{no_extra, Dial, Lock, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;
use crate::set9::{moment, sequence};

/// How many places the city has; the last one is the fireworks barge.
pub const PLACES: u8 = 20;
pub const BARGE: u8 = 19;
/// The colour of the big lantern hanging at each place (0 red, 1 gold,
/// 2 blue, 3 green, 4 violet).
pub const LANTERNS: [u8; 20] = [1, 4, 0, 0, 2, 4, 1, 3, 0, 2, 2, 1, 4, 2, 3, 0, 3, 4, 1, 1];
/// The procession's way on the theatre's poster: places in order.
pub const ROUTE: [u8; 5] = [14, 0, 1, 3, 10];
/// The masks on the mask maker's wall: (colour 0 gold, 1 silver, 2 black;
/// cat's ears; feathers 0 none, 1 green, 2 white).
pub const MASKS: [(u8, bool, u8); 6] = [
    (0, true, 1),
    (1, true, 2),
    (1, true, 1),
    (1, false, 1),
    (2, true, 1),
    (1, true, 0),
];
/// The thief's mask: cat's ears (the calling card), a green feather (the
/// pigeons), pale as the moon (the waiter).
pub const MASK: usize = 2;
/// The casket's symbols (0 book, 1 sword, 2 crown, 3 ball, 4 key, 5 fish),
/// as the Arsenale's lions hold them from left to right.
pub const CASKET: [u8; 4] = [2, 0, 5, 1];
/// The telescope's eight directions: the barge in one, a reveller in a cat
/// mask (the decoy) in another.
pub const SCOPE_BARGE: u8 = 5;
pub const SCOPE_DECOY: u8 = 2;
/// The ring toss: the gold bottle faces you for the last 2 seconds of every
/// 5; three hits, each on another turn of the stand.
pub const TOSS: (u32, u32) = (5, 2);
/// The glass glows like the sunset for the last 2 seconds of every 6.
pub const GLOW: (u32, u32) = (6, 2);
pub const NEED: u8 = 3;
/// The steamer crosses the broad canal for the last 3 seconds of every 7.
pub const STEAMER: (u32, u32) = (7, 3);
pub const STEAMER_CELL: u8 = 20;

/// The canals from the molo to the barge, seen from above (north is up).
pub static CANALS: Course = Course {
    w: 8,
    h: 5,
    blocked: &[
        0, 4, 7, 8, 10, 12, 14, 15, 18, 22, 23, 24, 26, 27, 28, 32, 36, 37, 38,
    ],
    thin: &[],
    start: 16,
    goal: 39,
    drift: (0, 0),
};

fn clues() -> String {
    let masks = MASKS
        .iter()
        .map(|(c, e, f)| format!("[{c},{},{f}]", u8::from(*e)))
        .collect::<Vec<_>>()
        .join(",");
    format!(
        "{{\"ok\":true,\"lanterns\":[{}],\"route\":[{}],\"masks\":[{masks}],\"casket\":[{}],\"scope\":[{SCOPE_BARGE},{SCOPE_DECOY}],\"toss\":[{},{}],\"glow\":[{},{}],\"steamer\":[{},{},{STEAMER_CELL}],\"canals\":{}}}",
        nums_json(&LANTERNS),
        nums_json(&ROUTE),
        nums_json(&CASKET),
        TOSS.0,
        TOSS.1,
        GLOW.0,
        GLOW.1,
        STEAMER.0,
        STEAMER.1,
        CANALS.json()
    )
}

/// The rockets in the order of the procession: each place's lantern colour.
pub fn rockets() -> Vec<u8> {
    ROUTE.iter().map(|p| LANTERNS[usize::from(*p)]).collect()
}

/// A timed game in the dial `dial` = [hits, turn of the last hit]: a tap in
/// the moment counts (once per turn), one outside starts again. Returns the
/// reply's last word: "won", "hit", "again" or "miss".
pub fn timed(s: &mut State, dial: &str, (cycle, show): (u32, u32)) -> &'static str {
    let turn = ((s.secs / cycle) % 250) as u8 + 1;
    let right = moment(s, cycle, show);
    let v = s.val_mut(dial);
    if !right {
        v[0] = 0;
        return "miss";
    }
    if v[1] == turn {
        return "again";
    }
    v[0] += 1;
    v[1] = turn;
    if v[0] >= NEED {
        "won"
    } else {
        "hit"
    }
}

const BOAT_READY: &str = "paid&oar_in&lamp_on";

fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["walk", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < PLACES) {
            None => Err(bad("walk")),
            Some(BARGE) if !s.flag("at_barge") => Ok("srmsg.no_boat".into()),
            Some(p) => {
                s.val_mut("at")[0] = p;
                s.val_mut("seen")[usize::from(p)] = 1;
                Ok(String::new())
            }
        }),
        ["use", "srflame", "srlantern"] | ["use", "srlantern", "srflame"]
            if s.has("srflame") && s.has("srlantern") =>
        {
            s.take("srlantern");
            s.give("srlamp");
            s.set("lamp_lit");
            Some(Ok("srmsg.lamp_lit".into()))
        }
        ["use", "srfeather", spot] if spot.starts_with("mask") && s.has("srfeather") => {
            let i = spot[4..].parse::<usize>().ok().filter(|i| *i < MASKS.len());
            match i {
                None => Some(Err(bad(spot))),
                Some(_) if !s.flag("got_card") => Some(Ok("srmsg.whose_mask".into())),
                Some(MASK) => None,
                Some(_) => Some(Ok("srmsg.not_that_mask".into())),
            }
        }
        ["tap", "thief"] => Some(Ok(if !s.flag("tower_open") {
            String::new()
        } else if s.val("scope")[0] == SCOPE_BARGE {
            s.set("saw_barge");
            "srmsg.saw_thief".into()
        } else {
            "srmsg.nobody_there".into()
        })),
        ["tap", spot] if spot.starts_with("mask") && spot.len() == 5 => Some(Ok("srmsg.mask_look".into())),
        ["tap", "reveller"] => Some(Ok(if s.val("scope")[0] == SCOPE_DECOY {
            "srmsg.reveller".into()
        } else {
            "srmsg.nobody_there".into()
        })),
        ["throw"] => Some(Ok(if s.flag("got_coin") {
            "srmsg.toss_done".into()
        } else {
            match timed(s, "rings", TOSS) {
                "won" => {
                    s.set("got_coin");
                    s.give("srcoin");
                    "srmsg.toss_won".into()
                }
                "hit" => "srmsg.toss_hit".into(),
                "again" => "srmsg.toss_wait".into(),
                _ => "srmsg.toss_miss".into(),
            }
        })),
        ["blow"] => Some(Ok(if s.flag("got_lantern") {
            "srmsg.glass_done".into()
        } else {
            match timed(s, "glass", GLOW) {
                "won" => {
                    s.set("got_lantern");
                    s.give("srlantern");
                    "srmsg.glass_won".into()
                }
                "hit" => "srmsg.glass_hit".into(),
                "again" => "srmsg.glass_wait".into(),
                _ => "srmsg.glass_miss".into(),
            }
        })),
        ["pole", d] => Some(match crate::island::dir(d) {
            None => Err(bad("pole")),
            Some(_) if !s.flag(BOAT_READY) => Ok("srmsg.boat_not_ready".into()),
            Some(_) if s.flag("at_barge") => Ok(String::new()),
            Some(dv) => {
                let at = s.val("boat")[0];
                let x = (at % CANALS.w) as i8 + dv.0;
                let y = (at / CANALS.w) as i8 + dv.1;
                let into = (y * CANALS.w as i8 + x) as u8;
                let inside = x >= 0 && y >= 0 && x < CANALS.w as i8 && y < CANALS.h as i8;
                if inside && into == STEAMER_CELL && moment(s, STEAMER.0, STEAMER.1) {
                    s.val_mut("boat")[0] = CANALS.start;
                    Ok("srmsg.steamer".into())
                } else {
                    let m = row(s, "boat", &CANALS, dv);
                    if s.val("boat")[0] == CANALS.goal {
                        s.set("at_barge");
                    }
                    moved(m, "sr", "gondola")
                }
            }
        }),
        ["rocket", i] => Some(match i.parse::<u8>().ok().filter(|i| *i < 5) {
            None => Err(bad("rocket")),
            Some(_) if !s.flag("mask_raised") => Ok("srmsg.mask_first".into()),
            Some(_) if !s.has("srflame") => Ok("srmsg.no_flame".into()),
            Some(_) if !s.flag("foyer_open") => Ok("srmsg.which_order".into()),
            Some(r) => match sequence(s, "launched", &rockets(), r) {
                (true, _) => {
                    s.set("done");
                    Ok("srmsg.finale".into())
                }
                (false, true) => Ok("srmsg.rocket_up".into()),
                (false, false) => Ok("srmsg.rocket_wrong".into()),
            },
        }),
        _ => None,
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 16;

const fn never(name: &'static str, size: u8, start: &'static [u8]) -> Dial {
    Dial {
        name,
        size,
        start,
        wrap: false,
        needs: "never",
        needs_msg: "",
        freeze: "",
    }
}

pub static SPEC: Spec = Spec {
    id: "carnival",
    prefix: "sr",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_card",
        "got_ticket",
        "foyer_open",
        "got_coffee",
        "got_bellkey",
        "tower_open",
        "saw_barge",
        "got_bread",
        "got_feather",
        "got_slip",
        "court_open",
        "casket_open",
        "got_cratekey",
        "got_coin",
        "got_taper",
        "lit_taper",
        "got_lantern",
        "lamp_lit",
        "got_oar",
        "paid",
        "oar_in",
        "lamp_on",
        "at_barge",
        "got_mask",
        "mask_raised",
        "done",
    ],
    items: &[
        "srticket",
        "srcoffee",
        "srbellkey",
        "srbread",
        "srfeather",
        "srslip",
        "srcratekey",
        "srcoin",
        "srtaper",
        "srflame",
        "srlantern",
        "srlamp",
        "sroar",
        "srmask",
    ],
    locks: &[Lock {
        name: "casket",
        size: 6,
        start: &[0, 0, 0, 0],
        code: || CASKET.to_vec(),
        flag: "casket_open",
        msg: "srmsg.casket_open",
        needs: "court_open",
    }],
    dials: &[
        never("at", PLACES, &[0]),
        never(
            "seen",
            2,
            &[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        ),
        Dial {
            name: "scope",
            size: 8,
            start: &[0],
            wrap: true,
            needs: "tower_open",
            needs_msg: "srmsg.tower_locked",
            freeze: "",
        },
        never("rings", 251, &[0, 0]),
        never("glass", 251, &[0, 0]),
        never("boat", 40, &[16]),
        never("launched", 6, &[0]),
    ],
    picks: &[
        Pick {
            spot: "cushion",
            needs: "",
            locked_msg: "",
            got: "got_card",
            give: &[],
            msg: "srmsg.card_found",
        },
        Pick {
            spot: "ticket",
            needs: "",
            locked_msg: "",
            got: "got_ticket",
            give: &["srticket"],
            msg: "srmsg.ticket",
        },
        Pick {
            spot: "cup",
            needs: "",
            locked_msg: "",
            got: "got_coffee",
            give: &["srcoffee"],
            msg: "srmsg.coffee",
        },
        Pick {
            spot: "baker",
            needs: "",
            locked_msg: "",
            got: "got_bread",
            give: &["srbread"],
            msg: "srmsg.bread",
        },
        Pick {
            spot: "tapers",
            needs: "",
            locked_msg: "",
            got: "got_taper",
            give: &["srtaper"],
            msg: "srmsg.taper",
        },
        Pick {
            spot: "casketkey",
            needs: "casket_open",
            locked_msg: "srmsg.casket_locked",
            got: "got_cratekey",
            give: &["srcratekey"],
            msg: "srmsg.cratekey",
        },
        Pick {
            spot: "oars",
            needs: "",
            locked_msg: "",
            got: "got_oar",
            give: &["sroar"],
            msg: "srmsg.oar",
        },
    ],
    uses: &[
        Use {
            item: "srticket",
            spot: "doorman",
            needs: "",
            fail: "",
            keep: false,
            set: "foyer_open",
            give: &[],
            msg: "srmsg.foyer_open",
        },
        Use {
            item: "srcoffee",
            spot: "ringer",
            needs: "",
            fail: "",
            keep: false,
            set: "got_bellkey",
            give: &["srbellkey"],
            msg: "srmsg.bellkey",
        },
        Use {
            item: "srbellkey",
            spot: "towerdoor",
            needs: "",
            fail: "",
            keep: false,
            set: "tower_open",
            give: &[],
            msg: "srmsg.tower_open",
        },
        Use {
            item: "srbread",
            spot: "pigeons",
            needs: "",
            fail: "",
            keep: false,
            set: "got_feather",
            give: &["srfeather"],
            msg: "srmsg.feather",
        },
        Use {
            item: "srfeather",
            spot: "mask2",
            needs: "got_card",
            fail: "srmsg.whose_mask",
            keep: false,
            set: "got_slip",
            give: &["srslip"],
            msg: "srmsg.slip",
        },
        Use {
            item: "srslip",
            spot: "porter",
            needs: "",
            fail: "",
            keep: false,
            set: "court_open",
            give: &[],
            msg: "srmsg.court_open",
        },
        Use {
            item: "srtaper",
            spot: "candles",
            needs: "",
            fail: "",
            keep: false,
            set: "lit_taper",
            give: &["srflame"],
            msg: "srmsg.flame",
        },
        Use {
            item: "srcoin",
            spot: "gondolier",
            needs: "saw_barge",
            fail: "srmsg.where_to",
            keep: false,
            set: "paid",
            give: &[],
            msg: "srmsg.paid",
        },
        Use {
            item: "sroar",
            spot: "gondola",
            needs: "",
            fail: "",
            keep: false,
            set: "oar_in",
            give: &[],
            msg: "srmsg.oar_in",
        },
        Use {
            item: "srlamp",
            spot: "gondola",
            needs: "",
            fail: "",
            keep: false,
            set: "lamp_on",
            give: &[],
            msg: "srmsg.lamp_on",
        },
        Use {
            item: "srcratekey",
            spot: "crate",
            needs: "at_barge",
            fail: "",
            keep: false,
            set: "got_mask",
            give: &["srmask"],
            msg: "srmsg.mask_found",
        },
        Use {
            item: "srmask",
            spot: "pole",
            needs: "at_barge",
            fail: "",
            keep: false,
            set: "mask_raised",
            give: &[],
            msg: "srmsg.mask_raised",
        },
    ],
    checks: &[],
    looks: &[],
    flavour: &[
        "pigeons",
        "pigeonlady",
        "basilica",
        "lioncolumn",
        "crowd",
        "lantern",
        "card",
        "clockface",
        "moors",
        "plaque",
        "towerdoor",
        "view",
        "gondolier",
        "gondola",
        "lagoon",
        "song",
        "waiter",
        "musicians",
        "chairs",
        "maker",
        "shops",
        "bridgeboats",
        "fish",
        "fruit",
        "glassblower",
        "sign",
        "books",
        "bookcat",
        "bookseller",
        "lions",
        "gate",
        "well",
        "children",
        "barker",
        "laundry",
        "singer",
        "ringer",
        "candles",
        "portal",
        "doorman",
        "posters",
        "poster",
        "boatbuilder",
        "hull",
        "porter",
        "balcony",
        "diary",
        "cat",
        "passage",
        "shrine",
        "fishermen",
        "barge",
        "crate",
        "pole",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_card"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_ticket"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("foyer_open"),
            available: |s| s.flag("got_ticket"),
        },
        Puzzle {
            solved: |s| s.flag("got_coffee"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_bellkey"),
            available: |s| s.flag("got_coffee"),
        },
        Puzzle {
            solved: |s| s.flag("tower_open"),
            available: |s| s.flag("got_bellkey"),
        },
        Puzzle {
            solved: |s| s.flag("saw_barge"),
            available: |s| s.flag("tower_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_bread"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_feather"),
            available: |s| s.flag("got_bread"),
        },
        Puzzle {
            solved: |s| s.flag("got_slip"),
            available: |s| s.flag("got_feather&got_card"),
        },
        Puzzle {
            solved: |s| s.flag("court_open"),
            available: |s| s.flag("got_slip"),
        },
        Puzzle {
            solved: |s| s.flag("got_cratekey"),
            available: |s| s.flag("court_open"),
        },
        Puzzle {
            solved: |s| s.flag("got_coin"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("got_taper"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lit_taper"),
            available: |s| s.flag("got_taper"),
        },
        Puzzle {
            solved: |s| s.flag("got_lantern"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("lamp_lit"),
            available: |s| s.flag("got_lantern&lit_taper"),
        },
        Puzzle {
            solved: |s| s.flag("got_oar"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag(BOAT_READY),
            available: |s| s.flag("saw_barge&got_coin&got_oar&lamp_lit"),
        },
        Puzzle {
            solved: |s| s.flag("at_barge"),
            available: |s| s.flag(BOAT_READY),
        },
        Puzzle {
            solved: |s| s.flag("got_mask"),
            available: |s| s.flag("at_barge&got_cratekey"),
        },
        Puzzle {
            solved: |s| s.flag("mask_raised"),
            available: |s| s.flag("got_mask"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("mask_raised&foyer_open&lit_taper"),
        },
    ],
    hint_views: &[
        ("SR0", &[0, 8, 9]),
        ("srstage", &[0, 9]),
        ("SR1", &[6]),
        ("SR2", &[5, 6]),
        ("srtop", &[6]),
        ("SR3", &[18, 19]),
        ("srsong", &[19]),
        ("srlagoon", &[19]),
        ("SR4", &[3, 1, 9]),
        ("srcafe", &[1]),
        ("SR5", &[9]),
        ("srmasks", &[9]),
        ("SR6", &[10]),
        ("SR7", &[7]),
        ("SR8", &[15, 16]),
        ("srglass", &[15]),
        ("SR9", &[11]),
        ("SR10", &[11]),
        ("SR11", &[12]),
        ("srtoss", &[12]),
        ("SR12", &[15]),
        ("SR13", &[4, 13, 14]),
        ("SR14", &[2, 22]),
        ("srfoyer", &[22]),
        ("SR15", &[17]),
        ("SR16", &[10, 11]),
        ("srcourt", &[11]),
        ("srcasket", &[11]),
        ("SR17", &[6]),
        ("SR18", &[19, 20]),
        ("SR19", &[20, 21, 22]),
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

    /// Waits for a moment and taps three times, each on another turn.
    fn play_timed(r: &mut State, cmd: &str, (cycle, show): (u32, u32), from: u32) -> u32 {
        let mut t = from;
        for _ in 0..NEED {
            t = (t / cycle + 1) * cycle + cycle - show;
            msg(r, &format!("time {t}"));
            msg(r, cmd);
        }
        t
    }

    #[test]
    fn the_mask_comes_home() {
        let mut r = State::new(&SPEC);
        assert_eq!(msg(&mut r, "walk 19"), "srmsg.no_boat");
        msg(&mut r, "walk 4");
        assert_eq!(r.val("at"), &[4]);
        assert_eq!(r.val("seen")[4], 1);
        msg(&mut r, "tap cushion");
        msg(&mut r, "tap ticket");
        msg(&mut r, "use srticket doorman");
        msg(&mut r, "tap cup");
        msg(&mut r, "use srcoffee ringer");
        msg(&mut r, "use srbellkey towerdoor");
        turn_to(&mut r, "scope", &[SCOPE_DECOY], 8);
        assert_eq!(msg(&mut r, "tap thief"), "srmsg.nobody_there");
        turn_to(&mut r, "scope", &[SCOPE_BARGE], 8);
        msg(&mut r, "tap thief");
        assert!(r.flag("saw_barge"));
        msg(&mut r, "tap baker");
        msg(&mut r, "use srbread pigeons");
        assert_eq!(msg(&mut r, "use srfeather mask1"), "srmsg.not_that_mask");
        msg(&mut r, &format!("use srfeather mask{MASK}"));
        msg(&mut r, "use srslip porter");
        turn_to(&mut r, "casket", &CASKET, 6);
        msg(&mut r, "tap casketkey");
        // A miss starts the rings again; a second hit on the same turn
        // does not count.
        msg(&mut r, "time 1");
        assert_eq!(msg(&mut r, "throw"), "srmsg.toss_miss");
        msg(&mut r, "time 4");
        assert_eq!(msg(&mut r, "throw"), "srmsg.toss_hit");
        assert_eq!(msg(&mut r, "throw"), "srmsg.toss_wait");
        let t = play_timed(&mut r, "throw", TOSS, 5);
        assert!(r.has("srcoin"));
        msg(&mut r, "tap tapers");
        msg(&mut r, "use srtaper candles");
        let t = play_timed(&mut r, "blow", GLOW, t);
        msg(&mut r, "use srlantern srflame");
        assert!(r.has("srlamp") && r.has("srflame"));
        msg(&mut r, "tap oars");
        msg(&mut r, "use srcoin gondolier");
        msg(&mut r, "use sroar gondola");
        msg(&mut r, "use srlamp gondola");
        // Into a wall: back to the molo.
        assert_eq!(msg(&mut r, "pole w"), "srmsg.gondola_back");
        // The steamer on the broad canal sends the gondola back too.
        let mut t = (t / STEAMER.0 + 2) * STEAMER.0;
        for d in ["e", "n", "n", "e", "e", "s", "s"] {
            msg(&mut r, &format!("pole {d}"));
        }
        msg(&mut r, &format!("time {}", t + STEAMER.0 - 1));
        assert_eq!(msg(&mut r, "pole e"), "srmsg.steamer");
        for d in ["e", "n", "n", "e", "e", "s", "s"] {
            msg(&mut r, &format!("pole {d}"));
        }
        t += STEAMER.0;
        msg(&mut r, &format!("time {t}"));
        for d in ["e", "e", "s", "e", "e"] {
            msg(&mut r, &format!("pole {d}"));
        }
        assert_eq!(msg(&mut r, "pole s"), "srmsg.gondola_there");
        assert!(r.flag("at_barge"));
        msg(&mut r, "walk 19");
        msg(&mut r, "use srcratekey crate");
        msg(&mut r, "use srmask pole");
        let order = rockets();
        assert_eq!(msg(&mut r, &format!("rocket {}", order[1])), "srmsg.rocket_wrong");
        for k in order {
            msg(&mut r, &format!("rocket {k}"));
        }
        assert!(r.done && r.solved().iter().all(|s| *s));
    }

    #[test]
    fn the_procession_needs_five_colours() {
        let mut order = rockets();
        order.sort();
        assert_eq!(order, vec![0, 1, 2, 3, 4]);
    }
}
