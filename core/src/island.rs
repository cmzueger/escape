//! The small games of the series Puffin Island (`spring`, `summer`,
//! `autumn`, `winter`): easy coordination guided by a clue.
//!
//! - [`row`]: a boat on a grid of rocks; each stroke moves it one cell, then
//!   the tide pushes it one cell more. A rock or the edge sends it back.
//! - [`skate`]: on the ice the skater slides until a snowbank stops her;
//!   thin ice (unseen, marked only in the almanac) breaks.
//! - [`kite`]: let the line out with a gust, hold it in the calm.
//! - [`stroke`]: rowing in the race, a stroke on the drum's beat.

use crate::kit::{Reply, State};
use crate::set9::moment;

/// A grid of water (or ice): `w` by `h` cells, row by row.
pub struct Course {
    pub w: u8,
    pub h: u8,
    /// Rocks (rowing) or snowbanks (skating): cells that stop you.
    pub blocked: &'static [u8],
    /// Thin ice (skating only): a cell that breaks.
    pub thin: &'static [u8],
    pub start: u8,
    pub goal: u8,
    /// The tide's push after each stroke (rowing only): (dx, dy).
    pub drift: (i8, i8),
}

impl Course {
    fn step(&self, at: u8, (dx, dy): (i8, i8)) -> Option<u8> {
        let x = (at % self.w) as i8 + dx;
        let y = (at / self.w) as i8 + dy;
        if x < 0 || y < 0 || x >= self.w as i8 || y >= self.h as i8 {
            return None;
        }
        Some(y as u8 * self.w + x as u8)
    }

    pub fn json(&self) -> String {
        format!(
            "{{\"w\":{},\"h\":{},\"blocked\":[{}],\"start\":{},\"goal\":{},\"drift\":[{},{}]}}",
            self.w,
            self.h,
            crate::nums_json(self.blocked),
            self.start,
            self.goal,
            self.drift.0,
            self.drift.1
        )
    }

    /// The almanac's page: where the thin ice is (skating).
    pub fn thin_json(&self) -> String {
        format!("[{}]", crate::nums_json(self.thin))
    }
}

pub fn dir(word: &str) -> Option<(i8, i8)> {
    match word {
        "n" => Some((0, -1)),
        "e" => Some((1, 0)),
        "s" => Some((0, 1)),
        "w" => Some((-1, 0)),
        _ => None,
    }
}

/// What a move did.
#[derive(Debug, PartialEq)]
pub enum Move {
    On,
    Back,
    Arrived,
}

/// One stroke on `course`, the boat's cell in the dial `dial`.
pub fn row(s: &mut State, dial: &str, course: &Course, d: (i8, i8)) -> Move {
    let at = s.val(dial)[0];
    let go = |c: Option<u8>| c.filter(|c| !course.blocked.contains(c));
    let Some(moved) = go(course.step(at, d)) else {
        s.val_mut(dial)[0] = course.start;
        return Move::Back;
    };
    if moved == course.goal {
        s.val_mut(dial)[0] = moved;
        return Move::Arrived;
    }
    let Some(pushed) = go(course.step(moved, course.drift)) else {
        s.val_mut(dial)[0] = course.start;
        return Move::Back;
    };
    s.val_mut(dial)[0] = pushed;
    if pushed == course.goal {
        Move::Arrived
    } else {
        Move::On
    }
}

/// One push on the ice: slides until the next cell is a snowbank or the
/// shore's edge; thin ice passed or stopped on breaks.
pub fn skate(s: &mut State, dial: &str, course: &Course, d: (i8, i8)) -> Move {
    let mut at = s.val(dial)[0];
    while let Some(next) = course.step(at, d).filter(|c| !course.blocked.contains(c)) {
        at = next;
        if course.thin.contains(&at) {
            s.val_mut(dial)[0] = course.start;
            return Move::Back;
        }
        if at == course.goal {
            break;
        }
    }
    s.val_mut(dial)[0] = at;
    if at == course.goal {
        Move::Arrived
    } else {
        Move::On
    }
}

/// The kite's height (dial `dial`, 0 to `top`): letting out in a gust
/// raises it, letting out in the calm drops it by two; holding keeps it.
/// Returns whether it reached the top.
pub fn kite(s: &mut State, dial: &str, out: bool, gust: bool, top: u8) -> bool {
    let h = &mut s.val_mut(dial)[0];
    if out {
        *h = if gust {
            (*h + 1).min(top)
        } else {
            h.saturating_sub(2)
        };
    }
    *h >= top
}

/// A stroke in the race (dial `dial` = [lead, strokes]): on the beat it
/// gains a length, off the beat it loses one. After `most` strokes the
/// other boat has won and the race starts again. Returns the reply key's
/// last word: "won", "on_beat", "off_beat" or "lost".
pub fn stroke(s: &mut State, dial: &str, on_beat: bool, need: u8, most: u8) -> &'static str {
    let v = s.val_mut(dial);
    v[1] += 1;
    if on_beat {
        v[0] += 1;
    } else {
        v[0] = v[0].saturating_sub(1);
    }
    if v[0] >= need {
        "won"
    } else if v[1] >= most {
        v[0] = 0;
        v[1] = 0;
        "lost"
    } else if on_beat {
        "on_beat"
    } else {
        "off_beat"
    }
}

/// Whether a gust (or a beat) is blowing now: the last `show` seconds of
/// every `cycle`.
pub fn now(s: &State, cycle: u32, show: u32) -> bool {
    moment(s, cycle, show)
}

/// A reply for a row or skate move, with the room's prefix.
pub fn moved(m: Move, prefix: &str, what: &str) -> Reply {
    Ok(match m {
        Move::On => String::new(),
        Move::Back => format!("{prefix}msg.{what}_back"),
        Move::Arrived => format!("{prefix}msg.{what}_there"),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn courses_step_inside() {
        let c = Course {
            w: 3,
            h: 2,
            blocked: &[1],
            thin: &[],
            start: 0,
            goal: 5,
            drift: (0, 0),
        };
        assert_eq!(c.step(0, (1, 0)), Some(1));
        assert_eq!(c.step(0, (-1, 0)), None);
        assert_eq!(c.step(5, (0, 1)), None);
    }
}
