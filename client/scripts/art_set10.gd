## Draws the tenth set on top of ArtCity: The Moon-Viewing Garden (MG…),
## The Great Balloon Race (BL…) and The Dragon's Egg (DG…), with close-ups.
## Hotspots are in views_set10.gd.
class_name ArtSet10
extends ArtCity

const T10_NIGHT := Color("101a33")
const T10_NIGHT2 := Color("24345e")
const T10_MOON := Color("f6efd2")
const T10_WOOD := Color("6a4a30")
const T10_WOOD_L := Color("9a7048")
const T10_TATAMI := Color("b8b070")
const T10_PAPER := Color("efe6cc")
const T10_MOSS := Color("3f6a3a")
const T10_STONE := Color("8a8a84")
const T10_WATER := Color("1f3f5a")
const T10_KOI := [Color("e0502a"), Color("f2f0ea"), Color("f0b830"), Color("2a2a2a")]
const T10_SKY := Color("9cc8e8")
const T10_GRASS := Color("7fae52")
const T10_SILK := [Color("c83a3a"), Color("f2e6c8"), Color("2a5a9a"), Color("e8b84a")]
const T10_ROPES := [Color("c83a3a"), Color("2a6aa8"), Color("e8c030"), Color("3a9a4a")]
const T10_ROCK := Color("3a3438")
const T10_ROCK_D := Color("241f24")
const T10_GOLD := Color("e8b84a")
const T10_LAVA := Color("ff6a1a")
const T10_SCALE := Color("2f7a5a")
const T10_SNOW := Color("e8eef6")
const T10_RUNES := ["sun", "tree", "wave", "eye", "hill", "star"]
const T10_KEYS := ["crown", "skull", "star", "moon"]


func draw_view(view: String) -> void:
	match view:
		"MG1": _mg1()
		"MG2": _mg2()
		"MG3": _mg3()
		"MG4": _mg4()
		"mgscroll": _mgscroll()
		"mgtea": _mgtea()
		"mgkoi": _mgkoi()
		"mgpond": _mgpond()
		"mggravel": _mggravel()
		"mggate": _mggate()
		"BL1": _bl1()
		"BL2": _bl2()
		"BL3": _bl3()
		"BL4": _bl4()
		"blcard": _blcard()
		"blcase": _blcase()
		"blrigging": _blrigging()
		"blmap": _blmap()
		"blnote": _blnote()
		"DG1": _dg1()
		"DG2": _dg2()
		"DG3": _dg3()
		"DG4": _dg4()
		"dgrunes": _dgrunes()
		"dgcart": _dgcart()
		"dgbells": _dgbells()
		"dghoard": _dghoard()
		"dgnotes": _dgnotes()
		"dgmirrors": _dgmirrors()
		"dgfloor": _dgfloor()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"mgrake":
			at(x, y, -0.6, s)
			r(-2, -18, 4, 30, T10_WOOD_L)
			r(-12, 10, 24, 4, T10_WOOD)
			for k in range(5):
				r(-11 + k * 5, 14, 2, 6, T10_WOOD)
		"mgchestkey", "dgrope":
			if name == "dgrope":
				at(x, y, 0.0, s)
				for k in range(3):
					ring(0, 0, 6 + k * 4, Color("c8a868"), 3)
			else:
				super.item("key", x, y, s)
				return
		"mgfood":
			at(x, y, 0.0, s)
			rr(-12, -6, 24, 16, Color("c8a060"), 6)
			for k in range(4):
				c(-6 + k * 4, -6, 2.5, Color("d84a2a"))
		"mgcandles":
			at(x, y, 0.0, s)
			for k in range(3):
				r(-10 + k * 7, -12, 5, 22, Color("f2ead8"))
		"mglit":
			at(x, y, 0.0, s)
			for k in range(3):
				r(-10 + k * 7, -8, 5, 18, Color("f2ead8"))
				c(-7.5 + k * 7, -11 + sin(t * 9.0 + k), 3, FIRE)
		"mgladle", "mgwater":
			at(x, y, -0.5, s)
			r(-2, -18, 3, 24, Color("c8b080"))
			c(0, 10, 8, Color("c8b080"))
			if name == "mgwater":
				c(0, 10, 6, Color("6ab0e0"))
		"mgcharcoal":
			at(x, y, 0.0, s)
			for k in range(4):
				c(-8 + k * 5, 2 - (k % 2) * 4, 6, Color("2a2a2a"))
		"mgmatches":
			super.item("matches", x, y, s)
			return
		"mgfan":
			at(x, y, 0.0, s)
			for k in range(7):
				var a := PI + PI * k / 6.0
				poly([0, 8, cos(a) * 20, 8 + sin(a) * 20, cos(a + 0.45) * 20, 8 + sin(a + 0.45) * 20], Color("e8d8b8") if k % 2 == 0 else Color("c83a3a"))
		"blwrench":
			super.item("waspanner", x, y, s)
			return
		"blsand":
			at(x, y, 0.0, s)
			rr(-12, -12, 24, 26, Color("c8a878"), 8)
			r(-6, -16, 12, 6, Color("8a6a3a"))
		"blbinoculars":
			at(x, y, 0.0, s)
			rr(-14, -8, 12, 18, Color("2a2a2a"), 4)
			rr(2, -8, 12, 18, Color("2a2a2a"), 4)
			r(-3, -4, 6, 6, BRASS)
		"blchampagne":
			at(x, y, 0.2, s)
			rr(-6, -6, 12, 22, Color("2a5a3a"), 4)
			r(-3, -16, 6, 12, Color("2a5a3a"))
			r(-4, -18, 8, 4, T10_GOLD)
		"blpigeon":
			at(x, y, 0.0, s)
			c(0, 2, 10, Color("a8a8b8"))
			c(8, -6, 5, Color("8a8a9a"))
			poly([12, -6, 17, -5, 12, -3], Color("e8a020"))
		"dgtorch", "dglit":
			at(x, y, -0.4, s)
			r(-2, -6, 4, 24, T10_WOOD)
			c(0, -8, 5, Color("6a5a4a"))
			if name == "dglit":
				c(0, -13 + sin(t * 9.0), 6, FIRE)
				c(0, -14, 3, AMBER)
		"dgegg", "dgwrapped", "dghot":
			at(x, y, 0.0, s)
			ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(s * 0.8, s))
			c(0, 0, 14, Color("6a8aa8") if name == "dgegg" else Color("8a3a2a"))
			if name == "dghot":
				c(0, 0, 18, Color(1, 0.5, 0.2, 0.3 + 0.1 * sin(t * 4.0)))
			at(x, y, 0.0, s)
			if name != "dgegg":
				poly([-12, 4, 12, 4, 10, 14, -10, 14], T10_SCALE)
			for k in range(3):
				c(-4 + k * 4, -4 + k * 3, 2, Color(1, 1, 1, 0.3))
		"dgscale":
			at(x, y, 0.3, s)
			poly([0, -14, 12, 0, 0, 14, -12, 0], T10_SCALE)
			c(0, 0, 4, Color(1, 0.6, 0.3, 0.6 + 0.3 * sin(t * 3.0)))
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"moon":
			r(0, 0, w, h, T10_NIGHT)
			var rise := 0.5 + 0.5 * sin(t * 0.6)
			c(w * 0.7, h * (0.55 - 0.25 * rise), h * 0.16, T10_MOON)
			r(0, h * 0.62, w, h * 0.38, T10_WATER)
			ci.draw_set_transform(Vector2(w * 0.7, h * 0.8), 0.0, Vector2(1, 0.25))
			c(0, 0, h * 0.16, Color(T10_MOON, 0.35 + 0.15 * sin(t * 2.0)))
			home()
			ring(w * 0.28, h * 0.48, h * 0.26, T10_WOOD, 4)
			for k in range(2):
				var kx := fmod(t * 12.0 + k * w * 0.5, w)
				poly([kx, h * 0.82, kx + 8, h * 0.79, kx + 8, h * 0.85], T10_KOI[k * 2])
		"balloon":
			r(0, 0, w, h, T10_SKY)
			r(0, h * 0.78, w, h * 0.22, T10_GRASS)
			for k in range(2):
				var bx := w * (0.3 + 0.4 * k) + 6 * sin(t * 0.8 + k)
				var by := h * (0.38 + 0.1 * k) + 4 * sin(t * 1.1 + k)
				c(bx, by, h * (0.2 - 0.05 * k), T10_SILK[k * 2])
				ln(bx - 5, by + h * 0.15, bx - 3, by + h * 0.26, INK, 1)
				ln(bx + 5, by + h * 0.15, bx + 3, by + h * 0.26, INK, 1)
				r(bx - 4, by + h * 0.25, 8, 6, T10_WOOD)
			var cx := fmod(t * 6.0, w + 40.0) - 20.0
			c(cx, h * 0.12, 8, Color(1, 1, 1, 0.8))
			c(cx + 9, h * 0.1, 7, Color(1, 1, 1, 0.8))
		"dragon":
			r(0, 0, w, h, T10_ROCK_D)
			c(w * 0.5, h * 0.95, w * 0.45, Color(1, 0.6, 0.2, 0.15))
			for k in range(9):
				c(w * (0.1 + 0.1 * k), h * 0.9 - (k % 3) * 3, 6, T10_GOLD)
			var breath := 0.5 + 0.5 * sin(t * 1.5)
			ci.draw_set_transform(Vector2(w * 0.5, h * 0.6), 0.0, Vector2(1.0 + 0.06 * breath, 0.6 + 0.04 * breath))
			c(0, 0, h * 0.32, Color("8a2a2a"))
			home()
			c(w * 0.78, h * 0.52, h * 0.14, Color("8a2a2a"))
			ln(w * 0.82, h * 0.5, w * 0.86, h * 0.5, Color(1, 0.8, 0.3) if fmod(t, 4.0) < 0.3 else INK, 1.5)
			c(w * 0.3, h * 0.72, 5, Color("6a8aa8"))
			for k in range(5):
				var ey := h - fmod(t * 14.0 + k * 13.0, h)
				c(w * (0.2 + 0.15 * k) + 3 * sin(t * 2.0 + k), ey, 1.5, Color(1, 0.6, 0.2, 0.8))
		_:
			super.card(room, w, h)


# --- The Moon-Viewing Garden -------------------------------------------------------

func _t10_moon_sky(horizon: float = 300.0) -> void:
	for k in range(6):
		r(0, k * horizon / 6.0, 960, horizon / 6.0 + 1, T10_NIGHT.lerp(T10_NIGHT2, k / 5.0))
	for k in range(18):
		c(float((k * 151) % 960), float((k * 67) % int(horizon * 0.7)), 1.3, Color(1, 1, 0.9, 0.5 + 0.3 * sin(t + k)))
	var up := 1.0 if flag("done") else 0.0
	c(700, 130 - up * 80, 46, T10_MOON)
	c(700, 130 - up * 80, 70, Color(T10_MOON, 0.12))
	if not flag("done"):
		for k in range(4):
			rr(600 + k * 40 + 10 * sin(t * 0.3 + k), 110 + (k % 2) * 16, 120, 30, Color("4a5470"), 15)


func _t10_pine(x: float, y: float, s: float) -> void:
	r(x - 6 * s, y - 60 * s, 12 * s, 60 * s, Color("4a3424"))
	for k in range(3):
		rr(x - (70 - k * 14) * s, y - (80 + k * 40) * s, (140 - k * 28) * s, 34 * s, Color("2f4a32"), 16)


func _mg1() -> void:
	# The veranda room: paper walls, tatami, the alcove with its scroll.
	r(0, 0, 960, 372, T10_PAPER.darkened(0.25))
	for k in range(9):
		r(k * 110.0, 0, 6, 372, T10_WOOD)
	for k in range(5):
		r(0, k * 80.0, 960, 4, T10_WOOD)
	r(0, 372, 960, 100, T10_TATAMI.darkened(0.2))
	for k in range(4):
		ln(k * 240.0, 372, k * 240.0 - 60, 472, T10_TATAMI.darkened(0.45), 3)
	r(50, 50, 170, 320, T10_WOOD.darkened(0.3))
	r(80, 70, 110, 220, T10_PAPER)
	for k in range(5):
		ln(96, 100 + k * 30, 174, 100 + k * 30, Color(INK, 0.25), 2)
	c(135, 300, 18, Color("6a8a5a"))
	# The painted screen: four koi in a row.
	r(250, 70, 260, 170, Color("e8dcc0"))
	r(250, 70, 260, 170, Color(1, 1, 1, 0.0))
	for k in range(3):
		r(250 + k * 87, 70, 2, 170, T10_WOOD)
	var koi: Array = clues.get("koi", [0, 1, 2, 3])
	for k in range(koi.size()):
		_t10_fish(290 + k * 62, 170 + 12 * sin(k), 0.8, T10_KOI[int(koi[k])], 0.0)
	# Ms Aoki kneeling, her wrist bound.
	poly([580, 370, 700, 370, 690, 250, 590, 250], Color("5a3a6a"))
	c(640, 220, 26, Color("e8c8a8"))
	poly([614, 206, 666, 206, 660, 186, 620, 186], Color("1a1a1a"))
	r(676, 300, 26, 14, Color("f2f2f2"))
	# The tea chest, the brazier and the kettle.
	rr(250, 280, 150, 90, T10_WOOD_L if not flag("chest_open") else T10_WOOD, 4)
	if not flag("chest_open"):
		c(325, 320, 6, BRASS)
	rr(430, 300, 110, 70, Color("5a4a3a"), 6)
	if flag("fire_lit"):
		c(485, 300, 22, Color(1, 0.5, 0.1, 0.5 + 0.2 * sin(t * 6.0)))
	elif flag("coal_in"):
		c(485, 300, 18, Color("2a2a2a"))
	rr(450, 214, 70, 58, IRON, 18)
	ln(470, 214, 500, 214, IRON, 4)
	if flag("kettle_full") and flag("fire_lit"):
		for k in range(3):
			c(490 + 6 * sin(t * 2.0 + k), 200 - fmod(t * 20.0 + k * 12.0, 40.0), 6, Color(1, 1, 1, 0.3))
	# The shelf with matches, the wind chime.
	r(720, 310, 160, 8, T10_WOOD)
	if not flag("got_matches"):
		item("mgmatches", 785, 292, 1.2)
	ln(850, 40, 850, 80, INK, 1.5)
	c(850, 92, 14, Color("4a6a8a"))
	r(844, 106, 12, 50 + 6 * sin(t * 2.0), PAPER)


func _t10_fish(x: float, y: float, s: float, col: Color, turn: float) -> void:
	at(x, y, turn, s)
	ci.draw_set_transform(Vector2(x, y), turn, Vector2(s * 1.6, s * 0.7))
	c(0, 0, 16, col)
	at(x, y, turn, s)
	poly([-22, 0, -36, -10, -36, 10], col)
	c(14, -3, 2, INK)
	home()


func _mg2() -> void:
	_t10_moon_sky(200)
	_t10_pine(120, 200, 1.0)
	r(0, 200, 960, 272, T10_MOSS.darkened(0.3))
	ci.draw_set_transform(Vector2(340, 300), 0.0, Vector2(1, 0.35))
	c(0, 0, 300, T10_WATER)
	home()
	for k in range(4):
		var fx := 200 + k * 90 + 40 * sin(t * 0.4 + k)
		_t10_fish(fx, 290 + 10 * k % 30, 0.6, T10_KOI[k], sin(t * 0.4 + k) * 0.3)
	# The stone lantern on its little island, lit once the boat arrives.
	ci.draw_set_transform(Vector2(495, 220), 0.0, Vector2(1, 0.4))
	c(0, 0, 50, T10_STONE.darkened(0.3))
	home()
	r(480, 140, 30, 80, T10_STONE)
	r(460, 110, 70, 34, T10_STONE.lightened(0.1))
	poly([450, 110, 540, 110, 495, 76], T10_STONE)
	r(482, 118, 26, 20, Color(1, 0.8, 0.4, 0.9) if flag("lantern_lit") else Color("2a2a2a"))
	# The red bridge.
	ci.draw_arc(Vector2(775, 300), 130, PI * 1.1, PI * 1.9, 20, Color("b03a2a"), 14, true)
	for k in range(6):
		ln(670 + k * 42, 250 - absf(2.5 - k) * -8 - 30, 670 + k * 42, 230, Color("b03a2a"), 4)
	# The paper boat, the surfaced candle box.
	poly([150, 350, 250, 350, 232, 368, 168, 368], T10_PAPER)
	poly([180, 350, 200, 322, 220, 350], T10_PAPER.darkened(0.1))
	if flag("boat_ready") and not flag("lantern_lit"):
		c(200, 336, 6, FIRE)
	if flag("koi_fed") and not flag("got_candles"):
		rr(330, 336, 70, 30, T10_WOOD_L, 4)


func _mg3() -> void:
	_t10_moon_sky(160)
	r(0, 160, 960, 40, T10_MOSS.darkened(0.2))
	r(0, 200, 960, 272, Color("cfc8b8").darkened(0.2))
	# The gravel, smooth or raked.
	var g: Array = st.get("gravel", [0, 0, 0, 0, 0, 0])
	for row in range(6):
		var y := 220.0 + row * 26
		if flag("raked"):
			ln(150, y, 750, y, Color("a8a090").darkened(0.1), 2)
	for k in range(3):
		ci.draw_set_transform(Vector2(360 + k * 90, 160), 0.0, Vector2(1.3, 0.7))
		c(0, 0, 30 - k * 4, Color("5a5550"))
		home()
	if g.size() == 6 and not flag("raked"):
		ln(150, 300, 750, 300, Color("a8a090"), 1)
	# The fox shrine with its offering bowl.
	r(790, 120, 120, 110, Color("b03a2a"))
	poly([770, 120, 930, 120, 850, 80], Color("3a2a2a"))
	for k in [0, 1]:
		var fx: float = 760 + k * 170
		poly([fx - 14, 260, fx + 14, 260, fx + 8, 200, fx - 8, 200], Color("e8e0d0"))
		poly([fx - 8, 200, fx - 4, 186, fx, 200], Color("e8e0d0"))
		poly([fx, 200, fx + 4, 186, fx + 8, 200], Color("e8e0d0"))
	ci.draw_set_transform(Vector2(845, 280), 0.0, Vector2(1, 0.4))
	c(0, 0, 36, Color("8a3a2a"))
	home()
	if not flag("got_food"):
		for k in range(5):
			c(825 + k * 9, 276, 3, Color("d84a2a"))


func _mg4() -> void:
	_t10_moon_sky(372)
	# Bamboo, with a rake leaning among the stalks.
	for k in range(9):
		var bx := 20.0 + k * 26
		r(bx, 0, 12, 372, Color("6a8a3a").darkened((k % 3) * 0.1))
		for j in range(5):
			r(bx - 1, j * 80.0 + 30, 14, 3, Color("4a6a2a"))
	if not flag("got_rake"):
		ln(176, 360, 168, 230, Color("7a6a3a"), 4)
		r(160, 226, 20, 4, Color("7a6a3a"))
	# The deer scarer: the bamboo fills and tips, clack.
	var sc: Array = clues.get("scarer", [7, 2])
	var pouring := int(st.get("secs", 0)) % int(sc[0]) >= int(sc[0]) - int(sc[1])
	r(300, 150, 16, 40, Color("6a8a3a"))
	var tip := 0.5 if pouring else -0.25
	at(380, 200, tip)
	r(-70, -8, 140, 16, Color("7a9a4a"))
	home()
	if pouring:
		for k in range(4):
			c(440, 220 + k * 14, 3, Color("8ac0e8"))
	r(380, 196, 6, 90, Color("4a4a4a"))
	ci.draw_set_transform(Vector2(400, 315), 0.0, Vector2(1, 0.4))
	c(0, 0, 76, T10_STONE.darkened(0.2))
	c(0, 0, 60, T10_WATER)
	home()
	if not flag("got_ladle"):
		item("mgladle", 525, 340, 1.4)
	r(0, 372, 960, 100, T10_MOSS.darkened(0.4))
	# The charcoal shed and the moon gate.
	r(580, 170, 140, 200, T10_WOOD.darkened(0.3))
	poly([570, 170, 730, 170, 650, 130], Color("3a2a2a"))
	r(800, 40, 140, 332, Color("d8d0c0").darkened(0.35))
	c(870, 200, 80, Color("15100c") if not flag("gate_aligned") else Color(T10_MOON, 0.4))


func _mgscroll() -> void:
	board(T10_WOOD.darkened(0.3))
	for k in range(2):
		var x0 := 140.0 + k * 360
		r(x0, 20, 320, 440, T10_PAPER)
		r(x0 - 10, 14, 340, 10, T10_WOOD)
		r(x0 - 10, 456, 340, 10, T10_WOOD)
	# The garden's beds: lines, rings, waves.
	var g: Array = clues.get("gravel", [])
	for k in range(g.size()):
		var bx := 170.0 + (k % 3) * 90
		var by := 100.0 + int(k / 3) * 150
		_t10_bed(bx, by, 80, 120, int(g[k]), INK)
	# The tea: five tools in the order of the ceremony.
	var tea: Array = clues.get("tea", [])
	for k in range(tea.size()):
		_t10_tool(int(tea[k]), 660, 70 + k * 80, 0.8)
		txt(560, 82 + k * 80, str(k + 1), 22, INK)


func _t10_bed(x: float, y: float, w: float, h: float, kind: int, col: Color) -> void:
	match kind:
		0:
			for k in range(5):
				ln(x + 6, y + 12 + k * (h - 24) / 4.0, x + w - 6, y + 12 + k * (h - 24) / 4.0, col, 2)
		1:
			for k in range(3):
				ring(x + w / 2, y + h / 2, 10 + k * 12, col, 2)
		_:
			for k in range(4):
				var pts := PackedVector2Array()
				for j in range(9):
					pts.append(Vector2(x + 6 + j * (w - 12) / 8.0, y + 20 + k * (h - 40) / 3.0 + 6 * sin(j * 1.2)))
				ci.draw_polyline(pts, col, 2, true)


func _t10_tool(kind: int, x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	match kind:
		0:
			rr(-30, -16, 60, 32, Color("c83a3a"), 4)
			ln(-24, 0, 24, 0, Color(1, 1, 1, 0.4), 2)
		1:
			r(-36, -3, 64, 6, Color("c8b080"))
			ci.draw_set_transform(Vector2(x + 30 * s, y), 0.0, Vector2(s * 1.4, s * 0.8))
			c(0, 0, 8, Color("c8b080"))
		2:
			r(-36, -3, 50, 6, Color("c8b080"))
			c(22, 0, 14, Color("c8b080"))
		3:
			r(-4, -36, 8, 30, Color("e8d8b0"))
			for k in range(7):
				ln(0, -6, -14 + k * 4.6, 30, Color("e8d8b0"), 2)
		_:
			poly([-34, -20, 34, -20, 26, 20, -26, 20], Color("3a5a4a"))
			r(-20, -12, 40, 4, Color("5a8a3a"))
	home()


func _mgtea() -> void:
	r(0, 0, 960, 472, T10_TATAMI.darkened(0.25))
	rr(260, 40, 440, 160, T10_WOOD.darkened(0.2), 8)
	_t10_tool(3, 480, 130, 1.2)
	var steps := int(st.get("steps", [0])[0])
	for k in range(5):
		var x := 110.0 + int(Set10Views.TOOL_SLOT[k]) * 150 + 65
		rr(x - 65, 240, 130, 160, Color(0, 0, 0, 0.15), 10)
		_t10_tool(k, x, 320, 1.4)
	for k in range(5):
		c(380 + k * 50, 440, 10, T10_GOLD if k < steps or flag("tea_served") else Color(1, 1, 1, 0.15))


func _mgkoi() -> void:
	r(0, 0, 960, 472, T10_WATER)
	for k in range(14):
		var wx := fmod(k * 131.0 + t * 8.0, 1000.0) - 20.0
		ring(wx, 60 + (k * 37) % 380, 10 + fmod(t * 10.0 + k * 7, 30.0), Color(1, 1, 1, 0.12), 2)
	for k in range(3):
		c(120 + k * 340, 420, 50, Color("2f6a3a"))
	for k in range(4):
		var z := int(Set10Views.KOI_ZONE[k])
		var cx := 155.0 + z * 215
		var a := t * 0.9 + k
		_t10_fish(cx + cos(a) * 40, 250 + sin(a) * 40, 1.5, T10_KOI[k], a + PI / 2)
	var fed := int(st.get("fed", [0])[0])
	for k in range(4):
		c(400 + k * 50, 440, 9, T10_GOLD if k < fed or flag("koi_fed") else Color(1, 1, 1, 0.15))


func _mgpond() -> void:
	r(0, 0, 960, 472, T10_MOSS.darkened(0.35))
	var p: Dictionary = clues.get("pond", {})
	var w := int(p.get("w", 7))
	var h := int(p.get("h", 5))
	var blocked: Array = p.get("blocked", [])
	for i in range(w * h):
		var rect := Set10Views.grid_rect(i, w)
		r(rect.position.x, rect.position.y, rect.size.x, rect.size.y, T10_WATER)
		if i in blocked.map(func(b: Variant) -> int: return int(b)):
			c(rect.get_center().x, rect.get_center().y, 30, Color("3f7a3a"))
			poly([rect.get_center().x, rect.get_center().y, rect.get_center().x + 30, rect.get_center().y - 8, rect.get_center().x + 30, rect.get_center().y + 8], T10_WATER)
	for k in range(6):
		var y := Set10Views.GRID_AT.y + 20 + k * 60
		var x := Set10Views.GRID_AT.x + fmod(t * 20.0 + k * 50.0, w * Set10Views.GRID_CELL)
		ln(x, y, x + 20, y, Color(1, 1, 1, 0.25), 2)
	var goal := Set10Views.grid_rect(int(p.get("goal", 13)), w)
	r(goal.position.x + 4, goal.position.y + 4, goal.size.x - 8, goal.size.y - 8, T10_STONE.darkened(0.2))
	r(goal.get_center().x - 8, goal.position.y + 10, 16, 40, Color(1, 0.8, 0.4) if flag("lantern_lit") else T10_STONE)
	var bank := Set10Views.grid_rect(int(p.get("start", 21)), w)
	r(bank.position.x - 50, bank.position.y, 50, bank.size.y, T10_MOSS)
	var bp := Set10Views.grid_rect(int(st.get("boat", [21])[0]), w).get_center()
	poly([bp.x - 18, bp.y, bp.x + 18, bp.y, bp.x + 12, bp.y + 10, bp.x - 12, bp.y + 10], T10_PAPER)
	poly([bp.x - 6, bp.y, bp.x, bp.y - 14, bp.x + 6, bp.y], T10_PAPER.darkened(0.1))
	c(bp.x, bp.y - 4, 4, FIRE)
	# The current flows east.
	poly([660, 420, 700, 420, 700, 410, 720, 428, 700, 446, 700, 436, 660, 436], Color(1, 1, 1, 0.3))
	for d in ["n", "w", "e", "s"]:
		var rect: Rect2 = Set10Views.PAD[d]
		arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, {"n": 0, "s": 1, "w": 2, "e": 3}[d])
	item("mgfan", 816, 330, 2.0)


func _mggravel() -> void:
	r(0, 0, 960, 472, Color("cfc8b8").darkened(0.15))
	var g: Array = st.get("gravel", [0, 0, 0, 0, 0, 0])
	for k in range(6):
		var x := Set10Views.BED_AT.x + (k % 3) * Set10Views.BED.x
		var y := Set10Views.BED_AT.y + int(k / 3) * Set10Views.BED.y
		rr(x + 4, y + 4, Set10Views.BED.x - 8, Set10Views.BED.y - 8, Color("d8d0c0"), 6)
		_t10_bed(x + 10, y + 10, Set10Views.BED.x - 20, Set10Views.BED.y - 20, int(g[k]), Color("8a8070"))
	for k in range(3):
		var rx := Set10Views.BED_AT.x + Set10Views.BED.x * (0.5 + k)
		c(rx, Set10Views.BED_AT.y + Set10Views.BED.y, 22, Color("5a5550"))
	item("mgrake", 880, 400, 2.0)
	if flag("raked") and not flag("got_chestkey"):
		c(Set10Views.BED_AT.x + 2 * Set10Views.BED.x + 125, Set10Views.BED_AT.y + Set10Views.BED.y + 80, 6 + 2 * sin(t * 4.0), Color(1, 0.9, 0.5, 0.9))


func _mggate() -> void:
	r(0, 0, 960, 472, Color("d8d0c0").darkened(0.4))
	c(480, 220, 230, Color("15100c"))
	ring(480, 220, 230, Color("d8d0c0").darkened(0.2), 16)
	var rings: Array = st.get("rings", [0, 0, 0])
	var full := int(clues.get("full", 4))
	for k in range(3):
		var x: float = Set10Views.RING_X[k]
		c(x, Set10Views.RING_Y, 60, Color("2a2a3a"))
		ring(x, Set10Views.RING_Y, 60, T10_GOLD, 4)
		_t10_phase(x, Set10Views.RING_Y, 40, int(rings[k]))
		for j in range(8):
			var a := TAU * j / 8.0 - PI / 2
			c(x + cos(a) * 52, Set10Views.RING_Y + sin(a) * 52, 3 if j != full else 5, T10_GOLD if j == full else Color(T10_GOLD, 0.4))
	# Small links between the rings: each turns the next.
	for k in range(3):
		ln(Set10Views.RING_X[k] + 60, Set10Views.RING_Y + 50, Set10Views.RING_X[(k + 1) % 3] - 60, Set10Views.RING_Y + 50, Color(T10_GOLD, 0.4), 2)
	# The gong.
	ln(410, 350, 550, 350, T10_WOOD, 6)
	c(480, 398, 42, Color("b8902a"))
	ring(480, 398, 42, Color("8a6a1a"), 4)


func _t10_phase(x: float, y: float, rad: float, phase: int) -> void:
	c(x, y, rad, Color("1a1a2a"))
	var lit := absf(4.0 - phase) / 4.0
	c(x, y, rad, T10_MOON)
	var off := (phase - 4) * rad / 2.0
	c(x + off, y, rad * (0.4 + 0.6 * lit), Color("1a1a2a") if phase != 4 else T10_MOON)


# --- The Great Balloon Race -------------------------------------------------------------

func _t10_balloon(x: float, y: float, s: float, colours: Array, flat: bool = false) -> void:
	at(x, y, 0.0, s)
	if flat:
		poly([-90, 60, 90, 60, 60, 40, -60, 40], colours[0])
		home()
		return
	for k in range(6):
		var a := -PI / 2 + (k - 2.5) * 0.28
		poly([0, 70, cos(a - 0.14) * 90, -40 + sin(a - 0.14) * 90, cos(a + 0.14) * 90, -40 + sin(a + 0.14) * 90], colours[k % colours.size()])
	c(0, -40, 86, Color(colours[0], 0.0))
	for k in range(4):
		ln(-50 + k * 33, 30, -14 + k * 9, 110, INK, 1.5)
	r(-20, 110, 40, 28, T10_WOOD_L)
	home()


func _bl1() -> void:
	r(0, 0, 960, 300, T10_SKY)
	for k in range(5):
		var cx := fmod(k * 210.0 + t * 6.0, 1100.0) - 80
		c(cx, 50 + (k % 2) * 30, 30, Color(1, 1, 1, 0.8))
		c(cx + 30, 40 + (k % 2) * 30, 24, Color(1, 1, 1, 0.8))
	r(0, 260, 960, 212, T10_GRASS)
	# Bunting and the crowd.
	for k in range(16):
		poly([k * 60.0, 20, k * 60.0 + 30, 20, k * 60.0 + 15, 44], T10_SILK[k % 4])
	for k in range(10):
		c(30 + k * 95.0, 250, 12, Color("e0b890"))
		r(22 + k * 95.0, 260, 16, 24, T10_ROPES[k % 4].darkened(0.3))
	# The judge at his table, the race card on it.
	r(40, 260, 220, 14, T10_WOOD)
	r(50, 274, 10, 90, T10_WOOD)
	r(240, 274, 10, 90, T10_WOOD)
	c(90, 170, 20, Color("e0b890"))
	r(66, 150, 48, 10, Color("1a1a1a"))
	r(78, 120, 24, 30, Color("1a1a1a"))
	poly([70, 190, 110, 190, 120, 262, 60, 262], Color("2a2a3a"))
	if not flag("got_card"):
		rr(160, 246, 80, 36, PAPER, 3)
	# The tool tent.
	poly([270, 280, 460, 280, 365, 110], Color("e8e0c8"))
	poly([340, 280, 390, 280, 365, 200], Color("6a5a40"))
	if not flag("got_wrench"):
		rr(330, 310, 70, 44, Color("8a2a2a"), 4)
	# The balloon: flat on the grass, or filled and tugging at its ropes.
	if flag("ropes_free"):
		_t10_balloon(570, 60 - 20 * sin(t * 0.3), 0.6, T10_SILK)
	elif flag("inflated"):
		_t10_balloon(570, 120 + 4 * sin(t * 1.5), 1.0, T10_SILK)
		for k in range(4):
			ln(520 + k * 34, 370, 540 + k * 10, 250, Color("8a7a5a"), 2)
	else:
		_t10_balloon(570, 280, 1.0, T10_SILK, true)
		rr(530, 290, 80, 60, T10_WOOD_L, 4)
	# The gas cart and the sand pile.
	rr(660, 290, 120, 70, Color("4a5a6a"), 10)
	c(680, 365, 14, IRON)
	c(760, 365, 14, IRON)
	c(720, 280, 10, BRASS)
	ci.draw_set_transform(Vector2(875, 345), 0.0, Vector2(1.6, 0.6))
	c(0, 0, 40, Color("d8c090"))
	home()


func _bl2() -> void:
	# Inside the basket: wicker below, the sky beyond the rim.
	r(0, 0, 960, 240, T10_SKY.lightened(0.1) if flag("ropes_free") else T10_GRASS)
	if flag("ropes_free"):
		for k in range(3):
			c(fmod(k * 330.0 + t * 10.0, 1000.0), 60 + k * 40, 28, Color(1, 1, 1, 0.7))
	else:
		for k in range(8):
			c(40 + k * 120.0, 200, 12, Color("e0b890"))
	r(0, 230, 960, 242, Color("b08a50"))
	for k in range(24):
		ln(k * 40.0, 230, k * 40.0, 472, Color("8a6a3a"), 3)
	for k in range(6):
		ln(0, 250 + k * 40, 960, 250 + k * 40, Color("8a6a3a"), 2)
	r(0, 224, 960, 14, Color("6a4a2a"))
	# The instruments on a board.
	rr(60, 60, 500, 160, T10_WOOD, 8)
	var fl: Array = st.get("flight", [40, 1, 2])
	var height := int(fl[1]) if flag("ropes_free") and not flag("landed") else 0
	c(140, 140, 60, PAPER)
	for k in range(4):
		var a := PI * 0.8 + k * PI * 0.47
		txt(140 + cos(a) * 42, 146 + sin(a) * 42, str(k), 16, INK)
	var ha := PI * 0.8 + height * PI * 0.47
	ln(140, 140, 140 + cos(ha) * 46, 140 + sin(ha) * 46, Color("c83a3a"), 4)
	for k in range(int(fl[2]) if flag("ropes_free") else 2):
		rr(90 + k * 30, 210, 24, 26, Color("c8a878"), 6)
	c(300, 140, 60, PAPER)
	txt(300, 100, "N", 18, INK)
	var na := -PI / 2 if flag("compass_ok") else 0.7 + 0.1 * sin(t * 3.0)
	ln(300, 140, 300 + cos(na) * 48, 140 + sin(na) * 48, Color("c83a3a"), 4)
	rr(390, 90, 160, 100, Color("5a3a2a"), 6)
	r(400, 100, 140, 20, PAPER.darkened(0.2))
	if not flag("got_binoculars"):
		item("blbinoculars", 635, 130, 2.0)
	# The rigging with its four ropes, the pigeon, the hamper.
	for k in range(4):
		ln(80 + k * 120, 0, 120 + k * 100, 300, T10_ROPES[k], 4)
	rr(570, 260, 130, 110, Color("c8a868"), 10)
	for k in range(4):
		r(580 + k * 30, 260, 4, 110, Color("8a6a3a"))
	if not flag("got_pigeon"):
		c(635, 300, 16, Color("a8a8b8"))
	rr(730, 270, 170, 100, Color("c8a868"), 8)
	if not flag("got_champagne"):
		item("blchampagne", 815, 260, 1.8)


func _bl3() -> void:
	# Looking down: the map of fields far below (or the grass on the ground).
	if not flag("ropes_free"):
		r(0, 0, 960, 472, T10_GRASS.darkened(0.1))
		for k in range(12):
			c(60 + k * 80.0, 240 + 30 * sin(k), 10, Color("5a8a3a"))
		return
	r(0, 0, 960, 472, T10_GRASS)
	for k in range(6):
		r(k * 160.0, 0, 150, 472, T10_GRASS.darkened(0.05 * (k % 3)))
	ci.draw_polyline(PackedVector2Array([Vector2(0, 80), Vector2(300, 140), Vector2(520, 100), Vector2(960, 200)]), Color("5a9ad0"), 18, true)
	if flag("landed"):
		_t10_balloon(300, 230, 0.7, T10_SILK, true)
		poly([570, 370, 680, 370, 670, 250, 580, 250], Color("5a6a3a"))
		c(625, 225, 24, Color("e0b890"))
		r(595, 196, 60, 12, Color("c8a050"))
		rr(720, 240, 160, 120, PAPER, 6)
		item("blpigeon", 800, 300, 2.4)
	else:
		for k in range(3):
			c(fmod(k * 300.0 - t * 15.0, 1000.0), 100 + k * 100, 40, Color(1, 1, 1, 0.5))


func _bl4() -> void:
	# The sky, looking north: below, smoke drifting right (east); in the
	# middle a kite flying straight away (north); above, clouds sailing left
	# (west). A rival balloon, birds.
	r(0, 0, 960, 472, T10_SKY)
	r(0, 400, 960, 72, T10_GRASS)
	txt(480, 392, "N", 22, Color(INK, 0.6))
	for k in range(4):
		var cx := fmod(800.0 - t * 22.0 + k * 140, 520.0) + 440
		c(cx, 70 + (k % 2) * 20, 30, Color(1, 1, 1, 0.9))
		c(cx + 26, 60 + (k % 2) * 20, 24, Color(1, 1, 1, 0.9))
	var ks := 1.0 - fmod(t * 0.1, 0.5)
	var ky := 200.0 - fmod(t * 8.0, 60.0)
	poly([455, ky - 30 * ks, 475, ky, 455, ky + 30 * ks, 435, ky], Color("c83a3a"))
	ln(455, ky + 30 * ks, 455, 400, Color(INK, 0.5), 1.5)
	r(100, 330, 30, 70, Color("8a4a3a"))
	for k in range(6):
		var p := fmod(t * 0.5 + k / 6.0, 1.0)
		c(115 + p * 180, 320 - p * 30, 10 + p * 14, Color(0.6, 0.6, 0.65, 0.6 * (1.0 - p)))
	_t10_balloon(800, 180 + 6 * sin(t * 0.7), 0.6, [Color("3a7a5a"), Color("f2e6c8")])
	for k in range(3):
		var bx := 180 + k * 40 + 20 * sin(t + k)
		ln(bx - 8, 90 + k * 6, bx, 96 + k * 6, INK, 2)
		ln(bx, 96 + k * 6, bx + 8, 90 + k * 6, INK, 2)


func _blcard() -> void:
	board(T10_WOOD)
	rr(140, 20, 680, 440, PAPER, 6)
	_s8_text(170, 60, 400, "bltext.card", 18, INK)
	var icons := ["cows", "river", "bees", "mill"]
	for k in range(4):
		_t10_icon(icons[k], 660, 90 + k * 90, 1.4)
	ln(600, 70, 600, 430, Color(INK, 0.2), 2)


func _t10_icon(kind: String, x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	match kind:
		"cows":
			rr(-16, -8, 32, 16, Color("f2f2f2"), 6)
			c(-6, -2, 4, INK)
			c(18, -8, 6, Color("f2f2f2"))
			r(-12, 8, 3, 8, INK)
			r(9, 8, 3, 8, INK)
		"river":
			for k in range(3):
				ln(-18, -8 + k * 8, 18, -12 + k * 8, Color("3a7ac0"), 3)
		"bees":
			rr(-14, -12, 28, 24, Color("e8b830"), 10)
			for k in range(3):
				r(-14, -6 + k * 6, 28, 2, Color("5a3a1a"))
		_:
			r(-6, -4, 12, 18, Color("c8b8a0"))
			for k in range(4):
				var a := t * 0.5 + k * PI / 2
				ln(0, -6, cos(a) * 18, -6 + sin(a) * 18, T10_WOOD, 3)
	home()


func _blcase() -> void:
	board(Color("5a3a2a"))
	rr(100, 30, 760, 410, Color("7a5a3a"), 8)
	c(290, 210, 140, PAPER)
	txt(290, 100, "N", 26, INK)
	var na := -PI / 2 if flag("compass_ok") else 0.75
	ln(290, 210, 290 + cos(na) * 110, 210 + sin(na) * 110, Color("c83a3a"), 6)
	# Rolled maps, a pencil, and tucked between them a little magnet.
	for k in range(3):
		rr(500, 80 + k * 70, 300, 46, PAPER.darkened(0.1 + k * 0.05), 22)
	r(520, 300, 200, 6, Color("e8b830"))
	if not flag("compass_ok"):
		at(640, 338, 0.3, 1.0)
		ci.draw_arc(Vector2.ZERO, 14, PI * 0.1, PI * 0.9 + PI, 12, Color("c83a3a"), 7, true)
		r(-17, -4, 6, 10, Color("d8d8d8"))
		r(11, -4, 6, 10, Color("d8d8d8"))
		home()


func _blrigging() -> void:
	r(0, 0, 960, 472, T10_GRASS if not flag("ropes_free") else T10_SKY)
	# The rigging card: the ropes' colours in the order to let go.
	rr(220, 20, 520, 190, PAPER, 6)
	var order: Array = clues.get("ropes", [])
	for k in range(order.size()):
		txt(290 + k * 120, 70, str(k + 1), 22, INK)
		rr(260 + k * 120, 90, 60, 90, T10_ROPES[int(order[k])], 6)
	var done := int(st.get("ropes", [0])[0])
	for k in range(4):
		var x := 190.0 + k * 190
		r(x - 30, 380, 60, 30, T10_WOOD)
		var free := flag("ropes_free") or _t10_rope_off(k, done, order)
		ln(x, 380, x + (60 if free else 0), 250 if not free else 330, T10_ROPES[k], 8)
		c(x, 380, 10, IRON)


func _t10_rope_off(k: int, done: int, order: Array) -> bool:
	for i in range(mini(done, order.size())):
		if int(order[i]) == k:
			return true
	return false


func _blmap() -> void:
	r(0, 0, 960, 472, T10_WOOD.darkened(0.3))
	var w := int(clues.get("w", 8))
	var h := int(clues.get("h", 6))
	var o: Vector2 = Set10Views.MAP_AT
	var cs: float = Set10Views.MAP_CELL
	r(o.x, o.y, w * cs, h * cs, T10_GRASS)
	for i in range(w * h):
		r(o.x + (i % w) * cs + 1, o.y + int(i / w) * cs + 1, cs - 2, cs - 2, T10_GRASS.darkened(0.04 * ((i * 7) % 3)))
	for k in range(w):
		txt(o.x + k * cs + cs / 2, o.y - 8, "ABCDEFGH"[k], 16, CREAM)
	for k in range(h):
		txt(o.x - 16, o.y + k * cs + cs / 2 + 6, str(k + 1), 16, CREAM)
	# The river along the bottom, the church, the start.
	ci.draw_polyline(PackedVector2Array([o + Vector2(0, 5.6 * cs), o + Vector2(3 * cs, 5.2 * cs), o + Vector2(8 * cs, 4.6 * cs)]), Color("5a9ad0"), 8, true)
	var church := int(clues.get("church", 27))
	var cp := o + Vector2((church % w) * cs + cs / 2, int(church / w) * cs + cs / 2)
	r(cp.x - 12, cp.y - 8, 24, 22, Color("e8e0d0"))
	poly([cp.x - 6, cp.y - 8, cp.x + 6, cp.y - 8, cp.x, cp.y - 30], Color("8a3a2a"))
	if not flag("got_mail"):
		rr(cp.x + 8, cp.y - 30, 14, 12, Color("c8a868"), 3)
	var start := int(clues.get("start", 40))
	r(o.x + (start % w) * cs + 8, o.y + int(start / w) * cs + 8, cs - 16, cs - 16, Color("f2e6c8"))
	# The crosses, and what lies by them (seen through the binoculars).
	var fields: Array = clues.get("fields", [])
	var icons := ["cows", "river", "bees", "mill"]
	for k in range(fields.size()):
		var c2 := int(fields[k][0])
		var fp := o + Vector2((c2 % w) * cs + cs / 2, int(c2 / w) * cs + cs / 2)
		ln(fp.x - 14, fp.y - 14, fp.x + 14, fp.y + 14, Color("f2f2f2"), 6)
		ln(fp.x - 14, fp.y + 14, fp.x + 14, fp.y - 14, Color("f2f2f2"), 6)
		if flag("saw_fields"):
			var n := 0
			for j in range(4):
				if int(fields[k][j + 1]) == 1:
					_t10_icon(icons[j], fp.x - 16 + n * 30, fp.y + 24, 0.55)
					n += 1
		if flag("field_marked") and k == 0:
			ring(fp.x, fp.y, 26, Color("c83a3a"), 4)
	# The balloon and its height.
	var fl: Array = st.get("flight", [40, 1, 2])
	var at_cell := int(fl[0])
	var bp := o + Vector2((at_cell % w) * cs + cs / 2, int(at_cell / w) * cs + cs / 2)
	if flag("ropes_free"):
		c(bp.x, bp.y - 6, 16 + int(fl[1]) * 2, T10_SILK[0])
		r(bp.x - 5, bp.y + 10, 10, 8, T10_WOOD_L)
		txt(bp.x, bp.y - 1, str(int(fl[1])), 16, CREAM)
	# The controls.
	for key in ["drift", "sand", "valve", "hook"]:
		var rect: Rect2 = Set10Views.FLY[key]
		rr(rect.position.x, rect.position.y, rect.size.x, rect.size.y, Color(0, 0, 0, 0.45), 10)
		_t10_control(key, rect.get_center())
	txt(780, 250, tr("blmsg.bags") % int(fl[2]) if flag("ropes_free") else "", 18, CREAM)


func _t10_control(key: String, p: Vector2) -> void:
	match key:
		"drift":
			for k in range(3):
				ln(p.x - 30, p.y - 10 + k * 10, p.x + 20, p.y - 10 + k * 10 + 3 * sin(t * 3.0 + k), CREAM, 3)
		"sand":
			rr(p.x - 14, p.y - 12, 28, 26, Color("c8a878"), 8)
			poly([p.x + 30, p.y + 10, p.x + 44, p.y - 10, p.x + 58, p.y + 10], CREAM)
		"valve":
			ring(p.x - 10, p.y, 14, CREAM, 3)
			poly([p.x + 30, p.y - 10, p.x + 58, p.y - 10, p.x + 44, p.y + 10], CREAM)
		_:
			ln(p.x, p.y - 18, p.x, p.y + 14, CREAM, 4)
			ci.draw_arc(p + Vector2(0, 4), 14, 0.2, PI - 0.2, 10, CREAM, 4, true)


func _blnote() -> void:
	board(T10_WOOD)
	rr(160, 40, 640, 400, PAPER, 6)
	_s8_text(190, 80, 560, "bltext.note", 18, INK)
	var note: Array = st.get("note", [0, 0])
	for k in range(2):
		var x: float = [330.0, 500.0][k]
		_s8_arrows(x, 220)
		rr(x - 40, 190, 80, 80, Color("e8dcc0"), 8)
		txt(x, 248, "ABCDEFGH"[int(note[0]) % 8] if k == 0 else str(int(note[1]) % 8 + 1), 40, INK)
	rr(660, 300, 200, 90, Color("3a5a3a"), 10)
	item("blpigeon", 760, 345, 2.4)


# --- The Dragon's Egg ---------------------------------------------------------------

func _t10_snow_night() -> void:
	r(0, 0, 960, 472, T10_NIGHT)
	for k in range(40):
		c(fmod(k * 97.0 + sin(t + k) * 12.0, 960.0), fmod(k * 53.0 + t * 25.0, 472.0), 2, Color(1, 1, 1, 0.7))


func _t10_rune(kind: int, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match T10_RUNES[kind % 6]:
		"sun":
			ring(0, 0, 10, col, 3)
			for k in range(6):
				var a := TAU * k / 6.0
				ln(cos(a) * 14, sin(a) * 14, cos(a) * 20, sin(a) * 20, col, 3)
		"tree":
			ln(0, 18, 0, -18, col, 3)
			ln(0, -6, -12, -16, col, 3)
			ln(0, -6, 12, -16, col, 3)
		"wave":
			ln(-18, 0, -6, -10, col, 3)
			ln(-6, -10, 6, 0, col, 3)
			ln(6, 0, 18, -10, col, 3)
		"eye":
			ring(0, 0, 14, col, 3)
			c(0, 0, 5, col)
		"hill":
			poly([-18, 14, 0, -16, 18, 14], col)
		_:
			for k in range(4):
				var a := TAU * k / 8.0
				ln(-cos(a) * 18, -sin(a) * 18, cos(a) * 18, sin(a) * 18, col, 3)
	home()


func _dg1() -> void:
	_t10_snow_night()
	poly([0, 472, 0, 140, 200, 40, 380, 10, 620, 10, 800, 60, 960, 160, 960, 472], T10_ROCK)
	r(0, 380, 960, 92, T10_SNOW.darkened(0.2))
	# The great door, the lullaby carved above it (four bells, struck in turn).
	var open := flag("door_open")
	r(360, 80, 240, 290, T10_ROCK_D if open else Color("5a5560"))
	if open:
		c(480, 300, 120, Color(1, 0.6, 0.2, 0.12))
	else:
		ln(480, 80, 480, 370, T10_ROCK_D, 4)
		for k in range(4):
			_t10_rune(k, 420 + (k % 2) * 120, 160 + int(k / 2) * 90, 0.9, Color("8a8a9a"))
	r(360, 20, 240, 50, Color("4a4550"))
	var song: Array = clues.get("lullaby", [])
	for k in range(song.size()):
		_t10_bell(395 + k * 42, 46, 0.4 + 0.1 * int(song[k]), Color("c8a868"))
	# The mine cart, the lantern post, the torch rack.
	rr(70, 260, 210, 90, Color("5a4a3a"), 6)
	c(110, 360, 16, IRON)
	c(240, 360, 16, IRON)
	for k in range(4):
		for j in range(int(clues.get("runes", [0, 0, 0, 0])[k])):
			ln(100 + j * 12, 274 + k * 18, 100 + j * 12, 286 + k * 18, Color("c8c0b0"), 2)
	r(725, 80, 10, 200, T10_WOOD)
	rr(708, 70, 44, 50, Color(1, 0.75, 0.3, 0.9), 6)
	r(810, 230, 90, 10, T10_WOOD)
	if not flag("got_torch"):
		for k in range(3):
			item("dgtorch", 830 + k * 24, 290, 1.6)
	r(60, 20, 260, 120, Color(1, 1, 1, 0.0))


func _t10_bell(x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	poly([-20, 24, 20, 24, 14, -10, 0, -22, -14, -10], col)
	c(0, 28, 5, col.darkened(0.3))
	home()


func _t10_dragon(x: float, y: float, s: float, eye_open: bool) -> void:
	var breath := 0.5 + 0.5 * sin(t * TAU / 6.0)
	ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(s * (1.0 + 0.04 * breath), s * (0.55 + 0.03 * breath)))
	c(0, 0, 200, Color("7a2424"))
	c(-40, -30, 150, Color("8a2a2a"))
	at(x, y, 0.0, s)
	for k in range(7):
		poly([-180 + k * 50, -90, -160 + k * 50, -140, -140 + k * 50, -90], Color("5a1a1a"))
	c(200, 20, 70, Color("8a2a2a"))
	poly([240, -20, 300, -60, 270, 10], Color("5a1a1a"))
	if eye_open:
		c(230, 0, 12, Color(1, 0.85, 0.2))
		r(228, -10, 4, 20, INK)
	else:
		ln(218, 0, 242, 4, INK, 3)
	c(268, 40, 4, INK)
	home()


func _dg2() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	if not flag("torch_lit"):
		r(0, 0, 960, 472, Color(0, 0, 0, 0.4))
	# Gold everywhere, the dragon asleep on it.
	for k in range(40):
		c(40 + (k * 53) % 600, 300 + (k * 29) % 70, 12, T10_GOLD.darkened((k % 3) * 0.1))
	_t10_dragon(330, 220, 0.9, false)
	for k in range(3):
		var zy := 120 - fmod(t * 15.0 + k * 20, 60.0)
		txt(560 + k * 16, zy, "z", 16 + k * 4, Color(CREAM, 0.6))
	# The bells hanging from the vault.
	for k in range(4):
		ln(660 + k * 70, 0, 660 + k * 70, 50, IRON, 2)
		_t10_bell(660 + k * 70, 80, 0.8 + 0.12 * k, Color("c8a868"))
	# The thieves' notes, and the red glow from the passage behind.
	for k in range(3):
		at(730 + k * 50, 330, 0.2 * (k - 1))
		r(-20, -26, 40, 52, PAPER)
		home()
	r(660, 200, 100, 80, Color(0.3, 0.08, 0.02))
	c(710, 200, 50, Color(0.3, 0.08, 0.02))
	c(710, 230, 40, Color(1, 0.4, 0.1, 0.3 + 0.1 * sin(t * 2.0)))


func _dghoard() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	for k in range(60):
		c((k * 47) % 960, 380 + (k * 31) % 90, 14, T10_GOLD.darkened((k % 4) * 0.08))
	# The dragon's head above the path; its eye opens when it stops snoring.
	var sn: Array = clues.get("snore", [6, 3])
	var snoring := int(st.get("secs", 0)) % int(sn[0]) >= int(sn[0]) - int(sn[1])
	_t10_dragon(300, 90, 0.55, not snoring)
	if snoring:
		for k in range(3):
			txt(470 + k * 18, 60 - fmod(t * 20.0 + k * 10, 40.0), "z", 18 + k * 4, Color(CREAM, 0.7))
	# The stones to the cage.
	var stones := int(clues.get("stones", 5))
	var at_s := int(st.get("sneak", [0])[0])
	for k in range(stones + 1):
		var x := Set10Views.STONE_X + k * Set10Views.STONE_GAP
		ci.draw_set_transform(Vector2(x, 330), 0.0, Vector2(1.4, 0.5))
		c(0, 0, 30, T10_ROCK.lightened(0.15))
		home()
	var px := Set10Views.STONE_X + at_s * Set10Views.STONE_GAP
	c(px, 290, 14, Color("e0b890"))
	poly([px - 14, 330, px + 14, 330, px + 10, 300, px - 10, 300], Color("4a6a8a"))
	# The cage with the egg, the key ring, the shed scale.
	rr(760, 120, 170, 150, Color(0, 0, 0, 0.3), 8)
	for k in range(6):
		r(770 + k * 28, 120, 5, 150, IRON)
	if not flag("got_egg"):
		item("dgegg", 845, 220, 2.2)
	if not flag("cage_open"):
		for k in range(4):
			rr(740 + (k % 2) * 90, 270 + int(k / 2) * 50, 80, 46, Color(0, 0, 0, 0.4), 6)
			_t10_keyhead(k, 780 + (k % 2) * 90, 293 + int(k / 2) * 50)
	if not flag("got_scale"):
		item("dgscale", 683, 350, 1.0)
	rr(380, 380, 200, 70, Color(0, 0, 0, 0.5), 12)
	txt(480, 425, "· · ·", 30, CREAM)


func _t10_keyhead(kind: int, x: float, y: float) -> void:
	match T10_KEYS[kind]:
		"crown":
			poly([x - 12, y + 8, x + 12, y + 8, x + 12, y - 6, x + 6, y + 2, x, y - 10, x - 6, y + 2, x - 12, y - 6], T10_GOLD)
		"skull":
			c(x, y - 2, 10, Color("e8e0d0"))
			c(x - 4, y - 3, 2.5, INK)
			c(x + 4, y - 3, 2.5, INK)
		"star":
			for k in range(5):
				var a := TAU * k / 5.0 - PI / 2
				ln(x, y, x + cos(a) * 12, y + sin(a) * 12, Color("c8c8d8"), 4)
		_:
			c(x, y, 10, Color("d8d8c0"))
			c(x + 5, y - 3, 9, Color(0, 0, 0, 0.4))
	r(x + 12, y - 2, 24, 4, Color("a8a8a8"))


func _dgnotes() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	for k in range(3):
		at(170 + k * 310, 190, 0.05 * (k - 1))
		r(-130, -150, 260, 300, PAPER)
		home()
		_s8_text(60 + k * 310, 80, 220, "dgtext.note%d" % (k + 1), 17, INK)
	for k in range(4):
		_t10_keyhead(k, 300 + k * 120, 420)


func _dgbells() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	var song := int(st.get("lull", [0])[0])
	for k in range(4):
		var x := 190.0 + k * 190
		ln(x, 0, x, 120, IRON, 3)
		_t10_bell(x, 210, 2.2 + 0.3 * k, Color("c8a868"))
	for k in range(5):
		c(380 + k * 50, 440, 8, T10_GOLD if k < song or flag("lulled") else Color(1, 1, 1, 0.12))


func _dgrunes() -> void:
	r(0, 0, 960, 472, Color("5a5560"))
	var vals: Array = st.get("runes", [0, 0, 0, 0])
	for k in range(4):
		var x := 240.0 + k * 160
		_t10_rune(k, x, 60, 1.2, Color("c8c0b0"))
		_s8_arrows(x, 210)
		rr(x - 40, 190, 80, 80, Color("3a3540"), 8)
		# The wheel shows tally marks.
		for j in range(int(vals[k])):
			ln(x - 28 + j * 12, 208, x - 28 + j * 12, 252, Color("e8e0d0"), 4)


func _dgcart() -> void:
	r(0, 0, 960, 472, T10_NIGHT)
	rr(80, 30, 520, 400, Color("5a4a3a"), 10)
	# Four rows: a rune, then the dwarves' tally marks.
	var runes: Array = clues.get("runes", [])
	for k in range(runes.size()):
		var y := 90.0 + k * 90
		_t10_rune(k, 150, y, 1.1, Color("c8c0b0"))
		for j in range(int(runes[k])):
			ln(230 + j * 30, y - 24, 230 + j * 30, y + 24, Color("e8e0d0"), 4)
		ln(200, y + 40, 560, y + 40, Color(0, 0, 0, 0.2), 2)
	if not flag("got_rope"):
		for k in range(4):
			ring(740, 330, 30 + k * 12, Color("c8a868"), 6)


func _dg3() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	# The lava river behind, its glow, the obsidian floor in front.
	for k in range(6):
		var lx := fmod(k * 170.0 + t * 20.0, 1000.0) - 20
		c(lx, 250, 50, Color(1, 0.4 + 0.1 * sin(t + k), 0.1, 0.8))
	r(0, 230, 960, 50, Color(1, 0.4, 0.1, 0.5))
	r(120, 280, 700, 90, Color("1a1a22"))
	for k in range(7):
		ln(120 + k * 100, 280, 120 + k * 100, 370, Color(1, 1, 1, 0.06), 2)
	# Two mirrors on posts, the crystal above.
	var m: Array = st.get("mirrors", [0, 0])
	for k in range(2):
		var x := 150.0 + k * 140
		r(x - 4, 140, 8, 110, IRON)
		at(x, 130, PI / 4 * int(m[k]))
		r(-30, -6, 60, 12, Color("c8d8e8"))
		home()
	var lit := flag("floor_lit")
	poly([480, 40, 520, 100, 480, 160, 440, 100], Color(0.6, 0.9, 1.0, 0.9) if lit else Color("4a5a6a"))
	if lit:
		c(480, 100, 90, Color(0.6, 0.9, 1.0, 0.15))
	# The crag and the ledge.
	poly([780, 260, 960, 260, 960, 40, 860, 60], T10_ROCK)


func _dgmirrors() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	r(0, 400, 960, 72, Color(1, 0.4, 0.1, 0.6))
	var m: Array = st.get("mirrors", [0, 0])
	var want: Array = clues.get("mirrors", [1, 3])
	for k in range(2):
		var x: float = [330.0, 630.0][k]
		_s8_arrows(x, 230)
		at(x, 250, PI / 4 * int(m[k]))
		r(-50, -8, 100, 16, Color("c8d8e8"))
		home()
	# The glow from the lava, bounced on as far as the mirrors allow.
	ln(150, 420, 330, 250, Color(1, 0.6, 0.2, 0.8), 5)
	if int(m[0]) == int(want[0]):
		ln(330, 250, 630, 250, Color(1, 0.6, 0.2, 0.8), 5)
		if int(m[1]) == int(want[1]):
			ln(630, 250, 480, 70, Color(1, 0.6, 0.2, 0.8), 5)
	poly([480, 20, 510, 70, 480, 120, 450, 70], Color(0.6, 0.9, 1.0) if flag("floor_lit") else Color("4a5a6a"))


func _dgfloor() -> void:
	r(0, 0, 960, 472, T10_ROCK_D)
	var f: Dictionary = clues.get("floor", {})
	var w := int(f.get("w", 7))
	var h := int(f.get("h", 5))
	var blocked: Array = f.get("blocked", [])
	var cracks: Array = clues.get("cracks", [])
	for i in range(w * h):
		var rect := Set10Views.grid_rect(i, w)
		r(rect.position.x + 1, rect.position.y + 1, rect.size.x - 2, rect.size.y - 2, Color("1a1a22"))
		r(rect.position.x + 1, rect.position.y + 1, rect.size.x - 2, rect.size.y - 2, Color(0.6, 0.9, 1.0, 0.06))
		if i in blocked.map(func(b: Variant) -> int: return int(b)):
			c(rect.get_center().x, rect.get_center().y, 30, T10_ROCK.lightened(0.1))
		if flag("floor_lit") and i in cracks.map(func(b: Variant) -> int: return int(b)):
			var cx := rect.get_center()
			ln(cx.x - 26, cx.y - 20, cx.x + 4, cx.y + 2, T10_LAVA, 3)
			ln(cx.x + 4, cx.y + 2, cx.x - 6, cx.y + 26, T10_LAVA, 3)
			ln(cx.x + 4, cx.y + 2, cx.x + 26, cx.y - 6, T10_LAVA, 3)
	var start := Set10Views.grid_rect(int(f.get("start", 14)), w)
	r(start.position.x - 40, start.position.y, 40, start.size.y, T10_ROCK)
	var goal := Set10Views.grid_rect(int(f.get("goal", 20)), w)
	r(goal.end.x, goal.position.y, 40, goal.size.y, T10_ROCK)
	var p := Set10Views.grid_rect(int(st.get("floor", [14])[0]), w).get_center()
	c(p.x, p.y - 10, 12, Color("e0b890"))
	poly([p.x - 12, p.y + 22, p.x + 12, p.y + 22, p.x + 8, p.y, p.x - 8, p.y], Color("4a6a8a"))
	for d in ["n", "w", "e", "s"]:
		var rect: Rect2 = Set10Views.PAD[d]
		arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, {"n": 0, "s": 1, "w": 2, "e": 3}[d])


func _dg4() -> void:
	r(0, 0, 960, 472, T10_NIGHT)
	for k in range(20):
		c(float((k * 151) % 960), float((k * 41) % 160), 1.4, Color(1, 1, 0.9, 0.6))
	poly([250, 160, 400, 60, 520, 120, 640, 40, 750, 160], Color("2a3450"))
	poly([0, 472, 0, 200, 960, 220, 960, 472], T10_ROCK)
	r(60, 60, 140, 300, T10_ROCK_D)
	if flag("rope_up"):
		ln(130, 60, 130, 360, Color("c8a868"), 5)
	# The steam vent: it puffs now and then.
	var v: Array = clues.get("vent", [8, 2])
	var puff := int(st.get("secs", 0)) % int(v[0]) >= int(v[0]) - int(v[1])
	ci.draw_set_transform(Vector2(450, 340), 0.0, Vector2(1.6, 0.5))
	c(0, 0, 40, T10_ROCK_D)
	home()
	if puff:
		for k in range(5):
			c(450 + 10 * sin(t * 3.0 + k), 300 - k * 30, 20 + k * 8, Color(1, 0.8, 0.6, 0.35 - k * 0.05))
	# The nest, waiting.
	ci.draw_set_transform(Vector2(755, 300), 0.0, Vector2(1.6, 0.6))
	c(0, 0, 90, Color("6a5030"))
	c(0, -10, 70, Color("3a2a1a"))
	home()
	if flag("done"):
		item("dghot", 755, 280, 2.4)
		_t10_dragon(700, 140, 0.35, true)
