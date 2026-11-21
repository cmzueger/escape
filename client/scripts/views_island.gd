## The series Puffin Island: Spring (PS…, close-ups ps…), Summer (PU…,
## pu…), Autumn (PA…, pa…), Winter (PW…, pw…): views, hotspots and light
## (see views.gd). Rectangles match art_island.gd.
class_name IslandViews
extends RefCounted

const RINGS := [["PS1", "PS2", "PS3", "PS4"], ["PU1", "PU2", "PU3", "PU4"], ["PA1", "PA2", "PA3", "PA4"], ["PW1", "PW2", "PW3", "PW4"]]
const PARENT := {
	"psboat": "PS1",
	"psmaggie": "PS2", "pschart": "PS2", "psalmanac": "PS2",
	"psledge": "PS3", "psflags": "PS3",
	"pspatch": "PS4", "psgates": "PS4",
	"pulamp": "PU2", "pubarn": "PU3", "pukite": "PU4", "putom": "PU4", "pualmanac": "PU4",
	"papress": "PA2", "patrader": "PA3", "parace": "PA4", "paalmanac": "PA1",
	"pwlake": "PW1", "pwmaggie": "PW2", "pwalmanac": "PW2", "pwlens": "PW3", "pwchart": "PW3", "pwicicles": "PW4",
}
const FIRST := {"spring": "PS1", "summer": "PU1", "autumn": "PA1", "winter": "PW1"}
## The rowing and skating grids' four arrows (north, west, east, south).
const PAD := {"n": Rect2(780, 60, 72, 56), "w": Rect2(708, 130, 72, 56), "e": Rect2(852, 130, 72, 56), "s": Rect2(780, 200, 72, 56)}
## Where the grids lie.
const SEA_AT := Vector2(150, 40)
const SEA_CELL := 76.0
const LAKE_AT := Vector2(150, 30)
const LAKE_CELL := 64.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func _updown(dial: String, i: int, x: float, y: float) -> Array:
	return Set8Views._updown(dial, i, x, y)


static func _talk(st: Dictionary, art: ArtIsland, caller: String) -> Array:
	return Set8Views._talk(st, art, caller)


static func _pad(cmd: String) -> Array:
	var list := []
	for d in ["n", "w", "e", "s"]:
		list.append(["%s_%s" % [cmd, d], PAD[d], "cmd:%s %s" % [cmd, d]])
	return list


static func spots(view: String, st: Dictionary, art: ArtIsland) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- Spring
		"PS1":
			list = [
				["boathouse", Rect2(64, 80, 190, 250), "tap"],
				["gap", Rect2(420, 250, 90, 70), "tap"],
				["jetty", Rect2(700, 250, 130, 70), "tap"],
				["boat", Rect2(560, 330, 230, 42), "go:psboat"],
				["bell", Rect2(840, 120, 60, 160), "tap"],
			]
		"PS2":
			list = [
				["maggie", Rect2(64, 180, 200, 190), "go:psmaggie"],
				["boots", Rect2(280, 300, 90, 70), "tap"],
				["coat", Rect2(390, 70, 70, 190), "tap"],
				["stove", Rect2(480, 170, 140, 200), "tap"],
				["box", Rect2(630, 300, 100, 70), "tap"],
				["chart", Rect2(480, 30, 140, 120), "go:pschart"],
				["tideclock", Rect2(650, 40, 90, 100), "tap"],
				["whistle", Rect2(760, 110, 60, 60), "tap"],
				["seedtin", Rect2(830, 110, 60, 60), "tap"],
				["almanac", Rect2(760, 260, 130, 70), "go:psalmanac"],
			]
		"PS3":
			list = [
				["rock", Rect2(280, 120, 160, 90), "tap"],
				["ledge", Rect2(64, 230, 380, 140), "go:psledge"],
				["flagpole", Rect2(660, 40, 160, 330), "go:psflags"],
			]
		"PS4":
			list = [
				["well", Rect2(64, 160, 120, 210), "tap"],
				["can", Rect2(196, 316, 70, 54), "tap"],
				["patch", Rect2(290, 270, 230, 100), "go:pspatch"],
				["woodpile", Rect2(540, 280, 110, 90), "tap"],
				["gates", Rect2(670, 110, 230, 260), "go:psgates"],
			]
		"psboat":
			if not "oars_in" in flags:
				list = [["boat", Rect2(150, 40, 456, 380), "tap"]]
			else:
				list = _pad("row")
				if "at_rock" in flags and not "got_pip" in flags:
					list.append(["nest", Rect2(SEA_AT.x + 5 * SEA_CELL, SEA_AT.y, SEA_CELL, SEA_CELL), "tap"])
		"psmaggie":
			if "pip_home" in flags:
				list = _talk(st, art, "maggie")
			else:
				list = [["maggie", Rect2(240, 40, 480, 400), "tap"]]
		"pschart":
			list = [["chart", Rect2(140, 20, 680, 440), "tap"]]
		"psalmanac":
			list = [["almanac", Rect2(120, 20, 720, 440), "tap"]]
		"psledge":
			list = [
				["short", Rect2(200, 280, 240, 150), "cmd:call 0"],
				["long", Rect2(520, 280, 240, 150), "cmd:call 1"],
				["puffins", Rect2(120, 20, 720, 240), "tap"],
			]
		"psflags":
			list = _updown("pennants", 0, 560, 230) + _updown("pennants", 1, 680, 230) + _updown("pennants", 2, 800, 230)
			list.append(["signals", Rect2(80, 30, 380, 420), "tap"])
		"pspatch":
			if "got_seeds" in flags and "dug" in flags:
				for i in range(3):
					list.append_array(_updown("rows", i, 300 + i * 180.0, 220))
			list.append(["patch", Rect2(160, 380, 640, 80), "tap"])
		"psgates":
			for i in range(3):
				list.append(["gate%d" % i, Rect2(GATE_SPOTS[i].x - 50, GATE_SPOTS[i].y - 50, 100, 100), "cmd:turn gates %d +1" % i])
			list.append(["lamb", Rect2(80, 330, 180, 110), "cmd:lamb"])
		# --- Summer
		"PU1":
			list = [
				["pots", Rect2(64, 290, 150, 80), "tap"],
				["wall", Rect2(250, 240, 260, 80), "tap"],
				["jetty", Rect2(540, 260, 240, 60), "tap"],
				["horn", Rect2(820, 140, 80, 160), "tap"],
			]
		"PU2":
			list = [
				["door", Rect2(420, 230, 120, 140), "tap"],
				["lamproom", Rect2(400, 20, 160, 100), "go:pulamp"],
				["store", Rect2(600, 260, 140, 110), "tap"],
				["sewingbox", Rect2(220, 300, 120, 70), "tap"],
			]
		"PU3":
			list = [["barndoor", Rect2(260, 140, 250, 230), "tap" if not "barn_open" in flags else "go:pubarn"]]
		"PU4":
			list = [
				["windsock", Rect2(80, 50, 140, 200), "tap"],
				["kite", Rect2(250, 220, 260, 150), "go:pukite"],
				["stack", Rect2(640, 70, 220, 300), "go:putom"],
				["almanac", Rect2(540, 300, 90, 70), "go:pualmanac"],
			]
		"pulamp":
			list = [
				["lamp", Rect2(330, 120, 220, 250), "tap"],
				["lens", Rect2(120, 120, 180, 250), "tap"],
				["short", Rect2(600, 330, 140, 110), "cmd:flash 0"],
				["long", Rect2(760, 330, 140, 110), "cmd:flash 1"],
				["codecard", Rect2(600, 20, 300, 120), "tap"],
			]
			list.append(["lens_up0", Rect2(174, 34, 72, 56), "cmd:turn lens 0 +1"])
			list.append(["lens_down0", Rect2(174, 400, 72, 58), "cmd:turn lens 0 -1"])
		"pubarn":
			if not "got_matches" in flags:
				list.append(["matchbox", Rect2(80, 60, 90, 70), "tap"])
			if not "got_kite" in flags:
				list.append(["oldkite", Rect2(200, 40, 160, 170), "tap"])
			if not "got_twine" in flags:
				list.append(["twine", Rect2(390, 70, 90, 90), "tap"])
			for i in range(4):
				list.append(["bale%d" % i, Rect2(80 + i * 140.0, 270, 120, 110), "cmd:bale %d" % i])
			list.append(["sign", Rect2(640, 40, 260, 200), "tap"])
		"pukite":
			list = [
				["letout", Rect2(560, 300, 160, 130), "cmd:kite out"],
				["hold", Rect2(740, 300, 160, 130), "cmd:kite in"],
				["windsock", Rect2(60, 300, 200, 140), "tap"],
			]
		"putom":
			if "tom_safe" in flags:
				list = _talk(st, art, "tom")
			else:
				list = [["tom", Rect2(300, 40, 360, 400), "tap"]]
		"pualmanac":
			list = [["almanac", Rect2(120, 20, 720, 440), "tap"]]
		# --- Autumn
		"PA1":
			list = [
				["scarecrow", Rect2(64, 90, 120, 260), "tap"],
				["tree", Rect2(200, 30, 230, 320), "tap"],
				["henhouse", Rect2(450, 220, 150, 150), "tap"],
				["shed", Rect2(640, 120, 250, 250), "tap"],
				["almanac", Rect2(470, 120, 90, 70), "go:paalmanac"],
			]
		"PA2":
			list = [
				["press", Rect2(64, 60, 270, 310), "go:papress"],
				["bottles", Rect2(350, 280, 110, 90), "tap"],
				["oven", Rect2(490, 120, 210, 250), "tap"],
				["patch", Rect2(730, 50, 170, 200), "tap"],
			]
		"PA3":
			list = [
				["trader", Rect2(64, 80, 260, 290), "go:patrader"],
				["judges", Rect2(350, 200, 250, 170), "tap"],
				["crew", Rect2(630, 150, 170, 220), "tap"],
				["cup", Rect2(816, 200, 84, 100), "tap"],
			]
		"PA4":
			list = [
				["boats", Rect2(160, 200, 600, 170), "go:parace"],
				["pip", Rect2(790, 120, 110, 110), "tap"],
				["drum", Rect2(64, 220, 90, 140), "tap"],
			]
		"papress":
			list = _updown("screw", 0, 760, 230)
			list.append(["press", Rect2(120, 40, 440, 300), "tap"])
			list.append(["crank", Rect2(120, 360, 300, 90), "tap"])
		"patrader":
			if "got_cider" in flags and (not "traded" in flags or int(st.get("talk", [0])[0]) != 0):
				list = _talk(st, art, "trader")
			else:
				list = [["trader", Rect2(240, 40, 480, 400), "tap"]]
		"parace":
			list = [["stroke", Rect2(620, 260, 280, 180), "cmd:stroke"], ["drum", Rect2(60, 280, 200, 160), "tap"]]
		"paalmanac":
			list = [["almanac", Rect2(120, 20, 720, 440), "tap"]]
		# --- Winter
		"PW1":
			list = [["lake", Rect2(100, 150, 760, 220), "go:pwlake"], ["aurora", Rect2(100, 20, 760, 120), "tap"]]
		"PW2":
			list = [
				["door", Rect2(64, 60, 140, 310), "tap"],
				["scuttle", Rect2(220, 300, 90, 70), "tap"],
				["skates", Rect2(320, 70, 90, 140), "tap"],
				["almanac", Rect2(420, 200, 120, 70), "go:pwalmanac"],
				["drawer", Rect2(420, 290, 120, 60), "tap"],
				["stove", Rect2(560, 160, 140, 210), "tap"],
				["lanternhook", Rect2(712, 70, 70, 140), "tap"],
				["maggie", Rect2(790, 170, 110, 200), "go:pwmaggie"],
			]
		"PW3":
			list = [
				["clockwork", Rect2(64, 180, 190, 190), "tap"],
				["crank", Rect2(266, 300, 60, 70), "tap"],
				["lamp", Rect2(340, 120, 280, 250), "tap"],
				["lens", Rect2(360, 20, 240, 90), "go:pwlens"],
				["chart", Rect2(680, 60, 220, 200), "go:pwchart"],
			]
		"PW4":
			list = [
				["cave", Rect2(64, 30, 830, 120), "tap"],
				["icicles", Rect2(100, 150, 400, 220), "go:pwicicles"],
				["oilcan", Rect2(540, 300, 90, 70), "tap"],
				["barrel", Rect2(650, 200, 220, 170), "tap"],
			]
		"pwlake":
			list = _pad("skate")
		"pwmaggie":
			if "dug_out" in flags:
				list = _talk(st, art, "maggie")
			else:
				list = [["maggie", Rect2(240, 40, 480, 400), "tap"]]
		"pwalmanac":
			list = [["almanac", Rect2(120, 20, 720, 440), "tap"]]
		"pwlens":
			for i in range(3):
				list.append(["panel%d" % i, Rect2(150 + i * 230.0, 80, 200, 300), "cmd:panel %d" % i])
		"pwchart":
			list = _updown("pattern", 0, 780, 230)
			list.append(["chart", Rect2(80, 20, 560, 440), "tap"])
		"pwicicles":
			for i in range(5):
				list.append(["icicle%d" % i, Rect2(120 + i * 150.0, 40, 120, 380), "cmd:key %d" % i])
	return list


## Where the meadow's gates stand in the gate close-up.
const GATE_SPOTS := [Vector2(330, 250), Vector2(560, 140), Vector2(560, 360)]


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		return {"dark": 0.02 if close else 0.04, "warm": [Vector4(700, -60, 700, 0.5)], "cold": none, "tint": Vector3(0.02, 0.04, 0.0)}
	if place in RINGS[1]:
		var calm: bool = "done" in st.get("flags", [])
		return {"dark": 0.06 if close else (0.1 if calm else 0.22), "warm": [Vector4(480, 80, 520, 0.6)], "cold": Vector4(200, 60, 500, 0.3), "tint": Vector3(0.0, 0.02, 0.05)}
	if place in RINGS[2]:
		return {"dark": 0.03 if close else 0.06, "warm": [Vector4(600, 40, 700, 0.9)], "cold": none, "tint": Vector3(0.1, 0.05, 0.0)}
	var lit: bool = "done" in st.get("flags", [])
	return {"dark": 0.1 if close else (0.2 if lit else 0.3), "warm": [Vector4(480, 200, 500, 0.7)], "cold": Vector4(480, 40, 600, 0.5), "tint": Vector3(0.0, 0.03, 0.08)}
