## The eighth set: The Filter Hall (WA…, close-ups wa…), The 8:15 to Nowhere
## (RC…, close-ups rc…) and Harvest Moon (MI…, close-ups mi…): views,
## hotspots and light (see views.gd). Rectangles match art_set8.gd.
class_name Set8Views
extends RefCounted

const RINGS := [["WA1", "WA2"], ["RC1", "RC2"], ["MI1", "MI2"]]
const PARENT := {
	"wacoal": "WA1", "wafirebox": "WA1", "wagauge": "WA1", "watube": "WA1", "walevers": "WA1", "wagov": "WA1",
	"waprogramme": "WA1", "wanotes": "WA1", "waboard": "WA1",
	"warisers": "WA2", "watank": "WA2", "waplaque": "WA2", "wanet": "WA2", "watable": "WA2", "wawindow": "WA2",
	"wajets": "WA2",
	"rcstation": "RC1", "rccontrol": "RC1", "rcturntable": "RC1", "rcyard": "RC1", "rcletter": "RC1", "rcphone": "RC1",
	"rcpoints": "RC2", "rcsign": "RC2", "rcshelf": "RC2", "rcbench": "RC2", "rcgap": "RC2",
	"misacks": "MI1", "mihoist": "MI1", "michute": "MI1", "midoor": "MI1",
	"miwheel": "MI2", "miwindow": "MI2", "migears": "MI2", "mislate": "MI2",
}
const FIRST := {"filter": "WA1", "railway": "RC1", "mill": "MI1"}
## The pipe wall's grid.
const NET_X := 250.0
const NET_Y := 14.0
const NET_CELL := 110.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


## Up and down arrows for a dial (named `<name>_up<i>` / `_down<i>` like a
## lock's wheels, so the layout check pairs them with their drawn arrows).
static func _updown(dial: String, i: int, x: float, y: float) -> Array:
	return [
		["%s_up%d" % [dial, i], Rect2(x - 36, y - 66, 72, 56), "cmd:turn %s %d +1" % [dial, i]],
		["%s_down%d" % [dial, i], Rect2(x - 36, y + 76, 72, 58), "cmd:turn %s %d -1" % [dial, i]],
	]


## A conversation: the tube or telephone to call, or the current choices.
static func _talk(st: Dictionary, art: ArtSet8, caller: String) -> Array:
	var at := int(st.get("talk", [0])[0])
	if at == 0:
		return [[caller, Rect2(330, 120, 300, 230), "cmd:call"]]
	var lines: Array = art.clues.get("lines", []) if art != null else []
	var list := []
	if at - 1 < lines.size():
		var choices: Array = lines[at - 1]["choices"]
		for i in range(choices.size()):
			list.append(["say%d" % i, Rect2(60, 222 + i * 64.0, 840, 56), "cmd:say %d" % i])
	return list


static func spots(view: String, st: Dictionary, art: ArtSet8) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Filter Hall
		"WA1":
			list = [
				["coal", Rect2(30, 250, 170, 120), "go:wacoal"],
				["boiler", Rect2(220, 60, 150, 120), "go:wagauge"],
				["firebox", Rect2(220, 200, 150, 170), "go:wafirebox"],
				["governor", Rect2(400, 40, 130, 170), "go:wagov"],
				["levers", Rect2(390, 240, 170, 130), "go:walevers"],
				["engine", Rect2(570, 220, 80, 150), "tap"],
				["tube", Rect2(580, 50, 70, 150), "go:watube"],
				["programme", Rect2(670, 40, 130, 160), "go:waprogramme"],
				["desk", Rect2(670, 250, 160, 120), "go:wanotes"],
				["board", Rect2(830, 40, 120, 220), "go:waboard"],
			]
		"WA2":
			list = [
				["risers", Rect2(30, 40, 160, 330), "go:warisers"],
				["plaque", Rect2(210, 40, 170, 90), "go:waplaque"],
				["tank", Rect2(210, 150, 170, 220), "go:watank"],
				["pipes", Rect2(400, 40, 240, 240), "go:wanet"],
				["table", Rect2(400, 300, 240, 70), "go:watable"],
				["window", Rect2(670, 40, 270, 200), "go:wawindow"],
				["jets", Rect2(670, 260, 170, 110), "go:wajets"],
				["mainvalve", Rect2(860, 260, 80, 110), "tap"],
			]
		"wacoal":
			list = [["coal", Rect2(160, 100, 640, 330), "tap"]]
		"wafirebox":
			list = [["firebox", Rect2(260, 80, 440, 340), "tap"]]
		"wagauge":
			list = _updown("feed", 0, 760, 230)
			list.append(["boiler", Rect2(60, 20, 600, 430), "tap"])
		"watube":
			list = _talk(st, art, "tube")
		"walevers":
			for i in range(3):
				list.append(["lever%d" % i, Rect2(130 + i * 250.0, 80, 200, 340), "cmd:lever %d" % i])
		"wagov":
			list = _updown("speed", 0, 760, 230)
			list.append(["governor", Rect2(80, 20, 560, 430), "tap"])
		"waprogramme":
			list = [["programme", Rect2(200, 20, 560, 440), "tap"]]
		"wanotes":
			if not "got_matches" in flags:
				list.append(["matchtin", Rect2(760, 320, 140, 100), "tap"])
			list.append(["notes", Rect2(80, 20, 640, 440), "tap"])
		"waboard":
			for i in range(6):
				list.append(["valve%d" % i, Rect2(60 + i * 145.0, 250, 120, 180), "cmd:flip districts %d" % i])
			list.append(["board", Rect2(60, 20, 840, 210), "tap"])
		"warisers":
			for i in range(3):
				list.append(["riser%d" % i, Rect2(130 + i * 250.0, 30, 180, 400), "cmd:bleed %d" % i])
		"watank":
			for i in range(3):
				list.append(["bin%d" % i, Rect2(40, 40 + i * 140.0, 200, 120), "cmd:layer %d" % i])
			list.append(["empty", Rect2(680, 60, 220, 90), "cmd:empty"])
			list.append(["test", Rect2(680, 300, 220, 120), "cmd:test"])
			list.append(["tank", Rect2(300, 40, 340, 400), "tap"])
		"waplaque":
			list = [["plaque", Rect2(120, 40, 720, 400), "tap"]]
		"wanet":
			for i in range(16):
				var rect := Rect2(NET_X + (i % 4) * NET_CELL, NET_Y + (i / 4) * NET_CELL, NET_CELL - 6, NET_CELL - 6)
				var tiles: Array = art.clues.get("tiles", []) if art != null else []
				var kind := int(tiles[i]) if i < tiles.size() else 0
				if kind == 0 or kind == 4:
					continue
				if kind == 5 and not "socket_in" in flags:
					list.append(["socket", rect, "tap"])
				else:
					list.append(["pipe%d" % i, rect, "cmd:turn pipes %d +1" % i])
		"watable":
			if not "got_horn" in flags:
				list.append(["horn", Rect2(120, 200, 260, 160), "tap"])
			list.append(["speech", Rect2(440, 30, 460, 400), "tap"])
		"wawindow":
			list = [["window", Rect2(40, 20, 880, 440), "tap"]]
		"wajets":
			for i in range(3):
				list.append_array(_updown("jets", i, 240 + i * 240.0, 260))
		# --- The 8:15 to Nowhere
		"RC1":
			list = [
				["letter", Rect2(40, 30, 200, 100), "go:rcletter"],
				["portrait", Rect2(290, 30, 120, 140), "tap"],
				["phone", Rect2(860, 150, 80, 100), "go:rcphone"],
				["station", Rect2(70, 150, 120, 110), "go:rcstation"],
				["controller", Rect2(60, 290, 180, 80), "go:rccontrol"],
				["turntable", Rect2(260, 230, 170, 140), "go:rcturntable"],
				["yard", Rect2(450, 250, 220, 120), "go:rcyard"],
				["dairy", Rect2(500, 150, 130, 90), "tap"],
				["tunnel", Rect2(720, 200, 110, 170), "tap"],
			]
		"RC2":
			list = [
				["sign", Rect2(40, 70, 150, 110), "go:rcsign"],
				["points", Rect2(40, 220, 320, 150), "go:rcpoints"],
				["bookcase", Rect2(390, 30, 220, 340), "go:rcshelf"],
				["bench", Rect2(640, 250, 290, 120), "go:rcbench"],
			]
			if "branch_open" in flags:
				list.append(["gap", Rect2(640, 50, 290, 170), "go:rcgap"])
		"rcstation":
			if not "got_key" in flags:
				list.append(["clocktower", Rect2(420, 40, 140, 280), "tap"])
			list.append(["station", Rect2(120, 40, 720, 400), "tap"])
		"rccontrol":
			list = [
				["p1", Rect2(160, 200, 180, 160), "cmd:flip points1 0"],
				["p2", Rect2(390, 200, 180, 160), "cmd:flip points1 1"],
				["run", Rect2(660, 220, 200, 140), "cmd:run"],
				["controller", Rect2(100, 30, 760, 150), "tap"],
			]
		"rcturntable":
			list = [["turnbtn", Rect2(740, 150, 140, 120), "cmd:turn turn 0 +1"]]
			for i in range(4):
				list.append(["engine%d" % (i + 1), Rect2(60 + i * 160.0, 330, 140, 110), "tap"])
		"rcyard":
			for a in range(3):
				var k := 0
				for b in range(3):
					if a != b:
						list.append(["shunt%d%d" % [a, b], Rect2(740 + k * 100.0, 60 + a * 130.0, 86, 90), "cmd:shunt %d %d" % [a, b]])
						k += 1
		"rcletter":
			list = [["letter", Rect2(140, 20, 680, 440), "tap"]]
		"rcphone":
			list = _talk(st, art, "phone")
		"rcpoints":
			list = [
				["p3", Rect2(180, 200, 180, 160), "cmd:flip points2 0"],
				["p4", Rect2(420, 200, 180, 160), "cmd:flip points2 1"],
				["run", Rect2(680, 220, 200, 140), "cmd:run"],
				["post", Rect2(60, 20, 840, 150), "tap"],
			]
		"rcsign":
			list = [["run", Rect2(720, 300, 200, 130), "cmd:run"], ["sign", Rect2(80, 30, 600, 400), "tap"]]
		"rcshelf":
			for i in range(8):
				list.append(["book%d" % i, Rect2(110 + i * 92.0, 90, 80, 300), "cmd:book %d" % i])
		"rcbench":
			if not "got_notes" in flags:
				list.append(["notebook", Rect2(80, 160, 340, 240), "tap"])
			if not "got_board" in flags:
				list.append(["headboard", Rect2(600, 260, 280, 120), "tap"])
			list.append(["bench", Rect2(40, 20, 880, 440), "tap"])
		"rcgap":
			list = [["gap", Rect2(120, 60, 720, 360), "tap"]]
		# --- Harvest Moon
		"MI1":
			list = [
				["sacks", Rect2(30, 220, 300, 150), "go:misacks"],
				["brakerope", Rect2(350, 30, 50, 340), "tap"],
				["hoist", Rect2(420, 30, 170, 230), "go:mihoist"],
				["chute", Rect2(610, 50, 170, 320), "go:michute"],
				["door", Rect2(800, 50, 140, 320), "go:midoor"],
			]
		"MI2":
			list = [
				["wheel", Rect2(30, 40, 180, 200), "go:miwheel"],
				["window", Rect2(240, 30, 300, 200), "go:miwindow"],
				["stones", Rect2(240, 250, 300, 120), "go:migears"],
				["clutch", Rect2(580, 190, 100, 180), "cmd:flip clutch 0"],
				["slate", Rect2(720, 40, 210, 170), "go:mislate"],
				["song", Rect2(720, 230, 210, 140), "tap"],
			]
		"misacks":
			if not "got_crank" in flags:
				list.append(["sacks", Rect2(80, 160, 800, 280), "tap"])
			else:
				for i in range(5):
					list.append(["sack%d" % i, Rect2(60 + i * 172.0, 160, 150, 260), "cmd:hoist %d" % i])
		"mihoist":
			list = [["traps", Rect2(600, 160, 220, 200), "cmd:flip traps 0"], ["hook", Rect2(100, 30, 420, 420), "tap"]]
		"michute":
			for i in range(3):
				list.append(["flap%d" % i, ArtSet8.flap_rect(i), "cmd:flip flaps %d" % i])
			if not "got_flour" in flags:
				list.append(["festival", Rect2(120, 340, 200, 110), "tap"])
			if not "got_bran" in flags:
				list.append(["bransack", Rect2(640, 340, 200, 110), "tap"])
			list.append(["chute", Rect2(60, 20, 840, 60), "tap"])
		"midoor":
			if int(st.get("talk", [0])[0]) != 0:
				list = _talk(st, art, "greta")
			else:
				list = [
					["greta", Rect2(60, 40, 260, 380), "cmd:call"],
					["counterweight", Rect2(380, 40, 160, 200), "tap"],
					["cart", Rect2(600, 280, 320, 160), "tap"],
					["loadingdoor", Rect2(380, 250, 200, 200), "tap"],
				]
		"miwheel":
			list = [
				["cap_left", Rect2(80, 330, 130, 100), "cmd:turn cap 0 -1"],
				["cap_right", Rect2(750, 330, 130, 100), "cmd:turn cap 0 +1"],
				["wheel", Rect2(280, 40, 400, 400), "tap"],
			]
		"miwindow":
			for i in range(4):
				list.append(["cloth%d" % i, Rect2(110 + i * 200.0, 380, 140, 80), "cmd:turn cloth %d +1" % i])
			list.append(["window", Rect2(40, 20, 880, 340), "tap"])
		"migears":
			list = [
				["wallower", Rect2(130, 60, 220, 220), "cmd:turn gears 0 +1"],
				["nut", Rect2(430, 60, 220, 220), "cmd:turn gears 1 +1"],
				["stones", Rect2(100, 300, 760, 150), "tap"],
			]
		"mislate":
			list = [["slate", Rect2(80, 20, 800, 440), "tap"]]
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		# Daylight through high windows on white tiles.
		return {"dark": 0.02 if close else 0.06, "warm": [], "cold": none, "tint": Vector3(0.0, 0.02, 0.04)}
	if place in RINGS[1]:
		var lit: bool = "powered" in st.get("flags", [])
		return {"dark": 0.14 if close else (0.26 if lit else 0.4), "warm": [Vector4(480, 40, 560, 1.0)], "cold": none, "tint": Vector3(0.07, 0.04, 0.0)}
	return {"dark": 0.08 if close else 0.18, "warm": [Vector4(390, 120, 600, 1.0)], "cold": none, "tint": Vector3(0.1, 0.05, 0.0)}
