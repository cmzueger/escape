## Draws the rooms of the fifth set on top of ArtSet4: Lookout (E1, E2),
## Gondola 12 (Q1, Q2), Praline Works (P1, P2) and Tinker & Sons (Y1, Y2),
## with their close-ups. Hotspots are in views_set5.gd.
class_name ArtSet5
extends ArtSet4

const PLANK := Color("9a6a3c")
const PLANK_D := Color("7a5230")
const AUTUMN := Color("d9822b")
const AUTUMN_D := Color("b5521f")
const CLUB := Color("f08a24")
const RIVAL := Color("3f6fd0")
const CABIN := Color("d8dde4")
const CABIN_D := Color("aeb6c0")
const CABIN_RED := Color("c23b2e")
const ICE_SKY := Color("bcdcf2")
const SHADOW := Color(0.25, 0.32, 0.45, 0.55)
const TILE_C := Color("e9e1c8")
const TILE_G := Color("5f8a6a")
const COPPER := Color("b8673a")
const COPPER_D := Color("8a4a28")
const COCOA := Color("5a3420")
const COCOA_D := Color("3e2214")
const WRAPS := ["red", "gold", "green", "blue", "violet", "silver"]
const WRAP_COL := {"red": Color("c0392b"), "gold": Color("e8b923"), "green": Color("3e9a52"), "blue": Color("3a6fc8"), "violet": Color("8a52b8"), "silver": Color("b8bec8")}
const SHAPES := ["heart", "star", "shell", "leaf", "bean", "square"]
const XMAS_RED := Color("8e1f22")
const XMAS_RED_D := Color("6e1518")
const XMAS_GREEN := Color("2d6a3e")
const FIR := Color("2f6b3a")
const FIR_D := Color("234f2b")
const DART_NUMBERS := [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5]


func draw_view(view: String) -> void:
	match view:
		"E1": _e1()
		"E2": _e2()
		"edarts": _edarts()
		"echest": _echest()
		"ebeam": _ebeam()
		"eperi": _eperi()
		"emap": _emap()
		"ehatch": _ehatch()
		"Q1": _q1()
		"Q2": _q2()
		"qwindow": _qwindow()
		"qmap": _qmap()
		"qbag": _qbag()
		"qsill": _qsill()
		"qkit": _qkit()
		"qpanel": _qpanel()
		"P1": _p1()
		"P2": _p2()
		"psign": _psign()
		"pcards": _pcards()
		"plocker": _plocker()
		"pcab": _pcab()
		"ptray": _ptray()
		"precipe": _precipe()
		"pkettle": _pkettle()
		"Y1": _y1()
		"Y2": _y2()
		"ydrawers": _ydrawers()
		"ydoll": _ydoll()
		"ytrain": _ytrain()
		"ygifts": _ygifts()
		"ynotes": _ynotes()
		"ymaze": _ymaze()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"battery":
			at(x, y, 0.3, s)
			rr(-8, -16, 16, 32, Color("2a2a2a"), 3)
			r(-8, -16, 16, 10, Color("d8a020"))
			r(-3, -20, 6, 4, STEEL)
		"knob":
			at(x, y, 0.0, s)
			ln(-14, 8, 6, -6, STEEL, 5)
			c(10, -9, 8, RED)
			c(-14, 8, 4, IRON_D)
		"multitool":
			at(x, y, -0.4, s)
			rr(-18, -6, 36, 12, CABIN_RED, 6)
			r(-3, -3, 6, 6, CREAM)
			r(-1, -1, 2, 2, CABIN_RED)
			poly([12, -6, 26, -12, 26, -9, 14, -3], STEEL)
		"qfuse":
			at(x, y, 0.5, s)
			rr(-14, -6, 28, 12, Color(0.8, 0.9, 1.0, 0.6), 5)
			r(-16, -6, 5, 12, STEEL)
			r(11, -6, 5, 12, STEEL)
			ln(-10, 0, 10, 0, Color("6a6a6a"), 1.5)
		"windkey":
			at(x, y, 0.0, s)
			ring(-8, 0, 7, BRASS, 4)
			ring(8, 0, 7, BRASS, 4)
			r(-2, 0, 4, 18, BRASS)
		"walnut":
			at(x, y, 0.0, s)
			c(0, 0, 12, Color("a07040"))
			ln(0, -12, 0, 12, Color("6a4424"), 2)
			ln(-7, -6, -3, 6, Color("6a4424"), 1.5)
			ln(6, -7, 4, 5, Color("6a4424"), 1.5)
		"marble":
			at(x, y, 0.0, s)
			c(0, 0, 10, Color("3a7ad0"))
			c(-3, -3, 3.5, Color(1, 1, 1, 0.7))
		"star":
			home()
			_star5(x, y, 15 * s, GOLD)
		"shopkey":
			at(x, y, 0.0, s)
			ring(-10, 0, 8, Color("c0c4cc"), 4)
			r(-2, -2, 22, 4, Color("c0c4cc"))
			r(14, 2, 4, 6, Color("c0c4cc"))
			r(8, 2, 3, 5, Color("c0c4cc"))
		"torn1", "torn2", "torn3", "torn4":
			at(x, y, 0.2 * (int(name.substr(4)) - 2), s)
			poly([-14, -14, 12, -16, 16, -2, 10, 14, -12, 16, -16, 4], PAPER)
			ln(-8, -4, 8, -6, INK, 1.5)
			ln(-8, 4, 4, 3, INK, 1.5)
		"okey":
			at(x, y, 0.0, s)
			ring(-10, 0, 8, BRASS, 4)
			r(-2, -2, 22, 4, BRASS)
			r(14, 2, 4, 6, BRASS)
			c(-10, 0, 3, GOLD)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"tree":
			r(0, 0, w, h, Color("f2c27a"))
			for k in range(9):
				c(w * (0.05 + k * 0.12), h * (0.15 + (k % 3) * 0.12), h * 0.16, AUTUMN if k % 2 == 0 else AUTUMN_D)
			r(w * 0.46, h * 0.4, w * 0.08, h * 0.6, PLANK_D)
			rr(w * 0.24, h * 0.42, w * 0.52, h * 0.3, PLANK, 3)
			poly([w * 0.2, h * 0.44, w * 0.5, h * 0.22, w * 0.8, h * 0.44], AUTUMN_D)
			poly([w * 0.7, h * 0.12, w * 0.7, h * 0.3, w * 0.86, h * 0.21], CLUB)
		"gondola":
			r(0, 0, w, h, ICE_SKY)
			poly([0, h, 0, h * 0.6, w * 0.35, h * 0.3, w * 0.7, h * 0.65, w, h * 0.45, w, h], SNOW)
			ln(0, h * 0.1, w, h * 0.35, IRON_D, 2)
			ln(w * 0.48, h * 0.2, w * 0.48, h * 0.36, IRON_D, 2)
			rr(w * 0.34, h * 0.36, w * 0.28, h * 0.34, CABIN_RED, 5)
			rr(w * 0.38, h * 0.42, w * 0.2, h * 0.14, ICE_SKY, 3)
		"praline":
			r(0, 0, w, h, Color("3a2418"))
			for k in range(6):
				r(w * k / 6.0, h * 0.7, w / 6.0 - 2, h * 0.3, TILE_C if k % 2 == 0 else TILE_G)
			c(w * 0.5, h * 0.45, h * 0.26, COCOA)
			c(w * 0.5, h * 0.45, h * 0.2, COCOA_D.lightened(0.1))
			poly([w * 0.5 - h * 0.28, h * 0.45, w * 0.5 - h * 0.42, h * 0.3, w * 0.5 - h * 0.42, h * 0.6], GOLD)
			poly([w * 0.5 + h * 0.28, h * 0.45, w * 0.5 + h * 0.42, h * 0.3, w * 0.5 + h * 0.42, h * 0.6], GOLD)
		"toyshop":
			r(0, 0, w, h, XMAS_RED_D)
			poly([w * 0.5, h * 0.12, w * 0.75, h * 0.82, w * 0.25, h * 0.82], FIR)
			r(w * 0.47, h * 0.82, w * 0.06, h * 0.1, WOOD_D)
			_star5(w * 0.5, h * 0.12, h * 0.1, GOLD)
			for k in range(7):
				var on := int(t * 2.0 + k) % 2 == 0
				c(w * (0.35 + (k % 4) * 0.1), h * (0.4 + floorf(k / 4.0) * 0.2), 2.5, Color("ffd45a") if on else Color("ff5a5a"))
			rr(w * 0.06, h * 0.7, w * 0.16, h * 0.2, Color("2f6fc0"), 2)
			rr(w * 0.78, h * 0.66, w * 0.16, h * 0.24, GOLD.darkened(0.2), 2)
		_:
			super.card(room, w, h)


# --- Shared ---------------------------------------------------------------------

func _star5(x: float, y: float, rad: float, col: Color) -> void:
	var pts := []
	for k in range(10):
		var a := -PI / 2 + k * PI / 5
		var rr2 := rad if k % 2 == 0 else rad * 0.45
		pts.append(x + cos(a) * rr2)
		pts.append(y + sin(a) * rr2)
	poly(pts, col)


func _planks(col: Color, dark: Color) -> void:
	r(0, 0, 960, 372, col)
	for k in range(13):
		r(k * 74.0, 0, 3, 372, dark)
	r(0, 372, 960, 100, dark)
	for k in range(6):
		r(0, 380 + k * 16.0, 960, 2, dark.darkened(0.2))


func _dice(n: int, x: float, y: float, size: float, col: Color, pip: Color) -> void:
	rr(x, y, size, size, col, size * 0.15)
	var spots := {1: [[1, 1]], 2: [[0, 0], [2, 2]], 3: [[0, 0], [1, 1], [2, 2]], 4: [[0, 0], [2, 0], [0, 2], [2, 2]],
		5: [[0, 0], [2, 0], [1, 1], [0, 2], [2, 2]], 6: [[0, 0], [2, 0], [0, 1], [2, 1], [0, 2], [2, 2]]}
	for p in spots.get(n, []):
		c(x + size * (0.22 + p[0] * 0.28), y + size * (0.22 + p[1] * 0.28), size * 0.09, pip)


func _dots(n: int, x: float, y: float, rad: float, col: Color) -> void:
	for k in range(n):
		c(x + (k - (n - 1) / 2.0) * rad * 2.6, y, rad, col)


func _tilt_arrows(x: float, y: float, size: float) -> void:
	arrow_btn(x + size / 2 - 50, y - 46, 100, 40, 0)
	arrow_btn(x + size / 2 - 50, y + size + 8, 100, 40, 1)
	arrow_btn(x - 70, y + size / 2 - 50, 50, 100, 2)
	arrow_btn(x + size + 20, y + size / 2 - 50, 50, 100, 3)
	# The reset knob: lift the board and start again.
	rr(70, 370, 130, 70, Color(0, 0, 0, 0.3), 12)
	ci.draw_arc(Vector2(135, 405), 20, -2.6, 2.2, 20, CREAM, 4, true)
	poly([152, 386, 162, 400, 146, 402], CREAM)


# --- Lookout --------------------------------------------------------------------

func _club_flag(x: float, y: float, s: float, col: Color) -> void:
	ln(x, y, x, y + 40 * s, PLANK_D, 3)
	poly([x, y, x + 28 * s, y + 8 * s, x, y + 16 * s], col)


func _e1() -> void:
	_planks(PLANK, PLANK_D)
	# Window with autumn leaves.
	rr(60, 50, 240, 170, PLANK_D, 6)
	r(72, 62, 216, 146, Color("f6d39a"))
	for k in range(14):
		c(80 + (k * 37) % 200, 70 + (k * 53) % 130, 16, AUTUMN if k % 3 else AUTUMN_D)
	r(178, 62, 4, 146, PLANK_D)
	_club_flag(312, 60, 1.2, CLUB)
	# Dartboard.
	c(460, 140, 70, Color("1c1c1c"))
	for k in range(20):
		var a := -PI / 2 + k * TAU / 20 - PI / 20
		ci.draw_arc(Vector2(460, 140), 46, a, a + TAU / 20, 4, Color("e8dcc0") if k % 2 else Color("2a2a2a"), 30, true)
	c(460, 140, 8, RED)
	# Periscope pipe through the roof.
	r(690, 0, 26, 200, STEEL)
	rr(650, 180, 110, 70, STEEL.darkened(0.2), 8)
	rr(664, 196, 50, 36, Color("1a1a1a"), 6)
	if flag("knob_on"):
		item("knob", 742, 214, 1.0)
	# Club chest.
	rr(120, 280, 200, 92, Color("8a3a24"), 8)
	r(120, 316, 200, 6, Color("5a2414"))
	rr(206, 300, 28, 24, BRASS, 4)
	# Hatch in the floor.
	rr(480, 390, 200, 60, PLANK_D.darkened(0.2), 6)
	r(490, 400, 180, 40, PLANK_D)
	rr(570, 410, 24, 20, BRASS if not st.get("done", false) else Color(0, 0, 0, 0), 4)
	# Leaves blown in.
	for k in range(10):
		c(810 + (k * 29) % 110, 345 + (k * 7) % 25, 10, AUTUMN if k % 2 else AUTUMN_D)


func _e2() -> void:
	_planks(PLANK, PLANK_D)
	# Shelf with the signal lamp.
	r(80, 270, 170, 12, PLANK_D)
	rr(110, 170, 90, 100, Color("2f4f6a"), 10)
	c(200, 220, 34, Color("ffe08a") if flag("lamp_on") else Color("8a8a7a"))
	ring(200, 220, 34, STEEL, 5)
	# The mirror board, small.
	_beam_board(300, 50, 60.0, 0.75)
	# The club's map.
	rr(720, 60, 180, 130, PAPER, 4)
	for k in range(3):
		ln(740, 90 + k * 30, 880, 86 + k * 30, Color("c9b98a"), 2)
	_club_flag(830, 100, 0.8, CLUB)
	c(812, 92, 4, RED)
	# Comics and a blanket.
	for k in range(4):
		rr(730 + k * 12, 330 - k * 8, 120, 26, [RED, Color("2f6fc0"), GOLD, LEAF][k], 3)
	rr(40, 330, 220, 40, Color("6a8a3a"), 10)
	for k in range(6):
		r(50 + k * 36, 330, 14, 40, Color("8aaa4a"))


func _edarts() -> void:
	board(Color("6a4a2a"))
	var cx := 480.0
	var cy := 240.0
	c(cx, cy, 210, Color("141414"))
	for k in range(20):
		var a := -PI / 2 + k * TAU / 20 - PI / 20
		var col := Color("efe2c4") if k % 2 else Color("262626")
		ci.draw_arc(Vector2(cx, cy), 85, a, a + TAU / 20, 6, col, 130, true)
		ci.draw_arc(Vector2(cx, cy), 152, a, a + TAU / 20, 6, RED if k % 2 else LEAF, 12, true)
		var mid := -PI / 2 + k * TAU / 20
		txt(cx + cos(mid) * 186, cy + sin(mid) * 186 + 9, str(DART_NUMBERS[k]), 24, CREAM)
	c(cx, cy, 16, LEAF)
	c(cx, cy, 8, RED)
	var cols := [RED, Color("f0c020"), Color("2f6fd0")]
	var darts: Array = clues.get("darts", [7, 3, 9])
	for i in range(3):
		var seg := DART_NUMBERS.find(int(darts[i]))
		var a := -PI / 2 + seg * TAU / 20 + (i - 1) * 0.05
		var out := Vector2(cos(a), sin(a))
		var side := Vector2(-out.y, out.x)
		var p := Vector2(cx, cy) + out * 70
		var tail := Vector2(cx, cy) + out * 128
		ln(p.x, p.y, tail.x, tail.y, STEEL, 5)
		c(p.x, p.y, 5, IRON_D)
		var f1 := tail + side * 12 + out * 14
		var f2 := tail - side * 12 + out * 14
		poly([tail.x, tail.y, f1.x, f1.y, tail.x + out.x * 22, tail.y + out.y * 22, f2.x, f2.y], cols[i])


func _echest() -> void:
	board(Color("5a3a24"))
	rr(120, 60, 720, 380, Color("8a3a24"), 16)
	if flag("chest_open"):
		rr(170, 110, 620, 290, Color("1c120c"), 8)
		if not flag("got_chest"):
			item("battery", 480, 250, 3.2)
	else:
		var cols := [RED, Color("f0c020"), Color("2f6fd0")]
		for i in range(3):
			rr(400 + i * 80 - 36, 246, 72, 92, cols[i], 8)
		kit_wheels(st.get("chest", [0, 0, 0]), 400, 260)


## The mirror board at (x, y) with cells of `cell`; `s` scales the lamp.
func _beam_board(x: float, y: float, cell: float, s: float) -> void:
	var cols := 6
	var rows := 4
	rr(x - 10, y - 10, cols * cell + 20, rows * cell + 20, PLANK_D.darkened(0.25), 10)
	r(x, y, cols * cell, rows * cell, Color("3a2a1c"))
	for k in range(cols + 1):
		r(x + k * cell - 1, y, 2, rows * cell, Color("4e3a28"))
	for k in range(rows + 1):
		r(x, y + k * cell - 1, cols * cell, 2, Color("4e3a28"))
	var lamp_row := int(clues.get("lamp_row", 1))
	var ly := y + (lamp_row + 0.5) * cell
	rr(x - 50 * s, ly - 26 * s, 40 * s, 52 * s, Color("2f4f6a"), 8)
	var mm: Array = clues.get("marble", [1, 0])
	var hit: bool = st.get("hit", false) and flag("lamp_on")
	var mc := Vector2(x + (int(mm[0]) + 0.5) * cell, y + (int(mm[1]) + 0.5) * cell)
	if hit:
		c(mc.x, mc.y, cell * 0.42, Color(1.0, 0.85, 0.3, 0.35 + 0.15 * sin(t * 4.0)))
	c(mc.x, mc.y, cell * 0.26, Color(0.75, 0.9, 1.0, 0.85))
	c(mc.x - cell * 0.08, mc.y - cell * 0.08, cell * 0.07, Color(1, 1, 1, 0.9))
	var mirrors: Array = clues.get("mirrors", [])
	var vals: Array = st.get("mirrors", [0, 0, 0, 0])
	for i in range(mirrors.size()):
		var m: Array = mirrors[i]
		var cc := Vector2(x + (int(m[0]) + 0.5) * cell, y + (int(m[1]) + 0.5) * cell)
		c(cc.x, cc.y, cell * 0.36, Color(0, 0, 0, 0.25))
		var d := cell * 0.32
		if int(vals[i]) == 0:
			ln(cc.x - d, cc.y + d, cc.x + d, cc.y - d, SILVER, cell * 0.12)
		else:
			ln(cc.x - d, cc.y - d, cc.x + d, cc.y + d, SILVER, cell * 0.12)
	if not flag("lamp_on"):
		return
	c(x - 12 * s, ly, 12 * s, Color("ffe08a"))
	var pts := [Vector2(x - 12 * s, ly)]
	for p in st.get("beam", []):
		pts.append(Vector2(x + (int(p[0]) + 0.5) * cell, y + (int(p[1]) + 0.5) * cell))
	if not hit and pts.size() >= 2:
		var last: Vector2 = pts[pts.size() - 1]
		var dir: Vector2 = (last - pts[pts.size() - 2]).normalized()
		pts.append(last + dir * cell * 0.7)
	var beam := Color(1.0, 0.9, 0.4, 0.75)
	for k in range(pts.size() - 1):
		ln(pts[k].x, pts[k].y, pts[k + 1].x, pts[k + 1].y, beam, 5)


func _ebeam() -> void:
	board(PLANK_D)
	var bx := Set5Views.BEAM_X
	_beam_board(bx, Set5Views.BEAM_Y, Set5Views.BEAM_CELL, 1.6)
	# The club's alarm: a drawer that springs when the marble lights up.
	rr(560, 390, 230, 66, Color("6a4a2a"), 8)
	if flag("beam_ok"):
		rr(574, 398, 202, 50, Color("1a120c"), 6)
		if not flag("got_knob"):
			item("knob", 675, 423, 1.8)
	else:
		rr(650, 414, 50, 14, BRASS, 4)


func _peri_scene(d: int, cx: float, cy: float, rad: float) -> void:
	r(cx - rad, cy - rad, rad * 2, rad, Color("cfe0ea"))
	r(cx - rad, cy, rad * 2, rad, Color("c8a050"))
	r(cx - rad, cy - 6, rad * 2, 12, Color("a9b8a0"))
	var dice: Array = clues.get("dice", [1, 1, 1, 1])
	var decoy: Array = clues.get("decoy", [1, 1, 1, 1])
	match d:
		0:
			ci.draw_set_transform(Vector2(cx, cy + 40), 0.0, Vector2(1.0, 0.35))
			c(0, 0, 150, Color("4a8ab8"))
			home()
			for k in range(6):
				ln(cx - 120 + k * 12, cy + 50, cx - 124 + k * 12, cy + 10, LEAF_D, 3)
		1:
			r(cx - 40, cy - 70, 80, 90, Color("e8e0d0"))
			poly([cx - 50, cy - 70, cx, cy - 110, cx + 50, cy - 70], RED)
			r(cx + 10, cy - 150, 24, 90, Color("e8e0d0"))
			poly([cx + 6, cy - 150, cx + 22, cy - 190, cx + 38, cy - 150], RED)
		2, 5:
			var big := d == 2
			var px := cx - 80.0
			var ph := 200.0 if big else 110.0
			poly([px, cy - ph, px - ph * 0.3, cy + 10, px + ph * 0.3, cy + 10], FIR)
			# The treehouse in the next tree, with its board.
			r(cx + 40, cy - 30, 14, 50, PLANK_D)
			rr(cx - 10, cy - 100, 120, 70, PLANK, 4)
			poly([cx - 20, cy - 100, cx + 50, cy - 140, cx + 120, cy - 100], AUTUMN_D)
			_club_flag(cx + 96, cy - 176, 1.0, CLUB if big else RIVAL)
			var vals: Array = dice if big else decoy
			for k in range(4):
				_dice(int(vals[k]), cx - 4 + k * 28, cy - 88, 24, CREAM, INK)
		3:
			for k in range(5):
				r(cx - 150, cy + 10 + k * 18, 300, 8, Color("b08a3a"))
			ln(cx, cy + 40, cx, cy - 70, PLANK_D, 5)
			ln(cx - 40, cy - 40, cx + 40, cy - 40, PLANK_D, 5)
			c(cx, cy - 80, 16, Color("e8c88a"))
			poly([cx - 26, cy - 92, cx + 26, cy - 92, cx, cy - 118], Color("6a4a2a"))
		4:
			poly([cx - 20, cy, cx + 20, cy, cx + 90, cy + rad, cx - 90, cy + rad], Color("6a6a6a"))
			ln(cx + 70, cy + 30, cx + 70, cy - 70, STEEL, 5)
			rr(cx + 44, cy - 110, 52, 44, Color("2f8a4a"), 6)
			txt(cx + 70, cy - 76, "17", 26, CREAM)
		6:
			r(cx - 90, cy - 70, 180, 90, Color("e8d8b8"))
			poly([cx - 104, cy - 70, cx, cy - 130, cx + 104, cy - 70], Color("8a3a24"))
			rr(cx - 34, cy - 54, 68, 30, CREAM, 4)
			txt(cx, cy - 31, "386", 24, INK)
		_:
			for k in range(3):
				var hx := cx - 120 + k * 120.0
				ci.draw_set_transform(Vector2(hx, cy + 10), 0.0, Vector2(1.6, 0.6))
				c(0, 0, 60, LEAF.lightened(0.1 * k))
				home()
			for k in range(2):
				rr(cx - 60 + k * 90, cy + 30, 50, 26, CREAM, 8)
				c(cx - 50 + k * 90, cy + 36, 5, INK)


func _eperi() -> void:
	board(Color("1c1c1c"))
	var d := int(st.get("peri", [6])[0])
	_peri_scene(d, 480, 236, 200)
	ring(480, 236, 310, Color("1c1c1c"), 220)
	ring(480, 236, 204, STEEL, 10)
	ln(480, 30, 480, 46, CREAM, 3)
	arrow_btn(70, 190, 90, 90, 2)
	arrow_btn(800, 190, 90, 90, 3)


func _emap() -> void:
	board(PLANK_D)
	rr(160, 20, 640, 440, PAPER, 6)
	var cx := 480.0
	var cy := 240.0
	# Our treehouse in the middle; around it what the periscope sees.
	rr(cx - 22, cy - 18, 44, 30, PLANK, 3)
	poly([cx - 28, cy - 18, cx, cy - 38, cx + 28, cy - 18], AUTUMN_D)
	_club_flag(cx + 16, cy - 64, 0.7, CLUB)
	for k in range(8):
		var a := -PI / 2 + k * TAU / 8
		var p := Vector2(cx + cos(a) * 170, cy + sin(a) * 150)
		match k:
			0:
				ci.draw_set_transform(p, 0.0, Vector2(1.6, 0.7))
				c(0, 0, 26, Color("4a8ab8"))
				home()
			1:
				r(p.x - 14, p.y - 10, 28, 26, Color("d0c8b8"))
				poly([p.x - 6, p.y - 10, p.x + 2, p.y - 34, p.x + 10, p.y - 10], RED)
			2:
				poly([p.x - 40, p.y + 26, p.x - 26, p.y - 34, p.x - 12, p.y + 26], FIR)
				rr(p.x - 4, p.y - 8, 40, 26, PLANK, 3)
				_club_flag(p.x + 26, p.y - 40, 0.8, CLUB)
				# A star: the friends' treehouse.
				_star5(p.x + 14, p.y + 40, 12, RED)
				for j in range(8):
					var q := Vector2(cx, cy).lerp(p, j / 8.0 + 0.06)
					c(q.x, q.y, 2.5, RED)
			3:
				for j in range(3):
					r(p.x - 24, p.y - 10 + j * 8, 48, 4, Color("b08a3a"))
			4:
				r(p.x - 3, p.y - 20, 6, 30, STEEL)
				rr(p.x - 12, p.y - 34, 24, 18, Color("2f8a4a"), 3)
			5:
				poly([p.x - 34, p.y + 20, p.x - 24, p.y - 16, p.x - 14, p.y + 20], FIR)
				rr(p.x - 6, p.y - 6, 36, 22, PLANK, 3)
				_club_flag(p.x + 20, p.y - 34, 0.7, RIVAL)
				ln(p.x - 10, p.y - 40, p.x + 40, p.y + 20, RED, 4)
				ln(p.x + 40, p.y - 40, p.x - 10, p.y + 20, RED, 4)
			6:
				r(p.x - 18, p.y - 8, 36, 22, Color("e8d8b8"))
				poly([p.x - 22, p.y - 8, p.x, p.y - 26, p.x + 22, p.y - 8], Color("8a3a24"))
			_:
				rr(p.x - 16, p.y - 6, 26, 14, CREAM, 6)
				c(p.x - 10, p.y - 2, 3, INK)


func _ehatch() -> void:
	board(PLANK_D.darkened(0.2))
	rr(160, 40, 640, 420, PLANK, 10)
	for k in range(6):
		r(160, 40 + k * 70.0, 640, 3, PLANK_D)
	rr(260, 110, 440, 290, Color("5a3a24"), 12)
	# The club's padlock.
	rr(420, 100, 120, 30, STEEL, 6)
	kit_wheels(st.get("hatch", [0, 0, 0, 0]), 360, 250)


# --- Gondola 12 -----------------------------------------------------------------

func _cabin(tint: Color) -> void:
	r(0, 0, 960, 372, tint)
	r(0, 0, 960, 24, CABIN_D)
	r(0, 372, 960, 100, Color("4a525c"))
	for k in range(12):
		r(k * 80.0, 380, 3, 92, Color("3c434c"))


func _slope(x: float, y: float, w: float, h: float, ahead: bool) -> void:
	r(x, y, w, h, ICE_SKY)
	poly([x, y + h * 0.45, x + w * 0.35, y + h * 0.2, x + w * 0.7, y + h * 0.4, x + w, y + h * 0.25, x + w, y + h, x, y + h], Color("f4f8fc"))
	poly([x, y + h, x, y + h * 0.7, x + w * 0.5, y + h * 0.55, x + w, y + h * 0.75, x + w, y + h], SNOW)
	for k in range(14):
		var tx := x + 20 + (k * 71) % int(w - 40)
		var ty := y + h * 0.58 + (k * 37) % int(h * 0.3)
		poly([tx, ty - 18, tx - 8, ty + 4, tx + 8, ty + 4], FIR_D)
	if ahead:
		ln(x, y + h * 0.05, x + w, y + h * 0.5, IRON_D, 3)
		ln(x, y + h * 0.1, x + w, y + h * 0.55, IRON_D, 2)


func _q1() -> void:
	_cabin(CABIN)
	rr(52, 32, 576, 286, CABIN_RED, 10)
	_slope(64, 44, 552, 262, true)
	# The pylon ahead, small; its plate is too small to read from here.
	r(470, 140, 8, 160, IRON_D)
	r(450, 140, 48, 6, IRON_D)
	rr(462, 170, 24, 16, Color("f0d040"), 2)
	# Door seam.
	r(648, 24, 4, 348, CABIN_D)
	r(662, 24, 4, 348, CABIN_D)
	# Emergency panel.
	rr(680, 130, 230, 210, Color("5a6470"), 10)
	if flag("cover_off"):
		rr(696, 146, 198, 178, Color("2c3238"), 6)
		c(740, 190, 10, Color("8af08a") if flag("fuse_in") else Color("3a4a3a"))
		c(840, 260, 22, Color("2fa84f"))
	else:
		for p in [[694, 144], [896, 144], [694, 326], [896, 326]]:
			c(p[0], p[1], 6, STEEL)
		poly([795, 180, 776, 240, 798, 236, 784, 290, 822, 222, 800, 226, 814, 180], Color("f0d040"))


func _shadow_rows(k: int) -> Array:
	var front: Array = clues.get("front", ["111", "001", "111", "100", "111"])
	var side: Array = clues.get("side", ["101", "101", "111", "001", "001"])
	var rows: Array = front if k % 2 == 0 else side
	if k >= 2:
		var flipped := []
		for row in rows:
			var s: String = row
			flipped.append(s.reverse())
		return flipped
	return rows


func _shadow(x: float, y: float, cell: float, col: Color) -> void:
	var rows := _shadow_rows(int(st.get("turn", [3])[0]))
	for j in range(rows.size()):
		var row: String = rows[j]
		for i in range(row.length()):
			if row[i] == "1":
				r(x + i * cell, y + j * cell, cell + 1, cell + 1, col)


func _sculpture(x: float, base: float, cell: float) -> void:
	# Wooden blocks stacked on a turntable; the front face is what faces the sun.
	ci.draw_set_transform(Vector2(x, base), 0.0, Vector2(1.0, 0.3))
	c(0, 0, cell * 3.2, Color("6a4a2a"))
	c(0, -4, cell * 3.0, Color("8a6a3a"))
	home()
	# Every block both silhouettes allow, seen from above at an angle: from
	# here it is just a stack; only its shadow shows a digit.
	var front: Array = clues.get("front", [])
	var sidev: Array = clues.get("side", [])
	var k := int(st.get("turn", [3])[0])
	var blocks := []
	for j in range(front.size()):
		for i in range(3):
			for z in range(3):
				if str(front[j])[i] == "1" and str(sidev[j])[z] == "1":
					var px := i - 1
					var pz := z - 1
					for _q in range(k):
						var tmp := px
						px = -pz
						pz = tmp
					blocks.append([px, j, pz])
	blocks.sort_custom(func(a: Array, b: Array) -> bool: return a[2] > b[2] or (a[2] == b[2] and a[1] < b[1]))
	for bl in blocks:
		var bx: float = x + bl[0] * cell + bl[2] * cell * 0.45 - cell / 2
		var by: float = base - (front.size() - bl[1]) * cell - bl[2] * cell * 0.3
		r(bx + cell * 0.25, by - cell * 0.2, cell, cell, Color("a07a44"))
		r(bx, by, cell, cell, Color("d0a868"))
		r(bx, by, cell, 2, Color("e8c890"))
		r(bx, by, 2, cell, Color("b89058"))


func _base_mark(x: float, y: float, rad: float) -> void:
	var k := int(st.get("turn", [3])[0])
	if k < 3:
		_dots(k + 1, x, y, rad, INK)


func _q2() -> void:
	_cabin(CABIN)
	# Side window with the low sun; the sculpture on the sill.
	rr(50, 30, 280, 180, CABIN_RED, 10)
	r(62, 42, 256, 156, ICE_SKY)
	c(110, 90, 30, Color("fff2b0"))
	poly([62, 170, 160, 120, 260, 150, 318, 130, 318, 198, 62, 198], SNOW)
	r(40, 206, 300, 14, CABIN_D)
	_sculpture(200, 202, 9)
	# Its shadow on the wall beside the window.
	_shadow(360, 70, 22, SHADOW)
	# Bench and backpack.
	rr(120, 300, 440, 30, Color("6a7480"), 6)
	r(120, 330, 440, 40, Color("4a525c"))
	rr(140, 240, 120, 100, Color("2f6fc0"), 18)
	rr(160, 270, 80, 50, Color("2860a8"), 10)
	rr(186, 262, 28, 18, STEEL, 4)
	# Ski rack.
	for k in range(3):
		rr(530 + k * 26, 50, 14, 310, [RED, Color("2f6fc0"), GOLD][k], 6)
	# Piste map.
	rr(640, 50, 180, 140, CREAM, 4)
	poly([660, 180, 730, 70, 800, 180], Color("dfe8f0"))
	ln(670, 175, 790, 80, IRON_D, 2)
	# First-aid box.
	rr(850, 80, 90, 90, CREAM, 8)
	r(887, 96, 16, 58, RED)
	r(866, 117, 58, 16, RED)


func _qwindow() -> void:
	board(CABIN_RED)
	_slope(40, 20, 880, 432, true)
	# The pylon ahead, downhill, with its number plate.
	var px := 560.0
	r(px, 80, 16, 330, IRON_D)
	r(px - 60, 80, 136, 10, IRON_D)
	for k in range(6):
		ln(px, 100 + k * 50, px + 16, 140 + k * 50, IRON_D, 3)
	rr(px - 26, 160, 68, 56, Color("f0d040"), 6)
	txt(px + 8, 204, str(int(clues.get("ahead", 7))), 40, INK)
	# The valley station, tiny and far below.
	r(130, 380, 50, 26, Color("8a3a24"))
	poly([124, 380, 155, 362, 186, 380], INK)


func _qmap() -> void:
	board(CABIN_D)
	rr(120, 20, 720, 440, CREAM, 6)
	poly([160, 440, 520, 50, 800, 440], Color("eef3f8"))
	poly([420, 160, 520, 50, 610, 170], SNOW)
	# The cable car line, valley to top, with its numbered pylons.
	var vb := Vector2(200, 420)
	var tp := Vector2(600, 80)
	ln(vb.x, vb.y, tp.x, tp.y, IRON_D, 3)
	rr(vb.x - 24, vb.y - 8, 48, 26, Color("8a3a24"), 3)
	rr(tp.x - 24, tp.y - 26, 48, 26, Color("8a3a24"), 3)
	var n := int(clues.get("pylons", 9))
	for k in range(n):
		var p := vb.lerp(tp, (k + 1.0) / (n + 1.0))
		r(p.x - 2, p.y - 14, 4, 14, IRON_D)
		txt(p.x - 16, p.y + 4, str(k + 1), 16, INK)
	# The runs, numbered on coloured signs (blue round, red square, black diamond).
	var pistes: Array = clues.get("pistes", [0, 0, 0])
	var runs := [
		[Color("2f6fd0"), [700, 120, 740, 240, 700, 330, 740, 430]],
		[RED, [520, 90, 470, 200, 520, 300, 460, 430]],
		[Color("202020"), [560, 100, 640, 220, 600, 330, 640, 430]],
		[Color("2f6fd0"), [430, 160, 380, 260, 330, 330, 300, 430]],
		[RED, [650, 160, 690, 260, 660, 360, 700, 430]],
	]
	for k in range(runs.size()):
		var pts: Array = runs[k][1]
		for j in range(0, pts.size() - 2, 2):
			ln(pts[j], pts[j + 1], pts[j + 2], pts[j + 3], runs[k][0], 5)
		if k < 3:
			var sx: float = pts[2] + 20
			var sy: float = pts[3]
			match k:
				0:
					c(sx, sy, 20, runs[k][0])
				1:
					r(sx - 18, sy - 18, 36, 36, runs[k][0])
				_:
					poly([sx, sy - 24, sx + 24, sy, sx, sy + 24, sx - 24, sy], runs[k][0])
			txt(sx, sy + 9, str(int(pistes[k])), 24, CREAM)


func _qbag() -> void:
	board(CABIN_D)
	rr(220, 60, 520, 360, Color("2f6fc0"), 40)
	rr(260, 120, 440, 260, Color("2860a8"), 24)
	if flag("bag_open"):
		rr(290, 150, 380, 200, Color("13203a"), 16)
		if not flag("got_bag"):
			item("multitool", 480, 250, 3.0)
	else:
		var cols := [Color("2f6fd0"), RED, Color("202020")]
		for i in range(3):
			rr(400 + i * 80 - 36, 256, 72, 92, cols[i], 8)
		kit_wheels(st.get("bag", [0, 0, 0]), 400, 270)


func _qsill() -> void:
	board(CABIN)
	# The window and the low sun on the left, the wall on the right.
	rr(10, 10, 240, 170, CABIN_RED, 10)
	r(22, 22, 216, 146, ICE_SKY)
	c(90, 80, 40, Color("fff2b0"))
	r(0, 420, 560, 52, CABIN_D)
	ci.draw_set_transform(Vector2(275, 410), 0.0, Vector2(1.0, 0.3))
	c(0, 0, 120, Color("6a4a2a"))
	c(0, -6, 112, Color("8a6a3a"))
	home()
	_sculpture(275, 400, 32)
	_base_mark(275, 438, 7)
	# The shadow on the wall.
	r(560, 30, 380, 380, CABIN.darkened(0.04))
	_shadow(640, 80, 48, SHADOW)
	arrow_btn(50, 310, 90, 90, 2)
	arrow_btn(410, 310, 90, 90, 3)


func _qkit() -> void:
	board(CABIN_D)
	# Closed, the box stands in the middle; open, it moves aside for the card.
	var bx := 180.0 if flag("kit_open") else 310.0
	rr(bx, 60, 340, 360, CREAM, 14)
	r(bx + 150, 80, 40, 70, RED)
	r(bx + 135, 95, 70, 40, RED)
	if flag("kit_open"):
		rr(200, 170, 300, 220, Color("e8e8e0"), 8)
		if not flag("got_kit"):
			item("qfuse", 350, 280, 3.4)
		_card(540, 70)
	else:
		for i in range(3):
			_dots(i + 1, 400 + i * 80, 188, 7, INK)
		kit_wheels(st.get("kit", [0, 0, 0]), 400, 270)


## The emergency card: four steps in pictures.
func _card(x: float, y: float) -> void:
	rr(x, y, 340, 340, Color("f0d040"), 8)
	for k in range(4):
		var cy := y + 30 + k * 78.0
		c(x + 30, cy + 10, 16, INK)
		txt(x + 30, cy + 18, str(k + 1), 20, Color("f0d040"))
		match k:
			0:
				item("qfuse", x + 120, cy + 10, 1.4)
				arrow_btn(x + 170, cy - 8, 40, 36, 3)
				rr(x + 230, cy - 8, 60, 36, Color("2c3238"), 4)
			1:
				rr(x + 90, cy - 14, 70, 48, Color("2c3238"), 6)
				ln(x + 110, cy + 24, x + 140, cy - 10, CREAM, 6)
				c(x + 140, cy - 10, 8, RED)
			2:
				# Toward the nearer station: the short way, not the long one.
				rr(x + 70, cy - 8, 30, 24, Color("8a3a24"), 3)
				ln(x + 100, cy + 4, x + 160, cy + 4, INK, 4)
				rr(x + 160, cy - 6, 20, 20, CABIN_RED, 3)
				ln(x + 180, cy + 4, x + 290, cy + 4, INK, 2)
				rr(x + 290, cy - 8, 30, 24, Color("8a3a24"), 3)
				poly([x + 150, cy - 10, x + 120, cy - 2, x + 150, cy + 6], RED)
			_:
				c(x + 150, cy + 10, 22, Color("2fa84f"))


func _qpanel() -> void:
	board(Color("4a525c"))
	rr(130, 30, 700, 420, Color("5a6470"), 14)
	if not flag("cover_off"):
		for p in [[156, 56], [804, 56], [156, 424], [804, 424]]:
			c(p[0], p[1], 12, STEEL)
			ln(p[0] - 8, p[1], p[0] + 8, p[1], IRON_D, 3)
		poly([480, 120, 440, 250, 490, 240, 460, 360, 540, 210, 490, 220, 520, 120], Color("f0d040"))
		return
	rr(150, 50, 660, 380, Color("2c3238"), 8)
	var powered := flag("fuse_in")
	# Fuse slot.
	rr(170, 80, 110, 140, Color("1a1e22"), 6)
	if powered:
		item("qfuse", 225, 150, 2.4)
	c(225, 250, 12, Color("8af08a") if powered else Color("3a4a3a"))
	# Brake lever: down is on, up is released.
	var brake := int(st.get("brake", [0])[0])
	rr(400, 80, 60, 200, Color("1a1e22"), 6)
	var by := 110.0 if brake == 1 else 250.0
	ln(430, 180, 430, by, STEEL, 12)
	c(430, by, 18, RED)
	rr(380, 300, 100, 40, Color("1a1e22"), 4)
	rr(392, 312, 34, 18, Color("8a8a8a"), 4)
	rr(436, 312, 34, 18, Color("8a8a8a"), 4)
	# Direction lever: up to the top station, stop, down to the valley.
	var dir := int(st.get("dir", [1])[0])
	rr(600, 70, 80, 250, Color("1a1e22"), 6)
	var dy: float = [280.0, 195.0, 110.0][dir]
	ln(640, 195, 640, dy, STEEL, 12)
	c(640, dy, 18, Color("f0d040"))
	poly([710, 120, 740, 80, 770, 120], CREAM)
	poly([700, 140, 740, 100, 780, 140], Color(1, 1, 1, 0.0))
	poly([716, 112, 740, 84, 764, 112], Color("9ab0c8"))
	c(740, 195, 8, CREAM)
	r(718, 270, 44, 24, Color("8a3a24"))
	poly([712, 270, 740, 252, 768, 270], CREAM)
	arrow_btn(590, 50, 100, 40, 0)
	arrow_btn(590, 290, 100, 40, 1)
	# The start button.
	c(830, 190, 54, Color("1a1e22"))
	c(830, 190, 44, Color("2fa84f") if powered else Color("2a4a32"))


# --- Praline Works ---------------------------------------------------------------

func praline(shape: String, x: float, y: float, s: float, col: Color) -> void:
	match shape:
		"heart":
			c(x - 8 * s, y - 4 * s, 9 * s, col)
			c(x + 8 * s, y - 4 * s, 9 * s, col)
			poly([x - 16 * s, y, x + 16 * s, y, x, y + 16 * s], col)
		"star":
			_star5(x, y, 16 * s, col)
		"shell":
			for k in range(5):
				var a := PI + k * PI / 4
				ln(x, y + 10 * s, x + cos(a) * 16 * s, y + 10 * s + sin(a) * 16 * s, col, 6 * s)
			ci.draw_arc(Vector2(x, y + 10 * s), 16 * s, PI, TAU, 16, col, 5 * s, true)
		"leaf":
			poly([x - 18 * s, y + 12 * s, x - 10 * s, y - 6 * s, x + 4 * s, y - 14 * s, x + 18 * s, y - 16 * s, x + 12 * s, y, x, y + 10 * s], col)
			ln(x - 18 * s, y + 12 * s, x + 12 * s, y - 10 * s, col.darkened(0.3), 2 * s)
			ln(x - 4 * s, y + 3 * s, x - 4 * s, y - 6 * s, col.darkened(0.3), 1.5 * s)
			ln(x + 4 * s, y - 3 * s, x + 6 * s, y - 11 * s, col.darkened(0.3), 1.5 * s)
		"bean":
			ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(1.3, 0.8))
			c(0, 0, 13 * s, col)
			home()
			ln(x, y - 9 * s, x, y + 9 * s, col.darkened(0.35), 2.5 * s)
		_:
			rr(x - 13 * s, y - 13 * s, 26 * s, 26 * s, col, 4 * s)


func _tile_wall(top: float, h: float) -> void:
	r(0, 0, 960, 372, Color("efe6cc"))
	for j in range(int(h / 30.0)):
		for i in range(32):
			r(i * 30.0, top + j * 30.0, 29, 29, TILE_C if (i + j) % 2 == 0 else TILE_G)
	r(0, 372, 960, 100, Color("6a5040"))
	for i in range(16):
		r(i * 60.0, 372, 2, 100, Color("5a4030"))


func _p1() -> void:
	_tile_wall(250, 122)
	# Hanging lamp.
	ln(490, 0, 490, 20, INK, 2)
	poly([460, 34, 520, 34, 506, 18, 474, 18], Color("2f5a3a"))
	# Tempering kettle.
	rr(60, 100, 210, 240, COPPER, 30)
	rr(80, 120, 170, 40, COPPER_D, 12)
	r(150, 60, 30, 50, COPPER_D)
	for k in range(3):
		c(110 + k * 55, 210, 14, BRASS)
	rr(120, 250, 90, 60, CREAM, 6)
	r(160, 262, 10, 40, RED if flag("tempered") else Color("c0a0a0"))
	# The recipe frame on the wall.
	rr(340, 46, 280, 164, WOOD_D, 6)
	r(352, 58, 256, 140, Color("d8ccaa"))
	for i in range(4):
		var px := 352 + (i % 2) * 128.0
		var py := 58 + floorf(i / 2.0) * 70.0
		if flag("placed%d" % (i + 1)):
			r(px + 4, py + 4, 120, 62, PAPER)
	# Conveyor belt.
	r(300, 240, 400, 46, Color("3a3a3a"))
	for k in range(9):
		c(312 + k * 47, 286, 9, STEEL)
	if flag("tempered"):
		for k in range(4):
			var bx := fmod(310.0 + k * 100 + t * 40.0, 390.0) + 300
			c(bx, 250, 12, COCOA)
		if not flag("got_okey"):
			c(660, 250, 15, GOLD)
	# Table with the tray.
	r(380, 330, 200, 10, WOOD_D)
	r(390, 340, 10, 32, WOOD_D)
	r(560, 340, 10, 32, WOOD_D)
	rr(400, 306, 160, 26, Color("8a8a8a"), 4)
	c(450, 314, 7, COCOA)
	c(510, 316, 7, COCOA)
	# Mould cabinet.
	rr(720, 50, 220, 230, WOOD, 8)
	rr(736, 66, 188, 150, Color(0.8, 0.9, 0.95, 0.35), 4)
	for k in range(4):
		praline(SHAPES[k], 770 + (k % 2) * 90, 110 + floorf(k / 2.0) * 60, 1.2, Color("9a9aa2"))
	rr(800, 230, 60, 30, BRASS, 4)
	# A scrap of paper on the floor.
	if not flag("got_torn1"):
		item("torn1", 680, 414, 1.6)


func _p2() -> void:
	_tile_wall(250, 122)
	# Enamel sign.
	rr(50, 30, 280, 170, Color("1f3f7a"), 10)
	ring(190, 115, 70, CREAM, 3)
	for k in range(6):
		praline(SHAPES[k], 100 + (k % 3) * 90, 80 + floorf(k / 3.0) * 70, 1.0, WRAP_COL[WRAPS[k]])
	# The wrapping machine with four reels of foil.
	rr(50, 214, 290, 158, Color("4a5a4a"), 8)
	var reels: Array = clues.get("reels", [0, 1, 2, 3])
	for k in range(4):
		c(95 + k * 66, 270, 26, WRAP_COL[WRAPS[int(reels[k])]])
		c(95 + k * 66, 270, 8, Color("2a2a2a"))
	r(60, 320, 270, 20, Color("2a2a2a"))
	# Lockers: cup, bicycle, umbrella, and the hat's (locked).
	for k in range(4):
		var lx := 352 + k * 74.0
		rr(lx, 70, 70, 290, Color("6a7a6a") if k < 3 else Color("5a6a7a"), 4)
		for j in range(4):
			r(lx + 14, 90 + j * 8, 42, 3, Color("4a5a4a"))
		rr(lx + 15, 150, 40, 30, CREAM, 4)
		_worker(["cup", "bicycle", "umbrella", "hat"][k], lx + 35, 165, 0.6, INK)
		if k == 3 and not flag("locker_open"):
			rr(lx + 20, 200, 30, 40, STEEL, 4)
	# Time cards.
	rr(664, 70, 112, 190, WOOD_D, 6)
	for k in range(4):
		rr(674, 82 + k * 44, 92, 36, CREAM, 3)
	# Office door with frosted glass.
	rr(800, 50, 150, 322, WOOD, 6)
	rr(820, 70, 110, 140, Color(0.85, 0.9, 0.92, 0.7), 4)
	c(820, 240, 8, BRASS)


func _worker(kind: String, x: float, y: float, s: float, col: Color) -> void:
	match kind:
		"cup":
			rr(x - 12 * s, y - 10 * s, 22 * s, 22 * s, col, 3 * s)
			ring(x + 12 * s, y, 7 * s, col, 3 * s)
		"bicycle":
			ring(x - 13 * s, y + 4 * s, 9 * s, col, 3 * s)
			ring(x + 13 * s, y + 4 * s, 9 * s, col, 3 * s)
			ln(x - 13 * s, y + 4 * s, x, y - 8 * s, col, 3 * s)
			ln(x, y - 8 * s, x + 13 * s, y + 4 * s, col, 3 * s)
		"hat":
			rr(x - 18 * s, y + 4 * s, 36 * s, 6 * s, col, 3 * s)
			rr(x - 10 * s, y - 14 * s, 20 * s, 20 * s, col, 4 * s)
		_:
			ci.draw_arc(Vector2(x, y), 16 * s, PI, TAU, 16, col, 5 * s, true)
			ln(x, y, x, y + 16 * s, col, 3 * s)


func _psign() -> void:
	board(Color("efe6cc"))
	rr(80, 20, 800, 430, Color("1f3f7a"), 20)
	rr(96, 36, 768, 398, Color(1, 1, 1, 0.0), 16)
	for k in range(6):
		var x := 240 + (k % 3) * 240.0
		var y := 140 + floorf(k / 3.0) * 180.0
		praline(SHAPES[k], x, y, 3.0, COCOA.lightened(0.2))
		rr(x - 60, y + 60, 120, 44, WRAP_COL[WRAPS[k]], 6)


func _pcards() -> void:
	board(WOOD_D)
	var times: Array = clues.get("times", [])
	var symbols := ["cup", "bicycle", "hat", "umbrella"]
	for k in range(4):
		var x := 140 + k * 175.0
		rr(x, 60, 150, 360, CREAM, 6)
		_worker(symbols[k], x + 75, 120, 1.6, INK)
		for j in range(5):
			r(x + 16, 190 + j * 40, 118, 2, Color("c9b98a"))
		if k < times.size():
			var tm: Array = times[k]
			rr(x + 18, 196, 114, 34, Color(0.75, 0.2, 0.2, 0.15), 4)
			txt(x + 75, 222, "%d:%02d" % [int(tm[0]), int(tm[1])], 26, Color("8a2a2a"))


func _plocker() -> void:
	board(Color("efe6cc"))
	rr(250, 40, 460, 400, Color("5a6a7a"), 8)
	for j in range(5):
		r(300, 70 + j * 12, 360, 4, Color("4a5a6a"))
	rr(420, 140, 120, 70, CREAM, 6)
	_worker("hat", 480, 176, 1.6, INK)
	if flag("locker_open"):
		rr(280, 60, 400, 360, Color("1e2228"), 6)
		if not flag("got_locker"):
			item("torn2", 480, 240, 3.0)
	else:
		kit_wheels(st.get("locker", [0, 0, 0]), 400, 280)


func _pcab() -> void:
	board(Color("efe6cc"))
	rr(200, 40, 560, 400, WOOD, 12)
	if flag("cab_open"):
		rr(230, 80, 500, 320, Color("2a1a10"), 8)
		for k in range(4):
			praline(SHAPES[k], 300 + k * 120, 300, 2.0, Color("9a9aa2"))
		if not flag("got_cab"):
			item("torn3", 480, 180, 3.0)
		return
	var vals: Array = st.get("cab", [0, 0, 0, 0])
	for i in range(4):
		var cx := 360 + i * 80.0
		arrow_btn(cx - 30, 210, 60, 46, 0)
		rr(cx - 30, 262, 60, 80, CREAM, 6)
		praline(SHAPES[int(vals[i]) % 6], cx, 300, 1.4, COCOA)
		arrow_btn(cx - 30, 348, 60, 46, 1)


func _ptray() -> void:
	board(Color("efe6cc"))
	var x := Set5Views.TRAY_X
	var y := Set5Views.TRAY_Y
	var cell := Set5Views.TRAY_CELL
	var n := int(clues.get("tray", 5))
	rr(x - 14, y - 14, cell * n + 28, cell * n + 28, Color("7a7a7a"), 12)
	r(x, y, cell * n, cell * n, Color("c8c8c8"))
	for m in clues.get("moulds", []):
		c(x + (int(m[0]) + 0.5) * cell, y + (int(m[1]) + 0.5) * cell, cell * 0.36, Color("5a5a5a"))
		c(x + (int(m[0]) + 0.5) * cell, y + (int(m[1]) + 0.5) * cell, cell * 0.3, Color("3a3a3a"))
	for p in clues.get("pegs", []):
		c(x + (int(p[0]) + 0.5) * cell, y + (int(p[1]) + 0.5) * cell, cell * 0.22, STEEL.darkened(0.2))
		c(x + (int(p[0]) + 0.5) * cell - 4, y + (int(p[1]) + 0.5) * cell - 4, cell * 0.08, SILVER)
	var at_: Array = st.get("tray", [0, 0, 0, 0])
	for k in range(2):
		var px := x + (int(at_[k * 2]) + 0.5) * cell
		var py := y + (int(at_[k * 2 + 1]) + 0.5) * cell
		c(px, py, cell * 0.3, COCOA)
		c(px - 5, py - 5, cell * 0.08, COCOA.lightened(0.3))
	_tilt_arrows(x, y, cell * n)
	rr(730, 360, 200, 90, Color("7a7a7a"), 8)
	if flag("tray_done"):
		rr(744, 372, 172, 66, Color("2a2a2a"), 6)
		if not flag("got_tray"):
			item("torn4", 830, 405, 1.8)
	else:
		r(800, 396, 60, 12, Color("5a5a5a"))


func _recipe_piece(i: int, cx: float, cy: float, size: float) -> void:
	var temps: Array = clues.get("temps", [0, 0, 0])
	var rot := int(st.get("rot", [0, 0, 0, 0])[i])
	at(cx, cy, rot * PI / 2, 1.0)
	var h := size / 2.0
	poly([-h, -h, h, -h + 6, h - 4, h, -h + 6, h - 2], PAPER)
	if i < 3:
		# A thermometer, the step's dots, and the degrees.
		rr(-h + 24, -h + 30, 18, size - 70, CREAM, 8)
		ring(-h + 33, h - 36, 14, INK, 3)
		c(-h + 33, h - 36, 12, RED)
		var level := (int(temps[i]) - 20) / 30.0
		r(-h + 29, h - 40 - level * (size - 90), 8, level * (size - 90), RED)
		home()
		at(cx, cy, rot * PI / 2, 1.0)
		for k in range(i + 1):
			c(-10 + k * 22, -h + 40, 8, INK)
		ci.draw_string(font, Vector2(-30, 40), "%d°" % int(temps[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 56, INK)
	else:
		c(0, 0, 50, COCOA)
		c(-14, -14, 10, COCOA.lightened(0.3))
		praline("bean", 40, 60, 1.6, Color("6a4a2a"))
	home()


func _precipe() -> void:
	board(Color("efe6cc"))
	rr(240, 20, 480, 440, WOOD_D, 10)
	r(270, 30, 420, 420, Color("cbbf9a"))
	for i in range(4):
		var cx := 380 + (i % 2) * 200.0
		var cy := 136 + floorf(i / 2.0) * 200.0
		if flag("placed%d" % (i + 1)):
			_recipe_piece(i, cx, cy, 190)
		else:
			ring(cx, cy, 30, Color(0, 0, 0, 0.15), 4)


func _pkettle() -> void:
	board(COPPER_D)
	rr(160, 40, 640, 420, COPPER, 30)
	for g in range(3):
		_dots(g + 1, 320 + g * 160.0, 150, 8, INK)
	kit_wheels(st.get("kettle", [0, 0, 0, 0, 0, 0]), 280, 270)
	if flag("tempered"):
		rr(300, 420, 360, 24, COCOA, 10)


# --- Tinker & Sons ---------------------------------------------------------------

func _wallpaper() -> void:
	r(0, 0, 960, 372, XMAS_RED)
	for i in range(16):
		r(i * 60.0 + 28, 0, 4, 372, XMAS_RED_D)
	r(0, 372, 960, 100, Color("5a3a24"))
	for i in range(10):
		r(i * 96.0, 372, 2, 100, Color("4a2e1c"))


func _fir(x: float, top: float, base: float, lit: bool) -> void:
	var h := base - top
	for k in range(3):
		var ty := top + k * h * 0.25
		var w := h * (0.22 + k * 0.14)
		poly([x, ty, x + w, ty + h * 0.4, x - w, ty + h * 0.4], FIR if k % 2 == 0 else FIR_D)
	r(x - 8, base - 6, 16, 20, WOOD_D)
	if lit:
		_star5(x, top - 6, h * 0.08, GOLD)
		for k in range(12):
			var on := int(t * 2.0 + k) % 2 == 0
			var lx := x + (k % 5 - 2) * h * 0.08
			var ly := top + h * (0.25 + floorf(k / 5.0) * 0.22) + (k % 2) * 8
			c(lx, ly, 4, [Color("ffd45a"), Color("ff5a5a"), Color("6ad0ff")][k % 3] if on else Color(1, 1, 1, 0.25))


func _y1() -> void:
	_wallpaper()
	# Shop window with snow outside, the tree and the train.
	rr(32, 32, 376, 296, WOOD_D, 8)
	r(44, 44, 352, 272, Color("1c2a4a"))
	for k in range(20):
		c(50 + (k * 67) % 340, fmod(50.0 + k * 41 + t * 20.0, 260.0) + 50, 2.5, SNOW)
	_fir(200, 64, 270, flag("tree_lit"))
	ci.draw_set_transform(Vector2(200, 310), 0.0, Vector2(1.0, 0.25))
	ring(0, 0, 140, STEEL, 6)
	home()
	var a := t * 0.8 if flag("train_on") else 2.2
	var tx := 200 + cos(a) * 140
	var ty := 310 + sin(a) * 35
	rr(tx - 20, ty - 18, 40, 22, RED, 4)
	r(tx - 6, ty - 28, 10, 12, IRON_D)
	# Presents beside the tree.
	for k in range(3):
		rr(290 + k * 36, 236 - k * 6, 32, 34 + k * 6, [Color("2f6fc0"), GOLD, LEAF][k], 3)
	# Counter with the till and the notebook.
	rr(480, 230, 320, 142, WOOD, 6)
	r(480, 230, 320, 12, WOOD_D)
	rr(550, 170, 120, 70, BRASS_D, 8)
	rr(566, 180, 88, 26, Color("2a2a2a"), 4)
	if flag("gifts_ok"):
		rr(550, 232, 120, 18, BRASS, 4)
	rr(705, 206, 80, 34, CREAM, 3)
	r(742, 206, 3, 34, INK)
	# Door with a bell.
	rr(820, 60, 130, 312, WOOD_D, 6)
	rr(836, 80, 98, 120, Color(0.6, 0.75, 0.9, 0.5), 4)
	c(930, 220, 8, BRASS)
	c(880, 40, 14, GOLD)
	r(878, 20, 4, 10, INK)


func _y2() -> void:
	_wallpaper()
	# The wall of little drawers.
	rr(50, 50, 260, 200, WOOD_D, 6)
	for i in range(12):
		var dx := 60 + (i % 4) * 62.0
		var dy := 60 + floorf(i / 4.0) * 62.0
		rr(dx, dy, 56, 56, WOOD, 4)
		c(dx + 28, dy + 28, 5, BRASS)
	# The dollhouse: a tiny copy of this shop.
	rr(360, 160, 220, 170, Color("e8d0b0"), 4)
	poly([350, 160, 470, 100, 590, 160], XMAS_RED_D)
	r(468, 160, 4, 170, Color("b09070"))
	for k in range(6):
		r(372 + (k % 3) * 22.0, 180 + floorf(k / 3.0) * 22.0, 18, 18, WOOD)
	_fir(530, 200, 290, flag("tree_lit"))
	r(350, 330, 240, 10, WOOD_D)
	# Labyrinth game.
	rr(640, 260, 180, 100, WOOD, 8)
	r(656, 272, 148, 76, Color("c8a878"))
	for k in range(4):
		r(670 + k * 34, 280 + (k % 2) * 30, 12, 12, WOOD_D)
	# Nutcracker.
	rr(872, 140, 56, 60, XMAS_RED, 8)
	c(900, 130, 22, Color("f0d0b0"))
	r(878, 100, 44, 22, IRON_D)
	r(880, 200, 18, 110, Color("2f3f7a"))
	r(902, 200, 18, 110, Color("2f3f7a"))
	r(888, 140, 24, 6, CREAM)
	# Teddy bear and a rocking horse; a shelf of toys.
	c(105, 330, 36, Color("a0703a"))
	c(105, 290, 24, Color("a0703a"))
	c(88, 272, 9, Color("a0703a"))
	c(122, 272, 9, Color("a0703a"))
	ci.draw_arc(Vector2(250, 330), 70, 0.3, PI - 0.3, 16, WOOD_D, 6, true)
	rr(200, 290, 100, 30, Color("e0d8c8"), 10)
	c(300, 284, 16, Color("e0d8c8"))
	r(630, 160, 200, 8, WOOD_D)
	for k in range(5):
		rr(640 + k * 38, 110, 30, 50, [RED, Color("2f6fc0"), GOLD, LEAF, VIOLET][k], 4)


func _ydrawers() -> void:
	board(WOOD_D)
	for i in range(12):
		var x := 150 + (i % 4) * 165.0
		var y := 40 + floorf(i / 4.0) * 135.0
		rr(x, y, 156, 126, WOOD, 8)
		rr(x + 10, y + 10, 136, 106, WOOD.lightened(0.05), 6)
		rr(x + 58, y + 82, 40, 14, BRASS, 6)
		picto_toy(["teddy", "drum", "horse", "kite"][i % 4], x + 78, y + 46, 0.9, Color(0, 0, 0, 0.25))


func picto_toy(kind: String, x: float, y: float, s: float, col: Color) -> void:
	match kind:
		"teddy":
			c(x, y + 6 * s, 16 * s, col)
			c(x, y - 14 * s, 11 * s, col)
			c(x - 10 * s, y - 22 * s, 5 * s, col)
			c(x + 10 * s, y - 22 * s, 5 * s, col)
		"drum":
			rr(x - 18 * s, y - 10 * s, 36 * s, 24 * s, col, 3 * s)
			ci.draw_set_transform(Vector2(x, y - 10 * s), 0.0, Vector2(1.0, 0.35))
			c(0, 0, 18 * s, col.lightened(0.35))
			home()
			for k in range(4):
				ln(x - 18 * s + k * 9 * s, y - 6 * s, x - 13.5 * s + k * 9 * s, y + 12 * s, CREAM, 1.5 * s)
				ln(x - 13.5 * s + k * 9 * s, y + 12 * s, x - 9 * s + k * 9 * s, y - 6 * s, CREAM, 1.5 * s)
			ln(x - 8 * s, y - 28 * s, x + 2 * s, y - 14 * s, col, 3 * s)
			ln(x + 12 * s, y - 28 * s, x + 4 * s, y - 14 * s, col, 3 * s)
		"horse":
			ci.draw_arc(Vector2(x, y + 22 * s), 24 * s, PI + 0.4, TAU - 0.4, 12, col, 4 * s, true)
			rr(x - 16 * s, y - 6 * s, 30 * s, 14 * s, col, 6 * s)
			poly([x + 10 * s, y - 4 * s, x + 18 * s, y - 24 * s, x + 26 * s, y - 16 * s, x + 16 * s, y + 2 * s], col)
			ln(x - 12 * s, y + 6 * s, x - 14 * s, y + 18 * s, col, 3 * s)
			ln(x + 10 * s, y + 6 * s, x + 12 * s, y + 18 * s, col, 3 * s)
		_:
			poly([x, y - 22 * s, x + 16 * s, y, x, y + 16 * s, x - 16 * s, y], col)
			ln(x, y + 16 * s, x - 8 * s, y + 30 * s, col, 2 * s)


func child(kind: String, x: float, y: float, s: float) -> void:
	var skin := Color("f2c8a0")
	match kind:
		"pigtails":
			c(x - 20 * s, y + 4 * s, 8 * s, Color("8a4a1a"))
			c(x + 20 * s, y + 4 * s, 8 * s, Color("8a4a1a"))
		"bonnet":
			c(x, y, 24 * s, Color("f0f0ff"))
	c(x, y, 18 * s, skin)
	c(x - 6 * s, y - 2 * s, 2.5 * s, INK)
	c(x + 6 * s, y - 2 * s, 2.5 * s, INK)
	ci.draw_arc(Vector2(x, y + 4 * s), 7 * s, 0.4, PI - 0.4, 8, INK, 2 * s, true)
	match kind:
		"cap":
			ci.draw_arc(Vector2(x, y - 6 * s), 18 * s, PI, TAU, 12, Color("2f6fc0"), 8 * s, true)
			rr(x, y - 12 * s, 26 * s, 6 * s, Color("2f6fc0"), 3 * s)
		"pigtails":
			ci.draw_arc(Vector2(x, y - 4 * s), 18 * s, PI, TAU, 12, Color("8a4a1a"), 8 * s, true)
		"glasses":
			ci.draw_arc(Vector2(x, y - 6 * s), 18 * s, PI, TAU, 12, Color("2a2a2a"), 6 * s, true)
			ring(x - 7 * s, y - 2 * s, 6 * s, INK, 2 * s)
			ring(x + 7 * s, y - 2 * s, 6 * s, INK, 2 * s)
			ln(x - 1 * s, y - 2 * s, x + 1 * s, y - 2 * s, INK, 2 * s)


const CHILDREN := ["cap", "pigtails", "glasses", "bonnet"]
const TOYS := ["teddy", "drum", "horse", "kite"]


func _ydoll() -> void:
	board(XMAS_RED_D)
	# The dollhouse opened up: the same shop, tiny, its two rooms side by side.
	rr(120, 20, 720, 440, Color("e8d0b0"), 8)
	r(478, 20, 4, 440, Color("b09070"))
	r(120, 380, 720, 80, Color("a07a50"))
	# Left room: the window display, the counter and the till.
	_fir(220, 120, 300, flag("tree_lit"))
	rr(320, 260, 140, 120, WOOD, 4)
	rr(350, 220, 70, 44, BRASS_D, 4)
	if flag("gifts_ok"):
		rr(350, 262, 70, 10, BRASS, 3)
	# Right room: the wall of drawers (one ajar), the labyrinth, the nutcracker.
	var ajar := int(clues.get("ajar", 6))
	for i in range(12):
		var dx := 520 + (i % 4) * 46.0
		var dy := 80 + floorf(i / 4.0) * 46.0
		rr(dx, dy, 42, 42, WOOD, 3)
		if i == ajar and not flag("got_wind"):
			rr(dx - 3, dy + 4, 48, 38, WOOD.lightened(0.15), 3)
			r(dx, dy + 2, 42, 4, INK)
		c(dx + 21, dy + 21, 3, BRASS)
	rr(560, 300, 120, 70, WOOD, 6)
	rr(740, 220, 30, 40, XMAS_RED, 4)
	c(755, 212, 12, Color("f0d0b0"))


func _ytrain() -> void:
	board(Color("1c2a4a"))
	r(0, 380, 960, 92, Color("e8e8f0"))
	_fir(340, 30, 330, flag("tree_lit"))
	ci.draw_set_transform(Vector2(340, 360), 0.0, Vector2(1.0, 0.22))
	ring(0, 0, 280, STEEL, 10)
	home()
	var running := flag("train_on")
	var a := t * 0.9 if running else 0.4
	for k in range(3):
		var ak := a - k * 0.32
		var tx := 340 + cos(ak) * 280
		var ty := 360 + sin(ak) * 62
		if k == 0:
			rr(tx - 34, ty - 34, 68, 40, RED, 6)
			r(tx - 12, ty - 54, 18, 22, IRON_D)
		else:
			rr(tx - 30, ty - 26, 60, 32, [GOLD, LEAF][k - 1], 4)
			if k == 2 and not running:
				item("walnut", tx, ty - 32, 1.0)
	# The little station.
	rr(680, 300, 200, 50, Color("b0a090"), 6)
	poly([670, 260, 780, 230, 890, 260], XMAS_RED)
	r(690, 260, 8, 40, WOOD_D)
	r(862, 260, 8, 40, WOOD_D)
	if running and not flag("got_walnut"):
		item("walnut", 780, 290, 1.6)


func _ygifts() -> void:
	board(Color("2a1c14"))
	var gifts: Array = st.get("gifts", [0, 1, 2, 3])
	var cols := [Color("2f6fc0"), GOLD, LEAF, VIOLET]
	for i in range(4):
		var x := 70 + i * 215.0
		rr(x, 200, 180, 220, cols[i], 6)
		r(x + 80, 200, 20, 220, CREAM)
		r(x, 290, 180, 20, CREAM)
		# The tag with the child, the label with the toy.
		rr(x + 30, 110, 120, 80, PAPER, 6)
		child(CHILDREN[i], x + 90, 150, 1.2)
		rr(x + 40, 320, 100, 90, PAPER, 8)
		picto_toy(TOYS[int(gifts[i]) % 4], x + 90, 368, 1.4, INK)
	if not flag("tree_lit"):
		r(0, 0, 960, 472, Color(0, 0, 0, 0.78))


func _ynotes() -> void:
	board(WOOD_D)
	rr(140, 20, 680, 440, PAPER, 6)
	for j in range(12):
		r(160, 50 + j * 34.0, 640, 2, Color("c9d8e8"))
	var crossed: Array = clues.get("crossed", [])
	for k in range(crossed.size()):
		var x := 230 + (k % 2) * 330.0
		var y := 90 + floorf(k / 2.0) * 130.0
		var pair: Array = crossed[k]
		child(CHILDREN[int(pair[0])], x, y, 1.3)
		ln(x + 66, y - 18, x + 102, y + 18, RED, 6)
		ln(x + 102, y - 18, x + 66, y + 18, RED, 6)
		picto_toy(TOYS[int(pair[1])], x + 170, y, 1.3, INK)


func _ymaze() -> void:
	board(XMAS_RED_D)
	var x := Set5Views.MAZE_X
	var y := Set5Views.MAZE_Y
	var cell := Set5Views.MAZE_CELL
	var n := int(clues.get("maze", 6))
	rr(x - 16, y - 16, cell * n + 32, cell * n + 32, WOOD, 12)
	r(x, y, cell * n, cell * n, Color("d8b888"))
	for k in range(n + 1):
		r(x + k * cell, y, 1, cell * n, Color("c0a070"))
		r(x, y + k * cell, cell * n, 1, Color("c0a070"))
	var hole: Array = clues.get("hole", [0, 0])
	c(x + (int(hole[0]) + 0.5) * cell, y + (int(hole[1]) + 0.5) * cell, cell * 0.34, Color("2a1a10"))
	for p in clues.get("pegs", []):
		rr(x + int(p[0]) * cell + 6, y + int(p[1]) * cell + 6, cell - 12, cell - 12, WOOD_D, 6)
	if flag("marble_in") and not flag("maze_done"):
		var b: Array = st.get("ball", [0, 0])
		item("marble", x + (int(b[0]) + 0.5) * cell, y + (int(b[1]) + 0.5) * cell, 1.8)
	_tilt_arrows(x, y, cell * n)
	rr(730, 360, 200, 90, WOOD, 8)
	if flag("maze_done"):
		rr(744, 372, 172, 66, Color("2a1a10"), 6)
		if not flag("got_star"):
			item("star", 830, 405, 1.6)
	else:
		r(800, 396, 60, 12, WOOD_D)
