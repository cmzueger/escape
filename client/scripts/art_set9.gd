## Draws the ninth set on top of ArtSet8: The Glass Aviary (AV1..AV4), Hall
## of Mirrors (HM1..HM4) and Detention (SC1..SC4), with their close-ups.
## Hotspots are in views_set9.gd.
class_name ArtSet9
extends ArtSet8

const AV9_GLASS := Color("d6efd0")
const AV9_FRAME := Color("f6f6ee")
const AV9_LEAF := Color("3f8a3a")
const AV9_LEAF_D := Color("2c6a2a")
const AV9_TERRA := Color("c07850")
const AV9_WATER := Color("5aa8b8")
const AV9_HOLES := [Color("d0483a"), Color("e8c030"), Color("4aa040"), Color("3a70d0")]
const HM9_NIGHT := Color("1a1530")
const HM9_PINK := Color("ff4fa8")
const HM9_BLUE := Color("4fd8ff")
const HM9_BULB := Color("ffe08a")
const HM9_RED := Color("c8283a")
const HM9_GOLD := Color("e8b84a")
const HM9_SILVER := Color("b8c4d0")
const HM9_BALLOONS := [Color("e03a3a"), Color("f0d030"), Color("3ab04a"), Color("3a6ae0"), Color("9a4ad0")]
const HM9_HORSES := [Color("d04040"), Color("4070d0"), Color("40a050"), Color("e8b84a")]
const SC9_WALL := Color("e8d8b0")
const SC9_WAINSCOT := Color("8a6a44")
const SC9_BOARD := Color("2f4a3a")
const SC9_CHALK := Color("f0f0e8")
const SC9_FLOOR := Color("9a7048")
const SC9_NAMES := ["Anna", "Ben", "Dora", "Emil", "Fritz"]
const SC9_SUMS := ["3 + 4 =", "9 - 3 =", "2 x 4 ="]
const SC9_ROMAN := ["I", "II", "III", "IV", "V"]
const SC9_BOOKS := [Color("a03a2a"), Color("2a5a8a"), Color("3a7a3a"), Color("8a6a2a"), Color("6a3a7a")]
const SC9_KEYS := [Color("d04040"), Color("e08a30"), Color("e8d030"), Color("4aa040"), Color("30a0a0"), Color("3a60d0"), Color("8a4ac0"), Color("e070b0")]
const SC9_TOWNS := [[180, 70], [330, 150], [470, 60], [600, 170], [720, 80], [820, 180]]
const SC9_HAIR := [Color("e8c860"), Color("5a3a1a"), Color("2a1a10"), Color("c86a2a"), Color("8a6a3a"), Color("1a1a1a"), Color("d8b070"), Color("7a4a2a")]
const SC9_SHIRT := [Color("c04040"), Color("4060a0"), Color("e8e0d0"), Color("40804a"), Color("8a5a9a"), Color("d09040"), Color("3a3a3a"), Color("60a0c0")]


func draw_view(view: String) -> void:
	match view:
		"AV1": _av1()
		"AV2": _av2()
		"AV3": _av3()
		"AV4": _av4()
		"avdesk": _avdesk()
		"avperches": _avperches()
		"avshade": _avshade()
		"avparrot":
			if flag("fed_parrot"):
				_s9_talk("parrot")
			else:
				_avparrot_big()
		"avorchid": _avorchid()
		"avcage": _avcage()
		"avjars": _avjars()
		"HM1": _hm1()
		"HM2": _hm2()
		"HM3": _hm3()
		"HM4": _hm4()
		"hmbooth": _hmbooth()
		"hmposter": _hmposter()
		"hmzelda":
			if flag("zelda_on"):
				_s9_talk("zelda")
			else:
				_hmzelda_big()
		"hmdrawing": _hmdrawing()
		"hmstall": _hmstall()
		"hmperiscope": _hmperiscope()
		"hmcart": _hmcart()
		"hmhorses": _hmhorses()
		"hmgen": _hmgen()
		"hmfuses": _hmfuses()
		"hmspots": _hmspots()
		"hmorgan": _hmorgan()
		"SC1": _sc1()
		"SC2": _sc2()
		"SC3": _sc3()
		"SC4": _sc4()
		"scboard": _scboard()
		"scabacus": _scabacus()
		"scclock": _scclock()
		"scmap": _scmap()
		"scdesks": _scdesks()
		"scletter": _scletter()
		"scshelf": _scshelf()
		"scpegs": _scpegs()
		"sctasks": _sctasks()
		"scregister": _scregister()
		"scharmonium": _scharmonium()
		"scglobe": _scglobe()
		"scbell": _scbell()
		"scphoto": _scphoto()
		"scwindow":
			if int(st.get("talk", [0])[0]) != 0:
				_s9_talk("janitor")
			else:
				_scwindow()
		"schutch": _schutch()
		"scstove": _scstove()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"avkeys", "hmkey", "sckey", "scclockkey", "scdoorkey":
			super.item("key", x, y, s)
			return
		"avnet":
			at(x, y, -0.5, s)
			r(-2, 0, 4, 18, WOOD)
			ring(0, -8, 10, AV9_FRAME, 2)
			for k in range(-6, 8, 4):
				ln(k, -16, k, 0, Color(1, 1, 1, 0.6), 1)
		"avfish":
			at(x, y, 0.0, s)
			poly([-14, 0, 0, -7, 10, 0, 0, 7], Color("d07a3a"))
			poly([10, 0, 18, -7, 18, 7], Color("d07a3a"))
			c(-7, -1, 1.5, INK)
		"avapple":
			at(x, y, 0.0, s)
			c(0, 2, 11, Color("c83a2a"))
			ln(0, -8, 2, -14, WOOD_D, 2)
			poly([2, -10, 10, -14, 6, -8], AV9_LEAF)
		"avknife", "hmstick":
			at(x, y, -0.7, s)
			if name == "avknife":
				r(-2, -16, 4, 18, STEEL)
				r(-3, 2, 6, 14, WOOD_D)
			else:
				r(-1.5, -16, 3, 32, Color("e8dcc0"))
		"avslices":
			at(x, y, 0.0, s)
			for k in range(3):
				ci.draw_arc(Vector2(-8 + k * 8, 0), 8, 0, PI, 8, Color("c83a2a"), 3, true)
				poly([-16 + k * 8, 0, k * 8, 0, -8 + k * 8, 7], Color("f0e0b0"))
		"avseed", "avgrain", "hmsugar", "avsugar":
			at(x, y, 0.0, s)
			var col := Color("e8d8a8") if name in ["avsugar", "hmsugar"] else Color("c8a060")
			poly([-12, 14, 12, 14, 10, -8, -10, -8], col)
			ln(-10, -8, 10, -8, WOOD_D, 2)
			if name == "avseed":
				c(0, 4, 5, Color("f8c830"))
		"avcan", "avwater", "sccan", "scfull":
			at(x, y, 0.0, s)
			rr(-10, -8, 20, 20, Color("6a8a9a"), 3)
			ln(10, 0, 20, -10, Color("6a8a9a"), 3)
			ci.draw_arc(Vector2(0, -8), 8, PI, TAU, 8, Color("6a8a9a"), 2, true)
			if name in ["avwater", "scfull"]:
				c(20, -6, 2, AV9_WATER)
				c(22, -1, 2, AV9_WATER)
		"avnectar":
			at(x, y, 0.0, s)
			rr(-7, -12, 14, 26, Color(0.9, 0.2, 0.3, 0.85), 4)
			r(-3, -16, 6, 5, STEEL)
		"avscoop":
			at(x, y, -0.4, s)
			rr(-10, -6, 18, 14, STEEL, 4)
			r(8, -2, 12, 5, WOOD)
		"avwhistle":
			at(x, y, -0.3, s)
			rr(-16, -4, 32, 9, WOOD, 4)
			for k in range(4):
				c(-9 + k * 6, 0, 1.8, AV9_HOLES[k])
		"hmcoin", "hmtoken":
			at(x, y, 0.0, s)
			c(0, 0, 10, HM9_GOLD if name == "hmcoin" else Color("b87a3a"))
			ring(0, 0, 7, Color(1, 1, 1, 0.5), 1.5)
			if name == "hmtoken":
				star(0, 0, 5, 2)
		"hmmallet":
			at(x, y, -0.6, s)
			r(-2, -6, 4, 22, WOOD)
			rr(-12, -16, 24, 12, WOOD_D, 3)
		"hmcylinder":
			at(x, y, 0.0, s)
			rr(-7, -14, 14, 28, HM9_SILVER, 3)
			r(-3, -12, 2, 24, Color(1, 1, 1, 0.8))
		"hmdarts":
			at(x, y, 0.0, s)
			for k in range(3):
				ln(-12, -8 + k * 8, 10, -10 + k * 8, STEEL, 2)
				poly([-12, -8 + k * 8, -18, -12 + k * 8, -18, -4 + k * 8], HM9_RED)
		"hmmirror":
			at(x, y, 0.0, s)
			c(0, 0, 12, HM9_SILVER)
			ln(-6, -6, 4, -2, Color(1, 1, 1, 0.9), 2)
		"hmfloss":
			at(x, y, 0.0, s)
			r(-1.5, 2, 3, 14, Color("e8dcc0"))
			c(0, -4, 10, Color("ffa8d8"))
			c(-6, -8, 6, Color("ffc0e0"))
		"scsponge", "scwet":
			at(x, y, 0.0, s)
			rr(-12, -8, 24, 16, Color("e8d060") if name == "scsponge" else Color("b8a840"), 4)
			for p in [[-6, -2], [3, 3], [6, -4]]:
				c(p[0], p[1], 2, Color(0, 0, 0, 0.2))
		"scink":
			at(x, y, 0.0, s)
			rr(-8, -10, 16, 22, Color("1a1a3a"), 3)
			r(-4, -14, 8, 5, Color("6a4a2a"))
		"sccarrot":
			at(x, y, -0.6, s)
			poly([-4, -10, 4, -10, 0, 16], Color("e8802a"))
			poly([-2, -10, -6, -18, 0, -12, 6, -18, 2, -10], AV9_LEAF)
		"scpencils":
			at(x, y, 0.0, s)
			for k in range(3):
				r(-12, -8 + k * 6, 22, 4, [Color("d04040"), Color("3a60d0"), Color("e8c030")][k])
				poly([10, -8 + k * 6, 16, -6 + k * 6, 10, -4 + k * 6], Color("e8d0a0"))
		"scmatches":
			super.item("matches", x, y, s)
			return
		"scsharpener":
			at(x, y, 0.0, s)
			rr(-8, -6, 16, 12, STEEL, 2)
			c(-2, 0, 3, INK)
		"scpin":
			at(x, y, 0.5, s)
			ln(0, -2, 0, 14, STEEL, 2)
			c(0, -6, 6, Color("3a9a4a"))
		"scscarf", "sccap", "scmitten":
			at(x, y, 0.0, s)
			var col: Color = {"scscarf": Color("c04040"), "sccap": Color("3a5aa0"), "scmitten": Color("4a8a4a")}[name]
			match name:
				"scscarf":
					r(-14, -6, 28, 8, col)
					r(6, -6, 7, 20, col)
				"sccap":
					ci.draw_arc(Vector2(0, 4), 12, PI, TAU, 12, col, 10, true)
					r(4, 2, 14, 4, col)
				_:
					rr(-8, -12, 16, 24, col, 7)
					rr(-14, -2, 8, 10, col, 4)
			txt(0, 5, {"scscarf": "E", "sccap": "A", "scmitten": "F"}[name], 10, CREAM)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"aviary":
			r(0, 0, w, h, AV9_GLASS)
			for k in range(1, 6):
				ci.draw_arc(Vector2(w * 0.5, h * 1.1), w * 0.12 * k, PI, TAU, 24, AV9_FRAME, 2, true)
			for k in range(7):
				ln(w * 0.5, h * 1.1, w * 0.5 + cos(PI + k * PI / 6) * w, h * 1.1 + sin(PI + k * PI / 6) * w, AV9_FRAME, 1.5)
			c(w * 0.85, h * 0.12, h * 0.3, Color(1, 1, 0.8, 0.35))
			for k in range(5):
				poly([w * (0.05 + k * 0.2), h, w * (0.1 + k * 0.2), h * 0.62, w * (0.18 + k * 0.2), h], AV9_LEAF if k % 2 == 0 else AV9_LEAF_D)
			var cols := [Color("f4d020"), Color("d0483a"), Color("3a70d0")]
			for k in range(3):
				var bx := fmod(t * (24.0 + k * 9.0) + k * 70.0, w + 40.0) - 20.0
				bird(bx, h * (0.3 + 0.12 * k) + 6.0 * sin(t * 3.0 + k), 0.6, cols[k])
		"mirrors":
			r(0, 0, w, h, HM9_NIGHT)
			var cx := w * 0.5
			poly([cx - w * 0.36, h * 0.32, cx, h * 0.06, cx + w * 0.36, h * 0.32], HM9_RED)
			poly([cx - w * 0.12, h * 0.32, cx, h * 0.06, cx + w * 0.12, h * 0.32], Color("f2e6d0"))
			for k in range(9):
				var on := int(t * 4.0 + k) % 2 == 0
				c(cx - w * 0.36 + k * w * 0.09, h * 0.33, 2.2, HM9_BULB if on else Color(HM9_BULB, 0.3))
			ln(cx, h * 0.32, cx, h * 0.86, HM9_GOLD, 2)
			r(cx - w * 0.38, h * 0.84, w * 0.76, h * 0.06, HM9_PINK)
			for k in range(4):
				var a := t * 0.9 + k * PI / 2
				var hx := cx + cos(a) * w * 0.3
				var hy := h * 0.62 + 5.0 * sin(t * 3.0 + k)
				if sin(a) > -0.2:
					ln(hx, h * 0.34, hx, hy, HM9_GOLD, 1)
					rr(hx - 6, hy - 4, 12, 8, HM9_HORSES[k], 3)
		"school":
			r(0, 0, w, h, SC9_WALL)
			rr(w * 0.08, h * 0.12, w * 0.6, h * 0.55, WOOD, 3)
			r(w * 0.1, h * 0.15, w * 0.56, h * 0.49, SC9_BOARD)
			var shown := int(fmod(t * 3.0, 12.0))
			var text := "2 x 4 = 8"
			txt(w * 0.14, h * 0.45, text.substr(0, mini(shown, text.length())), int(h * 0.16), SC9_CHALK, false)
			c(w * 0.84, h * 0.25, h * 0.13, CREAM)
			ring(w * 0.84, h * 0.25, h * 0.13, WOOD_D, 2)
			var sw := 0.4 * sin(t * 3.0)
			ln(w * 0.84, h * 0.4, w * 0.84 + sin(sw) * h * 0.3, h * 0.4 + cos(sw) * h * 0.3, BRASS, 2)
			c(w * 0.84 + sin(sw) * h * 0.3, h * 0.4 + cos(sw) * h * 0.3, 4, BRASS)
			poly([0, h, w * 0.5, 0, w * 0.7, 0, w * 0.3, h], Color(1, 0.9, 0.6, 0.18))
			r(0, h * 0.8, w, h * 0.2, SC9_FLOOR)
		_:
			super.card(room, w, h)


# --- Shared ------------------------------------------------------------------

func _s9_moment(cycle: int, show: int) -> bool:
	return int(st.get("secs", 0)) % cycle >= cycle - show


## A conversation: the one to talk to, or the line and its choices.
func _s9_talk(caller: String) -> void:
	var at_line := int(st.get("talk", [0])[0])
	match caller:
		"parrot":
			r(0, 0, 960, 472, AV9_GLASS)
			if at_line == 0:
				_av_parrot(480, 260, 2.2)
		"zelda":
			r(0, 0, 960, 472, Color("2a1838"))
			if at_line == 0:
				_hm_zelda(480, 250, 1.6)
		_:
			r(0, 0, 960, 472, Color("a8c890"))
			if at_line == 0:
				_sc_janitor(470, 300, 1.4)
	if at_line == 0:
		return
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


# --- The Glass Aviary ---------------------------------------------------------

func _av_dome() -> void:
	r(0, 0, 960, 372, AV9_GLASS)
	c(820, 20, 140, Color(1, 1, 0.8, 0.25))
	for k in range(13):
		ln(k * 80.0, 0, k * 80.0, 372, AV9_FRAME, 3)
	for k in range(1, 4):
		ln(0, k * 92.0, 960, k * 92.0 - 20, AV9_FRAME, 2)
	r(0, 372, 960, 100, AV9_TERRA)
	for k in range(12):
		ln(k * 90.0, 372, k * 110.0 - 100, 472, Color(AV9_TERRA, 1).darkened(0.15), 2)
	for k in range(4):
		var bx := fmod(t * (30.0 + k * 11.0) + k * 260.0, 1040.0) - 40.0
		bird(bx, 30 + 14 * k + 8.0 * sin(t * 2.0 + k), 0.7, [Color("f4d020"), Color("3a70d0"), Color("d0483a"), Color("6aa040")][k])


func _av_leaf(x: float, y: float, length: float, ang: float, col: Color) -> void:
	at(x, y, ang, 1.0)
	poly([0, 0, length * 0.5, -length * 0.2, length, 0, length * 0.5, length * 0.2], col)
	home()


func _av_parrot(x: float, y: float, s: float) -> void:
	var bob := 3.0 * sin(t * 3.0) if flag("fed_parrot") else 0.0
	at(x, y + bob, 0.0, s)
	poly([-14, 30, 14, 30, 20, -10, 6, -34, -10, -30, -20, -6], Color("d0302a"))
	poly([-10, -6, 8, 0, 4, 28, -14, 24], Color("2a5ac0"))
	poly([-4, 30, 4, 30, 0, 60], Color("e8c030"))
	c(4, -22, 4, CREAM)
	c(5, -22, 2, INK)
	poly([12, -26, 26, -18, 12, -12], Color("3a3030"))
	home()


func _av1() -> void:
	_av_dome()
	# Nest box on its post.
	r(124, 160, 12, 210, WOOD_D)
	poly([66, 72, 130, 40, 194, 72], WOOD_D)
	rr(82, 70, 96, 92, WOOD, 4)
	c(130, 110, 16, Color("2a1a10"))
	if not flag("got_keys"):
		c(136, 116, 1.5 + 1.0 * sin(t * 4.0), Color(1, 0.9, 0.5, 0.9))
	# The keeper's desk.
	r(220, 250, 220, 18, WOOD)
	r(230, 268, 14, 102, WOOD_D)
	r(416, 268, 14, 102, WOOD_D)
	rr(250, 230, 70, 24, PAPER, 2)
	rr(340, 228, 80, 26, PAPER, 2)
	for k in range(3):
		ln(352 + k * 22, 250, 352 + k * 22, 234, INK, 1)
	# The bell.
	ln(515, 46, 515, 74, IRON, 4)
	poly([488, 124, 542, 124, 532, 82, 498, 82], BRASS)
	c(515, 84, 16, BRASS)
	c(515, 128, 6, BRASS_D)
	ln(515, 132, 515, 166, Color("c8b898"), 3)
	# The perch stand: six perches at their heights.
	var perches: Array = st.get("perches", [0, 0, 0, 0, 0, 0])
	r(474, 360, 104, 10, WOOD_D)
	for i in range(6):
		var px := 484.0 + i * 17.0
		ln(px, 214, px, 360, WOOD_D, 3)
		var py := 350.0 - int(perches[i]) * 40.0
		ln(px - 7, py, px + 7, py, WOOD, 4)
	# The glass doors, chained.
	r(600, 40, 160, 330, Color(1, 1, 1, 0.3))
	for k in [600, 680, 760]:
		ln(k, 40, k, 370, AV9_FRAME, 5)
	ln(600, 40, 760, 40, AV9_FRAME, 5)
	if not st.get("done", false):
		for k in range(6):
			c(652 + k * 6, 210 + 3 * sin(k), 4, STEEL)
		rr(668, 214, 24, 22, IRON, 4)
	for k in range(4):
		_av_leaf(620 + k * 40, 370, 60, -1.2 - k * 0.2, AV9_LEAF)
	# The shade crank.
	ln(840, 0, 840, 150, Color("c8b898"), 3)
	ring(840, 190, 40, IRON, 8)
	var a := int(st.get("shade", [0])[0]) * PI / 2
	for k in range(4):
		ln(840, 190, 840 + cos(a + k * PI / 2) * 40, 190 + sin(a + k * PI / 2) * 40, IRON, 4)
	c(840 + cos(a) * 40, 190 + sin(a) * 40, 8, WOOD)


func _avdesk() -> void:
	board(Color("7a5a3a"))
	rr(70, 30, 400, 412, PAPER, 4)
	_s8_text(96, 76, 350, "avtext.note", 21, INK)
	rr(510, 30, 380, 412, PAPER, 4)
	_s8_text(530, 70, 340, "avtext.plan", 18, INK)
	var plan: Array = clues.get("perches", [0, 0, 0, 0, 0, 0])
	for i in range(3):
		var px := 600.0 + i * 100.0
		ln(px, 380, px, 160, WOOD_D, 4)
		for v in range(4):
			ln(px - 6, 370 - v * 60.0, px + 6, 370 - v * 60.0, Color(INK, 0.4), 2)
		var py := 370.0 - int(plan[i]) * 60.0
		ln(px - 24, py, px + 24, py, WOOD, 6)
		bird(px, py - 14, 1.0, Color("e8a030"))
		txt(px, 420, str(i + 1), 22, INK)


func _avperches() -> void:
	_av_dome()
	var perches: Array = st.get("perches", [0, 0, 0, 0, 0, 0])
	for i in range(6):
		var px := 130.0 + i * 140.0
		ln(px, 100, px, 400, WOOD_D, 6)
		for v in range(4):
			ln(px - 10, 380 - v * 60.0, px + 10, 380 - v * 60.0, Color(INK, 0.35), 2)
		var py := 380.0 - int(perches[i]) * 60.0
		ln(px - 44, py, px + 44, py, WOOD, 9)
		txt(px - 56, 448, str(i + 1), 20, INK)
		_s8_arrows(px, 230)


func _avshade() -> void:
	r(0, 0, 960, 472, Color("6a7a5a"))
	var v := int(st.get("shade", [0])[0])
	ring(300, 240, 150, IRON, 18)
	for k in range(6):
		var a := v * PI / 3 + k * PI / 3
		ln(300, 240, 300 + cos(a) * 150, 240 + sin(a) * 150, IRON, 8)
	c(300, 240, 24, IRON)
	c(300 + cos(v * PI / 3) * 150, 240 + sin(v * PI / 3) * 150, 18, WOOD)
	# The owl's corner of the dome, its shade lowered.
	r(580, 60, 240, 340, AV9_GLASS)
	ln(700, 60, 700, 400, AV9_FRAME, 3)
	r(580, 60, 240, 340.0 * v / 3.0, Color("2e3a2a"))
	rr(580, 60, 240, 340, Color(0, 0, 0, 0), 2)
	_s8_arrows(700, 230)


func _avparrot_big() -> void:
	r(0, 0, 960, 472, AV9_GLASS)
	ln(300, 330, 660, 330, WOOD_D, 10)
	_av_parrot(480, 240, 2.4)


func _av2() -> void:
	_av_dome()
	# The apple tree.
	poly([150, 370, 180, 370, 176, 170, 154, 170], WOOD_D)
	for k in range(9):
		c(100 + (k % 3) * 60 + 10 * sin(k), 90 + int(k / 3) * 40, 46, AV9_LEAF if k % 2 == 0 else AV9_LEAF_D)
	var apples := [[110, 120], [200, 90], [150, 160], [230, 150], [90, 70]]
	for k in range(5 if not flag("got_apple") else 4):
		c(apples[k][0], apples[k][1], 9, Color("c83a2a"))
	# The parrot on its ring.
	ln(296, 250, 424, 250, WOOD_D, 6)
	ln(360, 40, 360, 250, Color("c8b898"), 2)
	_av_parrot(360, 200, 1.0)
	# The hummingbird feeder.
	ln(515, 40, 515, 72, IRON, 2)
	rr(495, 72, 40, 96, Color(1, 0.4, 0.4, 0.4), 8)
	if flag("fed_humming"):
		r(497, 110, 36, 56, Color(0.9, 0.2, 0.3, 0.8))
	c(515, 176, 8, Color("e04a4a"))
	var hx := 550.0 + (10.0 * sin(t * 2.0) if flag("fed_humming") else 30.0 * sin(t * 0.7))
	var hy := 160.0 + (4.0 * sin(t * 9.0) if flag("fed_humming") else -40.0 + 20.0 * sin(t * 1.3))
	c(hx, hy, 6, Color("3aa070"))
	ln(hx - 4, hy, hx - 16, hy + 2, Color("2a6a4a"), 2)
	c(hx + 2, hy - 6, 8 + 2 * sin(t * 40.0), Color(0.6, 0.9, 0.7, 0.4))
	# The orchid and its misting nozzles.
	poly([640, 370, 720, 370, 730, 320, 630, 320], AV9_TERRA)
	for k in range(3):
		ln(660 + k * 20, 320, 650 + k * 30, 220 + k * 10, AV9_LEAF_D, 3)
		if flag("bloom"):
			for p in range(5):
				var a := p * TAU / 5.0 + k
				c(650 + k * 30 + cos(a) * 9, 220 + k * 10 + sin(a) * 9, 7, Color("e070c0"))
			c(650 + k * 30, 220 + k * 10, 4, Color("f8e040"))
		else:
			c(650 + k * 30, 220 + k * 10, 6, Color("8ab060"))
	if flag("bloom"):
		rr(712, 250, 40, 26, PAPER, 2)
	var mist: Array = st.get("mist", [0, 0, 0])
	for k in range(3):
		r(610 + k * 60, 186, 10, 12, STEEL)
		for m in range(int(mist[k]) * 3):
			c(615 + k * 60 + 14 * sin(t * 2.0 + m), 205 + fmod(t * 20.0 + m * 9.0, 40.0), 3, Color(1, 1, 1, 0.5))
	# The peacock.
	var fed := flag("fed_peacock")
	if fed:
		for k in range(9):
			var a := PI + 0.15 + k * (PI - 0.3) / 8.0 + 0.03 * sin(t * 2.0)
			ln(830, 320, 830 + cos(a) * 90, 320 + sin(a) * 90, Color("2a7a5a"), 4)
			c(830 + cos(a) * 88, 320 + sin(a) * 88, 7, Color("3a8ad0"))
	else:
		poly([810, 330, 900, 368, 820, 350], Color("2a7a5a"))
	c(830, 330, 22, Color("2a5aa0"))
	ln(840, 316, 846, 250, Color("2a5aa0"), 7)
	c(848, 246, 9, Color("2a5aa0"))
	poly([855, 244, 866, 248, 855, 251], Color("e8c030"))
	ln(824, 352, 820, 370, Color("8a7a5a"), 3)
	ln(838, 352, 840, 370, Color("8a7a5a"), 3)


func _avorchid() -> void:
	_av_dome()
	var mist: Array = st.get("mist", [0, 0, 0])
	for i in range(3):
		var vx := 160.0 + i * 170.0
		ring(vx, 273, 34, Color("c03a2a"), 8)
		var a := int(mist[i]) * PI * 0.5 - PI / 2
		ln(vx, 273, vx + cos(a) * 34, 273 + sin(a) * 34, Color("c03a2a"), 6)
		c(vx, 273, 8, STEEL)
		for m in range(int(mist[i]) * 4):
			c(vx + 30 * sin(t * 1.5 + m), 170 - fmod(t * 25.0 + m * 11.0, 70.0), 4, Color(1, 1, 1, 0.6))
		_s8_arrows(vx, 240)
	# The gauge: humidity from all three, the green mark.
	var total := int(mist[0]) + int(mist[1]) + int(mist[2])
	ci.draw_arc(Vector2(760, 420), 110, PI, TAU, 24, Color("e8e8e0"), 22, true)
	var good := PI + PI * (5.0 / 6.0)
	ci.draw_arc(Vector2(760, 420), 110, good - 0.12, good + 0.12, 6, Color("3aa040"), 22, true)
	var na := PI + PI * total / 6.0
	ln(760, 420, 760 + cos(na) * 100, 420 + sin(na) * 100, Color("c03a2a"), 4)
	c(760, 420, 10, IRON)
	# The orchid, in bloom once the air is right; its label.
	poly([700, 230, 820, 230, 830, 190, 690, 190], AV9_TERRA)
	for k in range(4):
		var fx := 690.0 + k * 50.0
		ln(760, 190, fx, 70 + 20 * (k % 2), AV9_LEAF_D, 3)
		if flag("bloom"):
			for p in range(5):
				var pa := p * TAU / 5.0 + k
				c(fx + cos(pa) * 14, 70 + 20 * (k % 2) + sin(pa) * 14, 11, Color("e070c0"))
			c(fx, 70 + 20 * (k % 2), 6, Color("f8e040"))
		else:
			c(fx, 70 + 20 * (k % 2), 8, Color("8ab060"))
	if flag("bloom"):
		rr(840, 100, 110, 120, PAPER, 4)
		var plan: Array = clues.get("perches", [0, 0, 0, 0, 0, 0])
		for i in range(3):
			var px := 862.0 + i * 33.0
			ln(px, 200, px, 120, WOOD_D, 2)
			ln(px - 10, 192 - int(plan[3 + i]) * 22.0, px + 10, 192 - int(plan[3 + i]) * 22.0, WOOD, 4)
			txt(px, 214, str(4 + i), 12, INK)


func _av3() -> void:
	_av_dome()
	var shade := int(st.get("shade", [0])[0])
	# The kingfisher on its branch.
	ln(64, 156, 214, 142, WOOD_D, 7)
	c(140, 126, 14, Color("2a7ad0"))
	c(150, 132, 9, Color("e8802a"))
	c(152, 114, 9, Color("2a7ad0"))
	poly([158, 112, 182, 116, 158, 120], INK)
	if flag("fed_king"):
		poly([176, 118, 190, 112, 196, 122], Color("d07a3a"))
	# The pond.
	ci.draw_set_transform(Vector2(254, 306), 0.0, Vector2(1.0, 0.3))
	c(0, 0, 190, AV9_WATER)
	c(-40, -30, 110, Color(1, 1, 1, 0.12))
	home()
	for k in range(3):
		ci.draw_set_transform(Vector2(140 + k * 110, 300 + (k % 2) * 30), 0.0, Vector2(1.0, 0.4))
		c(0, 0, 18, Color("4a9a3a"))
		home()
	var cycle: Array = [int(clues.get("cycle", 9)), int(clues.get("show", 3))]
	if not flag("got_fish") and _s9_moment(cycle[0], cycle[1]):
		var p := fmod(t * 0.6, 1.0)
		var fx := 220.0 + p * 120.0
		var fy := 300.0 - sin(p * PI) * 70.0
		at(fx, fy, p * 2.0 - 1.0, 1.4)
		poly([-14, 0, 0, -7, 10, 0, 0, 7], Color("d07a3a"))
		poly([10, 0, 18, -7, 18, 7], Color("d07a3a"))
		home()
	else:
		ring(260 + 40 * sin(t * 0.5), 310, 10 + fmod(t * 8.0, 20.0), Color(1, 1, 1, 0.3), 1.5)
	# The tap and the can.
	r(500, 150, 14, 60, STEEL)
	r(490, 200, 50, 14, STEEL)
	c(507, 150, 10, Color("c03a2a"))
	if fmod(t, 2.0) < 0.2:
		c(530, 230, 3, AV9_WATER)
	if not flag("got_can"):
		item("avcan", 515, 335, 1.8)
	# The canary's cage.
	ln(670, 0, 670, 180, IRON, 2)
	ci.draw_arc(Vector2(670, 240), 60, PI, TAU, 16, BRASS, 3, true)
	for k in range(7):
		ln(614 + k * 19, 240, 614 + k * 19, 360, BRASS, 2)
	r(606, 356, 128, 10, BRASS_D)
	bird(670, 320 + (4.0 * sin(t * 5.0) if flag("fed_canary") else 0.0), 1.3, Color("f4d020"))
	if flag("fed_canary"):
		for k in range(3):
			var ny := 210.0 - fmod(t * 20.0 + k * 20.0, 60.0)
			c(700 + k * 14, ny, 4, Color(INK, 0.6))
			ln(704 + k * 14, ny, 704 + k * 14, ny - 14, Color(INK, 0.6), 2)
	# The owl's corner (darker as the shade comes down), the owl and its perch.
	r(740, 0, 220, 372, Color(0, 0, 0, 0.16 * shade))
	ln(764, 216, 886, 216, WOOD_D, 7)
	var awake := flag("owl_awake")
	var oy := 80.0 if awake else 170.0
	ci.draw_set_transform(Vector2(825, oy), 0.0, Vector2(1.0, 1.3))
	c(0, 0, 30, Color("8a6a4a"))
	home()
	c(813, oy - 14, 9, CREAM)
	c(837, oy - 14, 9, CREAM)
	if awake:
		c(813, oy - 14, 5, INK)
		c(837, oy - 14, 5, INK)
		ln(764, 110, 886, 110, WOOD_D, 6)
	else:
		ln(806, oy - 14, 820, oy - 14, INK, 2)
		ln(830, oy - 14, 844, oy - 14, INK, 2)
	poly([820, oy - 4, 830, oy - 4, 825, oy + 4], Color("e8c030"))
	if awake and not flag("got_whistle"):
		item("avwhistle", 825, 206, 1.4)


func _avcage() -> void:
	_av_dome()
	ci.draw_arc(Vector2(480, 200), 170, PI, TAU, 24, BRASS, 5, true)
	for k in range(13):
		ln(316 + k * 27.3, 200, 316 + k * 27.3, 300, BRASS, 3)
	r(300, 296, 360, 16, BRASS_D)
	bird(480, 260 + (5.0 * sin(t * 5.0) if flag("fed_canary") else 0.0), 2.6, Color("f4d020"))
	if flag("fed_canary"):
		# The canary's song, on four coloured lines.
		var song: Array = clues.get("song", [])
		rr(30, 30, 250, 170, Color(1, 1, 1, 0.7), 8)
		for v in range(4):
			ln(44, 180 - v * 40.0, 266, 180 - v * 40.0, AV9_HOLES[v], 3)
		for k in range(song.size()):
			var n := int(song[k])
			c(70 + k * 46.0, 180 - n * 40.0, 12, AV9_HOLES[n])
			ln(80 + k * 46.0, 180 - n * 40.0, 80 + k * 46.0, 150 - n * 40.0, INK, 3)
	if flag("got_whistle"):
		rr(170, 330, 650, 120, WOOD, 40)
		for i in range(4):
			c(255 + i * 150.0, 390, 30, Color("2a1a10"))
			ring(255 + i * 150.0, 390, 30, AV9_HOLES[i], 6)


func _av4() -> void:
	_av_dome()
	r(40, 40, 880, 330, WOOD_D)
	if not flag("store_open"):
		r(300, 40, 360, 330, WOOD)
		for k in range(6):
			ln(300 + k * 60, 40, 300 + k * 60, 370, WOOD_D, 3)
		ln(300, 110, 660, 110, WOOD_D, 5)
		ln(300, 300, 660, 300, WOOD_D, 5)
		rr(460, 200, 40, 44, IRON, 5)
		ci.draw_arc(Vector2(480, 200), 14, PI, TAU, 10, STEEL, 5, true)
		return
	r(50, 50, 860, 310, Color("4a3020"))
	r(60, 300, 520, 10, WOOD)
	r(600, 200, 300, 10, WOOD)
	if not flag("got_net"):
		r(126, 60, 8, 220, WOOD)
		ring(130, 100, 40, Color(1, 1, 1, 0.8), 3)
		for k in range(-30, 40, 12):
			ln(130 + k, 70, 130 + k, 130, Color(1, 1, 1, 0.5), 1)
	if not flag("got_knife"):
		item("avknife", 275, 280, 2.0)
	if not flag("got_sugar"):
		item("avsugar", 405, 270, 2.6)
	if not flag("got_scoop"):
		item("avscoop", 530, 280, 2.4)
	for i in range(3):
		_av_jar(650 + i * 90.0, 130, 0.8, i)
	poly([630, 370, 800, 370, 790, 250, 640, 250], Color("c8a878"))
	ln(640, 254, 790, 254, WOOD_D, 3)
	for k in range(8):
		c(670 + k * 15, 262 + 4 * sin(k), 4, Color("d8b060"))


func _av_jar(x: float, y: float, s: float, i: int) -> void:
	at(x, y, 0.0, s)
	rr(-40, -60, 80, 130, Color(1, 1, 1, 0.45), 10)
	var level := 0.4 if i == 2 and flag("got_seed") else 0.8
	r(-36, 66 - 120 * level, 72, 120 * level, Color("d8b060") if i != 1 else Color("a0784a"))
	r(-44, -70, 88, 16, WOOD_D)
	rr(-28, -20, 56, 50, PAPER, 4)
	home()
	var cx := x
	var cy := y + 5 * s
	match i:
		0:
			star(cx, cy, 16 * s, 2)
		1:
			c(cx, cy, 15 * s, Color("e8e8f0"))
			c(cx + 7 * s, cy - 4 * s, 13 * s, PAPER)
		_:
			c(cx, cy, 10 * s, Color("f8c830"))
			for k in range(8):
				var a := k * TAU / 8.0
				ln(cx + cos(a) * 13 * s, cy + sin(a) * 13 * s, cx + cos(a) * 19 * s, cy + sin(a) * 19 * s, Color("f8c830"), 2)


func _avjars() -> void:
	board(WOOD_D)
	r(80, 400, 800, 20, WOOD)
	for i in range(3):
		_av_jar(240 + i * 240.0, 250, 2.2, i)


# --- Hall of Mirrors -----------------------------------------------------------

func _hm_night() -> void:
	r(0, 0, 960, 372, HM9_NIGHT)
	for k in range(30):
		c(fmod(k * 137.0, 960.0), fmod(k * 71.0, 200.0), 1.2, Color(1, 1, 1, 0.4 + 0.3 * sin(t * 2.0 + k)))
	for k in range(20):
		var on := int(t * 3.0 + k) % 3 != 0
		c(k * 50.0 + 25, 18 + 8 * sin(k * 0.8), 5, HM9_BULB if on else Color(HM9_BULB, 0.35))
	r(0, 372, 960, 100, Color("2a2238"))
	for k in range(30):
		c(fmod(k * 97.0, 960.0), 380 + fmod(k * 37.0, 90.0), 1.5, Color("4a3a50"))


func _hm_mirror(x: float, y: float, w: float, h: float, warp: float) -> void:
	rr(x - 6, y - 6, w + 12, h + 12, HM9_GOLD, 6)
	r(x, y, w, h, HM9_SILVER)
	ln(x + w * 0.1, y + h * 0.3, x + w * 0.5, y + h * 0.05, Color(1, 1, 1, 0.6), 3)
	# A reflection: the visitor, stretched or squashed.
	var cx := x + w * 0.5
	var pts := []
	for k in range(9):
		var yy := y + h * (0.25 + k * 0.08)
		pts.append_array([cx + 14 + warp * 10.0 * sin(k + t), yy])
	for k in range(8, -1, -1):
		var yy := y + h * (0.25 + k * 0.08)
		pts.append_array([cx - 14 + warp * 10.0 * sin(k + t), yy])
	poly(pts, Color(0.2, 0.2, 0.3, 0.5))
	c(cx + warp * 10.0 * sin(t), y + h * 0.2, 12, Color(0.2, 0.2, 0.3, 0.5))


func _hm_zelda(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	rr(-70, -150, 140, 300, Color("5a2a6a"), 10)
	rr(-58, -138, 116, 150, Color(0.6, 0.8, 1.0, 0.25), 8)
	c(0, -80, 26, Color("e8c8a0"))
	poly([-30, -96, 30, -96, 20, -126, -20, -126], Color("c03a6a"))
	c(0, -128, 6, HM9_GOLD)
	c(-9, -84, 3, INK)
	c(9, -84, 3, INK)
	ln(-8, -66, 8, -66, Color("8a2a2a"), 2)
	var glow := 0.5 + 0.3 * sin(t * 3.0) if flag("zelda_on") else 0.2
	c(0, -20, 24, Color(0.6, 0.8, 1.0, glow))
	r(-40, 40, 80, 8, Color("2a1a2a"))
	home()


func _hm1() -> void:
	_hm_night()
	# The ticket booth (the maze's plan pinned to it, a coin underneath).
	poly([60, 120, 182, 60, 304, 120], HM9_RED)
	r(70, 120, 230, 210, Color("f2e6d0"))
	for k in range(5):
		r(70 + k * 46, 120, 23, 210, HM9_RED)
	rr(110, 170, 92, 92, PAPER, 2)
	for k in range(4):
		ln(114 + k * 22, 174, 114 + k * 22, 258, Color(INK, 0.5), 1)
		ln(114, 174 + k * 22, 198, 174 + k * 22, Color(INK, 0.5), 1)
	r(70, 330, 230, 40, Color("140f20"))
	if not flag("got_coin"):
		c(220, 352, 3 + sin(t * 5.0), HM9_GOLD)
	# The turnstile at the maze's mirrored arch.
	ci.draw_arc(Vector2(425, 170), 100, PI, TAU, 20, HM9_PINK, 6, true)
	_hm_mirror(345, 90, 160, 80, 0.0)
	r(415, 220, 20, 150, STEEL)
	var a := t * 2.0 if flag("in_maze") else 0.0
	for k in range(3):
		var aa := a + k * TAU / 3.0
		ln(425, 250, 425 + cos(aa) * 70, 250 + sin(aa) * 20, STEEL, 6)
	r(440, 280, 16, 10, Color("101010"))
	# Zelda.
	_hm_zelda(635, 210, 1.0)
	# The balloon stall's poster.
	rr(745, 55, 140, 180, Color("f0e0c0"), 4)
	var order: Array = clues.get("balloons", [0, 1, 2, 3, 4])
	for k in range(order.size()):
		var bx := 768.0 + k * 24.0
		c(bx, 110 + 12 * sin(k), 11, HM9_BALLOONS[int(order[k])])
		ln(bx, 121 + 12 * sin(k), 815, 210, Color(INK, 0.5), 1)


func _hmbooth() -> void:
	board(HM9_RED)
	rr(200, 20, 560, 440, PAPER, 4)
	var maze: Array = clues.get("maze", [])
	var x0 := 280.0
	var y0 := 40.0
	var cell := 80.0
	for i in range(maze.size()):
		var m := int(maze[i])
		var cx := x0 + (i % 5) * cell
		var cy := y0 + int(i / 5) * cell
		if m & 1 == 0:
			ln(cx, cy, cx + cell, cy, INK, 4)
		if m & 4 == 0:
			ln(cx, cy + cell, cx + cell, cy + cell, INK, 4)
		if m & 8 == 0:
			ln(cx, cy, cx, cy + cell, INK, 4)
		if m & 2 == 0:
			ln(cx + cell, cy, cx + cell, cy + cell, INK, 4)
	var start := int(clues.get("start", 22))
	var centre := int(clues.get("centre", 12))
	star(x0 + (centre % 5) * cell + 40, y0 + int(centre / 5) * cell + 40, 22, 2)
	var sx := x0 + (start % 5) * cell + 40
	poly([sx, y0 + 5 * cell - 50, sx + 16, y0 + 5 * cell - 24, sx - 16, y0 + 5 * cell - 24], HM9_RED)
	ln(sx, y0 + 5 * cell - 24, sx, y0 + 5 * cell + 10, HM9_RED, 5)


func _hmposter() -> void:
	board(Color("2a1838"))
	rr(200, 20, 560, 440, Color("f0e0c0"), 6)
	for k in range(12):
		var a := k * TAU / 12.0 + t * 0.2
		ln(480, 240, 480 + cos(a) * 300, 240 + sin(a) * 300, Color(1, 0.8, 0.5, 0.3), 14)
	rr(200, 20, 560, 40, HM9_RED, 6)
	var order: Array = clues.get("balloons", [0, 1, 2, 3, 4])
	for k in range(order.size()):
		var bx := 280.0 + k * 100.0
		var by := 200.0 + 30 * sin(k * 1.3) + 4 * sin(t * 2.0 + k)
		ci.draw_set_transform(Vector2(bx, by), 0.0, Vector2(1.0, 1.2))
		c(0, 0, 36, HM9_BALLOONS[int(order[k])])
		c(-10, -12, 8, Color(1, 1, 1, 0.4))
		home()
		ln(bx, by + 44, 480, 420, Color(INK, 0.6), 2)
		txt(bx, by + 8, str(k + 1), 26, CREAM)


func _hmzelda_big() -> void:
	r(0, 0, 960, 472, Color("2a1838"))
	_hm_zelda(480, 250, 1.6)
	r(600, 330, 30, 10, Color("101010"))


func _hm2() -> void:
	_hm_night()
	if not flag("in_maze"):
		for k in range(4):
			_hm_mirror(200 + k * 140, 60, 120, 300, 0.3 * k)
		return
	var pos := int(st.get("pos", [22])[0])
	var maze: Array = clues.get("maze", [])
	var m := int(maze[pos]) if pos < maze.size() else 0
	# Floor, back wall (a corridor where the way goes on), side walls.
	poly([0, 372, 960, 372, 700, 300, 260, 300], Color("3a2a48"))
	var centre := pos == int(clues.get("centre", 12))
	if centre:
		r(270, 70, 420, 230, Color("2a1838"))
	elif m & 1:
		poly([380, 300, 580, 300, 540, 150, 420, 150], Color("101018"))
		_hm_mirror(440, 170, 80, 110, 0.0)
	else:
		_hm_mirror(270, 70, 420, 230, 0.0)
	if m & 8:
		poly([0, 40, 180, 90, 180, 300, 0, 372], Color("141020"))
	else:
		_hm_mirror(70, 70, 140, 280, 0.6)
	if m & 2:
		poly([960, 40, 780, 90, 780, 300, 960, 372], Color("141020"))
	else:
		_hm_mirror(750, 70, 140, 280, -0.6)
	ci.draw_arc(Vector2(480, 80), 260, PI * 1.1, PI * 1.9, 20, HM9_PINK, 4, true)
	if centre:
		r(440, 250, 80, 60, HM9_GOLD)
		_hm_icon(5, 480, 168 + 4 * sin(t * 2.0), 1.6, HM9_PINK)
		if not flag("got_key"):
			item("hmkey", 480, 236, 2.4)
	arrow_btn(STEP_N.position.x, STEP_N.position.y, STEP_N.size.x, STEP_N.size.y, 0)
	arrow_btn(STEP_W.position.x, STEP_W.position.y, STEP_W.size.x, STEP_W.size.y, 2)
	arrow_btn(STEP_E.position.x, STEP_E.position.y, STEP_E.size.x, STEP_E.size.y, 3)
	arrow_btn(STEP_S.position.x, STEP_S.position.y, STEP_S.size.x, STEP_S.size.y, 1)


const STEP_N := Rect2(444, 96, 72, 56)
const STEP_W := Rect2(240, 214, 72, 56)
const STEP_E := Rect2(648, 214, 72, 56)
const STEP_S := Rect2(444, 312, 72, 56)


func _hm3() -> void:
	_hm_night()
	for k in range(10):
		r(k * 96.0, 40, 48, 332, Color(0.5, 0.2, 0.5, 0.25))
	_hm_mirror(76, 46, 88, 308, 1.0)
	# The smeared drawing, a cylinder on it once placed.
	rr(184, 34, 112, 112, PAPER, 2)
	for k in range(5):
		ci.draw_arc(Vector2(240, 90), 18 + k * 8, 0.3 + k, 2.2 + k, 10, HM9_HORSES[k % 4], 4, true)
	if flag("unwarped"):
		rr(230, 66, 20, 40, HM9_SILVER, 3)
	# The squat mirror: darts glimpsed on the stall's shelf top.
	rr(176, 176, 128, 184, HM9_GOLD, 6)
	r(182, 182, 116, 172, HM9_SILVER)
	ci.draw_set_transform(Vector2(240, 300), 0.0, Vector2(1.6, 0.6))
	c(0, 0, 22, Color(0.2, 0.2, 0.3, 0.5))
	home()
	if not flag("got_darts"):
		for k in range(3):
			ln(200 + k * 10, 200, 214 + k * 10, 194, HM9_RED, 2)
	# The balloon stall.
	r(320, 120, 200, 18, WOOD_D)
	r(330, 138, 180, 232, Color("3a2a1a"))
	for k in range(5):
		c(354 + k * 34, 200 + 10 * sin(k * 2.0), 14, HM9_BALLOONS[k])
	r(320, 320, 200, 50, HM9_RED)
	# The strength tester.
	r(570, 60, 20, 300, Color("e8e0d0"))
	for k in range(6):
		r(566, 80 + k * 46, 28, 3, HM9_RED)
	c(580, 56, 16, BRASS)
	var tester: Array = clues.get("tester", [7, 2])
	var lamp := _s9_moment(int(tester[0]), int(tester[1])) and int(t * 6.0) % 2 == 0
	c(580, 350, 12, Color("ff4040") if lamp else Color("5a2020"))
	var puck_y := 70.0 if flag("got_token") else 330.0
	rr(568, puck_y, 24, 14, HM9_RED, 4)
	# The prize cabinet.
	rr(640, 40, 120, 150, Color("5a3a2a"), 6)
	r(650, 50, 100, 110, Color(0.7, 0.85, 1.0, 0.3))
	if not flag("cabinet_open"):
		item("hmmallet", 680, 110, 1.6)
		item("hmcylinder", 725, 110, 1.6)
		rr(690, 160, 20, 22, IRON, 4)
	# The curtain, or the periscope behind it.
	if flag("curtain_open"):
		r(640, 210, 30, 160, HM9_RED)
		r(690, 230, 26, 140, STEEL)
		r(690, 230, 50, 20, STEEL)
		c(744, 240, 12, Color("101010"))
	else:
		r(640, 210, 120, 160, HM9_RED)
		for k in range(6):
			ln(650 + k * 20, 210, 650 + k * 20, 370, Color("8a1a2a"), 3)
	# The candy-floss cart.
	rr(784, 220, 104, 110, Color("f0a0c8"), 8)
	c(836, 190, 34, Color("ffc0e0"))
	c(812, 340, 18, IRON)
	c(862, 340, 18, IRON)


func _hmdrawing() -> void:
	board(Color("2a1838"))
	rr(200, 40, 560, 400, PAPER, 4)
	var heights: Array = clues.get("horses", [0, 0, 0, 0])
	for k in range(4):
		var a0 := PI * 0.9 + k * 0.32
		ci.draw_arc(Vector2(480, 300), 120 + int(heights[k]) * 10, a0, a0 + 0.3, 8, HM9_HORSES[k], 10 + int(heights[k]) * 8, true)
	for k in range(6):
		ci.draw_arc(Vector2(480, 300), 70 + k * 30, PI * 1.05, PI * 1.95, 24, Color(INK, 0.15), 2, true)
	if flag("unwarped"):
		rr(370, 120, 220, 200, HM9_SILVER, 10)
		r(390, 130, 20, 180, Color(1, 1, 1, 0.6))
		for k in range(4):
			_hm_icon(5, 420 + k * 46, 220, 0.5 + int(heights[k]) * 0.35, HM9_HORSES[k])
	else:
		ci.draw_arc(Vector2(480, 300), 40, 0, TAU, 20, Color(INK, 0.3), 2, true)


func _hmstall() -> void:
	board(Color("3a2a1a"))
	r(140, 20, 680, 100, WOOD_D)
	r(140, 116, 680, 14, WOOD)
	if flag("darts_seen") and not flag("got_darts"):
		for k in range(3):
			ln(400 + k * 40, 116, 420 + k * 40, 90, HM9_RED, 4)
	var popped := int(st.get("pops", [0])[0])
	var order: Array = clues.get("balloons", [0, 1, 2, 3, 4])
	for i in range(5):
		var gone := flag("got_mirror")
		for k in range(popped):
			if int(order[k]) == i:
				gone = true
		var bx := 200.0 + i * 140.0
		if gone:
			for k in range(6):
				var a := k * TAU / 6.0
				ln(bx + cos(a) * 10, 240 + sin(a) * 10, bx + cos(a) * 26, 240 + sin(a) * 26, HM9_BALLOONS[i], 3)
		else:
			ci.draw_set_transform(Vector2(bx, 240 + 4 * sin(t * 2.0 + i)), 0.0, Vector2(1.0, 1.2))
			c(0, 0, 48, HM9_BALLOONS[i])
			c(-14, -16, 10, Color(1, 1, 1, 0.4))
			home()
	r(140, 340, 680, 110, HM9_RED)
	for k in range(8):
		r(140 + k * 85, 340, 42, 110, Color("f2e6d0"))
	if not flag("got_mirror"):
		item("hmmirror", 480, 394, 1.6)


func _hmperiscope() -> void:
	r(0, 0, 960, 472, Color("101018"))
	c(480, 240, 210, STEEL)
	c(480, 240, 190, Color("181820"))
	if not flag("saw_mark"):
		c(480, 240, 170, Color("2a2a30"))
		ring(480, 240, 120, Color("3a3a44"), 6)
		c(480, 240, 20, BRASS)
		return
	# Looking down on the generator: its dial and a chalk cross.
	c(480, 240, 170, Color("2a3a2a"))
	c(480, 240, 120, Color("5a5a52"))
	var mark := int(clues.get("generator", 0))
	for k in range(6):
		var a := k * TAU / 6.0 - PI / 2
		c(480 + cos(a) * 100, 240 + sin(a) * 100, 8, CREAM)
		if k == mark:
			var mx := 480 + cos(a) * 140
			var my := 240 + sin(a) * 140
			ln(mx - 14, my - 14, mx + 14, my + 14, Color(1, 1, 1, 0.9), 5)
			ln(mx - 14, my + 14, mx + 14, my - 14, Color(1, 1, 1, 0.9), 5)


func _hmcart() -> void:
	board(Color("2a1838"))
	rr(60, 380, 840, 70, Color("f0a0c8"), 8)
	if not flag("got_sugar"):
		item("avsugar", 175, 320, 4.0)
	if not flag("got_stick"):
		rr(310, 280, 100, 100, Color(1, 1, 1, 0.3), 6)
		for k in range(6):
			ln(330 + k * 12, 370, 326 + k * 14, 250, Color("e8dcc0"), 3)
	ci.draw_arc(Vector2(670, 260), 170, 0, PI, 24, STEEL, 12, true)
	r(500, 250, 340, 12, STEEL)
	if flag("sugar_in") and not flag("got_floss"):
		for k in range(12):
			var a := t * 6.0 + k
			c(670 + cos(a) * 80, 300 + sin(a) * 30, 22, Color(1, 0.75, 0.88, 0.6))
	r(650, 350, 40, 40, IRON)
	c(670, 90, 30, Color("ffc0e0") if flag("gen_ok") else Color("5a4a50"))


func _hm4() -> void:
	_hm_night()
	var fuses: Array = st.get("fuses", [0, 0, 0, 0, 0])
	var lights := int(fuses[1]) == 1 and flag("gen_ok")
	var turning := flag("turning")
	# The carousel.
	poly([200, 110, 395, 40, 590, 110], HM9_RED)
	poly([330, 110, 395, 40, 460, 110], Color("f2e6d0"))
	for k in range(14):
		var on := lights and int(t * 4.0 + k) % 2 == 0
		c(206 + k * 29, 112, 5, HM9_BULB if on else Color(HM9_BULB, 0.25))
	# Its sign: what it needs to go round.
	rr(345, 60, 100, 30, Color("101018"), 4)
	_hm_icon(0, 365, 75, 0.6, CREAM)
	_hm_icon(1, 395, 75, 0.6, CREAM)
	_hm_icon(2, 425, 75, 0.6, CREAM)
	ln(395, 112, 395, 340, HM9_GOLD, 6)
	r(210, 340, 370, 24, HM9_PINK)
	var heights: Array = st.get("horses", [0, 0, 0, 0])
	var saddle: Array = clues.get("saddle", [6, 2])
	for k in range(4):
		var hx := 250.0 + k * 96.0
		if turning:
			hx = 395.0 + 150.0 * sin(t * 0.8 + k * PI / 2)
		var hy := 290.0 - int(heights[k]) * 26.0 + (8.0 * sin(t * 3.0 + k) if turning else 0.0)
		ln(hx, 112, hx, 340, HM9_GOLD, 2)
		_hm_horse(hx, hy, 1.0, HM9_HORSES[k])
		if k == 3 and turning and _s9_moment(int(saddle[0]), int(saddle[1])):
			_hm_icon(4 + int(clues.get("card", 0)), hx, hy - 12, 0.7, INK)
	# Fuse box and generator.
	rr(76, 54, 100, 120, Color("5a6070"), 6)
	for k in range(5):
		r(88 + k * 18, 90, 10, 50, STEEL if int(fuses[k]) == 0 else Color("e8d030"))
	var shake := 2.0 * sin(t * 30.0) if flag("gen_ok") else 0.0
	rr(76 + shake, 230, 108, 130, Color("4a7a4a"), 8)
	c(130 + shake, 290, 34, Color("3a5a3a"))
	ring(130 + shake, 290, 34, STEEL, 4)
	# The brake lever.
	r(640, 150, 30, 20, IRON)
	var la := -0.5 if turning else 0.5
	ln(655, 150, 655 + sin(la) * 100, 150 - cos(la) * 100, IRON, 8)
	c(655 + sin(la) * 100, 150 - cos(la) * 100, 12, HM9_RED)
	# The clown.
	_hm_clown(660, 290, 1.0)
	# The organ.
	rr(724, 40, 164, 150, Color("8a3a2a"), 8)
	for k in range(8):
		var ph := 30.0 + 8.0 * (k % 4)
		r(736 + k * 18, 60 + ph, 12, 100 - ph, HM9_GOLD)
	if flag("music"):
		for k in range(3):
			var ny := 30.0 - fmod(t * 30.0 + k * 20.0, 60.0)
			c(780 + k * 30, 60 + ny, 5, CREAM)
	# The spotlights and the beam onto the sensor above.
	rr(740, 300, 60, 60, STEEL, 8)
	rr(820, 300, 60, 60, STEEL if flag("mirror_in") else Color("3a3a44"), 8)
	c(470, 30, 10, Color("ffe060") if flag("beam_ok") else Color("4a4a30"))
	if flag("beam_ok"):
		ln(770, 300, 850, 300, Color(1, 1, 0.7, 0.5), 6)
		ln(850, 300, 470, 30, Color(1, 1, 0.7, 0.4), 8)


func _hm_horse(x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	rr(-26, -12, 52, 24, col, 10)
	poly([18, -10, 30, -34, 40, -30, 30, -4], col)
	c(36, -30, 7, col)
	ln(-18, 10, -22, 30, col, 5)
	ln(18, 10, 22, 30, col, 5)
	poly([-26, -8, -38, 4, -28, 10], Color("2a1a10"))
	rr(-10, -18, 22, 8, HM9_RED, 3)
	home()


## Pictograms: 0 motor, 1 light, 2 music, 3 popcorn, 9 fan; 4..7 the organ
## cards (heart, star, moon, bell).
func _hm_icon(kind: int, x: float, y: float, s: float, col: Color) -> void:
	match kind:
		0:
			ring(x, y, 10 * s, col, 4 * s)
			for k in range(6):
				var a := k * TAU / 6.0
				c(x + cos(a) * 13 * s, y + sin(a) * 13 * s, 3.4 * s, col)
		1:
			c(x, y - 3 * s, 10 * s, col)
			r(x - 5 * s, y + 6 * s, 10 * s, 7 * s, col)
		2:
			c(x - 3 * s, y + 8 * s, 6 * s, col)
			ln(x + 3 * s, y + 8 * s, x + 3 * s, y - 14 * s, col, 3 * s)
			ln(x + 3 * s, y - 14 * s, x + 12 * s, y - 8 * s, col, 3 * s)
		3:
			poly([x - 10 * s, y - 2 * s, x + 10 * s, y - 2 * s, x + 7 * s, y + 14 * s, x - 7 * s, y + 14 * s], col)
			for k in range(3):
				c(x - 7 * s + k * 7 * s, y - 6 * s, 5 * s, col)
		4:
			c(x - 6 * s, y - 4 * s, 8 * s, col)
			c(x + 6 * s, y - 4 * s, 8 * s, col)
			poly([x - 13 * s, y, x + 13 * s, y, x, y + 16 * s], col)
		5:
			var pts := []
			for i in range(10):
				var a := TAU * i / 10.0 - PI / 2
				var d := 16.0 * s if i % 2 == 0 else 7.0 * s
				pts.append_array([x + cos(a) * d, y + sin(a) * d])
			poly(pts, col)
		6:
			ci.draw_arc(Vector2(x, y), 11 * s, PI * 0.55, PI * 1.95, 16, col, 7 * s, true)
		7:
			poly([x - 12 * s, y + 10 * s, x + 12 * s, y + 10 * s, x + 8 * s, y - 8 * s, x - 8 * s, y - 8 * s], col)
			c(x, y - 9 * s, 7 * s, col)
			c(x, y + 13 * s, 3 * s, col)
		_:
			for k in range(3):
				var a := k * TAU / 3.0 + t * 4.0
				poly([x, y, x + cos(a) * 14 * s, y + sin(a) * 14 * s, x + cos(a + 0.6) * 14 * s, y + sin(a + 0.6) * 14 * s], col)


func _hm_clown(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	poly([-26, 80, 26, 80, 20, 0, -20, 0], Color("3a8ad0"))
	for k in range(3):
		c(0, 14 + k * 20, 4, HM9_BULB)
	c(0, -24, 22, Color("f4e8e0"))
	c(0, -22, 6, HM9_RED)
	c(-18, -34, 10, Color("e86a2a"))
	c(18, -34, 10, Color("e86a2a"))
	poly([-12, -44, 12, -44, 0, -74], Color("3ab04a"))
	ci.draw_arc(Vector2(0, -16), 9, 0.2, PI - 0.2, 8, HM9_RED, 3, true)
	var reach := 1.0 if flag("music") else 0.0
	ln(20, 10, 46, 0 - 10 * reach, Color("3a8ad0"), 8)
	c(48, -2 - 10 * reach, 7, Color("f4e8e0"))
	if st.get("done", false):
		poly([-30, 0, -60, -14, -60, 14], HM9_GOLD)
		for k in range(3):
			ci.draw_arc(Vector2(-70, 0), 10 + k * 10 + fmod(t * 20.0, 10.0), PI * 0.7, PI * 1.3, 6, Color(1, 1, 1, 0.5), 2, true)
	home()


func _hmhorses() -> void:
	_hm_night()
	var heights: Array = st.get("horses", [0, 0, 0, 0])
	for i in range(4):
		var hx := 200.0 + i * 190.0
		ln(hx + 60, 20, hx + 60, 440, HM9_GOLD, 5)
		for v in range(4):
			ln(hx + 52, 380 - v * 60.0, hx + 68, 380 - v * 60.0, CREAM, 2)
		_hm_horse(hx, 380 - int(heights[i]) * 60.0, 1.7, HM9_HORSES[i])
		_s8_arrows(hx, 230)


func _hmgen() -> void:
	_hm_night()
	rr(120, 120, 360, 300, Color("4a7a4a"), 16)
	var v := int(st.get("generator", [0])[0])
	c(300, 270, 110, Color("3a5a3a"))
	for k in range(6):
		var a := k * TAU / 6.0 - PI / 2
		c(300 + cos(a) * 90, 270 + sin(a) * 90, 10, CREAM)
	var pa := v * TAU / 6.0 - PI / 2
	ln(300, 270, 300 + cos(pa) * 80, 270 + sin(pa) * 80, HM9_RED, 8)
	c(300, 270, 14, STEEL)
	if flag("gen_ok"):
		for k in range(4):
			ci.draw_arc(Vector2(300, 270), 130 + k * 12 + fmod(t * 30.0, 12.0), -0.6, 0.6, 6, Color(1, 1, 0.6, 0.4), 2, true)
	_s8_arrows(720, 230)


func _hmfuses() -> void:
	r(0, 0, 960, 472, Color("3a4050"))
	rr(130, 20, 700, 110, Color("5a6070"), 8)
	# The box's limit: three at once.
	_hm_icon(1, 430, 75, 1.0, HM9_BULB)
	txt(500, 90, "3", 40, HM9_BULB)
	poly([560, 50, 590, 50, 574, 76, 594, 76, 554, 112, 566, 82, 548, 82], HM9_BULB)
	var fuses: Array = st.get("fuses", [0, 0, 0, 0, 0])
	var kinds := [0, 1, 2, 3, 9]
	for i in range(5):
		var fx := 130.0 + i * 145.0
		rr(fx, 160, 110, 220, Color("2a2e38"), 8)
		_hm_icon(kinds[i], fx + 55, 196, 1.2, CREAM)
		var up := int(fuses[i]) == 1
		r(fx + 45, 240, 20, 120, Color("1a1a1a"))
		rr(fx + 30, 250 if up else 310, 50, 40, Color("e8d030") if up else STEEL, 6)


func _hmspots() -> void:
	r(0, 0, 960, 472, Color("181428"))
	var spots: Array = st.get("spots", [0, 0])
	var lamp := Vector2(110, 430)
	var a := Vector2(260, 290)
	var b := Vector2(700, 290)
	var sensor := Vector2(480, 70)
	var lit := flag("mirror_in") and flag("fuses_ok")
	rr(lamp.x - 30, lamp.y - 24, 60, 48, STEEL, 8)
	rr(400, 20, 160, 100, Color("3a3a44"), 8)
	c(sensor.x, sensor.y, 24, Color("ffe060") if flag("beam_ok") else Color("4a4a30"))
	# Each mirror sends the beam in one of eight directions; the right one
	# points at the next mirror, then at the sensor.
	var dir_a := (b - a).angle() + (int(spots[0]) - int(clues.get("spots", [0, 0])[0])) * PI / 4.0
	var dir_b := (sensor - b).angle() + (int(spots[1]) - int(clues.get("spots", [0, 0])[1])) * PI / 4.0
	_hm_spot_mirror(a, ((lamp - a).angle() + dir_a) / 2.0)
	if flag("mirror_in"):
		_hm_spot_mirror(b, ((a - b).angle() + dir_b) / 2.0)
	else:
		ring(b.x, b.y, 30, Color("5a5a64"), 4)
	if lit:
		ln(lamp.x, lamp.y, a.x, a.y, Color(1, 1, 0.7, 0.6), 6)
		if int(spots[0]) == int(clues.get("spots", [0, 0])[0]):
			ln(a.x, a.y, b.x, b.y, Color(1, 1, 0.7, 0.6), 6)
			var end := b + Vector2(cos(dir_b), sin(dir_b)) * (sensor - b).length()
			ln(b.x, b.y, end.x, end.y, Color(1, 1, 0.7, 0.6), 6)
		else:
			var end2 := a + Vector2(cos(dir_a), sin(dir_a)) * 300.0
			ln(a.x, a.y, end2.x, end2.y, Color(1, 1, 0.7, 0.6), 6)
	if flag("mirror_in"):
		_s8_arrows(a.x, 250)
		_s8_arrows(b.x, 250)


func _hm_spot_mirror(p: Vector2, ang: float) -> void:
	var d := Vector2(cos(ang + PI / 2), sin(ang + PI / 2)) * 34.0
	ln(p.x - d.x, p.y - d.y, p.x + d.x, p.y + d.y, HM9_SILVER, 10)
	c(p.x, p.y, 6, STEEL)


func _hmorgan() -> void:
	r(0, 0, 960, 472, Color("5a2a2a"))
	for k in range(12):
		var ph := 20.0 + 10.0 * (k % 5)
		r(120 + k * 60, ph, 40, 70 - ph * 0.3, HM9_GOLD)
	rr(160, 90, 300, 300, PAPER, 10)
	_hm_icon(4 + int(st.get("card", [0])[0]), 310, 240, 5.0, HM9_RED)
	var spin := t * 3.0 if flag("music") else 0.0
	ring(720, 250, 80, IRON, 10)
	ln(720, 250, 720 + cos(spin) * 80, 250 + sin(spin) * 80, IRON, 8)
	c(720 + cos(spin) * 80, 250 + sin(spin) * 80, 14, WOOD)
	r(160, 400, 660, 60, Color("8a3a2a"))
	if flag("music"):
		for k in range(4):
			var ny := fmod(t * 40.0 + k * 50.0, 200.0)
			c(560 + k * 30, 380 - ny, 8, CREAM)


# --- Detention -------------------------------------------------------------------

func _sc_room() -> void:
	r(0, 0, 960, 372, SC9_WALL)
	r(0, 250, 960, 122, SC9_WAINSCOT)
	for k in range(16):
		ln(k * 60.0, 250, k * 60.0, 372, Color(SC9_WAINSCOT, 1).darkened(0.2), 2)
	r(0, 372, 960, 100, SC9_FLOOR)
	for k in range(8):
		ln(0, 380 + k * 12, 960, 380 + k * 12, Color(SC9_FLOOR, 1).darkened(0.15), 1)
	poly([520, 0, 700, 0, 980, 472, 600, 472], Color(1, 0.9, 0.6, 0.13))
	for k in range(10):
		c(600 + fmod(k * 37.0 + t * 5.0, 200.0), fmod(k * 53.0 + t * 7.0, 372.0), 1.5, Color(1, 1, 0.9, 0.5))


func _sc_janitor(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	poly([-50, 120, 50, 120, 40, 0, -40, 0], Color("4a5a6a"))
	c(0, -40, 34, Color("e8c8a0"))
	poly([-38, -60, 38, -60, 30, -80, -30, -80], Color("3a3a3a"))
	r(-44, -62, 88, 8, Color("3a3a3a"))
	c(-12, -42, 4, INK)
	c(12, -42, 4, INK)
	poly([-20, -22, 20, -22, 0, -10], Color("8a8a8a"))
	ln(60, 120, 80, -60, WOOD, 6)
	home()


func _sc1() -> void:
	_sc_room()
	# The abacus.
	rr(70, 180, 110, 180, WOOD, 4)
	for k in range(3):
		ln(80, 220 + k * 50, 170, 220 + k * 50, STEEL, 2)
		for b in range(6):
			c(88 + b * 10, 220 + k * 50, 5, [Color("d04040"), Color("3a60d0"), Color("e8c030")][k])
	# The blackboard.
	rr(200, 30, 420, 250, WOOD, 4)
	r(212, 42, 396, 226, SC9_BOARD)
	if flag("board_clean"):
		for k in range(3):
			txt(240, 100 + k * 60, SC9_SUMS[k], 34, SC9_CHALK, false)
	else:
		_sc_scribbles(212, 42, 396, 226)
	r(220, 268, 380, 10, WOOD_D)
	# The clock (stopped until wound) and the numeral chart.
	_sc_clock_face(705, 85, 48)
	rr(780, 30, 110, 120, PAPER, 3)
	for k in range(5):
		txt(800, 52 + k * 20, SC9_ROMAN[k], 14, INK, false)
		for d in range(k + 1):
			c(842 + d * 9, 48 + k * 20, 3, INK)
	# The wall map.
	_sc_map(650, 170, 240, 200, 0.3)


func _sc_scribbles(x: float, y: float, w: float, h: float) -> void:
	for k in range(14):
		var cx := x + fmod(k * 97.0, w - 60) + 30
		var cy := y + fmod(k * 61.0, h - 60) + 30
		ci.draw_arc(Vector2(cx, cy), 20 + (k % 3) * 12, k, k + 4.0, 14, Color(SC9_CHALK, 0.6), 3, true)
	for k in range(6):
		ln(x + 20 + k * 60, y + h - 30, x + 60 + k * 60, y + 30, Color(SC9_CHALK, 0.4), 3)


func _sc_clock_face(x: float, y: float, rad: float) -> void:
	c(x, y, rad + 6, WOOD)
	c(x, y, rad, CREAM)
	for k in range(12):
		var a := k * TAU / 12.0
		ln(x + cos(a) * rad * 0.82, y + sin(a) * rad * 0.82, x + cos(a) * rad * 0.95, y + sin(a) * rad * 0.95, INK, 2)
	var clock: Array = st.get("clock", [7, 2])
	var hour := int(clock[0]) + int(clock[1]) / 12.0
	var ha := hour * TAU / 12.0 - PI / 2
	var ma := int(clock[1]) * TAU / 12.0 - PI / 2
	ln(x, y, x + cos(ha) * rad * 0.5, y + sin(ha) * rad * 0.5, INK, rad * 0.08)
	ln(x, y, x + cos(ma) * rad * 0.8, y + sin(ma) * rad * 0.8, INK, rad * 0.05)
	c(x, y, rad * 0.06, INK)


func _sc_map(x: float, y: float, w: float, h: float, s: float) -> void:
	rr(x, y, w, h, Color("d8e0c0"), 4)
	ci.draw_set_transform(Vector2(x + w * 0.45, y + h * 0.5), 0.0, Vector2(w / 900.0, h / 260.0))
	poly([-400, -60, -200, -120, 50, -100, 300, -120, 420, 0, 300, 110, 0, 120, -250, 100, -420, 40], Color("a8c888"))
	poly([-60, -20, 40, -30, 60, 30, -40, 40], AV9_WATER)
	ln(-420, 60, 420, -40, Color("6a8ad0"), 8)
	home()
	for i in range(6):
		var tx := x + float(SC9_TOWNS[i][0]) / 960.0 * w * 1.0
		var ty := y + float(SC9_TOWNS[i][1]) / 240.0 * h * 0.9 + 6
		_sc_town(i, tx, ty, s * 2.0)
	if flag("pinned") or s > 0.6:
		var route: Array = st.get("route", [0, 0, 0])
		var pins := 3 if flag("pinned") else 2
		for k in range(pins):
			var town := int(route[k])
			var px := x + float(SC9_TOWNS[town][0]) / 960.0 * w + 8 * k
			var py := y + float(SC9_TOWNS[town][1]) / 240.0 * h * 0.9 - 4
			ln(px, py, px, py + 12 * s * 2, STEEL, 2)
			c(px, py, 5 * s * 2, [Color("d04040"), Color("3a60d0"), Color("3a9a4a")][k])


## Towns on the map: church, lake, mill, farm, castle, bridge.
func _sc_town(i: int, x: float, y: float, s: float) -> void:
	match i:
		0:
			r(x - 6 * s, y - 6 * s, 12 * s, 12 * s, INK)
			poly([x - 3 * s, y - 6 * s, x + 3 * s, y - 6 * s, x, y - 16 * s], INK)
		1:
			ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(1.0, 0.5))
			c(0, 0, 10 * s, Color("3a6ad0"))
			home()
		2:
			r(x - 4 * s, y - 8 * s, 8 * s, 14 * s, INK)
			ln(x - 10 * s, y - 14 * s, x + 10 * s, y - 2 * s, INK, 2)
			ln(x + 10 * s, y - 14 * s, x - 10 * s, y - 2 * s, INK, 2)
		3:
			poly([x - 9 * s, y + 6 * s, x + 9 * s, y + 6 * s, x + 9 * s, y - 2 * s, x, y - 10 * s, x - 9 * s, y - 2 * s], Color("8a3a2a"))
		4:
			r(x - 10 * s, y - 6 * s, 20 * s, 12 * s, INK)
			for k in range(3):
				r(x - 10 * s + k * 8 * s, y - 10 * s, 4 * s, 4 * s, INK)
		_:
			ci.draw_arc(Vector2(x, y + 6 * s), 10 * s, PI, TAU, 10, INK, 3, true)
			ln(x - 12 * s, y - 4 * s, x + 12 * s, y - 4 * s, INK, 2)


func _scboard() -> void:
	board(WOOD)
	r(80, 20, 800, 440, SC9_BOARD)
	if flag("board_clean"):
		for k in range(3):
			txt(200, 140 + k * 110, SC9_SUMS[k], 64, SC9_CHALK, false)
	else:
		_sc_scribbles(80, 20, 800, 440)


func _scabacus() -> void:
	board(SC9_WALL)
	rr(200, 40, 560, 400, WOOD, 10)
	r(220, 60, 520, 360, Color("f0e4c8"))
	var vals: Array = st.get("abacus", [0, 0, 0])
	var cols := [Color("d04040"), Color("3a60d0"), Color("e8c030")]
	for i in range(3):
		var x := 300.0 + i * 180.0
		ln(x, 60, x, 420, STEEL, 4)
		var up := int(vals[i])
		for b in range(10):
			var by := 76.0 + b * 16.0 if b < up else 420.0 - (10 - b) * 16.0 + 6
			rr(x - 26, by - 7, 52, 14, cols[i], 7)
		txt(x - 60, 446, str(i + 1), 18, INK)
		_s8_arrows(x, 230)


func _scclock() -> void:
	board(SC9_WALL)
	_sc_clock_face(480, 236, 190)
	if not flag("wound"):
		c(540, 300, 10, INK)
		r(537, 300, 6, 18, INK)
		return
	ln(140, 90, 140, 130, INK, 8)
	ln(820, 70, 820, 130, INK, 4)
	_s8_arrows(140, 230)
	_s8_arrows(820, 230)


func _scmap() -> void:
	board(SC9_WALL)
	_sc_map(80, 20, 800, 220 if flag("pinned") else 440, 1.0)
	if not flag("pinned"):
		return
	for i in range(3):
		var x := 300.0 + i * 180.0
		c(x, 330, 16, [Color("d04040"), Color("3a60d0"), Color("3a9a4a")][i])
		txt(x, 338, str(i + 1), 18, CREAM)
		_s8_arrows(x, 300)


func _sc2() -> void:
	_sc_room()
	# The bookshelf.
	r(70, 40, 230, 160, WOOD_D)
	var books: Array = st.get("books", [0, 1, 2, 3, 4])
	for i in range(5):
		r(84 + i * 42, 70, 34, 120, SC9_BOOKS[int(books[i])])
	r(70, 190, 230, 10, WOOD)
	# The coat pegs and what hangs there.
	r(320, 60, 280, 14, WOOD)
	for i in range(5):
		c(340 + i * 60, 80, 6, BRASS)
		rr(326 + i * 60, 92, 28, 12, PAPER, 2)
	if flag("hung_cap"):
		item("sccap", 340, 120, 1.4)
	if flag("hung_scarf"):
		item("scscarf", 520, 120, 1.4)
	if flag("hung_mitten"):
		item("scmitten", 580, 120, 1.4)
	# The pupils' desks.
	for i in range(5):
		var dx := 80.0 + i * 104.0
		poly([dx, 300, dx + 96, 300, dx + 90, 260, dx + 6, 260], WOOD)
		r(dx + 6, 300, 8, 70, WOOD_D)
		r(dx + 82, 300, 8, 70, WOOD_D)
		c(dx + 78, 268, 5, Color("1a1a3a") if flag("inked") else Color("5a4a3a"))
		rr(dx + 20, 240, 50, 20, PAPER, 2)
	# The door with its name plate.
	door(640, 40, 150, 330)
	rr(670, 70, 90, 24, BRASS, 3)
	txt(715, 88, "M. Keller", 13, INK)
	# Lost property.
	if not flag("got_lost"):
		r(814, 300, 80, 70, Color("8a6a3a"))
		r(830, 284, 30, 20, Color("c04040"))
		r(866, 290, 20, 14, Color("4a8a4a"))


func _scdesks() -> void:
	board(SC9_WAINSCOT)
	var seats: Array = st.get("seats", [0, 1, 2, 3, 4])
	for i in range(5):
		var dx := 70.0 + i * 170.0
		rr(dx - 10, 220, 160, 220, WOOD, 6)
		poly([dx, 200, dx + 140, 200, dx + 130, 120, dx + 10, 120], PAPER)
		ln(dx + 70, 120, dx + 70, 108, INK, 1)
		txt(dx + 70, 170, SC9_NAMES[int(seats[i])], 22, INK)
		c(dx + 110, 270, 16, Color("1a1a3a") if flag("inked") else Color("4a3a2a"))
		ring(dx + 110, 270, 16, STEEL, 3)
	if flag("seats_ok"):
		rr(590, 330, 120, 80, PAPER, 3)
		poly([590, 330, 710, 330, 650, 370], Color("d8c8a0"))
		r(680, 340, 22, 24, Color("c04040"))


func _sc_outline(i: int, x: float, y: float, s: float, col: Color) -> void:
	var shapes := [
		[-30, -20, 10, -30, 30, 0, 10, 30, -20, 20],
		[-30, 0, 0, -30, 30, 0, 0, 30],
		[-20, -30, 20, -30, 30, 30, -30, 30],
		[-30, -10, -10, -30, 30, -20, 20, 30, -20, 20],
		[-10, -30, 10, -30, 10, 30, -10, 30],
		[-30, -20, 30, -20, 20, 0, 30, 25, -30, 25, -20, 0],
		[-30, 10, -10, -30, 10, -10, 30, -30, 20, 30],
		[0, -30, 30, 20, -30, 20],
	]
	var pts := []
	var shape: Array = shapes[i % 8]
	for k in range(0, shape.size(), 2):
		pts.append_array([x + float(shape[k]) * s, y + float(shape[k + 1]) * s])
	poly(pts, col)


func _scletter() -> void:
	board(SC9_WAINSCOT)
	rr(140, 20, 680, 432, PAPER, 4)
	_s8_text(170, 70, 470, "sctext.letter", 20, INK)
	r(660, 40, 140, 160, Color("f0e8d8"))
	for k in range(14):
		c(660 + k * 10, 40, 4, SC9_WAINSCOT)
		c(660 + k * 10, 200, 4, SC9_WAINSCOT)
	_sc_outline(int(clues.get("globe", 0)), 730, 120, 1.6, Color("3a7a4a"))


func _scshelf() -> void:
	board(WOOD_D)
	var books: Array = st.get("books", [0, 1, 2, 3, 4])
	var numerals: Array = clues.get("numerals", [1, 2, 3, 4, 5])
	for i in range(5):
		var b := int(books[i])
		var bx := 180.0 + i * 125.0
		rr(bx, 70, 105, 320, SC9_BOOKS[b], 4)
		r(bx, 110, 105, 6, BRASS)
		r(bx, 340, 105, 6, BRASS)
		txt(bx + 52, 240, SC9_ROMAN[int(numerals[b]) - 1], 34, BRASS)
	r(150, 390, 660, 20, WOOD)


func _scpegs() -> void:
	board(SC9_WALL)
	r(80, 70, 800, 24, WOOD)
	for i in range(5):
		var px := 165.0 + i * 160.0
		c(px, 110, 12, BRASS)
		rr(px - 50, 130, 100, 34, PAPER, 3)
		txt(px, 154, SC9_NAMES[i], 20, INK)
	var hung := {"hung_cap": ["sccap", 0], "hung_scarf": ["scscarf", 3], "hung_mitten": ["scmitten", 4]}
	for f in hung:
		if flag(f):
			item(hung[f][0], 165.0 + int(hung[f][1]) * 160.0, 250, 4.0)


func _sctasks() -> void:
	board(SC9_WALL)
	rr(140, 14, 680, 444, PAPER, 4)
	var tasks: Array = clues.get("tasks", [])
	ci.draw_string(font, Vector2(170, 44), tr("sctext.tasks"), HORIZONTAL_ALIGNMENT_LEFT, 620, 20, INK)
	for i in range(tasks.size()):
		var y := 72.0 + i * 25.5
		ci.draw_string(font, Vector2(210, y), tr("sctask.%d" % (i + 1)), HORIZONTAL_ALIGNMENT_LEFT, 580, 16, INK)
		rr(170, y - 15, 18, 18, Color(0, 0, 0, 0), 2)
		ring(179, y - 6, 9, Color(INK, 0.5), 1.5)
		var done := true
		for part in str(tasks[i]).split("&"):
			if not flag(part):
				done = false
		if done:
			ln(172, y - 6, 179, y, Color("2a6a2a"), 3)
			ln(179, y, 192, y - 18, Color("2a6a2a"), 3)


func _sc3() -> void:
	_sc_room()
	# The class photo in its frame.
	rr(64, 40, 160, 140, WOOD_D, 4)
	_sc_tiles(76, 52, 136.0 / 3.0, st.get("tiles", []))
	# The task list.
	rr(254, 44, 142, 132, PAPER, 2)
	for k in range(8):
		ln(266, 60 + k * 14, 380, 60 + k * 14, Color(INK, 0.4), 1)
	c(325, 46, 4, HM9_RED)
	# The teacher's desk, register and drawer.
	r(230, 210, 200, 14, WOOD)
	rr(250, 196, 110, 18, Color("2a4a6a"), 2)
	r(240, 224, 180, 146, WOOD_D)
	rr(250, 320, 160, 46, WOOD, 3)
	c(330, 343, 5, BRASS)
	# The harmonium with its song sheet.
	rr(450, 200, 180, 170, Color("5a3a2a"), 6)
	for k in range(8):
		r(462 + k * 20, 260, 16, 30, SC9_KEYS[k].lightened(0.3))
	rr(490, 170, 100, 40, PAPER, 2)
	# The globe.
	ln(715, 370, 715, 300, WOOD_D, 6)
	r(690, 364, 50, 8, WOOD_D)
	c(715, 250, 46, Color("4a8ac0"))
	_sc_outline(int(st.get("globe", [0])[0]), 715, 250, 0.7, Color("6aa04a"))
	ci.draw_arc(Vector2(715, 250), 52, -1.2, 2.0, 12, BRASS, 3, true)
	# The bell rope.
	ln(845, 0, 845, 330, Color("c8b898"), 5)
	rr(830, 320, 30, 40, Color("c04040"), 6)
	rr(810, 60, 70, 60, PAPER, 2)


func _sc_tiles(x: float, y: float, cell: float, tiles: Array) -> void:
	for i in range(9):
		var n := int(tiles[i]) if i < tiles.size() else i + 1
		if n == 0:
			r(x + (i % 3) * cell, y + int(i / 3) * cell, cell - 2, cell - 2, Color("2a1a10"))
			continue
		_sc_cell(n, x + (i % 3) * cell, y + int(i / 3) * cell, cell - 2)


## One piece of the class photo: piece n (1..8) belongs at cell n-1.
func _sc_cell(n: int, x: float, y: float, s: float) -> void:
	var row := int((n - 1) / 3)
	var bg: Color = [Color("d8c098"), Color("c8a878"), Color("a88a60")][row]
	r(x, y, s, s, bg)
	if row == 0:
		r(x, y + s * 0.7, s, s * 0.3, Color("8a6a4a"))
	var hx := x + s * 0.5
	var hy := y + s * 0.42
	rr(x + s * 0.25, y + s * 0.62, s * 0.5, s * 0.38, SC9_SHIRT[n - 1], s * 0.1)
	c(hx, hy, s * 0.17, Color("e8c8a0"))
	ci.draw_arc(Vector2(hx, hy - s * 0.02), s * 0.18, PI, TAU, 10, SC9_HAIR[n - 1], s * 0.1, true)
	c(hx - s * 0.06, hy, s * 0.025, INK)
	c(hx + s * 0.06, hy, s * 0.025, INK)


func _scregister() -> void:
	board(Color("2a4a6a"))
	rr(80, 20, 800, 440, PAPER, 6)
	ln(480, 20, 480, 460, Color(INK, 0.3), 3)
	_s8_text(110, 56, 340, "sctext.seating", 18, INK)
	var seats: Array = clues.get("seats", [0, 1, 2, 3, 4])
	for i in range(5):
		var dx := 100.0 + i * 74.0
		rr(dx, 300, 66, 40, Color("c8a878"), 4)
		txt(dx + 33, 326, SC9_NAMES[int(seats[i])], 15, INK)
	rr(180, 400, 200, 30, Color("8a6a4a"), 4)
	_s8_text(510, 56, 340, "sctext.diary", 18, INK)
	var route: Array = clues.get("route", [0, 0, 0])
	for k in range(3):
		_sc_town(int(route[k]), 560 + k * 120, 320, 3.0)
		if k < 2:
			poly([620 + k * 120, 312, 636 + k * 120, 320, 620 + k * 120, 328], INK)


func _scharmonium() -> void:
	board(Color("5a3a2a"))
	rr(250, 20, 460, 200, PAPER, 4)
	var song: Array = clues.get("song", [])
	for v in range(5):
		ln(270, 70 + v * 26, 690, 70 + v * 26, Color(INK, 0.5), 2)
	for k in range(song.size()):
		var n := int(song[k])
		var nx := 300.0 + k * 56.0
		var ny := 174.0 - n * 13.0
		c(nx, ny, 12, SC9_KEYS[n])
		ln(nx + 11, ny, nx + 11, ny - 44, INK, 3)
	for i in range(8):
		rr(120 + i * 92.0, 260, 86, 190, CREAM, 4)
		c(163 + i * 92.0, 420, 14, SC9_KEYS[i])


func _scglobe() -> void:
	board(SC9_WALL)
	ln(340, 440, 340, 430, WOOD_D, 8)
	r(260, 430, 160, 20, WOOD_D)
	c(340, 230, 190, Color("4a8ac0"))
	_sc_outline(int(st.get("globe", [0])[0]), 340, 230, 3.0, Color("6aa04a"))
	ci.draw_arc(Vector2(340, 230), 205, -1.2, 2.0, 24, BRASS, 8, true)
	_s8_arrows(760, 230)


func _scbell() -> void:
	board(SC9_WALL)
	rr(180, 20, 600, 210, PAPER, 4)
	poly([220, 160, 300, 160, 290, 70, 230, 70], BRASS)
	c(260, 72, 30, BRASS)
	var peal: Array = clues.get("peal", [])
	for k in range(peal.size()):
		var long_pull := int(peal[k]) == 1
		r(340 + k * 84, 110, 70 if long_pull else 26, 22, INK)
	var rung := int(st.get("rung", [0])[0])
	for k in range(peal.size()):
		c(370 + k * 84, 180, 8, BRASS if k < rung or flag("bell_ok") else Color(INK, 0.2))
	rr(180, 260, 260, 170, Color(0, 0, 0, 0.35), 10)
	rr(520, 260, 260, 170, Color(0, 0, 0, 0.35), 10)
	r(296, 300, 26, 22, CREAM)
	r(616, 300, 70, 22, CREAM)
	ln(310, 340, 310, 380, CREAM, 6)
	poly([296, 380, 324, 380, 310, 400], CREAM)
	ln(650, 340, 650, 400, CREAM, 6)
	poly([636, 400, 664, 400, 650, 420], CREAM)


func _scphoto() -> void:
	board(SC9_WALL)
	rr(286, 46, 388, 388, WOOD_D, 6)
	_sc_tiles(300, 60, 120.0, st.get("tiles", []))
	# The photographer's proof, pinned beside it.
	rr(730, 120, 160, 160, CREAM, 3)
	for n in range(1, 9):
		_sc_cell(n, 740 + ((n - 1) % 3) * 46.0, 130 + int((n - 1) / 3) * 46.0, 45.0)
	r(832, 222, 45, 45, Color("a88a60"))
	c(810, 124, 5, HM9_RED)


func _sc4() -> void:
	_sc_room()
	# The cupboard.
	rr(64, 40, 170, 330, WOOD, 4)
	if flag("cupboard_open"):
		r(74, 50, 150, 310, Color("3a2a1a"))
		for k in range(3):
			r(74, 140 + k * 90, 150, 8, WOOD_D)
		if not flag("got_cupboard"):
			item("scsponge", 110, 125, 1.6)
			item("scink", 180, 125, 1.6)
			item("sccarrot", 120, 215, 1.6)
			item("scpencils", 180, 215, 1.4)
	else:
		ln(149, 50, 149, 360, WOOD_D, 3)
		c(162, 200, 5, BRASS)
	# The window: the pump, the church, the sky.
	r(260, 40, 240, 160, Color("a8d0e8"))
	r(260, 150, 240, 50, Color("8ab060"))
	r(440, 80, 20, 70, Color("8a8a8a"))
	c(450, 88, 7, CREAM)
	r(300, 120, 12, 60, IRON)
	ln(260, 120, 500, 120, WOOD, 6)
	ln(380, 40, 380, 200, WOOD, 6)
	rr(254, 34, 252, 172, Color(0, 0, 0, 0), 2)
	r(250, 196, 260, 10, WOOD)
	if flag("lit"):
		for k in range(4):
			c(480 + 10 * sin(t + k), 70 - fmod(t * 10.0 + k * 10.0, 40.0), 8, Color(0.8, 0.8, 0.8, 0.5))
	# The flower pot (the key under it).
	poly([280, 280, 350, 280, 342, 236, 288, 236], AV9_TERRA)
	for k in range(3):
		ln(315, 236, 300 + k * 15, 206 - (10 if flag("watered") else 0), AV9_LEAF_D if flag("watered") else Color("9a8a4a"), 3)
	if not flag("got_can"):
		item("sccan", 425, 335, 2.0)
	# The rabbit hutch.
	r(520, 230, 200, 140, WOOD)
	r(530, 240, 120, 110, Color("3a2a1a"))
	for k in range(7):
		ln(530 + k * 20, 240, 530 + k * 20, 350, STEEL, 1)
	r(660, 300, 50, 60, Color("d8b860"))
	c(590 + (0 if flag("fed_rabbit") else 60), 320, 18, Color("e8e0d8"))
	ln(584 + (0 if flag("fed_rabbit") else 60), 304, 580 + (0 if flag("fed_rabbit") else 60), 280, Color("e8e0d8"), 6)
	# The stove.
	rr(750, 120, 130, 250, Color("e8e0d0"), 8)
	for k in range(5):
		ln(750, 160 + k * 40, 880, 160 + k * 40, Color("c8c0b0"), 2)
	r(790, 260, 50, 40, Color("1a1a1a"))
	if flag("lit"):
		c(815, 285, 14 + 3 * sin(t * 8.0), FIRE)
	r(808, 40, 16, 80, IRON)


func _scwindow() -> void:
	r(0, 0, 960, 472, Color("a8d0e8"))
	r(0, 300, 960, 172, Color("8ab060"))
	# The church, its clock.
	r(700, 60, 120, 240, Color("d8d0c0"))
	poly([690, 60, 760, 0, 830, 60], Color("8a4a3a"))
	var clock: Array = clues.get("clock", [3, 9])
	c(760, 110, 30, CREAM)
	var ha := (int(clock[0]) + int(clock[1]) / 12.0) * TAU / 12.0 - PI / 2
	var ma := int(clock[1]) * TAU / 12.0 - PI / 2
	ln(760, 110, 760 + cos(ha) * 16, 110 + sin(ha) * 16, INK, 4)
	ln(760, 110, 760 + cos(ma) * 25, 110 + sin(ma) * 25, INK, 2)
	# The pump.
	r(170, 220, 30, 200, IRON)
	ln(185, 230, 280, 200 + 10 * sin(t), IRON, 8)
	r(200, 260, 40, 10, IRON)
	poly([130, 440, 230, 440, 220, 390, 140, 390], Color("8a6a3a"))
	if flag("lit"):
		_sc_janitor(470, 300, 1.4)
	ln(0, 236, 960, 236, WOOD, 14)
	ln(480, 0, 480, 472, WOOD, 14)


func _schutch() -> void:
	board(SC9_WAINSCOT)
	r(100, 60, 480, 360, WOOD)
	r(120, 80, 440, 320, Color("3a2a1a"))
	for k in range(12):
		ln(120 + k * 40, 80, 120 + k * 40, 400, STEEL, 2)
	var fed := flag("fed_rabbit")
	var rx := 260.0 if fed else 720.0
	ci.draw_set_transform(Vector2(rx, 340), 0.0, Vector2(1.3, 1.0))
	c(0, 0, 44, Color("e8e0d8"))
	home()
	c(rx + 40, 300, 26, Color("e8e0d8"))
	ln(rx + 34, 280, rx + 26, 210, Color("e8e0d8"), 12)
	ln(rx + 50, 280, rx + 56, 210, Color("e8e0d8"), 12)
	c(rx + 50, 296, 4, INK)
	if fed:
		item("sccarrot", rx + 80, 320, 2.0)
	for k in range(20):
		ln(620 + fmod(k * 37.0, 260.0), 430, 640 + fmod(k * 53.0, 240.0), 300 + fmod(k * 13.0, 40.0), Color("d8b860"), 3)
	if fed and not flag("got_pin"):
		c(760, 400, 3 + sin(t * 5.0), Color("3a9a4a"))


func _scstove() -> void:
	board(SC9_WALL)
	rr(100, 40, 460, 400, Color("e8e0d0"), 16)
	for k in range(8):
		ln(100, 80 + k * 45, 560, 80 + k * 45, Color("c8c0b0"), 3)
	r(240, 260, 180, 130, Color("1a1a1a"))
	if flag("lit"):
		for k in range(5):
			poly([260 + k * 32, 390, 290 + k * 32, 390, 276 + k * 32, 300 - 30 * sin(t * 6.0 + k)], FIRE)
	# The flue and its damper handle.
	r(600, 0, 60, 472, IRON)
	var d := int(st.get("damper", [0])[0])
	var a := d * PI / 4.0
	ln(630 - cos(a) * 40, 200 - sin(a) * 40, 630 + cos(a) * 80, 200 + sin(a) * 80, BRASS, 10)
	c(630, 200, 10, BRASS_D)
	_s8_arrows(780, 230)
