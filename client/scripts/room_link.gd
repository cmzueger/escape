## The room's rules: the native HutRoom class (godot/src/lib.rs) on desktop,
## the same rules as WebAssembly (client/web/hut-engine.js) in the web build.
## Commands and answers are described in core/src/lib.rs.
class_name RoomLink
extends RefCounted

var _native: Object = null


func _init() -> void:
	if not OS.has_feature("web"):
		_native = ClassDB.instantiate("HutRoom")


## True once the rules are loaded (the web build fetches them after the page).
func ready() -> bool:
	if _native != null:
		return true
	return OS.has_feature("web") and bool(JavaScriptBridge.eval("!!(window.hut && window.hut.ready())"))


## Why the rules did not load, or "".
func failure() -> String:
	if _native != null:
		return ""
	if not OS.has_feature("web"):
		return "the HutRoom extension is missing (run client/build.sh)"
	return str(JavaScriptBridge.eval("window.hut ? window.hut.failure() : 'hut-engine.js is missing'"))


## Runs one command; the answer as a Dictionary ({"ok": false, …} on errors).
func send(command: String) -> Dictionary:
	var text := ""
	if _native != null:
		text = str(_native.call("call_room", command))
	else:
		text = str(JavaScriptBridge.eval("window.hut.call(%s)" % JSON.stringify(command)))
	var answer = JSON.parse_string(text)
	if answer is Dictionary:
		return answer
	return {"ok": false, "error": "no answer"}
