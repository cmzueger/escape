## The Quiet House: the same floor in 1905 (H…), 1938 (J…), 1969 (U…) and
## today (X…). Views, close-ups, hotspots and light (see views.gd).
## Rectangles match the drawings in art_house.gd.
class_name HouseViews
extends RefCounted

const RINGS := [["H1", "H2"], ["J1", "J2"], ["U1", "U2"], ["X1", "X2"]]
const PARENT := {
	"hpiano": "H1", "hstove": "H1", "hclock": "H1", "hbed": "H2", "hbox": "H2", "hhat": "H2", "hnote": "hhat",
	"jstove": "J1", "jnote": "jstove", "jphone": "J1", "jfuses": "J1", "jpanels": "J1", "jcourt": "J2",
	"upiano": "U1", "ustove": "U1", "unotes": "ustove", "urecord": "U1", "ubox": "U1", "ucourt": "U2", "udesk": "U2",
	"uintercom": "U2",
	"xpiano": "X1", "xstove": "X1", "xnotes": "xstove", "xphone": "X1", "xcourt": "X2", "xplan": "X2", "xwall": "X2",
}
const FIRST := {"house1905": "H1", "house1938": "J1", "house1969": "U1", "housenow": "X1"}
## Piano keys in a close-up.
const KEY_X := 120.0
const KEY_W := 90.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func _keys(lid: String) -> Array:
	var list := []
	for i in range(8):
		list.append(["key%d" % i, Rect2(KEY_X + i * KEY_W, 220, KEY_W - 6, 230), "cmd:key %d" % i])
	if lid != "":
		list.append([lid, Rect2(300, 30, 360, 110), "tap"])
	return list


## A conversation: the handset to call, or the choices of the current line.
static func _talk(st: Dictionary, art: ArtHouse) -> Array:
	var at := int(st.get("talk", [0])[0])
	if at == 0:
		return [["handset", Rect2(560, 120, 300, 200), "cmd:call"]]
	var lines: Array = art.clues.get("lines", []) if art != null else []
	var list := []
	if at - 1 < lines.size():
		var choices: Array = lines[at - 1]["choices"]
		for i in range(choices.size()):
			list.append(["say%d" % i, Rect2(60, 250 + i * 70.0, 840, 62), "cmd:say %d" % i])
	return list


static func spots(view: String, st: Dictionary, art: ArtHouse) -> Array:
	var flags: Array = st.get("flags", [])
	var talking := int(st.get("talk", [0])[0]) != 0
	var list := []
	match view:
		# --- 1905
		"H1":
			list = [
				["piano", Rect2(40, 150, 300, 220), "go:hpiano"],
				["stove", Rect2(400, 60, 170, 310), "go:hstove"],
				["clock", Rect2(600, 40, 100, 100), "go:hclock"],
				["lamp", Rect2(610, 170, 100, 80), "tap"],
				["door", Rect2(790, 40, 150, 330), "tap"],
			]
		"H2":
			list = [
				["bed", Rect2(30, 200, 320, 170), "go:hbed"],
				["window", Rect2(380, 40, 210, 210), "tap"],
				["desk", Rect2(380, 270, 220, 100), "go:hbox"],
				["wardrobe", Rect2(650, 40, 260, 330), "go:hhat" if "ward_open" in flags else "tap"],
			]
		"hpiano":
			list = _keys("pianolid")
		"hstove", "hclock":
			list = [[view.substr(1), Rect2(120, 20, 720, 440), "tap"]]
		"hbed":
			if not "got_crank" in flags:
				list.append(["pillow", Rect2(120, 230, 260, 120), "tap"])
			list.append(["bed", Rect2(60, 20, 840, 440), "tap"])
		"hbox":
			list = [["musicbox", Rect2(220, 80, 520, 340), "tap"]]
		"hhat":
			if "hat_open" in flags:
				list = [["hatbox", Rect2(220, 80, 520, 330), "tap"]]
				if "got_hat" in flags:
					list = [["note", Rect2(300, 120, 360, 240), "go:hnote"]]
			else:
				list = Set2Views._wheels("hat", 3, 400, 270)
		"hnote":
			list = [["note", Rect2(140, 20, 680, 440), "tap"]]
		# --- 1938
		"J1":
			list = [
				["piano", Rect2(30, 170, 250, 200), "tap"],
				["stove", Rect2(300, 60, 160, 310), "go:jstove"],
				["phone", Rect2(490, 230, 120, 140), "go:jphone"],
				["fuses", Rect2(500, 50, 110, 140), "go:jfuses"],
				["panels", Rect2(630, 250, 170, 120), "go:jpanels"],
				["lamp", Rect2(640, 20, 140, 90), "tap"],
				["door", Rect2(820, 40, 120, 330), "tap"],
			]
		"J2":
			list = [
				["window", Rect2(360, 40, 240, 230), "go:jcourt"],
				["sewing", Rect2(40, 220, 280, 150), "tap"],
				["photo", Rect2(660, 60, 140, 110), "tap"],
				["radio", Rect2(680, 240, 160, 120), "tap"],
			]
		"jstove":
			list = [["note", Rect2(380, 300, 200, 120), "go:jnote"]] if "got_note" in flags else [["tile", Rect2(500, 260, 90, 80), "tap"]]
			list.append(["stove", Rect2(200, 20, 560, 440), "tap"])
		"jnote":
			list = [["note", Rect2(140, 20, 680, 440), "tap"]]
		"jphone":
			if talking:
				list = _talk(st, art)
			else:
				list = Set2Views._wheels("phone", 4, 140, 270)
				list.append_array(_talk(st, art))
		"jfuses":
			for i in range(4):
				list.append(["fuse%d" % i, Rect2(150 + i * 170.0, 120, 150, 260), "cmd:flip fuses %d" % i])
		"jpanels":
			for i in range(6):
				list.append(["panel%d" % i, Rect2(60 + i * 140.0, 60, 130, 360), "cmd:panel %d" % i])
		"jcourt":
			list = [["court", Rect2(20, 20, 920, 432), "tap"]]
		# --- 1969
		"U1":
			list = [
				["piano", Rect2(30, 170, 250, 200), "go:upiano"],
				["stove", Rect2(300, 60, 160, 310), "go:ustove"],
				["record", Rect2(490, 220, 200, 150), "go:urecord"],
				["box", Rect2(500, 80, 110, 90), "go:ubox"],
				["tv", Rect2(720, 200, 200, 170), "tap"],
			]
		"U2":
			list = [
				["window", Rect2(360, 40, 240, 230), "go:ucourt"],
				["desk", Rect2(40, 230, 290, 140), "go:udesk"],
				["poster", Rect2(60, 40, 200, 160), "tap"],
				["intercom", Rect2(660, 140, 110, 110), "go:uintercom"],
				["door", Rect2(800, 40, 140, 330), "tap"],
			]
		"upiano":
			list = _keys("bench")
		"ustove":
			list = [["notes", Rect2(380, 300, 200, 120), "go:unotes"]] if "got_notes" in flags else [["tile", Rect2(500, 260, 90, 80), "tap"]]
			list.append(["stove", Rect2(200, 20, 560, 440), "tap"])
		"unotes":
			list = [["sketch", Rect2(600, 60, 320, 360), "tap"], ["notes", Rect2(40, 20, 540, 440), "tap"]]
		"urecord":
			list = [
				["speed", Rect2(110, 330, 200, 110), "cmd:turn speed 0 +1"],
				["needle", Rect2(330, 60, 300, 330), "cmd:listen record"],
				["sleeve", Rect2(660, 40, 260, 400), "tap"],
			]
		"ubox":
			list = [["box", Rect2(220, 80, 520, 340), "cmd:listen box"]]
		"ucourt":
			list = [["court", Rect2(20, 20, 920, 432), "tap"]]
		"udesk":
			list = [["drawer", Rect2(220, 80, 520, 330), "tap"]] if "drawer_open" in flags else Set2Views._wheels("drawer", 3, 400, 270)
		"uintercom":
			if talking:
				list = _talk(st, art)
			else:
				list = [["intercom", Rect2(560, 120, 300, 200), "tap" if not "intercom" in flags else "cmd:call"]]
		# --- Today
		"X1":
			list = [
				["piano", Rect2(30, 170, 250, 200), "go:xpiano"],
				["stove", Rect2(300, 60, 160, 310), "go:xstove"],
				["phone", Rect2(500, 240, 120, 130), "go:xphone"],
				["sheet", Rect2(660, 200, 260, 170), "tap"],
			]
		"X2":
			list = [
				["window", Rect2(360, 40, 240, 230), "go:xcourt"],
				["plan", Rect2(40, 60, 260, 230), "go:xplan"],
				["wall", Rect2(640, 40, 290, 330), "go:xwall"],
				["toolbox", Rect2(380, 290, 200, 80), "tap"],
				["ladder", Rect2(310, 60, 60, 310), "tap"],
			]
		"xpiano":
			list = _keys("pianolid")
		"xstove":
			if "got_notes" in flags:
				list.append(["notes", Rect2(380, 330, 200, 110), "go:xnotes"])
			else:
				list.append(["tile", Rect2(500, 260, 90, 80), "tap"])
			list.append(["damper", Rect2(640, 60, 200, 120), "cmd:turn damper 0 +1"])
			list.append(["stove", Rect2(200, 20, 420, 300), "tap"])
		"xnotes":
			list = [["notes", Rect2(40, 20, 880, 440), "tap"]]
		"xphone":
			if talking:
				list = _talk(st, art)
			else:
				list = Set2Views._wheels("phone", 4, 140, 270)
				list.append_array(_talk(st, art))
		"xcourt":
			list = [["court", Rect2(20, 20, 920, 432), "tap"]]
		"xplan":
			list = [["plan", Rect2(60, 20, 840, 440), "tap"]]
		"xwall":
			if "niche_open" in flags:
				list = Set2Views._wheels("box", 4, 360, 290)
			else:
				for i in range(6):
					list.append(["wall%d" % i, Rect2(60 + i * 140.0, 40, 130, 400), "tap"])
	return list


static func lights(view: String, _st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		# 1905: gas light, late evening.
		return {"dark": 0.2 if close else 0.4, "warm": [Vector4(480, 120, 560, 1.0)], "cold": none, "tint": Vector3(0.1, 0.05, 0.0)}
	if place in RINGS[1]:
		return {"dark": 0.16 if close else 0.32, "warm": [Vector4(700, 60, 520, 1.0)], "cold": none, "tint": Vector3(0.06, 0.04, 0.02)}
	if place in RINGS[2]:
		return {"dark": 0.1 if close else 0.2, "warm": [Vector4(480, 100, 600, 1.0)], "cold": none, "tint": Vector3(0.05, 0.03, 0.0)}
	return {"dark": 0.04 if close else 0.1, "warm": [], "cold": none, "tint": Vector3(0.0, 0.0, 0.0)}
