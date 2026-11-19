## The ninth set: The Glass Aviary (AV…, close-ups av…), Hall of Mirrors
## (HM…, close-ups hm…) and Detention (SC…, close-ups sc…): views, hotspots
## and light (see views.gd). Rectangles match art_set9.gd.
class_name Set9Views
extends RefCounted

const RINGS := [["AV1", "AV2", "AV3", "AV4"], ["HM1", "HM2", "HM3", "HM4"], ["SC1", "SC2", "SC3", "SC4"]]
const PARENT := {
	"avdesk": "AV1", "avperches": "AV1", "avshade": "AV1",
	"avparrot": "AV2", "avorchid": "AV2",
	"avcage": "AV3",
	"avjars": "AV4",
	"hmbooth": "HM1", "hmposter": "HM1", "hmzelda": "HM1",
	"hmdrawing": "HM3", "hmstall": "HM3", "hmperiscope": "HM3", "hmcart": "HM3",
	"hmhorses": "HM4", "hmgen": "HM4", "hmfuses": "HM4", "hmspots": "HM4", "hmorgan": "HM4",
	"scboard": "SC1", "scabacus": "SC1", "scclock": "SC1", "scmap": "SC1",
	"scdesks": "SC2", "scletter": "scdesks", "scshelf": "SC2", "scpegs": "SC2",
	"sctasks": "SC3", "scregister": "SC3", "scharmonium": "SC3", "scglobe": "SC3", "scbell": "SC3", "scphoto": "SC3",
	"scwindow": "SC4", "schutch": "SC4", "scstove": "SC4",
}
const FIRST := {"aviary": "AV1", "mirrors": "HM1", "school": "SC1"}
## The maze's step buttons (north, west, east, south) in HM2.
const STEPS := {"n": Rect2(444, 96, 72, 56), "w": Rect2(240, 214, 72, 56), "e": Rect2(648, 214, 72, 56), "s": Rect2(444, 312, 72, 56)}


static func is_wall(view: String) -> bool:
	for ring in RINGS:
		if view in ring:
			return true
	return false


static func has(view: String) -> bool:
	return is_wall(view) or PARENT.has(view)


static func _updown(dial: String, i: int, x: float, y: float) -> Array:
	return Set8Views._updown(dial, i, x, y)


static func _talk(st: Dictionary, art: ArtSet9, caller: String) -> Array:
	return Set8Views._talk(st, art, caller)


static func spots(view: String, st: Dictionary, art: ArtSet9) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		# --- The Glass Aviary
		"AV1":
			if not "got_keys" in flags:
				list.append(["nestbox", Rect2(70, 50, 120, 120), "tap"])
			list.append_array([
				["desk", Rect2(220, 230, 220, 140), "go:avdesk"],
				["bell", Rect2(470, 50, 90, 120), "tap"],
				["stand", Rect2(470, 210, 110, 160), "go:avperches"],
				["dome", Rect2(600, 40, 160, 330), "tap"],
				["crank", Rect2(790, 120, 100, 140), "go:avshade"],
			])
		"AV2":
			list = [
				["tree", Rect2(64, 40, 200, 330), "tap"],
				["parrot", Rect2(290, 60, 140, 200), "go:avparrot"],
				["feeder", Rect2(460, 60, 110, 160), "tap"],
				["orchid", Rect2(600, 180, 160, 190), "go:avorchid"],
				["peacock", Rect2(780, 200, 110, 170), "tap"],
			]
		"AV3":
			list = [
				["kingfisher", Rect2(64, 40, 140, 150), "tap"],
				["pond", Rect2(64, 240, 380, 130), "tap"],
				["tap", Rect2(470, 150, 90, 140), "tap"],
			]
			if not "got_can" in flags:
				list.append(["can", Rect2(470, 300, 90, 70), "tap"])
			list.append(["cage", Rect2(600, 170, 140, 200), "go:avcage"])
			list.append(["owl", Rect2(760, 40, 130, 130), "tap"])
			list.append(["owlperch", Rect2(760, 180, 130, 70), "tap"])
		"AV4":
			if not "store_open" in flags:
				list = [["storedoor", Rect2(300, 40, 360, 330), "tap"]]
			else:
				if not "got_net" in flags:
					list.append(["net", Rect2(70, 60, 120, 220), "tap"])
				if not "got_knife" in flags:
					list.append(["knife", Rect2(220, 250, 110, 60), "tap"])
				if not "got_sugar" in flags:
					list.append(["sugar", Rect2(360, 230, 90, 90), "tap"])
				if not "got_scoop" in flags:
					list.append(["scoop", Rect2(480, 250, 100, 70), "tap"])
				list.append(["jars", Rect2(600, 60, 270, 140), "go:avjars"])
				list.append(["sack", Rect2(620, 240, 190, 130), "tap"])
		"avdesk":
			list = [["desk", Rect2(60, 20, 420, 440), "tap"], ["plan", Rect2(500, 20, 400, 440), "tap"]]
		"avperches":
			for i in range(6):
				list.append_array(_updown("perches", i, 130 + i * 140.0, 230))
		"avshade":
			list = _updown("shade", 0, 700, 230)
			list.append(["crank", Rect2(120, 60, 360, 360), "tap"])
		"avparrot":
			if not "fed_parrot" in flags:
				list = [["parrot", Rect2(300, 40, 360, 400), "tap"]]
			else:
				list = _talk(st, art, "parrot")
		"avorchid":
			for i in range(3):
				list.append_array(_updown("mist", i, 160 + i * 170.0, 240))
			list.append(["orchid", Rect2(640, 20, 280, 220), "tap"])
		"avcage":
			list = [["canary", Rect2(300, 30, 360, 280), "tap"]]
			if "got_whistle" in flags:
				for i in range(4):
					list.append(["hole%d" % i, Rect2(200 + i * 150.0, 340, 110, 100), "cmd:key %d" % i])
		"avjars":
			for i in range(3):
				list.append(["jar%d" % i, Rect2(140 + i * 240.0, 90, 200, 320), "cmd:jar %d" % i])
		# --- Hall of Mirrors
		"HM1":
			list = [["booth", Rect2(64, 60, 240, 270), "go:hmbooth"]]
			if not "got_coin" in flags:
				list.append(["coin", Rect2(190, 335, 60, 34), "tap"])
			list.append_array([
				["turnstile", Rect2(340, 170, 170, 200), "tap"],
				["zelda", Rect2(560, 40, 150, 330), "go:hmzelda"],
				["poster", Rect2(740, 50, 150, 190), "go:hmposter"],
			])
		"HM2":
			if not "in_maze" in flags:
				list = [["maze", Rect2(200, 40, 560, 330), "tap"]]
			else:
				for d in ["n", "w", "e", "s"]:
					list.append(["step_" + d, STEPS[d], "cmd:step " + d])
				if int(st.get("pos", [0])[0]) == 12 and not "got_key" in flags:
					list.append(["brasskey", Rect2(420, 170, 120, 120), "tap"])
		"HM3":
			list = [
				["wavymirror", Rect2(70, 40, 100, 320), "tap"],
				["drawing", Rect2(180, 30, 120, 120), "go:hmdrawing"],
				["squatmirror", Rect2(180, 170, 120, 190), "tap"],
				["stall", Rect2(320, 120, 200, 250), "go:hmstall"],
				["tester", Rect2(540, 40, 80, 330), "tap"],
				["cabinet", Rect2(640, 40, 120, 150), "tap"],
				["curtain" if not "curtain_open" in flags else "periscope", Rect2(640, 210, 120, 160),
					"tap" if not "curtain_open" in flags else "go:hmperiscope"],
				["cart", Rect2(780, 150, 110, 220), "go:hmcart"],
			]
		"HM4":
			list = [
				["fusebox", Rect2(70, 50, 110, 130), "go:hmfuses"],
				["generator", Rect2(70, 220, 120, 150), "go:hmgen"],
				["carousel", Rect2(200, 40, 390, 330), "tap" if "turning" in flags else "go:hmhorses"],
				["lever", Rect2(610, 40, 90, 130), "tap"],
				["clown", Rect2(610, 200, 100, 170), "tap"],
				["organ", Rect2(720, 40, 170, 150), "go:hmorgan"],
				["spotlight", Rect2(720, 210, 170, 160), "go:hmspots"],
			]
		"hmbooth":
			list = [["plan", Rect2(200, 20, 560, 440), "tap"]]
		"hmposter":
			list = [["poster", Rect2(200, 20, 560, 440), "tap"]]
		"hmzelda":
			if not "zelda_on" in flags:
				list = [["zelda", Rect2(300, 30, 360, 420), "tap"]]
			else:
				list = _talk(st, art, "zelda")
		"hmdrawing":
			list = [["drawing", Rect2(200, 40, 560, 400), "tap"]]
		"hmstall":
			if "got_darts" in flags and not "got_mirror" in flags:
				for i in range(5):
					list.append(["balloon%d" % i, Rect2(140 + i * 140.0, 160, 120, 160), "cmd:balloon %d" % i])
			elif not "got_darts" in flags:
				list.append(["shelf", Rect2(140, 20, 680, 110), "tap"])
			list.append(["stall", Rect2(140, 340, 680, 110), "tap"])
		"hmperiscope":
			list = [["periscope", Rect2(240, 20, 480, 440), "tap"]]
		"hmcart":
			if not "got_sugar" in flags:
				list.append(["sugar", Rect2(90, 260, 170, 120), "tap"])
			if not "got_stick" in flags:
				list.append(["sticks", Rect2(290, 260, 140, 120), "tap"])
			list.append(["machine", Rect2(480, 60, 380, 360), "tap"])
		"hmhorses":
			for i in range(4):
				list.append_array(_updown("horses", i, 200 + i * 190.0, 230))
		"hmgen":
			list = _updown("generator", 0, 720, 230)
			list.append(["generator", Rect2(120, 40, 360, 400), "tap"])
		"hmfuses":
			for i in range(5):
				list.append(["fuse%d" % i, Rect2(130 + i * 145.0, 160, 110, 220), "cmd:flip fuses %d" % i])
			list.append(["fusebox", Rect2(130, 20, 700, 110), "tap"])
		"hmspots":
			if not "mirror_in" in flags:
				list = [["spotlight", Rect2(560, 150, 220, 220), "tap"]]
			else:
				list = _updown("spots", 0, 260, 250) + _updown("spots", 1, 700, 250)
			list.append(["sensor", Rect2(400, 20, 160, 100), "tap"])
		"hmorgan":
			list = [
				["card", Rect2(160, 90, 300, 300), "cmd:turn card 0 +1"],
				["crank", Rect2(620, 140, 200, 220), "tap"],
				["organ", Rect2(160, 400, 660, 60), "tap"],
			]
		# --- Detention
		"SC1":
			list = [
				["abacus", Rect2(64, 170, 120, 200), "go:scabacus"],
				["board", Rect2(200, 30, 420, 250), "go:scboard"],
				["clock", Rect2(650, 30, 110, 120), "go:scclock"],
				["chart", Rect2(780, 30, 110, 120), "tap"],
				["map", Rect2(650, 170, 240, 200), "go:scmap"],
			]
		"SC2":
			list = [
				["shelf", Rect2(70, 40, 230, 160), "go:scshelf"],
				["pegs", Rect2(320, 40, 280, 150), "go:scpegs"],
				["desks", Rect2(70, 220, 530, 150), "go:scdesks"],
				["door", Rect2(640, 40, 150, 330), "tap"],
			]
			if not "got_lost" in flags:
				list.append(["lostbox", Rect2(810, 260, 85, 110), "tap"])
		"SC3":
			list = [
				["photo", Rect2(64, 40, 160, 140), "go:scphoto"],
				["tasks", Rect2(250, 40, 150, 140), "go:sctasks"],
				["register", Rect2(240, 220, 180, 90), "go:scregister"],
				["drawer", Rect2(240, 315, 180, 55), "tap"],
				["harmonium", Rect2(440, 170, 200, 200), "go:scharmonium"],
				["globe", Rect2(660, 190, 110, 180), "go:scglobe"],
				["bellrope", Rect2(800, 40, 90, 330), "go:scbell"],
			]
		"SC4":
			list = [
				["shelves" if "cupboard_open" in flags else "cupboard", Rect2(64, 40, 170, 330), "tap"],
				["window", Rect2(260, 40, 240, 160), "go:scwindow"],
				["plant" if "got_key" in flags else "pot", Rect2(270, 200, 90, 80), "tap"],
			]
			if not "got_can" in flags:
				list.append(["can", Rect2(380, 300, 90, 70), "tap"])
			list.append(["hutch", Rect2(520, 230, 200, 140), "go:schutch"])
			list.append(["stove", Rect2(740, 120, 150, 250), "go:scstove"])
		"scboard":
			list = [["board", Rect2(80, 20, 800, 440), "tap"]]
		"scabacus":
			for i in range(3):
				list.append_array(_updown("abacus", i, 300 + i * 180.0, 230))
		"scclock":
			if not "wound" in flags:
				list = [["clock", Rect2(240, 20, 480, 440), "tap"]]
			else:
				list = _updown("clock", 0, 140, 230) + _updown("clock", 1, 820, 230)
		"scmap":
			if not "pinned" in flags:
				list = [["map", Rect2(80, 20, 800, 440), "tap"]]
			else:
				for i in range(3):
					list.append_array(_updown("route", i, 300 + i * 180.0, 300))
		"scdesks":
			for i in range(5):
				list.append(["card%d" % i, Rect2(70 + i * 170.0, 110, 140, 90), "cmd:turn seats %d +1" % i])
			list.append(["inkwells", Rect2(70, 240, 820, 60), "tap"])
			if "seats_ok" in flags:
				list.append(["letter", Rect2(580, 320, 140, 100), "go:scletter"])
		"scletter":
			list = [["letter", Rect2(140, 20, 680, 440), "tap"]]
		"scshelf":
			for i in range(5):
				list.append(["book%d" % i, Rect2(180 + i * 125.0, 70, 105, 320), "cmd:turn books %d +1" % i])
		"scpegs":
			for i in range(5):
				list.append(["peg%d" % i, Rect2(100 + i * 160.0, 80, 130, 320), "tap"])
		"sctasks":
			list = [["tasks", Rect2(140, 20, 680, 440), "tap"]]
		"scregister":
			list = [["register", Rect2(80, 20, 800, 440), "tap"]]
		"scharmonium":
			for i in range(8):
				list.append(["key%d" % i, Rect2(120 + i * 92.0, 260, 86, 190), "cmd:key %d" % i])
			list.append(["harmonium", Rect2(250, 20, 460, 200), "tap"])
		"scglobe":
			list = _updown("globe", 0, 760, 230)
			list.append(["globe", Rect2(140, 40, 400, 400), "tap"])
		"scbell":
			list = [
				["short", Rect2(180, 260, 260, 170), "cmd:ring 0"],
				["long", Rect2(520, 260, 260, 170), "cmd:ring 1"],
				["bellrope", Rect2(180, 20, 600, 210), "tap"],
			]
		"scphoto":
			if "photo_ok" in flags:
				list = [["frame", Rect2(300, 60, 360, 360), "tap"]]
			else:
				for i in range(9):
					list.append(["tile%d" % i, Rect2(300 + (i % 3) * 120.0, 60 + (i / 3) * 120.0, 116, 116), "cmd:slide %d" % i])
				list.append(["photo", Rect2(720, 60, 180, 360), "tap"])
		"scwindow":
			if int(st.get("talk", [0])[0]) != 0:
				list = _talk(st, art, "janitor")
			else:
				list = [["pump", Rect2(80, 200, 220, 240), "tap"], ["church", Rect2(640, 20, 240, 240), "tap"]]
				list.append(["janitor" if "lit" in flags else "window", Rect2(340, 120, 260, 320), "cmd:call" if "lit" in flags else "tap"])
		"schutch":
			list = [["hutch", Rect2(100, 60, 480, 360), "tap"], ["straw", Rect2(620, 300, 260, 130), "tap"]]
		"scstove":
			list = _updown("damper", 0, 780, 230)
			list.append(["stove", Rect2(100, 40, 460, 400), "tap"])
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var none := Vector4.ZERO
	var place := view
	while PARENT.has(place):
		place = PARENT[place]
	var close := view != place
	if place in RINGS[0]:
		# Sunshine through green glass.
		var dark := 0.02 if close else 0.05
		if place == "AV3" and not close:
			dark = 0.05 + 0.08 * int(st.get("shade", [0])[0])
		return {"dark": dark, "warm": [Vector4(480, -40, 700, 0.6)], "cold": none, "tint": Vector3(0.0, 0.05, 0.0)}
	if place in RINGS[1]:
		# Night, neon and bulbs.
		return {"dark": 0.12 if close else 0.32, "warm": [Vector4(480, 160, 520, 1.0)], "cold": Vector4(200, 100, 380, 0.6), "tint": Vector3(0.05, 0.0, 0.08)}
	# A warm afternoon in the classroom.
	return {"dark": 0.04 if close else 0.1, "warm": [Vector4(380, 80, 640, 0.9)], "cold": none, "tint": Vector3(0.08, 0.05, 0.0)}
