## The second set: The Orangery (G…), Curtain Call (T…) and The Grandmaster's
## Study (C…): views, close-ups, hotspots and light (see views.gd for the
## format). Rectangles match the drawings in art_set2.gd. Their rules are
## kit rooms: locks and dials are moved with "turn" and "flip".
class_name Set2Views
extends RefCounted

const RINGS := [["G1", "G2"], ["T1", "T2", "T3"], ["C1", "C2", "C3"]]
const PARENT := {
	"gcab": "G1", "gdoor": "G1", "sundial": "G2", "pipes": "G2", "pond": "G2",
	"rack": "T1", "sheet": "T1", "ttrunk": "T1", "tdesk": "T2",
	"mirror": "T3", "masks": "T3", "poster": "T3", "tdoor": "T3",
	"mini": "C1", "csafe": "C1", "bigboard": "C1", "cclock": "C1",
	"shelf": "C2", "chart": "C2", "tiles": "C2",
	"travel": "C3", "csheet": "C3", "cdrawer": "C3",
}
const FIRST := {"orangery": "G1", "theatre": "T1", "chess": "C1"}


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func _wheels(lock: String, count: int, x0: float, y0: float, gap: float = 80.0) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * gap
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 36, y0 - 66, 72, 56), "cmd:turn %s %d +1" % [lock, i]])
		spots.append(["%s_digit%d" % [lock, i], Rect2(cx - 36, y0 - 10, 72, 86), "cmd:turn %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 36, y0 + 76, 72, 58), "cmd:turn %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary, art: ArtSet2) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Orangery
		"G1":
			if not "got_can" in flags:
				list.append(["wcan", Rect2(350, 316, 76, 66), "tap"])
			list.append_array([
				["wilted", Rect2(280, 170, 54, 124), "tap"],
				["butterflies", Rect2(60, 80, 270, 80), "tap"],
				["flowers", Rect2(40, 160, 236, 130), "tap"],
				["bench", Rect2(30, 290, 310, 84), "tap"],
				["pot", Rect2(424, 50, 130, 336), "tap"],
				["cabinet", Rect2(590, 170, 190, 206), "go:gcab"],
				["door", Rect2(820, 104, 116, 272), "go:gdoor"],
			])
		"G2":
			list = [
				["sundial", Rect2(100, 230, 140, 150), "go:sundial"],
				["tap", Rect2(248, 190, 70, 92), "tap"],
				["pipes", Rect2(560, 120, 170, 130), "go:pipes"],
				["shed", Rect2(780, 150, 170, 230), "tap"],
				["pond", Rect2(230, 300, 500, 172), "go:pond"],
			]
		"gcab":
			list = [["cabinet", Rect2(220, 80, 520, 330), "tap"]] if "cab_open" in flags else _wheels("cab", 3, 400, 270)
		"sundial":
			list = [["sundial", Rect2(260, 20, 440, 440), "tap"]]
		"pipes":
			if "wheel_on" in flags:
				list.append(["valve0", Rect2(200, 110, 100, 100), "cmd:flip valves 0"])
			else:
				list.append(["pipes", Rect2(200, 110, 100, 100), "tap"])
			list.append(["valve1", Rect2(430, 240, 100, 100), "cmd:flip valves 1"])
			list.append(["valve2", Rect2(600, 110, 100, 100), "cmd:flip valves 2"])
		"pond":
			list = [["bottle", Rect2(300, 40, 360, 400), "tap"], ["lilies", Rect2(0, 0, 960, 472), "tap"]]
		"gdoor":
			list = _wheels("door", 4, 360, 240)
		# --- Curtain Call
		"T1":
			if not "got_plug" in flags:
				list.append(["props", Rect2(580, 256, 60, 44), "tap"])
			list.append_array([
				["ropes", Rect2(20, 0, 120, 250), "tap"],
				["winch", Rect2(36, 300, 96, 86), "tap"],
				["rack", Rect2(176, 100, 256, 284), "go:rack"],
				["callsheet", Rect2(466, 116, 98, 118), "go:sheet"],
				["trunk", Rect2(686, 278, 178, 112), "go:ttrunk"],
				["curtain", Rect2(880, 0, 80, 400), "tap"],
			])
		"T2":
			if "trap_open" in flags and art != null:
				var mark: Array = art.clues.get("mark", [0, 0])
				var p := art.stage_cell(int(mark[0]), int(mark[1]))
				list.append(["trap", Rect2(p.x - 54, p.y - 56, 108, 80), "tap"])
			list.append_array([
				["desk", Rect2(46, 298, 160, 94), "go:tdesk"],
				["ghostlight", Rect2(874, 266, 54, 128), "tap"],
				["backdrop", Rect2(120, 36, 720, 220), "tap"],
			])
		"T3":
			list = [
				["mirror", Rect2(80, 76, 270, 280), "go:mirror"],
				["masks", Rect2(400, 84, 290, 150), "go:masks"],
				["poster", Rect2(720, 84, 90, 150), "go:poster"],
				["door", Rect2(830, 104, 116, 272), "go:tdoor"],
				["chair", Rect2(510, 250, 90, 130), "tap"],
			]
		"tdesk":
			for k in range(3):
				list.append(["lamp%d" % k, Rect2(120 + k * 100.0, 70, 60, 300), "cmd:flip lamps %d" % k])
			list.append_array([
				["spot_left", Rect2(536, 296, 72, 72), "cmd:turn spot 0 -1"],
				["spot_right", Rect2(732, 296, 72, 72), "cmd:turn spot 0 +1"],
				["spot_up", Rect2(634, 282, 72, 56), "cmd:turn spot 1 -1"],
				["spot_down", Rect2(634, 340, 72, 58), "cmd:turn spot 1 +1"],
				["desk", Rect2(60, 30, 840, 420), "tap"],
			])
		"ttrunk":
			list = [["trunk", Rect2(200, 100, 200, 320), "tap"]] if "trunk_open" in flags else _wheels("trunk", 3, 400, 290)
		"masks":
			for i in range(5):
				var x := 150.0 + i * 165.0
				if i == 4 and not "mask_on" in flags:
					list.append(["gap", Rect2(x - 70, 110, 140, 180), "tap"])
				else:
					list.append(["mask%d" % i, Rect2(x - 70, 110, 140, 180), "cmd:mask %d" % i])
			list.append(["niche", Rect2(380, 380, 200, 76), "tap"])
		"mirror":
			for k in range(6):
				var a := TAU * k / 6.0 - PI / 2
				list.append(["bulb%d" % k, Rect2(480 + cos(a) * 216 - 30, 236 + sin(a) * 120 - 30, 60, 60), "cmd:bulb %d" % k])
		"tdoor":
			list = _wheels("door", 4, 360, 240)
			list.append(["door", Rect2(676, 206, 84, 90), "tap"])
		# --- The Grandmaster's Study
		"C1":
			list = [
				["mini", Rect2(56, 246, 160, 72), "go:mini"],
				["portrait", Rect2(380, 50, 200, 140), "go:csafe"],
				["bigboard", Rect2(370, 240, 220, 76), "go:bigboard"],
				["clock", Rect2(778, 122, 84, 70), "go:cclock"],
				["fire", Rect2(740, 240, 160, 136), "tap"],
				["armchair", Rect2(226, 270, 90, 112), "tap"],
			]
		"C2":
			list = [
				["shelf", Rect2(50, 60, 420, 320), "go:shelf"],
				["chart", Rect2(520, 70, 150, 190), "go:chart"],
				["cabinet", Rect2(720, 110, 200, 266), "go:tiles"],
			]
		"C3":
			if "got_drawer" in flags:
				list.append(["sheet", Rect2(296, 262, 90, 38), "go:csheet"])
			list.append_array([
				["travel", Rect2(150, 246, 100, 54), "go:travel"],
				["lamp", Rect2(470, 210, 60, 90), "tap"],
				["drawer", Rect2(380, 312, 160, 62), "go:cdrawer"],
				["door", Rect2(740, 104, 150, 272), "tap"],
			])
		"cdrawer":
			if "drawer_open" in flags:
				list = [["drawer", Rect2(210, 100, 540, 290), "tap"]]
			else:
				for i in range(2):
					var cx := 430.0 + i * 100.0
					list.append(["drawer_up%d" % i, Rect2(cx - 38, 176, 76, 54), "cmd:turn drawer %d +1" % i])
					list.append(["drawer_face%d" % i, Rect2(cx - 38, 230, 76, 88), "cmd:turn drawer %d +1" % i])
					list.append(["drawer_down%d" % i, Rect2(cx - 38, 318, 76, 56), "cmd:turn drawer %d -1" % i])
		"csafe":
			list = [["safe", Rect2(230, 60, 500, 360), "tap"]] if "safe_open" in flags else _wheels("safe", 4, 360, 250)
		"cclock":
			if "clock_open" in flags:
				list = [["clock", Rect2(740, 60, 150, 190), "tap"]]
			else:
				for i in range(5):
					list.append(["shade%d" % i, Rect2(156 + i * 140.0, 284, 88, 140), "cmd:flip shades %d" % i])
		"tiles":
			list = [["cabinet", Rect2(500, 200, 400, 230), "tap"]] if "cab_open" in flags else _wheels("cabinet", 4, 580, 290)
		"mini":
			if not "king_safe" in flags:
				for rank in range(4):
					for file in range(4):
						list.append(["m%d%d" % [file, rank], Rect2(ArtSet2.MINI_X + file * ArtSet2.MINI_CELL, ArtSet2.MINI_Y + (3 - rank) * ArtSet2.MINI_CELL, ArtSet2.MINI_CELL, ArtSet2.MINI_CELL), "cmd:king %d %d" % [file, rank]])
			list.append(["minidrawer", Rect2(360, 388, 240, 72), "tap"])
		"bigboard":
			if art != null:
				var marked: Array = art.clues.get("marked", [])
				for i in range(marked.size()):
					list.append(["sq%d" % i, _square(int(marked[i][0]), int(marked[i][1])), "tap"])
				var king: Array = art.clues.get("black_king", [0, 0])
				list.append(["kingbase", _square(int(king[0]), int(king[1])), "tap"])
	return list


static func _square(file: int, rank: int) -> Rect2:
	return Rect2(ArtSet2.BIG_X + file * ArtSet2.BIG_CELL, ArtSet2.BIG_Y + (7 - rank) * ArtSet2.BIG_CELL, ArtSet2.BIG_CELL, ArtSet2.BIG_CELL)


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		return {"dark": 0.06 if close else 0.14, "warm": [Vector4(700, 150, 700, 1.0)], "cold": none, "tint": Vector3(0.12, 0.05, 0.0)}
	if place in RINGS[1]:
		var tint := Vector3(0.03, 0.02, 0.07)
		if close:
			return {"dark": 0.26, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": tint}
		if view == "T1":
			return {"dark": 0.56, "warm": [Vector4(560, 240, 460, 0.9)], "cold": Vector4(250, 230, 300, 0.5), "tint": tint}
		if view == "T2":
			var lit: bool = str(st.get("mix", "")) != ""
			return {"dark": 0.42 if lit else 0.62, "warm": [Vector4(900, 282, 200, 0.8)], "cold": Vector4(480, 200, 620, 0.7 if lit else 0.25), "tint": tint}
		var mirror: bool = "mirror_lit" in st.get("flags", [])
		return {"dark": 0.5 if mirror else 0.6, "warm": [Vector4(215, 206, 420 if mirror else 260, 0.9)], "cold": Vector4(640, 200, 420, 0.4), "tint": tint}
	var green := Vector3(0.02, 0.05, 0.03)
	if close:
		return {"dark": 0.24, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": green}
	if view == "C1":
		return {"dark": 0.5, "warm": [Vector4(820, 320, 380, 1.0), Vector4(480, 240, 300, 0.5)], "cold": none, "tint": green}
	if view == "C2":
		return {"dark": 0.46, "warm": [Vector4(480, 200, 640, 0.8)], "cold": none, "tint": green}
	return {"dark": 0.48, "warm": [Vector4(500, 230, 460, 1.0)], "cold": none, "tint": green}
