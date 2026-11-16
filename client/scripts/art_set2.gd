## Draws the rooms of the second set on top of ArtObs: The Orangery (G1, G2),
## Curtain Call (T1 to T3) and The Grandmaster's Study (C1 to C3), with their
## close-ups. Hotspots are in views_set2.gd.
class_name ArtSet2
extends ArtObs

const PAINT := {
	"red": Color("d0483c"), "yellow": Color("e8c23a"), "blue": Color("3b6fc0"), "white": Color("f0efe6"),
	"violet": Color("9a5fd0"), "orange": Color("e08a34"), "green": Color("4fa85a"), "magenta": Color("d44fb0"),
	"cyan": Color("3fc0d8"),
}
const LEAF := Color("4f8a3a")
const LEAF_D := Color("3a6a2c")
const TERRA := Color("b5673f")
const GLASS_FRAME := Color("e9e4d4")


func draw_view(view: String) -> void:
	match view:
		"G1": _g1()
		"G2": _g2()
		"gcab": _gcab()
		"sundial": _sundial()
		"pipes": _pipes()
		"pond": _pond()
		"gdoor": _gdoor()
		"T1": _t1()
		"T2": _t2()
		"T3": _t3()
		"tdesk": _tdesk()
		"ttrunk": _ttrunk()
		"sheet": _callsheet()
		"rack": _rack()
		"masks": _masks()
		"poster": _poster()
		"mirror": _mirror()
		"tdoor": _tdoor()
		"C1": _c1()
		"C2": _c2()
		"C3": _c3()
		"travel": _travel()
		"cdrawer": _cdrawer()
		"csheet": _csheet()
		"shelf": _shelf()
		"csafe": _csafe()
		"cclock": _cclock()
		"tiles": _tiles()
		"mini": _mini()
		"bigboard": _bigboard()
		"chart": _chart_moves()
		_:
			super.draw_view(view)
			return
	home()


func paint(name: String) -> Color:
	return PAINT.get(name, INK)


## Wheels of a lock of the kit: digits, or colours from `names`.
func kit_wheels(values: Array, x0: float, y0: float, names: Array = [], gap: float = 80.0) -> void:
	for i in range(values.size()):
		var cx := x0 + i * gap
		arrow_btn(cx - 30, y0 - 60, 60, 46, 0)
		rr(cx - 30, y0 - 8, 60, 80, CREAM, 6)
		if names.is_empty():
			txt(cx, y0 + 50, str(int(values[i])), 48, INK)
		else:
			rr(cx - 22, y0, 44, 64, INK, 6)
			rr(cx - 19, y0 + 3, 38, 58, paint(names[int(values[i]) % names.size()]), 5)
		arrow_btn(cx - 30, y0 + 78, 60, 46, 1)


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"wcan", "fullcan":
			at(x, y, 0.0, s)
			poly([-12, -6, 10, -6, 12, 14, -14, 14], Color("5f8f9a"))
			ln(10, -2, 20, -12, Color("5f8f9a"), 4)
			ci.draw_arc(Vector2(-2, -6), 9, PI, TAU, 10, Color("3f6a74"), 3, true)
			if name == "fullcan":
				poly([-11, -2, 10, -2, 11, 6, -12, 6], Color("7fc4e0"))
		"skey":
			super.item("key", x, y, s)
			return
		"trowel":
			at(x, y, 0.4, s)
			rr(-4, 2, 8, 16, WOOD_D, 3)
			poly([-8, 4, 8, 4, 0, -18], STEEL)
		"gnomon":
			at(x, y, 0.0, s)
			poly([-14, 12, 14, 12, -14, -14], BRASS)
		"bulb":
			at(x, y, 0.0, s)
			c(0, 4, 11, Color("c79a5f"))
			poly([-5, -4, 5, -4, 0, -16], Color("c79a5f"))
			ln(0, -14, 0, -18, LEAF, 3)
		"wheel":
			at(x, y, 0.0, s)
			ring(0, 0, 12, RED, 5)
			ln(-12, 0, 12, 0, RED, 4)
			ln(0, -12, 0, 12, RED, 4)
		"plug":
			at(x, y, 0.0, s)
			rr(-9, -6, 18, 20, IRON_D, 4)
			r(-6, -14, 4, 9, STEEL)
			r(2, -14, 4, 9, STEEL)
			ci.draw_arc(Vector2(8, 16), 10, PI, PI * 1.6, 8, IRON_D, 4, true)
		"mask":
			home()
			face("sleepy", x, y, 0.5 * s)
		"rook", "bishop", "knight", "wking":
			home()
			piece({"rook": "R", "bishop": "B", "knight": "N", "wking": "K"}[name], x, y + 12 * s, 0.9 * s, CREAM)
		"key1":
			super.item("key", x, y, s)
			return
		"key2":
			super.item("dkey", x, y, s * 1.2)
			return
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"orangery":
			r(0, 0, w, h, Color("f0b878"))
			c(w * 0.78, h * 0.4, h * 0.34, Color(1, 0.85, 0.5, 0.9))
			poly([0, h, 0, h * 0.45, w * 0.5, h * 0.08, w, h * 0.45, w, h], Color(1, 0.96, 0.85, 0.3))
			for k in range(7):
				ln(w * k / 6.0, h, w * k / 6.0, h * (0.45 - 0.37 * (1.0 - absf(k - 3) / 3.0)), GLASS_FRAME, 2)
			ln(0, h * 0.45, w * 0.5, h * 0.08, GLASS_FRAME, 2)
			ln(w, h * 0.45, w * 0.5, h * 0.08, GLASS_FRAME, 2)
			for k in range(4):
				_flower(w * 0.14 + k * w * 0.1, h * 0.96, h * 0.4, ["red", "yellow", "violet", "orange"][k], false)
		"theatre":
			r(0, 0, w, h, Color("26222e"))
			c(w * 0.3, h * 0.7, h * 0.6, Color(0.83, 0.31, 0.69, 0.35))
			c(w * 0.55, h * 0.6, h * 0.6, Color(0.25, 0.75, 0.85, 0.3))
			c(w * 0.42, h * 0.3, h * 0.5, Color(0.9, 0.76, 0.23, 0.25))
			for k in range(5):
				r(w * 0.76 + k * w * 0.05, 0, w * 0.05, h, Color("8a2a4a") if k % 2 == 0 else Color("6a1c38"))
			face("happy", w * 0.2, h * 0.5, 0.5)
			face("sad", w * 0.42, h * 0.5, 0.5)
		"chess":
			r(0, 0, w, h, Color("35503f"))
			chessboard(w * 0.5 - h * 0.9, h * 0.52, h * 0.225, 8, 2)
			piece("K", w * 0.5, h * 0.52, h / 110.0, CREAM)
			piece("N", w * 0.3, h * 0.52, h / 130.0, Color("2a2018"))
			piece("R", w * 0.7, h * 0.52, h / 130.0, Color("2a2018"))
			c(w * 0.86, h * 0.3, h * 0.5, Color(1, 0.8, 0.5, 0.18))
		_:
			super.card(room, w, h)


# === The Orangery ===================================================================

func _flower(x: float, base: float, height: float, colour: String, wilted: bool) -> void:
	if wilted:
		var bend := PackedVector2Array([Vector2(x, base), Vector2(x + 2, base - height * 0.5), Vector2(x + 16, base - height * 0.62), Vector2(x + 26, base - height * 0.4)])
		ci.draw_polyline(bend, LEAF_D.darkened(0.2), 4, true)
		c(x + 27, base - height * 0.36, 8, paint(colour).darkened(0.45))
		return
	ln(x, base, x, base - height, LEAF, 4)
	poly([x, base - height * 0.3, x - 16, base - height * 0.55, x - 4, base - height * 0.3], LEAF)
	poly([x, base - height * 0.45, x + 16, base - height * 0.7, x + 4, base - height * 0.45], LEAF)
	for k in range(6):
		c(x + cos(k * 1.047) * 8, base - height + sin(k * 1.047) * 8, 6, paint(colour))
	c(x, base - height, 5, Color("f6d860"))


func _glasshouse() -> void:
	r(0, 0, 960, 372, Color("f3bd80"))
	r(0, 0, 960, 150, Color("f7cf9a"))
	c(700, 150, 80, Color(1, 0.9, 0.6, 0.85))
	c(700, 150, 130, Color(1, 0.9, 0.6, 0.2))
	poly([0, 372, 0, 130, 480, 16, 960, 130, 960, 372], Color(1, 0.97, 0.88, 0.22))
	for k in range(9):
		var x := k * 120.0
		ln(x, 372, x, 130 - 114 * (1.0 - absf(x - 480) / 480.0), GLASS_FRAME, 6)
	ln(0, 130, 480, 16, GLASS_FRAME, 6)
	ln(960, 130, 480, 16, GLASS_FRAME, 6)
	r(0, 232, 960, 6, GLASS_FRAME)
	r(0, 372, 960, 100, Color("b08a62"))
	for i in range(8):
		for j in range(2):
			r(i * 128.0 + j * 64, 372 + j * 50, 2, 50, Color("967250"))
	r(0, 420, 960, 2, Color("967250"))
	r(0, 366, 960, 8, Color("d8d2c0"))


func _g1() -> void:
	_glasshouse()
	# The bench and its flowers; the last one hangs its head.
	rr(30, 290, 310, 12, WOOD, 3)
	r(44, 302, 10, 72, WOOD_D)
	r(316, 302, 10, 72, WOOD_D)
	var colours := ["red", "yellow", "violet", "orange"]
	for k in range(4):
		var x := 70.0 + k * 58.0
		poly([x - 16, 262, x + 16, 262, x + 11, 290, x - 11, 290], TERRA)
		_flower(x, 264, 76 + (k % 2) * 14, colours[k], false)
	poly([286, 262, 318, 262, 313, 290, 291, 290], TERRA)
	_flower(302, 264, 80, "blue", not flag("bloomed"))
	# Butterflies.
	for k in range(int(clues.get("butterflies", 0))):
		var bx := 90.0 + k * 90.0 + 26 * sin(t * 0.9 + k * 2.0)
		var by := 120.0 + 22 * sin(t * 1.3 + k * 1.4)
		var flap := absf(sin(t * 9.0 + k))
		poly([bx, by, bx - 20 * flap - 4, by - 17, bx - 17 * flap - 4, by + 12], Color("d0483c"))
		poly([bx, by, bx + 20 * flap + 4, by - 17, bx + 17 * flap + 4, by + 12], Color("d0483c"))
		ln(bx, by - 9, bx, by + 10, INK, 3)
	# The watering can.
	if not flag("got_can"):
		item("wcan", 386, 352, 2.0)
	# The big pot.
	poly([430, 300, 546, 300, 530, 382, 446, 382], TERRA)
	rr(424, 290, 128, 16, TERRA.lightened(0.1), 4)
	if flag("dug"):
		rr(446, 288, 84, 10, Color("4a3220"), 5)
	if flag("planted") and not flag("grown"):
		poly([484, 288, 488, 270, 492, 288], LEAF)
	if flag("grown"):
		ln(488, 290, 488, 60, LEAF, 6)
		var blossoms: Array = clues.get("blossoms", [])
		for k in range(blossoms.size()):
			var by2 := 78.0 + k * 54.0
			var side := -1.0 if k % 2 == 0 else 1.0
			ln(488, by2 + 12, 488 + side * 20, by2, LEAF, 4)
			for p in range(6):
				c(488 + side * 22 + cos(p * 1.047) * 10, by2 + sin(p * 1.047) * 10, 8, paint(blossoms[k]))
			c(488 + side * 22, by2, 6, Color("f6d860"))
	# The seed cabinet.
	rr(590, 170, 190, 206, WOOD_D, 4)
	for row in range(4):
		for col in range(4):
			rr(598 + col * 45.0, 178 + row * 48.0, 40, 42, WOOD, 3)
			c(618 + col * 45.0, 199 + row * 48.0, 3, BRASS)
	if flag("cab_open"):
		rr(643, 226, 85, 90, Color("2a1c12"), 3)
	else:
		rr(650, 240, 70, 30, BRASS, 4)
	# The door.
	r(820, 104, 116, 272, GLASS_FRAME)
	r(830, 114, 96, 252, Color(1, 0.97, 0.88, 0.45))
	r(876, 114, 4, 252, GLASS_FRAME)
	rr(846, 222, 64, 36, BRASS_D, 5)
	var door: Array = st.get("door", [0, 0, 0, 0])
	var names: Array = clues.get("colours", [])
	for k in range(door.size()):
		if not names.is_empty():
			rr(851.0 + k * 14.0, 230, 11, 20, paint(names[int(door[k]) % names.size()]), 2)


func _g2() -> void:
	_glasshouse()
	# The sundial.
	poly([130, 376, 144, 300, 196, 300, 210, 376], Color("c9c2b0"))
	ci.draw_set_transform(Vector2(170, 292), 0.0, Vector2(1.0, 0.36))
	c(0, 0, 62, Color("a9a290"))
	c(0, 0, 54, Color("e4decc"))
	home()
	if flag("gnomon_on"):
		poly([170, 292, 170, 258, 196, 292], BRASS)
	# The tap on the wall.
	rr(266, 214, 14, 60, STEEL, 4)
	rr(262, 206, 44, 14, STEEL, 5)
	r(296, 216, 8, 16, STEEL)
	ring(271, 204, 10, RED, 4)
	# The pond with its fountain, lilies, fish, and the bottle.
	ci.draw_set_transform(Vector2(480, 410), 0.0, Vector2(1.0, 0.3))
	c(0, 0, 250, Color("8a8474"))
	c(0, 0, 236, Color("4f9ab8"))
	home()
	poly([462, 404, 470, 330, 490, 330, 498, 404], Color("c9c2b0"))
	rr(450, 318, 60, 14, Color("d8d2c0"), 6)
	if flag("fountain"):
		for k in [-1.0, 1.0]:
			var jet := PackedVector2Array()
			for i in range(9):
				var f := i / 8.0
				jet.append(Vector2(480 + k * 70 * f, 318 - 70 * f + 110 * f * f + 3 * sin(t * 8.0 + i)))
			ci.draw_polyline(jet, Color(0.85, 0.95, 1, 0.9), 4, true)
	var places := [[290, 404], [352, 388], [408, 414], [562, 410], [636, 392], [600, 434], [330, 432]]
	for k in range(mini(int(clues.get("lilies", 0)), places.size())):
		var lx: float = places[k][0]
		var ly: float = places[k][1]
		ci.draw_set_transform(Vector2(lx, ly), 0.0, Vector2(1.0, 0.4))
		c(0, 0, 22, LEAF)
		home()
		c(lx, ly - 4, 7, Color("f6f0f4"))
		c(lx, ly - 4, 3.5, Color("f0a0c0"))
	var fx := 480 + 90 * sin(t * 0.5)
	poly([fx - 12, 428, fx, 422, fx + 10, 428, fx, 434], Color("e8703a"))
	if not flag("got_bottle"):
		var near: bool = flag("fountain")
		var bx := 340.0 if near else 430.0
		var by := 446.0 if near else 412.0 + 2 * sin(t * 2.0)
		rr(bx - 18, by - 8, 30, 14, Color(0.7, 0.9, 0.8, 0.85), 6)
		r(bx + 10, by - 4, 10, 6, Color("8a6a3a"))
		r(bx - 10, by - 4, 14, 6, PAPER)
	# The pipe board.
	rr(560, 120, 170, 130, Color("8a9aa0"), 5)
	var valves: Array = st.get("valves", [0, 0, 0])
	for k in range(3):
		ln(590 + k * 55.0, 130, 590 + k * 55.0, 240, Color("4a6a70"), 6)
		if flag("wheel_on") or k > 0:
			ring(590 + k * 55.0, 186, 12, RED if int(valves[k]) == 1 else Color("7a3a34"), 5)
	# The shed cupboard.
	rr(780, 150, 150, 226, Color("5f7a52"), 4)
	if flag("shed_open"):
		r(790, 160, 130, 206, Color("2a2a22"))
		if not flag("got_shed"):
			item("trowel", 830, 300, 2.0)
			item("gnomon", 884, 320, 1.6)
		poly([920, 160, 950, 172, 950, 380, 920, 366], Color("4f6a44"))
	else:
		r(853, 160, 4, 206, Color("4a6340"))
		rr(842, 250, 26, 30, BRASS, 4)


func _gcab() -> void:
	board(Color("5a3f28"))
	rr(160, 30, 640, 420, WOOD_D, 8)
	if flag("cab_open"):
		rr(220, 80, 520, 330, Color("2a1c12"), 6)
		if not flag("got_cab"):
			item("bulb", 390, 250, 3.6)
			item("wheel", 590, 250, 3.4)
	else:
		# The plaque: sundial, lily, butterfly.
		rr(310, 54, 340, 90, BRASS, 5)
		ci.draw_set_transform(Vector2(374, 104), 0.0, Vector2(1.0, 0.5))
		ring(0, 0, 24, INK, 4)
		home()
		poly([374, 104, 374, 78, 392, 104], INK)
		ci.draw_set_transform(Vector2(480, 112), 0.0, Vector2(1.0, 0.45))
		c(0, 0, 30, INK)
		home()
		for k in range(5):
			var pa := PI + PI * k / 4.0
			poly([480, 106, 480 + cos(pa - 0.25) * 22, 106 + sin(pa - 0.25) * 22, 480 + cos(pa + 0.25) * 22, 106 + sin(pa + 0.25) * 22], CREAM)
		poly([586, 98, 566, 78, 568, 108], INK)
		poly([586, 98, 606, 78, 604, 108], INK)
		ln(586, 88, 586, 112, INK, 3)
		kit_wheels(st.get("cab", [0, 0, 0]), 400, 270)


func _sundial() -> void:
	board(Color("b08a62"))
	c(480, 236, 214, Color("a9a290"))
	c(480, 236, 200, Color("e4decc"))
	for h in range(1, 13):
		var a := deg_to_rad(h * 30.0) - PI / 2
		txt(480 + cos(a) * 164, 236 + sin(a) * 164 + 10, str(h), 28, INK)
		ln(480 + cos(a) * 126, 236 + sin(a) * 126, 480 + cos(a) * 140, 236 + sin(a) * 140, INK, 3)
	c(480, 236, 12, BRASS_D)
	if flag("gnomon_on"):
		var hour := float(clues.get("sun_hour", 0))
		var a2 := deg_to_rad(hour * 30.0) - PI / 2
		poly([480, 236, 480 + cos(a2) * 150, 236 + sin(a2) * 150, 480 + cos(a2 + 0.14) * 60, 236 + sin(a2 + 0.14) * 60], Color(0.15, 0.1, 0.05, 0.6))
		poly([470, 246, 490, 226, 480 + cos(a2 + PI) * 40, 236 + sin(a2 + PI) * 40], BRASS)
	else:
		r(474, 230, 12, 12, INK)


func _pipes() -> void:
	board(Color("6a7a80"))
	rr(60, 30, 840, 420, Color("8a9aa0"), 10)
	var pipe := Color("4a6a70")
	var valves: Array = st.get("valves", [0, 0, 0])
	var wet := Color("7fc4e0")
	var a_open: bool = int(valves[0]) == 1 and flag("wheel_on")
	var b_open: bool = int(valves[1]) == 1
	var c_open: bool = int(valves[2]) == 1
	# From the tap (left) through valve 0 to the junction; down through
	# valve 1 to the drain; on through valve 2 to the fountain.
	ln(100, 160, 480, 160, pipe, 22)
	ln(480, 160, 820, 160, pipe, 22)
	ln(480, 160, 480, 400, pipe, 22)
	ln(100, 160, 250, 160, wet, 10)
	if a_open:
		ln(250, 160, 480, 160, wet, 10)
		if b_open:
			ln(480, 160, 480, 400, wet, 10)
		elif c_open:
			ln(480, 160, 820, 160, wet, 10)
		else:
			ln(480, 160, 650, 160, wet, 10)
		if b_open and c_open:
			ln(480, 160, 650, 160, wet, 10)
	# Tap, drain, fountain.
	rr(70, 120, 60, 80, STEEL, 8)
	ring(100, 110, 16, RED, 6)
	rr(440, 396, 80, 30, IRON_D, 4)
	for k in range(4):
		r(450 + k * 18.0, 402, 6, 18, Color("15141f"))
	poly([800, 190, 812, 110, 836, 110, 848, 190], Color("c9c2b0"))
	rr(790, 96, 68, 16, Color("d8d2c0"), 6)
	var spots := [[250, 160], [480, 290], [650, 160]]
	for k in range(3):
		var x: float = spots[k][0]
		var y: float = spots[k][1]
		c(x, y, 42, IRON_D)
		if k == 0 and not flag("wheel_on"):
			r(x - 8, y - 8, 16, 16, STEEL)
			continue
		var open: bool = int(valves[k]) == 1
		var col := RED if open else Color("7a3a34")
		ring(x, y, 30, col, 9)
		var turn := 0.0 if open else PI / 4
		for s in range(2):
			ln(x - cos(turn + s * PI / 2) * 30, y - sin(turn + s * PI / 2) * 30, x + cos(turn + s * PI / 2) * 30, y + sin(turn + s * PI / 2) * 30, col, 7)


func _pond() -> void:
	board(Color("4f9ab8"))
	for k in range(6):
		ci.draw_arc(Vector2(480, 236), 60.0 + k * 50.0 + 8 * sin(t + k), 0, TAU, 48, Color(1, 1, 1, 0.08), 3, true)
	if flag("got_bottle"):
		# The note from the bottle: the flower, read from the bottom up.
		rr(300, 40, 360, 400, PAPER, 6)
		ln(430, 380, 430, 110, LEAF, 8)
		for k in range(4):
			var side := -1.0 if k % 2 == 0 else 1.0
			ring(430 + side * 40, 130.0 + k * 66.0, 20, INK, 4)
			ln(430, 142.0 + k * 66.0, 430 + side * 22, 134.0 + k * 66.0, LEAF, 5)
		ln(560, 370, 560, 130, RED, 8)
		poly([560, 100, 540, 140, 580, 140], RED)
	else:
		rr(380, 200, 180, 70, Color(0.7, 0.9, 0.8, 0.85), 30)
		r(552, 220, 40, 30, Color("8a6a3a"))
		r(420, 216, 90, 38, PAPER)


func _gdoor() -> void:
	board(Color("b08a62"))
	rr(200, 20, 560, 440, GLASS_FRAME, 8)
	rr(220, 40, 520, 400, Color(1, 0.97, 0.88, 0.5), 6)
	rr(300, 130, 360, 250, BRASS_D, 12)
	# A flower marks what opens it.
	_flower(480, 124, 60, "white", false)
	kit_wheels(st.get("door", [0, 0, 0, 0]), 360, 240, clues.get("colours", []))


# === Curtain Call ====================================================================

const STAGE_BACK := Color("2c2836")
const STAGE_BACK_D := Color("221f2b")
const STAGE_FLOOR := Color("4a4252")
const VELVET := Color("8a2a4a")
const VELVET_D := Color("6a1c38")


## A theatre mask, about 80 px high at s = 1.
func face(expr: String, x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(s, s * 1.25))
	c(0, 0, 30, Color("ece2c8"))
	at(x, y, 0.0, s)
	var ink := INK
	match expr:
		"happy":
			ci.draw_arc(Vector2(-11, -8), 6, PI, TAU, 8, ink, 3.5, true)
			ci.draw_arc(Vector2(11, -8), 6, PI, TAU, 8, ink, 3.5, true)
			ci.draw_arc(Vector2(0, 6), 14, 0.2, PI - 0.2, 12, ink, 4, true)
		"sad":
			ln(-16, -12, -6, -8, ink, 3.5)
			ln(16, -12, 6, -8, ink, 3.5)
			ci.draw_arc(Vector2(0, 24), 14, PI + 0.3, TAU - 0.3, 12, ink, 4, true)
		"angry":
			ln(-17, -16, -5, -9, ink, 4)
			ln(17, -16, 5, -9, ink, 4)
			c(-10, -4, 3, ink)
			c(10, -4, 3, ink)
			ln(-10, 16, 10, 16, ink, 4)
		"surprised":
			ring(-10, -8, 6, ink, 3)
			ring(10, -8, 6, ink, 3)
			ring(0, 15, 8, ink, 3.5)
		_:
			ln(-16, -7, -5, -7, ink, 3.5)
			ln(5, -7, 16, -7, ink, 3.5)
			ln(-5, 15, 5, 15, ink, 3.5)
			txt(26, -20, "z", 16, ink)
	home()


func _stage_room(curtain: bool) -> void:
	r(0, 0, 960, 372, STAGE_BACK)
	for i in range(17):
		r(i * 60.0, 0, 3, 372, STAGE_BACK_D)
	r(0, 372, 960, 100, STAGE_FLOOR)
	for i in range(9):
		ln(i * 120 - 20, 372, i * 150 - 150, 472, STAGE_FLOOR.darkened(0.2), 2)
	c(200, 320, 280, Color(0.83, 0.31, 0.69, 0.10))
	c(720, 180, 300, Color(0.25, 0.75, 0.85, 0.08))
	c(480, 440, 240, Color(0.9, 0.76, 0.23, 0.07))
	if curtain:
		for k in range(4):
			r(880 + k * 20.0, 0, 20, 400, VELVET if k % 2 == 0 else VELVET_D)


func _costume(x: float, y: float, colour: String, tag: int, s: float) -> void:
	ln(x, y - 14 * s, x, y, STEEL, 2 * s)
	poly([x - 6 * s, y, x + 6 * s, y, x + 26 * s, y + 20 * s, x + 20 * s, y + 130 * s, x - 20 * s, y + 130 * s, x - 26 * s, y + 20 * s], paint(colour))
	poly([x - 6 * s, y, x + 6 * s, y, x, y + 22 * s], paint(colour).darkened(0.25))
	if tag >= 0:
		rr(x + 6 * s, y + 46 * s, 22 * s, 26 * s, PAPER, 2)
		txt(x + 17 * s, y + 66 * s, str(tag), int(18 * s), INK)


func _t1() -> void:
	_stage_room(true)
	# Ropes, sandbags and the winch.
	for k in range(4):
		ln(40 + k * 26.0, 0, 40 + k * 26.0, 150 + k * 22.0, Color("c8a66a"), 4)
		rr(30 + k * 26.0, 150 + k * 22.0, 20, 34, Color("8a7a5a"), 7)
	rr(40, 310, 86, 70, IRON_D, 6)
	c(83, 345, 22, STEEL)
	if flag("bar_down"):
		ln(83, 345, 108, 320, STEEL, 6)
		c(108, 320, 7, WOOD_D)
	else:
		r(78, 340, 10, 10, CREAM)
	# The costume rack.
	ln(180, 104, 430, 104, STEEL, 5)
	ln(186, 104, 186, 380, STEEL, 5)
	ln(424, 104, 424, 380, STEEL, 5)
	var costumes: Array = clues.get("costumes", [])
	for i in range(costumes.size()):
		_costume(220.0 + i * 44.0, 118, costumes[i]["colour"], -1, 1.0)
	# The call sheet on the wall.
	rr(470, 120, 90, 110, PAPER, 2)
	var cues: Array = clues.get("cues", [])
	for i in range(cues.size()):
		c(515, 146.0 + i * 30.0, 10, paint(cues[i]))
	# The props table.
	rr(460, 296, 190, 14, WOOD, 3)
	r(472, 310, 12, 70, WOOD_D)
	r(626, 310, 12, 70, WOOD_D)
	c(500, 282, 14, Color("d8b04e"))
	rr(530, 276, 40, 20, RED, 3)
	if not flag("got_plug"):
		item("plug", 610, 280, 1.3)
	# The trunk.
	rr(690, 310, 170, 76, Color("5a4630"), 6)
	if flag("trunk_open"):
		rr(690, 282, 170, 30, Color("15141f"), 4)
	else:
		rr(686, 296, 178, 24, Color("463624"), 8)
		rr(756, 306, 38, 26, BRASS, 4)


## The centre of a cell of the stage's three by three.
func stage_cell(col: int, row: int) -> Vector2:
	return Vector2(330 + col * 150 + (row - 1) * (col - 1) * 14, 392 + row * 28)


func _t2() -> void:
	_stage_room(false)
	var mix: String = st.get("mix", "")
	# The backdrop: three numbers in inks that only one light shows.
	rr(120, 36, 720, 220, Color("3a3644"), 4)
	for i in range(18):
		c(140 + fmod(i * 97.0, 680.0), 50 + fmod(i * 61.0, 190.0), 2, Color(1, 1, 1, 0.12))
	var digits: Array = clues.get("mix_digits", [])
	var spots := [[300, 170], [480, 150], [660, 180]]
	for i in range(digits.size()):
		if mix == digits[i]["colour"]:
			txt(spots[i][0], spots[i][1] + 30, str(int(digits[i]["digit"])), 110, Color(1, 1, 1, 0.92))
	if mix != "":
		r(0, 0, 960, 472, Color(paint(mix), 0.16))
	# The stage's nine places, the spot, the trap.
	for row in range(3):
		for col in range(3):
			var p := stage_cell(col, row)
			ln(p.x - 8, p.y, p.x + 8, p.y, Color(1, 1, 1, 0.25), 2)
			ln(p.x, p.y - 4, p.x, p.y + 4, Color(1, 1, 1, 0.25), 2)
	var mark: Array = clues.get("mark", [0, 0])
	var trap := stage_cell(int(mark[0]), int(mark[1]))
	if flag("trap_open"):
		ci.draw_set_transform(trap, 0.0, Vector2(1.0, 0.4))
		c(0, 0, 44, Color("0a0a10"))
		home()
		poly([trap.x - 44, trap.y, trap.x + 44, trap.y, trap.x + 40, trap.y - 46, trap.x - 40, trap.y - 46], STAGE_FLOOR.darkened(0.3))
		if not flag("got_mask"):
			face("sleepy", trap.x, trap.y - 6, 0.45)
	if flag("bar_down"):
		var spot: Array = st.get("spot", [0, 0])
		var at_cell := stage_cell(int(spot[0]), int(spot[1]))
		poly([at_cell.x - 46, at_cell.y, at_cell.x + 46, at_cell.y, 500, 0, 460, 0], Color(1, 1, 0.9, 0.08))
		ci.draw_set_transform(at_cell, 0.0, Vector2(1.0, 0.4))
		c(0, 0, 50, Color(1, 1, 0.85, 0.3))
		home()
		rr(440, 0, 80, 26, IRON_D, 4)
	# The lighting desk and the ghost light.
	rr(50, 304, 150, 84, IRON_D, 6)
	var lamps: Array = st.get("lamps", [0, 0, 0])
	var names := ["red", "green", "blue"]
	for k in range(3):
		rr(66 + k * 44.0, 318, 30, 50, Color("15141f"), 4)
		rr(70 + k * 44.0, 322 if int(lamps[k]) == 1 and flag("desk_on") else 344, 22, 20, paint(names[k]), 3)
	ln(900, 388, 900, 290, STEEL, 4)
	c(900, 282, 10, Color("fff1a8"))
	rr(884, 386, 32, 6, STEEL, 2)


func _t3() -> void:
	_stage_room(false)
	# The dressing mirror.
	rr(80, 76, 270, 260, WOOD_D, 8)
	rr(104, 100, 222, 212, Color("9fb4c4") if flag("mirror_lit") else Color("4a5560"), 4)
	var bulbs: Array = st.get("bulbs", [0, 0, 0, 0, 0, 0])
	for k in range(bulbs.size()):
		var p := _bulb_xy(k, 215, 206, 126, 118)
		c(p.x, p.y, 9, Color("fff1a8") if int(bulbs[k]) == 1 else Color("3a3440"))
	rr(100, 340, 230, 12, WOOD, 3)
	# The masks.
	rr(400, 84, 290, 150, Color("3a3644"), 6)
	var masks: Array = clues.get("masks", [])
	for i in range(masks.size()):
		if i == masks.size() - 1 and not flag("mask_on"):
			ring(430.0 + i * 57.0, 160, 20, Color(1, 1, 1, 0.15), 2)
		else:
			face(masks[i], 430.0 + i * 57.0, 160, 0.62)
	# The poster.
	rr(720, 84, 90, 150, PAPER, 2)
	for k in range(4):
		c(765, 108.0 + k * 34.0, 10, INK)
	# The stage door.
	r(830, 104, 116, 272, Color("3a4a5a"))
	r(840, 114, 96, 252, Color("4a5f74"))
	rr(858, 220, 60, 40, IRON_D, 5)
	c(888, 276, 6, BRASS if flag("key_in") else IRON_D)
	# A chair.
	rr(520, 300, 70, 10, WOOD, 3)
	r(526, 250, 8, 130, WOOD_D)
	r(578, 310, 8, 70, WOOD_D)


func _bulb_xy(k: int, cx: float, cy: float, rx: float, ry: float) -> Vector2:
	var a := TAU * k / 6.0 - PI / 2
	return Vector2(cx + cos(a) * rx, cy + sin(a) * ry)


func _tdesk() -> void:
	board(Color("26222e"))
	rr(60, 30, 840, 420, IRON_D, 12)
	var on: bool = flag("desk_on")
	# Three lamps: red, green, blue.
	var lamps: Array = st.get("lamps", [0, 0, 0])
	var names := ["red", "green", "blue"]
	for k in range(3):
		var x := 150.0 + k * 100.0
		c(x, 110, 30, paint(names[k]) if on and int(lamps[k]) == 1 else paint(names[k]).darkened(0.7))
		rr(x - 26, 170, 52, 190, Color("15141f"), 6)
		rr(x - 20, 180 if on and int(lamps[k]) == 1 else 300, 40, 50, paint(names[k]), 5)
	# What they mix to.
	var mix: String = st.get("mix", "")
	c(250, 410, 22, paint(mix) if mix != "" else Color("15141f"))
	ring(250, 410, 22, STEEL, 3)
	# The follow spot: a three by three and four arrows.
	rr(520, 70, 300, 200, Color("15141f"), 8)
	var spot: Array = st.get("spot", [0, 0])
	for row in range(3):
		for col in range(3):
			var here: bool = flag("bar_down") and int(spot[0]) == col and int(spot[1]) == row
			c(590 + col * 80.0, 110 + row * 60.0, 16 if here else 6, Color("fff1a8") if here else STEEL)
	arrow_btn(540, 300, 64, 64, 2)
	arrow_btn(736, 300, 64, 64, 3)
	arrow_btn(638, 286, 64, 50, 0)
	arrow_btn(638, 344, 64, 50, 1)
	# Where the plug goes.
	rr(430, 380, 60, 44, Color("15141f"), 6)
	if on:
		item("plug", 460, 404, 1.4)
		c(412, 402, 7, Color("69d06a"))


func _ttrunk() -> void:
	board(Color("26222e"))
	rr(120, 60, 720, 390, Color("5a4630"), 12)
	for x in [170.0, 770.0]:
		r(x, 60, 20, 390, IRON_D)
	if flag("trunk_open"):
		rr(200, 100, 560, 320, Color("15141f"), 8)
		if not flag("got_trunk"):
			item("crank", 290, 260, 3.2)
		# The prompt book: the stage from above, the audience below.
		rr(420, 120, 300, 280, PAPER, 4)
		var mark: Array = clues.get("mark", [0, 0])
		for row in range(3):
			for col in range(3):
				var px := 500.0 + col * 70.0
				var py := 170.0 + row * 60.0
				ring(px, py, 6, INK.lightened(0.4), 2)
				if int(mark[0]) == col and int(mark[1]) == row:
					ln(px - 16, py - 16, px + 16, py + 16, RED, 6)
					ln(px + 16, py - 16, px - 16, py + 16, RED, 6)
		ln(450, 330, 690, 330, INK, 3)
		for k in range(7):
			ci.draw_arc(Vector2(468 + k * 34.0, 372), 11, PI, TAU, 8, INK, 3, true)
	else:
		rr(100, 40, 760, 90, Color("463624"), 30)
		# The call sheet's sign on the lock: three lights.
		rr(380, 150, 200, 44, BRASS, 5)
		for k in range(3):
			ring(430 + k * 50.0, 172, 11, INK, 3)
		kit_wheels(st.get("trunk", [0, 0, 0]), 400, 290)


func _callsheet() -> void:
	board(Color("26222e"))
	rr(300, 20, 360, 432, PAPER, 4)
	c(480, 34, 6, RED)
	var cues: Array = clues.get("cues", [])
	for i in range(cues.size()):
		var y := 110.0 + i * 120.0
		txt(360, y + 12, "%d." % (i + 1), 34, INK)
		c(500, y, 44, INK)
		c(500, y, 40, paint(cues[i]))


func _rack() -> void:
	board(Color("26222e"))
	ln(60, 70, 900, 70, STEEL, 8)
	var costumes: Array = clues.get("costumes", [])
	for i in range(costumes.size()):
		_costume(160.0 + i * 160.0, 90, costumes[i]["colour"], int(costumes[i]["digit"]), 2.4)


func _masks() -> void:
	board(Color("26222e"))
	rr(60, 60, 840, 300, Color("3a3644"), 10)
	var masks: Array = clues.get("masks", [])
	var pressed: Array = st.get("pressed", [0, 0, 0, 0])
	for i in range(masks.size()):
		var x := 150.0 + i * 165.0
		if i == masks.size() - 1 and not flag("mask_on"):
			ring(x, 200, 62, Color(1, 1, 1, 0.2), 3)
			c(x, 130, 6, IRON_D)
		else:
			if (i + 1.0) in pressed and not flag("masks_open"):
				c(x, 200, 88, Color(1, 0.95, 0.7, 0.18))
			face(masks[i], x, 200, 2.0)
	# The niche under the masks.
	rr(380, 384, 200, 70, IRON_D, 6)
	if flag("masks_open"):
		rr(390, 392, 180, 54, Color("0a0a10"), 4)
		if not flag("got_key"):
			item("key", 480, 420, 2.0)
	for k in range(4):
		c(420.0 + k * 40.0, 372, 6, AMBER if int(pressed[k]) != 0 or flag("masks_open") else Color("15141f"))


func _poster() -> void:
	board(Color("26222e"))
	rr(160, 20, 640, 432, PAPER, 4)
	rr(180, 40, 600, 392, VELVET, 4)
	var acts: Array = clues.get("acts", [])
	var numerals := ["I", "II", "III", "IV"]
	for i in range(acts.size()):
		var x := 255.0 + i * 150.0
		txt(x, 120, numerals[i], 44, CREAM)
		face(acts[i], x, 260, 1.5)


func _mirror() -> void:
	board(Color("26222e"))
	rr(150, 20, 660, 432, WOOD_D, 12)
	var lit: bool = flag("mirror_lit")
	rr(230, 90, 500, 292, Color("b9cddc") if lit else Color("4a5560"), 6)
	var bulbs: Array = st.get("bulbs", [0, 0, 0, 0, 0, 0])
	for k in range(bulbs.size()):
		var p := _bulb_xy(k, 480, 236, 290, 180)
		var on: bool = int(bulbs[k]) == 1
		if on:
			c(p.x, p.y, 40, Color(1, 0.95, 0.6, 0.25))
		c(p.x, p.y, 26, Color("fff1a8") if on else Color("3a3440"))
		ring(p.x, p.y, 26, IRON_D, 4)
		# Each switch flips its bulb and the next one round.
		var q := _bulb_xy(k, 480, 236, 216, 120)
		rr(q.x - 16, q.y - 16, 32, 32, IRON_D, 6)
		c(q.x, q.y, 8, CREAM)
	if lit:
		var dots: Array = clues.get("dots", [])
		for i in range(dots.size()):
			c(360.0 + i * 80.0, 236, 24, INK)
			c(360.0 + i * 80.0, 236, 21, paint(dots[i]))
	ci.draw_arc(Vector2(480, 236), 150, -0.6, 0.9, 16, Color(1, 1, 1, 0.12), 6, true)


func _tdoor() -> void:
	board(Color("26222e"))
	rr(160, 20, 640, 440, Color("3a4a5a"), 8)
	rr(180, 40, 600, 400, Color("4a5f74"), 6)
	rr(290, 110, 380, 280, IRON_D, 12)
	# A costume hanger marks what opens it.
	ci.draw_arc(Vector2(480, 80), 10, PI, TAU + 1.2, 10, CREAM, 3, true)
	poly([480, 88, 530, 104, 430, 104], CREAM)
	c(716, 250, 22, BRASS_D)
	c(716, 250, 9, BRASS if flag("key_in") else Color("15141f"))
	kit_wheels(st.get("door", [0, 0, 0, 0]), 360, 240)


# === The Grandmaster's Study ==========================================================

const STUDY_WALL := Color("3f5a4a")
const STUDY_WALL_D := Color("35503f")
const SQ_LIGHT := Color("e8dcc0")
const SQ_DARK := Color("6a4a30")
const EBONY := Color("2a2018")
const FILES := "abcdefgh"


## A board with a1 at the bottom left; `top` is its upper edge.
func chessboard(x: float, top: float, cell: float, files: int, ranks: int, labels: bool = false) -> void:
	r(x - 6, top - 6, files * cell + 12, ranks * cell + 12, EBONY)
	for rank in range(ranks):
		for file in range(files):
			r(x + file * cell, top + (ranks - 1 - rank) * cell, cell, cell, SQ_DARK if (file + rank) % 2 == 0 else SQ_LIGHT)
	if labels:
		for file in range(files):
			txt(x + (file + 0.5) * cell, top + ranks * cell + 26, FILES[file], 20, CREAM)
		for rank in range(ranks):
			txt(x - 22, top + (ranks - 0.5 - rank) * cell + 7, str(rank + 1), 20, CREAM)


## The foot of a piece on a square (pieces stand on their base line).
func square_xy(x: float, top: float, cell: float, ranks: int, file: float, rank: float) -> Vector2:
	return Vector2(x + (file + 0.5) * cell, top + (ranks - rank) * cell - cell * 0.14)


## A chess piece standing on (x, y); about 40 px high at s = 1. Light
## pieces get a dark outline, dark ones a light one.
func piece(kind: String, x: float, y: float, s: float, col: Color) -> void:
	var edge := EBONY if col.get_luminance() > 0.5 else CREAM
	for pass_no in range(2):
		var grow := 2.2 if pass_no == 0 else 0.0
		var paint_col := edge if pass_no == 0 else col
		ci.draw_set_transform(Vector2(x, y + grow * s * 0.6), 0.0, Vector2(s * (1.0 + grow / 13.0), s * (1.0 + grow / 24.0)))
		_piece_shape(kind, paint_col)
	if kind == "B":
		at(x, y, 0.0, s)
		ln(-2, -34, 4, -26, edge, 2)
	elif kind == "N":
		at(x, y, 0.0, s)
		c(3, -32, 1.8, edge)
	home()


func _piece_shape(kind: String, col: Color) -> void:
	rr(-12, -5, 24, 6, col, 2)
	match kind:
		"P":
			poly([-8, -5, 8, -5, 4, -20, -4, -20], col)
			c(0, -25, 7, col)
		"R":
			poly([-9, -5, 9, -5, 7, -28, -7, -28], col)
			r(-11, -36, 22, 9, col)
		"B":
			poly([-8, -5, 8, -5, 3, -20, -3, -20], col)
			poly([-7, -29, 0, -40, 7, -29, 0, -18], col)
			c(0, -29, 6.5, col)
			c(0, -42, 3, col)
		"N":
			poly([-9, -5, 9, -5, 8, -22, 12, -30, 4, -40, -4, -38, -12, -26, -4, -24, -8, -14], col)
		"Q":
			poly([-9, -5, 9, -5, 5, -24, -5, -24], col)
			poly([-11, -38, -6, -28, 0, -40, 6, -28, 11, -38, 7, -22, -7, -22], col)
			c(0, -42, 3, col)
		"K":
			poly([-9, -5, 9, -5, 5, -26, -5, -26], col)
			rr(-9, -34, 18, 10, col, 3)
			r(-2, -46, 4, 13, col)
			r(-6, -42, 12, 4, col)


func _study() -> void:
	r(0, 0, 960, 372, STUDY_WALL)
	for i in range(12):
		rr(i * 80.0 + 8, 212, 64, 150, STUDY_WALL_D, 3)
	r(0, 200, 960, 6, WOOD_D)
	r(0, 372, 960, 100, Color("6a4a30"))
	for i in range(9):
		ln(i * 120 - 20, 372, i * 150 - 150, 472, Color("553a24"), 2)
	r(0, 366, 960, 8, WOOD_D)


func _c1() -> void:
	_study()
	# The side table with the small board.
	rr(60, 300, 150, 12, WOOD, 3)
	r(128, 312, 14, 68, WOOD_D)
	chessboard(95, 262, 20, 4, 2)
	# The portrait.
	rr(380, 50, 200, 140, WOOD_D, 4)
	r(392, 62, 176, 116, Color("b9b39c"))
	c(480, 106, 22, EBONY)
	poly([440, 178, 456, 136, 504, 136, 520, 178], EBONY)
	# The table with the big board.
	rr(330, 296, 300, 14, WOOD, 3)
	r(346, 310, 14, 70, WOOD_D)
	r(600, 310, 14, 70, WOOD_D)
	poly([380, 296, 410, 256, 550, 256, 580, 296], SQ_LIGHT)
	for k in range(4):
		poly([390 + k * 48.0, 290, 414 + k * 36.0, 262, 432 + k * 36.0, 262, 414 + k * 48.0, 290], SQ_DARK)
	piece("K", 500, 280, 0.7, EBONY)
	# The fireplace with the clock on its mantel.
	rr(720, 200, 200, 176, Color("4a4038"), 4)
	r(748, 250, 144, 126, Color("14100c"))
	var f := 5.0 * sin(t * 9.0)
	poly([770, 374, 786, 330 + f, 800, 350, 818, 300 - f, 836, 346, 852, 322 + f, 870, 374], FIRE)
	rr(708, 186, 224, 16, WOOD_D, 3)
	rr(790, 130, 60, 58, WOOD, 6)
	c(820, 158, 20, CREAM)
	ln(820, 158, 820, 144, INK, 2.5)
	ln(820, 158, 830, 162, INK, 2.5)
	# An armchair.
	rr(232, 320, 80, 60, Color("7a3a34"), 10)
	rr(226, 270, 26, 110, Color("6a2e2a"), 8)


func _c2() -> void:
	_study()
	# The bookshelf: eight wide, three high.
	rr(50, 60, 420, 320, WOOD_D, 4)
	var shelf: Array = clues.get("shelf", [])
	var dull := [Color("7a2a2a"), Color("2a4a6a"), Color("8a7430"), Color("3a5a3a"), Color("5a3a5a")]
	for rank in range(shelf.size()):
		r(60, 70 + (2 - rank) * 102.0, 400, 92, Color("1c1712"))
		for file in range(8):
			rr(64 + file * 50.0, 76 + (2 - rank) * 102.0, 42, 86, dull[(file * 3 + rank * 2) % 5], 3)
	# The chart of moves.
	rr(520, 70, 150, 190, PAPER, 3)
	for k in range(6):
		piece(["K", "Q", "R", "B", "N", "P"][k], 558 + (k % 2) * 74.0, 130 + floorf(k / 2.0) * 58.0, 0.8, EBONY)
	# The trophy cabinet with its tiled panel.
	rr(720, 110, 200, 266, WOOD_D, 4)
	rr(734, 124, 172, 110, Color(0.8, 0.85, 0.9, 0.18), 3)
	for k in range(3):
		poly([760 + k * 54.0, 230, 772 + k * 54.0, 190, 796 + k * 54.0, 190, 808 + k * 54.0, 230], BRASS)
		r(778 + k * 54.0, 176, 12, 16, BRASS_D)
	for i in range(25):
		rr(748 + (i % 5) * 30.0, 246 + floorf(i / 5.0) * 24.0, 26, 20, CREAM if not flag("cab_open") else Color("15141f"), 2)


func _c3() -> void:
	_study()
	# The desk: travel board, score sheet, lamp, drawer.
	rr(100, 296, 480, 16, WOOD, 3)
	r(116, 312, 16, 68, WOOD_D)
	r(548, 312, 16, 68, WOOD_D)
	chessboard(160, 256, 10, 8, 4)
	if flag("got_drawer"):
		poly([300, 296, 308, 270, 372, 270, 380, 296], PAPER)
		for k in range(3):
			ln(318, 276 + k * 6.0, 366, 276 + k * 6.0, INK.lightened(0.3), 1.5)
	rr(486, 282, 30, 14, BRASS_D, 4)
	ln(500, 282, 500, 240, BRASS_D, 4)
	poly([474, 242, 526, 242, 516, 214, 484, 214], Color("3f8a5a"))
	if flag("drawer_open"):
		rr(384, 318, 152, 40, Color("14100c"), 3)
		rr(380, 344, 160, 26, WOOD, 3)
	else:
		rr(384, 316, 152, 34, WOOD_D, 3)
		rr(440, 322, 40, 22, BRASS, 3)
	# The door with its two locks.
	r(740, 104, 150, 272, WOOD_D)
	r(752, 116, 126, 260, WOOD)
	r(752, 240, 126, 3, WOOD_D)
	for k in range(2):
		c(852, 220 + k * 50.0, 13, BRASS_D)
		c(852, 220 + k * 50.0, 5, BRASS if flag("k1_in" if k == 0 else "k2_in") else Color("14100c"))


func _travel() -> void:
	board(Color("35503f"))
	chessboard(288, 40, 48, 8, 8, true)
	for entry in clues.get("travel", []):
		var p := square_xy(288, 40, 48, 8, float(entry[1]), float(entry[2]))
		piece(entry[0], p.x, p.y, 1.0, CREAM)


func _cdrawer() -> void:
	board(Color("35503f"))
	rr(160, 50, 640, 390, WOOD, 10)
	if flag("drawer_open"):
		rr(210, 100, 540, 290, Color("14100c"), 6)
		if not flag("got_drawer"):
			piece("R", 400, 300, 3.4, CREAM)
			rr(540, 170, 120, 160, PAPER, 3)
			for k in range(4):
				ln(556, 200 + k * 30.0, 644, 200 + k * 30.0, INK.lightened(0.3), 3)
	else:
		rr(210, 100, 540, 290, WOOD_D, 6)
		# The lock's sign: a rook and a bishop meet.
		rr(380, 112, 200, 50, BRASS, 5)
		piece("R", 430, 156, 0.9, EBONY)
		piece("B", 530, 156, 0.9, EBONY)
		ln(452, 140, 508, 140, EBONY, 3)
		var value: Array = st.get("drawer", [0, 0])
		for i in range(2):
			var cx := 430.0 + i * 100.0
			arrow_btn(cx - 34, 180, 68, 46, 0)
			rr(cx - 34, 232, 68, 84, CREAM, 6)
			txt(cx, 292, FILES[int(value[0]) % 8] if i == 0 else str(int(value[1]) + 1), 50, INK)
			arrow_btn(cx - 34, 322, 68, 46, 1)


func _csheet() -> void:
	board(Color("35503f"))
	rr(280, 20, 400, 432, PAPER, 4)
	ln(300, 70, 660, 70, INK.lightened(0.4), 2)
	var sheet: Array = clues.get("sheet", [])
	for i in range(sheet.size()):
		var y := 150.0 + i * 88.0
		txt(330, y, "%d." % (i + 1), 30, INK.lightened(0.4))
		piece(sheet[i][0], 430, y + 6, 1.5, EBONY)
		txt(560, y, "%s%d" % [FILES[int(sheet[i][1])], int(sheet[i][2]) + 1], 44, INK)


func _shelf() -> void:
	board(Color("35503f"))
	rr(100, 14, 780, 410, WOOD_D, 6)
	var shelf: Array = clues.get("shelf", [])
	var dull := [Color("7a2a2a"), Color("2a4a6a"), Color("8a7430"), Color("3a5a3a"), Color("5a3a5a")]
	for rank in range(shelf.size()):
		var y := 26.0 + (2 - rank) * 130.0
		r(150, y, 716, 122, Color("1c1712"))
		txt(126, y + 72, str(rank + 1), 26, CREAM)
		for file in range(8):
			var x := 158.0 + file * 88.0
			rr(x, y + 8, 76, 114, dull[(file * 3 + rank * 2) % 5], 4)
			c(x + 38, y + 62, 22, CREAM)
			txt(x + 38, y + 74, str(int(shelf[rank][file])), 30, INK)
	for file in range(8):
		txt(196.0 + file * 88.0, 452, FILES[file], 26, CREAM)


func _csafe() -> void:
	board(Color("35503f"))
	rr(200, 30, 560, 420, IRON, 14)
	if flag("safe_open"):
		rr(230, 60, 500, 360, IRON_D.darkened(0.3), 8)
		if not flag("got_safe"):
			piece("B", 480, 340, 4.0, CREAM)
	else:
		rr(230, 60, 500, 360, STEEL, 8)
		# A book marks what opens it.
		rr(450, 80, 60, 44, EBONY, 3)
		r(456, 86, 48, 32, PAPER)
		kit_wheels(st.get("safe", [0, 0, 0, 0]), 360, 250)


func _cclock() -> void:
	board(Color("35503f"))
	rr(240, 16, 480, 250, WOOD, 20)
	c(480, 140, 104, WOOD_D)
	c(480, 140, 94, CREAM)
	for i in range(12):
		var a := TAU * i / 12.0
		ln(480 + cos(a) * 80, 140 + sin(a) * 80, 480 + cos(a) * 90, 140 + sin(a) * 90, INK, 3)
	ln(480, 140, 480, 78, INK, 5)
	ln(480, 140, 524, 160, INK, 6)
	c(480, 140, 7, INK)
	# Five squares and a switch under each: light or dark.
	rr(120, 280, 720, 170, WOOD_D, 8)
	var squares: Array = clues.get("clock_squares", [])
	var shades: Array = st.get("shades", [0, 0, 0, 0, 0])
	for i in range(squares.size()):
		var x := 200.0 + i * 140.0
		rr(x - 44, 292, 88, 44, BRASS, 4)
		txt(x, 326, "%s%d" % [FILES[int(squares[i][0])], int(squares[i][1]) + 1], 30, INK)
		rr(x - 34, 350, 68, 68, EBONY, 6)
		rr(x - 28, 356, 56, 56, SQ_DARK if int(shades[i]) == 1 else SQ_LIGHT, 4)
	if flag("clock_open"):
		rr(740, 60, 150, 190, Color("14100c"), 6)
		if not flag("got_clock"):
			piece("N", 815, 220, 3.0, CREAM)


const TILE_X := 70.0
const TILE_Y := 46.0
const TILE := 74.0


func _tiles() -> void:
	board(Color("35503f"))
	var tiles: Array = clues.get("tiles", [])
	for row in range(tiles.size()):
		for col in range(5):
			rr(TILE_X + col * TILE + 3, TILE_Y + row * TILE + 3, TILE - 6, TILE - 6, CREAM, 6)
			txt(TILE_X + (col + 0.5) * TILE, TILE_Y + (row + 0.5) * TILE + 14, str(int(tiles[row][col])), 38, INK)
	var start: Array = clues.get("knight_start", [0, 0])
	var sx := TILE_X + (float(start[0]) + 0.5) * TILE
	var sy := TILE_Y + (float(start[1]) + 0.5) * TILE
	ring(sx, sy, 32, RED, 5)
	piece("N", sx + 22, sy + 34, 0.55, EBONY)
	# The three jumps, in order.
	var jumps: Array = clues.get("jumps", [])
	for i in range(jumps.size()):
		var x := 540.0 + i * 130.0
		rr(x - 54, 40, 108, 124, PAPER, 4)
		txt(x - 36, 66, str(i + 1), 20, INK.lightened(0.3))
		var dx := float(jumps[i][0]) * 20.0
		var dy := float(jumps[i][1]) * 20.0
		var from := Vector2(x - dx / 2, 104 - dy / 2)
		var corner := Vector2(from.x, from.y + dy) if absf(dy) > absf(dx) else Vector2(from.x + dx, from.y)
		var to := from + Vector2(dx, dy)
		c(from.x, from.y, 6, INK)
		ci.draw_line(from, corner, INK, 4, true)
		ci.draw_line(corner, to, INK, 4, true)
		var dir := (to - corner).normalized()
		var side := Vector2(-dir.y, dir.x)
		ci.draw_colored_polygon(PackedVector2Array([to + dir * 10, to + side * 8, to - side * 8]), INK)
	if flag("cab_open"):
		rr(500, 200, 400, 230, Color("14100c"), 8)
		if not flag("got_cab"):
			piece("K", 700, 400, 3.6, CREAM)
	else:
		rr(500, 200, 400, 230, WOOD_D, 8)
		kit_wheels(st.get("cabinet", [0, 0, 0, 0]), 580, 290)


const MINI_X := 312.0
const MINI_Y := 30.0
const MINI_CELL := 84.0


func _mini() -> void:
	board(Color("35503f"))
	chessboard(MINI_X, MINI_Y, MINI_CELL, 4, 4)
	for entry in clues.get("mini", []):
		var p := square_xy(MINI_X, MINI_Y, MINI_CELL, 4, float(entry[1]), float(entry[2]))
		piece(entry[0], p.x, p.y, 1.7, EBONY)
	if flag("king_safe"):
		var home_sq: Array = clues.get("king_home", [0, 0])
		var p2 := square_xy(MINI_X, MINI_Y, MINI_CELL, 4, float(home_sq[0]), float(home_sq[1]))
		piece("K", p2.x, p2.y, 1.7, CREAM)
	# The drawer under the board.
	rr(360, 392, 240, 64, WOOD_D, 6)
	if flag("king_safe"):
		rr(370, 400, 220, 48, Color("14100c"), 4)
		if not flag("got_key1"):
			item("key1", 480, 424, 1.8)
	else:
		c(480, 424, 7, BRASS)
	# What is asked: a white king.
	rr(690, 150, 150, 170, PAPER, 4)
	piece("K", 765, 290, 2.6, CREAM)


const BIG_X := 280.0
const BIG_Y := 30.0
const BIG_CELL := 50.0


func _bigboard() -> void:
	board(Color("35503f"))
	chessboard(BIG_X, BIG_Y, BIG_CELL, 8, 8, true)
	var king: Array = clues.get("black_king", [0, 0])
	var kp := square_xy(BIG_X, BIG_Y, BIG_CELL, 8, float(king[0]), float(king[1]))
	if flag("king_down"):
		ci.draw_set_transform(kp + Vector2(0, -8), 1.4, Vector2.ONE)
		piece("K", 0, 0, 1.1, EBONY)
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		rr(kp.x - 20, kp.y - 30, 40, 34, Color("14100c"), 4)
		if not flag("got_key2"):
			item("key2", kp.x, kp.y - 12, 1.0)
	else:
		piece("K", kp.x, kp.y, 1.1, EBONY)
	var marked: Array = clues.get("marked", [])
	var slots: Array = st.get("slots", [0, 0, 0])
	var kinds := ["", "R", "B", "N"]
	for i in range(marked.size()):
		var p := square_xy(BIG_X, BIG_Y, BIG_CELL, 8, float(marked[i][0]), float(marked[i][1]))
		ring(p.x, p.y - 18, 21, RED, 4)
		if int(slots[i]) > 0:
			piece(kinds[int(slots[i])], p.x, p.y, 1.1, CREAM)


func _chart_moves() -> void:
	board(Color("35503f"))
	rr(60, 14, 840, 444, PAPER, 4)
	var kinds := ["K", "Q", "R", "B", "N", "P"]
	for k in range(6):
		var x0 := 110.0 + (k % 3) * 270.0
		var y0 := 36.0 + floorf(k / 3.0) * 216.0
		for row in range(5):
			for col in range(5):
				r(x0 + col * 38.0, y0 + row * 38.0, 36, 36, Color(0, 0, 0, 0.1 if (row + col) % 2 == 0 else 0.03))
		var centre := Vector2(x0 + 95, y0 + 95)
		var dots := []
		match kinds[k]:
			"K":
				for d in [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]:
					dots.append(d)
			"N":
				for d in [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]:
					dots.append(d)
			"P":
				dots.append([0, -1])
			_:
				for d in [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, 1], [-1, -1]]:
					var straight: bool = d[0] == 0 or d[1] == 0
					if kinds[k] == "Q" or (kinds[k] == "R" and straight) or (kinds[k] == "B" and not straight):
						ln(centre.x, centre.y, centre.x + d[0] * 84, centre.y + d[1] * 84, RED, 3)
						dots.append([d[0], d[1]])
						dots.append([d[0] * 2, d[1] * 2])
		for d in dots:
			c(centre.x + d[0] * 38, centre.y + d[1] * 38, 7, RED)
		piece(kinds[k], centre.x, centre.y + 16, 0.85, EBONY)
