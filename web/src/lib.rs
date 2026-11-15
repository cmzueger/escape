//! The room as WebAssembly for the Godot client's web build.
//!
//! Godot's web export cannot load the native extension (`godot/`), so
//! `client/web/hut-engine.js` loads this module into the page, where
//! GDScript calls it through `JavaScriptBridge`. No dependencies: JavaScript
//! writes a text command (see `hut_core`) into memory from [`hut_alloc`],
//! calls [`hut_call`] and reads the JSON answer from [`hut_out`].

use std::cell::RefCell;

use hut_core::Room;

thread_local! {
    static ROOM: RefCell<Room> = RefCell::new(Room::new());
    static OUT: RefCell<String> = const { RefCell::new(String::new()) };
}

/// Allocates `len` bytes for a command string; JavaScript writes into it.
#[no_mangle]
pub extern "C" fn hut_alloc(len: usize) -> *mut u8 {
    let mut buf = Vec::<u8>::with_capacity(len.max(1));
    let ptr = buf.as_mut_ptr();
    std::mem::forget(buf);
    ptr
}

/// Frees a buffer from [`hut_alloc`].
///
/// # Safety
/// `ptr` and `len` must come from one [`hut_alloc`] call.
#[no_mangle]
pub unsafe extern "C" fn hut_free(ptr: *mut u8, len: usize) {
    drop(Vec::from_raw_parts(ptr, 0, len.max(1)));
}

/// Runs the command in `ptr[..len]` and returns the answer's length; the
/// answer is at [`hut_out`].
///
/// # Safety
/// `ptr[..len]` must be initialised memory from [`hut_alloc`].
#[no_mangle]
pub unsafe extern "C" fn hut_call(ptr: *const u8, len: usize) -> usize {
    let command = std::str::from_utf8(std::slice::from_raw_parts(ptr, len)).unwrap_or("");
    let answer = call(command);
    OUT.with(|out| {
        *out.borrow_mut() = answer;
        out.borrow().len()
    })
}

/// Pointer to the last answer (valid until the next [`hut_call`]).
#[no_mangle]
pub extern "C" fn hut_out() -> *const u8 {
    OUT.with(|out| out.borrow().as_ptr())
}

/// Runs one command and returns the JSON answer. Also used by tests.
pub fn call(command: &str) -> String {
    ROOM.with(|room| room.borrow_mut().call(command))
}

#[cfg(test)]
mod tests {
    #[test]
    fn commands_reach_the_room() {
        assert!(super::call("new").starts_with("{\"ok\":true"));
        assert!(super::call("tap coat").contains("msg.coat_matches"));
        assert!(super::call("state").contains("\"inv\":[\"matches\"]"));
    }
}
