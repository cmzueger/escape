## The fifth set: Lookout (E…), Gondola 12 (Q…), Praline Works (P…) and
## Tinker & Sons (Y…): views, close-ups, hotspots and light (see views.gd).
## Rectangles match the drawings in art_set5.gd.
class_name Set5Views
extends RefCounted

const RINGS := [["E1", "E2"], ["Q1", "Q2"], ["P1", "P2"], ["Y1", "Y2"]]
const PARENT := {
	"edarts": "E1", "echest": "E1", "eperi": "E1", "ehatch": "E1", "ebeam": "E2", "emap": "E2",
	"qwindow": "Q1", "qpanel": "Q1", "qmap": "Q2", "qbag": "Q2", "qsill": "Q2", "qkit": "Q2",
	"pkettle": "P1", "ptray": "P1", "precipe": "P1", "pcab": "P1", "psign": "P2", "plocker": "P2", "pcards": "P2",
	"ytrain": "Y1", "ygifts": "Y1", "ynotes": "Y1", "ydrawers": "Y2", "ydoll": "Y2", "ymaze": "Y2",
}
const FIRST := {"tree": "E1", "gondola": "Q1", "praline": "P1", "toyshop": "Y1"}
## The mirror board's cells (ebeam) and the tilt boards.
const BEAM_X := 240.0
const BEAM_Y := 56.0
const BEAM_CELL := 80.0
const MAZE_X := 312.0
const MAZE_Y := 52.0
const MAZE_CELL := 56.0
const TRAY_X := 330.0
const TRAY_Y := 56.0
const TRAY_CELL := 60.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


## Tilt arrows around a board (n, e, s, w) and a reset knob.
static func _tilts(x: float, y: float, size: float) -> Array:
	return [
		["tilt_n", Rect2(x + size / 2 - 70, y - 50, 140, 48), "cmd:tilt n"],
		["tilt_s", Rect2(x + size / 2 - 70, y + size + 4, 140, 48), "cmd:tilt s"],
		["tilt_w", Rect2(x - 80, y + size / 2 - 70, 70, 140), "cmd:tilt w"],
		["tilt_e", Rect2(x + size + 10, y + size / 2 - 70, 70, 140), "cmd:tilt e"],
		["tilt_reset", Rect2(60, 360, 150, 90), "cmd:tilt reset"],
	]


static func spots(view: String, st: Dictionary, _art: ArtSet5) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- Lookout
		"E1":
			list = [
				["window", Rect2(60, 50, 240, 170), "tap"],
				["flag", Rect2(300, 50, 50, 80), "tap"],
				["darts", Rect2(390, 70, 140, 140), "go:edarts"],
				["periscope", Rect2(640, 0, 120, 270), "go:eperi"],
				["chest", Rect2(110, 270, 220, 110), "go:echest"],
				["hatch", Rect2(470, 380, 220, 80), "go:ehatch"],
				["leaves", Rect2(790, 320, 150, 60), "tap"],
			]
		"E2":
			list = [
				["lamp", Rect2(90, 150, 150, 130), "tap"],
				["board", Rect2(290, 40, 380, 300), "go:ebeam"],
				["map", Rect2(710, 50, 200, 150), "go:emap"],
				["comics", Rect2(720, 290, 160, 70), "tap"],
				["blanket", Rect2(30, 320, 230, 50), "tap"],
			]
		"edarts":
			list = [["darts", Rect2(250, 30, 460, 420), "tap"]]
		"echest":
			list = [["chest", Rect2(170, 110, 620, 290), "tap"]] if "chest_open" in flags else Set2Views._wheels("chest", 3, 400, 260)
		"ebeam":
			for i in range(4):
				var m: Array = [[2, 1], [2, 3], [5, 3], [5, 0]][i]
				list.append(["mirror%d" % i, Rect2(BEAM_X + m[0] * BEAM_CELL, BEAM_Y + m[1] * BEAM_CELL, BEAM_CELL, BEAM_CELL), "cmd:turn mirrors %d +1" % i])
			list.append(["lamp", Rect2(110, 120, 120, 120), "tap"])
			list.append(["alarm", Rect2(560, 384, 230, 80), "tap"])
		"eperi":
			list = [
				["peri_left", Rect2(60, 180, 110, 110), "cmd:turn peri 0 -1"],
				["peri_right", Rect2(790, 180, 110, 110), "cmd:turn peri 0 +1"],
				["periscope", Rect2(250, 30, 460, 420), "tap"],
			]
		"emap":
			list = [["map", Rect2(160, 20, 640, 440), "tap"]]
		"ehatch":
			list = Set2Views._wheels("hatch", 4, 360, 250)
			list.append(["hatch", Rect2(160, 410, 640, 50), "tap"])
		# --- Gondola 12
		"Q1":
			list = [
				["window", Rect2(60, 40, 560, 270), "go:qwindow"],
				["panel", Rect2(680, 130, 230, 210), "go:qpanel"],
				["door", Rect2(640, 20, 30, 340), "tap"],
			]
		"Q2":
			list = [
				["sill", Rect2(50, 30, 280, 230), "go:qsill"],
				["bag", Rect2(130, 240, 140, 120), "go:qbag"],
				["bench", Rect2(300, 300, 260, 70), "tap"],
				["skis", Rect2(520, 40, 90, 320), "tap"],
				["map", Rect2(630, 40, 200, 160), "go:qmap"],
				["kit", Rect2(840, 70, 110, 110), "go:qkit"],
			]
		"qwindow":
			list = [["pylon", Rect2(460, 60, 200, 320), "tap"], ["valley", Rect2(40, 200, 400, 250), "tap"]]
		"qmap":
			list = [["map", Rect2(120, 20, 720, 440), "tap"]]
		"qbag":
			list = [["bag", Rect2(220, 80, 520, 330), "tap"]] if "bag_open" in flags else Set2Views._wheels("bag", 3, 400, 270)
		"qsill":
			list = [
				["turn_left", Rect2(40, 300, 110, 110), "cmd:turn turn 0 -1"],
				["turn_right", Rect2(400, 300, 110, 110), "cmd:turn turn 0 +1"],
				["sculpture", Rect2(170, 170, 210, 250), "tap"],
				["sun", Rect2(20, 20, 200, 140), "tap"],
			]
		"qkit":
			if "kit_open" in flags:
				list = [["kit", Rect2(200, 90, 300, 300), "tap"], ["card", Rect2(540, 70, 340, 340), "tap"]]
			else:
				list = Set2Views._wheels("kit", 3, 400, 270)
		"qpanel":
			if not "cover_off" in flags:
				list = [["panel", Rect2(180, 40, 600, 400), "tap"]]
			else:
				var brake: int = int(st.get("brake", [0])[0])
				list = [
					["fuseslot", Rect2(150, 70, 150, 160), "tap"],
					["brake", Rect2(360, 60, 140, 230), "cmd:turn brake 0 %s" % ("+1" if brake == 0 else "-1")],
					["dir_up", Rect2(580, 50, 120, 110), "cmd:turn dir 0 +1"],
					["dir_down", Rect2(580, 220, 120, 110), "cmd:turn dir 0 -1"],
					["start", Rect2(760, 120, 140, 140), "cmd:start"],
					["panel", Rect2(150, 350, 660, 100), "tap"],
				]
		# --- Praline Works
		"P1":
			list = [
				["kettle", Rect2(40, 60, 250, 310), "go:pkettle"],
				["recipe", Rect2(330, 40, 300, 180), "go:precipe"],
				["conveyor", Rect2(300, 236, 400, 60), "tap"],
				["tray", Rect2(370, 300, 220, 70), "go:ptray"],
				["cabinet", Rect2(720, 50, 220, 230), "go:pcab"],
				["lamp", Rect2(450, 0, 80, 40), "tap"],
			]
			if not "got_torn1" in flags:
				list.push_front(["floor", Rect2(620, 384, 120, 60), "tap"])
		"P2":
			list = [
				["sign", Rect2(50, 30, 280, 170), "go:psign"],
				["machine", Rect2(50, 210, 290, 160), "tap"],
				["locker", Rect2(570, 70, 75, 290), "go:plocker"],
				["lockers", Rect2(350, 70, 215, 290), "tap"],
				["cards", Rect2(660, 70, 120, 190), "go:pcards"],
				["door", Rect2(800, 50, 150, 320), "tap"],
			]
		"psign":
			list = [["sign", Rect2(80, 20, 800, 430), "tap"]]
		"pcards":
			list = [["cards", Rect2(120, 20, 720, 430), "tap"]]
		"plocker":
			list = [["locker", Rect2(250, 60, 460, 360), "tap"]] if "locker_open" in flags else Set2Views._wheels("locker", 3, 400, 280)
		"pcab":
			list = [["cabinet", Rect2(200, 80, 560, 330), "tap"]] if "cab_open" in flags else Set2Views._wheels("cab", 4, 360, 270)
		"ptray":
			list = _tilts(TRAY_X, TRAY_Y, TRAY_CELL * 5)
			list.append(["trayhatch", Rect2(730, 360, 200, 90), "tap"])
		"precipe":
			# Only placed pieces turn; an empty corner takes a piece (as the frame).
			for i in range(4):
				if not ("placed%d" % (i + 1)) in flags:
					continue
				list.append(["piece%d" % i, Rect2(280 + (i % 2) * 200.0, 36 + floorf(i / 2.0) * 200.0, 200, 200), "cmd:rotate %d" % i])
			list.append(["recipe", Rect2(240, 20, 480, 440), "tap"])
		"pkettle":
			list = Set2Views._wheels("kettle", 6, 280, 270)
			list.append(["kettle", Rect2(80, 410, 800, 50), "tap"])
		# --- Tinker & Sons
		"Y1":
			list = [
				["tree", Rect2(130, 50, 140, 220), "tap"],
				["train", Rect2(50, 270, 310, 80), "go:ytrain"],
				["gifts", Rect2(280, 210, 120, 70), "go:ygifts"],
				["till", Rect2(540, 160, 140, 90), "tap"],
				["notes", Rect2(700, 200, 90, 50), "go:ynotes"],
				["door", Rect2(820, 60, 130, 310), "tap"],
				["bell", Rect2(850, 20, 60, 40), "tap"],
				["snow", Rect2(40, 40, 70, 70), "tap"],
			]
		"Y2":
			list = [
				["drawers", Rect2(50, 50, 260, 200), "go:ydrawers"],
				["dollhouse", Rect2(350, 100, 240, 230), "go:ydoll"],
				["maze", Rect2(630, 240, 200, 130), "go:ymaze"],
				["nutcracker", Rect2(850, 120, 100, 200), "tap"],
				["bear", Rect2(50, 280, 110, 90), "tap"],
				["rocker", Rect2(170, 270, 160, 100), "tap"],
				["shelf", Rect2(630, 50, 200, 130), "tap"],
			]
		"ydrawers":
			for i in range(12):
				list.append(["drawer%d" % i, Rect2(150 + (i % 4) * 165.0, 40 + floorf(i / 4.0) * 135.0, 160, 130), "cmd:drawer %d" % i])
		"ydoll":
			list = [["dollhouse", Rect2(120, 20, 720, 440), "tap"]]
		"ytrain":
			list = [["station", Rect2(660, 230, 230, 140), "tap"], ["train", Rect2(60, 140, 580, 280), "tap"]]
		"ygifts":
			for i in range(4):
				list.append(["gift%d" % i, Rect2(70 + i * 215.0, 120, 180, 300), "cmd:turn gifts %d +1" % i])
		"ynotes":
			list = [["notes", Rect2(140, 20, 680, 440), "tap"]]
		"ymaze":
			list = _tilts(MAZE_X, MAZE_Y, MAZE_CELL * 6)
			list.append(["mazebox", Rect2(730, 360, 200, 90), "tap"])
			list.append(["maze", Rect2(MAZE_X, MAZE_Y, MAZE_CELL * 6, MAZE_CELL * 6), "tap"])
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	var flags: Array = st.get("flags", [])
	if place in RINGS[0]:
		# Late autumn afternoon: warm light from the window.
		return {"dark": 0.12 if close else 0.26, "warm": [Vector4(200, 120, 700, 1.0)], "cold": none, "tint": Vector3(0.08, 0.04, 0.0)}
	if place in RINGS[1]:
		# Bright snowy morning.
		return {"dark": 0.0 if close else 0.06, "warm": [], "cold": none, "tint": Vector3(0.0, 0.02, 0.05)}
	if place in RINGS[2]:
		return {"dark": 0.16 if close else 0.34, "warm": [Vector4(490, 60, 520, 1.0)], "cold": none, "tint": Vector3(0.06, 0.03, 0.01)}
	var lit := "tree_lit" in flags
	var warm := [Vector4(560, 120, 520, 1.0)]
	if lit and view == "Y1":
		warm.append(Vector4(200, 160, 300, 1.0))
	return {"dark": 0.14 if close else 0.3, "warm": warm, "cold": none, "tint": Vector3(0.06, 0.02, 0.02)}
