## The views of the hut: how they connect, what can be tapped where, and how
## each is lit. A hotspot is [id, Rect2, action]; the action is "tap" (ask
## the rules about the id), "go:<view>" (look closer) or "cmd:<command>".
## Rectangles match the drawings in art.gd.
class_name Views
extends RefCounted

const MAIN_ROOM := ["A", "B", "C"]
const WARDEN_ROOM := ["D", "E"]
const PARENT := {
	"lock": "C", "logbook": "D", "baro": "D", "radio": "D", "wiring": "radio",
	"map": "E", "clock": "E", "safe": "E", "D": "B", "E": "B",
}


static func is_closeup(view: String) -> bool:
	return not (view in MAIN_ROOM or view in WARDEN_ROOM)


## The view to the left (-1) or right (+1), or "" in a close-up.
static func beside(view: String, dir: int) -> String:
	for ring in [MAIN_ROOM, WARDEN_ROOM]:
		var i: int = ring.find(view)
		if i >= 0:
			return ring[posmod(i + dir, ring.size())]
	return ""


static func back(view: String) -> String:
	return PARENT.get(view, "")


## Views that move even when nothing is tapped.
static func animated(view: String) -> bool:
	return view in ["A", "radio", "baro"]


static func _wheels(lock: String, count: int, x0: float, y0: float) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * 80.0
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 34, y0 - 64, 68, 54), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_digit%d" % [lock, i], Rect2(cx - 34, y0 - 10, 68, 84), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 34, y0 + 74, 68, 54), "cmd:dial %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary) -> Array:
	var flags: Array = st.get("flags", [])
	match view:
		"A":
			return [
				["coat", Rect2(240, 112, 82, 196), "tap"],
				["window", Rect2(60, 92, 170, 150), "tap"],
				["stove", Rect2(332, 180, 126, 216), "tap"],
				["axes", Rect2(495, 76, 200, 112), "tap"],
				["lamp", Rect2(606, 232, 68, 70), "tap"],
				["table", Rect2(500, 300, 190, 96), "tap"],
				["sign", Rect2(786, 62, 118, 42), "tap"],
				["door_out", Rect2(780, 110, 130, 264), "tap"],
			]
		"B":
			return [
				["hats", Rect2(465, 84, 260, 82), "tap"],
				["boots", Rect2(480, 300, 220, 72), "tap"],
				["bunk", Rect2(42, 100, 376, 280), "tap"],
				["door2", Rect2(760, 110, 130, 264), "go:D" if "door2_open" in flags else "tap"],
			]
		"C":
			var list := [
				["cupboard", Rect2(40, 150, 240, 228), "tap" if "cup_open" in flags else "go:lock"],
				["mugs", Rect2(320, 124, 340, 60), "tap"],
				["poster", Rect2(700, 80, 160, 140), "tap"],
				["woodbox", Rect2(330, 272, 150, 104), "tap"],
			]
			if not "got_bucket" in flags:
				list.append(["bucket", Rect2(535, 268, 90, 108), "tap"])
			return list
		"D":
			return [
				["baro", Rect2(112, 92, 116, 116), "go:baro"],
				["photo", Rect2(740, 100, 120, 90), "tap"],
				["logbook", Rect2(318, 252, 124, 40), "go:logbook"],
				["radio", Rect2(446, 200, 214, 92), "go:radio"],
				["drawer", Rect2(540, 306, 150, 70), "tap"],
			]
		"E":
			return [
				["map", Rect2(60, 60, 300, 180), "go:map"],
				["safe", Rect2(150, 258, 130, 58), "go:safe"],
				["clock", Rect2(416, 60, 128, 260), "go:clock"],
				["bed", Rect2(590, 250, 350, 130), "tap"],
			]
		"lock":
			return _wheels("cup", 3, 400, 290)
		"safe":
			if "safe_open" in flags:
				return [["safe", Rect2(300, 200, 360, 220), "tap"]]
			return _wheels("safe", 4, 360, 230)
		"clock":
			return [
				["cuckoo", Rect2(420, 26, 150, 96), "tap"],
				["hour_back", Rect2(96, 246, 84, 72), "cmd:clock h -1"],
				["hour_on", Rect2(190, 246, 84, 72), "cmd:clock h +1"],
				["minute_back", Rect2(686, 246, 84, 72), "cmd:clock m -1"],
				["minute_on", Rect2(780, 246, 84, 72), "cmd:clock m +1"],
			]
		"baro":
			if "baro_open" in flags:
				return [["baro_crank", Rect2(690, 290, 210, 150), "tap"]]
			return [
				["ring_left", Rect2(112, 192, 112, 92), "cmd:baro -1"],
				["ring_right", Rect2(736, 192, 112, 92), "cmd:baro +1"],
			]
		"map":
			return [["map", Rect2(60, 20, 840, 432), "tap"]]
		"radio":
			var list := []
			var knobs := ["c", "m", "f"]
			for k in range(3):
				var kx := 386.0 + k * 98.0
				list.append(["knob_%s_down" % knobs[k], Rect2(kx - 49, 196, 49, 134), "cmd:tune %s -1" % knobs[k]])
				list.append(["knob_%s_up" % knobs[k], Rect2(kx, 196, 49, 134), "cmd:tune %s +1" % knobs[k]])
			list.append(["key_short", Rect2(632, 192, 84, 84), "cmd:key s"])
			list.append(["key_long", Rect2(720, 192, 92, 84), "cmd:key l"])
			list.append(["radio_back", Rect2(156, 336, 178, 72), "go:wiring"])
			list.append(["crank_slot", Rect2(812, 170, 100, 130), "tap"])
			list.append(["radio", Rect2(132, 52, 696, 376), "tap"])
			return list
		"wiring":
			var list := [["fuse_slot", Rect2(160, 116, 86, 60), "tap"]]
			for i in range(15):
				list.append(["tile%d" % i, Rect2(Art.WIRE_X + (i % 5) * Art.WIRE_CELL, Art.WIRE_Y + floorf(i / 5.0) * Art.WIRE_CELL, Art.WIRE_CELL, Art.WIRE_CELL), "cmd:wire %d" % i])
			return list
	return []


## {"dark": 0..1, "warm": [Vector4 x4 at most], "cold": Vector4}
static func lights(view: String, st: Dictionary) -> Dictionary:
	var flags: Array = st.get("flags", [])
	var lamp: bool = "lamp_lit" in flags
	var stove: bool = "stove_lit" in flags
	var none := Vector4.ZERO
	if view in MAIN_ROOM:
		var dark := 0.9
		if lamp:
			dark = 0.66
		if stove:
			dark = 0.5
		var warm := []
		var cold := none
		if view == "A":
			cold = Vector4(150, 180, 250, 0.5 if lamp else 0.62)
			if lamp:
				warm.append(Vector4(640, 262, 380, 1.0))
			if stove:
				warm.append(Vector4(395, 300, 260, 0.9))
		elif lamp:
			# The lamp's light from where the table stands.
			warm.append(Vector4(480, 230, 620, 0.85))
			if view == "B" and "door2_open" in flags:
				warm.append(Vector4(825, 250, 200, 0.6))
		return {"dark": dark, "warm": warm, "cold": cold}
	if view == "D":
		return {"dark": 0.55, "warm": [Vector4(480, 90, 560, 1.0)], "cold": none}
	if view == "E":
		return {"dark": 0.55, "warm": [Vector4(480, 120, 600, 0.95)], "cold": none}
	return {"dark": 0.34, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none}
