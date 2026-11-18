## Draws the rooms of the fourth set on top of ArtSet3: The Attic (K1, K2),
## The Watchmaker (W1, W2) and The Night Gallery (M1, M2), with their
## close-ups. Hotspots are in views_set4.gd.
class_name ArtSet4
extends ArtSet3

const ROOF := Color("8a6a48")
const ROOF_D := Color("6e5236")
const SHOP := Color("6a5a4a")
const SHOP_D := Color("564838")
const STONE_M := Color("b8a888")
const STONE_MD := Color("9a8a6c")
const NIGHT_M := Color("1a2038")


func draw_view(view: String) -> void:
	match view:
		"K1": _k1()
		"K2": _k2()
		"album": _album()
		"ktrunk": _ktrunk()
		"ktrain": _ktrain()
		"kward": _kward()
		"W1": _w1()
		"W2": _w2()
		"wclocks": _wclocks()
		"wdrawer": _wdrawer()
		"wwatch": _wwatch()
		"wplan": _wplan()
		"wtall": _wtall()
		"wdoor": _wdoor()
		"M1": _m1()
		"M2": _m2()
		"mtablet": _mtablet()
		"mcase": _mcase()
		"mscales": _mscales()
		"mdial": _mdial()
		"mfrieze": _mfrieze()
		"msarc": _msarc()
		"mdoor": _mdoor()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"mcrank":
			super.item("crank", x, y, s)
			return
		"wagon":
			at(x, y, 0.0, s)
			rr(-16, -10, 32, 18, paint("green"), 3)
			c(-9, 10, 5, IRON_D)
			c(9, 10, 5, IRON_D)
		"mkey":
			super.item("dkey", x, y, s * 1.2)
			return
		"pole":
			at(x, y, 0.7, s)
			ln(0, -20, 0, 18, WOOD_D, 4)
			ci.draw_arc(Vector2(5, -20), 5, PI, TAU, 8, BRASS, 3, true)
		"loupe":
			at(x, y, 0.0, s)
			ring(-3, -4, 11, BRASS, 4)
			c(-3, -4, 9, Color(0.75, 0.9, 0.95, 0.5))
			ln(5, 5, 15, 16, WOOD_D, 5)
		"spring":
			at(x, y, 0.0, s)
			for k in range(3):
				ci.draw_arc(Vector2(0, 0), 4.0 + k * 4.5, k * 1.0, k * 1.0 + 5.0, 14, STEEL, 2.5, true)
		"gearw":
			home()
			gear_wheel(x, y, 13 * s, BRASS)
		"balance":
			at(x, y, 0.0, s)
			ring(0, 0, 13, BRASS, 3)
			ln(-13, 0, 13, 0, BRASS, 3)
			c(0, 0, 4, RED)
		"feather":
			at(x, y, 0.5, s)
			poly([0, -20, 8, -6, 6, 10, 0, 18, -6, 10, -8, -6], CREAM)
			ln(0, -20, 0, 22, INK, 1.5)
		"disc":
			at(x, y, 0.0, s)
			c(0, 0, 14, GOLD)
			ring(0, 0, 9, BRASS_D, 2)
		"scarabkey":
			at(x, y, 0.0, s)
			ci.draw_set_transform(Vector2(x - 6 * s, y), 0.0, Vector2(s, s * 0.8))
			c(0, 0, 10, Color("3f8a7a"))
			at(x, y, 0.0, s)
			ln(-6, -8, -6, 8, INK, 1.5)
			ln(4, 0, 18, 0, BRASS, 4)
			ln(14, 0, 14, 7, BRASS, 4)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"attic":
			r(0, 0, w, h, Color("5a4634"))
			poly([0, h, 0, h * 0.5, w * 0.5, 0, w, h * 0.5, w, h], ROOF)
			for k in range(5):
				ln(w * k / 4.0, h, w * 0.5, 0, ROOF_D, 2)
			var swing := 0.22 * sin(t * 1.4)
			var bulb := Vector2(w * 0.5 + sin(swing) * h * 0.37, h * 0.05 + cos(swing) * h * 0.37)
			ln(w * 0.5, h * 0.05, bulb.x, bulb.y, ROOF_D, 2)
			c(bulb.x, bulb.y, h * 0.3, Color(1, 0.92, 0.66, 0.15))
			c(bulb.x, bulb.y, h * 0.12, Color("ffe9a8"))
			for k in range(8):
				c(fmod(k * 23.0 + t * 4.0, w), h * 0.2 + fmod(k * 17.0 + t * (3.0 + k % 3), h * 0.5), 1.0, Color(1, 1, 0.9, 0.6))
			rr(w * 0.14, h * 0.66, w * 0.3, h * 0.26, Color("7a3a34"), 4)
			rr(w * 0.62, h * 0.7, w * 0.2, h * 0.2, paint("green"), 3)
		"watch":
			r(0, 0, w, h, SHOP_D)
			for k in range(3):
				var cx := w * (0.2 + k * 0.3)
				c(cx, h * 0.42, h * 0.26, BRASS_D)
				c(cx, h * 0.42, h * 0.22, CREAM)
				var a := t * (0.6 + k * 0.4) + k
				ln(cx, h * 0.42, cx + cos(a) * h * 0.17, h * 0.42 + sin(a) * h * 0.17, INK, 2)
				ln(cx, h * 0.68, cx + 8 * sin(t * 3.0 + k), h * 0.9, BRASS, 2)
				c(cx + 8 * sin(t * 3.0 + k), h * 0.9, 4, BRASS)
		"museum":
			r(0, 0, w, h, NIGHT_M)
			var sweep := w * 0.18 * sin(t * 0.8)
			poly([w * 0.42, 0, w * 0.58, 0, w * 0.8 + sweep, h, w * 0.2 + sweep, h], Color(0.7, 0.75, 1, 0.12))
			for k in range(2):
				r(w * (0.08 + k * 0.74), h * 0.1, w * 0.1, h * 0.9, STONE_MD)
			rr(w * 0.3, h * 0.5, w * 0.4, h * 0.34, GOLD.darkened(0.25), 8)
			c(w * 0.38, h * 0.5, h * 0.16, GOLD)
			glyph_of("eye", w * 0.5, h * 0.24, h / 70.0, GOLD)
			var glint := maxf(0.0, sin(t * 1.3)) ** 6
			c(w * 0.5, h * 0.24, h * 0.12 * glint, Color(1, 1, 0.85, 0.8 * glint))
		_:
			super.card(room, w, h)


# === The Attic =======================================================================

func _attic() -> void:
	r(0, 0, 960, 372, ROOF)
	for i in range(13):
		r(i * 80.0, 0, 6, 372, ROOF_D)
	poly([0, 0, 260, 0, 0, 200], ROOF_D.darkened(0.25))
	poly([960, 0, 700, 0, 960, 200], ROOF_D.darkened(0.25))
	r(0, 372, 960, 100, Color("7a5c3e"))
	for i in range(7):
		r(0, 372 + i * 16.0, 960, 2, Color("654a30"))
	for i in range(30):
		c(fmod(i * 97.0 + t * 6.0, 960.0), fmod(i * 61.0 + t * 3.0, 360.0), 1.2, Color(1, 1, 0.9, 0.25))


func _k1() -> void:
	_attic()
	# The dormer window.
	rr(380, 50, 200, 150, ROOF_D, 6)
	r(394, 64, 172, 122, Color("cfe4f0"))
	r(478, 64, 4, 122, ROOF_D)
	poly([394, 186, 566, 186, 700, 372, 260, 372], Color(1, 0.97, 0.8, 0.10))
	# The trunk.
	rr(80, 296, 220, 84, Color("7a3a34"), 6)
	rr(76, 280, 228, 26, Color("5e2a26"), 10)
	rr(176, 292, 28, 26, BRASS, 4)
	if flag("trunk_open"):
		rr(80, 262, 220, 22, Color("14100c"), 4)
	# The music box on a crate.
	crate(350, 300, 130, 80)
	rr(370, 256, 90, 44, Color("3d6a8a"), 5)
	c(415, 250, 10, CREAM)
	poly([409, 250, 421, 250, 415, 228], Color("e8887a"))
	if flag("music_on"):
		ln(460, 278, 478, 278, STEEL, 4)
		ln(478, 278, 478 + 8 * cos(t * 5.0), 264 + 8 * sin(t * 5.0), STEEL, 4)
		rr(380, 296, 70, 10, Color("14100c"), 2)
	# The trapdoor.
	rr(540, 400, 170, 56, Color("5a4028"), 4)
	ring(625, 428, 12, IRON_D, 4)
	if not flag("unlocked"):
		rr(690, 416, 22, 26, BRASS, 4)
	# A rocking horse.
	ci.draw_arc(Vector2(830, 330), 70, 0.3, PI - 0.3, 16, RED, 6, true)
	rr(780, 300, 100, 30, Color("d8b890"), 12)
	poly([870, 310, 900, 262, 916, 270, 892, 320], Color("d8b890"))
	ln(800, 328, 800, 372, Color("d8b890"), 6)
	ln(860, 328, 860, 372, Color("d8b890"), 6)


func _train_small(x: float, y: float, s: float, big: bool) -> void:
	var wagons: Array = clues.get("wagons", [])
	var missing := int(clues.get("missing", -1))
	rr(x, y - 30 * s, 54 * s, 30 * s, IRON_D, 4)
	rr(x + 34 * s, y - 46 * s, 20 * s, 18 * s, RED, 3)
	r(x + 8 * s, y - 42 * s, 9 * s, 14 * s, IRON_D)
	for k in [10.0, 40.0]:
		c(x + k * s, y, 7 * s, RED)
	var colours := ["blue", "yellow", "green", "orange"]
	for i in range(wagons.size()):
		var wx := x + (66 + i * 62) * s
		if i == missing and not flag("wagon_on"):
			ring(wx + 26 * s, y - 14 * s, 12 * s, Color(1, 1, 1, 0.25), 2)
			continue
		rr(wx, y - 26 * s, 52 * s, 26 * s, paint(colours[i % 4]), 4)
		for k in [10.0, 42.0]:
			c(wx + k * s, y, 6 * s, IRON_D)
		if big:
			txt(wx + 26 * s, y - 4 * s, str(int(wagons[i])), int(18 * s), INK)
		ln(wx - 10 * s, y - 8 * s, wx, y - 8 * s, IRON_D, 2)


func _k2() -> void:
	_attic()
	# Shelf with the toy train.
	rr(110, 206, 540, 12, WOOD_D, 3)
	r(110, 200, 540, 4, STEEL)
	_train_small(140, 194, 1.0, false)
	# Chair with the album.
	rr(120, 320, 120, 12, WOOD, 3)
	r(128, 250, 10, 130, WOOD_D)
	r(222, 332, 10, 48, WOOD_D)
	rr(140, 300, 84, 20, Color("3d5a4a"), 3)
	# A dressmaker's dummy.
	poly([430, 230, 500, 230, 512, 330, 418, 330], Color("d8c8a8"))
	c(465, 222, 12, WOOD_D)
	ln(465, 330, 465, 376, WOOD_D, 5)
	# The wardrobe.
	rr(700, 106, 210, 272, WOOD_D, 6)
	if flag("ward_open"):
		r(712, 118, 186, 250, Color("14100c"))
		if not flag("got_pole"):
			ln(790, 130, 790, 350, WOOD, 6)
			ci.draw_arc(Vector2(800, 130), 10, PI, TAU, 8, BRASS, 4, true)
	else:
		r(712, 118, 91, 250, WOOD)
		r(807, 118, 91, 250, WOOD)
		rr(776, 224, 58, 28, BRASS, 4)


func _cake(x: float, y: float, candles: int) -> void:
	rr(x - 70, y, 140, 50, Color("f0d8e0"), 8)
	rr(x - 70, y + 18, 140, 10, Color("e8887a"), 4)
	for k in range(candles):
		var cx := x - 56 + k * (112.0 / maxf(candles - 1, 1))
		r(cx - 3, y - 26, 6, 26, paint(["blue", "yellow", "green"][k % 3]))
		poly([cx, y - 40, cx + 4, y - 28, cx - 4, y - 28], FIRE)


func _album() -> void:
	board(Color("3d5a4a"))
	rr(40, 20, 880, 432, Color("2a4034"), 8)
	var candles: Array = clues.get("candles", [])
	for i in range(candles.size()):
		var x := 190.0 + i * 290.0
		rr(x - 120, 70, 240, 300, PAPER, 4)
		r(x - 104, 86, 208, 230, Color("d9cfb4"))
		c(x, 150, 26, Color("e8c8a8"))
		poly([x - 34, 240, x - 24, 184, x + 24, 184, x + 34, 240], paint(["red", "blue", "violet"][i]))
		_cake(x, 256, int(candles[i]))
		txt(x, 352, "%d." % (i + 1), 24, INK.lightened(0.3))


func _ktrunk() -> void:
	board(Color("5a4634"))
	rr(120, 60, 720, 380, Color("7a3a34"), 16)
	if flag("trunk_open"):
		rr(170, 110, 620, 290, Color("14100c"), 8)
		if not flag("got_trunk"):
			item("mcrank", 380, 250, 3.4)
			item("wagon", 590, 250, 3.6)
	else:
		# A birthday cake marks what opens it.
		rr(400, 76, 160, 60, BRASS, 5)
		rr(450, 100, 60, 24, INK, 4)
		for k in range(3):
			r(462 + k * 16.0, 86, 4, 14, INK)
		kit_wheels(st.get("trunk", [0, 0, 0]), 400, 260)


func _ktrain() -> void:
	board(Color("5a4634"))
	r(40, 330, 880, 8, STEEL)
	for k in range(22):
		r(50 + k * 40.0, 338, 12, 14, WOOD_D)
	_train_small(120, 322, 2.1, true)


func _kward() -> void:
	board(Color("5a4634"))
	rr(160, 20, 640, 440, WOOD_D, 8)
	if flag("ward_open"):
		rr(200, 60, 560, 360, Color("14100c"), 6)
		if not flag("got_pole"):
			item("pole", 480, 240, 6.0)
	else:
		rr(200, 60, 560, 360, WOOD, 6)
		# A little engine marks what opens it.
		rr(430, 74, 100, 50, BRASS, 5)
		rr(450, 92, 40, 20, INK, 3)
		rr(476, 82, 16, 14, INK, 2)
		c(460, 114, 5, INK)
		c(482, 114, 5, INK)
		kit_wheels(st.get("ward", [0, 0, 0, 0]), 360, 250)


# === The Watchmaker ==================================================================

func _shop() -> void:
	r(0, 0, 960, 372, SHOP)
	for i in range(13):
		r(i * 80.0, 0, 2, 372, SHOP_D)
	r(0, 240, 960, 132, SHOP_D)
	r(0, 236, 960, 6, WOOD_D)
	r(0, 372, 960, 100, Color("4a3a2c"))
	for i in range(9):
		ln(i * 120 - 20, 372, i * 150 - 150, 472, Color("3a2c20"), 2)


func _wall_clock(x: float, y: float, rad: float, hm: Array, swings: bool) -> void:
	rr(x - rad * 0.5, y, rad, rad * 2.4, WOOD_D, 6)
	var sway := sin(t * 3.0) * 0.35 if swings else 0.0
	ln(x, y + rad * 0.8, x + sin(sway) * rad * 1.3, y + rad * 0.8 + cos(sway) * rad * 1.3, BRASS, maxf(2, rad * 0.06))
	c(x + sin(sway) * rad * 1.3, y + rad * 0.8 + cos(sway) * rad * 1.3, rad * 0.2, BRASS)
	dial(x, y, rad, hm, CREAM)


func _w1() -> void:
	_shop()
	var clocks: Array = clues.get("clocks", [])
	for i in range(clocks.size()):
		_wall_clock(130.0 + i * 130.0, 90, 36, clocks[i], i == int(clues.get("swinging", -1)))
	# The diagram.
	rr(700, 66, 150, 160, PAPER, 3)
	for k in range(3):
		ring(775, 100.0 + k * 46.0, 14, INK.lightened(0.3), 2)
	# The bench.
	rr(90, 296, 620, 16, WOOD, 3)
	r(106, 312, 16, 66, WOOD_D)
	r(680, 312, 16, 66, WOOD_D)
	c(330, 284, 24, BRASS_D)
	c(330, 284, 19, CREAM if flag("watch_runs") else Color("3a3430"))
	if not flag("got_gear"):
		gear_wheel(450, 284, 12, BRASS)
	_desk_lamp(640, 296)
	rr(520, 314, 150, 62, WOOD_D, 3)
	if flag("drawer_open"):
		rr(528, 322, 134, 30, Color("14100c"), 3)
	else:
		rr(566, 330, 58, 22, BRASS, 3)
	# A stool and the shop cat.
	rr(780, 330, 80, 10, WOOD, 3)
	r(790, 340, 8, 38, WOOD_D)
	r(842, 340, 8, 38, WOOD_D)
	c(820, 316, 16, Color("3a3430"))
	poly([808, 306, 812, 292, 818, 304], Color("3a3430"))
	poly([822, 304, 828, 292, 832, 306], Color("3a3430"))


func _w2() -> void:
	_shop()
	# The tall clock.
	rr(360, 16, 170, 362, WOOD_D, 8)
	var tall: Array = st.get("tall", [0, 0])
	dial(445, 96, 58, [int(tall[0]), int(tall[1]) * 5], CREAM)
	if flag("case_open"):
		rr(390, 180, 110, 180, Color("14100c"), 4)
	else:
		rr(390, 180, 110, 180, Color(0.8, 0.85, 0.9, 0.18), 4)
		var sway := sin(t * 2.0) * 0.2
		ln(445, 184, 445 + sin(sway) * 130, 184 + cos(sway) * 130, BRASS, 4)
		c(445 + sin(sway) * 130, 184 + cos(sway) * 130, 16, BRASS)
	# Tools on the wall, the door and its sign.
	for k in range(4):
		ln(120 + k * 44.0, 90, 120 + k * 44.0, 170, STEEL, 4)
		rr(112 + k * 44.0, 80, 16, 16, WOOD, 3)
	r(720, 60, 180, 316, WOOD_D)
	r(732, 72, 156, 304, WOOD)
	rr(752, 92, 116, 130, Color("1a2038"), 4)
	rr(772, 240, 76, 32, BRASS_D, 4)
	rr(764, 120, 92, 40, PAPER, 3)
	ring(810, 140, 12, INK, 2)


func _wclocks() -> void:
	board(SHOP_D)
	var clocks: Array = clues.get("clocks", [])
	for i in range(clocks.size()):
		_wall_clock(150.0 + i * 220.0, 150, 86, clocks[i], i == int(clues.get("swinging", -1)))
		for h in range(1, 13):
			var a := TAU * h / 12.0 - PI / 2
			txt(150.0 + i * 220.0 + cos(a) * 62, 150 + sin(a) * 62 + 6, str(h), 14, INK)


func _wdrawer() -> void:
	board(SHOP_D)
	rr(160, 40, 640, 400, WOOD_D, 10)
	if flag("drawer_open"):
		rr(210, 90, 540, 300, Color("14100c"), 6)
		if not flag("got_drawer"):
			item("loupe", 390, 240, 3.6)
			item("spring", 590, 240, 3.6)
	else:
		rr(210, 90, 540, 300, WOOD, 6)
		# A pendulum marks what opens it.
		rr(440, 100, 80, 50, BRASS, 5)
		ln(480, 106, 496, 136, INK, 3)
		c(496, 138, 7, INK)
		kit_wheels(st.get("drawer", [0, 0, 0, 0]), 360, 262)


func _wwatch() -> void:
	board(SHOP_D)
	c(400, 240, 204, BRASS_D)
	c(400, 240, 188, Color("2a2622"))
	var built := int(st.get("built", 0))
	# The three places for the parts.
	var places := [[330, 180], [470, 200], [390, 320]]
	var parts: Array = clues.get("parts", [])
	for i in range(mini(parts.size(), 3)):
		ring(places[i][0], places[i][1], 44, Color(1, 1, 1, 0.12), 3)
		if i < built:
			item(parts[i], places[i][0], places[i][1], 3.0)
	# The engraving: too small for the naked eye.
	if flag("seen"):
		var engraved: Array = clues.get("engraved", [12, 0])
		c(480, 330, 40, CREAM)
		dial(480, 330, 34, engraved, CREAM)
		ring(480, 330, 44, BRASS, 5)
	else:
		c(480, 330, 6, Color(1, 1, 1, 0.3))
	# The lid.
	c(760, 240, 150, BRASS_D)
	c(760, 240, 136, BRASS)
	if flag("watch_runs"):
		var lid: Array = clues.get("lid", [])
		var text := ""
		for d in lid:
			text += str(int(d))
		txt(760, 258, text, 54, INK)
		ln(400, 240, 400 + cos(t * 6.0) * 30, 240 + sin(t * 6.0) * 30, RED, 3)


func _wplan() -> void:
	board(SHOP_D)
	rr(200, 20, 560, 432, PAPER, 4)
	var parts: Array = clues.get("parts", [])
	for i in range(parts.size()):
		var y := 100.0 + i * 130.0
		txt(290, y + 16, "%d." % (i + 1), 44, INK)
		item(parts[i], 480, y, 3.4)
		if i < parts.size() - 1:
			poly([480, y + 76, 464, y + 56, 496, y + 56], INK.lightened(0.4))
	c(660, 236, 60, INK.lightened(0.5))
	c(660, 236, 52, PAPER)
	r(654, 166, 12, 16, INK.lightened(0.5))


func _wtall() -> void:
	board(SHOP_D)
	rr(180, 10, 440, 452, WOOD_D, 12)
	var tall: Array = st.get("tall", [0, 0])
	dial(400, 180, 150, [int(tall[0]), int(tall[1]) * 5], CREAM)
	for h in range(1, 13):
		var a := TAU * h / 12.0 - PI / 2
		txt(400 + cos(a) * 112, 180 + sin(a) * 112 + 8, str(h), 22, INK)
	rr(250, 350, 300, 100, Color("14100c") if flag("case_open") else WOOD, 6)
	if flag("case_open") and not flag("got_case"):
		item("balance", 400, 400, 2.6)
	# The hands: short one left, long one right.
	for side in [0, 1]:
		var x: float = 690.0 + side * 130.0
		c(x, 120, 30, CREAM)
		ln(x, 120, x + (10 if side == 0 else 0), 120 - (10 if side == 0 else 24), INK, 5 if side == 0 else 3)
		arrow_btn(x - 50, 180, 100, 64, 0)
		arrow_btn(x - 50, 254, 100, 64, 1)


func _wdoor() -> void:
	board(SHOP_D)
	rr(160, 20, 640, 440, WOOD_D, 8)
	rr(180, 40, 600, 400, WOOD, 6)
	rr(290, 110, 380, 280, BRASS_D, 12)
	# A pocket watch marks what opens it.
	c(480, 82, 22, INK)
	c(480, 82, 17, BRASS)
	r(476, 52, 8, 10, INK)
	kit_wheels(st.get("door", [0, 0, 0]), 400, 240)


# === The Night Gallery ===============================================================

func glyph_of(name: String, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match name:
		"eye":
			ci.draw_arc(Vector2(0, 6), 16, PI + 0.5, TAU - 0.5, 12, col, 3, true)
			ci.draw_arc(Vector2(0, -8), 16, 0.5, PI - 0.5, 12, col, 3, true)
			c(0, -1, 5, col)
			ln(4, 6, 10, 15, col, 3)
		"bird":
			poly([-12, 6, -2, -6, 8, -2, 4, 8, -4, 12], col)
			c(8, -9, 5, col)
			poly([12, -10, 19, -8, 12, -6], col)
			ln(0, 10, 0, 16, col, 2.5)
		"wave":
			for k in [-6.0, 4.0]:
				var zig := PackedVector2Array()
				for i in range(7):
					zig.append(Vector2(-15 + i * 5.0, k + (4 if i % 2 == 0 else -4)))
				ci.draw_polyline(zig, col, 3, true)
		"sun":
			ring(0, 0, 11, col, 3)
			c(0, 0, 4, col)
		"reed":
			ln(0, 16, 0, -8, col, 3)
			poly([0, -16, 6, -4, 0, 0, -6, -4], col)
			ln(0, 6, 8, 0, col, 2.5)
		"scarab":
			ci.draw_set_transform(Vector2(x, y + 2 * s), 0.0, Vector2(s * 0.8, s))
			c(0, 0, 11, col)
			at(x, y, 0.0, s)
			c(0, -12, 5, col)
			for k in [-1.0, 1.0]:
				ln(k * 8, -4, k * 16, -10, col, 2.5)
				ln(k * 9, 4, k * 17, 6, col, 2.5)
	home()


func tally(n: int, x: float, y: float, col: Color, gap: float = 16.0) -> void:
	for k in range(n):
		c(x + (k - (n - 1) / 2.0) * gap, y, gap * 0.3, col)


func _gallery() -> void:
	r(0, 0, 960, 372, NIGHT_M)
	for i in range(5):
		r(40 + i * 220.0, 0, 44, 372, STONE_MD.darkened(0.45))
		r(34 + i * 220.0, 0, 56, 16, STONE_MD.darkened(0.3))
	r(0, 372, 960, 100, Color("2a2a36"))
	for i in range(8):
		for j in range(2):
			r(i * 128.0 + j * 64, 372 + j * 50, 2, 50, Color("1f1f2a"))
	poly([380, 0, 580, 0, 700, 472, 260, 472], Color(0.7, 0.75, 1, 0.07))


func _m1() -> void:
	_gallery()
	# The tablet of signs.
	rr(110, 70, 150, 190, STONE_M, 6)
	var glyphs: Array = clues.get("glyphs", [])
	for i in range(glyphs.size()):
		glyph_of(glyphs[i], 150, 96.0 + i * 28.0, 0.45, INK)
	# The sarcophagus.
	rr(300, 270, 360, 104, GOLD.darkened(0.3), 20)
	rr(310, 256, 340, 40, GOLD.darkened(0.15), 16)
	c(350, 276, 26, GOLD)
	if flag("sarc_open"):
		rr(390, 266, 250, 24, Color("14100c"), 8)
	for k in range(4):
		rr(430.0 + k * 50.0, 310, 36, 36, Color("3a3020"), 4)
	# The scales.
	ln(820, 380, 820, 220, BRASS, 6)
	var lean := float(st.get("lean", 1)) * 0.12
	ci.draw_set_transform(Vector2(820, 222), lean, Vector2.ONE)
	r(-80, -3, 160, 6, BRASS)
	for side in [-1.0, 1.0]:
		ln(side * 74, 0, side * 74, 40, BRASS_D, 2)
		ci.draw_arc(Vector2(side * 74, 40), 26, 0, PI, 10, BRASS, 4, true)
	home()
	# A statue.
	rr(700, 300, 40, 76, STONE_MD, 4)
	c(720, 286, 16, STONE_MD)


func _m2() -> void:
	_gallery()
	# The frieze.
	rr(300, 46, 400, 90, STONE_M, 4)
	for k in range(6):
		r(320 + k * 62.0, 70, 30, 44, STONE_MD)
	# The display case.
	rr(90, 300, 170, 78, WOOD_D, 4)
	rr(96, 200, 158, 104, Color(0.8, 0.85, 1, 0.16), 4)
	if not flag("got_feather"):
		item("feather", 175, 262, 1.6)
	rr(150, 320, 50, 22, BRASS, 3)
	# The moon dial under the skylight.
	poly([430, 380, 446, 320, 514, 320, 530, 380], STONE_MD)
	ci.draw_set_transform(Vector2(480, 312), 0.0, Vector2(1.0, 0.36))
	c(0, 0, 80, STONE_M)
	ring(0, 0, 56, STONE_MD, 8)
	home()
	if flag("disc_on"):
		c(480, 306, 12, GOLD)
	# The door of the wing.
	r(770, 70, 150, 306, STONE_MD.darkened(0.3))
	r(782, 82, 126, 294, STONE_MD.darkened(0.15))
	for k in range(6):
		c(812.0 + (k % 2) * 66.0, 150.0 + floorf(k / 2.0) * 60.0, 16, GOLD.darkened(0.3))
	# Rope barrier and a vase.
	ln(280, 340, 400, 352, RED, 4)
	r(276, 320, 6, 56, BRASS)
	poly([620, 376, 632, 320, 624, 300, 656, 300, 648, 320, 660, 376], Color("7a5a8a"))


func _mtablet() -> void:
	board(Color("2a2a36"))
	rr(200, 14, 560, 444, STONE_M, 10)
	var glyphs: Array = clues.get("glyphs", [])
	var values: Array = clues.get("values", [])
	for i in range(glyphs.size()):
		var y := 62.0 + i * 70.0
		glyph_of(glyphs[i], 300, y, 1.5, INK)
		ln(360, y, 420, y, STONE_MD, 3)
		tally(int(values[i]), 580, y, INK, 30.0)
		ln(220, y + 35, 740, y + 35, STONE_MD, 2)


func _mcase() -> void:
	board(Color("2a2a36"))
	rr(160, 30, 640, 420, WOOD_D, 10)
	if flag("case_open"):
		rr(220, 80, 520, 330, Color("14100c"), 6)
		if not flag("got_feather"):
			item("feather", 480, 240, 5.0)
	else:
		rr(330, 54, 300, 84, BRASS, 5)
		var label: Array = clues.get("label", [])
		for i in range(label.size()):
			glyph_of(label[i], 390.0 + i * 90.0, 96, 1.3, INK)
		kit_wheels(st.get("case", [0, 0, 0]), 400, 270)


func _mscales() -> void:
	board(Color("2a2a36"))
	var lean := float(st.get("lean", 1))
	var jars: Array = st.get("jars", [0, 0, 0, 0])
	var names: Array = clues.get("jars", [])
	poly([480, 120, 452, 380, 508, 380], BRASS_D)
	ci.draw_set_transform(Vector2(480, 120), lean * 0.1, Vector2.ONE)
	rr(-320, -8, 640, 16, BRASS, 6)
	for side in [-1.0, 1.0]:
		ln(side * 300, 0, side * 300, 110, BRASS_D, 3)
		ci.draw_arc(Vector2(side * 300, 110), 100, 0, PI, 16, BRASS, 6, true)
	home()
	var drop := lean * 30.0
	# Left: the feather with its tag. Right: the jars that are on the pan.
	if flag("feather_on"):
		item("feather", 180, 290 - drop, 3.4)
		rr(120, 330 - drop, 120, 30, PAPER, 4)
		tally(int(clues.get("feather", 0)), 180, 345 - drop, INK, 14.0)
	for i in range(names.size()):
		var on: bool = int(jars[i]) == 1
		var jx := (690.0 + i * 60.0) if on else (360.0 + i * 100.0)
		var jy := (310.0 + drop) if on else 440.0
		poly([jx - 20, jy, jx - 24, jy - 50, jx - 12, jy - 70, jx + 12, jy - 70, jx + 24, jy - 50, jx + 20, jy], Color("c8a878"))
		rr(jx - 14, jy - 84, 28, 16, Color("a88858"), 5)
		glyph_of(names[i], jx, jy - 30, 0.7, INK)
	rr(60, 384, 220, 70, WOOD_D, 6)
	if flag("balanced"):
		rr(70, 392, 200, 54, Color("14100c"), 4)
		if not flag("got_disc"):
			item("disc", 170, 420, 2.0)
	else:
		c(170, 420, 7, BRASS)
	c(480, 250, 9, Color("69d06a") if flag("balanced") else Color("3a2c22"))


func _mdial() -> void:
	board(Color("2a2a36"))
	poly([420, 0, 540, 0, 600, 472, 360, 472], Color(0.7, 0.75, 1, 0.10))
	c(480, 250, 210, STONE_MD)
	c(480, 250, 196, STONE_M)
	var glyphs: Array = clues.get("glyphs", [])
	var turned := float(st.get("ring", [0])[0])
	for j in range(glyphs.size()):
		var a := TAU * (j - turned) / 6.0 - PI / 2
		glyph_of(glyphs[j], 480 + cos(a) * 150, 250 + sin(a) * 150, 1.4, INK)
	c(480, 250, 84, STONE_MD)
	if flag("disc_on"):
		c(480, 250, 40, GOLD)
		ring(480, 250, 26, BRASS_D, 3)
		poly([480, 250, 462, 96, 498, 96], Color(1, 0.95, 0.7, 0.45))
		arrow_btn(120, 210, 96, 76, 2)
		arrow_btn(744, 210, 96, 76, 3)
	else:
		c(480, 250, 40, Color("14100c"))
	rr(760, 340, 150, 110, STONE_MD.darkened(0.2), 8)
	if flag("niche_open"):
		rr(772, 352, 126, 86, Color("14100c"), 6)
		if not flag("got_skey"):
			item("scarabkey", 835, 396, 2.4)


func _mfrieze() -> void:
	board(Color("2a2a36"))
	rr(40, 20, 880, 432, STONE_M, 6)
	r(40, 226, 880, 6, STONE_MD)
	# Above: the signs in a row; the sun disc rests over one of them.
	var glyphs: Array = clues.get("glyphs", [])
	var order := [4, 0, 5, 1, 2, 3]
	for n in range(order.size()):
		var g: String = glyphs[order[n]] if order[n] < glyphs.size() else ""
		var x := 130.0 + n * 140.0
		glyph_of(g, x, 160, 1.5, INK)
		if g == clues.get("sun_over", ""):
			c(x, 78, 26, GOLD)
			for k in range(8):
				ln(x + cos(k * 0.785) * 32, 78 + sin(k * 0.785) * 32, x + cos(k * 0.785) * 42, 78 + sin(k * 0.785) * 42, GOLD.darkened(0.2), 3)
	# Below: the procession, walking to the right.
	var procession: Array = clues.get("procession", [])
	for i in range(procession.size()):
		var x2 := 170.0 + i * 200.0
		c(x2, 290, 16, INK)
		poly([x2 + 12, 288, x2 + 24, 292, x2 + 12, 296], INK)
		poly([x2 - 16, 400, x2 - 10, 310, x2 + 12, 310, x2 + 18, 400], INK)
		ln(x2 + 6, 400, x2 + 26, 430, INK, 8)
		ln(x2 - 4, 400, x2 - 14, 430, INK, 8)
		ln(x2 + 12, 330, x2 + 50, 320, INK, 6)
		ln(x2 + 50, 400, x2 + 50, 262, INK, 4)
		rr(x2 + 28, 240, 46, 46, STONE_MD, 4)
		glyph_of(procession[i], x2 + 51, 263, 0.9, INK)


func _msarc() -> void:
	board(Color("2a2a36"))
	rr(100, 40, 760, 400, GOLD.darkened(0.3), 40)
	if flag("sarc_open"):
		rr(170, 100, 620, 280, Color("14100c"), 20)
		# The papyrus: four numbers.
		rr(230, 150, 500, 180, PAPER, 4)
		var papyrus: Array = clues.get("papyrus", [])
		for i in range(papyrus.size()):
			var x := 300.0 + i * 120.0
			rr(x - 44, 180, 88, 120, Color(0, 0, 0, 0.06), 4)
			for k in range(int(papyrus[i])):
				c(x - 20 + (k % 2) * 40.0, 200.0 + floorf(k / 2.0) * 30.0, 9, INK)
	else:
		# A row of walkers marks what opens it.
		rr(350, 60, 260, 56, GOLD.darkened(0.1), 5)
		for k in range(4):
			c(390.0 + k * 60.0, 78, 7, INK)
			ln(390.0 + k * 60.0, 84, 390.0 + k * 60.0, 106, INK, 5)
		poly([596, 88, 580, 78, 580, 98], INK)
		var value: Array = st.get("sarc", [0, 0, 0, 0])
		var glyphs: Array = clues.get("glyphs", [])
		for i in range(value.size()):
			var cx := 360.0 + i * 80.0
			arrow_btn(cx - 30, 150, 60, 46, 0)
			rr(cx - 32, 202, 64, 84, STONE_M, 6)
			if not glyphs.is_empty():
				glyph_of(glyphs[int(value[i]) % glyphs.size()], cx, 244, 1.4, INK)
			arrow_btn(cx - 30, 292, 60, 46, 1)


func _mdoor() -> void:
	board(Color("2a2a36"))
	rr(160, 14, 640, 448, STONE_MD.darkened(0.3), 8)
	var glyphs: Array = clues.get("glyphs", [])
	var pressed: Array = st.get("pressed", [0, 0, 0, 0])
	for i in range(glyphs.size()):
		var x := 320.0 + (i % 3) * 160.0
		var y := 130.0 + floorf(i / 3.0) * 150.0
		var lit: bool = (i + 1.0) in pressed
		c(x, y, 58, GOLD if lit else GOLD.darkened(0.4))
		c(x, y, 50, STONE_M)
		glyph_of(glyphs[i], x, y, 1.7, INK)
	for k in range(4):
		c(420.0 + k * 40.0, 380, 7, AMBER if int(pressed[k]) != 0 or st.get("done", false) else Color("14100c"))
	c(480, 426, 16, BRASS_D)
	c(480, 426, 7, Color("3f8a7a") if flag("key_in") else Color("14100c"))
