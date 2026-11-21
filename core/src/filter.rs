//! The Filter Hall (hard): a Victorian pumping station, 1898, during the
//! opening ceremony. Twelve puzzles. Views: `WA1` (the engine hall: coal,
//! firebox, boiler, levers, governor, speaking tube, the district valve
//! board) and `WA2` (the filter hall: risers, the filter tank, the pipe wall,
//! the ceremony table, the window onto the square and its fountain).
//!
//! Water is simulated: the pipe wall's tiles carry it from the engine hall's
//! pipe to the fountain main; the fountain's jets follow the engine's speed
//! (engine hall) times each jet's valve (filter hall).

use crate::bad;
use crate::house::{lines_json, talk, Line};
use crate::kit::{Check, Dial, Look, Pick, Puzzle, Reply, Spec, State, Use};
use crate::nums_json;

/// The boiler's feed valve: the water glass reads right at this mark.
pub const FEED: u8 = 5;
/// The engine's three levers on screen (throttle, steam, drains) and the
/// order the engineer gives: steam, drains, throttle.
pub const LEVERS: u8 = 3;
pub const START: [u8; 3] = [1, 2, 0];
/// The riser with the air lock (of three).
pub const KNOCK: u8 = 2;
/// Filter layers poured bottom first (1 gravel, 2 sand, 3 charcoal); the
/// water passes gravel, then sand, then charcoal, so charcoal goes in first.
pub const LAYERS: [u8; 3] = [3, 2, 1];
/// District valves: harbour, market, hill, mill, station, square.
pub const DISTRICTS: [u8; 6] = [0, 0, 1, 1, 0, 1];
/// The fountain's jets: heights are speed (1 to 3) times each valve (0 to
/// 3); the programme shows 2, 6, 2.
pub const SPEED: u8 = 1;
pub const JETS: [u8; 3] = [1, 3, 1];
pub const DESIGN: [u8; 3] = [2, 6, 2];
/// The mayor raises his glass for the last `TOAST` seconds of every `CYCLE`.
pub const CYCLE: u32 = 15;
pub const TOAST: u32 = 4;

/// Pipe tiles, row by row: 0 none, 1 straight, 2 elbow, 3 tee, 4 the filter
/// tank (fixed, west and south), 5 the socket (an elbow once filled).
pub const TILES: [u8; 16] = [1, 2, 3, 2, 1, 3, 4, 0, 2, 0, 5, 2, 3, 0, 0, 1];
pub const ROT_START: [u8; 16] = [1, 3, 2, 1, 0, 1, 0, 0, 2, 0, 2, 3, 1, 0, 0, 1];
pub const FILTER_TILE: usize = 6;
pub const SOCKET_TILE: usize = 10;
/// Water enters the top left tile from the west and leaves the bottom
/// right one to the south.
const N: u8 = 1;
const E: u8 = 2;
const S: u8 = 4;
const W: u8 = 8;

fn rotate(mask: u8, r: u8) -> u8 {
    let mut m = mask;
    for _ in 0..r % 4 {
        m = ((m << 1) | (m >> 3)) & 15;
    }
    m
}

/// The openings of tile `i` as it stands.
pub fn openings(s: &State, i: usize) -> u8 {
    let r = s.val("pipes")[i];
    match TILES[i] {
        1 => rotate(N | S, r),
        2 => rotate(N | E, r),
        3 => rotate(N | E | S, r),
        4 => W | S,
        5 if s.flag("socket_in") => rotate(N | E, r),
        _ => 0,
    }
}

/// The tiles water reaches from the inlet (pumped only once the engine
/// runs and the air lock is out), and whether it leaves to the fountain.
pub fn flow(s: &State) -> (Vec<bool>, bool) {
    let mut wet = vec![false; 16];
    if !s.flag("engine_on") || !s.flag("air_out") {
        return (wet, false);
    }
    let mut todo = vec![(0usize, W)];
    let mut out = false;
    while let Some((i, from)) = todo.pop() {
        let o = openings(s, i);
        if o & from == 0 || wet[i] {
            continue;
        }
        wet[i] = true;
        let (r, c) = (i / 4, i % 4);
        if i == 15 && o & S != 0 {
            out = true;
        }
        if o & N != 0 && r > 0 {
            todo.push((i - 4, S));
        }
        if o & S != 0 && r < 3 {
            todo.push((i + 4, N));
        }
        if o & E != 0 && c < 3 {
            todo.push((i + 1, W));
        }
        if o & W != 0 && c > 0 {
            todo.push((i - 1, E));
        }
    }
    (wet, out)
}

pub fn heights(s: &State) -> Vec<u8> {
    let speed = s.val("speed")[0] + 1;
    s.val("jets").iter().map(|v| v * speed).collect()
}

pub static LINES: [Line; 3] = [
    Line {
        text: "watalk.1",
        choices: &[("wasay.1a", 0), ("wasay.1b", 2), ("wasay.1c", 0)],
        sets: "",
    },
    Line {
        text: "watalk.2",
        choices: &[("wasay.2a", 0), ("wasay.2b", 0), ("wasay.2c", 3)],
        sets: "",
    },
    Line {
        text: "watalk.3",
        choices: &[("wasay.3a", 0)],
        sets: "told",
    },
];

fn clues() -> String {
    format!(
        "{{\"ok\":true,\"feed\":{FEED},\"tiles\":[{}],\"design\":[{}],\"cycle\":{CYCLE},\"toast\":{TOAST},\"lines\":[{}]}}",
        nums_json(&TILES),
        nums_json(&DESIGN),
        lines_json(&LINES)
    )
}

fn extra(s: &State) -> String {
    let (wet, out) = flow(s);
    let wet: Vec<u8> = wet.iter().map(|w| u8::from(*w)).collect();
    format!(
        ",\"wet\":[{}],\"out\":{out},\"heights\":[{}]",
        nums_json(&wet),
        nums_json(&heights(s))
    )
}

fn index(word: &str, n: u8) -> Option<u8> {
    word.parse::<u8>().ok().filter(|i| *i < n)
}

/// Levers, bleed valves, the filter's layer bins and test tap, the main
/// valve, and the speaking tube.
fn hook(s: &mut State, words: &[&str]) -> Option<Reply> {
    match words {
        ["lever", i] => Some(match index(i, LEVERS) {
            None => Err(bad("lever")),
            Some(_) if s.flag("engine_on") => Ok("wamsg.engine_runs".into()),
            Some(_) if !s.flag("told") => Ok("wamsg.lever_stiff".into()),
            Some(l) => {
                let at = usize::from(s.val("start")[0]);
                if START[at] == l {
                    s.val_mut("start")[0] += 1;
                    if at + 1 == START.len() {
                        s.set("engine_on");
                        Ok("wamsg.engine_on".into())
                    } else {
                        Ok("wamsg.lever".into())
                    }
                } else {
                    s.val_mut("start")[0] = 0;
                    Ok("wamsg.stall".into())
                }
            }
        }),
        ["bleed", i] => Some(match index(i, 3) {
            None => Err(bad("bleed")),
            Some(_) if !s.flag("engine_on") => Ok("wamsg.bleed_dry".into()),
            Some(_) if s.flag("air_out") => Ok("wamsg.bleed_water".into()),
            Some(KNOCK) => {
                s.set("air_out");
                Ok("wamsg.air_out".into())
            }
            Some(_) => Ok("wamsg.bleed_water".into()),
        }),
        ["layer", i] => Some(match index(i, 3) {
            None => Err(bad("layer")),
            Some(_) if s.flag("filter_ok") => Ok("wamsg.filter_done".into()),
            Some(l) => {
                let tank = s.val_mut("layers");
                match tank.iter().position(|v| *v == 0) {
                    Some(at) => {
                        tank[at] = l + 1;
                        Ok("wamsg.poured".into())
                    }
                    None => Ok("wamsg.tank_full".into()),
                }
            }
        }),
        ["empty"] => {
            if !s.flag("filter_ok") {
                s.val_mut("layers").iter_mut().for_each(|v| *v = 0);
            }
            Some(Ok("wamsg.emptied".into()))
        }
        ["test"] => Some(Ok(if s.flag("filter_ok") {
            "wamsg.clear".into()
        } else if !s.flag("engine_on") {
            "wamsg.test_dry".into()
        } else if s.val("layers").contains(&0) {
            "wamsg.tank_short".into()
        } else if s.val("layers") == LAYERS {
            s.set("filter_ok");
            "wamsg.clear".into()
        } else {
            "wamsg.muddy".into()
        })),
        ["tap", "mainvalve"] => Some(Ok(if !s.flag("jets_ok") {
            "wamsg.main_wait".into()
        } else if s.secs % CYCLE >= CYCLE - TOAST {
            s.set("done");
            "wamsg.fountain".into()
        } else {
            "wamsg.not_yet".into()
        })),
        _ => talk(s, words, &LINES, "boiler_ok", "wa"),
    }
}

/// Minutes for three stars: set by `tools/knowledge.py targets --write` (0.8 times the learned model's prediction).
pub const PAR_MINUTES: u32 = 21;

pub static SPEC: Spec = Spec {
    id: "filter",
    prefix: "wa",
    par_minutes: PAR_MINUTES,
    flags: &[
        "got_spanner",
        "firebox_open",
        "got_matches",
        "fire",
        "boiler_ok",
        "told",
        "engine_on",
        "air_out",
        "filter_ok",
        "got_horn",
        "socket_in",
        "districts_ok",
        "net_ok",
        "jets_ok",
        "done",
    ],
    items: &["waspanner", "wamatches", "wahorn"],
    locks: &[],
    dials: &[
        Dial {
            name: "feed",
            size: 9,
            start: &[0],
            wrap: false,
            needs: "fire",
            needs_msg: "wamsg.feed_cold",
            freeze: "boiler_ok",
        },
        Dial {
            name: "start",
            size: 4,
            start: &[0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "layers",
            size: 4,
            start: &[0, 0, 0],
            wrap: false,
            needs: "never",
            needs_msg: "",
            freeze: "",
        },
        Dial {
            name: "districts",
            size: 2,
            start: &[1, 1, 0, 0, 1, 0],
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "net_ok",
        },
        Dial {
            name: "pipes",
            size: 4,
            start: &ROT_START,
            wrap: true,
            needs: "",
            needs_msg: "",
            freeze: "net_ok",
        },
        Dial {
            name: "speed",
            size: 3,
            start: &[0],
            wrap: false,
            needs: "engine_on",
            needs_msg: "wamsg.governor_still",
            freeze: "",
        },
        Dial {
            name: "jets",
            size: 4,
            start: &[0, 0, 0],
            wrap: false,
            needs: "",
            needs_msg: "",
            freeze: "",
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
    picks: &[
        Pick {
            spot: "coal",
            needs: "",
            locked_msg: "",
            got: "got_spanner",
            give: &["waspanner"],
            msg: "wamsg.spanner",
        },
        Pick {
            spot: "matchtin",
            needs: "",
            locked_msg: "",
            got: "got_matches",
            give: &["wamatches"],
            msg: "wamsg.matches",
        },
        Pick {
            spot: "horn",
            needs: "",
            locked_msg: "",
            got: "got_horn",
            give: &["wahorn"],
            msg: "wamsg.horn",
        },
    ],
    uses: &[
        Use {
            item: "waspanner",
            spot: "firebox",
            needs: "",
            fail: "",
            keep: false,
            set: "firebox_open",
            give: &[],
            msg: "wamsg.firebox_open",
        },
        Use {
            item: "wamatches",
            spot: "firebox",
            needs: "firebox_open",
            fail: "wamsg.firebox_shut",
            keep: false,
            set: "fire",
            give: &[],
            msg: "wamsg.fire",
        },
        Use {
            item: "wahorn",
            spot: "socket",
            needs: "",
            fail: "",
            keep: false,
            set: "socket_in",
            give: &[],
            msg: "wamsg.socket_in",
        },
    ],
    checks: &[
        Check {
            flag: "boiler_ok",
            cond: |s| s.flag("fire") && s.val("feed")[0] == FEED,
            msg: "wamsg.boiler_ok",
        },
        Check {
            flag: "districts_ok",
            cond: |s| s.val("districts") == DISTRICTS,
            msg: "",
        },
        Check {
            flag: "net_ok",
            cond: |s| {
                let (wet, out) = flow(s);
                out && wet[FILTER_TILE] && s.flag("filter_ok&socket_in&districts_ok")
            },
            msg: "wamsg.net_ok",
        },
        Check {
            flag: "jets_ok",
            cond: |s| s.flag("net_ok") && heights(s) == DESIGN,
            msg: "wamsg.jets_ok",
        },
    ],
    looks: &[
        Look {
            spot: "firebox",
            flag: "fire",
            set: "wamsg.firebox_burns",
            unset: "wamsg.firebox",
        },
        Look {
            spot: "window",
            flag: "jets_ok",
            set: "wamsg.window_jets",
            unset: "wamsg.window",
        },
    ],
    flavour: &[
        "governor",
        "boiler",
        "programme",
        "plaque",
        "notes",
        "risers",
        "tank",
        "pipes",
        "socket",
        "table",
        "speech",
        "flag",
        "engine",
        "door",
        "board",
        "bins",
        "desk",
    ],
    puzzles: &[
        Puzzle {
            solved: |s| s.flag("got_spanner"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("fire"),
            available: |s| s.flag("got_spanner"),
        },
        Puzzle {
            solved: |s| s.flag("boiler_ok"),
            available: |s| s.flag("fire"),
        },
        Puzzle {
            solved: |s| s.flag("told"),
            available: |s| s.flag("boiler_ok"),
        },
        Puzzle {
            solved: |s| s.flag("engine_on"),
            available: |s| s.flag("told"),
        },
        Puzzle {
            solved: |s| s.flag("air_out"),
            available: |s| s.flag("engine_on"),
        },
        Puzzle {
            solved: |s| s.flag("filter_ok"),
            available: |s| s.flag("engine_on"),
        },
        Puzzle {
            solved: |s| s.flag("socket_in"),
            available: |s| s.flag("got_horn"),
        },
        Puzzle {
            solved: |s| s.flag("districts_ok"),
            available: |_| true,
        },
        Puzzle {
            solved: |s| s.flag("net_ok"),
            available: |s| s.flag("air_out&filter_ok&socket_in&districts_ok"),
        },
        Puzzle {
            solved: |s| s.flag("jets_ok"),
            available: |s| s.flag("net_ok"),
        },
        Puzzle {
            solved: |s| s.done,
            available: |s| s.flag("jets_ok"),
        },
    ],
    hint_views: &[
        ("WA1", &[0, 1, 2, 3, 4, 8, 10]),
        ("WA2", &[5, 6, 7, 9, 10, 11]),
        ("wacoal", &[0]),
        ("wafirebox", &[1]),
        ("wagauge", &[2, 3]),
        ("watube", &[3]),
        ("walevers", &[4]),
        ("wagov", &[10]),
        ("waprogramme", &[10, 11]),
        ("waboard", &[8]),
        ("wanotes", &[8]),
        ("warisers", &[5]),
        ("watank", &[6]),
        ("waplaque", &[6]),
        ("watable", &[7, 11]),
        ("wanet", &[7, 9]),
        ("wawindow", &[3, 10, 11]),
        ("wajets", &[10]),
    ],
    done_flag: "done",
    clues,
    extra,
    hook,
};

/// The pipe rotations of one solution (tests): only tiles on the path matter.
#[cfg(test)]
pub fn solved_pipes() -> Vec<u8> {
    // Search the four rotations of the six path tiles.
    let path = [0usize, 1, 5, 10, 11, 15];
    let mut s = State::new(&SPEC);
    for flag in ["engine_on", "air_out", "socket_in"] {
        s.set(flag);
    }
    for combo in 0..4u32.pow(path.len() as u32) {
        let mut c = combo;
        for i in path {
            s.val_mut("pipes")[i] = (c % 4) as u8;
            c /= 4;
        }
        let (wet, out) = flow(&s);
        if out && wet[FILTER_TILE] {
            return s.val("pipes").to_vec();
        }
    }
    panic!("no pipe solution");
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::house::say_all;
    use crate::kit::{msg, turn_to};

    #[test]
    fn the_fountain_runs() {
        let mut r = State::new(&SPEC);
        msg(&mut r, "tap coal");
        msg(&mut r, "tap matchtin");
        assert_eq!(msg(&mut r, "use wamatches firebox"), "wamsg.firebox_shut");
        msg(&mut r, "use waspanner firebox");
        msg(&mut r, "use wamatches firebox");
        for _ in 0..FEED {
            msg(&mut r, "turn feed 0 +1");
        }
        assert!(r.flag("boiler_ok"));
        say_all(&mut r, &[0]);
        assert!(!r.flag("told"));
        say_all(&mut r, &[1, 2, 0]);
        assert!(r.flag("told"));
        assert_eq!(msg(&mut r, "lever 0"), "wamsg.stall");
        for l in START {
            msg(&mut r, &format!("lever {l}"));
        }
        assert!(r.flag("engine_on"));
        assert_eq!(msg(&mut r, "bleed 0"), "wamsg.bleed_water");
        msg(&mut r, &format!("bleed {KNOCK}"));
        for l in [0, 1, 2] {
            msg(&mut r, &format!("layer {l}"));
        }
        assert_eq!(
            msg(&mut r, "test"),
            "wamsg.muddy",
            "gravel at the bottom is wrong"
        );
        msg(&mut r, "empty");
        for l in LAYERS {
            msg(&mut r, &format!("layer {}", l - 1));
        }
        msg(&mut r, "test");
        assert!(r.flag("filter_ok"));
        msg(&mut r, "tap horn");
        msg(&mut r, "use wahorn socket");
        turn_to(&mut r, "districts", &DISTRICTS, 2);
        assert!(r.flag("districts_ok"));
        let target = solved_pipes();
        turn_to(&mut r, "pipes", &target, 4);
        assert!(r.flag("net_ok"), "{:?}", flow(&r));
        // No pipe setting bypasses the filter.
        let mut t = State::new(&SPEC);
        for flag in ["engine_on", "air_out", "socket_in"] {
            t.set(flag);
        }
        for combo in 0..4u32.pow(9) {
            let mut c = combo;
            for i in [0usize, 1, 2, 3, 4, 5, 8, 10, 11] {
                t.val_mut("pipes")[i] = (c % 4) as u8;
                c /= 4;
            }
            let (wet, out) = flow(&t);
            assert!(!out || wet[FILTER_TILE]);
        }
        msg(&mut r, "turn speed 0 +1");
        turn_to(&mut r, "jets", &JETS, 4);
        assert!(r.flag("jets_ok"));
        msg(&mut r, "time 3");
        assert_eq!(msg(&mut r, "tap mainvalve"), "wamsg.not_yet");
        msg(&mut r, &format!("time {}", CYCLE - 1));
        msg(&mut r, "tap mainvalve");
        assert!(r.done && r.solved().iter().all(|s| *s) && r.inv == 0);
        // Speed 3 cannot make the small jets: the design has one answer.
        let mut u = r.clone();
        u.val_mut("speed")[0] = 2;
        assert!((0..64).all(|j| {
            u.val_mut("jets").copy_from_slice(&[j % 4, (j / 4) % 4, j / 16]);
            heights(&u) != DESIGN
        }));
    }
}
