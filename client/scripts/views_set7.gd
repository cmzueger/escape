## The seventh set: The Night Edition (O…, close-ups d…), The Great Vaudini
## (F…, close-ups f…) and Rain on Gale Street (I…, close-ups i…): views,
## hotspots and light (see views.gd). Rectangles match art_set7.gd.
class_name Set7Views
extends RefCounted

const RINGS := [["O1", "O2"], ["F1", "F2"], ["I1", "I2"]]
const PARENT := {
	"dbin": "O1", "dcards": "O1", "dlocker": "O1", "dstick": "O1", "dnotebook": "O1", "drules": "O1", "dmonday": "O1",
	"dlog": "O2", "dreels": "O2", "dchart": "O2", "dweb": "O2", "dfount": "O2", "dpress": "O2", "ddesk": "O2",
	"frack": "F1", "ftrunk": "F1", "fscript": "ftrunk", "fletter": "ftrunk", "fcabinet": "F1", "ftable": "F1",
	"fmirror": "F1", "fposter": "F1",
	"fglass": "F2", "fswitch": "F2", "fbox": "F2", "fdoor": "F2",
	"ibin": "I1", "idesk": "I1", "iread": "idesk", "iblinds": "I1", "icabinet": "I1", "itype": "I1", "iboard": "I1",
	"isafe": "I1",
	"icoats": "I2", "iradio": "I2", "iglass": "I2", "itimetable": "I2", "idoor": "I2",
}
const FIRST := {"press": "O1", "magic": "F1", "noir": "I1"}
## The type case: ten sorts in two rows.
const SORT_X := 70.0
const SORT_W := 84.0


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func sort_rect(d: int) -> Rect2:
	return Rect2(SORT_X + (d % 5) * SORT_W, 30 + (d / 5) * 100.0, SORT_W - 8, 90)


static func spots(view: String, st: Dictionary, _art: ArtSet7) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Night Edition
		"O1":
			list = [
				["case", Rect2(40, 150, 250, 150), "go:dstick"],
				["bin", Rect2(300, 300, 90, 70), "go:dbin"],
				["cards", Rect2(320, 60, 120, 150), "go:dcards"],
				["lockers", Rect2(470, 60, 200, 310), "go:dlocker"],
				["rules", Rect2(700, 40, 140, 170), "go:drules"],
				["notebook", Rect2(700, 280, 150, 80), "go:dnotebook"],
				["monday", Rect2(860, 50, 90, 150), "go:dmonday"],
				["door", Rect2(870, 220, 80, 150), "tap"],
			]
		"O2":
			list = [
				["chart", Rect2(40, 30, 220, 130), "go:dchart"],
				["reels", Rect2(40, 190, 220, 180), "go:dreels"],
				["web", Rect2(290, 30, 300, 90), "go:dweb"],
				["press", Rect2(290, 130, 300, 240), "go:dpress"],
				["fount", Rect2(610, 200, 110, 170), "go:dfount"],
				["log", Rect2(740, 110, 130, 90), "go:dlog"],
				["desk", Rect2(740, 220, 200, 150), "go:ddesk"],
				["clock", Rect2(880, 30, 70, 70), "tap"],
			]
		"dbin":
			list = [["letter", Rect2(240, 60, 480, 380), "tap"]]
		"dcards":
			list = [["cards", Rect2(40, 20, 880, 440), "tap"]]
		"dlog":
			list = [["log", Rect2(60, 20, 840, 440), "tap"]]
		"dnotebook":
			list = [["notebook", Rect2(140, 20, 680, 440), "tap"]]
		"drules":
			list = [["rules", Rect2(140, 20, 680, 440), "tap"]]
		"dmonday":
			list = [["monday", Rect2(80, 20, 800, 440), "tap"]]
		"dlocker":
			if "locker_open" in flags:
				if not "got_forme" in flags:
					list.append(["forme", Rect2(120, 120, 300, 250), "tap"])
				list.append(["manual", Rect2(500, 60, 380, 360), "tap"])
			else:
				list = Set2Views._wheels("locker", 3, 400, 250)
		"dstick":
			for d in range(10):
				list.append(["sort%d" % d, sort_rect(d), "cmd:sort %d" % d])
			list.append(["clear", Rect2(500, 60, 120, 70), "cmd:clear"])
			list.append(["proof", Rect2(660, 40, 260, 150), "cmd:proof"])
			list.append(["stick", Rect2(60, 240, 560, 100), "tap"])
		"dreels":
			for i in range(3):
				list.append(["reel%d" % i, Rect2(70 + i * 290, 40, 240, 290), "tap"])
				list.append(["mount%d" % i, Rect2(110 + i * 290, 350, 160, 80), "cmd:mount %d" % i])
		"dchart":
			list = [["chart", Rect2(40, 20, 880, 440), "tap"]]
		"dweb":
			for i in range(6):
				list.append(["roller%d" % i, Rect2(60 + i * 145, 120, 130, 240), "cmd:flip web %d" % i])
		"dfount":
			list = Set2Views._wheels("ink", 5, 240, 300, 120)
		"dpress":
			list = [
				["cylinder", Rect2(120, 60, 440, 260), "tap"],
				["press", Rect2(620, 160, 220, 180), "tap"],
			]
		"ddesk":
			if not "got_lantern" in flags:
				list.append(["lantern", Rect2(40, 150, 150, 220), "tap"])
			list.append(["tuesday", Rect2(210, 30, 360, 410), "tap"])
			if "drawer_open" in flags:
				if not "got_key" in flags:
					list.append(["pkey", Rect2(640, 250, 260, 140), "tap"])
			else:
				list.append_array(Set2Views._wheels("drawer", 4, 650, 270))
		# --- The Great Vaudini
		"F1":
			list = [
				["poster", Rect2(60, 20, 160, 110), "go:fposter"],
				["rack", Rect2(30, 140, 250, 230), "go:frack"],
				["mirror", Rect2(330, 40, 260, 200), "go:fmirror"],
				["bulbs", Rect2(606, 150, 56, 70), "cmd:flip bulbs 0"],
				["table", Rect2(320, 250, 300, 120), "go:ftable"],
				["cabinet", Rect2(700, 40, 170, 210), "go:fcabinet"],
				["trunk", Rect2(680, 270, 250, 100), "go:ftrunk"],
			]
		"F2":
			list = [
				["switch", Rect2(60, 80, 130, 150), "go:fswitch"],
				["box", Rect2(30, 260, 250, 110), "go:fbox"],
				["glass", Rect2(310, 40, 360, 300), "go:fglass"],
				["bell", Rect2(690, 40, 50, 70), "tap"],
				["door", Rect2(750, 40, 180, 330), "go:fdoor"],
			]
		"frack":
			list = [
				["lining", Rect2(500, 110, 170, 260), "tap"],
				["costume", Rect2(80, 40, 800, 400), "tap"],
			]
		"ftrunk":
			if "trunk_open" in flags:
				list = [["script", Rect2(110, 60, 340, 360), "go:fscript"], ["letter", Rect2(510, 60, 340, 360), "go:fletter"]]
			else:
				list = [["trunk", Rect2(120, 80, 720, 320), "tap"]]
		"fscript":
			list = [["script", Rect2(100, 20, 760, 440), "tap"]]
		"fletter":
			list = [["letter", Rect2(140, 20, 680, 440), "tap"]]
		"fposter":
			list = [["poster", Rect2(200, 20, 560, 440), "tap"]]
		"fmirror":
			list = [["mirror", Rect2(160, 20, 640, 440), "tap"]]
		"ftable":
			if "spread" in flags:
				for i in range(8):
					list.append(["card%d" % i, Rect2(50 + i * 110, 150, 100, 150), "cmd:flip cards %d" % i])
			else:
				list = [["table", Rect2(80, 60, 800, 360), "tap"]]
		"fcabinet":
			if "cabinet_open" in flags:
				list = [["cabinet", Rect2(200, 40, 560, 400), "tap"]]
			else:
				for i in range(6):
					list.append(["panel%d" % i, Rect2(200 + (i % 3) * 190, 50 + (i / 3) * 200, 170, 180), "cmd:panel %d" % i])
		"fswitch":
			list = [["lamp", Rect2(380, 100, 200, 260), "cmd:flip lamp 0"]]
		"fglass":
			list = [
				["glass", Rect2(120, 20, 560, 300), "tap"],
				["tilt_left", Rect2(620, 350, 110, 90), "cmd:turn tilt 0 -1"],
				["tilt_right", Rect2(800, 350, 110, 90), "cmd:turn tilt 0 +1"],
			]
		"fbox":
			for i in range(3):
				list.append(["part%d" % i, Rect2(140 + i * 230, 100, 210, 220), "cmd:turn saw %d +1" % i])
			if "saw_ok" in flags and not "got_rabbit" in flags:
				list.append(["rabbit", Rect2(380, 340, 200, 110), "tap"])
		"fdoor":
			list = Set2Views._wheels("pad1", 4, 110, 250)
			list.append_array(Set2Views._wheels("pad2", 3, 480, 250))
			list.append(["chain", Rect2(760, 60, 170, 360), "tap"])
		# --- Rain on Gale Street
		"I1":
			list = [
				["cabinet", Rect2(40, 60, 150, 190), "go:icabinet"],
				["typewriter", Rect2(40, 270, 200, 100), "go:itype"],
				["board", Rect2(240, 30, 300, 170), "go:iboard"],
				["desk", Rect2(300, 220, 360, 150), "go:idesk"],
				["bin", Rect2(670, 300, 70, 70), "go:ibin"],
				["window", Rect2(680, 30, 250, 230), "go:iblinds"],
				["safe", Rect2(760, 280, 170, 90), "go:isafe"],
			]
		"I2":
			list = [
				["coats", Rect2(40, 40, 200, 330), "go:icoats"],
				["timetable", Rect2(280, 40, 200, 170), "go:itimetable"],
				["radio", Rect2(280, 250, 170, 120), "go:iradio"],
				["glass", Rect2(590, 50, 160, 130), "go:iglass"],
				["door", Rect2(560, 30, 220, 340), "go:idoor"],
				["phone", Rect2(810, 240, 130, 130), "tap"],
			]
		"ibin":
			if not "got_carbon" in flags:
				list.append(["carbon", Rect2(330, 180, 300, 160), "tap"])
			list.append(["bin", Rect2(220, 40, 520, 400), "tap"])
		"idesk":
			list = [
				["lamp", Rect2(70, 30, 220, 240), "tap"],
				["lampswitch", Rect2(110, 290, 140, 90), "cmd:flip lamp 0"],
				["pad", Rect2(340, 190, 320, 220), "tap"],
			]
			if "carbon_read" in flags or "ribbon_read" in flags:
				list.append(["readings", Rect2(700, 30, 230, 300), "go:iread"])
		"iread":
			list = [["readings", Rect2(40, 20, 880, 440), "tap"]]
		"iblinds":
			list = [
				["blinds_open", Rect2(790, 110, 120, 90), "cmd:turn blinds 0 +1"],
				["blinds_shut", Rect2(790, 260, 120, 90), "cmd:turn blinds 0 -1"],
				["window", Rect2(80, 30, 640, 420), "tap"],
			]
		"icabinet":
			if "cabinet_open" in flags:
				list = [["cabinet", Rect2(60, 20, 840, 440), "tap"]]
			else:
				list = Set2Views._wheels("cabinet", 4, 360, 250)
		"itype":
			if not "got_ribbon" in flags:
				list.append(["ribbon", Rect2(380, 110, 200, 110), "tap"])
			list.append(["typewriter", Rect2(100, 40, 760, 400), "tap"])
		"iboard":
			list = [["board", Rect2(40, 20, 880, 440), "tap"]]
		"isafe":
			if "safe_open" in flags:
				if not "got_opener" in flags:
					list.append(["opener", Rect2(280, 180, 200, 180), "tap"])
				list.append(["ruby", Rect2(520, 180, 180, 180), "tap"])
			else:
				list = Set2Views._wheels("safe", 4, 360, 250)
		"icoats":
			for i in range(3):
				list.append(["coat%d" % i, Rect2(60 + i * 300, 30, 260, 410), "tap"])
		"iradio":
			list = Set2Views._wheels("radio", 2, 440, 270)
			list.append(["note", Rect2(640, 200, 260, 200), "tap"])
		"iglass":
			list = [["glass", Rect2(120, 20, 720, 440), "tap"]]
		"itimetable":
			list = [["timetable", Rect2(100, 20, 760, 440), "tap"]]
		"idoor":
			list = [
				["keyhole", Rect2(640, 190, 120, 130), "tap"],
				["sheet", Rect2(160, 390, 640, 70), "tap"],
				["door", Rect2(160, 20, 640, 360), "tap"],
			]
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		# Gaslight in the print works.
		return {"dark": 0.18 if close else 0.38, "warm": [Vector4(480, 60, 520, 1.0)], "cold": none, "tint": Vector3(0.08, 0.05, 0.0)}
	if place in RINGS[1]:
		return {"dark": 0.12 if close else 0.28, "warm": [Vector4(460, 120, 560, 1.0)], "cold": none, "tint": Vector3(0.1, 0.02, 0.02)}
	# Gale Street: the desk lamp, or only the neon.
	var lamp := int(st.get("lamp", [1])[0]) == 1
	var red := Vector4(800, 140, 700, 1.0) if int(st.get("blinds", [0])[0]) > 0 else none
	if lamp:
		return {"dark": 0.14 if close else 0.34, "warm": [Vector4(480, 240, 520, 1.0)], "cold": red, "tint": Vector3(0.0, 0.0, 0.0)}
	return {"dark": 0.3 if close else 0.5, "warm": [], "cold": red, "tint": Vector3(0.18, 0.0, 0.02)}
