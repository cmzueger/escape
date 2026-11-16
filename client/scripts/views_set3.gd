## The third set: Low Tide (B…), Night Train (N…) and The Alchemist's Cellar
## (A…): views, close-ups, hotspots and light (see views.gd and
## views_set2.gd). Rectangles match the drawings in art_set3.gd.
class_name Set3Views
extends RefCounted

const RINGS := [["B1", "B2"], ["N1", "N2"], ["A1", "A2"]]
const PARENT := {
	"bbottle": "B1", "tideclock": "B1", "bwindow": "B2", "kites": "B2", "bbox": "B2",
	"ncase": "N1", "nbrief": "N1", "timetable": "N2", "nticket": "N2", "npanel": "N2",
	"vials": "A1", "scales": "A1", "furnace": "A1", "abook": "A2", "achart": "A2", "disc": "A2",
}
const FIRST := {"beach": "B1", "train": "N1", "alch": "A1"}


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func spots(view: String, st: Dictionary, art: ArtSet3) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- Low Tide
		"B1":
			list = [
				["locker", Rect2(40, 150, 150, 226), "tap"],
				["bottle", Rect2(392, 186, 132, 48), "go:bbottle"],
				["tideclock", Rect2(676, 96, 108, 108), "go:tideclock"],
				["buoys", Rect2(226, 14, 150, 100), "tap"],
				["towel", Rect2(196, 150, 40, 110), "tap"],
				["shells", Rect2(240, 196, 420, 40), "tap"],
				["door", Rect2(840, 104, 110, 272), "tap"],
			]
		"B2":
			list = [
				["window", Rect2(80, 60, 380, 230), "go:bwindow"],
				["kites", Rect2(500, 20, 360, 190), "go:kites"],
				["shellbox", Rect2(596, 250, 118, 54), "go:bbox"],
				["tin" if "dug" in flags else "sand", Rect2(120, 390, 240, 78), "tap"],
				["net", Rect2(880, 14, 80, 170), "tap"],
				["shells", Rect2(520, 268, 380, 34), "tap"],
			]
		"bbox":
			list = [["shellbox", Rect2(220, 80, 520, 330), "tap"]] if "box_open" in flags else Set2Views._wheels("box", 3, 400, 270)
		"bbottle":
			list = [["bottle", Rect2(200, 40, 600, 400), "tap"]]
		"kites":
			for i in range(3):
				list.append(["hook%d" % i, Rect2(256 + i * 180.0, 376, 88, 84), "cmd:pull %d" % i])
		"tideclock":
			if "hand_on" in flags:
				list.append(["tide_back", Rect2(56, 196, 104, 84), "cmd:turn tide 0 -1"])
				list.append(["tide_on", Rect2(640, 196, 104, 84), "cmd:turn tide 0 +1"])
			list.append(["clockbox", Rect2(770, 150, 150, 180), "tap"])
			list.append(["tideclock", Rect2(210, 46, 380, 380), "tap"])
		"bwindow":
			list = [["post", Rect2(430, 60, 110, 380), "tap"], ["sea", Rect2(0, 0, 960, 472), "tap"]]
		# --- Night Train
		"N1":
			list.append(["suitcase", Rect2(70, 44, 170, 72), "go:ncase"])
			var xs := [60.0, 170.0, 690.0, 800.0]
			var seats: Array = art.clues.get("seats", []) if art != null else []
			for i in range(4):
				var under: bool = "seat_up" in flags and i < seats.size() and int(seats[i]) == int(art.clues.get("seat", -1))
				if under:
					list.append(["briefcase", Rect2(xs[i] - 4, 250, 108, 126), "go:nbrief"])
				else:
					list.append(["seat%d" % i, Rect2(xs[i] - 4, 134, 108, 242), "cmd:seat %d" % i])
			list.append(["window", Rect2(300, 70, 360, 180), "tap"])
			list.append(["bags", Rect2(720, 56, 120, 60), "tap"])
		"N2":
			list.append(["timetable", Rect2(190, 244, 154, 48), "go:timetable"])
			if "got_case" in flags:
				list.append(["tickets", Rect2(398, 264, 100, 28), "go:nticket"])
			list.append_array([
				["lamp", Rect2(56, 56, 68, 46), "tap"],
				["coat", Rect2(560, 60, 100, 190), "tap"],
				["panel", Rect2(690, 110, 110, 150), "go:npanel"],
				["door", Rect2(836, 40, 114, 336), "tap"],
			])
		"ncase":
			list = [["suitcase", Rect2(170, 110, 620, 290), "tap"]] if "case_open" in flags else Set2Views._wheels("case", 3, 400, 240)
		"nticket":
			list = [["ticket", Rect2(160, 100, 640, 270), "tap"]]
		"nbrief":
			if "brief_open" in flags:
				list = [["briefcase", Rect2(170, 110, 620, 290), "tap"]]
			else:
				for i in range(4):
					var cx := 360.0 + i * 80.0
					list.append(["brief_up%d" % i, Rect2(cx - 36, 174, 72, 56), "cmd:turn brief %d +1" % i])
					list.append(["brief_face%d" % i, Rect2(cx - 36, 230, 72, 88), "cmd:turn brief %d +1" % i])
					list.append(["brief_down%d" % i, Rect2(cx - 36, 318, 72, 56), "cmd:turn brief %d -1" % i])
		"npanel":
			for i in range(9):
				list.append(["button%d" % i, Rect2(336 + (i % 3) * 100.0, 76 + floorf(i / 3.0) * 100.0, 88, 88), "cmd:flip panel %d" % i])
			list.append(["socket", Rect2(686, 176, 88, 158), "tap"])
		# --- The Alchemist's Cellar
		"A1":
			list = [
				["vialrack", Rect2(146, 216, 198, 70), "go:vials"],
				["scales", Rect2(416, 196, 168, 100), "go:scales"],
				["furnace", Rect2(690, 150, 220, 230), "go:furnace"],
				["jars", Rect2(80, 56, 360, 64), "tap"],
				["candles", Rect2(490, 60, 70, 60), "tap"],
			]
		"A2":
			list = [
				["book", Rect2(116, 246, 168, 136), "go:abook"],
				["chartwall", Rect2(330, 70, 200, 160), "go:achart"],
				["cabinet", Rect2(580, 150, 140, 226), "tap"],
				["disc", Rect2(286, 384, 268, 84), "go:disc"],
				["owl", Rect2(792, 72, 56, 56), "tap"],
				["skull", Rect2(36, 332, 48, 46), "tap"],
				["door", Rect2(784, 150, 130, 226), "tap"],
			]
		"vials":
			for i in range(3):
				var x := 260.0 + i * 220.0
				for p in range(3):
					list.append(["dash%d%d" % [i, p], Rect2(x - 56 + p * 56.0 - 27, 273, 54, 54), "cmd:mix %d %d" % [i, p]])
				list.append(["empty%d" % i, Rect2(x - 44, 346, 88, 52), "cmd:empty %d" % i])
			if "cab_open" in flags:
				list.append(["vialrack", Rect2(60, 404, 840, 60), "tap"])
		"scales":
			for i in range(3):
				list.append(["weight%d" % i, Rect2(340 + i * 100.0, 380, 80, 78), "cmd:turn pans %d +1" % i])
			list.append(["scaledrawer", Rect2(700, 380, 200, 78), "tap"])
		"disc":
			for k in range(3):
				list.append(["ring%d_back" % k, Rect2(686, 86 + k * 100.0, 84, 72), "cmd:turn rings %d -1" % k])
				list.append(["ring%d_on" % k, Rect2(772, 86 + k * 100.0, 84, 72), "cmd:turn rings %d +1" % k])
			list.append(["hatch", Rect2(346, 182, 108, 108), "tap"])
		"furnace":
			list = [["furnace", Rect2(250, 150, 340, 270), "tap"], ["bellows", Rect2(720, 250, 180, 150), "cmd:bellows"]]
	return list


static func lights(view: String, _st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		return {"dark": 0.04, "warm": [Vector4(480, 200, 800, 1.0)], "cold": none, "tint": Vector3(0.0, 0.05, 0.1)}
	if place in RINGS[1]:
		var navy := Vector3(0.02, 0.02, 0.07)
		if close:
			return {"dark": 0.2, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": navy}
		return {"dark": 0.46, "warm": [Vector4(480 if view == "N1" else 140, 150 if view == "N1" else 100, 560, 1.0)], "cold": none, "tint": navy}
	var green := Vector3(0.02, 0.06, 0.03)
	if close:
		return {"dark": 0.22, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": green}
	if view == "A1":
		return {"dark": 0.56, "warm": [Vector4(520, 100, 320, 0.9), Vector4(800, 300, 260, 0.8)], "cold": Vector4(240, 250, 240, 0.5), "tint": green}
	return {"dark": 0.56, "warm": [Vector4(200, 280, 300, 0.8)], "cold": Vector4(420, 420, 300, 0.6), "tint": green}
