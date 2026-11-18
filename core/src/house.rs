//! Shared mechanisms of the series The Quiet House (`house1905`,
//! `house1938`, `house1969`, `housenow`): the piano, conversations on the
//! telephone or intercom, and listening to a melody.
//!
//! - `key <0..7>`: a piano key; the last notes played are kept in the dial
//!   `played` (as long as the tune), newest last.
//! - `call`: starts the conversation (when its flag allows); `say <i>`: picks
//!   a choice; a wrong one ends the call (dial `talk`, 0 when not talking).
//! - `listen <source>`: the room's own hook answers with `<prefix>msg.<source>_plays`;
//!   the client then plays that source's notes from the clues.

use crate::kit::{Reply, State};
use crate::{bad, nums_json};

/// One line of a conversation: what the other person says, the choices
/// (text key, next line; 0 ends the call), and a flag set on reaching it.
pub struct Line {
    pub text: &'static str,
    pub choices: &'static [(&'static str, u8)],
    pub sets: &'static str,
}

/// `key <i>`: plays a piano key.
pub fn piano(s: &mut State, words: &[&str]) -> Option<Reply> {
    let ["key", i] = words else {
        return None;
    };
    Some(match i.parse::<u8>().ok().filter(|k| *k < 8) {
        None => Err(bad("key")),
        Some(k) => {
            let played = s.val_mut("played");
            played.remove(0);
            played.push(k + 1);
            Ok(String::new())
        }
    })
}

/// Whether the last notes played are `tune` (keys 0..7).
pub fn played(s: &State, tune: &[u8]) -> bool {
    let p = s.val("played");
    p.len() == tune.len() && p.iter().zip(tune).all(|(a, b)| *a == b + 1)
}

/// `call` and `say <i>` for a conversation that may start once `can_call`
/// holds; `prefix` names the room's messages (`<prefix>msg.no_line`,
/// `<prefix>msg.hangup`).
pub fn talk(s: &mut State, words: &[&str], lines: &[Line], can_call: &str, prefix: &str) -> Option<Reply> {
    match words {
        ["call"] => Some(Ok(if !s.flag(can_call) {
            format!("{prefix}msg.no_line")
        } else {
            s.val_mut("talk")[0] = 1;
            String::new()
        })),
        ["say", i] => {
            let at = usize::from(s.val("talk")[0]);
            if at == 0 {
                return Some(Ok(String::new()));
            }
            let line = &lines[at - 1];
            Some(match i.parse::<usize>().ok().and_then(|i| line.choices.get(i)) {
                None => Err(bad("say")),
                Some((_, next)) => {
                    s.val_mut("talk")[0] = *next;
                    if *next == 0 {
                        Ok(format!("{prefix}msg.hangup"))
                    } else {
                        let reached = &lines[usize::from(*next) - 1];
                        s.set(reached.sets);
                        Ok(String::new())
                    }
                }
            })
        }
        _ => None,
    }
}

/// The conversation for the client's clues:
/// `[{"text":"…","choices":["…","…"]},…]` (where each choice leads stays
/// in the rules).
pub fn lines_json(lines: &[Line]) -> String {
    lines
        .iter()
        .map(|l| {
            let choices = l
                .choices
                .iter()
                .map(|(k, _)| format!("\"{k}\""))
                .collect::<Vec<_>>()
                .join(",");
            format!("{{\"text\":\"{}\",\"choices\":[{choices}]}}", l.text)
        })
        .collect::<Vec<_>>()
        .join(",")
}

pub fn tune_json(tune: &[u8]) -> String {
    format!("[{}]", nums_json(tune))
}

#[cfg(test)]
pub fn say_all(s: &mut State, choices: &[usize]) {
    use crate::kit::msg;
    msg(s, "call");
    for c in choices {
        msg(s, &format!("say {c}"));
    }
}
