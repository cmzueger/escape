//! Shared helpers of the ninth set (`aviary`, `mirrors`, `school`): long
//! easy rooms with many small steps.
//!
//! - [`combine`]: two items used on each other become a third.
//! - [`sequence`]: things tapped in an order; a wrong one starts over.
//! - [`moment`]: whether something only visible now and then is showing.

use crate::kit::{Reply, State};

/// Two items into one: `(a, b, result, flag, msg)`, in either order. Both
/// are taken, the result given and the flag set.
pub type Recipe = (
    &'static str,
    &'static str,
    &'static str,
    &'static str,
    &'static str,
);

pub fn combine(s: &mut State, words: &[&str], recipes: &[Recipe]) -> Option<Reply> {
    let ["use", x, y] = words else {
        return None;
    };
    let (a, b, result, flag, msg) = recipes
        .iter()
        .find(|(a, b, ..)| (a == x && b == y) || (a == y && b == x))?;
    if !s.has(a) || !s.has(b) {
        return None;
    }
    s.take(a);
    s.take(b);
    s.give(result);
    s.set(flag);
    Some(Ok((*msg).into()))
}

/// One step of an ordered sequence kept in the dial `dial` (how far along):
/// the right next one advances, a wrong one starts over (or counts as the
/// first step if it is the first). Returns whether the sequence is complete.
pub fn sequence(s: &mut State, dial: &str, order: &[u8], tapped: u8) -> (bool, bool) {
    let at = usize::from(s.val(dial)[0]);
    let next = if order.get(at) == Some(&tapped) {
        at + 1
    } else if order.first() == Some(&tapped) {
        1
    } else {
        0
    };
    s.val_mut(dial)[0] = next as u8;
    (next == order.len(), next > at)
}

/// Whether something that shows for the last `show` seconds of every
/// `cycle` is showing now.
pub fn moment(s: &State, cycle: u32, show: u32) -> bool {
    s.secs % cycle >= cycle - show
}

#[cfg(test)]
mod tests {
    #[test]
    fn moment_shows_at_the_end_of_each_cycle() {
        let showing = |secs: u32| secs % 9 >= 9 - 3;
        assert!(!showing(0) && !showing(5) && showing(6) && showing(8) && !showing(9));
    }
}
