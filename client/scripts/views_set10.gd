## The tenth set: The Moon-Viewing Garden (MG…, close-ups mg…), The Great
## Balloon Race (BL…, close-ups bl…) and The Dragon's Egg (DG1, and deeper
## into the mountain DG2 … DG4, close-ups dg…): views, hotspots and light
## (see views.gd). Rectangles match art_set10.gd, which reads some of them
## from here.
class_name Set10Views
extends RefCounted

const RINGS := [["MG1", "MG2", "MG3", "MG4"], ["BL1", "BL2", "BL3", "BL4"]]
## The dragon's mountain is walked inwards: each hall opens from the last.
const WALLS := ["DG1"]
const PARENT := {
	"mgscroll": "MG1", "mgtea": "MG1",
	"mgkoi": "MG2", "mgpond": "MG2",
	"mggravel": "MG3",
	"mggate": "MG4",
	"blcard": "BL1",
	"blcase": "BL2", "blrigging": "BL2",
	"blmap": "BL3", "blnote": "BL3",
	"dgrunes": "DG1", "dgcart": "DG1",
	"DG2": "DG1", "dgbells": "DG2", "dghoard": "DG2", "dgnotes": "DG2",
	"DG3": "DG2", "dgmirrors": "DG3", "dgfloor": "DG3",
	"DG4": "DG3",
}
const FIRST := {"moon": "MG1", "balloon": "BL1", "dragon": "DG1"}
const PAD := {"n": Rect2(780, 70, 72, 56), "w": Rect2(708, 140, 72, 56), "e": Rect2(852, 140, 72, 56), "s": Rect2(780, 210, 72, 56)}
## The pond and the obsidian floor seen from above.
const GRID_AT := Vector2(70, 50)
const GRID_CELL := 74.0
## The tea tools: where each (0 cloth, 1 scoop, 2 ladle, 3 whisk, 4 bowl) lies.
const TOOL_SLOT := [3, 0, 4, 1, 2]
## Where each koi (0 red, 1 white, 2 gold, 3 black) swims.
const KOI_ZONE := [2, 0, 3, 1]
## The gravel beds around the rocks (2 rows of 3).
const BED_AT := Vector2(150, 70)
const BED := Vector2(220, 150)
## The moon gate's rings.
const RING_X := [330.0, 480.0, 630.0]
const RING_Y := 200.0
## The flight map.
const MAP_AT := Vector2(70, 40)
const MAP_CELL := 62.0
const FLY := {"drift": Rect2(640, 60, 140, 60), "sand": Rect2(800, 60, 140, 60), "valve": Rect2(640, 140, 140, 60), "hook": Rect2(800, 140, 140, 60)}
## The hoard's stones, from the hall's mouth to the cage.
const STONE_X := 120.0
const STONE_GAP := 120.0


static func is_wall(view: String) -> bool:
	if view in WALLS:
		return true
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func room_of(view: String) -> String:
	var at := view
	while PARENT.has(at):
		at = PARENT[at]
	for room in FIRST:
		if at.substr(0, 2) == str(FIRST[room]).substr(0, 2):
			return room
	return ""


static func reachable(view: String, st: Dictionary) -> bool:
	var flags: Array = st.get("flags", [])
	var need := {"DG2": "door_open", "DG3": "crossed", "DG4": "across", "dgbells": "door_open", "dghoard": "door_open",
		"dgnotes": "door_open", "dgmirrors": "crossed", "dgfloor": "crossed", "mgtea": "chest_open", "mgpond": "boat_ready",
		"blcard": "got_card"}
	var at := view
	while true:
		if need.has(at) and not need[at] in flags:
			return false
		if not PARENT.has(at):
			return true
		at = PARENT[at]
	return true


static func _updown(dial: String, i: int, x: float, y: float) -> Array:
	return Set8Views._updown(dial, i, x, y)


static func _pad(cmd: String) -> Array:
	var list := []
	for d in ["n", "w", "e", "s"]:
		list.append(["%s_%s" % [cmd, d], PAD[d], "cmd:%s %s" % [cmd, d]])
	return list


static func grid_rect(i: int, w: int) -> Rect2:
	return Rect2(GRID_AT.x + (i % w) * GRID_CELL, GRID_AT.y + int(i / w) * GRID_CELL, GRID_CELL, GRID_CELL)


static func spots(view: String, st: Dictionary, art: ArtSet10) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Moon-Viewing Garden
		"MG1":
			list = [
				["scroll", Rect2(60, 60, 150, 250), "go:mgscroll"],
				["screen", Rect2(250, 70, 260, 170), "tap"],
				["aoki", Rect2(570, 170, 140, 200), "tap"],
				["chest", Rect2(250, 280, 150, 90), "go:mgtea" if "chest_open" in flags else "tap"],
				["kettle", Rect2(440, 200, 90, 70), "tap"],
				["brazier", Rect2(430, 280, 110, 90), "tap"],
				["chime", Rect2(820, 40, 60, 140), "tap"],
			]
			if not "got_matches" in flags:
				list.append(["matchbox", Rect2(750, 270, 70, 40), "tap"])
		"MG2":
			list = [
				["moon", Rect2(630, 60, 140, 130), "tap"],
				["stonelantern", Rect2(450, 70, 90, 140), "tap"],
				["bridge", Rect2(640, 160, 270, 140), "tap"],
				["pond", Rect2(60, 220, 560, 100), "go:mgkoi"],
				["paperboat", Rect2(150, 330, 100, 40), "go:mgpond" if "boat_ready" in flags else "tap"],
			]
			if "koi_fed" in flags and not "got_candles" in flags:
				list.append(["candlebox", Rect2(320, 326, 90, 44), "tap"])
		"MG3":
			list = [
				["rocks", Rect2(300, 110, 300, 80), "tap"],
				["gravel", Rect2(150, 200, 600, 170), "go:mggravel"],
				["shrine", Rect2(780, 100, 140, 150), "tap"],
			]
			if not "got_food" in flags:
				list.append(["offering", Rect2(805, 260, 80, 40), "tap"])
		"MG4":
			list = [
				["bamboo", Rect2(150, 220, 50, 140), "tap"],
				["spout", Rect2(300, 150, 170, 110), "cmd:catch"],
				["basin", Rect2(320, 270, 160, 90), "tap"],
				["shed", Rect2(570, 150, 160, 220), "tap"],
				["gate", Rect2(760, 40, 180, 330), "go:mggate"],
			]
			if not "got_ladle" in flags:
				list.append(["ladle", Rect2(490, 320, 70, 44), "tap"])
		"mgscroll":
			list = [["scroll", Rect2(120, 20, 720, 440), "tap"]]
		"mgtea":
			for k in range(5):
				list.append(["tool%d" % k, Rect2(110 + int(TOOL_SLOT[k]) * 150.0, 240, 130, 160), "cmd:tea %d" % k])
			list.append(["teaset", Rect2(260, 40, 440, 160), "tap"])
		"mgkoi":
			for k in range(4):
				list.append(["koi%d" % k, Rect2(60 + int(KOI_ZONE[k]) * 215.0, 140, 190, 220), "cmd:koi %d" % k])
		"mgpond":
			list = _pad("fan")
		"mggravel":
			if "raked" in flags:
				if not "got_chestkey" in flags:
					list.append(["glint", Rect2(BED_AT.x + 2 * BED.x + 100, BED_AT.y + BED.y + 60, 50, 40), "tap"])
				list.append(["gravel", Rect2(BED_AT.x, BED_AT.y, BED.x * 3, BED.y * 2), "tap"])
			else:
				for k in range(6):
					list.append(["bed%d" % k, Rect2(BED_AT.x + (k % 3) * BED.x, BED_AT.y + int(k / 3) * BED.y, BED.x, BED.y), "cmd:turn gravel %d +1" % k])
		"mggate":
			for k in range(3):
				list.append(["ring%d" % k, Rect2(RING_X[k] - 65, RING_Y - 65, 130, 130), "cmd:ring %d" % k])
			list.append(["gong", Rect2(400, 340, 160, 110), "tap"])
		# --- The Great Balloon Race
		"BL1":
			list = [
				["judge", Rect2(40, 140, 100, 120), "tap"],
				["card", Rect2(150, 240, 100, 50), "go:blcard" if "got_card" in flags else "tap"],
				["tent", Rect2(270, 100, 190, 180), "tap"],
				["envelope", Rect2(470, 20, 200, 230), "tap"],
				["basket", Rect2(500, 270, 140, 100), "tap"],
				["gascart", Rect2(660, 250, 130, 120), "tap"],
				["sandpile", Rect2(810, 300, 130, 70), "tap"],
			]
			if not "got_wrench" in flags:
				list.append(["toolbox", Rect2(320, 300, 90, 60), "tap"])
		"BL2":
			list = [
				["altimeter", Rect2(70, 70, 140, 140), "tap"],
				["compass", Rect2(230, 70, 140, 140), "tap"],
				["mapcase", Rect2(390, 90, 160, 100), "go:blcase"],
				["rigging", Rect2(60, 240, 470, 130), "go:blrigging"],
				["pigeon", Rect2(570, 250, 130, 120), "tap"],
				["hamper", Rect2(730, 250, 170, 120), "tap"],
			]
			if not "got_binoculars" in flags:
				list.append(["binocase", Rect2(580, 90, 110, 80), "tap"])
		"BL3":
			list = [["ground", Rect2(100, 40, 760, 330), "go:blmap"]]
			if "landed" in flags:
				list = [["farmer", Rect2(560, 180, 130, 190), "tap"], ["ground", Rect2(100, 40, 440, 330), "tap"]]
				list.append(["note", Rect2(720, 240, 160, 120), "go:blnote"])
		"BL4":
			list = [
				["clouds", Rect2(560, 30, 360, 110), "tap"],
				["kite", Rect2(380, 110, 150, 170), "tap"],
				["rival", Rect2(720, 160, 160, 170), "tap"],
				["smoke", Rect2(60, 250, 240, 120), "tap"],
				["birds", Rect2(140, 60, 200, 80), "tap"],
			]
		"blcard":
			list = [["racecard", Rect2(140, 20, 680, 440), "tap"]]
		"blcase":
			if not "compass_ok" in flags:
				list.append(["magnet", Rect2(612, 318, 56, 40), "tap"])
			list.append(["compass", Rect2(140, 60, 300, 300), "tap"])
		"blrigging":
			for k in range(4):
				list.append(["rope%d" % k, Rect2(120 + k * 190.0, 250, 140, 170), "cmd:rope %d" % k])
			list.append(["rigging", Rect2(220, 20, 520, 190), "tap"])
		"blmap":
			for key in ["drift", "sand", "valve", "hook"]:
				list.append([key, FLY[key], "cmd:" + key])
			if "saw_fields" in flags and art != null:
				var fields: Array = art.clues.get("fields", [])
				for k in range(fields.size()):
					var c := int(fields[k][0])
					list.append(["field%d" % k, Rect2(MAP_AT.x + (c % 8) * MAP_CELL, MAP_AT.y + int(c / 8) * MAP_CELL, MAP_CELL, MAP_CELL), "tap"])
		"blnote":
			list = _updown("note", 0, 330, 220) + _updown("note", 1, 500, 220)
			list.append(["send", Rect2(660, 300, 200, 90), "cmd:send"])
		# --- The Dragon's Egg
		"DG1":
			list = [
				["carving", Rect2(360, 20, 240, 50), "tap"],
				["door", Rect2(360, 80, 240, 290), "go:DG2" if "door_open" in flags else "go:dgrunes"],
				["cart", Rect2(60, 230, 230, 140), "go:dgcart"],
				["lantern", Rect2(690, 70, 80, 210), "tap"],
				["snow", Rect2(60, 20, 260, 120), "tap"],
			]
			if not "got_torch" in flags:
				list.append(["torches", Rect2(800, 220, 110, 150), "tap"])
		"DG2":
			list = [
				["bells", Rect2(620, 20, 300, 120), "go:dgbells"],
				["dragon", Rect2(80, 110, 500, 160), "tap"],
				["gold", Rect2(60, 280, 560, 90), "go:dghoard"],
				["notes", Rect2(700, 300, 180, 70), "go:dgnotes"],
				["lava", Rect2(640, 150, 140, 130), "go:DG3" if "crossed" in flags else "tap"],
			]
		"DG3":
			list = [
				["mirrors", Rect2(70, 60, 300, 200), "go:dgmirrors"],
				["crystal", Rect2(420, 40, 120, 130), "tap"],
				["floor", Rect2(120, 280, 700, 90), "go:dgfloor"],
				["crag", Rect2(780, 50, 150, 210), "go:DG4" if "across" in flags else "tap"],
			]
		"DG4":
			list = [
				["valley", Rect2(250, 20, 500, 140), "tap"],
				["crag", Rect2(60, 60, 140, 300), "tap"],
				["vent", Rect2(360, 280, 180, 90), "cmd:hold"],
				["nest", Rect2(620, 200, 270, 160), "tap"],
			]
		"dgrunes":
			for k in range(4):
				list.append_array(_updown("runes", k, 240 + k * 160.0, 210))
		"dgcart":
			if not "got_rope" in flags:
				list.append(["cart", Rect2(640, 260, 200, 140), "tap"])
			list.append(["tallies", Rect2(100, 40, 480, 380), "tap"])
		"dgbells":
			for k in range(4):
				list.append(["bell%d" % k, Rect2(110 + k * 190.0, 80, 160, 260), "cmd:bell %d" % k])
		"dghoard":
			list = [["step", Rect2(380, 380, 200, 70), "cmd:step"]]
			if "cage_open" in flags:
				if not "got_egg" in flags:
					list.append(["cage", Rect2(760, 150, 170, 200), "tap"])
			else:
				for k in range(4):
					list.append(["key%d" % k, Rect2(740 + (k % 2) * 90.0, 270 + int(k / 2) * 50.0, 80, 46), "cmd:key %d" % k])
				list.append(["cage", Rect2(760, 120, 170, 140), "tap"])
			if not "got_scale" in flags:
				list.append(["scale", Rect2(660, 330, 46, 40), "tap"])
			list.append(["dragon", Rect2(140, 20, 480, 160), "tap"])
		"dgnotes":
			list = [["notes", Rect2(60, 30, 840, 420), "tap"]]
		"dgmirrors":
			list = _updown("mirrors", 0, 330, 230) + _updown("mirrors", 1, 630, 230)
			list.append(["crystal", Rect2(430, 20, 100, 100), "tap"])
		"dgfloor":
			list = _pad("slide")
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var flags: Array = st.get("flags", [])
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		var risen: bool = "done" in flags
		var warm := [Vector4(480, 260, 420, 0.7)]
		if "lantern_lit" in flags:
			warm.append(Vector4(500, 120, 260, 0.8))
		return {"dark": 0.12 if close else (0.18 if risen else 0.3), "warm": warm, "cold": Vector4(760, 60, 500, 0.6), "tint": Vector3(0.0, 0.02, 0.06)}
	if place in RINGS[1]:
		return {"dark": 0.02 if close else 0.04, "warm": [Vector4(700, 40, 700, 0.5)], "cold": Vector4.ZERO, "tint": Vector3(0.05, 0.03, 0.0)}
	# The mountain: snow outside, then darkness lit by gold and lava.
	if view == "DG1" or view in ["dgrunes", "dgcart"]:
		return {"dark": 0.25, "warm": [Vector4(730, 120, 260, 0.9)], "cold": Vector4(480, 0, 700, 0.5), "tint": Vector3(0.0, 0.02, 0.08)}
	var lit: bool = "torch_lit" in flags
	return {"dark": 0.3 if lit else 0.55, "warm": [Vector4(480, 300, 600, 0.9), Vector4(300, 200, 400, 0.6)], "cold": Vector4.ZERO, "tint": Vector3(0.08, 0.02, 0.0)}
