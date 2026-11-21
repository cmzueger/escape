## Draws the series Puffin Island on top of ArtSet9: one island in four
## seasons (Spring PS…, Summer PU…, Autumn PA…, Winter PW…), with close-ups.
## Hotspots are in views_island.gd.
class_name ArtIsland
extends ArtSet9

const IS_SKY := {"spring": Color("bfe3f0"), "summer": Color("7f93a6"), "autumn": Color("f2cf98"), "winter": Color("17233f")}
const IS_SEA := {"spring": Color("3f8fb0"), "summer": Color("355f78"), "autumn": Color("3f7f98"), "winter": Color("22405e")}
const IS_LAND := {"spring": Color("7fbf5a"), "summer": Color("5f9a48"), "autumn": Color("b98a3c"), "winter": Color("e9f0f6")}
const IS_ROCK := Color("6f6a66")
const IS_WOOD := Color("8a6440")
const IS_WOOD_D := Color("5f4128")
const IS_WALL := Color("efe6d2")
const IS_ROOF := Color("4f6e7e")
const IS_PUFFIN_BEAK := Color("f07a2a")
const IS_SEEDS := [Color("f0902a"), Color("5aa040"), Color("3f7a3a"), Color("d8c8a0")]
const IS_FLAGS := [Color("2a4a8a"), Color("e8c830"), Color("c83a3a"), Color("f2f2f2"), Color("2a8a5a"), Color("1a1a1a")]
const IS_MARKS := ["circle", "triangle", "square", "star"]


func draw_view(view: String) -> void:
	match view:
		"PS1": _ps1()
		"PS2": _ps2()
		"PS3": _ps3()
		"PS4": _ps4()
		"psboat": _psboat()
		"psmaggie":
			if flag("pip_home"):
				_isl_talk("maggie", "spring")
			else:
				_isl_person("maggie", "spring")
		"pschart": _pschart()
		"psalmanac": _isl_almanac("pstext.almanac", "spring")
		"psledge": _psledge()
		"psflags": _psflags()
		"pspatch": _pspatch()
		"psgates": _psgates()
		"PU1": _pu1()
		"PU2": _pu2()
		"PU3": _pu3()
		"PU4": _pu4()
		"pulamp": _pulamp()
		"pubarn": _pubarn()
		"pukite": _pukite()
		"putom":
			if flag("tom_safe"):
				_isl_talk("tom", "summer")
			else:
				_isl_person("tom", "summer")
		"pualmanac": _isl_almanac("putext.almanac", "summer")
		"PA1": _pa1()
		"PA2": _pa2()
		"PA3": _pa3()
		"PA4": _pa4()
		"papress": _papress()
		"patrader":
			if flag("got_cider") and (not flag("traded") or int(st.get("talk", [0])[0]) != 0):
				_isl_talk("trader", "autumn")
			else:
				_isl_person("trader", "autumn")
		"parace": _parace()
		"paalmanac": _isl_almanac("patext.almanac", "autumn")
		"PW1": _pw1()
		"PW2": _pw2()
		"PW3": _pw3()
		"PW4": _pw4()
		"pwlake": _pwlake()
		"pwmaggie":
			if flag("dug_out"):
				_isl_talk("maggie", "winter")
			else:
				_isl_person("maggie", "winter")
		"pwalmanac": _pwalmanac()
		"pwlens": _pwlens()
		"pwchart": _pwchart()
		"pwicicles": _pwicicles()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"pskey", "pukey", "pakey":
			super.item("key", x, y, s)
			return
		"psoars":
			at(x, y, -0.7, s)
			r(-2, -16, 4, 26, IS_WOOD)
			rr(-5, 8, 10, 12, IS_WOOD_D, 3)
		"pstools":
			at(x, y, 0.0, s)
			rr(-14, -6, 28, 16, Color("b0402a"), 3)
			ci.draw_arc(Vector2(0, -6), 7, PI, TAU, 8, IS_ROCK, 3, true)
		"psspade", "pwshovel":
			at(x, y, -0.5, s)
			r(-2, -18, 4, 24, IS_WOOD)
			poly([-8, 6, 8, 6, 6, 18, -6, 18], STEEL)
		"psplanks":
			at(x, y, 0.0, s)
			for k in range(3):
				r(-16, -10 + k * 7, 32, 5, IS_WOOD if k % 2 == 0 else IS_WOOD_D)
		"pspip":
			_isl_puffin(x, y, 0.9 * s, true)
			return
		"psworms":
			at(x, y, 0.0, s)
			for k in range(3):
				ci.draw_arc(Vector2(-6 + k * 6, 0), 5, 0, PI, 6, Color("c86a6a"), 2, true)
		"psline", "putwine":
			at(x, y, 0.0, s)
			ring(0, 0, 9, Color("d8c8a0"), 4)
			c(0, 0, 3, IS_WOOD_D)
		"psrod":
			at(x, y, -0.6, s)
			ln(0, 14, 0, -16, IS_WOOD, 3)
			ln(0, -16, 8, 10, Color("d8c8a0"), 1)
			c(8, 10, 3, Color("c86a6a"))
		"psfish":
			super.item("avfish", x, y, s)
			return
		"psseeds":
			at(x, y, 0.0, s)
			for k in range(3):
				rr(-14 + k * 9, -10, 10, 18, IS_SEEDS[k], 2)
		"pscan":
			super.item("avcan", x, y, s)
			return
		"pswater":
			super.item("avwater", x, y, s)
			return
		"pswhistle":
			at(x, y, -0.3, s)
			rr(-14, -4, 28, 8, Color("efe6d2"), 4)
			c(-6, 0, 1.6, INK)
		"puoil", "pwoil", "pwcan":
			at(x, y, 0.0, s)
			rr(-9, -8, 18, 20, Color("c83a2a") if name != "pwcan" else STEEL, 3)
			ln(6, -6, 14, -14, STEEL, 2)
		"puscrew":
			at(x, y, 0.6, s)
			r(-2, -8, 4, 16, BRASS)
			r(-6, -10, 12, 4, BRASS)
		"pumatches", "pwwet", "pwdry":
			super.item("matches", x, y, s)
			if name == "pwwet":
				at(x, y, 0.0, s)
				c(10, -10, 4, Color(0.5, 0.7, 0.9, 0.9))
				home()
			return
		"pukite", "pumended", "puflyer":
			at(x, y, 0.0, s)
			poly([0, -16, 12, 0, 0, 16, -12, 0], Color("d84a3a"))
			if name == "pukite":
				ln(-6, -6, 6, 6, Color("2a1a10"), 2)
			if name == "puflyer":
				ln(0, 16, 10, 20, Color("d8c8a0"), 1)
				ring(12, 20, 4, Color("d8c8a0"), 2)
		"pusewing":
			at(x, y, 0.0, s)
			rr(-12, -8, 24, 16, Color("8a5a9a"), 4)
			ln(-4, -12, 8, 6, STEEL, 1)
		"panet":
			super.item("avnet", x, y, s)
			return
		"pabasket", "paveg":
			at(x, y, 0.0, s)
			poly([-14, -2, 14, -2, 10, 12, -10, 12], IS_WOOD)
			ci.draw_arc(Vector2(0, -2), 12, PI, TAU, 10, IS_WOOD_D, 2, true)
			if name == "paveg":
				c(-5, -5, 5, Color("f0902a"))
				c(4, -6, 6, Color("3f7a3a"))
		"paapples":
			super.item("avapple", x, y, s)
			return
		"pabottles", "pacider":
			at(x, y, 0.0, s)
			for k in range(2):
				rr(-10 + k * 10, -12, 8, 24, Color(0.4, 0.6, 0.4, 0.8) if name == "pabottles" else Color("d8a040"), 3)
		"paflour":
			super.item("avsugar", x, y, s)
			return
		"paeggs":
			at(x, y, 0.0, s)
			for k in range(3):
				ci.draw_set_transform(Vector2(x - 8 * s + k * 8 * s, y), 0.0, Vector2(0.8 * s, 1.0 * s))
				c(0, 0, 6, Color("f3e8d6"))
		"padough", "papie", "pabaked":
			at(x, y, 0.0, s)
			var col := Color("e8d6b0") if name == "padough" else (Color("e8c890") if name == "papie" else Color("c88a3a"))
			ci.draw_arc(Vector2(0, 4), 14, PI, TAU, 12, col, 10, true)
			r(-15, 3, 30, 6, Color("b0a090"))
		"pwskates":
			at(x, y, 0.0, s)
			rr(-12, -10, 12, 16, Color("6a3a2a"), 3)
			r(-14, 6, 18, 2, STEEL)
			rr(2, -10, 12, 16, Color("6a3a2a"), 3)
			r(0, 6, 18, 2, STEEL)
		"pwlantern", "pwlit":
			at(x, y, 0.0, s)
			rr(-8, -10, 16, 22, Color(1, 0.85, 0.4, 0.9) if name == "pwlit" else Color(0.8, 0.85, 0.9, 0.5), 3)
			ring(0, -12, 4, IRON, 2)
		"pwcrank":
			super.item("crank", x, y, s)
			return
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"spring":
			r(0, 0, w, h, IS_SKY["spring"])
			r(0, h * 0.62, w, h * 0.38, IS_SEA["spring"])
			poly([0, h * 0.7, w * 0.3, h * 0.45, w * 0.6, h * 0.62, w * 0.6, h, 0, h], IS_LAND["spring"])
			for k in range(3):
				var bx := fmod(t * (30.0 + k * 8) + k * 50.0, w + 30.0) - 15.0
				_isl_puffin(bx, h * (0.2 + 0.1 * k) + 4 * sin(t * 4.0 + k), 0.35, false)
		"summer":
			r(0, 0, w, h, IS_SKY["summer"])
			for k in range(6):
				var wy := h * (0.6 + k * 0.05)
				var pts := []
				for j in range(9):
					pts.append_array([j * w / 8.0, wy + 4.0 * sin(t * 3.0 + j + k)])
				pts.append_array([w, h, 0, h])
				poly(pts, IS_SEA["summer"].darkened(k * 0.06))
			poly([w * 0.7, h * 0.65, w * 0.74, h * 0.15, w * 0.8, h * 0.15, w * 0.84, h * 0.65], IS_WALL)
			var a := t * 1.2
			poly([w * 0.77, h * 0.18, w * 0.77 + cos(a) * w * 0.6, h * 0.18 + sin(a) * h * 0.2 - 8, w * 0.77 + cos(a) * w * 0.6, h * 0.18 + sin(a) * h * 0.2 + 8], Color(1, 1, 0.7, 0.4))
			if fmod(t, 5.0) < 0.15:
				r(0, 0, w, h, Color(1, 1, 1, 0.4))
		"autumn":
			r(0, 0, w, h, IS_SKY["autumn"])
			r(0, h * 0.75, w, h * 0.25, IS_LAND["autumn"])
			r(w * 0.3, h * 0.35, 8, h * 0.4, IS_WOOD_D)
			c(w * 0.32, h * 0.32, h * 0.25, Color("c8642a"))
			c(w * 0.24, h * 0.38, h * 0.16, Color("d88a2a"))
			for k in range(6):
				var lx := fmod(k * 37.0 + t * 15.0, w)
				var ly := fmod(k * 23.0 + t * 25.0, h)
				poly([lx, ly, lx + 5, ly + 2, lx + 1, ly + 6], Color("d8602a"))
		"winter":
			r(0, 0, w, h, IS_SKY["winter"])
			for k in range(3):
				var pts := []
				for j in range(10):
					pts.append_array([j * w / 9.0, h * (0.2 + 0.08 * k) + 8.0 * sin(t * 1.5 + j * 0.7 + k)])
				for j in range(9, -1, -1):
					pts.append_array([j * w / 9.0, h * (0.32 + 0.08 * k) + 8.0 * sin(t * 1.5 + j * 0.7 + k)])
				poly(pts, Color(0.3, 0.9, 0.6, 0.25) if k != 1 else Color(0.6, 0.4, 0.9, 0.2))
			r(0, h * 0.72, w, h * 0.28, IS_LAND["winter"])
			r(w * 0.7, h * 0.4, w * 0.08, h * 0.35, IS_WALL)
			c(w * 0.74, h * 0.4, 4, Color(1, 0.9, 0.5, 0.6 + 0.4 * sin(t * 2.0)))
		_:
			super.card(room, w, h)


# --- Shared --------------------------------------------------------------------

func _isl_scene(season: String, horizon: float = 220.0) -> void:
	r(0, 0, 960, horizon, IS_SKY[season])
	r(0, horizon, 960, 372 - horizon, IS_SEA[season])
	for k in range(8):
		var wx := fmod(k * 131.0 + t * 12.0, 1000.0) - 20.0
		ln(wx, horizon + 20 + k * 14, wx + 40, horizon + 20 + k * 14, Color(1, 1, 1, 0.3), 2)
	r(0, 372, 960, 100, IS_LAND[season].darkened(0.15))
	if season == "summer" and not flag("done"):
		for k in range(14):
			c(k * 75.0 + 20 * sin(t * 0.3 + k), 30 + 20 * (k % 3), 55, Color(0.33, 0.37, 0.42, 0.85))
		if fmod(t, 7.0) < 0.12:
			r(0, 0, 960, 372, Color(1, 1, 1, 0.3))
	if season == "winter":
		for k in range(30):
			c(fmod(k * 97.0 + sin(t + k) * 10.0, 960.0), fmod(k * 53.0 + t * 20.0, 472.0), 2, Color(1, 1, 1, 0.7))


func _isl_puffin(x: float, y: float, s: float, chick: bool) -> void:
	at(x, y, 0.0, s)
	ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(s, s * 1.2))
	c(0, 0, 18, Color("1a1a1a") if not chick else Color("5a5650"))
	c(0, 4, 12, Color("f2f2f2") if not chick else Color("8a847c"))
	at(x, y, 0.0, s)
	c(0, -20, 12, Color("1a1a1a") if not chick else Color("5a5650"))
	c(4, -20, 7, Color("f2f2f2"))
	c(6, -21, 2, INK)
	if not chick:
		poly([10, -24, 22, -18, 10, -12], IS_PUFFIN_BEAK)
		r(-6, 18, 4, 6, IS_PUFFIN_BEAK)
		r(2, 18, 4, 6, IS_PUFFIN_BEAK)
	else:
		poly([10, -21, 16, -19, 10, -17], Color("3a3a3a"))
	home()


func _isl_cottage(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	r(-60, -50, 120, 70, IS_WALL)
	poly([-70, -50, 0, -100, 70, -50], IS_ROOF)
	r(-15, -20, 30, 40, IS_WOOD_D)
	r(30, -35, 20, 20, Color("a8d0e8"))
	home()


func _isl_lighthouse(x: float, y: float, s: float, lit: bool) -> void:
	at(x, y, 0.0, s)
	poly([-30, 0, 30, 0, 20, -220, -20, -220], IS_WALL)
	for k in range(3):
		poly([-28 + k * 3, -40 - k * 60, 28 - k * 3, -40 - k * 60, 27 - k * 3, -60 - k * 60, -27 + k * 3, -60 - k * 60], Color("c83a3a"))
	r(-24, -260, 48, 40, Color(1, 0.9, 0.5, 0.9) if lit else Color("3a4450"))
	poly([-30, -260, 0, -290, 30, -260], Color("2a2a2a"))
	home()


## A person to talk to, before the conversation can start.
func _isl_person(who: String, season: String) -> void:
	r(0, 0, 960, 472, IS_SKY[season] if season != "winter" else Color("3a3040"))
	match who:
		"maggie":
			r(200, 300, 560, 172, Color("d8c8b0"))
			c(480, 230, 70, Color("e8c8a8"))
			ci.draw_arc(Vector2(480, 215), 72, PI * 1.05, TAU * 0.98, 18, Color("d8d8d8"), 26, true)
			c(455, 225, 6, INK)
			c(505, 225, 6, INK)
			ci.draw_arc(Vector2(480, 255), 20, 0.3, PI - 0.3, 8, Color("8a4a3a"), 3, true)
			rr(380, 300, 200, 120, Color("6a8aa8"), 20)
		"tom":
			r(0, 300, 960, 172, IS_SEA["summer"])
			poly([560, 60, 760, 60, 800, 330, 520, 330], IS_ROCK)
			poly([420, 300, 600, 300, 580, 330, 440, 330], Color("e8c830"))
			c(510, 250, 26, Color("e8c8a8"))
			poly([480, 280, 540, 280, 530, 300, 490, 300], Color("f0d020"))
		_:
			poly([200, 120, 760, 120, 720, 60, 240, 60], Color("c83a3a"))
			r(220, 120, 520, 260, Color("f2e6d0"))
			c(480, 230, 60, Color("e8c8a8"))
			r(410, 160, 140, 20, Color("3a3a3a"))
			r(300, 330, 360, 60, IS_WOOD)


## A conversation: the person, then the line and its choices.
func _isl_talk(who: String, season: String) -> void:
	var at_line := int(st.get("talk", [0])[0])
	if at_line == 0:
		_isl_person(who, season)
		return
	r(0, 0, 960, 472, IS_SKY[season] if season != "winter" else Color("3a3040"))
	var lines: Array = clues.get("lines", [])
	if at_line - 1 >= lines.size():
		return
	var line: Dictionary = lines[at_line - 1]
	rr(60, 16, 840, 192, Color(CREAM, 0.95), 10)
	ci.draw_multiline_string(font, Vector2(84, 58), tr(line["text"]), HORIZONTAL_ALIGNMENT_LEFT, 790, 22, -1, INK)
	var choices: Array = line["choices"]
	for i in range(choices.size()):
		rr(60, 222 + i * 64.0, 840, 56, Color(0, 0, 0, 0.6), 8)
		ci.draw_string(font, Vector2(84, 258 + i * 64.0), tr(choices[i]), HORIZONTAL_ALIGNMENT_LEFT, 790, 20, CREAM)


## Maggie's almanac: the season's page of verse and pictures.
func _isl_almanac(key: String, season: String) -> void:
	board(IS_WOOD_D)
	rr(120, 20, 720, 440, Color("f4ead2"), 6)
	ln(480, 24, 480, 456, Color(INK, 0.3), 2)
	_s8_text(150, 64, 300, key, 19, INK)
	match season:
		"spring":
			# The puffin call: long and short.
			var call: Array = clues.get("call", [])
			_isl_puffin(560, 120, 1.2, false)
			for k in range(call.size()):
				r(520 + k * 70, 220, 56 if int(call[k]) == 1 else 20, 18, INK)
		"summer":
			_isl_kite_sky(500, 60, 320, 360, 3, true)
		"autumn":
			c(580, 150, 50, Color("c8642a"))
			r(575, 190, 10, 60, IS_WOOD_D)
			for k in range(3):
				c(540 + k * 40, 280, 10, Color("c83a2a"))
			rr(680, 280, 110, 70, Color("c88a3a"), 30)
			for k in range(4):
				ring(560 + k * 60, 400, 14, INK, 3)


# --- Spring ----------------------------------------------------------------------

func _ps1() -> void:
	_isl_scene("spring")
	# The boathouse.
	r(64, 130, 190, 200, IS_WOOD)
	poly([54, 130, 159, 70, 264, 130], IS_ROOF)
	r(110, 210, 100, 120, IS_WOOD_D if not flag("boathouse_open") else Color("2a1a10"))
	# The jetty and its gap.
	r(250, 280, 660, 22, IS_WOOD)
	for k in range(12):
		r(260 + k * 55, 300, 8, 72, IS_WOOD_D)
	if not flag("planks_laid"):
		r(425, 278, 80, 26, IS_SEA["spring"])
	elif not flag("jetty_fixed"):
		for k in range(3):
			r(428 + k * 26, 276, 22, 8, IS_WOOD.lightened(0.2))
	# The boat (oars in once fitted), the bell.
	poly([570, 340, 780, 340, 760, 370, 590, 370], Color("c84a3a"))
	if flag("oars_in"):
		ln(620, 345, 590, 320, IS_WOOD, 4)
		ln(730, 345, 760, 320, IS_WOOD, 4)
	r(866, 140, 8, 140, IS_WOOD_D)
	poly([846, 190, 894, 190, 886, 150, 854, 150], BRASS)
	if flag("done"):
		poly([300, 230, 520, 230, 500, 260, 320, 260], Color("2a4a6a"))
	if fmod(t, 4.0) < 2.0:
		c(780, 290, 2, Color(1, 1, 1, 0.6))


func _ps2() -> void:
	r(0, 0, 960, 372, IS_WALL)
	r(0, 372, 960, 100, IS_WOOD)
	# Maggie in bed, her boots, coat, the stove and Pip's box.
	rr(64, 250, 200, 120, Color("6a8aa8"), 10)
	c(110, 240, 30, Color("e8c8a8"))
	ci.draw_arc(Vector2(110, 232), 30, PI, TAU, 12, Color("d8d8d8"), 12, true)
	poly([290, 370, 320, 370, 322, 320, 300, 316], Color("3a4a3a"))
	poly([330, 370, 360, 370, 362, 320, 340, 316], Color("3a4a3a"))
	ln(425, 70, 425, 90, IRON, 3)
	poly([395, 90, 455, 90, 460, 250, 390, 250], Color("2a4a6a"))
	rr(490, 200, 120, 170, IRON, 8)
	c(550, 300, 20, FIRE if fmod(t, 0.6) < 0.3 else AMBER)
	r(530, 160, 40, 40, IRON)
	rr(632, 310, 96, 60, IS_WOOD, 4)
	if flag("pip_home"):
		_isl_puffin(680, 300, 0.7, true)
	# The chart, the tide clock (its hand shows the tide), the shelf, the almanac.
	rr(484, 34, 132, 112, Color("f4ead2"), 3)
	for k in range(5):
		ln(484, 34 + k * 22, 616, 34 + k * 22, Color(INK, 0.15), 1)
	c(695, 90, 42, IS_WOOD)
	c(695, 90, 34, CREAM)
	var sea: Dictionary = clues.get("sea", {})
	var drift: Array = sea.get("drift", [1, 0])
	var dv := Vector2(int(drift[0]), int(drift[1]))
	ln(695 - dv.x * 24, 90 - dv.y * 24, 695 + dv.x * 22, 90 + dv.y * 22, Color("2a5a8a"), 5)
	var tip := Vector2(695, 90) + dv * 32
	var side := Vector2(-dv.y, dv.x) * 10
	poly([tip.x, tip.y, tip.x - dv.x * 14 + side.x, tip.y - dv.y * 14 + side.y, tip.x - dv.x * 14 - side.x, tip.y - dv.y * 14 - side.y], Color("2a5a8a"))
	r(756, 170, 140, 8, IS_WOOD_D)
	if not flag("got_whistle"):
		item("pswhistle", 790, 150, 1.4)
	if not flag("got_seeds"):
		rr(838, 126, 44, 44, Color("4a7a8a"), 4)
	rr(764, 270, 122, 56, Color("6a3a2a"), 4)
	r(820, 270, 4, 56, Color("f4ead2"))
	if not flag("got_line"):
		ring(425, 200, 10, Color("d8c8a0"), 3)


func _psboat() -> void:
	r(0, 0, 960, 472, IS_SEA["spring"])
	var sea: Dictionary = clues.get("sea", {})
	var w := int(sea.get("w", 6))
	var h := int(sea.get("h", 5))
	var blocked: Array = sea.get("blocked", [])
	var at := int(st.get("boat", [24])[0])
	var o: Vector2 = IslandViews.SEA_AT
	var cs: float = IslandViews.SEA_CELL
	for i in range(w * h):
		var cx := o.x + (i % w) * cs
		var cy := o.y + int(i / w) * cs
		r(cx + 1, cy + 1, cs - 2, cs - 2, Color(1, 1, 1, 0.06))
		var near := absi(i % w - at % w) <= 1 and absi(int(i / w) - int(at / w)) <= 1
		var rock := false
		for b in blocked:
			if int(b) == i:
				rock = true
		if rock and near:
			c(cx + cs / 2, cy + cs / 2, cs * 0.35, IS_ROCK)
		elif not near:
			r(cx + 1, cy + 1, cs - 2, cs - 2, Color(0.9, 0.93, 0.96, 0.55 + 0.05 * sin(t + i)))
	# The bird rock with its nest, the jetty.
	var goal := int(sea.get("goal", 5))
	c(o.x + (goal % w) * cs + cs / 2, o.y + int(goal / w) * cs + cs / 2, cs * 0.42, IS_ROCK.darkened(0.2))
	if not flag("got_pip"):
		_isl_puffin(o.x + (goal % w) * cs + cs / 2, o.y + int(goal / w) * cs + cs / 2, 0.6, true)
	r(o.x - 40, o.y + (h - 1) * cs + 20, 40, 30, IS_WOOD)
	# The boat.
	var bx := o.x + (at % w) * cs + cs / 2
	var by := o.y + int(at / w) * cs + cs / 2
	poly([bx - 22, by - 8, bx + 22, by - 8, bx + 16, by + 12, bx - 16, by + 12], Color("c84a3a"))
	if flag("oars_in"):
		ln(bx - 10, by, bx - 30, by + 6 * sin(t * 6.0), IS_WOOD, 3)
		ln(bx + 10, by, bx + 30, by + 6 * sin(t * 6.0), IS_WOOD, 3)
		_isl_pad()


func _isl_pad() -> void:
	var pad: Dictionary = IslandViews.PAD
	var dirs := {"n": 0, "s": 1, "w": 2, "e": 3}
	for d in ["n", "w", "e", "s"]:
		var rect: Rect2 = pad[d]
		arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, dirs[d])


func _pschart() -> void:
	board(IS_WOOD_D)
	rr(140, 20, 680, 440, Color("f4ead2"), 4)
	var sea: Dictionary = clues.get("sea", {})
	var w := int(sea.get("w", 6))
	var h := int(sea.get("h", 5))
	var blocked: Array = sea.get("blocked", [])
	var cs := 70.0
	var o := Vector2(270, 60)
	for i in range(w * h):
		ring(o.x + (i % w) * cs + cs / 2, o.y + int(i / w) * cs + cs / 2, 2, Color(INK, 0.3), 1)
	for b in blocked:
		var i := int(b)
		poly([o.x + (i % w) * cs + 15, o.y + int(i / w) * cs + 55, o.x + (i % w) * cs + 35, o.y + int(i / w) * cs + 12, o.x + (i % w) * cs + 58, o.y + int(i / w) * cs + 55], Color("6f6a66"))
	var goal := int(sea.get("goal", 5))
	_isl_puffin(o.x + (goal % w) * cs + cs / 2, o.y + int(goal / w) * cs + cs / 2, 0.6, false)
	var start := int(sea.get("start", 24))
	r(o.x + (start % w) * cs + 10, o.y + int(start / w) * cs + 40, 50, 14, IS_WOOD)
	# The compass rose.
	ln(200, 120, 200, 60, INK, 3)
	poly([200, 50, 192, 66, 208, 66], INK)
	txt(200, 140, "N", 16, INK)


func _ps3() -> void:
	_isl_scene("spring", 200)
	# The bird rock out at sea, the cliffs and the puffin ledge, the flagpole.
	c(360, 180, 40, IS_ROCK)
	poly([0, 372, 0, 230, 200, 210, 460, 240, 520, 372], IS_LAND["spring"].darkened(0.2))
	for k in range(6):
		var px := 100.0 + k * 55.0
		var py := 260.0 + 10 * sin(k)
		if flag("called") or k < 2:
			_isl_puffin(px, py + 2 * sin(t * 3.0 + k), 0.6, false)
		else:
			c(px, py + 10, 10, Color("2a1a10"))
	poly([520, 372, 560, 220, 960, 200, 960, 372], IS_LAND["spring"])
	r(736, 40, 8, 330, IS_WOOD_D)
	var flags: Array = st.get("pennants", [0, 0, 0])
	if flag("told"):
		for i in range(3):
			_isl_flag(744, 50 + i * 50, int(flags[i]), 0.8)


func _isl_flag(x: float, y: float, kind: int, s: float) -> void:
	var col: Color = IS_FLAGS[kind % IS_FLAGS.size()]
	var wave := 4.0 * sin(t * 4.0 + y)
	poly([x, y, x + 60 * s, y + wave, x + 60 * s, y + 40 * s + wave, x, y + 40 * s], col)
	match kind:
		0:
			ln(x, y + 20 * s, x + 60 * s, y + 20 * s + wave, Color("f2f2f2"), 6 * s)
		1:
			c(x + 30 * s, y + 20 * s + wave / 2, 10 * s, Color("c83a3a"))
		2:
			poly([x, y, x + 60 * s, y + 40 * s + wave, x, y + 40 * s], Color("f2f2f2"))
		3:
			r(x + 20 * s, y, 20 * s, 40 * s, Color("2a4a8a"))
		4:
			poly([x, y, x + 30 * s, y + 20 * s, x, y + 40 * s], Color("f2f2f2"))
		_:
			r(x, y + 14 * s, 60 * s, 12 * s, Color("e8c830"))


func _psflags() -> void:
	_isl_scene("spring", 300)
	# The signal book: each flag with its message as a picture.
	rr(80, 30, 380, 420, Color("f4ead2"), 4)
	var icons := ["storm", "chick", "fish", "sun", "jetty", "boat"]
	for k in range(6):
		var y := 50.0 + k * 66
		_isl_flag(110, y, k, 0.8)
		_isl_icon(icons[k], 300, y + 18, 1.0)
	var flags: Array = st.get("pennants", [0, 0, 0])
	r(676, 40, 8, 400, IS_WOOD_D)
	for i in range(3):
		var x := 560.0 + i * 120.0
		if flag("told"):
			_isl_flag(x - 30, 236, int(flags[i]), 1.0)
		_s8_arrows(x, 230)
		txt(x, 420, str(i + 1), 18, CREAM)


## Message pictures of the signal book and the code card.
func _isl_icon(kind: String, x: float, y: float, s: float) -> void:
	match kind:
		"storm":
			c(x, y - 6 * s, 14 * s, IS_ROCK)
			poly([x - 2 * s, y, x + 6 * s, y, x - 4 * s, y + 18 * s], AMBER)
		"chick":
			_isl_puffin(x, y + 6 * s, 0.5 * s, true)
		"fish":
			at(x, y, 0.0, s)
			poly([-14, 0, 0, -7, 10, 0, 0, 7], Color("2a6a8a"))
			poly([10, 0, 18, -7, 18, 7], Color("2a6a8a"))
			home()
		"sun":
			c(x, y, 10 * s, AMBER)
			for k in range(8):
				var a := k * TAU / 8
				ln(x + cos(a) * 13 * s, y + sin(a) * 13 * s, x + cos(a) * 19 * s, y + sin(a) * 19 * s, AMBER, 2)
		"jetty":
			r(x - 22 * s, y - 2 * s, 44 * s, 6 * s, IS_WOOD)
			for k in range(4):
				r(x - 20 * s + k * 13 * s, y + 4 * s, 3 * s, 12 * s, IS_WOOD_D)
		"harbour":
			ci.draw_arc(Vector2(x, y + 10 * s), 20 * s, PI, TAU, 10, IS_ROCK, 5 * s, true)
			poly([x - 8 * s, y + 6 * s, x + 8 * s, y + 6 * s, x + 6 * s, y + 12 * s, x - 6 * s, y + 12 * s], Color("c84a3a"))
		"cross":
			ln(x - 12 * s, y - 12 * s, x + 12 * s, y + 12 * s, Color("c83a3a"), 4)
			ln(x - 12 * s, y + 12 * s, x + 12 * s, y - 12 * s, Color("c83a3a"), 4)
		_:
			poly([x - 18 * s, y, x + 18 * s, y, x + 12 * s, y + 10 * s, x - 12 * s, y + 10 * s], Color("c84a3a"))
			ln(x, y, x, y - 18 * s, IS_WOOD_D, 2)


func _psledge() -> void:
	_isl_scene("spring", 160)
	poly([0, 300, 960, 260, 960, 472, 0, 472], IS_LAND["spring"].darkened(0.25))
	for k in range(7):
		var px := 160.0 + k * 100
		if flag("called"):
			_isl_puffin(px, 230 + 3 * sin(t * 3.0 + k), 0.9, false)
		else:
			_isl_puffin(fmod(px + t * 40.0, 960.0), 60 + 10 * sin(t + k), 0.5, false)
	rr(200, 280, 240, 150, Color(0, 0, 0, 0.4), 12)
	rr(520, 280, 240, 150, Color(0, 0, 0, 0.4), 12)
	r(300, 345, 40, 20, CREAM)
	r(580, 345, 120, 20, CREAM)
	var done := int(st.get("calls", [0])[0])
	for k in range(4):
		c(420 + k * 40, 450, 7, AMBER if k < done or flag("called") else Color(1, 1, 1, 0.2))


func _ps4() -> void:
	_isl_scene("spring", 120)
	r(0, 120, 960, 252, IS_LAND["spring"])
	# The well and the can, the patch, the woodpile, the pen and gates.
	c(124, 300, 50, IS_ROCK)
	c(124, 300, 36, Color("1a2a3a"))
	ln(84, 300, 84, 180, IS_WOOD_D, 6)
	ln(164, 300, 164, 180, IS_WOOD_D, 6)
	r(80, 176, 88, 10, IS_WOOD_D)
	if not flag("got_can"):
		item("pscan", 230, 345, 1.6)
	r(290, 280, 230, 90, Color("6a4a2a"))
	for k in range(3):
		var row_col: Color = IS_SEEDS[int(st.get("rows", [3, 3, 3])[k])] if flag("sown") else Color("5a3a1a")
		r(300, 292 + k * 26, 210, 10, row_col)
	if flag("watered"):
		r(290, 280, 230, 90, Color(0.3, 0.5, 0.9, 0.15))
	if not flag("got_planks"):
		for k in range(4):
			r(550, 300 + k * 16, 100, 12, IS_WOOD if k % 2 == 0 else IS_WOOD_D)
	for k in range(5):
		r(680 + k * 50, 180, 6, 190, IS_WOOD)
	ln(680, 220, 900, 220, IS_WOOD, 4)
	ln(680, 300, 900, 300, IS_WOOD, 4)
	if flag("lamb_in"):
		_isl_lamb(790, 330, 0.8)
	else:
		_isl_lamb(600 + 20 * sin(t * 0.5), 200, 0.7)


func _isl_lamb(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	for k in range(5):
		c(-16 + k * 8, -6 + 3 * (k % 2), 12, Color("f4f0e8"))
	c(22, -12, 9, Color("3a3a3a"))
	for k in range(4):
		r(-14 + k * 9, 4, 4, 14, Color("3a3a3a"))
	home()


func _pspatch() -> void:
	r(0, 0, 960, 472, Color("7a5a3a"))
	r(0, 0, 140, 472, IS_ROCK)
	c(900, 60, 40, AMBER)
	var rows: Array = st.get("rows", [3, 3, 3])
	for i in range(3):
		var x := 300.0 + i * 180
		r(x - 40, 20, 80, 340, Color("5a3a1a"))
		if flag("got_seeds") and flag("dug"):
			rr(x - 30, 200, 60, 70, IS_SEEDS[int(rows[i])], 6)
			_isl_seed(int(rows[i]), x, 235)
			_s8_arrows(x, 220)
	if flag("watered"):
		for k in range(20):
			c(260 + fmod(k * 53.0, 460.0), 30 + fmod(k * 71.0 + t * 30, 330.0), 2, Color(0.6, 0.8, 1, 0.7))
	r(160, 380, 640, 80, Color(0, 0, 0, 0.15))


func _isl_seed(kind: int, x: float, y: float) -> void:
	match kind:
		0:
			poly([x - 6, y - 14, x + 6, y - 14, x, y + 16], Color("f0902a"))
		1:
			rr(x - 4, y - 16, 8, 32, Color("5aa040"), 4)
		2:
			c(x, y, 16, Color("3f7a3a"))
		_:
			c(x, y + 4, 12, Color("f4f0e0"))
			ln(x, y - 8, x, y - 18, Color("5aa040"), 3)


const _IS_GATE_TO := {"garden": Vector2(840, 70), "bog": Vector2(840, 200), "pen": Vector2(840, 320), "cliff": Vector2(840, 440)}


func _psgates() -> void:
	r(0, 0, 960, 472, IS_LAND["spring"])
	var g: Array = st.get("gates", [0, 0, 0])
	var spots: Array = IslandViews.GATE_SPOTS
	var path := Color("c8b080")
	var start := Vector2(170, 330)
	ln(start.x, start.y, spots[0].x, spots[0].y, path, 16)
	ln(spots[0].x, spots[0].y, spots[1].x, spots[1].y, path, 16)
	ln(spots[0].x, spots[0].y, spots[2].x, spots[2].y, path, 16)
	ln(spots[1].x, spots[1].y, _IS_GATE_TO["garden"].x, _IS_GATE_TO["garden"].y, path, 16)
	ln(spots[1].x, spots[1].y, _IS_GATE_TO["bog"].x, _IS_GATE_TO["bog"].y, path, 16)
	ln(spots[2].x, spots[2].y, _IS_GATE_TO["pen"].x, _IS_GATE_TO["pen"].y, path, 16)
	ln(spots[2].x, spots[2].y, _IS_GATE_TO["cliff"].x, _IS_GATE_TO["cliff"].y, path, 16)
	# Where each way leads.
	r(800, 40, 80, 60, Color("6a4a2a"))
	c(840, 70, 10, Color("3f7a3a"))
	c(840, 200, 34, Color("4a5a3a"))
	for k in range(4):
		r(808 + k * 20, 300, 4, 50, IS_WOOD)
	ln(800, 320, 880, 320, IS_WOOD, 3)
	poly([800, 472, 880, 410, 900, 472], IS_ROCK)
	# The gates, each pointing up (0) or down (1).
	for i in range(3):
		var p: Vector2 = spots[i]
		c(p.x, p.y, 34, Color(1, 1, 1, 0.3))
		var up := int(g[i]) == 0
		ln(p.x, p.y, p.x + 44, p.y + (-36 if up else 36), IS_WOOD_D, 10)
	# The lamb at the stile, ready to go.
	rr(80, 330, 180, 110, Color(0, 0, 0, 0.3), 12)
	_isl_lamb(170, 385, 1.0 if not flag("lamb_in") else 0.0)
	if flag("lamb_in"):
		_isl_lamb(840, 340, 0.8)


# --- Summer ------------------------------------------------------------------------

func _pu1() -> void:
	_isl_scene("summer")
	# The lobster pots, the harbour wall (Pip lands on it now and then), the
	# jetty from spring, the horn.
	for k in range(3):
		rr(70 + k * 46, 310 + (k % 2) * 10, 40, 50, Color("8a6a4a"), 12)
		for j in range(3):
			ln(74 + k * 46 + j * 12, 312 + (k % 2) * 10, 74 + k * 46 + j * 12, 356 + (k % 2) * 10, Color("5a3a2a"), 1)
	r(250, 260, 260, 60, IS_ROCK)
	for k in range(6):
		ln(250 + k * 44, 260, 250 + k * 44, 320, IS_ROCK.darkened(0.2), 2)
	var pip: Array = clues.get("pip", [10, 3])
	if not flag("got_screw") and _s9_moment(int(pip[0]), int(pip[1])):
		_isl_puffin(380, 236, 0.8, false)
		c(396, 224, 3, BRASS)
	r(540, 280, 240, 18, IS_WOOD)
	for k in range(5):
		r(550 + k * 50, 298, 6, 74, IS_WOOD_D)
	r(856, 160, 8, 140, IS_WOOD_D)
	poly([840, 170, 890, 150, 890, 190], BRASS)
	# Ewan's boat out at sea, closer once he is home.
	var bx := 700.0 if not flag("done") else 640.0
	poly([bx - 30, 230, bx + 30, 230, bx + 20, 244, bx - 20, 244], Color("2a5a3a"))
	ln(bx, 230, bx, 200, IS_WOOD_D, 2)


func _pu2() -> void:
	_isl_scene("summer", 260)
	_isl_lighthouse(480, 372, 1.25, flag("lit"))
	r(420, 240, 120, 132, IS_WOOD_D if not flag("lighthouse_open") else Color("1a1a1a"))
	rr(600, 260, 140, 110, IS_WALL.darkened(0.1), 4)
	if flag("lighthouse_open") and not flag("got_oil"):
		item("puoil", 640, 330, 1.6)
	rr(220, 300, 120, 70, Color("8a5a9a") if not flag("got_sewing") else Color(0, 0, 0, 0.2), 6)


func _pulamp() -> void:
	r(0, 0, 960, 472, Color("2a3440"))
	# The window onto the bay and Ewan's boat; the beam from the lens.
	r(600, 160, 300, 160, IS_SEA["summer"])
	var lens := int(st.get("lens", [1])[0])
	var goal := int(clues.get("lens", 6))
	var bx := 750.0 + (goal - 4) * 30.0
	poly([bx - 20, 270, bx + 20, 270, bx + 14, 282, bx - 14, 282], Color("2a5a3a"))
	if flag("lit"):
		var a := PI + lens * PI / 8.0
		var tip := Vector2(440 - cos(a) * 520, 220 + sin(a) * 120)
		poly([440, 210, tip.x, tip.y - 30, tip.x, tip.y + 30], Color(1, 1, 0.7, 0.35))
	# The lamp, the lens with its arrows, the shutter keys, the code card.
	rr(360, 160, 160, 210, BRASS_D, 12)
	c(440, 220, 50, Color(1, 0.9, 0.5) if flag("lit") else Color("4a4a4a"))
	rr(130, 130, 160, 220, Color(0.7, 0.85, 0.95, 0.5), 20)
	for k in range(5):
		ln(140, 150 + k * 40, 280, 150 + k * 40 + (lens - 3) * 4, Color(1, 1, 1, 0.5), 3)
	if not flag("screwed"):
		c(210, 240, 6, Color("1a1a1a"))
	arrow_btn(174, 34, 72, 56, 0)
	arrow_btn(174, 400, 72, 58, 1)
	rr(600, 330, 140, 110, Color(0, 0, 0, 0.4), 10)
	rr(760, 330, 140, 110, Color(0, 0, 0, 0.4), 10)
	r(650, 380, 40, 16, CREAM)
	r(790, 380, 80, 16, CREAM)
	rr(600, 20, 300, 120, Color("f4ead2"), 4)
	var icons := ["harbour", "storm", "cross"]
	var patterns := [clues.get("flashes", [0, 1, 1, 0, 1]), [1, 1, 0], [0, 0, 1, 1]]
	for k in range(3):
		_isl_icon(icons[k], 630, 44 + k * 36, 0.7)
		var p: Array = patterns[k]
		for j in range(p.size()):
			r(670 + j * 40, 38 + k * 36, 30 if int(p[j]) == 1 else 10, 10, INK)
	var sent := int(st.get("flashed", [0])[0])
	for k in range(5):
		c(620 + k * 28, 460, 6, AMBER if k < sent or flag("signalled") else Color(1, 1, 1, 0.2))


func _pu3() -> void:
	_isl_scene("summer", 140)
	r(0, 140, 960, 232, IS_LAND["summer"])
	r(240, 120, 300, 250, Color("a83a2a"))
	poly([220, 120, 390, 40, 560, 120], Color("6a2a1a"))
	r(260, 150, 250, 220, Color("7a2a1a") if not flag("barn_open") else Color("2a1a10"))
	if not flag("hay_in"):
		for k in range(4):
			rr(600 + k * 80, 300, 70, 60, Color("d8b860"), 10)


func _pubarn() -> void:
	r(0, 0, 960, 472, Color("3a2a1a"))
	r(0, 400, 960, 72, Color("5a4a2a"))
	if not flag("got_matches"):
		item("pumatches", 125, 95, 2.0)
	if not flag("got_kite"):
		item("pukite", 280, 120, 4.0)
	if not flag("got_twine"):
		item("putwine", 435, 115, 3.0)
	# The bales with their marks, and the sign showing the stack.
	var stacked := int(st.get("stacked", [0])[0])
	var bales: Array = clues.get("bales", [0, 1, 2, 3])
	for i in range(4):
		var up := false
		for k in range(stacked):
			if int(bales[k]) == i:
				up = true
		if flag("hay_in"):
			up = true
		var y := 270.0 if not up else 200.0 - i * 4
		rr(80 + i * 140, y, 120, 110, Color("d8b860"), 14)
		_isl_mark(IS_MARKS[i], 140 + i * 140, y + 55, 1.0)
	rr(640, 40, 260, 200, Color("f4ead2"), 4)
	for k in range(4):
		var b := int(bales[k])
		rr(690 + (k % 2) * 90, 180 - int(k / 2) * 60, 80, 50, Color("d8b860"), 8)
		_isl_mark(IS_MARKS[b], 730 + (k % 2) * 90, 205 - int(k / 2) * 60, 0.6)
		txt(680 + (k % 2) * 90, 176 - int(k / 2) * 60, str(k + 1), 14, INK)


func _isl_mark(kind: String, x: float, y: float, s: float) -> void:
	match kind:
		"circle":
			ring(x, y, 16 * s, Color("8a2a1a"), 5 * s)
		"triangle":
			poly([x, y - 18 * s, x + 18 * s, y + 14 * s, x - 18 * s, y + 14 * s], Color("8a2a1a"))
		"square":
			r(x - 15 * s, y - 15 * s, 30 * s, 30 * s, Color("8a2a1a"))
		_:
			var pts := []
			for i in range(10):
				var a := TAU * i / 10.0 - PI / 2
				var d := 18.0 * s if i % 2 == 0 else 8.0 * s
				pts.append_array([x + cos(a) * d, y + sin(a) * d])
			poly(pts, Color("8a2a1a"))


func _pu4() -> void:
	_isl_scene("summer", 200)
	poly([0, 372, 0, 220, 520, 230, 600, 372], IS_LAND["summer"])
	# The wind sock: it stands out in a gust.
	var gust: Array = clues.get("gust", [5, 2])
	var blowing := _s9_moment(int(gust[0]), int(gust[1]))
	r(140, 60, 6, 190, IS_WOOD_D)
	var droop := 0.0 if blowing else 40.0
	poly([146, 70, 220, 74 + droop, 214, 92 + droop, 146, 92], Color("e86a2a"))
	# The sea stack with Tom's dinghy; the line once across.
	poly([660, 360, 860, 360, 830, 80, 690, 80], IS_ROCK)
	poly([630, 330, 720, 330, 710, 346, 640, 346], Color("e8c830"))
	c(676, 318, 10, Color("e8c8a8"))
	if flag("tom_safe"):
		ln(380, 260, 690, 300, Color("d8c8a0"), 2)
	else:
		poly([300, 250, 380, 250, 390, 300, 290, 300], Color(0, 0, 0, 0.2))
	rr(544, 304, 82, 60, Color("6a3a2a"), 4)


func _isl_kite_sky(x: float, y: float, w: float, h: float, height: int, blowing: bool) -> void:
	r(x, y, w, h, Color("9fb4c6"))
	var kx := x + w * 0.6 + (10.0 * sin(t * 3.0) if blowing else 0.0)
	var ky := y + h - 40 - height * (h - 80) / 5.0
	ln(x + 30, y + h - 10, kx, ky + 16, Color("d8c8a0"), 2)
	poly([kx, ky - 22, kx + 16, ky, kx, ky + 22, kx - 16, ky], Color("d84a3a"))
	for k in range(5):
		ln(x, y + 30 + k * 60, x + w, y + 30 + k * 60, Color(1, 1, 1, 0.15), 1)


func _pukite() -> void:
	var gust: Array = clues.get("gust", [5, 2])
	var blowing := _s9_moment(int(gust[0]), int(gust[1]))
	var h := int(st.get("kite", [0])[0])
	_isl_kite_sky(0, 0, 960, 472, h, blowing)
	if blowing:
		for k in range(8):
			var lx := fmod(t * 400.0 + k * 130.0, 960.0)
			ln(lx, 60 + k * 30, lx + 60, 60 + k * 30, Color(1, 1, 1, 0.6), 2)
	# The stack the line must reach, the wind sock, the two keys.
	poly([880, 472, 960, 472, 960, 60, 900, 80], IS_ROCK)
	r(120, 330, 6, 110, IS_WOOD_D)
	poly([126, 340, 200 - (0 if blowing else 50), 344 + (0 if blowing else 40), 196 - (0 if blowing else 50), 360 + (0 if blowing else 40), 126, 362], Color("e86a2a"))
	rr(560, 300, 160, 130, Color(0, 0, 0, 0.4), 12)
	rr(740, 300, 160, 130, Color(0, 0, 0, 0.4), 12)
	ring(640, 365, 30, CREAM, 6)
	ln(640, 365, 680, 345, CREAM, 4)
	r(800, 340, 40, 50, CREAM)
	for k in range(5):
		c(40, 420 - k * 70, 8, AMBER if k < h or flag("tom_safe") else Color(1, 1, 1, 0.3))


# --- Autumn ------------------------------------------------------------------------

func _pa1() -> void:
	_isl_scene("autumn", 120)
	r(0, 120, 960, 252, IS_LAND["autumn"])
	# The scarecrow (a key under its hat), the apple tree, the hen house, the shed.
	r(120, 110, 8, 240, IS_WOOD_D)
	r(80, 160, 90, 8, IS_WOOD_D)
	c(124, 120, 20, Color("e8d8a0"))
	poly([94, 106, 154, 106, 140, 80, 108, 80], Color("4a3a2a"))
	var wind: Array = clues.get("wind", [6, 2])
	var sway := 10.0 * sin(t * 8.0) if _s9_moment(int(wind[0]), int(wind[1])) else 0.0
	r(304, 200, 16, 150, IS_WOOD_D)
	c(312 + sway, 140, 90, Color("c8642a"))
	c(262 + sway, 180, 50, Color("d88a2a"))
	if not flag("got_apples"):
		for k in range(6):
			c(250 + k * 25 + sway, 130 + (k % 3) * 30, 9, Color("c83a2a"))
	if flag("net_spread"):
		poly([220, 340, 400, 340, 380, 360, 240, 360], Color(1, 1, 1, 0.4))
	poly([450, 260, 600, 260, 600, 370, 450, 370], IS_WOOD)
	poly([440, 260, 525, 210, 610, 260], Color("8a3a2a"))
	r(640, 150, 250, 220, IS_WOOD_D)
	poly([630, 150, 765, 100, 900, 150], IS_ROOF)
	r(720, 220, 90, 150, Color("2a1a10") if flag("shed_open") else IS_WOOD)
	rr(474, 124, 82, 62, Color("6a3a2a"), 4)


func _pa2() -> void:
	r(0, 0, 960, 372, IS_WOOD)
	r(0, 372, 960, 100, IS_WOOD_D)
	# The press, the bottles, the oven, the window onto the spring patch.
	r(100, 100, 200, 220, Color("6a4a2a"))
	r(180, 60, 40, 60, IRON)
	if flag("pressed"):
		r(130, 300, 140, 20, Color("d8a040"))
	if not flag("got_bottles"):
		for k in range(3):
			rr(360 + k * 32, 290, 24, 70, Color(0.4, 0.6, 0.4, 0.8), 6)
	rr(500, 120, 200, 250, Color("8a6a5a"), 30)
	r(540, 220, 120, 80, Color("1a1a1a"))
	if flag("baking") and not flag("baked"):
		var golden: Array = clues.get("golden", [9, 3])
		var col := Color("e8b040") if _s9_moment(int(golden[0]), int(golden[1])) else Color("c87a3a")
		ci.draw_arc(Vector2(600, 285), 30, PI, TAU, 12, col, 14, true)
		c(600, 260, 50, Color(1, 0.6, 0.2, 0.2))
	r(730, 50, 170, 200, Color("bfe3f0"))
	r(730, 160, 170, 90, IS_LAND["autumn"])
	if not flag("got_veg"):
		for k in range(3):
			c(760 + k * 50, 200, 12, IS_SEEDS[k])


func _papress() -> void:
	r(0, 0, 960, 472, IS_WOOD_D)
	var screw := int(st.get("screw", [0])[0])
	var press := int(clues.get("press", 5))
	rr(120, 40, 440, 300, Color("6a4a2a"), 12)
	r(320, 40, 40, 120 + screw * 16, IRON)
	r(160, 200, 360, 120, Color("8a3a2a") if flag("in_press") else Color("4a3a2a"))
	if flag("pressed"):
		for k in range(4):
			c(200 + k * 90, 330 + fmod(t * 60 + k * 20, 40), 6, Color("d8a040"))
	# The gauge: a notch for each turn of the screw.
	rr(640, 40, 240, 80, Color("f4ead2"), 6)
	for k in range(8):
		r(660 + k * 26, 60, 14, 40, Color("3a7a3a") if k <= press else Color("c83a3a"))
	r(656 + screw * 26, 50, 22, 60, Color(0, 0, 0, 0.35))
	_s8_arrows(760, 230)
	ring(270, 405, 40, IRON, 10)
	ln(270, 405, 270 + cos(t * (2.0 if flag("pressed") else 0.0)) * 40, 405 + sin(t * (2.0 if flag("pressed") else 0.0)) * 40, IRON, 8)


func _pa3() -> void:
	_isl_scene("autumn", 200)
	r(0, 300, 960, 72, IS_WOOD)
	# The trader's stall, the judges' table, the crew, the cup.
	poly([60, 120, 330, 120, 310, 80, 80, 80], Color("c83a3a"))
	r(80, 120, 240, 250, Color("f2e6d0"))
	r(350, 260, 250, 20, IS_WOOD_D)
	if flag("ribbon"):
		c(475, 240, 16, Color("2a4a8a"))
	for k in range(3):
		c(670 + k * 40, 220, 16, Color("e8c8a8"))
		r(658 + k * 40, 236, 24, 60, Color("2a4a6a"))
	poly([830, 280, 880, 280, 870, 240, 840, 240], BRASS)
	ci.draw_arc(Vector2(855, 230), 20, 0, PI, 10, BRASS, 6, true)


func _pa4() -> void:
	_isl_scene("autumn", 140)
	# The regatta boats, the drum on the beat, Pip fishing.
	for k in range(3):
		poly([200 + k * 180, 300, 340 + k * 180, 300, 320 + k * 180, 330, 220 + k * 180, 330], [Color("c84a3a"), Color("2a5a8a"), Color("e8c830")][k])
	var beat: Array = clues.get("beat", [2, 1])
	var on := _s9_moment(int(beat[0]), int(beat[1]))
	rr(70, 230, 80, 120, Color("8a3a2a"), 10)
	c(110, 240, 36, CREAM if on else Color("c8b898"))
	_isl_puffin(840, 180 + 6 * sin(t * 2.0), 0.8, false)


func _parace() -> void:
	_isl_scene("autumn", 80)
	var race: Array = st.get("race", [0, 0])
	var need: int = int(clues.get("race", [6, 10])[0])
	var most: int = int(clues.get("race", [6, 10])[1])
	var lead := int(race[0])
	var strokes := int(race[1])
	# Our boat and the other one: the lead in lengths, the strokes left.
	var ours := 120.0 + lead * 100.0
	var theirs := 120.0 + strokes * 600.0 / most
	if flag("won"):
		ours = 820
	poly([ours - 60, 150, ours + 60, 150, ours + 40, 180, ours - 40, 180], Color("c84a3a"))
	poly([theirs - 60, 220, theirs + 60, 220, theirs + 40, 250, theirs - 40, 250], Color("2a5a8a"))
	r(860, 100, 6, 180, Color("f2f2f2"))
	for k in range(need):
		c(300 + k * 40, 120, 8, AMBER if k < lead or flag("won") else Color(1, 1, 1, 0.3))
	var beat: Array = clues.get("beat", [2, 1])
	var on := _s9_moment(int(beat[0]), int(beat[1]))
	rr(60, 280, 200, 160, Color("8a3a2a"), 14)
	c(160, 330, 60, CREAM if on else Color("b8a888"))
	rr(620, 260, 280, 180, Color(0, 0, 0, 0.45), 16)
	ln(680, 400, 840, 300, IS_WOOD, 10)
	rr(830, 290, 30, 20, IS_WOOD_D, 4)


# --- Winter ----------------------------------------------------------------------

func _isl_aurora() -> void:
	for k in range(3):
		var pts := []
		for j in range(13):
			pts.append_array([j * 80.0, 40 + k * 30 + 16.0 * sin(t * 1.2 + j * 0.6 + k)])
		for j in range(12, -1, -1):
			pts.append_array([j * 80.0, 90 + k * 30 + 16.0 * sin(t * 1.2 + j * 0.6 + k)])
		poly(pts, Color(0.3, 0.9, 0.6, 0.18 + (0.15 if flag("done") else 0.0)) if k != 1 else Color(0.6, 0.4, 0.9, 0.14))


func _pw1() -> void:
	_isl_scene("winter", 140)
	_isl_aurora()
	r(100, 150, 760, 220, Color("cfe0ee"))
	for k in range(6):
		ln(120 + k * 120, 160, 160 + k * 120, 360, Color(1, 1, 1, 0.5), 2)
	_isl_cottage(60, 330, 0.8)
	c(860, 170, 40, IS_ROCK.darkened(0.3))
	_isl_lighthouse(900, 140, 0.4, flag("done"))


func _pwlake() -> void:
	r(0, 0, 960, 472, Color("1c2a44"))
	var lake: Dictionary = clues.get("lake", {})
	var w := int(lake.get("w", 7))
	var h := int(lake.get("h", 6))
	var blocked: Array = lake.get("blocked", [])
	var o: Vector2 = IslandViews.LAKE_AT
	var cs: float = IslandViews.LAKE_CELL
	r(o.x, o.y, w * cs, h * cs, Color("cfe0ee"))
	for i in range(w * h):
		var cx := o.x + (i % w) * cs
		var cy := o.y + int(i / w) * cs
		ring(cx + cs / 2, cy + cs / 2, 2, Color(1, 1, 1, 0.6), 1)
	for b in blocked:
		var i := int(b)
		c(o.x + (i % w) * cs + cs / 2, o.y + int(i / w) * cs + cs / 2 + 6, cs * 0.42, Color("f4f8fc"))
		c(o.x + (i % w) * cs + cs / 2 - 10, o.y + int(i / w) * cs + cs / 2, cs * 0.3, Color("ffffff"))
	var goal := int(lake.get("goal", 6))
	poly([o.x + (goal % w) * cs + 8, o.y + int(goal / w) * cs + cs - 4, o.x + (goal % w) * cs + cs / 2, o.y + int(goal / w) * cs + 6, o.x + (goal % w) * cs + cs - 8, o.y + int(goal / w) * cs + cs - 4], Color("3a4a5a"))
	var at := int(st.get("skater", [35])[0])
	var sx := o.x + (at % w) * cs + cs / 2
	var sy := o.y + int(at / w) * cs + cs / 2
	c(sx, sy - 14, 10, Color("e8c8a8"))
	r(sx - 8, sy - 4, 16, 22, Color("c83a3a"))
	r(sx - 10, sy + 18, 20, 3, STEEL)
	if flag("got_skates"):
		_isl_pad()


func _pw2() -> void:
	r(0, 0, 960, 372, IS_WALL.darkened(0.1))
	r(0, 372, 960, 100, IS_WOOD)
	# The door (snow behind it), the scuttle, skates, almanac and drawer,
	# the stove, the lantern, Maggie in her chair.
	r(64, 60, 140, 310, IS_WOOD_D)
	if not flag("dug_out"):
		poly([70, 370, 200, 370, 200, 200, 70, 260], Color("eef3f8"))
	r(80, 90, 50, 50, Color("1c2a44"))
	rr(220, 310, 90, 60, IRON, 6)
	if not flag("got_skates"):
		item("pwskates", 365, 140, 2.4)
	rr(424, 210, 112, 56, Color("6a3a2a"), 4)
	r(420, 290, 120, 60, IS_WOOD_D)
	rr(570, 180, 120, 190, IRON, 8)
	c(630, 300, 22, FIRE if fmod(t, 0.6) < 0.3 else AMBER)
	if not flag("got_lantern"):
		item("pwlantern", 746, 140, 2.4)
	rr(800, 220, 100, 150, Color("7a4a3a"), 10)
	c(850, 200, 26, Color("e8c8a8"))
	ci.draw_arc(Vector2(850, 192), 26, PI, TAU, 12, Color("d8d8d8"), 10, true)


func _pwalmanac() -> void:
	_isl_almanac("pwtext.almanac", "winter")
	# The lake with its springs (thin ice), the carol as icicles.
	var lake: Dictionary = clues.get("lake", {})
	var w := int(lake.get("w", 7))
	var h := int(lake.get("h", 6))
	var thin: Array = clues.get("thin", [])
	var blocked: Array = lake.get("blocked", [])
	var cs := 34.0
	var o := Vector2(520, 50)
	r(o.x, o.y, w * cs, h * cs, Color("dfe9f2"))
	for b in blocked:
		var i := int(b)
		c(o.x + (i % w) * cs + cs / 2, o.y + int(i / w) * cs + cs / 2, cs * 0.4, Color("ffffff"))
		ring(o.x + (i % w) * cs + cs / 2, o.y + int(i / w) * cs + cs / 2, cs * 0.4, Color(INK, 0.3), 1)
	for i in thin:
		var cx := o.x + (int(i) % w) * cs + cs / 2
		var cy := o.y + int(int(i) / w) * cs + cs / 2
		ln(cx - 8, cy - 8, cx + 8, cy + 8, Color("c83a3a"), 3)
		ln(cx - 8, cy + 8, cx + 8, cy - 8, Color("c83a3a"), 3)
	var carol: Array = clues.get("carol", [])
	for k in range(carol.size()):
		var n := int(carol[k])
		poly([540 + k * 50, 300, 570 + k * 50, 300, 555 + k * 50, 330 + n * 22], Color("8ab8e0"))


func _pw3() -> void:
	r(0, 0, 960, 372, Color("2a3440"))
	r(0, 372, 960, 100, Color("3a3a3a"))
	r(0, 0, 960, 120, Color("17233f"))
	_isl_aurora()
	# The clockwork, the crank, the lamp, the lens panels, the chart.
	rr(64, 180, 190, 190, Color("5a5a5a"), 8)
	for k in range(3):
		ring(110 + k * 50, 260 + (k % 2) * 40, 22, BRASS, 6)
	if not flag("got_crank"):
		item("pwcrank", 296, 336, 1.6)
	rr(360, 130, 240, 240, BRASS_D, 12)
	c(480, 240, 70, Color(1, 0.9, 0.5) if flag("done") else Color("4a4a4a"))
	if flag("done"):
		poly([480, 240, 960, 160, 960, 320], Color(1, 1, 0.7, 0.3))
	rr(360, 20, 240, 90, Color(0.75, 0.85, 0.95, 0.6), 10)
	rr(680, 60, 220, 200, Color("f4ead2"), 4)


func _pwlens() -> void:
	r(0, 0, 960, 472, Color("2a3440"))
	var p: Array = st.get("panels", [1, 3, 2])
	for i in range(3):
		var x := 150.0 + i * 230
		rr(x, 80, 200, 300, Color(0.75, 0.88, 0.98, 0.8), 14)
		var frost := int(p[i])
		for k in range(frost * 6):
			c(x + 20 + fmod(k * 37.0, 160.0), 100 + fmod(k * 53.0, 260.0), 14, Color(1, 1, 1, 0.55))
		for k in range(4):
			ln(x + 20, 120 + k * 60 + frost * 8, x + 180, 120 + k * 60 + frost * 8, Color(1, 1, 1, 0.6), 3)
		txt(x + 100, 420, str(i + 1), 22, CREAM)
	if flag("lens_ok"):
		r(150, 80, 660, 300, Color(1, 1, 0.8, 0.12))


func _pwchart() -> void:
	board(IS_WOOD_D)
	rr(80, 20, 560, 440, Color("f4ead2"), 4)
	# The coast and its lights; this island's light marked with a puffin.
	poly([100, 400, 300, 380, 420, 420, 620, 400, 620, 440, 100, 440], Color("c8d8c0"))
	var lights := [Vector2(180, 120), Vector2(420, 90), Vector2(300, 260), Vector2(540, 300)]
	var pats := [1, 3, int(clues.get("pattern", 4)), 0]
	for k in range(4):
		_isl_lighthouse(lights[k].x, lights[k].y + 60, 0.3, false)
		rr(lights[k].x - 60, lights[k].y + 74, 130, 26, Color("1a2430"), 6)
		_isl_pattern(pats[k], lights[k].x - 52, lights[k].y + 81, 0.8)
	_isl_puffin(lights[2].x + 50, lights[2].y + 30, 0.6, false)
	# The lamp's selector: six patterns.
	rr(680, 120, 200, 220, Color("2a2a2a"), 10)
	var sel := int(st.get("pattern", [0])[0])
	_isl_pattern(sel, 712, 244, 1.0)
	_s8_arrows(780, 230)


## A light's character: flashes (long and short) over its period.
func _isl_pattern(kind: int, x: float, y: float, s: float) -> void:
	var shapes := [[1], [0, 0], [1, 0], [0, 0, 0], [0, 0, 1], [1, 1]]
	var p: Array = shapes[kind % shapes.size()]
	for j in range(p.size()):
		r(x + j * 34 * s, y, (26 if int(p[j]) == 1 else 10) * s, 12 * s, AMBER)


func _pw4() -> void:
	r(0, 0, 960, 472, Color("10161f"))
	var lit := flag("cave_lit")
	if lit:
		c(480, 240, 420, Color(1, 0.8, 0.4, 0.12))
	# The icicles hiding the barrel, the oil can, the barrel.
	for k in range(5):
		var drop := 250.0 + (k * 37) % 100 if not flag("freed") else 175.0
		poly([120 + k * 80, 150, 170 + k * 80, 150, 145 + k * 80, drop], Color(0.7, 0.85, 1.0, 0.8 if lit else 0.25))
	if flag("freed") and not flag("got_can"):
		item("pwcan", 585, 335, 1.8)
	rr(650, 200, 220, 170, Color("5a3a2a") if lit else Color("1a1410"), 20)
	if not lit:
		r(0, 0, 960, 472, Color(0, 0, 0, 0.5))


func _pwicicles() -> void:
	r(0, 0, 960, 472, Color("10161f"))
	c(480, 240, 420, Color(1, 0.8, 0.4, 0.1))
	var p: Array = st.get("played", [])
	var last := int(p[p.size() - 1]) - 1 if p.size() > 0 else -1
	for i in range(5):
		var x := 180.0 + i * 150
		var long := 220.0 + i * 30
		var glow := 1.0 if i == last else 0.75
		poly([x - 40, 40, x + 40, 40, x, 40 + long], Color(0.7, 0.85, 1.0, glow))
		if flag("freed"):
			poly([x - 40, 40, x + 40, 40, x, 60], Color(0.7, 0.85, 1.0, 0.8))
