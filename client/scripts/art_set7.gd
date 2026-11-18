## Draws the seventh set on top of ArtHouse: The Night Edition (O1, O2),
## The Great Vaudini (F1, F2) and Rain on Gale Street (I1, I2), with their
## close-ups. Hotspots are in views_set7.gd.
class_name ArtSet7
extends ArtHouse

const PR_WALL := Color("2e2620")
const PR_WALL_D := Color("221c17")
const PR_FLOOR := Color("3a2e24")
const PR_IRON := Color("2a2c30")
const PR_IRON_HI := Color("4a4e56")
const F_VELVET := Color("6e1220")
const F_VELVET_D := Color("520c18")
const F_GOLD := Color("d4aa50")
const F_GOLD_D := Color("9a7a30")
const F_WINGS := Color("2a1e18")
const I_WALL := Color("3a3a3e")
const I_WALL_D := Color("2c2c30")
const I_FLOOR := Color("26262a")
const I_GREY := Color("8a8a90")
const I_LIGHT := Color("c8c8cc")
const I_NEON := Color("ff3048")
const I_BLUE := Color("2a4a9a")
## The ink keys' greys, lightest first.
const GREYS := [Color("e8e4da"), Color("b8b4aa"), Color("8a867e"), Color("5a5650"), Color("2a2824")]
const PANEL_SIGNS := ["crown", "moon", "star", "sun", "key", "eye"]


func draw_view(view: String) -> void:
	match view:
		"O1": _o1()
		"O2": _o2()
		"dbin": _dbin()
		"dcards": _dcards()
		"dlog": _s7_page("dtext.log", Color("6a5040"), 22)
		"dnotebook": _s7_page("dtext.notebook", Color("3a3028"), 26)
		"drules": _drules()
		"dmonday": _s7_paper_day("monday", MONDAY_KEYS)
		"dlocker": _dlocker()
		"dstick": _dstick()
		"dreels": _dreels()
		"dchart": _dchart()
		"dweb": _dweb()
		"dfount": _dfount()
		"dpress": _dpress()
		"ddesk": _ddesk()
		"F1": _f1()
		"F2": _f2()
		"frack": _frack()
		"ftrunk": _ftrunk()
		"fscript": _s7_page("vtext.script", Color("4a1a1a"), 21)
		"fletter": _s7_page("vtext.letter", Color("4a1a1a"), 22)
		"fposter": _fposter()
		"fmirror": _fmirror()
		"ftable": _ftable()
		"fcabinet": _fcabinet()
		"fswitch": _fswitch()
		"fglass": _fglass()
		"fbox": _fbox()
		"fdoor": _fdoor()
		"I1": _i1()
		"I2": _i2()
		"ibin": _ibin()
		"idesk": _idesk()
		"iread": _iread()
		"iblinds": _iblinds()
		"icabinet": _icabinet()
		"itype": _itype()
		"iboard": _iboard()
		"isafe": _isafe()
		"icoats": _icoats()
		"iradio": _iradio()
		"iglass": _iglass()
		"itimetable": _itimetable()
		"idoor": _idoor()
		_:
			super.draw_view(view)
			return
	home()


const MONDAY_KEYS := ["dtext.ad1", "dtext.ad_monday", "dtext.ad2", "dtext.ad3"]
const TUESDAY_KEYS := ["dtext.ad4", "dtext.ad5", "dtext.ad_tuesday", "dtext.ad6"]


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"dforme":
			at(x, y, 0.0, s)
			r(-16, -12, 32, 24, PR_IRON_HI)
			r(-12, -8, 24, 16, Color("8a8070"))
			for k in range(3):
				ln(-10, -4 + k * 5, 10, -4 + k * 5, PR_IRON, 2)
		"dlantern":
			at(x, y, 0.0, s)
			r(-8, -10, 16, 20, Color(AMBER, 0.85))
			ring(0, -14, 5, IRON, 2)
			r(-10, -12, 20, 3, IRON)
			r(-10, 9, 20, 3, IRON)
		"dpresskey", "vkey", "vpadkey", "idoorkey":
			super.item("key", x, y, s)
			return
		"vdeck":
			at(x, y, 0.0, s)
			rr(-10, -14, 20, 28, Color("8a1a2a"), 3)
			rr(-7, -11, 14, 22, F_GOLD_D, 2)
		"icarbon":
			at(x, y, 0.0, s)
			r(-12, -14, 24, 28, Color("1a1a3a"))
			ln(-8, -6, 8, -6, Color("4a4a7a"), 2)
		"iribbon":
			at(x, y, 0.0, s)
			ring(-6, 0, 7, Color("1a1a1a"), 4)
			ring(8, 0, 7, Color("1a1a1a"), 4)
			ln(-6, -7, 8, -7, Color("aa2222"), 3)
		"iopener":
			at(x, y, -0.6, s)
			poly([-2, -16, 2, -16, 1, 8, -1, 8], I_LIGHT)
			r(-3, 8, 6, 10, Color("6a4a2a"))
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"press":
			r(0, 0, w, h, PR_WALL)
			c(w * 0.5, h * 0.1, h * 0.5, Color(AMBER, 0.14 + 0.06 * sin(t * 7.0) * sin(t * 3.0)))
			var feed := fmod(t * 0.5, 1.0)
			rr(w * 0.22, h * 0.25, w * 0.56, h * 0.6, PAPER, 2)
			for k in range(int(feed * 6.0)):
				r(w * 0.28, h * (0.35 + k * 0.1), w * 0.44, 2, INK)
			if feed > 0.5:
				ring(w * 0.55, h * 0.5, h * 0.09, RED, 2)
			r(w * 0.18, h * 0.85, w * 0.64, h * 0.06, PR_IRON_HI)
			c(w * 0.5 + w * 0.2 * cos(t * 6.0), h * 0.88, 2, Color(1, 1, 1, 0.5))
		"magic":
			r(0, 0, w, h, F_VELVET)
			for k in range(8):
				r(k * w / 8.0, 0, w / 16.0, h, F_VELVET_D)
			rr(w * 0.3, h * 0.15, w * 0.4, h * 0.7, Color("1e140e"), 3)
			for k in range(5):
				c(w * (0.34 + k * 0.08), h * 0.18, 3, AMBER if int(t * 5.0) % 5 != k else Color("fff8e0"))
			ci.draw_set_transform(Vector2(w * 0.5, h * (0.5 - 0.08 * absf(sin(t * 1.5)))), 0.0, Vector2(maxf(0.08, absf(cos(t * 3.0))), 1.0))
			c(0, 0, h * 0.14, F_GOLD)
			c(0, 0, h * 0.1, F_GOLD_D)
			home()
		"noir":
			r(0, 0, w, h, Color("222226"))
			for k in range(7):
				r(w * 0.45, h * (0.1 + k * 0.11), w * 0.45, h * 0.05, I_GREY)
			var on := 0.35 if fmod(t, 3.4) < 2.9 or fmod(t * 9.0, 2.0) < 1.0 else 0.08
			c(w * 0.68, h * 0.45, h * 0.25, Color(I_NEON, on))
			for k in range(8):
				var rx := w * 0.45 + fmod(k * 13.0, w * 0.45)
				var ry := fmod(k * 23.0 + t * (30.0 + k * 3), h)
				ln(rx, ry, rx, ry + 6, Color(0.8, 0.85, 1.0, 0.5), 1)
			r(w * 0.08, h * 0.7, w * 0.5, h * 0.08, Color("111114"))
		_:
			super.card(room, w, h)


# --- Shared pieces ---------------------------------------------------------------

func _s7_text(x: float, y: float, width: float, key: String, size: int, col: Color) -> void:
	ci.draw_multiline_string(font, Vector2(x, y), tr(key), HORIZONTAL_ALIGNMENT_LEFT, width, size, -1, col)


## A sheet of text on a dark ground (a log, a script, a letter).
func _s7_page(key: String, ground: Color, size: int) -> void:
	board(ground)
	rr(150, 20, 660, 432, PAPER, 4)
	_s7_text(180, 60, 600, key, size, INK)


func _s7_mirrored(x: float, y: float, text: String, size: int, col: Color) -> void:
	ci.draw_set_transform(Vector2(x, y), 0.0, Vector2(-1, 1))
	ci.draw_string(font, Vector2.ZERO, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, col)
	home()


func _s7_clock(x: float, y: float, rad: float, hour: float, col: Color) -> void:
	c(x, y, rad, CREAM)
	ring(x, y, rad, col, 2)
	var a := hour / 12.0 * TAU - PI / 2
	ln(x, y, x + cos(a) * rad * 0.55, y + sin(a) * rad * 0.55, col, 3)
	ln(x, y, x, y - rad * 0.8, col, 2)


func _s7_hhmm(minutes: int) -> String:
	return "%02d:%02d" % [minutes / 60, minutes % 60]


func _s7_crown(x: float, y: float, s: float, points: int, col: Color) -> void:
	var pts := [x - 30 * s, y + 14 * s]
	for k in range(points * 2 + 1):
		var px := x - 30 * s + k * 60.0 * s / (points * 2)
		pts.append_array([px, y - (22 if k % 2 == 1 else 0) * s])
	pts.append_array([x + 30 * s, y + 14 * s])
	poly(pts, col)


func _s7_anchor(x: float, y: float, s: float, col: Color) -> void:
	ring(x, y - 22 * s, 6 * s, col, 3 * s)
	ln(x, y - 16 * s, x, y + 20 * s, col, 4 * s)
	ln(x - 16 * s, y - 6 * s, x + 16 * s, y - 6 * s, col, 4 * s)
	ci.draw_arc(Vector2(x, y + 2 * s), 18 * s, 0.2, PI - 0.2, 12, col, 4 * s, true)


# --- The Night Edition: composing room -------------------------------------------

func _o_room() -> void:
	r(0, 0, 960, 372, PR_WALL)
	for i in range(12):
		r(i * 80, 0, 3, 372, PR_WALL_D)
	r(0, 372, 960, 100, PR_FLOOR)
	r(0, 368, 960, 6, Color("1a1410"))
	# The gas lamp.
	c(480, 24, 10, AMBER)
	r(476, 0, 8, 16, BRASS_D)


func _o1() -> void:
	_o_room()
	# The type case with the composing stick on top.
	r(40, 150, 250, 220, WOOD_D)
	for row in range(4):
		for col in range(5):
			rr(50 + col * 48, 162 + row * 34, 42, 28, WOOD, 3)
			c(71 + col * 48, 176 + row * 34, 3, BRASS_D)
	r(60, 132, 200, 16, PR_IRON_HI)
	# The bin.
	poly([300, 300, 390, 300, 380, 370, 310, 370], Color("7a6a4a"))
	for k in range(4):
		ln(304 + k * 22, 302, 314 + k * 20, 368, Color("5a4a30"), 2)
	if not flag("got_letter"):
		c(345, 300, 16, PAPER)
	# Time cards.
	r(320, 60, 120, 150, WOOD)
	for k in range(5):
		r(332 + k * 21, 72, 16, 60, PAPER)
	r(328, 150, 104, 50, PR_IRON)
	txt(380, 182, _s7_hhmm(22 * 60 + 40), 18, AMBER)
	# Lockers.
	for k in range(4):
		var lx := 474 + k * 50
		r(lx, 60, 46, 310, PR_IRON_HI if k != 1 else PR_IRON)
		for v in range(3):
			r(lx + 8, 80 + v * 10, 30, 3, PR_IRON)
		c(lx + 38, 220, 4, BRASS)
	if flag("locker_open"):
		r(526, 64, 38, 302, Color("141414"))
	# House rules.
	r(700, 40, 140, 170, PAPER)
	txt(770, 70, "§", 26, INK)
	for k in range(7):
		r(714, 86 + k * 16, 112, 3, Color(INK, 0.6))
	_s7_crown(770, 196, 0.35, 5, RED)
	# Desk and notebook.
	r(690, 320, 180, 50, WOOD_D)
	rr(710, 286, 120, 40, Color("6a4a3a"), 3)
	r(714, 290, 112, 32, PAPER)
	# Monday's paper on its hook.
	ln(905, 40, 905, 56, BRASS, 3)
	r(864, 56, 82, 140, Color("ddd2b4"))
	r(870, 64, 70, 12, INK)
	for k in range(6):
		r(870, 86 + k * 16, 70, 3, Color(INK, 0.5))
	door(870, 220, 80, 150)


func _o2() -> void:
	_o_room()
	# The paper path chart, an ink splash over its middle.
	r(40, 30, 220, 130, PAPER)
	_dchart_path(60, 80, 30.0, false)
	c(150, 100, 24, Color("141210"))
	c(132, 86, 12, Color("141210"))
	# Three reels.
	for k in range(3):
		c(80 + k * 70, 300, 34, Color("e8dcc0"))
		ring(80 + k * 70, 300, 34, Color("b8ac90"), 3)
		c(80 + k * 70, 300, 8, PR_IRON)
	r(40, 340, 220, 30, PR_IRON)
	# The press: rollers above, the cylinder, the frame.
	r(290, 30, 300, 90, PR_IRON)
	for k in range(6):
		c(315 + k * 50, 75, 16, PR_IRON_HI)
	r(290, 130, 300, 240, PR_IRON_HI)
	c(440, 230, 70, PR_IRON)
	ring(440, 230, 70, Color("6a6e76"), 6)
	if flag("plate_on"):
		ci.draw_arc(Vector2(440, 230), 66, -1.2, 1.2, 16, Color("8a8070"), 10, true)
	if flag("done"):
		for k in range(4):
			r(300 + k * 70, 340, 60, 26, PAPER)
	# Ink fountain.
	r(610, 200, 110, 170, PR_IRON)
	r(618, 210, 94, 40, Color("141210"))
	for k in range(5):
		c(626 + k * 20, 270, 6, BRASS_D)
	# The watchman's shelf, log and desk.
	r(740, 196, 200, 6, WOOD_D)
	r(750, 120, 110, 76, Color("6a2a1a"))
	r(758, 128, 94, 60, Color("8a3a2a"))
	r(740, 300, 200, 70, WOOD_D)
	r(750, 260, 180, 40, WOOD)
	if not flag("got_lantern"):
		r(760, 228, 26, 32, Color(AMBER, 0.8))
	r(820, 236, 90, 22, Color("ddd2b4"))
	_s7_clock(915, 65, 30, 11.7, INK)


# --- The Night Edition: close-ups ----------------------------------------------

func _dbin() -> void:
	board(Color("2a2018"))
	poly([220, 40, 740, 40, 700, 440, 260, 440], Color("7a6a4a"))
	for k in range(10):
		ln(240 + k * 52, 44, 266 + k * 44, 436, Color("5a4a30"), 3)
	if not flag("got_letter"):
		for k in range(6):
			c(470 + cos(k) * 40, 250 + sin(k * 2.0) * 30, 46, Color(PAPER, 0.95))
		ln(440, 230, 500, 270, Color(INK, 0.4), 2)
	else:
		rr(240, 50, 480, 390, PAPER, 3)
		_s7_text(262, 86, 436, "dtext.letter", 20, INK)


func _dcards() -> void:
	board(Color("4a3a2a"))
	var cards: Array = clues.get("cards", [])
	for k in range(cards.size()):
		var x := 50 + k * 176.0
		rr(x, 40, 160, 380, PAPER, 4)
		var num: Array = cards[k][0]
		txt(x + 80, 100, "%d%d%d" % [int(num[0]), int(num[1]), int(num[2])], 40, INK)
		r(x + 12, 120, 136, 3, RED)
		txt(x + 80, 180, tr("dtext.in"), 18, Color(INK, 0.7))
		txt(x + 80, 220, _s7_hhmm(int(cards[k][1])), 30, INK)
		txt(x + 80, 290, tr("dtext.out"), 18, Color(INK, 0.7))
		var out := int(cards[k][2])
		txt(x + 80, 330, _s7_hhmm(out) if out > 0 else "—", 30, INK)


func _drules() -> void:
	board(PR_WALL)
	rr(140, 20, 680, 432, PAPER, 4)
	_s7_text(170, 60, 420, "dtext.rules", 19, INK)
	_s7_crown(700, 120, 1.3, 5, RED)
	rr(650, 250, 100, 100, GREYS[int(clues.get("grey", 2))], 2)
	ring(700, 300, 62, Color(INK, 0.3), 2)


func _s7_paper_day(day: String, keys: Array) -> void:
	board(Color("2a2018"))
	rr(80, 20, 800, 432, Color("e4dabc"), 3)
	txt(480, 70, "THE EVENING COURIER", 34, INK)
	txt(480, 100, tr("dtext." + day), 18, INK)
	r(100, 112, 760, 3, INK)
	for k in range(keys.size()):
		var x := 100 + (k % 2) * 384
		var y := 130 + (k / 2) * 158
		rr(x, y, 372, 146, Color("d8cca8"), 2)
		_s7_text(x + 12, y + 28, 348, keys[k], 17, INK)


func _dlocker() -> void:
	board(PR_IRON)
	if flag("locker_open"):
		r(80, 30, 380, 412, Color("141414"))
		if not flag("got_forme"):
			r(130, 130, 280, 230, PR_IRON_HI)
			r(146, 146, 248, 198, Color("8a8070"))
			for k in range(8):
				if k != 2:
					ln(156, 160 + k * 22, 384, 160 + k * 22, PR_IRON, 6)
			r(156, 202, 228, 10, Color("2a2420"))
		rr(500, 60, 380, 360, PAPER, 3)
		_s7_text(520, 96, 340, "dtext.manual", 18, INK)
		_dchart_part(560, 260, 70.0)
	else:
		r(260, 30, 300, 412, PR_IRON_HI)
		txt(410, 100, tr("dtext.foreman"), 22, CREAM)
		kit_wheels(st.get("locker", [0, 0, 0]), 400, 250)


func _s7_sort(x: float, y: float, d: int, s: float) -> void:
	rr(x, y, 60 * s, 76 * s, Color("8a8478"), 4)
	r(x + 4 * s, y + 4 * s, 52 * s, 8 * s, Color("6a665c"))
	# The face is a mirror image of the digit.
	var w := font.get_string_size(str(d), HORIZONTAL_ALIGNMENT_LEFT, -1, int(48 * s)).x
	_s7_mirrored(x + 30 * s + w / 2, y + 64 * s, str(d), int(48 * s), Color("2a2824"))


func _dstick() -> void:
	board(WOOD_D)
	for d in range(10):
		var rect := Set7Views.sort_rect(d)
		rr(rect.position.x, rect.position.y, rect.size.x, rect.size.y, WOOD, 4)
		_s7_sort(rect.position.x + 8, rect.position.y + 8, d, 1.0)
	rr(500, 60, 120, 70, Color("5a2a1a"), 8)
	ln(540, 80, 580, 112, CREAM, 5)
	ln(580, 80, 540, 112, CREAM, 5)
	# The proof press.
	r(660, 40, 260, 150, PR_IRON)
	r(680, 60, 220, 30, PR_IRON_HI)
	ln(880, 60, 900, 20, PR_IRON_HI, 8)
	# The stick.
	r(60, 240, 560, 100, PR_IRON_HI)
	r(70, 250, 540, 80, Color("3a3c40"))
	var stick: Array = st.get("stick", [10, 10, 10, 10, 10])
	var full := true
	for k in range(stick.size()):
		var v := int(stick[k])
		if v < 10:
			_s7_sort(90 + k * 104, 252, v, 1.0)
		else:
			full = false
	# The proof: what the line prints.
	rr(640, 230, 300, 220, PAPER, 3)
	if full:
		var printed := ""
		for k in range(stick.size() - 1, -1, -1):
			printed += str(int(stick[k]))
		txt(790, 350, printed, 52, INK)
	else:
		for k in range(4):
			r(670, 270 + k * 40, 240, 3, Color(INK, 0.15))


func _dreels() -> void:
	board(PR_WALL)
	var marks: Array = clues.get("marks", [0, 1, 2])
	var mounted := int(st.get("reel", [0])[0])
	for k in range(3):
		var x := 190 + k * 290.0
		c(x, 185, 120, Color("e8dcc0"))
		for q in range(5):
			ring(x, 185, 30 + q * 18, Color("d0c4a8"), 2)
		c(x, 185, 22, PR_IRON)
		if flag("mark%d" % k):
			c(x, 185, 110, Color(AMBER, 0.25))
			var col := Color("8a7a5a")
			match int(marks[k]):
				0: _s7_crown(x, 190, 2.2, 3, col)
				1: _s7_anchor(x, 190, 2.6, col)
				_: _s7_crown(x, 190, 2.2, 5, col)
		rr(x - 80, 350, 160, 80, F_GOLD if k == mounted else PR_IRON_HI, 8)
		txt(x, 400, tr("dtext.mount"), 20, INK if k == mounted else CREAM)


## The paper path over six rollers: a line over (1) or under (0) each.
func _dchart_path(x0: float, y: float, gap: float, hide_middle: bool) -> void:
	var web: Array = clues.get("web", [])
	var prev := Vector2(x0 - gap * 0.6, y)
	for k in range(6):
		var cx := x0 + k * gap
		ring(cx, y, gap * 0.28, INK, 2)
		if hide_middle and (k == 2 or k == 3):
			continue
		var p := Vector2(cx, y - gap * 0.36 if int(web[k]) == 1 else y + gap * 0.36)
		ln(prev.x, prev.y, p.x, p.y, RED, 3)
		prev = p


## The manual's drawing: rollers 3 and 4 only.
func _dchart_part(x0: float, y: float, gap: float) -> void:
	var web: Array = clues.get("web", [])
	for k in range(2):
		var cx := x0 + k * gap * 1.5
		ring(cx, y, gap * 0.28, INK, 3)
		txt(cx, y + gap * 0.8, str(k + 3), 22, INK)
		var py := y - gap * 0.38 if int(web[k + 2]) == 1 else y + gap * 0.38
		ln(cx - gap * 0.6, py, cx + gap * 0.6, py, RED, 4)


func _dchart() -> void:
	board(PR_WALL)
	rr(40, 20, 880, 432, PAPER, 4)
	txt(480, 70, tr("dtext.chart"), 24, INK)
	_dchart_path(180, 250, 120.0, false)
	for k in range(6):
		txt(180 + k * 120, 340, str(k + 1), 22, INK)
	# The ink splash over rollers 3 and 4.
	c(480, 240, 110, Color("141210"))
	c(400, 190, 50, Color("141210"))
	c(560, 300, 60, Color("141210"))
	c(420, 330, 26, Color("141210"))


func _dweb() -> void:
	board(PR_IRON)
	var web: Array = st.get("web", [0, 0, 0, 0, 0, 0])
	var prev := Vector2(20, 240)
	for k in range(6):
		var cx := 125 + k * 145.0
		c(cx, 240, 46, PR_IRON_HI)
		ring(cx, 240, 46, Color("6a6e76"), 4)
		txt(cx, 340, str(k + 1), 22, CREAM)
	if flag("reel_ok") and flag("locker_open"):
		for k in range(6):
			var cx := 125 + k * 145.0
			var p := Vector2(cx, 186 if int(web[k]) == 1 else 294)
			ln(prev.x, prev.y, p.x, p.y, PAPER, 8)
			prev = p
		ln(prev.x, prev.y, 940, 240, PAPER, 8)
		if flag("web_ok"):
			ln(456, 410, 474, 428, F_GOLD, 6)
			ln(474, 428, 508, 392, F_GOLD, 6)


func _dfount() -> void:
	board(PR_IRON)
	var ink: Array = st.get("ink", [0, 0, 0, 0, 0])
	rr(180, 30, 600, 150, PAPER if flag("web_ok") else Color("4a4a4a"), 3)
	if flag("web_ok"):
		for k in range(5):
			r(200 + k * 116, 50, 100, 110, GREYS[clampi(int(ink[k]), 0, 4)])
	kit_wheels(ink, 240, 300, [], 120)


func _dpress() -> void:
	board(PR_IRON)
	c(340, 190, 150, PR_IRON_HI)
	ring(340, 190, 150, Color("6a6e76"), 10)
	if flag("plate_on"):
		ci.draw_arc(Vector2(340, 190), 140, -1.0, 1.0, 24, Color("8a8070"), 30, true)
	r(620, 160, 220, 180, Color("1e2024"))
	c(730, 230, 26, PR_IRON_HI)
	r(724, 220, 12, 24, Color("0a0a0a"))
	if flag("done"):
		item("dpresskey", 730, 232, 2.0)


func _ddesk() -> void:
	board(WOOD_D)
	if not flag("got_lantern"):
		item("dlantern", 115, 260, 4.0)
		home()
	rr(210, 30, 360, 410, Color("e4dabc"), 3)
	txt(390, 66, "THE EVENING COURIER", 20, INK)
	txt(390, 90, tr("dtext.tuesday"), 15, INK)
	for k in range(TUESDAY_KEYS.size()):
		_s7_text(226, 124 + k * 80, 328, TUESDAY_KEYS[k], 15, INK)
	r(600, 150, 340, 300, WOOD)
	if flag("drawer_open"):
		r(620, 240, 300, 160, Color("1a120c"))
		if not flag("got_key"):
			item("dpresskey", 770, 320, 3.0)
			home()
	else:
		kit_wheels(st.get("drawer", [0, 0, 0, 0]), 650, 270)


# --- The Great Vaudini ---------------------------------------------------------

func _f_velvet() -> void:
	r(0, 0, 960, 372, F_VELVET)
	for i in range(0, 960, 40):
		r(i, 0, 18, 372, F_VELVET_D)
	r(0, 372, 960, 100, Color("3a1a10"))
	r(0, 368, 960, 6, F_GOLD_D)


func _s7_bulbs(x: float, y: float, w: float, h: float, on: bool) -> void:
	var col := Color("fff0c0") if on else Color("6a5a40")
	for k in range(7):
		c(x + k * w / 6.0, y, 7, col)
		c(x + k * w / 6.0, y + h, 7, col)
	for k in range(1, 4):
		c(x, y + k * h / 4.0, 7, col)
		c(x + w, y + k * h / 4.0, 7, col)


## The dressing mirror: a reflection, dark glass, or the alcove behind it.
func _s7_mirror(x: float, y: float, w: float, h: float) -> void:
	var bulbs := int(st.get("bulbs", [1])[0]) == 1
	var lamp := int(st.get("lamp", [0])[0]) == 1
	r(x, y, w, h, F_GOLD_D)
	if not bulbs and lamp:
		r(x + 8, y + 8, w - 16, h - 16, Color("6a5a40"))
		_s7_sketch(x + w / 2, y + h / 2, minf(w, h) / 300.0)
	elif bulbs:
		r(x + 8, y + 8, w - 16, h - 16, Color("8a8a96"))
		c(x + w / 2, y + h * 0.45, h * 0.16, Color("5a5a66"))
		r(x + w / 2 - h * 0.22, y + h * 0.6, h * 0.44, h * 0.4 - 8, Color("5a5a66"))
	else:
		r(x + 8, y + 8, w - 16, h - 16, Color("1a1a20"))
	_s7_bulbs(x, y, w, h, bulbs)


## The stagehands' sketch of the sawing box (three parts shifted).
func _s7_sketch(x: float, y: float, s: float) -> void:
	var saw: Array = clues.get("saw", [0, 0, 0])
	y -= 30 * s
	rr(x - 130 * s, y - 80 * s, 260 * s, 220 * s, PAPER, 3)
	for k in range(3):
		var off := int(saw[k]) * 14.0 * s
		r(x - 100 * s + k * 70 * s, y - 50 * s + off, 60 * s, 70 * s, Color(INK, 0.0))
		ring(x - 70 * s + k * 70 * s, y - 15 * s + off, 3 * s, INK, 2)
		ln(x - 100 * s + k * 70 * s, y - 50 * s + off, x - 40 * s + k * 70 * s, y - 50 * s + off, INK, 3)
		ln(x - 100 * s + k * 70 * s, y + 20 * s + off, x - 40 * s + k * 70 * s, y + 20 * s + off, INK, 3)
		ln(x - 100 * s + k * 70 * s, y - 50 * s + off, x - 100 * s + k * 70 * s, y + 20 * s + off, INK, 3)
		ln(x - 40 * s + k * 70 * s, y - 50 * s + off, x - 40 * s + k * 70 * s, y + 20 * s + off, INK, 3)
		txt(x - 70 * s + k * 70 * s, y + 60 * s + off, "%d" % int(saw[k]), int(20 * s) + 6, RED)


func _s7_sign(name: String, x: float, y: float, s: float, col: Color) -> void:
	match name:
		"crown": _s7_crown(x, y + 6 * s, s, 3, col)
		"moon":
			c(x, y, 26 * s, col)
			c(x + 12 * s, y - 6 * s, 22 * s, F_VELVET_D)
		"star":
			var pts := []
			for k in range(10):
				var a := k * TAU / 10 - PI / 2
				var rad := 28.0 * s if k % 2 == 0 else 12.0 * s
				pts.append_array([x + cos(a) * rad, y + sin(a) * rad])
			poly(pts, col)
		"sun":
			c(x, y, 16 * s, col)
			for k in range(8):
				var a := k * TAU / 8
				ln(x + cos(a) * 20 * s, y + sin(a) * 20 * s, x + cos(a) * 30 * s, y + sin(a) * 30 * s, col, 3 * s)
		"key":
			ring(x - 14 * s, y, 9 * s, col, 4 * s)
			ln(x - 5 * s, y, x + 26 * s, y, col, 5 * s)
			ln(x + 18 * s, y, x + 18 * s, y + 10 * s, col, 4 * s)
		_:
			poly([x - 30 * s, y, x, y - 16 * s, x + 30 * s, y, x, y + 16 * s], col)
			c(x, y, 9 * s, F_VELVET_D)


func _f1() -> void:
	_f_velvet()
	# Poster.
	r(60, 20, 160, 110, Color("e8d8a8"))
	txt(140, 46, "VAUDINI", 22, F_VELVET)
	_s7_clock(140, 92, 26, 1.0, INK)
	# The costume rack.
	r(40, 146, 230, 6, BRASS_D)
	var cols := [Color("1a1a2a"), Color("6a1a6a"), Color("1a4a3a"), Color("2a2a2a")]
	for k in range(4):
		poly([60 + k * 55, 152, 100 + k * 55, 152, 110 + k * 55, 360, 50 + k * 55, 360], cols[k])
	r(36, 146, 8, 224, BRASS_D)
	r(266, 146, 8, 224, BRASS_D)
	# Dressing table and its mirror.
	_s7_mirror(340, 50, 240, 180)
	r(320, 250, 300, 30, WOOD)
	r(330, 280, 280, 90, WOOD_D)
	if flag("spread"):
		for k in range(8):
			rr(340 + k * 34, 254, 26, 20, Color("8a1a2a"), 2)
	rr(606, 150, 56, 70, BRASS_D, 6)
	r(626, 162 if int(st.get("bulbs", [1])[0]) == 1 else 188, 16, 22, CREAM)
	# The Cabinet of Wonders.
	r(700, 40, 170, 210, Color("2a1410"))
	for i in range(6):
		_s7_sign(PANEL_SIGNS[i], 728 + (i % 3) * 57, 90 + (i / 3) * 90, 0.55, F_GOLD)
	# The trunk.
	rr(680, 270, 250, 100, Color("5a3a1e"), 8)
	r(680, 300, 250, 8, BRASS_D)
	c(805, 330, 10, BRASS if not flag("trunk_open") else Color("2a1a0a"))


func _f2() -> void:
	r(0, 0, 960, 372, F_WINGS)
	for i in range(6):
		ln(40 + i * 170, 0, 40 + i * 170, 372, Color("4a3a28"), 3)
	r(0, 372, 960, 100, Color("1e1610"))
	# The alcove lamp's switch box.
	r(60, 80, 130, 150, Color("3a3a3a"))
	var lamp := int(st.get("lamp", [0])[0]) == 1
	r(115, 110 if lamp else 170, 20, 40, F_GOLD)
	c(125, 96, 7, AMBER if lamp else Color("4a4a4a"))
	# The sawing box.
	var saw: Array = st.get("saw", [0, 0, 0])
	for k in range(3):
		rr(40 + k * 78, 270 + int(saw[k]) * 6, 72, 80, Color("8a2a6a") if k != 1 else Color("2a6a8a"), 4)
	r(30, 360, 250, 10, F_GOLD_D)
	# The glass and the painted backdrop behind it.
	r(310, 40, 360, 300, Color("2a3a5a"))
	for k in range(3):
		r(350 + k * 110, 140, 70, 90, Color("141c2e"))
	poly([310, 40, 340, 40, 670, 340, 640, 340], Color(1, 1, 1, 0.12))
	if lamp:
		_s7_ghost(350, 140, 110.0, 0.6)
	# Bell and the chained stage door.
	c(715, 70, 18, F_GOLD)
	r(712, 40, 6, 14, F_GOLD_D)
	door(750, 40, 180, 330)
	if not flag("done"):
		for k in range(7):
			ring(780 + k * 22, 200 + sin(k) * 6, 9, STEEL, 4)


## The ghost: the alcove's digit board reflected into the backdrop's three
## windows, as the glass's tilt places it.
func _s7_ghost(x0: float, y: float, gap: float, alpha: float) -> void:
	var ghost: Array = clues.get("ghost", [])
	var tilt := int(st.get("tilt", [0])[0])
	if tilt >= ghost.size():
		return
	var row: Array = ghost[tilt]
	for k in range(3):
		txt(x0 + 35 + k * gap, y + 66, str(int(row[k])), 54, Color(0.85, 0.95, 1.0, alpha))


func _frack() -> void:
	board(F_VELVET_D)
	r(60, 40, 840, 10, BRASS_D)
	var cols := [Color("1a1a2a"), Color("6a1a6a"), Color("1a4a3a"), Color("101010")]
	for k in range(4):
		var x := 110 + k * 200.0
		ln(x + 70, 50, x + 70, 80, BRASS, 3)
		poly([x + 20, 80, x + 120, 80, x + 160, 440, x - 20, 440], cols[k])
	# The cape's lining: a small lump.
	poly([520, 100, 660, 100, 680, 440, 500, 440], Color("8a1a1a"))
	if not flag("got_vkey"):
		c(590, 300, 12, Color("7a1616"))
		ln(582, 296, 598, 304, Color("6a1212"), 2)


func _ftrunk() -> void:
	board(Color("2a1810"))
	if flag("trunk_open"):
		rr(80, 40, 800, 400, Color("5a3a1e"), 10)
		r(100, 60, 760, 360, Color("3a1a10"))
		rr(110, 60, 340, 360, PAPER, 3)
		txt(280, 110, tr("vtext.script_title"), 22, INK)
		for k in range(9):
			r(140, 140 + k * 28, 280, 3, Color(INK, 0.4))
		rr(510, 60, 340, 360, Color("f0e4d0"), 3)
		txt(680, 110, tr("vtext.letter_title"), 22, INK)
		for k in range(9):
			r(540, 140 + k * 28, 280, 3, Color(INK, 0.4))
	else:
		rr(120, 80, 720, 320, Color("5a3a1e"), 14)
		r(120, 170, 720, 14, BRASS_D)
		rr(440, 220, 80, 70, BRASS, 6)
		c(480, 255, 10, Color("2a1a0a"))


func _fposter() -> void:
	board(F_VELVET)
	rr(200, 20, 560, 432, Color("e8d8a8"), 4)
	txt(480, 80, "THE GREAT VAUDINI", 40, F_VELVET)
	txt(480, 116, tr("vtext.poster"), 18, INK)
	_s7_clock(480, 250, 90, 1.0, INK)
	for k in range(12):
		var a := k / 12.0 * TAU
		ln(480 + cos(a) * 78, 250 + sin(a) * 78, 480 + cos(a) * 88, 250 + sin(a) * 88, INK, 3)
	txt(480, 400, tr("vtext.floating"), 22, F_VELVET)


func _fmirror() -> void:
	board(F_VELVET_D)
	_s7_mirror(170, 30, 620, 420)


func _ftable() -> void:
	board(Color("3a1a10"))
	r(40, 60, 880, 380, WOOD)
	if not flag("spread"):
		c(260, 220, 40, Color("e8d0d0"))
		rr(560, 180, 120, 80, Color("2a1a1a"), 6)
		return
	var faces: Array = clues.get("faces", [])
	var dots: Array = clues.get("dots", [])
	var shown: Array = st.get("cards", [0, 0, 0, 0, 0, 0, 0, 0])
	for k in range(8):
		var x := 50 + k * 110.0
		var corner := int(dots[k])
		var dot := Vector2.ZERO
		if corner > 0:
			dot = [Vector2(x + 12, 162), Vector2(x + 88, 162), Vector2(x + 88, 288), Vector2(x + 12, 288)][corner - 1]
		if int(shown[k]) == 1:
			rr(x, 150, 100, 150, CREAM, 6)
			var red := k % 2 == 0
			txt(x + 50, 245, str(int(faces[k])), 56, RED if red else INK)
			poly([x + 50, 270, x + 58, 282, x + 50, 294, x + 42, 282], RED if red else INK)
		else:
			rr(x, 150, 100, 150, Color("8a1a2a"), 6)
			for q in range(5):
				ring(x + 50, 225, 8 + q * 7, Color("a02a3a"), 2)
		# The marking shows through on the face too, so a turned card keeps its corner.
		if corner > 0:
			c(dot.x, dot.y, 3, F_GOLD)


func _fcabinet() -> void:
	board(Color("1e100c"))
	r(180, 30, 600, 412, Color("2a1410"))
	if flag("cabinet_open"):
		r(220, 60, 520, 360, F_VELVET_D)
		_s7_sign("star", 480, 240, 2.0, F_GOLD)
		return
	var seq := int(st.get("seq", [0])[0])
	for i in range(6):
		var x := 200 + (i % 3) * 190.0
		var y := 50 + (i / 3) * 200.0
		rr(x, y, 170, 180, Color("3a1c14"), 10)
		_s7_sign(PANEL_SIGNS[i], x + 85, y + 90, 1.6, F_GOLD)
	for k in range(5):
		c(380 + k * 50, 446, 8, F_GOLD if k < seq else Color("3a2a1a"))


func _fswitch() -> void:
	board(F_WINGS)
	var lamp := int(st.get("lamp", [0])[0]) == 1
	rr(360, 60, 240, 340, Color("3a3a3a"), 8)
	c(480, 100, 20, AMBER if lamp else Color("4a4a4a"))
	r(470, 140, 20, 200, Color("1a1a1a"))
	rr(440, 150 if lamp else 270, 80, 70, F_GOLD, 8)


func _fglass() -> void:
	board(F_WINGS)
	# The backdrop with its three windows, the glass in front.
	r(120, 20, 560, 300, Color("2a3a5a"))
	for k in range(3):
		r(190 + k * 150, 110, 110, 130, Color("141c2e"))
	poly([120, 20, 170, 20, 680, 320, 630, 320], Color(1, 1, 1, 0.1))
	if int(st.get("lamp", [0])[0]) == 1:
		_s7_ghost(190, 110, 150.0, 0.75)
	# The handle: five positions marked with clock faces.
	var tilt := int(st.get("tilt", [0])[0])
	var hours := [10.0, 11.0, 12.0, 1.0, 2.0]
	for k in range(5):
		_s7_clock(140 + k * 100, 400, 30, hours[k], INK)
		if k == tilt:
			ring(140 + k * 100, 400, 38, F_GOLD, 5)
	arrow_btn(620, 350, 110, 90, 2)
	arrow_btn(800, 350, 110, 90, 3)


func _fbox() -> void:
	board(F_WINGS)
	var saw: Array = st.get("saw", [0, 0, 0])
	for k in range(3):
		var y := 100 + int(saw[k]) * 30.0
		rr(140 + k * 230, y, 210, 160, Color("8a2a6a") if k != 1 else Color("2a6a8a"), 8)
		for q in range(4):
			c(160 + k * 230 + q * 50, y + 20, 6, F_GOLD)
	if flag("saw_ok"):
		r(380, 340, 200, 110, Color("1a1010"))
		if not flag("got_rabbit"):
			c(480, 400, 36, Color("e8e4dc"))
			poly([462, 380, 470, 330, 478, 380], Color("e8e4dc"))
			poly([484, 380, 492, 330, 500, 380], Color("e8e4dc"))


func _fdoor() -> void:
	board(F_WINGS)
	door(20, 20, 920, 440)
	r(40, 140, 880, 260, Color(0, 0, 0, 0.35))
	kit_wheels(st.get("pad1", [0, 0, 0, 0]), 110, 250)
	kit_wheels(st.get("pad2", [0, 0, 0]), 480, 250)
	for k in range(2):
		var sx := 230.0 if k == 0 else 560.0
		# The shackle: closed, or lifted out once the padlock is open.
		ci.draw_arc(Vector2(sx, 170 if not flag("pad%d" % (k + 1)) else 140), 40, PI, TAU, 16, STEEL, 8, true)
	rr(780, 160, 130, 150, STEEL, 12)
	c(845, 240, 12, Color("1a1a1a"))
	if not flag("done"):
		for k in range(10):
			ring(780 + k * 14, 110 + (k % 2) * 8, 10, Color("9aa2aa"), 4)


# --- Rain on Gale Street ---------------------------------------------------------

func _i_red() -> bool:
	return int(st.get("lamp", [1])[0]) == 0 and int(st.get("blinds", [0])[0]) > 0


func _i_room() -> void:
	r(0, 0, 960, 372, I_WALL)
	for i in range(0, 960, 60):
		r(i, 0, 2, 372, I_WALL_D)
	r(0, 372, 960, 100, I_FLOOR)
	r(0, 368, 960, 6, Color("1a1a1e"))


func _s7_blinds(x: float, y: float, w: float, h: float, open: int) -> void:
	r(x, y, w, h, Color("101018"))
	if open > 0:
		c(x + w * 0.6, y + h * 0.45, h * 0.35, Color(I_NEON, 0.55))
		txt(x + w * 0.6, y + h * 0.5, "HOTEL", int(h * 0.14), I_NEON)
	var slat := 6.0 + (2 - open) * 4.0
	var gap := h / 12.0
	for k in range(12):
		r(x, y + k * gap, w, slat if open < 2 else 3.0, I_GREY)
	r(x - 6, y - 6, w + 12, 8, I_LIGHT)


func _i1() -> void:
	_i_room()
	# Filing cabinet.
	r(40, 60, 150, 190, I_GREY)
	for k in range(3):
		r(50, 70 + k * 60, 130, 52, I_LIGHT)
		r(100, 90 + k * 60, 30, 6, I_WALL)
	# Typewriter on its table.
	r(40, 310, 200, 60, Color("4a3a2a"))
	rr(70, 270, 140, 50, Color("1a1a1a"), 6)
	for k in range(6):
		c(86 + k * 22, 300, 5, I_LIGHT)
	# The case board.
	r(240, 30, 300, 170, Color("8a6a4a"))
	for k in range(4):
		r(260 + k * 70, 50 + (k % 2) * 60, 50, 60, I_LIGHT)
	ln(285, 80, 355, 140, Color("c02a2a"), 2)
	ln(355, 140, 425, 80, Color("c02a2a"), 2)
	ln(425, 80, 495, 140, Color("c02a2a"), 2)
	# The desk, its lamp and pad.
	r(300, 260, 360, 30, Color("3a2a1e"))
	r(310, 290, 60, 80, Color("2a1e14"))
	r(590, 290, 60, 80, Color("2a1e14"))
	var lamp := int(st.get("lamp", [1])[0]) == 1
	poly([330, 210, 390, 210, 375, 185, 345, 185], Color("2a5a3a"))
	r(357, 210, 6, 50, I_GREY)
	if lamp:
		poly([330, 210, 390, 210, 420, 260, 300, 260], Color(AMBER, 0.25))
	r(450, 240, 120, 20, PAPER)
	# The bin.
	poly([670, 300, 740, 300, 732, 370, 678, 370], I_GREY)
	# The window and its blinds, the neon outside.
	_s7_blinds(690, 40, 230, 210, int(st.get("blinds", [0])[0]))
	# The safe.
	r(760, 280, 170, 90, Color("2a2a2e"))
	c(845, 325, 22, I_GREY)
	if _i_red():
		r(0, 0, 960, 472, Color(I_NEON, 0.12))


func _i2() -> void:
	_i_room()
	# The coat stand.
	r(136, 40, 8, 330, Color("2a1e14"))
	var carnations := [Color("f0a0c0"), Color("d01a2a"), Color(0, 0, 0, 0)]
	var coats := [Color("6a6a70"), Color("5a4030"), Color("1a1a1e")]
	for k in range(3):
		var x := 60 + k * 60.0
		poly([x, 70, x + 50, 70, x + 64, 330, x - 14, 330], coats[k])
		c(x + 14, 96, 6, carnations[k])
	# The timetable.
	r(280, 40, 200, 170, PAPER)
	r(290, 50, 180, 20, INK)
	for k in range(6):
		r(296, 86 + k * 18, 168, 2, Color(INK, 0.4))
	# The radio.
	rr(280, 250, 170, 120, Color("5a3a20"), 14)
	c(340, 310, 30, Color("3a2412"))
	r(390, 280, 40, 60, Color("e8c880"))
	# The door, its frosted glass read from inside.
	door(560, 30, 220, 340)
	r(590, 50, 160, 130, Color("c8ccd0"))
	_s7_mirrored(720, 110, "%d%d" % [int(clues.get("band", [4, 7])[0]), int(clues.get("band", [4, 7])[1])], 40, Color("4a4a50"))
	_s7_mirrored(740, 150, "GALE ST", 20, Color("4a4a50"))
	# The phone.
	r(800, 300, 140, 70, Color("3a2a1e"))
	rr(830, 260, 80, 40, Color("1a1a1a"), 8)


func _ibin() -> void:
	board(I_FLOOR)
	poly([220, 40, 740, 40, 700, 440, 260, 440], I_GREY)
	for k in range(8):
		ln(250 + k * 62, 40, 280 + k * 54, 440, I_WALL, 3)
	if not flag("got_carbon"):
		poly([330, 200, 630, 180, 620, 340, 340, 330], Color("14142a"))
		ln(360, 220, 600, 210, Color("3a3a6a"), 2)


func _idesk() -> void:
	board(Color("2a1e14"))
	var lamp := int(st.get("lamp", [1])[0]) == 1
	# The lamp and its switch.
	poly([90, 130, 270, 130, 230, 50, 130, 50], Color("2a5a3a"))
	r(174, 130, 12, 150, I_GREY)
	r(110, 270, 140, 20, I_GREY)
	if lamp:
		poly([90, 130, 270, 130, 340, 470, 20, 470], Color(AMBER, 0.16))
	rr(110, 290, 140, 90, Color("1a1a1a"), 8)
	r(170, 304 if lamp else 334, 20, 32, I_LIGHT)
	# The pad: blue numbers under red scribble; red light hides the red.
	var red := _i_red()
	rr(340, 190, 320, 220, PAPER if not red else Color("f0a0a0"), 3)
	var pad: Array = clues.get("pad", [])
	txt(500, 330, "%d  %d  %d  %d" % [int(pad[0]), int(pad[1]), int(pad[2]), int(pad[3])], 64, I_BLUE if not red else Color("1a1030"))
	if not red:
		for k in range(14):
			ln(360 + k * 21, 250 + (k % 3) * 30, 380 + k * 20, 370 - (k % 4) * 25, Color("d01a2a"), 7)
			ci.draw_arc(Vector2(380 + k * 20, 300), 26, k * 0.7, k * 0.7 + 3.5, 10, Color("d01a2a"), 6, true)
	if flag("carbon_read") or flag("ribbon_read"):
		rr(700, 30, 230, 300, PAPER, 3)
		for k in range(8):
			r(716, 60 + k * 30, 196, 3, Color(INK, 0.4))
	if red:
		r(0, 0, 960, 472, Color(I_NEON, 0.15))


func _iread() -> void:
	board(Color("2a1e14"))
	if flag("carbon_read"):
		rr(40, 20, 430, 432, Color("1a1a3a"), 3)
		_s7_text(64, 60, 382, "itext.carbon", 20, Color("c8d0ff"))
	if flag("ribbon_read"):
		r(500, 60, 420, 130, Color("101010"))
		# The ribbon keeps the typed letters, backwards.
		var line := tr("itext.ribbon")
		ci.draw_set_transform(Vector2(910, 100), 0.0, Vector2(-1, 1))
		ci.draw_multiline_string(font, Vector2.ZERO, line, HORIZONTAL_ALIGNMENT_LEFT, 400, 18, -1, Color("e05050"))
		home()


func _iblinds() -> void:
	board(I_WALL)
	_s7_blinds(80, 30, 640, 420, int(st.get("blinds", [0])[0]))
	arrow_btn(790, 110, 120, 90, 0)
	arrow_btn(790, 260, 120, 90, 1)


func _icabinet() -> void:
	board(I_WALL)
	if flag("cabinet_open"):
		rr(60, 20, 410, 432, PAPER, 3)
		_s7_text(80, 56, 370, "itext.bartender", 18, INK)
		rr(490, 20, 410, 432, PAPER, 3)
		_s7_text(510, 56, 370, "itext.driver", 18, INK)
	else:
		r(240, 30, 480, 412, I_GREY)
		kit_wheels(st.get("cabinet", [0, 0, 0, 0]), 360, 250)


func _itype() -> void:
	board(Color("2a1e14"))
	rr(100, 120, 760, 320, Color("1a1a1a"), 20)
	r(160, 60, 640, 70, Color("2a2a2a"))
	for row in range(3):
		for k in range(10):
			c(200 + k * 62 + row * 20, 270 + row * 56, 20, I_LIGHT)
	if not flag("got_ribbon"):
		ring(430, 165, 34, Color("101010"), 14)
		ring(530, 165, 34, Color("101010"), 14)
		ln(430, 131, 530, 131, Color("aa2222"), 6)


func _iboard() -> void:
	board(Color("6a4a30"))
	r(40, 20, 880, 432, Color("8a6a4a"))
	for k in range(4):
		var x := 80 + k * 200.0
		r(x, 50, 140, 160, I_LIGHT)
		c(x + 70, 110, 34, I_GREY)
		txt(x + 70, 196, tr("itext.who%d" % k), 16, INK)
	ln(150, 210, 550, 260, Color("c02a2a"), 3)
	rr(560, 250, 340, 190, PAPER, 3)
	_s7_text(578, 284, 304, "itext.board", 17, INK)
	rr(80, 260, 440, 170, PAPER, 3)
	_s7_text(98, 292, 404, "itext.case", 17, INK)


func _isafe() -> void:
	board(I_WALL)
	r(200, 20, 560, 432, Color("2a2a2e"))
	if flag("safe_open"):
		r(240, 60, 480, 360, Color("101012"))
		if not flag("got_opener"):
			item("iopener", 380, 270, 5.0)
			home()
		poly([610, 230, 640, 270, 610, 320, 580, 270], Color("d01a3a"))
	else:
		kit_wheels(st.get("safe", [0, 0, 0, 0]), 360, 250)


func _icoats() -> void:
	board(I_WALL)
	var carnations := [Color("f0a0c0"), Color("d01a2a"), Color(0, 0, 0, 0)]
	var coats := [Color("6a6a70"), Color("5a4030"), Color("1a1a1e")]
	for k in range(3):
		var x := 60 + k * 300.0
		poly([x + 40, 40, x + 220, 40, x + 260, 440, x, 440], coats[k])
		poly([x + 130, 40, x + 100, 160, x + 130, 140, x + 160, 160], coats[k].darkened(0.3))
		c(x + 80, 110, 16, carnations[k])
		r(x + 150, 300, 70, 8, coats[k].darkened(0.4))
	if flag("got_statement"):
		rr(300, 230, 360, 220, PAPER, 3)
		_s7_text(316, 262, 328, "itext.doorman", 16, INK)


func _iradio() -> void:
	board(I_WALL)
	rr(160, 60, 640, 360, Color("5a3a20"), 30)
	c(280, 240, 90, Color("3a2412"))
	for k in range(5):
		ring(280, 240, 20 + k * 16, Color("4a2e18"), 3)
	kit_wheels(st.get("radio", [0, 0]), 440, 270)
	rr(640, 200, 260, 200, PAPER, 3)
	_s7_text(656, 236, 228, "itext.radio_note", 17, INK)
	if flag("radio_on"):
		c(560, 120, 12, AMBER)
		rr(170, 12, 450, 118, PAPER, 3)
		_s7_text(184, 38, 422, "itext.bulletin", 14, INK)


func _iglass() -> void:
	board(I_WALL)
	r(120, 20, 720, 432, Color("c8ccd0"))
	for k in range(30):
		c(140 + (k * 97) % 680, 40 + (k * 53) % 400, 18, Color(1, 1, 1, 0.12))
	var band: Array = clues.get("band", [4, 7])
	_s7_mirrored(660, 200, "%d%d" % [int(band[0]), int(band[1])], 120, Color("3a3a40"))
	_s7_mirrored(720, 300, "GALE STREET", 44, Color("3a3a40"))
	_s7_mirrored(700, 380, "ROOK · INVESTIGATIONS", 26, Color("3a3a40"))


func _itimetable() -> void:
	board(I_WALL)
	rr(100, 20, 760, 432, PAPER, 3)
	txt(480, 66, tr("itext.timetable"), 24, INK)
	var depot := int(clues.get("depot", 0))
	txt(480, 104, "%s  %s" % [tr("itext.depot"), _s7_hhmm(depot)], 22, RED)
	var names := ["Harbour Road", "Market Hall", "Opera", "Hotel Ambassador", "Gale Street", "North Depot"]
	var stops: Array = clues.get("stops", [])
	for k in range(stops.size()):
		var y := 160 + k * 46.0
		txt(160, y, names[k], 22, INK, false)
		txt(760, y, "+%d min" % int(stops[k]), 22, INK)
		r(160, y + 12, 640, 2, Color(INK, 0.2))


func _idoor() -> void:
	board(I_FLOOR)
	door(160, 20, 640, 380)
	c(700, 250, 30, BRASS_D)
	r(694, 236, 12, 30, Color("0a0a0a"))
	if not flag("key_pushed"):
		r(697, 242, 6, 18, STEEL)
	r(160, 400, 640, 60, Color("101012"))
	if flag("sheet_under"):
		poly([200, 410, 760, 410, 780, 456, 180, 456], Color("14142a"))
		if flag("key_pushed") and not flag("got_doorkey"):
			item("idoorkey", 480, 432, 2.0)
			home()
