## Col Sidereal: its views, close-ups, hotspots and light (see views.gd for
## the format). Rectangles match the drawings in art_obs.gd.
class_name ObsViews
extends RefCounted

const STUDY := ["S1", "S2", "S3"]
const DOME := ["D1", "D2", "D3"]
const PARENT := {
	"D1": "S2", "D2": "S2", "D3": "S2",
	"door": "S1", "clocks": "S1", "notes": "S1", "plani": "S1", "drawer": "S1",
	"books": "S2", "atlas": "S2", "cabinet": "S2",
	"skymap": "S3", "board": "S3",
	"scope": "D1", "balance": "scope", "plate": "scope",
	"orrery": "D3", "box": "D3",
}


static func has(view: String) -> bool:
	return view in STUDY or PARENT.has(view)


static func _wheels(lock: String, count: int, x0: float, y0: float, gap: float = 80.0) -> Array:
	var spots := []
	for i in range(count):
		var cx := x0 + i * gap
		spots.append(["%s_up%d" % [lock, i], Rect2(cx - 38, y0 - 68, 76, 58), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_digit%d" % [lock, i], Rect2(cx - 38, y0 - 10, 76, 86), "cmd:dial %s %d +1" % [lock, i]])
		spots.append(["%s_down%d" % [lock, i], Rect2(cx - 38, y0 + 76, 76, 64), "cmd:dial %s %d -1" % [lock, i]])
	return spots


static func spots(view: String, st: Dictionary) -> Array:
	var flags: Array = st.get("flags", [])
	var list := []
	match view:
		"S1":
			list = [
				["door", Rect2(40, 104, 134, 270), "go:door"],
				["clocks", Rect2(226, 34, 228, 140), "go:clocks"],
				["note", Rect2(514, 98, 124, 66), "tap"],
				["notebook", Rect2(494, 268, 102, 32), "go:notes"],
				["plani", Rect2(614, 268, 94, 32), "go:plani"],
				["lamp", Rect2(722, 244, 70, 56), "tap"],
				["drawer", Rect2(598, 312, 166, 60), "tap" if "drawer_open" in flags else "go:drawer"],
			]
		"S2":
			list = [
				["shelf", Rect2(104, 170, 272, 98), "go:books"],
				["books", Rect2(56, 56, 372, 322), "tap"],
				["atlas", Rect2(458, 240, 144, 84), "go:atlas" if "atlas_open" in flags else "tap"],
				["cabinet", Rect2(640, 150, 160, 226), "tap" if "cabinet_open" in flags else "go:cabinet"],
				["gate", Rect2(832, 40, 124, 336), "go:D1" if "gate_open" in flags else "tap"],
			]
		"S3":
			list = [
				["skymap", Rect2(70, 44, 500, 268), "go:skymap"],
				["board", Rect2(640, 96, 250, 210), "go:board"],
				["globe", Rect2(630, 284, 84, 106), "tap"],
			]
		"D1":
			list = [["scope", Rect2(430, 150, 250, 250), "go:scope"], ["plaques", Rect2(100, 220, 250, 90), "tap"]]
		"D2":
			list = [
				["dome_left", Rect2(346, 200, 72, 72), "cmd:dome -1"],
				["dome_right", Rect2(542, 200, 72, 72), "cmd:dome +1"],
				["wheel", Rect2(424, 178, 112, 200), "tap"],
				["plaques", Rect2(160, 220, 84, 90), "tap"],
			]
		"D3":
			list = [
				["orrery", Rect2(540, 196, 190, 196), "go:orrery"],
				["box", Rect2(790, 130, 120, 100), "go:box"],
				["plaques", Rect2(60, 220, 380, 90), "tap"],
			]
		"notes":
			list = [["notebook", Rect2(110, 22, 740, 430), "tap"]]
		"drawer":
			if "drawer_open" in flags:
				list = [["drawer", Rect2(190, 90, 580, 300), "tap"]]
			else:
				list = _wheels("drawer", 3, 380, 210, 100.0)
		"cabinet":
			if "cabinet_open" in flags:
				list = [["cabinet", Rect2(230, 60, 500, 360), "tap"]]
			else:
				list = _wheels("cabinet", 4, 360, 262)
		"box":
			if "box_open" in flags:
				list = [["box", Rect2(230, 60, 500, 360), "tap"]]
			else:
				list = _wheels("box", 4, 360, 250)
		"door":
			list = _wheels("door", 4, 360, 262)
		"board":
			list = [["fuse_slot", Rect2(410, 52, 140, 64), "tap"]]
			for k in range(6):
				list.append(["lamp%d" % k, Rect2(150 + k * 116.0, 160, 80, 240), "cmd:lamp %d" % k])
		"plani":
			list = [
				["plani_left", Rect2(112, 192, 112, 92), "cmd:plani -1"],
				["plani_right", Rect2(736, 192, 112, 92), "cmd:plani +1"],
			]
		"orrery":
			for k in range(3):
				var y := 96.0 + k * 96.0
				list.append(["planet%d_back" % k, Rect2(686, y - 6, 84, 72), "cmd:planet %d -1" % k])
				list.append(["planet%d_on" % k, Rect2(772, y - 6, 84, 72), "cmd:planet %d +1" % k])
			list.append(["orrery_drawer", Rect2(620, 380, 240, 72), "tap"])
		"scope":
			list = [
				["eyepiece", Rect2(90, 70, 180, 110), "tap"],
				["camera", Rect2(270, 14, 140, 60), "go:plate" if "exposed" in flags else "tap"],
				["ra_up", Rect2(266, 226, 128, 58), "cmd:ra +1"],
				["ra_down", Rect2(266, 364, 128, 58), "cmd:ra -1"],
				["dec_up", Rect2(456, 226, 128, 58), "cmd:dec +1"],
				["dec_down", Rect2(456, 364, 128, 58), "cmd:dec -1"],
				["bar", Rect2(590, 170, 310, 210), "go:balance"],
			]
		"balance":
			for k in range(5):
				list.append(["weight%d" % k, Rect2(210 + k * 115.0, 280, 84, 134), "cmd:weight %d" % k])
			list.append(["bar", Rect2(60, 60, 840, 210), "tap"])
	return list


static func lights(view: String, st: Dictionary) -> Dictionary:
	var tint := Vector3(0.03, 0.03, 0.1)
	var none := Vector4.ZERO
	match view:
		"S1":
			return {"dark": 0.52, "warm": [Vector4(750, 262, 460, 1.0)], "cold": none, "tint": tint}
		"S2":
			return {"dark": 0.5, "warm": [Vector4(330, 210, 640, 0.85)], "cold": none, "tint": tint}
		"S3":
			return {"dark": 0.5, "warm": [Vector4(480, 200, 640, 0.8)], "cold": none, "tint": tint}
	if view in DOME:
		var cold := Vector4(480, 200, 760, 0.45)
		var lit := int(st.get("lit", -1))
		if lit >= 0 and lit < ArtObs.PLAQUES.size() and ArtObs.PLAQUES[lit][0] == view:
			cold = Vector4(ArtObs.PLAQUES[lit][1], ArtObs.PLAQUE_Y, 300, 1.0)
		return {"dark": 0.56, "warm": [Vector4(480, 430, 420, 0.4)], "cold": cold, "tint": tint}
	return {"dark": 0.3, "warm": [Vector4(480, 236, 640, 1.0)], "cold": none, "tint": tint}
