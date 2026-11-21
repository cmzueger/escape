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
	if Set10Views.has(view):
		return not Set10Views.is_wall(view)
	if CityViews.has(view):
		return not CityViews.is_wall(view)
	if IslandViews.has(view):
		return not IslandViews.is_wall(view)
	if Set9Views.has(view):
		return not Set9Views.is_wall(view)
	if Set8Views.has(view):
		return not Set8Views.is_wall(view)
	if Set7Views.has(view):
		return not Set7Views.is_wall(view)
	if HouseViews.has(view):
		return not HouseViews.is_wall(view)
	if Set6Views.has(view):
		return not Set6Views.is_wall(view)
	if Set5Views.has(view):
		return not Set5Views.is_wall(view)
	if Set4Views.has(view):
		return not Set4Views.is_wall(view)
	if Set3Views.has(view):
		return not Set3Views.is_wall(view)
	if Set2Views.has(view):
		return not Set2Views.is_wall(view)
	if ObsViews.has(view):
		return not (view in ObsViews.STUDY or view in ObsViews.DOME)
	if LightViews.has(view):
		return not view in LightViews.FLOORS
	return not (view in MAIN_ROOM or view in WARDEN_ROOM)


## The view to the left (-1) or right (+1), or "" in a close-up.
static func beside(view: String, dir: int) -> String:
	for ring in [MAIN_ROOM, WARDEN_ROOM, ObsViews.STUDY, ObsViews.DOME] + Set2Views.RINGS + Set3Views.RINGS + Set4Views.RINGS + Set5Views.RINGS + Set6Views.RINGS + HouseViews.RINGS + Set7Views.RINGS + Set8Views.RINGS + Set9Views.RINGS + IslandViews.RINGS + Set10Views.RINGS:
		var i: int = ring.find(view)
		if i >= 0:
			return ring[posmod(i + dir, ring.size())]
	return ""


static func back(view: String) -> String:
	if Set10Views.has(view):
		return Set10Views.PARENT.get(view, "")
	if CityViews.has(view):
		return CityViews.back(view)
	if IslandViews.has(view):
		return IslandViews.PARENT.get(view, "")
	if Set9Views.has(view):
		return Set9Views.PARENT.get(view, "")
	if Set8Views.has(view):
		return Set8Views.PARENT.get(view, "")
	if Set7Views.has(view):
		return Set7Views.PARENT.get(view, "")
	if HouseViews.has(view):
		return HouseViews.PARENT.get(view, "")
	if Set6Views.has(view):
		return Set6Views.PARENT.get(view, "")
	if Set5Views.has(view):
		return Set5Views.PARENT.get(view, "")
	if Set4Views.has(view):
		return Set4Views.PARENT.get(view, "")
	if Set3Views.has(view):
		return Set3Views.PARENT.get(view, "")
	if Set2Views.has(view):
		return Set2Views.PARENT.get(view, "")
	if ObsViews.has(view):
		return ObsViews.PARENT.get(view, "")
	if LightViews.has(view):
		return LightViews.PARENT.get(view, "")
	return PARENT.get(view, "")


## The floor above (lighthouse), or "".
static func up(view: String, st: Dictionary) -> String:
	return LightViews.up(view, st)


## The room a view belongs to, found by stepping back to a wall (a test
## checks that every view a room can reach answers that room).
static func room_of(view: String) -> String:
	if CityViews.has(view):
		return CityViews.ROOM
	if Set10Views.has(view):
		return Set10Views.room_of(view)
	var seen := 0
	while back(view) != "" and seen < 20:
		view = back(view)
		seen += 1
	if view in MAIN_ROOM or view in WARDEN_ROOM:
		return "hut"
	if view in LightViews.FLOORS:
		return "light"
	if view in ObsViews.STUDY or view in ObsViews.DOME:
		return "obs"
	for module in [Set2Views, Set3Views, Set4Views, Set5Views, Set6Views, HouseViews, Set7Views, Set8Views, Set9Views, IslandViews]:
		for room in module.FIRST:
			for ring in module.RINGS:
				if module.FIRST[room] in ring and view in ring:
					return room
	return ""


## Where a room starts.
static func first(room: String) -> String:
	if room == CityViews.ROOM:
		return "SR0"
	if Set10Views.FIRST.has(room):
		return Set10Views.FIRST[room]
	return {"light": "L1", "obs": "S1"}.get(room, Set2Views.FIRST.get(room, Set3Views.FIRST.get(room, Set4Views.FIRST.get(room, Set5Views.FIRST.get(room, Set6Views.FIRST.get(room, HouseViews.FIRST.get(room, Set7Views.FIRST.get(room, Set8Views.FIRST.get(room, Set9Views.FIRST.get(room, IslandViews.FIRST.get(room, "A")))))))))))


## Whether a saved view can be shown again in this state.
static func reachable(view: String, st: Dictionary) -> bool:
	if CityViews.has(view):
		return CityViews.reachable(view, st)
	if Set10Views.has(view):
		return Set10Views.reachable(view, st)
	var flags: Array = st.get("flags", [])
	if Set2Views.has(view) or Set3Views.has(view) or Set4Views.has(view) or Set5Views.has(view) or Set6Views.has(view) or HouseViews.has(view) or Set7Views.has(view) or Set8Views.has(view) or Set9Views.has(view) or IslandViews.has(view):
		return true
	if ObsViews.has(view):
		var place := view
		while not (place in ObsViews.STUDY or place in ObsViews.DOME):
			place = ObsViews.PARENT.get(place, "S1")
		return place in ObsViews.STUDY or "gate_open" in flags
	var at := view
	while PARENT.has(at) or LightViews.PARENT.has(at):
		if at in ["D", "E"]:
			return "door2_open" in flags
		if at in LightViews.FLOORS:
			var below: String = LightViews.PARENT[at]
			return LightViews.up(below, st) == at and reachable(below, st)
		at = PARENT.get(at, LightViews.PARENT.get(at, ""))
	return at in MAIN_ROOM or at == "L1"


## Views that move even when nothing is tapped.
static func animated(view: String) -> bool:
	return CityViews.has(view) or Set10Views.has(view) or view in ["A", "radio", "baro"] or LightViews.has(view) or view in ObsViews.DOME or view in ["G1", "G2", "pond", "C1", "T3", "mirror", "B2", "bwindow", "N1", "A1", "furnace", "K1", "K2", "W1", "W2", "wclocks", "wwatch", "Y1", "Y2", "ytrain", "ydoll", "P1", "ebeam", "E2", "V1", "V2", "vwindow", "vballast", "R1", "R2", "Z1", "zcompass", "hbox", "ubox", "xcourt", "xstove", "jcourt", "O1", "F1", "F2", "fmirror", "fglass", "WA1", "WA2", "warisers", "wafirebox", "wagov", "wawindow", "RC1", "RC2", "rcsign", "MI1", "MI2", "miwindow", "migears", "AV1", "AV2", "AV3", "AV4", "avcage", "avorchid", "HM1", "HM2", "HM3", "HM4", "hmzelda", "hmspots", "hmstall", "SC1", "SC3", "SC4", "scwindow", "schutch", "scstove", "scclock", "PS1", "PS2", "PS3", "PS4", "psboat", "psledge", "psflags", "PU1", "PU2", "PU3", "PU4", "pulamp", "pukite", "pualmanac", "PA1", "PA2", "PA3", "PA4", "papress", "parace", "PW1", "PW2", "PW3", "PW4", "pwlake", "pwicicles", "pwlens"]


static func _wheels(lock: String, count: int, x0: float, y0: float) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * 80.0
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 34, y0 - 64, 68, 54), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_digit%d" % [lock, i], Rect2(cx - 34, y0 - 10, 68, 84), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 34, y0 + 74, 68, 54), "cmd:dial %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary, art: ArtLight = null) -> Array:
	if CityViews.has(view):
		return CityViews.spots(view, st, art)
	if Set10Views.has(view):
		return Set10Views.spots(view, st, art as ArtSet10)
	if IslandViews.has(view):
		return IslandViews.spots(view, st, art as ArtIsland)
	if Set9Views.has(view):
		return Set9Views.spots(view, st, art as ArtSet9)
	if Set8Views.has(view):
		return Set8Views.spots(view, st, art as ArtSet8)
	if Set7Views.has(view):
		return Set7Views.spots(view, st, art as ArtSet7)
	if HouseViews.has(view):
		return HouseViews.spots(view, st, art as ArtHouse)
	if Set6Views.has(view):
		return Set6Views.spots(view, st, art as ArtSet6)
	if Set5Views.has(view):
		return Set5Views.spots(view, st, art as ArtSet5)
	if Set4Views.has(view):
		return Set4Views.spots(view, st, art as ArtSet4)
	if Set3Views.has(view):
		return Set3Views.spots(view, st, art as ArtSet3)
	if Set2Views.has(view):
		return Set2Views.spots(view, st, art as ArtSet2)
	if ObsViews.has(view):
		return ObsViews.spots(view, st)
	if LightViews.has(view):
		return LightViews.spots(view, st, art)
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
	if CityViews.has(view):
		return CityViews.lights(view, st)
	if Set10Views.has(view):
		return Set10Views.lights(view, st)
	if IslandViews.has(view):
		return IslandViews.lights(view, st)
	if Set9Views.has(view):
		return Set9Views.lights(view, st)
	if Set8Views.has(view):
		return Set8Views.lights(view, st)
	if Set7Views.has(view):
		return Set7Views.lights(view, st)
	if HouseViews.has(view):
		return HouseViews.lights(view, st)
	if Set6Views.has(view):
		return Set6Views.lights(view, st)
	if Set5Views.has(view):
		return Set5Views.lights(view, st)
	if Set4Views.has(view):
		return Set4Views.lights(view, st)
	if Set3Views.has(view):
		return Set3Views.lights(view, st)
	if Set2Views.has(view):
		return Set2Views.lights(view, st)
	if ObsViews.has(view):
		return ObsViews.lights(view, st)
	if LightViews.has(view):
		return LightViews.lights(view, st)
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
