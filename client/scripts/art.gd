## Draws every view of the hut with Godot's canvas calls (no image files).
## The scene is 960 x 472; the darkness and the pools of light come on top
## (light.gdshader). What the clues show comes from the rules ("clues").
class_name Art
extends RefCounted

const WALL := Color("a8774a")
const WALL2 := Color("8f6238")
const FLOOR := Color("6b482b")
const FLOOR2 := Color("573920")
const WOOD := Color("7b4a26")
const WOOD_D := Color("5a3619")
const IRON := Color("39404a")
const IRON_D := Color("262b33")
const BRASS := Color("d8b04e")
const BRASS_D := Color("a07d2c")
const PAPER := Color("efe2bd")
const INK := Color("3a2c22")
const RED := Color("b6453a")
const CREAM := Color("f3e6c4")
const GREEN := Color("3f5f57")
const GREEN_D := Color("2c443e")
const NIGHT := Color("24384f")
const SNOW := Color("e8f0f6")
const FIRE := Color("f6a23a")
const AMBER := Color("ffc24a")
const STEEL := Color("7d8791")

var ci: CanvasItem
var st: Dictionary = {}
var clues: Dictionary = {}
var t := 0.0
var font: Font
var _boxes: Dictionary = {}


func flag(name: String) -> bool:
	return st.get("flags", []).has(name)


# --- Primitives ---------------------------------------------------------------

func r(x: float, y: float, w: float, h: float, col: Color) -> void:
	ci.draw_rect(Rect2(x, y, w, h), col)


func rr(x: float, y: float, w: float, h: float, col: Color, rad: float = 6.0) -> void:
	var key := "%s/%d" % [col.to_html(), int(rad)]
	if not _boxes.has(key):
		var box := StyleBoxFlat.new()
		box.bg_color = col
		box.set_corner_radius_all(int(rad))
		box.anti_aliasing = true
		_boxes[key] = box
	ci.draw_style_box(_boxes[key], Rect2(x, y, w, h))


func poly(points: Array, col: Color) -> void:
	var p := PackedVector2Array()
	for i in range(0, points.size(), 2):
		p.append(Vector2(points[i], points[i + 1]))
	ci.draw_colored_polygon(p, col)


func c(x: float, y: float, rad: float, col: Color) -> void:
	ci.draw_circle(Vector2(x, y), rad, col)


func ring(x: float, y: float, rad: float, col: Color, w: float) -> void:
	ci.draw_arc(Vector2(x, y), rad, 0.0, TAU, 48, col, w, true)


func ln(x1: float, y1: float, x2: float, y2: float, col: Color, w: float = 2.0) -> void:
	ci.draw_line(Vector2(x1, y1), Vector2(x2, y2), col, w, true)


func txt(x: float, y: float, text: String, size: int, col: Color, centred: bool = true) -> void:
	var width := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
	var left := x - width / 2.0 if centred else x
	ci.draw_string(font, Vector2(left, y), text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)


func at(x: float, y: float, rot: float = 0.0, s: float = 1.0) -> void:
	ci.draw_set_transform(Vector2(x, y), rot, Vector2(s, s))


func home() -> void:
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


# --- Shared pieces --------------------------------------------------------------

func wall(tint: Color = WALL) -> void:
	r(0, 0, 960, 372, tint)
	var seam := tint.darkened(0.16)
	for i in range(8):
		r(0, i * 46.5, 960, 2.5, seam)
		for j in range(3):
			r(float((i * 137 + j * 331) % 960), i * 46.5, 2, 46, seam)
	r(0, 372, 960, 100, FLOOR)
	for i in range(9):
		ln(i * 120 - 20, 372, i * 150 - 150, 472, FLOOR2, 2)
	r(0, 368, 960, 6, WOOD_D)


func board(col: Color = Color("3b2a1e")) -> void:
	r(0, 0, 960, 472, col)
	for i in range(6):
		r(0, i * 80 + 30, 960, 2, col.darkened(0.2))


func door(x: float, y: float, w: float, h: float) -> void:
	r(x, y, w, h, WOOD_D)
	r(x + 10, y + 10, w - 20, h - 10, WOOD)
	for k in [0.33, 0.66]:
		r(x + 10 + (w - 20) * k, y + 10, 2.5, h - 10, WOOD_D)
	r(x + 10, y + 94, w - 20, 2.5, WOOD_D)
	r(x + 10, y + 180, w - 20, 2.5, WOOD_D)
	rr(x + 20, y + 118, 26, 40, IRON, 4)
	c(x + 33, y + 130, 6, BRASS)
	r(x + 31, y + 138, 4, 12, IRON_D)


func arrow_btn(x: float, y: float, w: float, h: float, dir: int) -> void:
	rr(x, y, w, h, Color(0, 0, 0, 0.35), 10)
	var cx := x + w / 2.0
	var cy := y + h / 2.0
	match dir:
		0:
			poly([cx, cy - 12, cx + 14, cy + 9, cx - 14, cy + 9], CREAM)
		1:
			poly([cx, cy + 12, cx + 14, cy - 9, cx - 14, cy - 9], CREAM)
		2:
			poly([cx - 12, cy, cx + 9, cy - 14, cx + 9, cy + 14], CREAM)
		_:
			poly([cx + 12, cy, cx - 9, cy - 14, cx - 9, cy + 14], CREAM)


## The three things counted for the cupboard lock.
func picto(name: String, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match name:
		"hat":
			var dome := []
			for i in range(13):
				var a := PI + PI * i / 12.0
				dome.append_array([cos(a) * 12.0, sin(a) * 13.0 + 6.0])
			poly(dome, col)
			rr(-14, 5, 28, 7, col, 3)
			c(0, -9, 4, col)
		"mug":
			rr(-10, -10, 18, 22, col, 3)
			ci.draw_arc(Vector2(9, 1), 6, -PI / 2, PI / 2, 12, col, 3, true)
		"axe":
			ln(0, -12, 0, 14, col, 3)
			poly([-13, -8, 10, -14, 10, -9, -13, -5], col)
			poly([-2, 14, 2, 14, 0, 19], col)
	home()


func weather(name: String, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	if name == "sun":
		c(0, 0, 7, col)
		for i in range(8):
			var a := TAU * i / 8.0
			ln(cos(a) * 10, sin(a) * 10, cos(a) * 14, sin(a) * 14, col, 2)
	else:
		c(-6, 0, 6, col)
		c(2, -4, 8, col)
		c(9, 1, 5, col)
		rr(-12, 0, 26, 7, col, 3)
		match name:
			"rain":
				for k in [-7, 0, 7]:
					ln(k, 10, k - 3, 16, col, 2)
			"snow":
				for k in [-7, 0, 7]:
					c(k, 13, 2, col)
			"storm":
				poly([2, 8, -5, 16, 0, 16, -3, 23, 6, 13, 1, 13], col)
	home()


func bird(x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	c(0, 0, 8, col)
	c(8, -6, 5, col)
	poly([12, -7, 19, -5, 12, -3], col)
	poly([-6, -2, -17, -7, -15, 3], col)
	ln(-1, 7, -1, 13, col, 2)
	ln(3, 7, 3, 13, col, 2)
	home()


func hut_picto(x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	poly([-14, 0, 0, -13, 14, 0], col)
	r(-10, 0, 20, 12, col)
	home()


## An inventory item, about 40 px across at s = 1.
func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	at(x, y, 0.0, s)
	match name:
		"matches":
			rr(-17, -11, 34, 22, RED, 3)
			r(-17, -4, 34, 9, CREAM)
			ln(-10, 6, 12, -14, Color("e2c58f"), 3)
			c(12, -14, 3, Color("7a2a22"))
		"kindling":
			for k in range(5):
				ln(-16 + k * 3, 12 - k * 2, 12 + k * 2, -14 + k * 3, Color("c79a5f").darkened(k * 0.06), 4)
			r(-5, -4, 8, 10, RED)
		"log":
			rr(-18, -9, 36, 18, Color("7a5230"), 8)
			c(13, 0, 8, Color("d2a871"))
			ring(13, 0, 4, Color("a67c4a"), 1.5)
		"bucket":
			poly([-15, -10, 15, -10, 11, 16, -11, 16], STEEL)
			poly([-15, -10, 15, -10, 13, -3, -13, -3], SNOW)
			ci.draw_arc(Vector2(0, -10), 15, PI, TAU, 16, IRON, 2, true)
			c(3, 4, 2, AMBER)
		"key", "dkey":
			var col := BRASS if name == "key" else Color("c9ced4")
			var k := 1.0 if name == "key" else 0.75
			ring(-10 * k, 0, 7 * k, col, 4 * k)
			ln(-3 * k, 0, 17 * k, 0, col, 4 * k)
			ln(11 * k, 0, 11 * k, 7 * k, col, 4 * k)
			ln(16 * k, 0, 16 * k, 6 * k, col, 4 * k)
		"paper":
			rr(-14, -17, 28, 34, Color(0.96, 0.95, 0.9), 2)
			for p in [[-6, -8], [5, -2], [-3, 6], [7, 10]]:
				c(p[0], p[1], 3, Color("3b2a1e"))
		"fuse":
			rr(-15, -6, 30, 12, Color(0.8, 0.9, 0.95, 0.9), 5)
			rr(-18, -7, 9, 14, STEEL, 2)
			rr(9, -7, 9, 14, STEEL, 2)
			ln(-9, 0, 9, 0, IRON, 1.5)
		"crank":
			ln(-14, 10, -14, -8, STEEL, 5)
			ln(-14, -8, 8, -8, STEEL, 5)
			rr(4, -14, 12, 24, WOOD_D, 4)
			r(-18, 8, 8, 8, IRON)
	home()


# --- Views ------------------------------------------------------------------------

func draw_view(view: String) -> void:
	match view:
		"A": _view_a()
		"B": _view_b()
		"C": _view_c()
		"D": _view_d()
		"E": _view_e()
		"lock": _lock()
		"logbook": _logbook()
		"clock": _clock()
		"baro": _baro()
		"map": _map()
		"safe": _safe()
		"radio": _radio()
		"wiring": _wiring()
	home()


func _snow_window(x: float, y: float, w: float, h: float) -> void:
	r(x, y, w, h, WOOD_D)
	r(x + 14, y + 14, w - 28, h - 28, NIGHT)
	for i in range(34):
		var sx := x + 16 + fmod(i * 53.0 + t * (14.0 + i % 5 * 5.0), w - 34)
		var sy := y + 16 + fmod(i * 37.0 + t * (26.0 + i % 4 * 9.0), h - 34)
		c(sx, sy, 1.4 + (i % 3) * 0.8, Color(0.85, 0.9, 1.0, 0.85))
	poly([x + 14, y + h - 14, x + 14, y + h - 44, x + w * 0.3, y + h - 62, x + w * 0.5, y + h - 48,
		x + w * 0.75, y + h - 70, x + w - 14, y + h - 52, x + w - 14, y + h - 14], Color("9fb7cc"))
	r(x + w / 2 - 3, y + 14, 6, h - 28, WOOD_D)
	r(x + 14, y + h / 2 - 3, w - 28, 6, WOOD_D)


func _view_a() -> void:
	wall()
	_snow_window(60, 92, 170, 150)
	# Coat on its peg.
	c(281, 118, 5, IRON)
	poly([262, 124, 300, 124, 318, 150, 314, 300, 248, 300, 244, 150], GREEN)
	poly([274, 124, 288, 124, 281, 150], GREEN_D)
	r(280, 150, 2, 150, GREEN_D)
	rr(288, 222, 22, 26, GREEN_D, 3)
	if not flag("got_matches"):
		r(293, 218, 12, 6, RED)
	# Stove.
	r(380, 0, 30, 232, IRON.lightened(0.08))
	rr(340, 230, 110, 150, IRON, 10)
	rr(332, 222, 126, 16, IRON_D, 5)
	rr(358, 268, 74, 60, IRON_D, 8)
	if flag("stove_wood"):
		rr(366, 308, 58, 14, Color("7a5230"), 6)
	if flag("stove_kindling"):
		for k in range(4):
			ln(372 + k * 12, 310, 380 + k * 10, 292, Color("c79a5f"), 3)
	if flag("stove_lit"):
		var f := 4.0 * sin(t * 9.0)
		var g := 4.0 * sin(t * 13.0 + 1.0)
		poly([364, 324, 372, 300 + g, 382, 310, 392, 276 + f, 404, 306, 414, 290 - g, 426, 324], FIRE)
		poly([378, 324, 386, 308 + f, 394, 314, 400, 296 - g, 410, 324], AMBER)
	r(350, 380, 12, 16, IRON_D)
	r(428, 380, 12, 16, IRON_D)
	if flag("bucket_melted"):
		poly([372, 190, 418, 190, 412, 222, 378, 222], STEEL)
		poly([372, 190, 418, 190, 416, 197, 374, 197], Color("7fb2d6"))
	# Ice axes on their rack.
	rr(500, 84, 190, 12, WOOD_D, 3)
	for i in range(int(clues.get("counts", {}).get("axe", 0))):
		var ax := 532.0 + i * 63.0
		ln(ax, 92, ax, 176, Color("c9a26a"), 5)
		poly([ax - 24, 100, ax + 16, 90, ax + 16, 99, ax - 24, 106], STEEL)
		poly([ax - 3, 176, ax + 3, 176, ax, 186], STEEL)
	# Table and lamp.
	rr(500, 300, 190, 14, WOOD, 3)
	r(512, 314, 12, 80, WOOD)
	r(666, 314, 12, 80, WOOD)
	rr(623, 286, 34, 14, BRASS, 4)
	poly([629, 286, 625, 262, 640, 246, 655, 262, 651, 286], Color(0.75, 0.88, 0.95, 0.55))
	r(636, 240, 8, 8, BRASS_D)
	if flag("lamp_lit"):
		poly([640, 258 + 2 * sin(t * 11.0), 646, 276, 640, 284, 634, 276], Color("fff1a8"))
	# Rug.
	rr(380, 404, 320, 44, RED.darkened(0.15), 22)
	rr(410, 414, 260, 24, RED, 12)
	# Front door, frozen, and the altitude sign over it.
	door(780, 110, 130, 264)
	poly([780, 110, 910, 110, 910, 128, 880, 122, 850, 134, 815, 120, 780, 132], Color(0.9, 0.95, 1, 0.8))
	poly([780, 374, 800, 356, 850, 350, 912, 362, 912, 374], SNOW)
	rr(788, 64, 114, 36, CREAM, 4)
	txt(845, 90, "%d m" % int(clues.get("altitude", 0)), 22, INK)


func _hat(x: float, y: float, col: Color) -> void:
	var dome := []
	for i in range(13):
		var a := PI + PI * i / 12.0
		dome.append_array([x + cos(a) * 22.0, y + 30 + sin(a) * 26.0])
	poly(dome, col)
	rr(x - 25, y + 28, 50, 12, col.lightened(0.25), 5)
	c(x, y + 2, 7, col.lightened(0.35))


func _view_b() -> void:
	wall()
	# Bunks.
	for y in [150.0, 280.0]:
		rr(50, y, 360, 22, CREAM.darkened(0.1), 6)
		rr(50, y + 18, 360, 14, WOOD_D, 2)
		rr(60, y - 14, 70, 18, SNOW, 8)
		rr(170, y - 6, 240, 12, RED if y < 200.0 else GREEN, 5)
	r(42, 100, 14, 280, WOOD)
	r(404, 100, 14, 280, WOOD)
	ln(330, 168, 330, 380, WOOD_D, 5)
	ln(366, 168, 366, 380, WOOD_D, 5)
	for k in range(5):
		ln(330, 200 + k * 36, 366, 200 + k * 36, WOOD_D, 4)
	# Hats on pegs.
	rr(470, 100, 250, 10, WOOD_D, 3)
	var hats := int(clues.get("counts", {}).get("hat", 0))
	var colours := [RED, Color("2f6d8a"), Color("d6a23a"), Color("5c7d3e"), Color("8a4f7d")]
	for i in range(hats):
		_hat(505.0 + i * 60.0, 104, colours[i % colours.size()])
	# Boots.
	rr(480, 356, 220, 8, WOOD_D, 2)
	for i in range(3):
		var bx := 496.0 + i * 70.0
		for d in [0.0, 26.0]:
			rr(bx + d, 318, 16, 38, Color("4a3628"), 4)
			rr(bx + d, 342, 26, 14, Color("4a3628"), 5)
	# Door to the warden's room.
	if flag("door2_open"):
		r(760, 110, 130, 264, WOOD_D)
		r(770, 120, 110, 254, Color("f0b060"))
		poly([770, 120, 800, 132, 800, 374, 770, 374], WOOD)
	else:
		door(760, 110, 130, 264)
	if not flag("door2_open"):
		rr(796, 150, 58, 26, BRASS, 3)
		ring(815, 163, 4, INK, 2)
		ln(819, 163, 836, 163, INK, 2)


func _view_c() -> void:
	wall()
	# Cupboard.
	rr(60, 150, 200, 226, WOOD_D, 4)
	if flag("cup_open"):
		r(70, 160, 180, 206, Color("2a1c12"))
		r(70, 258, 180, 5, WOOD_D)
		if not flag("got_kindling"):
			item("kindling", 160, 236, 1.6)
		poly([70, 160, 40, 172, 40, 378, 70, 366], WOOD)
		poly([250, 160, 280, 172, 280, 378, 250, 366], WOOD)
	else:
		r(70, 160, 88, 206, WOOD)
		r(162, 160, 88, 206, WOOD)
		rr(118, 176, 84, 42, PAPER, 2)
		var order: Array = clues.get("count_order", [])
		for i in range(order.size()):
			picto(order[i], 136.0 + i * 24.0, 198, 0.62, INK)
		ci.draw_arc(Vector2(160, 262), 10, PI, TAU, 12, STEEL, 4, true)
		rr(146, 262, 28, 24, BRASS, 4)
	# Mugs.
	rr(320, 170, 330, 10, WOOD_D, 3)
	var mugs := int(clues.get("counts", {}).get("mug", 0))
	var colours := [CREAM, RED, Color("2f6d8a"), CREAM, Color("d6a23a"), GREEN, RED]
	for i in range(mugs):
		var mx := 336.0 + i * 44.0
		rr(mx, 142, 24, 28, colours[i % colours.size()], 4)
		ci.draw_arc(Vector2(mx + 25, 156), 7, -PI / 2, PI / 2, 12, colours[i % colours.size()], 4, true)
	# Emergency poster: radio.
	rr(700, 80, 160, 140, PAPER, 3)
	poly([780, 96, 806, 140, 754, 140], RED)
	txt(780, 136, "!", 28, PAPER)
	rr(748, 160, 64, 36, INK, 5)
	c(764, 178, 9, PAPER)
	ln(800, 160, 816, 140, INK, 3)
	# Wood box.
	rr(330, 300, 150, 76, WOOD, 4)
	r(330, 330, 150, 4, WOOD_D)
	for i in range(4):
		c(352.0 + i * 36.0, 296, 15, Color("d2a871"))
		ring(352.0 + i * 36.0, 296, 15, Color("7a5230"), 4)
		ring(352.0 + i * 36.0, 296, 7, Color("a67c4a"), 1.5)
	# Bucket of ice.
	if not flag("got_bucket"):
		poly([540, 314, 620, 314, 610, 374, 550, 374], STEEL)
		poly([540, 314, 620, 314, 617, 330, 543, 330], SNOW)
		ci.draw_arc(Vector2(580, 314), 40, PI, TAU, 20, IRON, 3, true)
		c(588, 322, 3, AMBER)


func _view_d() -> void:
	wall(Color("9c7350"))
	# Hanging lamp.
	ln(480, 0, 480, 44, IRON_D, 3)
	poly([456, 62, 468, 44, 492, 44, 504, 62], GREEN)
	c(480, 66, 8, Color("fff1a8"))
	# Barometer.
	c(170, 150, 52, BRASS_D)
	c(170, 150, 44, BRASS)
	c(170, 150, 34, CREAM)
	ln(170, 150, 150, 128, INK, 2.5)
	c(170, 150, 4, INK)
	# Photo.
	rr(740, 100, 120, 90, WOOD_D, 3)
	r(750, 110, 100, 70, Color("c9c2ad"))
	c(790, 136, 10, INK)
	rr(780, 146, 20, 34, INK, 5)
	poly([812, 150, 824, 138, 836, 150], WOOD)
	r(814, 150, 20, 22, WOOD)
	# Desk.
	rr(300, 290, 400, 16, WOOD, 3)
	r(312, 306, 20, 70, WOOD_D)
	rr(540, 306, 150, 70, WOOD_D, 3)
	if flag("drawer_open"):
		rr(548, 316, 134, 40, Color("2a1c12"), 3)
		rr(544, 340, 142, 30, WOOD, 3)
	else:
		rr(552, 314, 126, 32, WOOD, 3)
		c(615, 330, 5, BRASS)
		r(614, 330, 2, 8, INK)
	# Log book.
	poly([330, 290, 340, 270, 382, 272, 380, 290], PAPER)
	poly([380, 290, 382, 272, 424, 270, 432, 290], PAPER.darkened(0.06))
	for k in range(3):
		ln(346, 277 + k * 4, 374, 278 + k * 4, INK.lightened(0.3), 1)
	# Radio.
	ln(616, 206, 640, 120, IRON_D, 2)
	ln(640, 120, 640, 0, IRON_D, 2)
	rr(450, 206, 180, 84, GREEN, 8)
	rr(520, 220, 96, 28, AMBER if st.get("power", false) else Color("1c2422"), 4)
	rr(462, 220, 46, 56, GREEN_D, 4)
	for k in range(4):
		r(468, 228 + k * 11, 34, 3, GREEN)
	for k in range(3):
		c(536.0 + k * 32.0, 268, 9, CREAM.darkened(0.15))
	if flag("crank_on"):
		ln(630, 250, 650, 250, STEEL, 5)
		ln(650, 250, 650, 226, STEEL, 5)
		rr(644, 210, 12, 20, WOOD_D, 4)


func _view_e() -> void:
	wall(Color("9c7350"))
	# Map.
	rr(60, 60, 300, 180, PAPER, 2)
	poly([84, 214, 130, 130, 160, 170, 210, 96, 270, 214], Color("b9c79b"))
	ln(84, 214, 130, 130, Color("6f8a52"), 3)
	ln(130, 130, 160, 170, Color("6f8a52"), 3)
	ln(160, 170, 210, 96, Color("6f8a52"), 3)
	ln(210, 96, 270, 214, Color("6f8a52"), 3)
	c(310, 190, 16, Color("7fb2d6"))
	if flag("map_overlay"):
		rr(60, 60, 300, 180, Color(1, 1, 1, 0.7), 2)
		for p in [[130, 110], [300, 180], [110, 200], [290, 110]]:
			c(p[0], p[1], 7, Color("3b2a1e"))
	# Strongbox on a cabinet.
	rr(130, 314, 170, 62, WOOD_D, 3)
	r(140, 324, 150, 44, WOOD)
	rr(160, 268, 110, 46, STEEL, 4)
	if flag("safe_open"):
		r(170, 276, 90, 32, IRON_D)
	else:
		for k in range(4):
			rr(176.0 + k * 20.0, 282, 16, 20, CREAM, 2)
	# Cuckoo clock.
	poly([420, 132, 480, 66, 540, 132], WOOD_D)
	r(432, 130, 96, 100, WOOD)
	c(480, 180, 34, CREAM)
	_hands(480, 180, 22, 2.5)
	rr(468, 96, 24, 26, WOOD_D.darkened(0.3) if flag("clock_open") else WOOD, 3)
	ln(462, 230, 462, 290, WOOD_D, 2.5)
	ln(498, 230, 498, 262, WOOD_D, 2.5)
	rr(455, 288, 14, 26, WOOD_D, 6)
	rr(491, 260, 14, 26, WOOD_D, 6)
	# Bed and book shelf.
	rr(640, 120, 240, 10, WOOD_D, 3)
	for k in range(7):
		r(656.0 + k * 24.0, 120 - 44 - (k % 3) * 6, 18, 44 + (k % 3) * 6, [RED, GREEN, BRASS_D, Color("2f6d8a")][k % 4])
	rr(590, 250, 20, 130, WOOD_D, 4)
	rr(600, 310, 340, 50, CREAM.darkened(0.1), 6)
	rr(700, 302, 240, 40, Color("2f6d8a"), 8)
	rr(614, 292, 70, 26, SNOW, 10)
	r(600, 356, 340, 20, WOOD_D)


func _hands(x: float, y: float, length: float, w: float) -> void:
	var clock: Array = st.get("clock", [12, 0])
	var m := float(clock[1])
	var h := float(clock[0]) + m / 60.0
	var ha := TAU * h / 12.0 - PI / 2
	var ma := TAU * m / 60.0 - PI / 2
	ln(x, y, x + cos(ha) * length * 0.62, y + sin(ha) * length * 0.62, INK, w * 1.6)
	ln(x, y, x + cos(ma) * length, y + sin(ma) * length, INK, w)
	c(x, y, w * 1.4, INK)


func _wheels(digits: Array, x0: float, y0: float) -> void:
	for i in range(digits.size()):
		var cx := x0 + i * 80.0
		arrow_btn(cx - 30, y0 - 60, 60, 46, 0)
		rr(cx - 30, y0 - 8, 60, 80, CREAM, 6)
		r(cx - 30, y0 - 8, 60, 10, Color(0, 0, 0, 0.18))
		r(cx - 30, y0 + 62, 60, 10, Color(0, 0, 0, 0.18))
		txt(cx, y0 + 50, str(int(digits[i])), 48, INK)
		arrow_btn(cx - 30, y0 + 78, 60, 46, 1)


func _lock() -> void:
	board()
	r(0, 0, 960, 472, WOOD.darkened(0.25))
	r(478, 0, 4, 472, WOOD_D.darkened(0.3))
	# The note.
	rr(350, 26, 260, 96, PAPER, 3)
	c(480, 34, 4, RED)
	var order: Array = clues.get("count_order", [])
	for i in range(order.size()):
		picto(order[i], 400.0 + i * 80.0, 78, 1.8, INK)
	# The padlock.
	ci.draw_arc(Vector2(480, 190), 70, PI, TAU, 32, STEEL, 18, true)
	rr(330, 190, 300, 250, BRASS, 18)
	rr(342, 202, 276, 226, BRASS_D, 12)
	_wheels(st.get("cup", [0, 0, 0]), 400, 290)


func _safe() -> void:
	board()
	rr(200, 60, 560, 390, IRON, 14)
	if flag("safe_open"):
		rr(230, 90, 500, 330, IRON_D.darkened(0.3), 8)
		poly([730, 90, 800, 60, 800, 450, 730, 420], STEEL)
		if not flag("got_fuse"):
			item("fuse", 480, 330, 3.2)
	else:
		rr(230, 90, 500, 330, STEEL, 8)
		for p in [[250, 110], [710, 110], [250, 400], [710, 400]]:
			c(p[0], p[1], 7, IRON)
		_wheels(st.get("safe", [0, 0, 0, 0]), 360, 230)


func _logbook() -> void:
	board()
	rr(110, 22, 740, 430, RED.darkened(0.35), 8)
	r(128, 36, 350, 402, PAPER)
	r(482, 36, 350, 402, PAPER.darkened(0.04))
	r(478, 36, 4, 402, INK.lightened(0.4))
	# Left page: the weather log.
	var soft := INK.lightened(0.45)
	txt(196, 78, "hPa", 18, soft)
	weather("cloud", 290, 68, 0.9, soft)
	ring(390, 70, 11, soft, 2)
	ln(390, 70, 390, 62, soft, 2)
	ln(390, 70, 396, 72, soft, 2)
	ln(146, 92, 460, 92, soft, 1.5)
	var rows: Array = clues.get("log", [])
	for i in range(rows.size()):
		var row: Dictionary = rows[i]
		var y := 140.0 + i * 62.0
		txt(160, y + 6, "%d." % int(row["day"]), 18, soft)
		txt(206, y + 8, str(int(row["hpa"])), 26, INK)
		weather(row["weather"], 290, y - 4, 1.2, INK)
		txt(392, y + 8, "%02d:%02d" % [int(row["h"]), int(row["m"])], 26, INK)
		ln(146, y + 28, 460, y + 28, Color(soft, 0.5), 1)
		if row.get("bird", false):
			bird(444, y - 2, 1.0, RED.darkened(0.1))
	# Right page: a sketch of the hut.
	poly([520, 330, 600, 190, 640, 250, 700, 150, 800, 330], Color(soft, 0.25))
	ln(520, 330, 600, 190, INK, 2)
	ln(600, 190, 640, 250, INK, 2)
	ln(640, 250, 700, 150, INK, 2)
	ln(700, 150, 800, 330, INK, 2)
	hut_picto(650, 320, 1.6, INK)
	txt(650, 372, "%d m" % int(clues.get("altitude", 0)), 22, INK)
	c(760, 90, 26, Color(0.55, 0.38, 0.2, 0.18))


func _clock() -> void:
	board()
	poly([290, 136, 480, 6, 670, 136], WOOD_D)
	rr(330, 130, 300, 330, WOOD, 6)
	for k in [0.0, 1.0]:
		poly([300 + k * 310, 136, 330 + k * 310, 136, 315 + k * 310, 170], WOOD_D)
	# The cuckoo's door.
	if flag("clock_open"):
		rr(448, 44, 64, 60, Color("1c120b"), 4)
		poly([448, 44, 428, 52, 428, 108, 448, 104], WOOD_D)
		poly([512, 44, 532, 52, 532, 108, 512, 104], WOOD_D)
		bird(476, 78, 2.0, Color("d6a23a"))
		c(494, 62, 2.5, INK)
		if not flag("got_dkey"):
			item("dkey", 530, 78, 1.1)
	else:
		rr(448, 44, 64, 60, WOOD, 4)
		r(479, 44, 2, 60, WOOD_D)
		c(474, 76, 2.5, BRASS)
		c(486, 76, 2.5, BRASS)
	# The face.
	c(480, 290, 128, WOOD_D)
	c(480, 290, 118, CREAM)
	for i in range(1, 13):
		var a := TAU * i / 12.0 - PI / 2
		txt(480 + cos(a) * 96, 290 + sin(a) * 96 + 9, str(i), 24, INK)
	for i in range(60):
		var a2 := TAU * i / 60.0
		var inner := 108.0 if i % 5 == 0 else 113.0
		ln(480 + cos(a2) * inner, 290 + sin(a2) * inner, 480 + cos(a2) * 117, 290 + sin(a2) * 117, INK, 1.5)
	_hands(480, 290, 84, 4)
	# The controls: short hand left, long hand right.
	for side in [0, 1]:
		var cx: float = 185.0 + side * 590.0
		c(cx, 196, 34, CREAM)
		ring(cx, 196, 34, WOOD_D, 4)
		c(cx, 196, 3, INK)
		if side == 0:
			ln(cx, 196, cx + 12, 184, INK, 5)
		else:
			ln(cx, 196, cx, 168, INK, 3)
		arrow_btn(cx - 85, 250, 76, 64, 2)
		arrow_btn(cx + 9, 250, 76, 64, 3)


func _baro_angle(hpa: float) -> float:
	return deg_to_rad(-150.0 + (hpa - 950.0) * 3.0) - PI / 2


func _baro() -> void:
	board()
	var x := 480.0
	var y := 236.0
	c(x, y, 196, WOOD_D)
	# The ring with the weather symbols.
	c(x, y, 184, BRASS)
	var off := deg_to_rad(float(st.get("baro", 0)) * 15.0)
	for k in range(24):
		var ta := TAU * k / 24.0 + off
		ln(x + cos(ta) * 176, y + sin(ta) * 176, x + cos(ta) * 184, y + sin(ta) * 184, BRASS_D, 2)
	for row in clues.get("log", []):
		var a := _baro_angle(float(row["hpa"])) + off
		c(x + cos(a) * 157, y + sin(a) * 157, 21, BRASS_D)
		weather(row["weather"], x + cos(a) * 157 - 1, y + sin(a) * 157 - 4, 1.0, CREAM)
	# The face.
	c(x, y, 132, IRON_D)
	c(x, y, 127, CREAM)
	for p in range(950, 1051, 5):
		var a2 := _baro_angle(float(p))
		var inner := 108.0 if p % 10 == 0 else 116.0
		ln(x + cos(a2) * inner, y + sin(a2) * inner, x + cos(a2) * 126, y + sin(a2) * 126, INK, 2 if p % 10 == 0 else 1)
		if p % 10 == 0:
			txt(x + cos(a2) * 90, y + sin(a2) * 90 + 6, str(p), 15, INK)
	txt(x, y + 70, "hPa", 16, INK.lightened(0.3))
	var na := _baro_angle(968.0 + 1.2 * sin(t * 1.7))
	ln(x - cos(na) * 20, y - sin(na) * 20, x + cos(na) * 104, y + sin(na) * 104, RED.darkened(0.2), 3)
	c(x, y, 7, IRON_D)
	# Turn the ring.
	if not flag("baro_open"):
		arrow_btn(120, 200, 96, 76, 2)
		arrow_btn(744, 200, 96, 76, 3)
	else:
		rr(700, 300, 190, 130, IRON_D.darkened(0.3), 8)
		poly([700, 300, 668, 318, 668, 444, 700, 430], BRASS_D)
		if not flag("got_crank"):
			item("crank", 800, 366, 2.6)


const MAP_SPOTS := [[470, 316], [250, 104], [704, 352], [150, 392], [690, 124]]
const DIGIT_W := 17.0


func _map_label(i: int, col: Color) -> void:
	var labels: Array = clues.get("map_labels", [])
	if i >= labels.size():
		return
	var text: String = labels[i]
	for k in range(text.length()):
		txt(MAP_SPOTS[i][0] + k * DIGIT_W, MAP_SPOTS[i][1], text[k], 26, col)


func _map() -> void:
	board()
	var land := Color("e4dcb8")
	rr(60, 20, 840, 432, land, 3)
	# Slopes, a ridge, a lake, the cable car.
	for k in range(5):
		ci.draw_arc(Vector2(280, 140), 50.0 + k * 34.0, 0.2, TAU - 0.4, 40, Color(0.55, 0.45, 0.28, 0.35), 1.5, true)
		ci.draw_arc(Vector2(700, 160), 40.0 + k * 30.0, 2.0, TAU + 1.2, 40, Color(0.55, 0.45, 0.28, 0.35), 1.5, true)
	poly([90, 440, 90, 330, 220, 300, 360, 380, 420, 440], Color("b9c79b"))
	ln(280, 140, 430, 230, Color("7a6a48"), 4)
	ln(430, 230, 560, 200, Color("7a6a48"), 4)
	ln(560, 200, 700, 160, Color("7a6a48"), 4)
	rr(640, 290, 170, 30, Color("7fb2d6"), 15)
	ci.draw_dashed_line(Vector2(130, 410), Vector2(450, 300), INK, 2, 10)
	r(118, 404, 22, 14, INK)
	poly([270, 150, 280, 126, 290, 150], INK)
	ln(280, 112, 280, 126, INK, 3)
	ln(273, 118, 287, 118, INK, 3)
	hut_picto(450, 300, 1.2, RED.darkened(0.1))
	poly([690, 170, 700, 146, 710, 170], INK)
	for gx in range(1, 6):
		ln(60 + gx * 140, 20, 60 + gx * 140, 452, Color(0, 0, 0, 0.08), 1)
	for gy in range(1, 3):
		ln(60, 20 + gy * 144, 900, 20 + gy * 144, Color(0, 0, 0, 0.08), 1)
	for i in range(MAP_SPOTS.size()):
		_map_label(i, INK)
	# The tracing paper: only the holes show the map.
	if flag("map_overlay"):
		rr(60, 20, 840, 432, Color(0.97, 0.96, 0.92, 0.93), 3)
		ln(60, 20, 900, 452, Color(0, 0, 0, 0.04), 2)
		var labels: Array = clues.get("map_labels", [])
		var holes: Array = clues.get("map_holes", [])
		for k in range(holes.size()):
			var label := int(holes[k][0])
			var ch := int(holes[k][1])
			var hx: float = MAP_SPOTS[label][0] + ch * DIGIT_W
			var hy: float = MAP_SPOTS[label][1] - 9.0
			c(hx, hy, 17, INK.lightened(0.3))
			c(hx, hy, 15, land)
			txt(hx, hy + 9, str(labels[label])[ch], 26, INK)
			for d in range(k + 1):
				c(hx - (k * 5.0) + d * 10.0, hy + 30, 3.5, INK)


func _signal_on() -> bool:
	# Short 0.25 s, long 0.75 s, 0.25 s between, 1.6 s before it repeats.
	var pattern: String = clues.get("signal", "")
	var total := 1.6
	for ch in pattern:
		total += (0.75 if ch == "l" else 0.25) + 0.25
	var at_time := fmod(t, total)
	for ch in pattern:
		var on := 0.75 if ch == "l" else 0.25
		if at_time < on:
			return true
		at_time -= on + 0.25
		if at_time < 0.0:
			return false
	return false


func _radio() -> void:
	board()
	var power: bool = st.get("power", false)
	rr(120, 40, 720, 400, GREEN_D, 16)
	rr(132, 52, 696, 376, GREEN, 12)
	# Plate: a hut and "m".
	rr(160, 76, 170, 70, BRASS, 4)
	hut_picto(206, 118, 1.5, INK)
	txt(280, 126, "m", 34, INK)
	for p in [[168, 84], [322, 84], [168, 138], [322, 138]]:
		c(p[0], p[1], 3, BRASS_D)
	# Display.
	rr(370, 72, 230, 78, IRON_D, 6)
	rr(378, 80, 214, 62, Color("2a1a08") if power else Color("14100c"), 4)
	var shown := str(int(st.get("freq", 0))) if power else "----"
	for k in range(4):
		txt(410.0 + k * 50.0, 130, shown[k], 48, AMBER if power else Color("3a2c22"))
	# Signal lamp.
	c(690, 110, 30, IRON_D)
	var blink: bool = flag("tuned") and not st.get("done", false) and _signal_on()
	c(690, 110, 23, Color("ff5a3a") if blink else Color("5a1f18"))
	if blink:
		c(690, 110, 40, Color(1, 0.4, 0.2, 0.25))
	# Speaker.
	rr(160, 180, 170, 130, GREEN_D, 8)
	for k in range(7):
		r(174, 194 + k * 16, 142, 6, GREEN.darkened(0.45))
	# Knobs: hundreds, tens, ones.
	var names := ["100", "10", "1"]
	for k in range(3):
		var kx := 386.0 + k * 98.0
		c(kx, 232, 31, IRON_D)
		c(kx, 232, 26, CREAM.darkened(0.12))
		var ka := float(int(st.get("freq", 0)) / int(names[k])) * 0.628 - PI / 2
		ln(kx, 232, kx + cos(ka) * 22, 232 + sin(ka) * 22, INK, 4)
		txt(kx, 288, names[k], 15, CREAM)
		txt(kx - 26, 316, "–", 30, CREAM)
		txt(kx + 26, 316, "+", 30, CREAM)
	# Morse key: short and long.
	rr(636, 196, 76, 76, IRON_D, 12)
	c(674, 234, 12, CREAM)
	rr(722, 196, 86, 76, IRON_D, 12)
	rr(740, 226, 50, 16, CREAM, 8)
	var keyed: String = st.get("keyed", "")
	for k in range(str(clues.get("signal", "")).length()):
		c(650.0 + k * 28.0, 300, 7, AMBER if k < keyed.length() else GREEN_D)
	# The back panel.
	rr(160, 340, 170, 64, GREEN_D, 8)
	for p in [[172, 352], [318, 352], [172, 392], [318, 392]]:
		c(p[0], p[1], 4, STEEL)
	ci.draw_arc(Vector2(245, 372), 16, 0.6, TAU - 0.6, 20, CREAM, 4, true)
	poly([252, 352, 268, 362, 252, 370], CREAM)
	# The crank's socket on the side.
	rr(836, 210, 26, 44, IRON_D, 4)
	if flag("crank_on"):
		var ca := t * 3.0 if power and not flag("tuned") else 0.6
		ln(856, 232, 856 + cos(ca) * 46, 232 + sin(ca) * 46, STEEL, 9)
		c(856 + cos(ca) * 46, 232 + sin(ca) * 46, 11, WOOD_D)
	else:
		r(842, 224, 14, 14, STEEL)


const WIRE_X := 250.0
const WIRE_Y := 100.0
const WIRE_CELL := 92.0


func _tile_mask(kind: String, rot: int) -> int:
	var base: int = {"I": 5, "L": 3, "T": 7}.get(kind, 0)
	var k := rot % 4
	return ((base << k) | (base >> (4 - k))) & 15


func _wiring() -> void:
	board()
	rr(50, 24, 860, 424, STEEL.darkened(0.35), 12)
	for p in [[66, 40], [894, 40], [66, 432], [894, 432]]:
		c(p[0], p[1], 6, IRON_D)
	var live: bool = st.get("wired", false) and flag("fuse_in")
	var cable := AMBER if live else Color("b87333")
	var y0 := WIRE_Y + WIRE_CELL / 2
	var y2 := WIRE_Y + WIRE_CELL * 2.5
	# Battery, fuse holder, way in.
	rr(76, y0 - 44, 70, 88, IRON_D, 6)
	r(96, y0 - 52, 12, 8, STEEL)
	txt(111, y0 + 12, "+", 34, AMBER)
	ln(146, y0, 172, y0, Color("b87333"), 10)
	rr(170, y0 - 20, 66, 40, IRON_D, 5)
	if flag("fuse_in"):
		item("fuse", 203, y0, 1.5)
	ln(234, y0, WIRE_X, y0, Color("b87333"), 10)
	# Way out, to the radio.
	ln(WIRE_X + 5 * WIRE_CELL, y2, 770, y2, cable, 10)
	rr(770, y2 - 34, 92, 68, GREEN, 8)
	c(798, y2, 11, AMBER if live else GREEN_D)
	for k in range(3):
		r(820, y2 - 16 + k * 12, 30, 5, GREEN_D)
	var tiles: Array = clues.get("wire_tiles", [])
	var rots: Array = st.get("wire", [])
	for i in range(mini(tiles.size(), rots.size())):
		var tx := WIRE_X + (i % 5) * WIRE_CELL
		var ty := WIRE_Y + floorf(i / 5.0) * WIRE_CELL
		rr(tx + 3, ty + 3, WIRE_CELL - 6, WIRE_CELL - 6, IRON, 8)
		var m := _tile_mask(tiles[i], int(rots[i]))
		var mx := tx + WIRE_CELL / 2
		var my := ty + WIRE_CELL / 2
		var half := WIRE_CELL / 2 - 3
		if m & 1:
			ln(mx, my, mx, my - half, cable, 12)
		if m & 2:
			ln(mx, my, mx + half, my, cable, 12)
		if m & 4:
			ln(mx, my, mx, my + half, cable, 12)
		if m & 8:
			ln(mx, my, mx - half, my, cable, 12)
		c(mx, my, 6, cable)


## A star for the score: fill 0 (empty), 1 (left half) or 2 (full).
func star(x: float, y: float, rad: float, fill: int) -> void:
	var pts := []
	for i in range(10):
		var a := TAU * i / 10.0 - PI / 2
		var d := rad if i % 2 == 0 else rad * 0.45
		pts.append_array([x + cos(a) * d, y + sin(a) * d])
	poly(pts, Color(1, 1, 1, 0.13))
	if fill >= 2:
		poly(pts, AMBER)
	elif fill == 1:
		var half := []
		for i in [0, 5, 6, 7, 8, 9]:
			half.append_array([pts[i * 2], pts[i * 2 + 1]])
		poly(half, AMBER)
