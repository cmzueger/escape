## The fourth set: The Attic (K…), The Watchmaker (W…) and The Night Gallery
## (M…): views, close-ups, hotspots and light (see views.gd and
## views_set2.gd). Rectangles match the drawings in art_set4.gd.
class_name Set4Views
extends RefCounted

const RINGS := [["K1", "K2"], ["W1", "W2"], ["M1", "M2"]]
const PARENT := {
	"ktrunk": "K1", "album": "K2", "ktrain": "K2", "kward": "K2",
	"wclocks": "W1", "wdrawer": "W1", "wwatch": "W1", "wplan": "W1", "wtall": "W2", "wdoor": "W2",
	"mtablet": "M1", "msarc": "M1", "mscales": "M1", "mcase": "M2", "mdial": "M2", "mfrieze": "M2", "mdoor": "M2",
}
const FIRST := {"attic": "K1", "watch": "W1", "museum": "M1"}


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func _faces(lock: String, count: int, x0: float, top: float) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * 80.0
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 36, top - 4, 72, 54), "cmd:turn %s %d +1" % [lock, i]])
		spots.append(["%s_face%d" % [lock, i], Rect2(cx - 36, top + 50, 72, 88), "cmd:turn %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 36, top + 138, 72, 54), "cmd:turn %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary, _art: ArtSet4) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Attic
		"K1":
			list = [
				["trunk", Rect2(76, 262, 228, 120), "go:ktrunk"],
				["musicbox", Rect2(350, 226, 130, 80), "tap"],
				["trapdoor", Rect2(540, 394, 174, 68), "tap"],
				["dormer", Rect2(380, 50, 200, 150), "tap"],
				["horse", Rect2(760, 250, 160, 130), "tap"],
			]
		"K2":
			list = [
				["train", Rect2(110, 136, 540, 84), "go:ktrain"],
				["album", Rect2(132, 290, 100, 36), "go:album"],
				["dummy", Rect2(418, 206, 96, 172), "tap"],
				["wardrobe", Rect2(700, 106, 210, 272), "go:kward"],
			]
		"album":
			list = [["photos", Rect2(40, 20, 880, 432), "tap"]]
		"ktrunk":
			list = [["trunk", Rect2(170, 110, 620, 290), "tap"]] if "trunk_open" in flags else Set2Views._wheels("trunk", 3, 400, 260)
		"ktrain":
			list = [["train", Rect2(40, 160, 880, 200), "tap"]]
		"kward":
			list = [["wardrobe", Rect2(200, 60, 560, 360), "tap"]] if "ward_open" in flags else Set2Views._wheels("ward", 4, 360, 250)
		# --- The Watchmaker
		"W1":
			if not "got_gear" in flags:
				list.append(["loosegear", Rect2(426, 260, 48, 46), "tap"])
			list.append_array([
				["clocks", Rect2(84, 50, 490, 150), "go:wclocks"],
				["plan", Rect2(700, 66, 150, 160), "go:wplan"],
				["watch", Rect2(298, 254, 64, 54), "go:wwatch"],
				["drawer", Rect2(520, 314, 150, 62), "go:wdrawer"],
				["lampw", Rect2(590, 244, 70, 56), "tap"],
				["cat", Rect2(796, 288, 50, 44), "tap"],
				["stool", Rect2(780, 332, 80, 46), "tap"],
			])
		"W2":
			list = [
				["tall", Rect2(360, 16, 170, 362), "go:wtall"],
				["tools", Rect2(104, 76, 170, 100), "tap"],
				["door", Rect2(720, 60, 180, 316), "go:wdoor"],
			]
		"wdrawer":
			list = [["drawer", Rect2(210, 90, 540, 300), "tap"]] if "drawer_open" in flags else Set2Views._wheels("drawer", 4, 360, 262)
		"wwatch":
			list = [["watch", Rect2(196, 36, 408, 408), "tap"]]
		"wtall":
			list = [
				["hour_on", Rect2(640, 178, 100, 68), "cmd:turn tall 0 +1"],
				["hour_back", Rect2(640, 252, 100, 68), "cmd:turn tall 0 -1"],
				["minute_on", Rect2(770, 178, 100, 68), "cmd:turn tall 1 +1"],
				["minute_back", Rect2(770, 252, 100, 68), "cmd:turn tall 1 -1"],
				["tallcase", Rect2(250, 350, 300, 100), "tap"],
			]
		"wdoor":
			list = Set2Views._wheels("door", 3, 400, 240)
		# --- The Night Gallery
		"M1":
			list = [
				["tablet", Rect2(110, 70, 150, 190), "go:mtablet"],
				["sarcophagus", Rect2(300, 250, 360, 126), "go:msarc"],
				["scales", Rect2(730, 190, 180, 190), "go:mscales"],
				["statue", Rect2(696, 268, 48, 108), "tap"],
			]
		"M2":
			list = [
				["frieze", Rect2(300, 46, 400, 90), "go:mfrieze"],
				["case", Rect2(90, 200, 170, 180), "go:mcase"],
				["dial", Rect2(400, 276, 160, 104), "go:mdial"],
				["door", Rect2(770, 70, 150, 306), "go:mdoor"],
				["rope", Rect2(270, 320, 140, 56), "tap"],
				["vase", Rect2(616, 300, 48, 76), "tap"],
				["skylight", Rect2(380, 0, 200, 40), "tap"],
			]
		"mcase":
			list = [["case", Rect2(220, 80, 520, 330), "tap"]] if "case_open" in flags else Set2Views._wheels("case", 3, 400, 270)
		"mscales":
			for i in range(4):
				list.append(["jar%d" % i, Rect2(330 + i * 100.0, 356, 60, 96), "cmd:flip jars %d" % i])
				list.append(["jar%d_on" % i, Rect2(662 + i * 60.0, 210, 56, 130), "cmd:flip jars %d" % i])
			list.append(["scalebox", Rect2(60, 384, 220, 70), "tap"])
			list.append(["scales", Rect2(60, 60, 420, 300), "tap"])
		"mdial":
			if "disc_on" in flags:
				list.append(["ring_back", Rect2(112, 202, 112, 92), "cmd:turn ring 0 -1"])
				list.append(["ring_on", Rect2(736, 202, 112, 92), "cmd:turn ring 0 +1"])
			list.append(["niche", Rect2(760, 340, 150, 110), "tap"])
			list.append(["dial", Rect2(270, 40, 420, 420), "tap"])
		"msarc":
			list = [["sarcophagus", Rect2(170, 100, 620, 280), "tap"]] if "sarc_open" in flags else _faces("sarc", 4, 360, 150)
		"mdoor":
			for i in range(6):
				list.append(["glyph%d" % i, Rect2(260 + (i % 3) * 160.0, 70 + floorf(i / 3.0) * 150.0, 120, 120), "cmd:glyph %d" % i])
			list.append(["door", Rect2(440, 396, 80, 62), "tap"])
	return list


static func lights(view: String, _st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		return {"dark": 0.1 if close else 0.24, "warm": [Vector4(480, 180, 620, 1.0)], "cold": none, "tint": Vector3(0.08, 0.04, 0.01)}
	if place in RINGS[1]:
		var brown := Vector3(0.05, 0.03, 0.01)
		if close:
			return {"dark": 0.2, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": brown}
		return {"dark": 0.44, "warm": [Vector4(620 if view == "W1" else 445, 250 if view == "W1" else 120, 520, 1.0)], "cold": none, "tint": brown}
	var navy := Vector3(0.02, 0.03, 0.09)
	if close:
		return {"dark": 0.2, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": navy}
	return {"dark": 0.5, "warm": [], "cold": Vector4(480, 240, 560, 0.9), "tint": navy}
