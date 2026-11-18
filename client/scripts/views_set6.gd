## The sixth set: Graf Alpina (Z…), Albatross (V…) and Base 70° South (R…):
## views, close-ups, hotspots and light (see views.gd). Rectangles match the
## drawings in art_set6.gd.
class_name Set6Views
extends RefCounted

const RINGS := [["Z1", "Z2"], ["V1", "V2"], ["R1", "R2"]]
const PARENT := {
	"zwindow": "Z1", "zcompass": "Z1", "ztelegram": "Z1",
	"zcab": "Z2", "zphoto": "Z2", "zbook": "Z2", "zchart": "Z2", "zvalves": "Z2",
	"vwindow": "V1", "vcompass": "V1", "vbell": "V1", "vlog": "V1",
	"vlocker": "V2", "vdiagram": "V2", "vchart": "V2", "vballast": "V2",
	"rboard": "R1", "rlog": "R1", "rmap": "R1", "rradio": "R1",
	"rcrates": "R2", "rairlock": "R2",
}
const FIRST := {"zeppelin": "Z1", "ship": "V1", "polar": "R1"}
## The zeppelin's compass (centre, radius of the magnet slots).
const COMPASS := Vector2(300, 236)
const SLOT_R := 190.0
## The polar store's grid.
const STORE_X := 300.0
const STORE_Y := 56.0
const STORE_CELL := 60.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func slot_xy(i: int) -> Vector2:
	return COMPASS + [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)][i] * SLOT_R


static func spots(view: String, st: Dictionary, art: ArtSet6) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- Graf Alpina
		"Z1":
			list = [
				["window", Rect2(60, 30, 600, 200), "go:zwindow"],
				["compass", Rect2(410, 240, 140, 130), "go:zcompass"],
				["telegram", Rect2(720, 230, 120, 70), "go:ztelegram"],
				["radio", Rect2(850, 220, 90, 90), "tap"],
				["clock", Rect2(840, 40, 90, 90), "tap"],
				["wheel", Rect2(90, 250, 160, 120), "tap"],
			]
		"Z2":
			list = [
				["cabinet", Rect2(60, 80, 200, 280), "go:zcab"],
				["photo", Rect2(300, 50, 170, 130), "go:zphoto"],
				["book", Rect2(500, 50, 190, 130), "go:zbook"],
				["chart", Rect2(470, 220, 280, 150), "go:zchart"],
				["valves", Rect2(780, 50, 160, 320), "go:zvalves"],
				["lamp", Rect2(300, 200, 90, 90), "tap"],
			]
		"zphoto":
			list = [["photo", Rect2(120, 20, 720, 440), "tap"]]
		"zcab":
			list = [["cabinet", Rect2(200, 80, 560, 330), "tap"]] if "cab_open" in flags else Set2Views._wheels("cab", 4, 360, 270)
		"ztelegram":
			list = [["telegram", Rect2(120, 40, 720, 400), "tap"]]
		"zbook":
			list = [["book", Rect2(100, 30, 760, 420), "tap"]]
		"zcompass":
			for i in range(4):
				var p := slot_xy(i)
				list.append(["slot%d" % i, Rect2(p.x - 45, p.y - 45, 90, 90), "cmd:slot %d" % i])
			list.append_array(Set2Views._wheels("course", 3, 660, 250))
			list.append(["compass", Rect2(COMPASS.x - 120, COMPASS.y - 120, 240, 240), "tap"])
		"zwindow":
			list = [["window", Rect2(20, 20, 920, 432), "tap"]]
		"zvalves":
			list = Set2Views._wheels("valve", 3, 400, 270)
			list.append(["valves", Rect2(160, 410, 640, 50), "tap"])
		"zchart":
			if not "got_horseshoe" in flags:
				list.append(["paperweight", Rect2(560, 250, 160, 120), "tap"])
			list.append(["chart", Rect2(100, 40, 760, 400), "tap"])
		# --- Albatross
		"V1":
			list = [
				["window", Rect2(60, 30, 840, 190), "go:vwindow"],
				["compass", Rect2(240, 240, 130, 130), "go:vcompass"],
				["wheel", Rect2(400, 230, 160, 140), "tap"],
				["telegraph", Rect2(610, 220, 110, 150), "tap"],
				["bell", Rect2(50, 230, 100, 110), "go:vbell"],
				["inclinometer", Rect2(740, 240, 100, 70), "tap"],
				["log", Rect2(840, 300, 110, 70), "go:vlog"],
				["plaque", Rect2(160, 250, 70, 40), "tap"],
			]
		"V2":
			list = [
				["locker", Rect2(60, 70, 170, 290), "go:vlocker"],
				["diagram", Rect2(260, 40, 330, 170), "go:vdiagram"],
				["chart", Rect2(260, 240, 330, 130), "go:vchart"],
				["cabinet", Rect2(610, 220, 100, 150), "tap"],
				["panel", Rect2(730, 50, 210, 310), "go:vballast"],
			]
		"vbell":
			list = [["bell", Rect2(240, 20, 480, 440), "tap"]]
		"vlocker":
			list = [["locker", Rect2(220, 60, 520, 360), "tap"]] if "locker_open" in flags else Set2Views._wheels("locker", 4, 360, 270)
		"vdiagram":
			for i in range(3):
				list.append(["filt%d" % i, Rect2(770, 60 + i * 130.0, 150, 120), "cmd:flip filt %d" % i])
			list.append(["diagram", Rect2(40, 30, 700, 420), "tap"])
		"vlog":
			list = [["log", Rect2(140, 20, 680, 440), "tap"]]
		"vballast":
			list = [
				["tank_pc", Rect2(275, 330, 110, 70), "cmd:tank pc"],
				["tank_cs", Rect2(575, 330, 110, 70), "cmd:tank cs"],
				["tank_flood", Rect2(420, 20, 120, 60), "cmd:tank flood"],
				["tank_pump", Rect2(420, 400, 120, 60), "cmd:tank pump"],
				["inclinometer", Rect2(20, 8, 160, 76), "tap"],
				["panel", Rect2(60, 90, 840, 230), "tap"],
			]
		"vwindow":
			list = [["lights", Rect2(40, 60, 880, 180), "tap"], ["storm", Rect2(40, 240, 880, 220), "tap"]]
		"vchart":
			list = [["chart", Rect2(60, 20, 840, 440), "tap"]]
		"vcompass":
			list = Set2Views._wheels("course", 3, 400, 270)
			list.append(["wheel", Rect2(160, 410, 640, 50), "tap"])
		# --- Base 70° South
		"R1":
			list = [
				["board", Rect2(50, 50, 240, 220), "go:rboard"],
				["map", Rect2(320, 40, 270, 190), "go:rmap"],
				["log", Rect2(320, 270, 150, 90), "go:rlog"],
				["radio", Rect2(610, 170, 320, 200), "go:rradio"],
				["window", Rect2(620, 30, 300, 120), "tap"],
			]
		"R2":
			list = [
				["store", Rect2(50, 50, 400, 320), "go:rcrates"],
				["generator", Rect2(470, 190, 220, 180), "tap"],
				["photo", Rect2(490, 50, 170, 110), "tap"],
				["airlock", Rect2(730, 30, 210, 340), "go:rairlock"],
			]
		"rboard":
			list = [["board", Rect2(140, 60, 680, 360), "tap"]] if "board_open" in flags else Set2Views._wheels("board", 4, 300, 280, 120.0)
		"rlog":
			list = [["log", Rect2(120, 20, 720, 440), "tap"]]
		"rmap":
			list = [["map", Rect2(100, 20, 760, 440), "tap"]]
		"rradio":
			list = Set2Views._wheels("radio", 3, 240, 270)
			list.append(["teleprinter", Rect2(560, 60, 360, 360), "tap"])
			list.append(["radio", Rect2(120, 420, 360, 40), "tap"])
		"rcrates":
			var at: Array = st.get("crates", [])
			var sizes: Array = art.clues.get("crates", []) if art != null else []
			for i in range(mini(sizes.size(), int(at.size() / 2.0))):
				var len: int = int(sizes[i][0])
				var lying: bool = int(sizes[i][1]) == 1
				var x := STORE_X + int(at[i * 2]) * STORE_CELL
				var y := STORE_Y + int(at[i * 2 + 1]) * STORE_CELL
				list.append(["crate%d" % i, Rect2(x, y, STORE_CELL * (len if lying else 1), STORE_CELL * (1 if lying else len)), "cmd:crate %d" % i])
			var size := STORE_CELL * 6
			list.append_array([
				["push_n", Rect2(STORE_X + size / 2 - 70, STORE_Y - 52, 140, 48), "cmd:push n"],
				["push_s", Rect2(STORE_X + size / 2 - 70, STORE_Y + size + 4, 140, 48), "cmd:push s"],
				["push_w", Rect2(STORE_X - 90, STORE_Y + size / 2 - 70, 80, 140), "cmd:push w"],
				["push_e", Rect2(STORE_X + size + 10, STORE_Y + size / 2 - 70, 80, 140), "cmd:push e"],
				["crate_reset", Rect2(60, 360, 150, 90), "cmd:crate reset"],
				["redcrate", Rect2(760, 150, 180, 120), "tap"],
			])
		"rairlock":
			list = Set2Views._wheels("airlock", 4, 360, 270)
			list.append(["airlock", Rect2(160, 410, 640, 50), "tap"])
	return list


static func lights(view: String, _st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		# Golden dusk through the big windows.
		return {"dark": 0.08 if close else 0.18, "warm": [Vector4(360, 120, 700, 1.0)], "cold": none, "tint": Vector3(0.1, 0.05, 0.0)}
	if place in RINGS[1]:
		# Grey storm light, an oil lamp.
		return {"dark": 0.2 if close else 0.38, "warm": [Vector4(480, 300, 420, 1.0)], "cold": none, "tint": Vector3(0.0, 0.02, 0.04)}
	# White-out: flat grey light, red emergency lamps.
	return {"dark": 0.12 if close else 0.26, "warm": [Vector4(480, 40, 380, 0.7)], "cold": none, "tint": Vector3(0.03, 0.0, 0.0)}
