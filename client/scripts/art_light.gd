## Draws Gale Rock Light (floors L1 to L4 and their close-ups) on top of
## Art's primitives; every other view is drawn by Art. What the clues show
## comes from the rules ("clues"); hotspots are in views_light.gd.
class_name ArtLight
extends Art

const STONE := Color("5a766b")
const STONE_D := Color("45605a")
const DECK := Color("5a4c38")
const DECK_D := Color("463a2a")
const TIMBER := Color("6a5436")
const TIMBER_D := Color("4c3c26")
const DARK_IRON := Color("28302e")
const SEA := Color("16302c")
const SKY := Color("0e1f1c")
const SKY_FLASH := Color("a9d8cf")
const CHALK := Color("e6eadc")
const FLAG_COLOURS := {"R": Color("c23b2e"), "Y": Color("e2b23a"), "B": Color("2d5f8f"), "W": Color("efece0"), "K": Color("22262a")}
## The signal flag of each digit: pattern and two colours.
const FLAG_DESIGNS := [
	["o", "Y", "R"], ["h", "W", "R"], ["v", "B", "W"], ["x", "B", "W"], ["q", "R", "W"],
	["b", "Y", "B"], ["d", "K", "Y"], ["s", "B", "Y"], ["t", "Y", "R"], ["v", "Y", "K"],
]

## 0..1 while lightning lights the sky (set by main.gd).
var flash := 0.0


func draw_view(view: String) -> void:
	match view:
		"L1": _floor1()
		"L2": _floor2()
		"L3": _floor3()
		"L4": _floor4()
		"oil": _oil()
		"chest": _chest()
		"tide": _tide()
		"hatch2": _hatch2()
		"flags": _flags()
		"slate": _slate()
		"locker": _locker()
		"seachart": _chart()
		"window": _window()
		"gears": _gears()
		"drum": _drum()
		"valves": _valves()
		"bearing": _bearing()
		_:
			super.draw_view(view)
			return
	home()


# --- Small pictures -----------------------------------------------------------------

func symbol(name: String, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match name:
		"anchor":
			ring(0, -11, 4, col, 2.5)
			ln(0, -7, 0, 13, col, 3)
			ln(-7, -2, 7, -2, col, 3)
			ci.draw_arc(Vector2(0, 3), 11, 0.15, PI - 0.15, 14, col, 3, true)
		"star":
			var pts := []
			for i in range(10):
				var a := TAU * i / 10.0 - PI / 2
				var d := 14.0 if i % 2 == 0 else 6.0
				pts.append_array([cos(a) * d, sin(a) * d])
			poly(pts, col)
		"fish":
			poly([-13, 0, -3, -8, 8, -3, 8, 3, -3, 8], col)
			poly([6, 0, 15, -8, 15, 8], col)
		"bell":
			poly([-11, 9, -8, 3, -7, -6, 0, -12, 7, -6, 8, 3, 11, 9], col)
			c(0, 12, 3, col)
		"wheel":
			ring(0, 0, 10, col, 3)
			for i in range(4):
				var a2 := PI * i / 4.0
				ln(cos(a2) * -14, sin(a2) * -14, cos(a2) * 14, sin(a2) * 14, col, 2)
		"wave":
			for k in [-6.0, 4.0]:
				ci.draw_arc(Vector2(-7, k), 7, PI, TAU, 10, col, 3, true)
				ci.draw_arc(Vector2(7, k), 7, 0, PI, 10, col, 3, true)
	home()


## High water (true) or low water: a wave with an arrow.
func tide_picto(high: bool, x: float, y: float, col: Color) -> void:
	for k in [-14.0, 0.0, 14.0]:
		ci.draw_arc(Vector2(x + k - 3.5, y + 14), 3.5, PI, TAU, 8, col, 2.5, true)
		ci.draw_arc(Vector2(x + k + 3.5, y + 14), 3.5, 0, PI, 8, col, 2.5, true)
	ln(x, y - 12, x, y + 4, col, 3.5)
	if high:
		poly([x, y - 18, x + 8, y - 6, x - 8, y - 6], col)
	else:
		poly([x, y + 8, x + 8, y - 4, x - 8, y - 4], col)


func moon(x: float, y: float, rad: float, col: Color, back: Color) -> void:
	c(x, y, rad, col)
	c(x + rad * 0.45, y - rad * 0.2, rad * 0.85, back)


func sig_flag(digit: int, x: float, y: float, w: float, h: float) -> void:
	var design: Array = FLAG_DESIGNS[digit % 10]
	var a: Color = FLAG_COLOURS[design[1]]
	var b: Color = FLAG_COLOURS[design[2]]
	r(x - 1, y - 1, w + 2, h + 2, Color(0, 0, 0, 0.5))
	r(x, y, w, h, a)
	match design[0]:
		"o":
			c(x + w / 2, y + h / 2, h * 0.3, b)
		"h":
			r(x, y + h / 2, w, h / 2, b)
		"v":
			r(x + w / 2, y, w / 2, h, b)
		"x":
			r(x + w * 0.4, y, w * 0.2, h, b)
			r(x, y + h * 0.38, w, h * 0.24, b)
		"q":
			r(x + w / 2, y, w / 2, h / 2, b)
			r(x, y + h / 2, w / 2, h / 2, b)
		"b":
			r(x + w * 0.22, y + h * 0.25, w * 0.56, h * 0.5, b)
		"d":
			poly([x, y, x + w, y, x + w, y + h], b)
		"s":
			r(x, y + h / 3, w, h / 3, b)
		"t":
			poly([x, y, x + w * 0.6, y + h / 2, x, y + h], b)


func gear_wheel(x: float, y: float, rad: float, col: Color, turn: float = 0.0) -> void:
	var teeth := int(rad / 5.0)
	for i in range(teeth):
		var a := TAU * i / teeth + turn
		ln(x + cos(a) * (rad - 6), y + sin(a) * (rad - 6), x + cos(a) * (rad + 5), y + sin(a) * (rad + 5), col, 7)
	c(x, y, rad - 2, col)
	c(x, y, rad - 9, col.darkened(0.18))
	for i in range(3):
		var a2 := TAU * i / 3.0 + turn
		ln(x, y, x + cos(a2) * (rad - 9), y + sin(a2) * (rad - 9), col, 5)
	c(x, y, 6, DARK_IRON)


func _gear_item(x: float, y: float, s: float, rad: float) -> void:
	gear_wheel(x, y, rad * s, BRASS)


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"magnet":
			at(x, y, 0.0, s)
			ci.draw_arc(Vector2(0, -2), 11, PI, TAU, 14, RED, 8, true)
			r(-15, -2, 8, 14, RED)
			r(7, -2, 8, 14, RED)
			r(-15, 9, 8, 6, STEEL)
			r(7, 9, 8, 6, STEEL)
		"rope":
			at(x, y, 0.0, s)
			for k in range(3):
				ring(0, 0, 6.0 + k * 4.0, Color("c8a66a"), 3)
		"line":
			at(x, y, 0.0, s)
			ci.draw_arc(Vector2(-6, -6), 9, 0.5, TAU - 1.0, 14, Color("c8a66a"), 3, true)
			ln(-2, 0, 8, 6, Color("c8a66a"), 3)
			ci.draw_arc(Vector2(9, 11), 5, PI, TAU, 10, RED, 4, true)
		"handle":
			at(x, y, 0.0, s)
			rr(-16, -14, 32, 9, TIMBER_D, 4)
			ln(0, -6, 0, 14, STEEL, 5)
			r(-5, 10, 10, 7, DARK_IRON)
		"can":
			at(x, y, 0.0, s)
			poly([-11, -8, 11, -8, 13, 16, -13, 16], STEEL)
			ln(8, -4, 18, -14, STEEL, 4)
			ci.draw_arc(Vector2(0, -8), 9, PI, TAU, 10, DARK_IRON, 3, true)
			home()
			txt(x, y + 12 * s, str(int(st.get("carried", 0))), int(13 * s), INK)
		"gear_a", "gear_b", "gear_c", "gear_d":
			var radii: Array = clues.get("gear_radii", [20, 30, 40, 50])
			home()
			_gear_item(x, y, s, 7.0 + float(radii[name.unicode_at(5) - 97]) * 0.24)
		_:
			super.item(name, x, y, s)
			return
	home()


# --- The tower ---------------------------------------------------------------------

func _curve(x: float) -> float:
	return 28.0 * (1.0 - pow((x - 480.0) / 480.0, 2))


func tower() -> void:
	r(0, 0, 960, 380, STONE)
	for i in range(8):
		var y := 34.0 + i * 48.0
		var pts := PackedVector2Array()
		for k in range(17):
			pts.append(Vector2(k * 60.0, y - _curve(k * 60.0)))
		ci.draw_polyline(pts, STONE_D, 3, true)
		for j in range(7):
			var x := float((j * 150 + (i % 2) * 75) % 960)
			ln(x, y - _curve(x) - 46, x, y - _curve(x), STONE_D, 2.5)
	# The round floor.
	var deck := [0.0, 472.0, 0.0, 372.0]
	for k in range(1, 17):
		deck.append_array([k * 60.0, 372.0 - _curve(k * 60.0)])
	deck.append_array([960.0, 472.0])
	poly(deck, DECK)
	for i in range(9):
		ln(i * 120.0, 376 - _curve(i * 120.0), i * 170.0 - 200, 472, DECK_D, 2)
	# Darker towards both sides: the wall curves away.
	for k in range(6):
		r(0, 0, 120 - k * 20, 380, Color(0, 0, 0, 0.05))
		r(840 + k * 20, 0, 120 - k * 20, 380, Color(0, 0, 0, 0.05))


## The spiral stairs to the hatch above, on the right.
func stairs(open: bool) -> void:
	r(650, 0, 150, 20, DARK_IRON)
	r(668, 0, 114, 12, Color("0a100f") if open else TIMBER_D)
	if not open:
		rr(712, 12, 26, 20, BRASS, 4)
	r(716, 0, 16, 392, DARK_IRON)
	for i in range(9):
		var y := 372.0 - i * 42.0
		var dir := 1.0 if i % 2 == 1 else -1.0
		var length := 110.0 - i * 4.0
		poly([724, y, 724 + dir * length, y - 8, 724 + dir * length, y + 4, 724, y + 12], TIMBER if i % 2 == 1 else TIMBER_D)
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for k in range(13):
		var f := k / 12.0
		left.append(Vector2(614 + 46 * f * f - 14 * sin(f * PI), 380 - 360 * f))
		right.append(Vector2(834 - 44 * f * f + 16 * sin(f * PI), 380 - 360 * f))
	ci.draw_polyline(left, DARK_IRON, 5, true)
	ci.draw_polyline(right, DARK_IRON, 5, true)


## An arched window on the sea; lightning shows through it.
func sea_window(x: float, y: float, w: float, h: float) -> void:
	var arch := [x - 12, y + h + 12, x - 12, y + h * 0.4]
	var glass := [x, y + h, x, y + h * 0.4]
	for k in range(13):
		var a := PI + PI * k / 12.0
		arch.append_array([x + w / 2 + cos(a) * (w / 2 + 12), y + h * 0.4 + sin(a) * (h * 0.4 + 12)])
		glass.append_array([x + w / 2 + cos(a) * w / 2, y + h * 0.4 + sin(a) * h * 0.4])
	arch.append_array([x + w + 12, y + h + 12])
	glass.append_array([x + w, y + h])
	poly(arch, TIMBER_D)
	poly(glass, SKY.lerp(SKY_FLASH, flash))
	var wave := [x, y + h, x, y + h * 0.72]
	for k in range(1, 9):
		wave.append_array([x + w * k / 8.0, y + h * 0.72 + 5.0 * sin(k * 1.6 + t * 1.5)])
	wave.append_array([x + w, y + h])
	poly(wave, SEA.lerp(Color("2f5a52"), flash))
	for i in range(18):
		var rx := x + 6 + fmod(i * 37.0 + t * 60.0, w - 12)
		var ry := y + h * 0.25 + fmod(i * 53.0 + t * 240.0, h * 0.7)
		ln(rx, ry, rx - 4, ry + 12, Color(0.8, 0.9, 0.95, 0.5), 1.5)
	r(x + w / 2 - 3, y + 4, 6, h - 4, TIMBER_D)
	r(x, y + h * 0.55, w, 6, TIMBER_D)


func lantern(x: float, y: float) -> void:
	rr(x - 17, y, 34, 14, BRASS, 4)
	rr(x - 12, y - 38, 24, 38, Color(0.75, 0.9, 0.92, 0.5), 6)
	ci.draw_arc(Vector2(x, y - 38), 12, PI, TAU, 12, BRASS, 4, true)
	poly([x, y - 28 + 2 * sin(t * 11.0), x + 5, y - 12, x, y - 6, x - 5, y - 12], Color("fff1a8"))


func crate(x: float, y: float, w: float, h: float) -> void:
	rr(x, y, w, h, TIMBER, 3)
	r(x, y, w, 6, TIMBER_D)
	r(x, y + h - 6, w, 6, TIMBER_D)
	ln(x + 4, y + 6, x + w - 4, y + h - 6, TIMBER_D, 4)


func _floor1() -> void:
	tower()
	sea_window(150, 96, 110, 160)
	# Life ring.
	ring(70, 190, 34, RED, 16)
	for k in range(4):
		ci.draw_arc(Vector2(70, 190), 34, k * PI / 2 + 0.3, k * PI / 2 + 0.9, 8, CREAM, 16, true)
	# Rope coils.
	if not flag("got_rope"):
		for k in range(4):
			ring(66, 300, 12.0 + k * 6.0, Color("c8a66a"), 4)
		c(66, 262, 5, DARK_IRON)
	for k in range(3):
		ring(128, 322, 10.0 + k * 6.0, Color("a88a58"), 4)
	# Tool board.
	rr(300, 86, 270, 124, TIMBER_D, 4)
	if not flag("got_magnet"):
		item("magnet", 338, 146, 1.7)
	else:
		c(338, 122, 4, DARK_IRON)
	if not flag("got_gear_b"):
		gear_wheel(420, 148, 26, BRASS)
	else:
		c(420, 148, 4, DARK_IRON)
	ln(486, 110, 486, 190, Color("c9a26a"), 6)
	rr(468, 104, 36, 20, STEEL, 3)
	poly([520, 112, 556, 112, 548, 190, 528, 190], STEEL)
	rr(530, 96, 16, 20, TIMBER, 3)
	# Oil barrel on its stand, and the two cans.
	rr(296, 262, 130, 92, TIMBER, 16)
	r(292, 280, 138, 8, DARK_IRON)
	r(292, 330, 138, 8, DARK_IRON)
	r(304, 354, 14, 30, TIMBER_D)
	r(404, 354, 14, 30, TIMBER_D)
	rr(424, 316, 26, 10, BRASS, 3)
	r(442, 322, 6, 14, BRASS)
	if not flag("can_taken") and not flag("oil_in"):
		poly([462, 330, 506, 330, 510, 386, 458, 386], STEEL)
		ln(500, 336, 520, 318, STEEL, 5)
	poly([524, 348, 556, 348, 559, 386, 521, 386], STEEL.darkened(0.15))
	ln(552, 352, 566, 340, STEEL.darkened(0.15), 4)
	# Crates.
	crate(856, 300, 90, 86)
	crate(870, 232, 70, 68)
	# The grating in the floor.
	rr(432, 404, 150, 50, DARK_IRON, 4)
	for k in range(7):
		r(442 + k * 20, 410, 8, 38, Color("0a100f"))
	if not flag("got_key"):
		c(508, 430, 2.5, Color(1, 0.9, 0.5, 0.5 + 0.5 * sin(t * 3.0)))
	lantern(200, 372)
	stairs(flag("hatch1_open"))


func _floor2() -> void:
	tower()
	sea_window(150, 96, 110, 160)
	# The tear-off calendar.
	rr(44, 108, 80, 96, PAPER, 3)
	r(44, 108, 80, 22, RED)
	txt(84, 180, str(int(clues.get("today", 0))), 44, INK)
	ring(84, 164, 30, RED, 3)
	# Four framed photos.
	var photos: Array = clues.get("photos", [])
	for i in range(photos.size()):
		var fx := 300.0 + i * 82.0
		var fy := 84.0 + (i % 2) * 14.0
		rr(fx, fy, 68, 92, TIMBER_D, 3)
		r(fx + 8, fy + 22, 52, 44, Color("b9b39c"))
		poly([fx + 8, fy + 66, fx + 26, fy + 40, fx + 40, fy + 54, fx + 50, fy + 44, fx + 60, fy + 66], Color("8a8672"))
		symbol(photos[i]["symbol"], fx + 34, fy + 12, 0.55, BRASS)
		txt(fx + 34, fy + 86, str(int(photos[i]["year"])), 15, CREAM)
	# Bed.
	rr(28, 286, 14, 100, TIMBER_D, 3)
	rr(36, 322, 240, 44, CREAM.darkened(0.15), 6)
	rr(110, 314, 166, 38, Color("3d6a72"), 8)
	rr(44, 306, 60, 24, SNOW.darkened(0.08), 10)
	r(36, 362, 240, 20, TIMBER_D)
	# Sea chest.
	rr(290, 346, 96, 46, TIMBER, 5)
	rr(286, 330, 104, 22, TIMBER_D, 8)
	r(290, 362, 96, 5, DARK_IRON)
	rr(328, 344, 20, 18, BRASS, 3)
	if flag("chest_open"):
		rr(290, 318, 96, 16, Color("0a100f"), 3)
	# Table with the tide book and the lantern.
	rr(410, 296, 190, 14, TIMBER, 3)
	r(422, 310, 12, 76, TIMBER_D)
	r(576, 310, 12, 76, TIMBER_D)
	poly([428, 296, 438, 276, 480, 278, 478, 296], PAPER)
	poly([478, 296, 480, 278, 522, 276, 530, 296], PAPER.darkened(0.06))
	lantern(566, 282)
	# Stove with the match shelf.
	rr(856, 270, 76, 112, DARK_IRON, 8)
	r(884, 120, 20, 150, DARK_IRON)
	rr(868, 300, 52, 40, Color("0a100f"), 6)
	poly([876, 336, 886, 316 + 3 * sin(t * 8.0), 894, 326, 902, 310, 912, 336], FIRE)
	rr(846, 228, 96, 8, TIMBER_D, 2)
	if not flag("got_matches"):
		super.item("matches", 872, 216, 0.9)
		home()
	stairs(flag("hatch2_open"))


func _floor3() -> void:
	tower()
	# The wide watch window.
	rr(48, 84, 256, 176, TIMBER_D, 4)
	r(60, 96, 232, 152, SKY.lerp(SKY_FLASH, flash))
	var wave := [60.0, 248.0, 60.0, 210.0]
	for k in range(1, 13):
		wave.append_array([60 + 232 * k / 12.0, 210 + 5.0 * sin(k * 1.3 + t * 1.5)])
	wave.append_array([292.0, 248.0])
	poly(wave, SEA.lerp(Color("2f5a52"), flash))
	for k in [1, 2]:
		r(60 + 232 * k / 3.0 - 3, 96, 6, 152, TIMBER_D)
	for i in range(26):
		var rx := 64 + fmod(i * 37.0 + t * 60.0, 224.0)
		var ry := 100 + fmod(i * 53.0 + t * 240.0, 136.0)
		ln(rx, ry, rx - 4, ry + 12, Color(0.8, 0.9, 0.95, 0.5), 1.5)
	# Flag chart.
	rr(330, 70, 140, 150, PAPER, 3)
	for d in range(10):
		sig_flag(d, 342.0 + (d % 5) * 25.0, 86.0 + floorf(d / 5.0) * 62.0, 20, 14)
		txt(352.0 + (d % 5) * 25.0, 118.0 + floorf(d / 5.0) * 62.0, str(d), 12, INK)
	# Slate.
	rr(492, 86, 110, 124, TIMBER_D, 3)
	r(500, 94, 94, 108, Color("27302e"))
	var hoist: Array = clues.get("hoist", [])
	ln(547, 100, 547, 196, CHALK, 1.5)
	for i in range(hoist.size()):
		sig_flag(int(hoist[i]), 537, 104.0 + i * 23.0, 20, 14)
	# Telescope.
	ln(262, 388, 282, 300, TIMBER_D, 5)
	ln(302, 388, 282, 300, TIMBER_D, 5)
	ln(282, 388, 282, 300, TIMBER_D, 5)
	ci.draw_set_transform(Vector2(282, 296), -0.35, Vector2.ONE)
	rr(-46, -9, 80, 18, BRASS, 5)
	rr(30, -12, 26, 24, BRASS_D, 5)
	home()
	# Chart table.
	rr(340, 296, 230, 14, TIMBER, 3)
	r(354, 310, 12, 76, TIMBER_D)
	r(544, 310, 12, 76, TIMBER_D)
	poly([360, 296, 374, 268, 480, 268, 494, 296], PAPER)
	ln(384, 288, 420, 276, Color("5f8fb0"), 2.5)
	ln(420, 276, 466, 284, Color("5f8fb0"), 2.5)
	c(440, 280, 4, RED)
	lantern(526, 282)
	# The signal locker.
	rr(856, 216, 86, 172, STEEL.darkened(0.3), 4)
	r(862, 222, 74, 160, STEEL.darkened(0.15))
	if flag("locker_open"):
		r(866, 226, 66, 152, Color("0a100f"))
		poly([932, 222, 950, 232, 950, 392, 932, 382], STEEL.darkened(0.3))
	else:
		for k in range(4):
			rr(868.0 + k * 16.0, 290, 13, 18, CREAM, 2)
	stairs(flag("hatch3_open"))


func _floor4() -> void:
	# The lantern room: glass all around.
	r(0, 0, 960, 380, SKY.lerp(SKY_FLASH, flash))
	var wave := [0.0, 380.0, 0.0, 300.0]
	for k in range(1, 25):
		wave.append_array([k * 40.0, 300 + 6.0 * sin(k * 1.1 + t * 1.4)])
	wave.append_array([960.0, 380.0])
	poly(wave, SEA.lerp(Color("2f5a52"), flash))
	for i in range(60):
		var rx := fmod(i * 37.0 + t * 60.0, 960.0)
		var ry := fmod(i * 53.0 + t * 240.0, 360.0)
		ln(rx, ry, rx - 5, ry + 14, Color(0.8, 0.9, 0.95, 0.4), 1.5)
	if st.get("done", false):
		poly([480, 150, 0, 90, 0, 250], Color(1, 0.9, 0.55, 0.28 + 0.1 * sin(t * 3.0)))
	for k in range(9):
		r(k * 120.0 - 5, 0, 10, 380, DARK_IRON)
	r(0, 0, 960, 22, DARK_IRON)
	r(0, 250, 960, 8, DARK_IRON)
	r(0, 330, 960, 50, STONE_D)
	var deck := [0.0, 472.0, 0.0, 380.0, 960.0, 380.0, 960.0, 472.0]
	poly(deck, DECK)
	for i in range(9):
		ln(i * 120.0, 380, i * 170.0 - 200, 472, DECK_D, 2)
	# The lamp: lens, base, three small lights (oil, clockwork, pressure).
	rr(410, 252, 140, 26, BRASS_D, 5)
	var lit: bool = st.get("done", false)
	var glass := Color(1, 0.92, 0.6, 0.9) if lit else Color(0.7, 0.86, 0.84, 0.45)
	rr(418, 62, 124, 192, Color(0.25, 0.36, 0.34), 40)
	rr(418, 62, 124, 192, glass, 40)
	for k in range(7):
		ci.draw_arc(Vector2(480, 158), 22.0 + k * 9.0, -0.9, 0.9, 12, Color(1, 1, 1, 0.16), 2, true)
		ci.draw_arc(Vector2(480, 158), 22.0 + k * 9.0, PI - 0.9, PI + 0.9, 12, Color(1, 1, 1, 0.16), 2, true)
	c(480, 158, 14, Color("fff1a8") if lit else Color(1, 1, 1, 0.2))
	rr(430, 40, 100, 24, BRASS, 6)
	var checks := [flag("oil_in"), flag("wound"), st.get("pressure", false)]
	for k in range(3):
		c(452.0 + k * 28.0, 265, 6, Color("69d06a") if checks[k] else Color("3a2c22"))
	# Clockwork cabinet.
	rr(390, 278, 180, 112, TIMBER_D, 5)
	r(400, 288, 160, 92, DARK_IRON)
	gear_wheel(440, 334, 26, BRASS, t * 2.0 if flag("wound") else 0.0)
	gear_wheel(510, 334, 34, BRASS_D, -t * 1.5 if flag("wound") else 0.3)
	# Shutter drum.
	rr(600, 150, 96, 86, BRASS_D, 12)
	var drum_pins: Array = st.get("pins", [0, 0, 0, 0, 0, 0, 0, 0])
	for k in range(drum_pins.size()):
		c(612.0 + k * 10.4, 176, 3.5, CREAM if int(drum_pins[k]) == 1 else DARK_IRON)
	r(606, 198, 84, 4, DARK_IRON)
	r(640, 236, 16, 20, DARK_IRON)
	# Valve board.
	rr(180, 244, 160, 140, STEEL.darkened(0.35), 6)
	var gauges: Array = st.get("gauges", [0, 0, 0])
	for k in range(3):
		var gx := 212.0 + k * 48.0
		c(gx, 276, 18, CREAM)
		var ga := -PI * 0.75 + float(gauges[k]) * PI / 2
		ln(gx, 276, gx + cos(ga) * 14, 276 + sin(ga) * 14, RED, 2.5)
		ring(gx, 340, 14, RED, 5)
		c(gx, 340, 4, DARK_IRON)
	# Oil reservoir.
	rr(76, 250, 84, 136, BRASS_D, 12)
	rr(104, 268, 28, 100, Color("0a100f"), 4)
	if flag("oil_in"):
		rr(106, 302, 24, 64, AMBER.darkened(0.2), 3)
	r(100, 300, 36, 3, RED)
	rr(92, 232, 52, 22, BRASS, 6)
	# Bearing ring.
	rr(620, 300, 150, 84, BRASS_D, 8)
	ring(662, 342, 28, CREAM, 3)
	poly([662, 318, 669, 342, 662, 336, 655, 342], RED)
	rr(700, 326, 60, 32, Color("0a100f"), 4)
	var bearing: Array = st.get("bearing", [0, 0, 0])
	txt(730, 350, "%d%d%d" % [int(bearing[0]), int(bearing[1]), int(bearing[2])], 22, AMBER)
	# A loose gear on the floor.
	if not flag("got_gear_d"):
		gear_wheel(826, 424, 26, BRASS)


# --- Close-ups -----------------------------------------------------------------------

func _can(x: float, y: float, w: float, size: int, level: int) -> void:
	var unit := 44.0
	var h := size * unit + 20
	rr(x, y - h, w, h, STEEL, 8)
	rr(x + 8, y - h + 8, w - 16, h - 16, Color("1c2422"), 5)
	if level > 0:
		rr(x + 8, y - 8 - level * unit, w - 16, level * unit, AMBER.darkened(0.25), 4)
	for k in range(1, size + 1):
		r(x + 8, y - 8 - k * unit, 16, 3, CREAM)
		txt(x - 16, y - 2 - k * unit, str(k), 18, CREAM)
	txt(x + w / 2, y + 30, "%d l" % size, 22, CREAM)
	ci.draw_arc(Vector2(x + w / 2, y - h), w * 0.32, PI, TAU, 14, DARK_IRON, 6, true)


func _can_button(x: float, y: float, kind: String, dir: float = 1.0) -> void:
	rr(x, y, 60, 60, Color(0, 0, 0, 0.4), 10)
	var cx := x + 30
	var cy := y + 30
	match kind:
		"fill":
			poly([cx, cy - 16, cx + 11, cy + 4, cx - 11, cy + 4], AMBER)
			c(cx, cy + 5, 11, AMBER)
		"pour":
			ln(cx - 14 * dir, cy, cx + 8 * dir, cy, CREAM, 5)
			poly([cx + 16 * dir, cy, cx + 4 * dir, cy - 11, cx + 4 * dir, cy + 11], CREAM)
		"empty":
			ln(cx, cy - 14, cx, cy + 4, CREAM, 5)
			poly([cx, cy + 16, cx - 11, cy + 4, cx + 11, cy + 4], CREAM)
			r(cx - 14, cy + 18, 28, 3, CREAM)


func _oil() -> void:
	board(Color("26332f"))
	# The barrel and its tap.
	rr(40, 90, 250, 300, TIMBER, 40)
	r(34, 140, 262, 12, DARK_IRON)
	r(34, 330, 262, 12, DARK_IRON)
	rr(286, 250, 50, 16, BRASS, 4)
	r(322, 258, 10, 30, BRASS)
	poly([165, 210, 185, 240, 145, 240], AMBER.darkened(0.2))
	c(165, 244, 20, AMBER.darkened(0.2))
	var cans: Array = st.get("cans", [0, 0])
	var sizes: Array = clues.get("can_sizes", [5, 3])
	if flag("can_taken") or flag("oil_in"):
		rr(420, 150, 130, 240, Color(0, 0, 0, 0.25), 8)
	else:
		_can(420, 390, 130, int(sizes[0]), int(cans[0]))
		_can_button(566, 150, "fill")
		_can_button(566, 222, "pour", 1.0)
		_can_button(566, 294, "empty")
	_can(700, 390, 110, int(sizes[1]), int(cans[1]))
	_can_button(826, 186, "fill")
	_can_button(826, 258, "pour", -1.0)
	_can_button(826, 330, "empty")


func _symbol_wheels(digits: Array, x0: float, y0: float) -> void:
	var names: Array = clues.get("symbols", [])
	for i in range(digits.size()):
		var cx := x0 + i * 90.0
		arrow_btn(cx - 34, y0 - 62, 68, 46, 0)
		rr(cx - 34, y0 - 8, 68, 84, CREAM, 6)
		if not names.is_empty():
			symbol(names[int(digits[i]) % names.size()], cx, y0 + 34, 1.9, INK)
		arrow_btn(cx - 34, y0 + 84, 68, 46, 1)


func _chest() -> void:
	board(Color("26332f"))
	rr(170, 130, 620, 320, TIMBER, 12)
	rr(150, 60, 660, 110, TIMBER_D, 30)
	for x in [220.0, 720.0]:
		r(x, 60, 22, 390, DARK_IRON)
	# An hourglass above the lock.
	poly([462, 76, 498, 76, 480, 100], BRASS)
	poly([462, 124, 498, 124, 480, 100], BRASS)
	r(458, 72, 44, 5, BRASS)
	r(458, 124, 44, 5, BRASS)
	if flag("chest_open"):
		rr(260, 190, 440, 230, Color("0a100f"), 8)
		if not flag("got_chest"):
			super.item("crank", 400, 310, 3.0)
			home()
			gear_wheel(570, 310, 52, BRASS)
	else:
		rr(290, 180, 380, 250, BRASS_D, 10)
		_symbol_wheels(st.get("chest", [0, 0, 0, 0]), 345, 270)


func _tide() -> void:
	board(Color("26332f"))
	rr(130, 20, 700, 436, Color("2d4f66"), 8)
	r(148, 34, 664, 408, PAPER)
	var soft := INK.lightened(0.4)
	for k in range(4):
		tide_picto(k % 2 == 0, 330.0 + k * 130.0, 62, INK)
	ln(166, 92, 794, 92, soft, 2)
	ln(250, 46, 250, 430, soft, 1.5)
	var rows: Array = clues.get("tides", [])
	for i in range(rows.size()):
		var y := 134.0 + i * 54.0
		txt(206, y + 8, "%d." % int(rows[i]["day"]), 26, INK)
		var times: Array = rows[i]["times"]
		for k in range(times.size()):
			var text: String = times[k]
			txt(330.0 + k * 130.0, y + 8, "%s:%s" % [text.substr(0, 2), text.substr(2, 2)], 26, INK)
		ln(166, y + 26, 794, y + 26, Color(soft, 0.45), 1)


func _digit_wheels(digits: Array, x0: float, y0: float) -> void:
	_wheels(digits, x0, y0)


func _hatch2() -> void:
	board(Color("26332f"))
	rr(120, 30, 720, 420, TIMBER_D, 8)
	for k in range(5):
		r(120 + k * 144.0, 30, 3, 420, Color(0, 0, 0, 0.3))
	# The plaque: low water, at night.
	rr(380, 52, 200, 76, BRASS, 5)
	tide_picto(false, 440, 88, INK)
	moon(520, 90, 17, INK, BRASS)
	rr(300, 150, 360, 280, DARK_IRON, 12)
	_digit_wheels(st.get("hatch2", [0, 0, 0, 0]), 360, 270)


func _flags() -> void:
	board(Color("26332f"))
	rr(130, 24, 700, 430, PAPER, 4)
	for d in range(10):
		var fx := 180.0 + (d % 5) * 128.0
		var fy := 70.0 + floorf(d / 5.0) * 196.0
		sig_flag(d, fx, fy, 96, 66)
		txt(fx + 48, fy + 112, str(d), 36, INK)


func _slate() -> void:
	board(Color("26332f"))
	rr(240, 14, 480, 446, TIMBER_D, 6)
	r(258, 30, 444, 414, Color("27302e"))
	# A ship, chalked, with its hoist.
	ln(330, 380, 630, 380, CHALK, 3)
	ln(330, 380, 360, 410, CHALK, 3)
	ln(360, 410, 600, 410, CHALK, 3)
	ln(600, 410, 630, 380, CHALK, 3)
	ln(480, 380, 480, 50, CHALK, 3)
	var hoist: Array = clues.get("hoist", [])
	for i in range(hoist.size()):
		sig_flag(int(hoist[i]), 490, 62.0 + i * 76.0, 96, 62)
	poly([470, 70, 380, 330, 470, 330], Color(CHALK, 0.25))


func _locker() -> void:
	board(Color("26332f"))
	rr(200, 30, 560, 420, STEEL.darkened(0.3), 10)
	if flag("locker_open"):
		rr(230, 60, 500, 360, Color("0a100f"), 6)
		poly([730, 60, 800, 30, 800, 450, 730, 420], STEEL.darkened(0.15))
		if not flag("got_locker"):
			item("handle", 390, 250, 3.4)
			gear_wheel(580, 250, 36, BRASS)
	else:
		rr(230, 60, 500, 360, STEEL.darkened(0.12), 6)
		# A hoist of four flags marks what opens it.
		ln(412, 96, 548, 96, CREAM, 2)
		for k in range(4):
			r(420.0 + k * 32.0, 84, 24, 3, CREAM)
			r(420.0 + k * 32.0, 84, 3, 22, CREAM)
			r(420.0 + k * 32.0, 104, 24, 3, CREAM)
			r(441.0 + k * 32.0, 84, 3, 22, CREAM)
		_digit_wheels(st.get("locker", [0, 0, 0, 0]), 360, 250)


func _chart() -> void:
	board(Color("26332f"))
	var water := Color("c9dcd8")
	rr(60, 20, 840, 432, water, 3)
	# The coast.
	poly([60, 20, 420, 20, 380, 70, 300, 96, 250, 150, 170, 170, 130, 240, 60, 270], Color("d9cfa6"))
	poly([900, 452, 900, 330, 840, 350, 800, 400, 720, 420, 700, 452], Color("d9cfa6"))
	for k in range(6):
		ci.draw_arc(Vector2(560, 250), 60.0 + k * 44.0, 0, TAU, 48, Color(0.2, 0.4, 0.45, 0.12), 1.5, true)
	# Rocks and soundings.
	for p in [[520, 250], [545, 268], [500, 276], [580, 236]]:
		poly([p[0] - 8, p[1] + 6, p[0], p[1] - 8, p[0] + 9, p[1] + 6], INK.lightened(0.2))
	for p in [[330, 300, "12"], [640, 150, "23"], [760, 250, "31"], [420, 390, "9"], [250, 380, "17"]]:
		txt(p[0], p[1], p[2], 14, Color(0.2, 0.35, 0.4, 0.7))
	# The three lights, each with its name and flash pattern.
	var spots := [[560, 196], [210, 204], [770, 366]]
	var lights: Array = clues.get("lights", [])
	for i in range(mini(lights.size(), spots.size())):
		var x: float = spots[i][0]
		var y: float = spots[i][1]
		poly([x - 8, y, x - 5, y - 26, x + 5, y - 26, x + 8, y], RED)
		rr(x - 7, y - 36, 14, 10, AMBER, 2)
		txt(x, y + 22, lights[i]["name"], 17, INK)
		var pattern: String = lights[i]["pattern"]
		for k in range(pattern.length()):
			var px := x - 62 + k * 15.0
			r(px, y + 32, 13, 13, INK)
			r(px + 1.5, y + 33.5, 10, 10, AMBER if pattern[k] == "1" else water)
		poly([x + 72, y + 38, x + 62, y + 32, x + 62, y + 44], INK)
	# Compass rose.
	ring(160, 370, 36, INK.lightened(0.3), 2)
	poly([160, 326, 168, 370, 152, 370], RED)
	poly([160, 414, 168, 370, 152, 370], INK.lightened(0.3))
	ln(116, 370, 204, 370, INK.lightened(0.3), 2)


## Screen x of a bearing on the window sill's scale.
func _sill_x(degrees: float) -> float:
	return 100.0 + (degrees - 200.0) * 9.5


func _window() -> void:
	r(0, 0, 960, 472, SKY.lerp(SKY_FLASH, flash))
	var wave := [0.0, 400.0, 0.0, 300.0]
	for k in range(1, 25):
		wave.append_array([k * 40.0, 300 + 7.0 * sin(k * 1.1 + t * 1.4)])
	wave.append_array([960.0, 400.0])
	poly(wave, SEA.lerp(Color("2f5a52"), flash))
	# The ship: only lightning shows it.
	var seen := clampf(flash * 1.6, 0.0, 1.0)
	if seen > 0.0:
		var sx := _sill_x(float(clues.get("bearing", 0)))
		var sy := 292.0 + 3.0 * sin(t * 1.4)
		var hull := Color(0.02, 0.06, 0.05, seen)
		poly([sx - 38, sy, sx + 38, sy, sx + 28, sy + 14, sx - 30, sy + 14], hull)
		ln(sx, sy, sx, sy - 62, hull, 4)
		poly([sx + 3, sy - 58, sx + 30, sy - 12, sx + 3, sy - 12], hull)
		poly([sx - 3, sy - 48, sx - 26, sy - 10, sx - 3, sy - 10], hull)
		for p in [[330, 318], [352, 328], [300, 330]]:
			poly([p[0] - 14, p[1] + 10, p[0], p[1] - 12, p[0] + 16, p[1] + 10], hull)
	for i in range(70):
		var rx := fmod(i * 37.0 + t * 60.0, 960.0)
		var ry := fmod(i * 53.0 + t * 260.0, 400.0)
		ln(rx, ry, rx - 6, ry + 16, Color(0.8, 0.9, 0.95, 0.4), 1.5)
	# Frame and the sill with its brass scale.
	for k in range(4):
		r(k * 310.0, 0, 30, 400, TIMBER_D)
	r(0, 0, 960, 26, TIMBER_D)
	r(0, 392, 960, 80, TIMBER_D)
	rr(60, 400, 840, 50, BRASS, 4)
	for d in range(200, 281, 5):
		var x := _sill_x(float(d))
		var tall := d % 10 == 0
		ln(x, 400, x, 416 if tall else 410, INK, 2 if tall else 1.5)
		if tall:
			txt(x, 440, str(d), 17, INK)


const GEAR_Y := 230.0
const GEAR_X0 := 190.0
const GEAR_SCALE := 2.0


## Screen x of the fixed wheel (0), the pegs (1..3) and the lamp's wheel (4).
func gear_x(i: int) -> float:
	var gaps: Array = clues.get("peg_gaps", [70, 60, 70, 80])
	var x := GEAR_X0
	for k in range(mini(i, gaps.size())):
		x += float(gaps[k]) * GEAR_SCALE
	return x


func _gears() -> void:
	board(Color("26332f"))
	rr(60, 40, 840, 400, DARK_IRON, 10)
	for p in [[76, 56], [884, 56], [76, 424], [884, 424]]:
		c(p[0], p[1], 6, STEEL)
	var radii: Array = clues.get("gear_radii", [20, 30, 40, 50])
	var end := float(clues.get("end_radius", 30)) * GEAR_SCALE
	var pegs: Array = st.get("pegs", [0, 0, 0])
	var turning: bool = flag("wound")
	var spin := t * 1.2 if turning else 0.0
	gear_wheel(gear_x(0), GEAR_Y, end, STEEL, spin)
	gear_wheel(gear_x(4), GEAR_Y, end, STEEL, spin)
	# The lamp's shaft, up from the last wheel.
	r(gear_x(4) - 7, 40, 14, GEAR_Y - 40, STEEL.darkened(0.2))
	for i in range(3):
		var x := gear_x(i + 1)
		var which := int(pegs[i])
		if which > 0:
			var dir := -1.0 if i % 2 == 0 else 1.0
			gear_wheel(x, GEAR_Y, float(radii[which - 1]) * GEAR_SCALE, BRASS, spin * dir * end / (float(radii[which - 1]) * GEAR_SCALE))
		else:
			c(x, GEAR_Y, 12, STEEL)
			c(x, GEAR_Y, 6, DARK_IRON)
	# The crank's square, on the first wheel.
	if turning:
		ln(gear_x(0), GEAR_Y, gear_x(0) + cos(spin) * 70, GEAR_Y + sin(spin) * 70, STEEL, 9)
		c(gear_x(0) + cos(spin) * 70, GEAR_Y + sin(spin) * 70, 12, WOOD_D)
	else:
		r(gear_x(0) - 9, GEAR_Y - 9, 18, 18, CREAM)


func _drum() -> void:
	board(Color("26332f"))
	rr(100, 120, 760, 230, BRASS_D, 60)
	rr(100, 150, 760, 170, BRASS, 30)
	# The way the drum turns.
	ln(360, 76, 600, 76, CREAM, 6)
	poly([340, 76, 372, 58, 372, 94], CREAM)
	var pins: Array = st.get("pins", [0, 0, 0, 0, 0, 0, 0, 0])
	for k in range(pins.size()):
		var x := 166.0 + k * 90.0
		c(x, 236, 30, BRASS_D)
		if int(pins[k]) == 1:
			c(x, 236, 24, CREAM)
			c(x - 6, 230, 8, Color(1, 1, 1, 0.6))
		else:
			c(x, 236, 20, DARK_IRON)
	r(100, 370, 760, 10, DARK_IRON)


func _valves() -> void:
	board(Color("26332f"))
	rr(80, 30, 800, 420, STEEL.darkened(0.4), 10)
	var gauges: Array = st.get("gauges", [0, 0, 0])
	var green := int(clues.get("gauge_green", 2))
	var valves: Array = clues.get("valves", [])
	var pipes := [Color("b87333"), Color("7fa6b8"), Color("c9c08a")]
	# Pipes from each valve to the gauges it feeds.
	for v in range(valves.size()):
		var vx := 250.0 + v * 230.0
		for g in valves[v]:
			var gx := 250.0 + int(g) * 230.0
			var lane := 228.0 + v * 22.0
			ln(vx - 14 + v * 14, 350, vx - 14 + v * 14, lane, pipes[v], 8)
			ln(vx - 14 + v * 14, lane, gx - 14 + v * 14, lane, pipes[v], 8)
			ln(gx - 14 + v * 14, lane, gx - 14 + v * 14, 150, pipes[v], 8)
	for k in range(3):
		var x := 250.0 + k * 230.0
		c(x, 130, 66, DARK_IRON)
		c(x, 130, 58, CREAM)
		for p in range(4):
			var a := -PI * 0.75 + p * PI / 2
			ci.draw_arc(Vector2(x, 130), 48, a - 0.5, a + 0.5, 10, Color("69d06a") if p == green else INK.lightened(0.5), 8, true)
		var ga := -PI * 0.75 + float(gauges[k]) * PI / 2
		ln(x, 130, x + cos(ga) * 42, 130 + sin(ga) * 42, RED, 5)
		c(x, 130, 7, DARK_IRON)
		# The valve's wheel.
		ring(x, 370, 44, pipes[k], 12)
		for s in range(3):
			var a2 := TAU * s / 3.0
			ln(x, 370, x + cos(a2) * 44, 370 + sin(a2) * 44, pipes[k], 8)
		c(x, 370, 10, DARK_IRON)


func _bearing() -> void:
	board(Color("26332f"))
	# Compass ring.
	c(250, 236, 180, BRASS_D)
	c(250, 236, 166, CREAM)
	for d in range(0, 360, 10):
		var a := deg_to_rad(float(d)) - PI / 2
		var inner := 140.0 if d % 30 == 0 else 152.0
		ln(250 + cos(a) * inner, 236 + sin(a) * inner, 250 + cos(a) * 165, 236 + sin(a) * 165, INK, 2)
		if d % 30 == 0:
			txt(250 + cos(a) * 120, 236 + sin(a) * 120 + 7, str(d), 16, INK)
	var value: Array = st.get("bearing", [0, 0, 0])
	var degrees := int(value[0]) * 100 + int(value[1]) * 10 + int(value[2])
	var na := deg_to_rad(float(degrees)) - PI / 2
	ln(250, 236, 250 + cos(na) * 104, 236 + sin(na) * 104, RED, 6)
	poly([250 + cos(na) * 124, 236 + sin(na) * 124, 250 + cos(na + 0.12) * 98, 236 + sin(na + 0.12) * 98,
		250 + cos(na - 0.12) * 98, 236 + sin(na - 0.12) * 98], RED)
	c(250, 236, 10, DARK_IRON)
	# The counter.
	rr(520, 120, 340, 250, BRASS_D, 12)
	_digit_wheels(value, 590, 238)
	txt(826, 262, "°", 54, CREAM)


## A padlock for the difficulty on a room's card.
func padlock(x: float, y: float, on: bool) -> void:
	var col := Color(CREAM, 1.0 if on else 0.22)
	ci.draw_arc(Vector2(x, y - 2), 6, PI, TAU, 10, col, 3, true)
	rr(x - 9, y - 2, 18, 15, col, 3)


## The picture on a room's card.
func card(room: String, w: float, h: float) -> void:
	if room == "light":
		r(0, 0, w, h, Color("1b2c2b"))
		var wave := [0.0, h, 0.0, h * 0.72]
		for k in range(1, 13):
			wave.append_array([w * k / 12.0, h * 0.72 + 5.0 * sin(k * 1.4 + t * 1.2)])
		wave.append_array([w, h])
		var cx := w * 0.42
		poly([cx, h * 0.24, w, h * 0.02, w, h * 0.46], Color(1, 0.85, 0.45, 0.28 + 0.08 * sin(t * 2.0)))
		poly([cx - 20, h * 0.86, cx - 11, h * 0.32, cx + 11, h * 0.32, cx + 20, h * 0.86], CREAM.darkened(0.1))
		r(cx - 14, h * 0.52, 28, 13, RED)
		r(cx - 13, h * 0.17, 26, h * 0.15, AMBER)
		poly([cx - 17, h * 0.17, cx, h * 0.04, cx + 17, h * 0.17], DARK_IRON)
		poly(wave, Color("14312d"))
		for i in range(16):
			var rx := fmod(i * 37.0 + t * 50.0, w)
			var ry := fmod(i * 53.0 + t * 200.0, h)
			ln(rx, ry, rx - 4, ry + 11, Color(0.8, 0.9, 0.95, 0.3), 1.5)
	else:
		r(0, 0, w, h, Color("3b2a1e"))
		for k in range(4):
			r(0, k * h / 4.0, w, 2, Color("2e2017"))
		r(w * 0.08, h * 0.2, w * 0.2, h * 0.45, WOOD_D)
		r(w * 0.1, h * 0.25, w * 0.16, h * 0.35, NIGHT)
		for i in range(9):
			c(w * 0.1 + fmod(i * 17.0 + t * 9.0, w * 0.16), h * 0.25 + fmod(i * 23.0 + t * 16.0, h * 0.35), 1.5, SNOW)
		rr(w * 0.4, h * 0.42, w * 0.13, h * 0.5, IRON, 5)
		r(w * 0.445, 0, w * 0.04, h * 0.42, IRON)
		rr(w * 0.62, h * 0.7, w * 0.28, 7, WOOD, 2)
		c(w * 0.76, h * 0.58, h * 0.5, Color(1, 0.6, 0.23, 0.16))
		c(w * 0.76, h * 0.58, h * 0.25, Color(1, 0.6, 0.23, 0.16))
		rr(w * 0.74, h * 0.62, w * 0.04, 9, BRASS, 2)
		poly([w * 0.76, h * 0.42, w * 0.775, h * 0.56, w * 0.76, h * 0.62, w * 0.745, h * 0.56], Color("fff1a8"))
