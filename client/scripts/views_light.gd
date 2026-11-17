## Gale Rock Light: its floors, close-ups, hotspots and light (see views.gd
## for the format). Rectangles match the drawings in art_light.gd.
class_name LightViews
extends RefCounted

const FLOORS := ["L1", "L2", "L3", "L4"]
const HATCH := {"L1": "hatch1", "L2": "hatch2", "L3": "hatch3"}
const PARENT := {
	"L2": "L1", "L3": "L2", "L4": "L3",
	"oil": "L1", "chest": "L2", "tide": "L2", "hatch2": "L2",
	"flags": "L3", "slate": "L3", "locker": "L3", "seachart": "L3", "window": "L3",
	"gears": "L4", "drum": "L4", "valves": "L4", "bearing": "L4",
}
const HATCH_RECT := Rect2(636, 0, 180, 110)


static func has(view: String) -> bool:
	return view in FLOORS or PARENT.has(view)


## The floor above, once its hatch is open, or "".
static func up(view: String, st: Dictionary) -> String:
	var i := FLOORS.find(view)
	if i < 0 or i == FLOORS.size() - 1:
		return ""
	return FLOORS[i + 1] if (HATCH[view] + "_open") in st.get("flags", []) else ""


static func _wheels(lock: String, count: int, x0: float, y0: float, gap: float = 80.0) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * gap
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 36, y0 - 66, 72, 56), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_digit%d" % [lock, i], Rect2(cx - 36, y0 - 10, 72, 86), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 36, y0 + 76, 72, 58), "cmd:dial %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary, art: ArtLight = null) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		"L1":
			if not "got_magnet" in flags:
				list.append(["magnet", Rect2(306, 108, 64, 80), "tap"])
			if not "got_gear_b" in flags:
				list.append(["gear_b", Rect2(388, 114, 64, 68), "tap"])
			if not "got_rope" in flags:
				list.append(["rope", Rect2(30, 258, 76, 80), "tap"])
			list.append_array([
				["tools", Rect2(300, 86, 270, 124), "tap"],
				["ring", Rect2(26, 146, 88, 88), "tap"],
				["ropes", Rect2(100, 296, 60, 60), "tap"],
				["sea", Rect2(138, 84, 134, 180), "tap"],
				["barrel", Rect2(290, 256, 280, 134), "go:oil"],
				["crates", Rect2(850, 228, 100, 162), "tap"],
				["grating", Rect2(424, 398, 166, 62), "tap"],
				["hatch1", HATCH_RECT, "go:L2" if "hatch1_open" in flags else "tap"],
			])
		"L2":
			if not "got_matches" in flags:
				list.append(["matches", Rect2(846, 192, 60, 44), "tap"])
			list.append_array([
				["calendar", Rect2(40, 104, 88, 104), "tap"],
				["sea", Rect2(138, 84, 134, 180), "tap"],
				["photos", Rect2(292, 76, 340, 120), "tap"],
				["bed", Rect2(28, 286, 250, 100), "tap"],
				["chest", Rect2(282, 322, 112, 74), "tap" if "chest_open" in flags else "go:chest"],
				["tidebook", Rect2(420, 266, 118, 34), "go:tide"],
				["stove", Rect2(846, 240, 96, 146), "tap"],
				["hatch2", HATCH_RECT, "go:L3" if "hatch2_open" in flags else "go:hatch2"],
			])
		"L3":
			list.append_array([
				["window", Rect2(48, 84, 256, 176), "go:window"],
				["flagchart", Rect2(330, 70, 140, 150), "go:flags"],
				["slate", Rect2(492, 86, 110, 124), "go:slate"],
				["telescope", Rect2(236, 262, 100, 130), "tap"],
				["chart", Rect2(350, 258, 160, 44), "go:seachart"],
				["locker", Rect2(852, 212, 96, 180), "go:locker"],
				["hatch3", HATCH_RECT, "go:L4" if "hatch3_open" in flags else "tap"],
			])
		"L4":
			if not "got_gear_d" in flags:
				list.append(["gear_d", Rect2(790, 390, 74, 70), "tap"])
			list.append_array([
				["lamp", Rect2(410, 40, 140, 216), "tap"],
				["clockwork", Rect2(390, 278, 180, 112), "go:gears"],
				["drum", Rect2(596, 144, 104, 114), "go:drum"],
				["valves", Rect2(180, 244, 160, 140), "go:valves"],
				["reservoir", Rect2(70, 228, 96, 160), "tap"],
				["bearing", Rect2(616, 296, 158, 92), "go:bearing"],
			])
		"oil":
			if not ("can_taken" in flags or "oil_in" in flags):
				list.append_array([
					["fill_a", Rect2(562, 146, 68, 68), "cmd:oil fill a"],
					["pour_a", Rect2(562, 218, 68, 68), "cmd:oil pour a"],
					["empty_a", Rect2(562, 290, 68, 68), "cmd:oil empty a"],
					["can", Rect2(410, 130, 150, 290), "tap"],
				])
			list.append_array([
				["fill_b", Rect2(822, 182, 68, 68), "cmd:oil fill b"],
				["pour_b", Rect2(822, 254, 68, 68), "cmd:oil pour b"],
				["empty_b", Rect2(822, 326, 68, 68), "cmd:oil empty b"],
				["barrel", Rect2(34, 90, 300, 300), "tap"],
			])
		"chest":
			if "chest_open" in flags:
				list.append(["chest", Rect2(260, 190, 440, 230), "tap"])
			else:
				list = _wheels("chest", 4, 345, 270, 90.0)
		"hatch2":
			list = _wheels("hatch2", 4, 360, 270)
		"locker":
			if "locker_open" in flags:
				list.append(["locker", Rect2(230, 60, 500, 360), "tap"])
			else:
				list = _wheels("locker", 4, 360, 250)
		"gears":
			list.append(["crank_slot", Rect2(120, 150, 140, 160), "tap"])
			for i in range(3):
				var x := art.gear_x(i + 1) if art != null else 330.0 + i * 130.0
				list.append(["peg%d" % i, Rect2(x - 56, 150, 112, 160), "tap"])
		"drum":
			for k in range(8):
				list.append(["pin%d" % k, Rect2(124 + k * 90.0, 190, 84, 92), "cmd:pin %d" % k])
		"valves":
			var names := ["a", "b", "c"]
			for k in range(3):
				list.append(["valve_%s" % names[k], Rect2(190 + k * 230.0, 310, 120, 120), "cmd:valve %s" % names[k]])
		"bearing":
			list = _wheels("bearing", 3, 590, 238)
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var tint := Vector3(0.01, 0.05, 0.04)
	match view:
		"L1":
			return {"dark": 0.66, "warm": [Vector4(200, 350, 330, 0.9)], "cold": Vector4(205, 180, 170, 0.3), "tint": tint}
		"L2":
			return {"dark": 0.6, "warm": [Vector4(566, 262, 380, 0.95), Vector4(894, 320, 150, 0.6)], "cold": Vector4(205, 180, 170, 0.3), "tint": tint}
		"L3":
			return {"dark": 0.62, "warm": [Vector4(526, 262, 380, 0.95)], "cold": Vector4(176, 172, 220, 0.3), "tint": tint}
		"L4":
			if st.get("done", false):
				return {"dark": 0.3, "warm": [Vector4(480, 158, 700, 1.0)], "cold": none, "tint": tint}
			return {"dark": 0.62, "warm": [Vector4(250, 420, 300, 0.7), Vector4(700, 420, 300, 0.7)], "cold": Vector4(480, 150, 520, 0.25), "tint": tint}
		"window":
			return {"dark": 0.5, "warm": [], "cold": Vector4(480, 200, 600, 0.35), "tint": tint}
	return {"dark": 0.34, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": tint}
