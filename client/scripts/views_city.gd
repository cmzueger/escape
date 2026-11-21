## Midnight in Serenissima: a city of twenty places (SR0 … SR19) walked
## street by street, a map (srmap) and close-ups (sr…). Every step to a place
## tells the rules (`walk i`), which keep where you are and what you have
## seen. Rectangles match art_city.gd, which reads them from here.
class_name CityViews
extends RefCounted

const ROOM := "carnival"
const FIRST := {"carnival": "SR0"}
const PLACE_VIEWS := ["SR0", "SR1", "SR2", "SR3", "SR4", "SR5", "SR6", "SR7", "SR8", "SR9", "SR10", "SR11", "SR12", "SR13", "SR14", "SR15", "SR16", "SR17", "SR18", "SR19"]
const PLACES := 20
## Where each place lies on the map (and, scaled down, on the small map).
const MAP_AT := [
	Vector2(480, 250), Vector2(600, 220), Vector2(640, 110), Vector2(720, 300), Vector2(370, 250),
	Vector2(260, 270), Vector2(360, 150), Vector2(360, 60), Vector2(200, 60), Vector2(500, 120),
	Vector2(840, 250), Vector2(150, 280), Vector2(150, 170), Vector2(600, 390), Vector2(440, 390),
	Vector2(170, 390), Vector2(240, 150), Vector2(790, 110), Vector2(860, 370), Vector2(760, 430),
]
## The ways out of each place: left, right, ahead, back.
const EXITS := [
	{"l": 4, "r": 1, "b": 14, "f": 9},
	{"l": 0, "r": 3, "f": 2},
	{"b": 1, "r": 17, "l": 9},
	{"l": 1, "r": 10, "b": 13},
	{"r": 0, "l": 5, "f": 6},
	{"r": 4, "l": 11},
	{"b": 4, "l": 16, "f": 7},
	{"b": 6, "l": 8},
	{"r": 7, "b": 12},
	{"b": 0, "r": 2},
	{"l": 3, "f": 17, "b": 18},
	{"r": 5, "f": 12, "b": 15},
	{"f": 8, "b": 11},
	{"f": 3, "l": 14},
	{"f": 0, "r": 13, "l": 15},
	{"f": 11, "r": 14},
	{"r": 6},
	{"l": 2, "b": 10},
	{"f": 10},
	{"b": 3},
]
const ARROW := {"l": Rect2(6, 200, 52, 72), "r": Rect2(902, 200, 52, 72), "f": Rect2(430, 6, 100, 50), "b": Rect2(430, 414, 100, 52)}
const ARROW_DIR := {"f": 0, "b": 1, "l": 2, "r": 3}
const LANTERN := Rect2(250, 8, 50, 78)
const MINIMAP := Rect2(790, 8, 110, 66)
const PARENT := {
	"srstage": "SR0", "srcafe": "SR4", "srmasks": "SR5", "srglass": "SR8", "srtoss": "SR11",
	"srfoyer": "SR14", "srcourt": "SR16", "srcasket": "srcourt", "srtop": "SR2", "srsong": "SR3",
	"srlagoon": "SR3",
}
## What can be tapped in each place, besides its ways out, the lantern and the small map.
const SPOTS := {
	"SR0": [["basilica", Rect2(330, 70, 300, 110)], ["stage", Rect2(360, 200, 240, 140)], ["pigeons", Rect2(110, 330, 200, 60)],
		["pigeonlady", Rect2(70, 200, 80, 130)], ["lioncolumn", Rect2(690, 90, 60, 280)], ["crowd", Rect2(770, 250, 120, 130)]],
	"SR1": [["moors", Rect2(410, 62, 140, 40)], ["clockface", Rect2(400, 110, 160, 160)], ["plaque", Rect2(420, 300, 120, 50)],
		["crowd", Rect2(110, 270, 170, 110)]],
	"SR2": [["towerdoor", Rect2(430, 250, 100, 120)], ["musicians", Rect2(640, 260, 160, 110)]],
	"SR3": [["lagoon", Rect2(80, 140, 380, 160)], ["gondolier", Rect2(560, 210, 90, 160)], ["song", Rect2(680, 200, 70, 70)],
		["gondola", Rect2(560, 372, 330, 44)]],
	"SR4": [["tables", Rect2(100, 250, 400, 130)], ["musicians", Rect2(520, 110, 110, 120)], ["waiter", Rect2(640, 170, 90, 200)],
		["cup", Rect2(760, 250, 70, 50)]],
	"SR5": [["wall", Rect2(130, 60, 520, 290)], ["maker", Rect2(700, 170, 110, 200)]],
	"SR6": [["shops", Rect2(80, 110, 260, 210)], ["crowd", Rect2(600, 180, 200, 120)], ["bridgeboats", Rect2(560, 380, 300, 44)]],
	"SR7": [["fish", Rect2(110, 220, 200, 150)], ["fruit", Rect2(330, 250, 180, 120)], ["baker", Rect2(560, 160, 180, 200)]],
	"SR8": [["sign", Rect2(110, 80, 180, 100)], ["furnace", Rect2(330, 120, 300, 240)], ["glassblower", Rect2(680, 170, 100, 200)]],
	"SR9": [["books", Rect2(100, 90, 370, 260)], ["bookcat", Rect2(520, 300, 100, 70)], ["bookseller", Rect2(680, 150, 110, 220)]],
	"SR10": [["gate", Rect2(380, 80, 200, 190)], ["lions", Rect2(70, 280, 820, 90)]],
	"SR11": [["children", Rect2(100, 250, 180, 120)], ["well", Rect2(380, 230, 200, 140)], ["toss", Rect2(640, 120, 240, 250)]],
	"SR12": [["laundry", Rect2(110, 90, 720, 110)], ["singer", Rect2(640, 210, 90, 90)]],
	"SR13": [["ringer", Rect2(130, 260, 140, 110)], ["portal", Rect2(380, 90, 200, 220)], ["tapers", Rect2(640, 230, 80, 90)],
		["candles", Rect2(740, 200, 130, 150)]],
	"SR14": [["posters", Rect2(120, 120, 200, 240)], ["door", Rect2(400, 160, 140, 210)], ["doorman", Rect2(560, 180, 90, 190)]],
	"SR15": [["oars", Rect2(140, 130, 140, 220)], ["hull", Rect2(320, 280, 220, 90)], ["boatbuilder", Rect2(600, 170, 100, 200)]],
	"SR16": [["balcony", Rect2(380, 40, 200, 90)], ["door", Rect2(410, 160, 140, 210)], ["porter", Rect2(580, 180, 90, 190)]],
	"SR17": [["passage", Rect2(330, 90, 300, 280)], ["shrine", Rect2(700, 120, 100, 120)]],
	"SR18": [["fishermen", Rect2(150, 240, 180, 130)], ["barge", Rect2(560, 180, 300, 120)]],
	"SR19": [["crate", Rect2(120, 250, 180, 120)], ["pole", Rect2(330, 40, 60, 330)]],
}
## The masks on the mask maker's wall.
const MASK_AT := Vector2(150, 40)
const MASK_GAP := Vector2(240, 210)
## The canals seen from above (gondola).
const CANAL_AT := Vector2(60, 50)
const CANAL_CELL := 70.0
const PAD := {"n": Rect2(780, 70, 72, 56), "w": Rect2(708, 140, 72, 56), "e": Rect2(852, 140, 72, 56), "s": Rect2(780, 210, 72, 56)}
## The rockets on the barge.
const ROCKET_X := 450.0
const ROCKET_GAP := 90.0

## The place last stood in: where the map returns to.
static var here := "SR0"


static func is_place(view: String) -> bool:
	return view in PLACE_VIEWS


static func place_index(view: String) -> int:
	return int(view.substr(2))


static func has(view: String) -> bool:
	return is_place(view) or PARENT.has(view) or view == "srmap"


static func is_wall(view: String) -> bool:
	return is_place(view)


static func back(view: String) -> String:
	if view == "srmap":
		return here
	return PARENT.get(view, "")


## Called on every change of view.
static func note(next: String) -> void:
	if is_place(next):
		here = next


static func seen(st: Dictionary, i: int) -> bool:
	var list: Array = st.get("seen", [])
	return i < list.size() and int(list[i]) == 1


static func reachable(view: String, st: Dictionary) -> bool:
	var flags: Array = st.get("flags", [])
	if is_place(view):
		return place_index(view) != 19 or "at_barge" in flags
	var need := {"srfoyer": "foyer_open", "srcourt": "court_open", "srcasket": "court_open", "srtop": "tower_open",
		"srsong": "paid", "srlagoon": "paid"}
	return not need.has(view) or need[view] in flags


static func spots(view: String, st: Dictionary, _art: Variant) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	if is_place(view):
		here = view
		var i := place_index(view)
		var exits: Dictionary = EXITS[i]
		for d in ["l", "r", "f", "b"]:
			if exits.has(d):
				list.append(["walk_" + d, ARROW[d], "go:SR%d" % int(exits[d])])
		list.append(["minimap", MINIMAP, "go:srmap"])
		for spot in SPOTS[view]:
			var action := "tap"
			match [view, spot[0]]:
				["SR0", "stage"]: action = "go:srstage"
				["SR2", "towerdoor"]: action = "go:srtop" if "tower_open" in flags else "tap"
				["SR3", "song"]: action = "go:srsong" if "paid" in flags else "tap"
				["SR3", "gondola"]: action = "go:srlagoon" if "paid" in flags and "oar_in" in flags and "lamp_on" in flags else "tap"
				["SR4", "tables"]: action = "go:srcafe"
				["SR5", "wall"]: action = "go:srmasks"
				["SR8", "furnace"]: action = "go:srglass"
				["SR11", "toss"]: action = "go:srtoss"
				["SR14", "door"]:
					if not "foyer_open" in flags:
						continue
					action = "go:srfoyer"
				["SR16", "door"]:
					if not "court_open" in flags:
						continue
					action = "go:srcourt"
			list.append([spot[0], spot[1], action])
		if i == 19:
			for k in range(5):
				list.append(["rocket%d" % k, Rect2(ROCKET_X + k * ROCKET_GAP - 35, 170, 70, 200), "cmd:rocket %d" % k])
		list.append(["lantern", LANTERN, "tap"])
		return list
	match view:
		"srmap":
			for k in range(PLACES):
				if seen(st, k) and "SR%d" % k != here:
					var p: Vector2 = MAP_AT[k]
					list.append(["place%d" % k, Rect2(p.x - 26, p.y - 26, 52, 52), "go:SR%d" % k])
		"srstage":
			if "got_card" in flags:
				list = [["card", Rect2(300, 40, 360, 330), "tap"]]
			else:
				list = [["cushion", Rect2(330, 180, 300, 160), "tap"]]
		"srcafe":
			if not "got_ticket" in flags:
				list.append(["ticket", Rect2(560, 384, 54, 32), "tap"])
			list.append(["chairs", Rect2(100, 140, 760, 230), "tap"])
		"srmasks":
			for k in range(6):
				list.append(["mask%d" % k, Rect2(MASK_AT.x + (k % 3) * MASK_GAP.x, MASK_AT.y + int(k / 3) * MASK_GAP.y, 180, 180), "tap"])
		"srglass":
			list = [["gather", Rect2(300, 140, 360, 260), "cmd:blow"], ["sign", Rect2(700, 30, 220, 110), "tap"]]
		"srtoss":
			list = [["stand", Rect2(300, 80, 360, 300), "cmd:throw"], ["barker", Rect2(720, 150, 140, 220), "tap"]]
		"srfoyer":
			list = [["poster", Rect2(220, 20, 520, 420), "tap"]]
		"srcourt":
			list = [["diary", Rect2(120, 250, 240, 120), "tap"], ["casket", Rect2(560, 240, 200, 130), "go:srcasket"], ["cat", Rect2(780, 300, 120, 70), "tap"]]
		"srcasket":
			if "casket_open" in flags:
				if not "got_cratekey" in flags:
					list = [["casketkey", Rect2(330, 150, 300, 200), "tap"]]
			else:
				for k in range(4):
					list.append_array(Set8Views._updown("casket", k, 240 + k * 160.0, 210))
		"srtop":
			list = [["scope_left", Rect2(40, 200, 72, 72), "cmd:turn scope 0 -1"], ["scope_right", Rect2(848, 200, 72, 72), "cmd:turn scope 0 +1"]]
			var at := int(st.get("scope", [0])[0])
			var scope: Array = _art.clues.get("scope", [5, 2]) if _art != null else [5, 2]
			if at == int(scope[0]):
				list.append(["thief", Rect2(400, 180, 180, 180), "tap"])
			elif at == int(scope[1]):
				list.append(["reveller", Rect2(400, 180, 180, 180), "tap"])
			list.append(["view", Rect2(160, 40, 640, 380), "tap"])
		"srsong":
			list = [["song", Rect2(140, 20, 680, 440), "tap"]]
		"srlagoon":
			for d in ["n", "w", "e", "s"]:
				list.append(["pole_" + d, PAD[d], "cmd:pole " + d])
			if "at_barge" in flags:
				list.append(["tobarge", Rect2(CANAL_AT.x + 7 * CANAL_CELL, CANAL_AT.y + 4 * CANAL_CELL, CANAL_CELL, CANAL_CELL), "go:SR19"])
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var done: bool = st.get("done", false)
	if view == "srmap" or view == "srfoyer" or view == "srsong":
		return {"dark": 0.05, "warm": [Vector4(480, 200, 600, 0.6)], "cold": Vector4.ZERO, "tint": Vector3(0.02, 0.01, 0.0)}
	if not is_place(view):
		return {"dark": 0.18, "warm": [Vector4(480, 220, 520, 0.8)], "cold": Vector4(480, 0, 500, 0.2), "tint": Vector3(0.0, 0.0, 0.04)}
	var warm := [Vector4(LANTERN.get_center().x, LANTERN.get_center().y + 20, 300, 0.9), Vector4(700, 260, 380, 0.6)]
	if done:
		warm.append(Vector4(480, 60, 700, 1.0))
	return {"dark": 0.12 if done else 0.32, "warm": warm, "cold": Vector4(480, 0, 700, 0.35), "tint": Vector3(0.0, 0.0, 0.06)}
