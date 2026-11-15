//! GDExtension for the Godot client: the room as one Godot class, `HutRoom`.
//! GDScript sends the text commands of `hut_core` and parses the JSON answer.

use godot::prelude::*;
use hut_core::Room;

struct HutExtension;

#[gdextension]
unsafe impl ExtensionLibrary for HutExtension {}

#[derive(GodotClass)]
#[class(base = RefCounted, init)]
pub struct HutRoom {
    room: Room,
}

#[godot_api]
impl HutRoom {
    /// Runs one command (see `hut_core`) and returns the JSON answer.
    #[func]
    fn call_room(&mut self, command: GString) -> GString {
        GString::from(&self.room.call(&command.to_string()))
    }
}
