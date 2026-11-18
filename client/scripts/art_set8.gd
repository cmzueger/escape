## Draws the eighth set on top of ArtSet7: The Filter Hall (WA1, WA2), The
## 8:15 to Nowhere (RC1, RC2) and Harvest Moon (MI1, MI2), with their
## close-ups. Hotspots are in views_set8.gd.
class_name ArtSet8
extends ArtSet7

const W8_TILE := Color("e6edf0")
const W8_GROUT := Color("c3d0d6")
const W8_FLOOR := Color("4a5c66")
const W8_IRON := Color("3c4a54")
const W8_IRON_HI := Color("6a7c88")
const W8_WATER := Color("3a8fd0")
const W8_WATER_HI := Color("9fd4f2")
const W8_BRASS := Color("c8a050")
const R8_PANEL := Color("6a4228")
const R8_PANEL_D := Color("52321c")
const R8_BAIZE := Color("4a7a44")
const R8_BAIZE_D := Color("3a6234")
const R8_RAIL := Color("8a8070")
const R8_ENGINES := [Color("3a8a4a"), Color("c0302a"), Color("2a5ab0"), Color("1e1e22")]
const R8_WAGONS := [Color(0, 0, 0, 0), Color("d8b44a"), Color("a03a2a"), Color("2a2a2a"), Color("8a5a2a"), Color("3a6a8a")]
const M8_SKY := Color("f4aa5a")
const M8_SKY_HI := Color("ffd890")
const M8_FIELD := Color("dcb43c")
const M8_WOOD := Color("8a5a34")
const M8_WOOD_D := Color("6a4224")
const M8_FLOUR := Color("f4eee0")
const M8_STONE := Color("a8a29a")
const DIRS8 := ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]

var _r8_runs := -1
var _r8_run_t := -100.0


func draw_view(view: String) -> void:
	match view:
		"WA1": _wa1()
		"WA2": _wa2()
		"wacoal": _wacoal()
		"wafirebox": _wafirebox()
		"wagauge": _wagauge()
		"watube": _s8_talk("tube")
		"walevers": _walevers()
		"wagov": _wagov()
		"waprogramme": _waprogramme()
		"wanotes": _wanotes()
		"waboard": _waboard()
		"warisers": _warisers()
		"watank": _watank()
		"waplaque": _s8_sheet("watext.plaque", Color("2e5a6a"), 22)
		"wanet": _wanet()
		"watable": _watable()
		"wawindow": _wawindow()
		"wajets": _wajets()
		"RC1": _rc1()
		"RC2": _rc2()
		"rcstation": _rcstation()
		"rccontrol": _rccontrol()
		"rcturntable": _rcturntable()
		"rcyard": _rcyard()
		"rcletter": _s8_sheet("rctext.letter", R8_PANEL_D, 21)
		"rcphone": _s8_talk("phone")
		"rcpoints": _rcpoints()
		"rcsign": _rcsign()
		"rcshelf": _rcshelf()
		"rcbench": _rcbench()
		"rcgap": _rcgap()
		"MI1": _mi1()
		"MI2": _mi2()
		"misacks": _misacks()
		"mihoist": _mihoist()
		"michute": _michute()
		"midoor": _midoor()
		"miwheel": _miwheel()
		"miwindow": _miwindow()
		"migears": _migears()
		"mislate": _s8_sheet("mitext.slate", Color("2a2a2a"), 21)
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"waspanner":
			at(x, y, -0.6, s)
			r(-3, -12, 6, 22, W8_IRON_HI)
			ring(0, -14, 6, W8_IRON_HI, 4)
		"wamatches":
			at(x, y, 0.0, s)
			r(-12, -8, 24, 16, Color("c03a2a"))
			r(-10, -6, 20, 12, Color("e8c880"))
		"wahorn":
			at(x, y, 0.0, s)
			ci.draw_arc(Vector2(0, 4), 12, PI, TAU * 0.95, 14, W8_BRASS, 5, true)
			poly([10, -2, 18, -10, 18, 6], W8_BRASS)
		"rckey", "micrank":
			if name == "micrank":
				at(x, y, 0.0, s)
				r(-2, -12, 4, 20, M8_WOOD_D)
				r(-2, -12, 14, 4, M8_WOOD_D)
				c(12, -10, 4, M8_WOOD)
			else:
				super.item("key", x, y, s)
				return
		"rcboard":
			at(x, y, 0.0, s)
			rr(-16, -7, 32, 14, Color("1e1e22"), 3)
			txt(0, 5, "8:15", 9, CREAM)
		"rcbook":
			at(x, y, 0.0, s)
			r(-8, -12, 16, 24, Color("a02a2a"))
			r(-6, -2, 12, 3, BRASS)
		"miflour", "mibran":
			at(x, y, 0.0, s)
			poly([-10, 12, 10, 12, 12, -6, 6, -12, -6, -12, -12, -6], M8_FLOUR if name == "miflour" else Color("b08a5a"))
			ln(-6, -10, 6, -10, M8_WOOD_D, 2)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"filter":
			r(0, 0, w, h, W8_TILE)
			for k in range(8):
				ln(k * w / 8.0, 0, k * w / 8.0, h * 0.6, W8_GROUT, 1)
			r(0, h * 0.6, w, h * 0.4, W8_WATER)
			rr(w * 0.38, h * 0.62, w * 0.24, h * 0.12, W8_IRON_HI, 3)
			var hs := [0.3, 0.6, 0.3]
			for k in range(3):
				var jet: float = h * hs[k] * (0.7 + 0.3 * sin(t * 3.0 + k * 1.7))
				var jx := w * (0.42 + k * 0.08)
				ln(jx, h * 0.62, jx, h * 0.62 - jet, W8_WATER_HI, 3)
				c(jx, h * 0.62 - jet, 3, W8_WATER_HI)
			for k in range(4):
				var rx := fmod(k * 37.0 + t * 12.0, w)
				ln(rx, h * (0.82 + k * 0.04), rx + w * 0.12, h * (0.82 + k * 0.04), Color(1, 1, 1, 0.5), 1.5)
		"railway":
			r(0, 0, w, h, R8_PANEL)
			r(0, h * 0.45, w, h * 0.55, R8_BAIZE)
			ring(w * 0.5, h * 0.72, h * 0.2, R8_RAIL, 2)
			ci.draw_set_transform(Vector2(w * 0.5, h * 0.72), 0.0, Vector2(2.2, 1.0))
			ring(0, 0, h * 0.18, R8_RAIL, 2)
			home()
			var a := t * 0.9
			var tx := w * 0.5 + cos(a) * h * 0.4
			var ty := h * 0.72 + sin(a) * h * 0.18
			rr(tx - 7, ty - 5, 14, 10, R8_ENGINES[3], 2)
			c(tx + 5 * cos(a + PI / 2), ty - 6, 2, Color(1, 0.9, 0.6, 0.9))
			c(w * 0.8, h * 0.15, h * 0.4, Color(1, 0.85, 0.55, 0.18))
		"mill":
			r(0, 0, w, h, M8_SKY)
			r(0, 0, w, h * 0.35, M8_SKY_HI)
			r(0, h * 0.75, w, h * 0.25, M8_FIELD)
			c(w * 0.82, h * (0.7 - 0.06 * sin(t * 0.3)), h * 0.12, Color("fff2c0"))
			poly([w * 0.38, h * 0.78, w * 0.43, h * 0.32, w * 0.53, h * 0.32, w * 0.58, h * 0.78], M8_WOOD_D)
			for k in range(4):
				var sa := t * 1.2 + k * PI / 2
				ln(w * 0.48, h * 0.34, w * 0.48 + cos(sa) * h * 0.38, h * 0.34 + sin(sa) * h * 0.38, Color("5a3a24"), 3)
		_:
			super.card(room, w, h)


# --- Shared ----------------------------------------------------------------------

func _s8_sheet(key: String, ground: Color, size: int) -> void:
	board(ground)
	rr(140, 20, 680, 432, PAPER, 4)
	ci.draw_multiline_string(font, Vector2(170, 60), tr(key), HORIZONTAL_ALIGNMENT_LEFT, 620, size, -1, INK)


func _s8_text(x: float, y: float, w: float, key: String, size: int, col: Color) -> void:
	ci.draw_multiline_string(font, Vector2(x, y), tr(key), HORIZONTAL_ALIGNMENT_LEFT, w, size, -1, col)


## A conversation: the caller object, or the line and its choices.
func _s8_talk(caller: String) -> void:
	var at := int(st.get("talk", [0])[0])
	match caller:
		"tube": board(W8_TILE)
		"phone": board(R8_PANEL)
		_: board(M8_WOOD)
	if at == 0:
		match caller:
			"tube":
				ci.draw_arc(Vector2(480, 120), 120, 0, PI, 20, W8_BRASS, 26, true)
				c(480, 240, 70, W8_BRASS)
				c(480, 240, 46, Color("2a2a2a"))
			"phone":
				rr(360, 200, 240, 140, Color("1a1a1a"), 20)
				rr(340, 130, 280, 60, Color("1a1a1a"), 30)
				for k in range(4):
					rr(380 + k * 52, 250, 40, 40, CREAM, 6)
				txt(588, 270, "H", 20, INK)
			_:
				r(330, 120, 300, 230, M8_WOOD_D)
				c(480, 190, 50, Color("e8c8a0"))
				poly([400, 350, 560, 350, 540, 250, 420, 250], Color("6a3a5a"))
		return
	var lines: Array = clues.get("lines", [])
	if at - 1 >= lines.size():
		return
	var line: Dictionary = lines[at - 1]
	rr(60, 16, 840, 192, Color(CREAM, 0.95), 10)
	ci.draw_multiline_string(font, Vector2(84, 58), tr(line["text"]), HORIZONTAL_ALIGNMENT_LEFT, 790, 22, -1, INK)
	var choices: Array = line["choices"]
	for i in range(choices.size()):
		rr(60, 222 + i * 64.0, 840, 56, Color(0, 0, 0, 0.45), 8)
		ci.draw_string(font, Vector2(84, 258 + i * 64.0), tr(choices[i]), HORIZONTAL_ALIGNMENT_LEFT, 790, 20, CREAM)


func _s8_arrows(x: float, y: float) -> void:
	arrow_btn(x - 36, y - 66, 72, 56, 0)
	arrow_btn(x - 36, y + 76, 72, 58, 1)


# --- The Filter Hall ---------------------------------------------------------------

func _wa_hall() -> void:
	r(0, 0, 960, 372, W8_TILE)
	for i in range(0, 960, 40):
		ln(i, 0, i, 372, W8_GROUT, 1)
	for j in range(0, 372, 30):
		ln(0, j, 960, j, W8_GROUT, 1)
	r(0, 300, 960, 8, Color("3a7aa0"))
	r(0, 372, 960, 100, W8_FLOOR)


func _wa_engine_on() -> bool:
	return flag("engine_on")


func _wa1() -> void:
	_wa_hall()
	# Coal bunker.
	r(30, 280, 170, 90, W8_IRON)
	for k in range(9):
		c(50 + k * 18, 290 - (k % 3) * 6, 14, Color("1a1a1e"))
	# Boiler with its water glass, the firebox below.
	rr(220, 60, 150, 140, W8_IRON, 30)
	r(330, 80, 14, 90, Color("dfe8ee"))
	var level := int(st.get("feed", [0])[0])
	r(332, 168 - level * 10, 10, level * 10, W8_WATER)
	rr(230, 210, 130, 160, W8_IRON_HI, 6)
	r(260, 240, 70, 60, Color("ff8a2a") if flag("fire") else Color("1a1a1e"))
	# Governor.
	r(460, 70, 8, 130, W8_IRON)
	var spin := t * 4.0 if _wa_engine_on() else 0.0
	var lift := 10.0 * int(st.get("speed", [0])[0])
	for k in [-1, 1]:
		var bx: float = 464 + k * (26 + lift * 0.6) * cos(spin)
		ln(464, 80, bx, 120 - lift, W8_IRON_HI, 3)
		c(bx, 120 - lift, 11, W8_BRASS)
	# Levers.
	for k in range(3):
		r(410 + k * 50, 250, 14, 110, W8_IRON)
		c(417 + k * 50, 250, 10, Color("c03a2a"))
	# Flywheel.
	var fa := t * 3.0 if _wa_engine_on() else 0.4
	ring(610, 290, 60, W8_IRON, 8)
	for k in range(4):
		ln(610, 290, 610 + cos(fa + k * PI / 2) * 58, 290 + sin(fa + k * PI / 2) * 58, W8_IRON, 5)
	# Speaking tube, programme, desk, valve board.
	r(605, 50, 12, 130, W8_BRASS)
	c(611, 180, 16, W8_BRASS)
	r(670, 40, 130, 160, PAPER)
	_wa_fountain_sketch(735, 170, 0.5)
	r(670, 320, 160, 50, Color("6a4a2a"))
	rr(690, 290, 100, 34, PAPER, 2)
	if not flag("got_matches"):
		r(800, 300, 22, 16, Color("c03a2a"))
	r(830, 40, 120, 220, W8_IRON)
	var valves: Array = st.get("districts", [0, 0, 0, 0, 0, 0])
	for k in range(6):
		c(850 + (k % 2) * 60, 70 + (k / 2) * 60, 16, W8_WATER if int(valves[k]) == 1 else Color("8a2a2a"))


func _wa_fountain_sketch(x: float, y: float, s: float) -> void:
	var design: Array = clues.get("design", [2, 6, 2])
	rr(x - 60 * s, y - 10 * s, 120 * s, 20 * s, Color(INK, 0.6), 4)
	for k in range(3):
		var jx := x + (k - 1) * 40 * s
		var hgt := int(design[k]) * 20 * s
		ln(jx, y - 10 * s, jx, y - 10 * s - hgt, Color("3a6a9a"), 3)
	for m in range(7):
		ln(x + 72 * s, y - 10 * s - m * 20 * s, x + 82 * s, y - 10 * s - m * 20 * s, Color(INK, 0.5), 1)


func _wa2() -> void:
	_wa_hall()
	# Risers; the one with the air lock knocks while the engine runs.
	for k in range(3):
		var shake := 0.0
		if k == 2 and _wa_engine_on() and not flag("air_out") and fmod(t, 2.0) < 0.3:
			shake = 3.0 * sin(t * 60.0)
		r(50 + k * 50 + shake, 40, 18, 330, W8_IRON_HI)
		c(59 + k * 50 + shake, 200, 10, Color("c03a2a"))
	# Plaque and filter tank.
	rr(210, 40, 170, 90, W8_BRASS, 6)
	for k in range(3):
		r(230, 62 + k * 18, 130, 3, Color("6a5020"))
	r(220, 160, 150, 210, Color(W8_IRON_HI, 0.6))
	_wa_layers(222, 360, 146, 30)
	# The pipe wall, small.
	_wa_grid(400, 40, 60.0)
	# Ceremony table.
	r(400, 330, 240, 40, Color("6a4a2a"))
	r(400, 300, 240, 30, Color("f0f0f0"))
	if not flag("got_horn"):
		ci.draw_arc(Vector2(470, 300), 16, PI, TAU, 10, W8_BRASS, 6, true)
	for k in range(4):
		r(540 + k * 20, 280, 8, 20, Color(0.8, 0.9, 1.0, 0.6))
	# The window onto the square.
	_wa_square(670, 40, 270, 200)
	# Jet valves and the main valve.
	var jets: Array = st.get("jets", [0, 0, 0])
	for k in range(3):
		ring(700 + k * 55, 310, 20, W8_IRON, 6)
		txt(700 + k * 55, 318, str(int(jets[k])), 18, INK)
	ring(900, 315, 34, Color("c03a2a"), 8)
	ln(866, 315, 934, 315, Color("c03a2a"), 6)


func _wa_layers(x: float, bottom: float, w: float, h: float) -> void:
	var layers: Array = st.get("layers", [0, 0, 0])
	var cols := [Color(0, 0, 0, 0), Color("9a9a8a"), Color("e8d49a"), Color("2a2a2a")]
	for k in range(layers.size()):
		var v := int(layers[k])
		if v > 0:
			r(x, bottom - (k + 1) * h, w, h, cols[v])
			if v == 1:
				for q in range(6):
					c(x + 12 + q * w / 6.0, bottom - (k + 0.5) * h, h * 0.25, Color("7a7a6a"))


## The window: the square, the pump house flag, the fountain and the mayor.
func _wa_square(x: float, y: float, w: float, h: float) -> void:
	r(x, y, w, h, Color("bcd8ea"))
	r(x, y + h * 0.7, w, h * 0.3, Color("c8b898"))
	# Pump house with its flag.
	r(x + w * 0.7, y + h * 0.35, w * 0.22, h * 0.35, Color("a85a3a"))
	ln(x + w * 0.81, y + h * 0.35, x + w * 0.81, y + h * 0.12, INK, 2)
	poly([x + w * 0.81, y + h * 0.12, x + w * 0.93, y + h * 0.16, x + w * 0.81, y + h * 0.2], Color("2a5ab0"))
	# The fountain.
	var fx := x + w * 0.4
	var fy := y + h * 0.78
	rr(fx - w * 0.2, fy, w * 0.4, h * 0.08, W8_IRON_HI, 4)
	var hs: Array = st.get("heights", [0, 0, 0])
	for k in range(3):
		var hgt := int(hs[k]) * h * 0.08
		if hgt > 0:
			var jx := fx + (k - 1) * w * 0.12
			ln(jx, fy, jx, fy - hgt, W8_WATER_HI, 4)
			c(jx, fy - hgt, 4, W8_WATER_HI)
	for m in range(8):
		ln(fx + w * 0.23, fy - m * h * 0.08, fx + w * 0.26, fy - m * h * 0.08, Color(INK, 0.4), 1)
	# The mayor on his stand; he raises his glass at the toast.
	var cycle := int(clues.get("cycle", 15))
	var toast := int(clues.get("toast", 4))
	var raised := int(st.get("secs", 0)) % cycle >= cycle - toast
	var mx := x + w * 0.12
	r(mx - 14, y + h * 0.62, 28, h * 0.16, Color("6a4a2a"))
	c(mx, y + h * 0.5, 9, Color("e8c8a0"))
	r(mx - 8, y + h * 0.54, 16, h * 0.1, Color("1a1a2a"))
	var gy := y + h * (0.36 if raised else 0.58)
	ln(mx + 6, y + h * 0.58, mx + 16, gy, Color("1a1a2a"), 3)
	r(mx + 13, gy - 8, 7, 9, Color(1, 0.9, 0.6, 0.9))


func _wacoal() -> void:
	board(W8_IRON)
	for k in range(40):
		c(180 + (k * 71) % 600, 200 + (k * 37) % 220, 30, Color("141418"))
	if not flag("got_spanner"):
		at(560, 330, -0.4, 4.0)
		r(-3, -12, 6, 22, W8_IRON_HI)
		home()


func _wafirebox() -> void:
	board(W8_IRON)
	rr(260, 80, 440, 340, W8_IRON_HI, 12)
	if flag("firebox_open"):
		r(320, 150, 320, 220, Color("1a1a1e"))
		if flag("fire"):
			for k in range(8):
				var fh := 60 + 40 * sin(t * 6.0 + k)
				poly([340 + k * 38, 370, 358 + k * 38, 370 - fh, 376 + k * 38, 370], Color("ff8a2a"))
	else:
		rr(320, 150, 320, 220, W8_IRON, 8)
		c(600, 260, 14, W8_BRASS)
		ln(320, 150, 640, 370, Color("8a2a2a"), 3)


func _wagauge() -> void:
	board(W8_TILE)
	rr(80, 30, 560, 410, W8_IRON, 40)
	# Water glass with its red marks.
	r(150, 80, 60, 320, Color("dfe8ee"))
	var level := int(st.get("feed", [0])[0])
	r(154, 396 - level * 38, 52, level * 38, W8_WATER)
	var mark := int(clues.get("feed", 5))
	for m in [mark - 0.4, mark + 0.4]:
		ln(140, 396 - m * 38, 220, 396 - m * 38, Color("d02a2a"), 4)
	# Pressure gauge: green once the boiler is right.
	c(420, 200, 120, CREAM)
	ci.draw_arc(Vector2(420, 200), 100, PI * 0.8, PI * 1.3, 10, Color("d02a2a"), 16, true)
	ci.draw_arc(Vector2(420, 200), 100, PI * 1.3, PI * 1.8, 10, Color("3a9a4a"), 16, true)
	ci.draw_arc(Vector2(420, 200), 100, PI * 1.8, PI * 2.2, 10, Color("f0f0f0"), 16, true)
	var a := PI * 0.85
	if flag("fire"):
		a = PI * 1.55 if flag("boiler_ok") else PI * 0.85 + level * 0.08
	ln(420, 200, 420 + cos(a) * 90, 200 + sin(a) * 90, INK, 5)
	# The feed valve.
	ring(760, 268, 50, Color("c03a2a"), 10)
	_s8_arrows(760, 230)


func _walevers() -> void:
	board(W8_TILE)
	var signs := ["throttle", "steam", "drains"]
	for i in range(3):
		var x := 230 + i * 250.0
		rr(x - 100, 80, 200, 340, W8_IRON_HI, 8)
		var pulled := false
		ln(x, 380, x + (30 if pulled else -30), 150, W8_IRON, 14)
		c(x - 30, 150, 22, Color("c03a2a"))
		match signs[i]:
			"throttle":
				for k in range(3):
					poly([x - 30 + k * 22, 410, x - 18 + k * 22, 396, x - 6 + k * 22, 410], INK)
			"steam":
				for k in range(3):
					ci.draw_arc(Vector2(x - 20 + k * 20, 400), 9, PI, TAU, 8, INK, 3, true)
			_:
				for k in range(3):
					c(x - 20 + k * 20, 402, 5, W8_WATER)
	var started := int(st.get("start", [0])[0])
	for k in range(3):
		c(400 + k * 80, 50, 10, Color("3a9a4a") if k < started or flag("engine_on") else Color("4a4a4a"))


func _wagov() -> void:
	board(W8_TILE)
	r(350, 40, 20, 380, W8_IRON)
	var speed := int(st.get("speed", [0])[0])
	var spin := t * (2.0 + speed * 2.0) if _wa_engine_on() else 0.0
	var lift := speed * 40.0
	for k in [-1, 1]:
		var bx: float = 360 + k * (80 + lift * 0.5) * cos(spin)
		ln(360, 80, bx, 260 - lift, W8_IRON_HI, 6)
		c(bx, 260 - lift, 34, W8_BRASS)
	for m in range(3):
		ln(520, 300 - m * 40, 600, 300 - m * 40, INK, 3)
		txt(630, 308 - m * 40, str(m + 1), 22, INK)
	ln(500, 300 - speed * 40, 540, 300 - speed * 40, Color("c03a2a"), 8)
	_s8_arrows(760, 230)


func _waprogramme() -> void:
	board(Color("2e5a6a"))
	rr(200, 20, 560, 432, PAPER, 4)
	txt(480, 66, tr("watext.programme"), 24, INK)
	_wa_fountain_sketch(480, 380, 1.6)


func _wanotes() -> void:
	board(Color("6a4a2a"))
	rr(80, 20, 640, 432, PAPER, 4)
	_s8_text(104, 58, 590, "watext.notes", 18, INK)
	if not flag("got_matches"):
		item("wamatches", 830, 370, 3.5)
		home()


func _waboard() -> void:
	board(W8_IRON)
	rr(60, 20, 840, 210, Color("dfe8ee"), 6)
	var names := ["watext.harbour", "watext.market", "watext.hill", "watext.mill", "watext.station", "watext.square"]
	var valves: Array = st.get("districts", [0, 0, 0, 0, 0, 0])
	for k in range(6):
		var x := 120 + k * 145.0
		c(x, 110, 40, W8_WATER if int(valves[k]) == 1 else Color("c8d0d4"))
		txt(x, 190, tr(names[k]), 15, INK)
		rr(x - 60, 250, 120, 180, W8_IRON_HI, 8)
		r(x - 10, 280 if int(valves[k]) == 1 else 370, 20, 50, Color("c03a2a"))


func _warisers() -> void:
	board(W8_TILE)
	for i in range(3):
		var x := 220 + i * 250.0
		var shake := 0.0
		if i == 2 and _wa_engine_on() and not flag("air_out") and fmod(t, 2.0) < 0.3:
			shake = 6.0 * sin(t * 60.0)
		r(x - 30 + shake, 30, 60, 400, W8_IRON_HI)
		c(x + shake, 230, 26, Color("c03a2a"))
		if shake != 0.0:
			for k in range(3):
				ci.draw_arc(Vector2(x + 50, 230), 20 + k * 14, -0.6, 0.6, 6, Color(INK, 0.6), 3, true)


func _watank() -> void:
	board(W8_TILE)
	var cols := [Color("9a9a8a"), Color("e8d49a"), Color("2a2a2a")]
	for i in range(3):
		rr(40, 40 + i * 140.0, 200, 120, W8_IRON_HI, 8)
		r(60, 60 + i * 140.0, 160, 80, cols[i])
		if i == 0:
			for q in range(6):
				c(78 + q * 26, 100 + i * 140.0, 10, Color("7a7a6a"))
	r(300, 40, 340, 400, Color(W8_IRON_HI, 0.5))
	r(310, 40, 320, 395, Color("f0f6f8"))
	_wa_layers(310, 435, 320, 120)
	rr(680, 60, 220, 90, W8_IRON, 8)
	ln(740, 80, 840, 130, CREAM, 6)
	ln(840, 80, 740, 130, CREAM, 6)
	rr(680, 300, 220, 120, W8_IRON, 8)
	r(770, 330, 40, 40, W8_BRASS)
	if flag("filter_ok"):
		r(780, 370, 20, 40, W8_WATER_HI)


## The pipe wall: tiles with their openings, wet ones blue.
func _wa_open(kind: int, rot: int) -> int:
	var base := {1: 5, 2: 3, 3: 7, 4: 12, 5: 3}.get(kind, 0) as int
	if kind == 5 and not flag("socket_in"):
		return 0
	if kind == 4:
		return base
	var m := base
	for k in range(rot % 4):
		m = ((m << 1) | (m >> 3)) & 15
	return m


func _wa_grid(x0: float, y0: float, cell: float) -> void:
	var tiles: Array = clues.get("tiles", [])
	var rot: Array = st.get("pipes", [])
	var wet: Array = st.get("wet", [])
	r(x0 - 4, y0 - 4, cell * 4 + 8, cell * 4 + 8, W8_GROUT)
	if tiles.size() < 16 or rot.size() < 16:
		return
	for i in range(16):
		var x := x0 + (i % 4) * cell
		var y := y0 + (i / 4) * cell
		var kind := int(tiles[i])
		r(x + 1, y + 1, cell - 2, cell - 2, W8_TILE)
		var o := _wa_open(kind, int(rot[i]))
		var w := i < wet.size() and int(wet[i]) == 1
		var col := W8_WATER if w else W8_IRON_HI
		var cx := x + cell / 2
		var cy := y + cell / 2
		var thick := cell * 0.22
		if kind == 4:
			rr(x + cell * 0.15, y + cell * 0.15, cell * 0.7, cell * 0.7, W8_WATER if w else Color("8a8a7a"), 6)
		if kind == 5 and not flag("socket_in"):
			ring(cx, cy, cell * 0.25, Color("c03a2a"), 3)
		for d in range(4):
			if o & (1 << d):
				var dx: float = [0.0, 1.0, 0.0, -1.0][d]
				var dy: float = [-1.0, 0.0, 1.0, 0.0][d]
				ln(cx, cy, cx + dx * cell / 2, cy + dy * cell / 2, col, thick)
		if o != 0:
			c(cx, cy, thick * 0.6, col)
	# Inlet and outlet.
	ln(x0 - 20, y0 + cell / 2, x0, y0 + cell / 2, W8_WATER if flag("engine_on") else W8_IRON_HI, cell * 0.22)
	ln(x0 + cell * 3.5, y0 + cell * 4, x0 + cell * 3.5, y0 + cell * 4 + 16, W8_WATER if st.get("out", false) else W8_IRON_HI, cell * 0.22)


func _wanet() -> void:
	board(W8_TILE)
	_wa_grid(Set8Views.NET_X, Set8Views.NET_Y, Set8Views.NET_CELL)


func _watable() -> void:
	board(Color("6a4a2a"))
	r(60, 300, 840, 160, Color("f0f0f0"))
	if not flag("got_horn"):
		ci.draw_arc(Vector2(250, 280), 70, PI, TAU * 0.98, 20, W8_BRASS, 24, true)
		poly([310, 270, 360, 220, 370, 300], W8_BRASS)
	rr(440, 30, 460, 400, PAPER, 4)
	_s8_text(462, 66, 420, "watext.speech", 17, INK)


func _wawindow() -> void:
	board(W8_TILE)
	_wa_square(40, 20, 880, 440)


func _wajets() -> void:
	board(W8_TILE)
	var jets: Array = st.get("jets", [0, 0, 0])
	for i in range(3):
		var x := 240 + i * 240.0
		ring(x, 268, 60, W8_IRON, 12)
		rr(x - 30, 238, 60, 80, CREAM, 6)
		txt(x, 292, str(int(jets[i])), 44, INK)
		_s8_arrows(x, 260)


# --- The 8:15 to Nowhere -------------------------------------------------------------

func _rc_wall() -> void:
	r(0, 0, 960, 372, R8_PANEL)
	for i in range(0, 960, 120):
		r(i, 0, 6, 372, R8_PANEL_D)
	r(0, 372, 960, 100, R8_PANEL_D)


func _rc_ran() -> float:
	var runs := int(st.get("runs", [0])[0])
	if runs != _r8_runs:
		if _r8_runs != -1:
			_r8_run_t = t
		_r8_runs = runs
	return t - _r8_run_t


func _rc1() -> void:
	_rc_wall()
	var since := _rc_ran()
	r(40, 30, 200, 100, Color("c8a878"))
	r(60, 46, 80, 60, PAPER)
	r(290, 30, 120, 140, Color("2a1a10"))
	c(350, 90, 30, Color("d8b890"))
	r(860, 150, 80, 100, Color("2a1a10"))
	# The layout on its table.
	r(40, 200, 800, 172, R8_BAIZE)
	r(40, 372, 800, 20, R8_PANEL_D)
	ln(60, 330, 820, 330, R8_RAIL, 4)
	# Station with its clock tower, controller, turntable, yard, dairy, tunnel.
	r(80, 190, 100, 50, Color("c8b48a"))
	r(140, 150, 30, 60, Color("c8b48a"))
	c(155, 162, 10, CREAM)
	rr(60, 290, 180, 80, Color("2a2a2a"), 6)
	c(100, 320, 8, Color("3a9a4a") if flag("powered") else Color("4a1a1a"))
	ring(345, 300, 60, R8_RAIL, 4)
	var turn := int(st.get("turn", [0])[0])
	var deck := -PI / 2 + turn * PI / 5
	ln(345 - cos(deck) * 58, 300 - sin(deck) * 58, 345 + cos(deck) * 58, 300 + sin(deck) * 58, R8_RAIL, 6)
	for k in range(4):
		var a := -PI / 2 + (k + 1) * PI / 5
		rr(345 + cos(a) * 70 - 10, 300 + sin(a) * 70 - 7, 20, 14, R8_ENGINES[k], 3)
	var yard := _rc_tracks()
	for k in range(3):
		ln(460, 270 + k * 34, 660, 270 + k * 34, R8_RAIL, 3)
		for q in range(yard[k].size()):
			rr(470 + q * 44, 262 + k * 34, 38, 16, R8_WAGONS[int(yard[k][q])], 3)
	r(520, 160, 90, 60, Color("e8e0d0"))
	poly([510, 160, 565, 130, 620, 160], Color("8a2a2a"))
	r(730, 200, 100, 170, Color("4a3a2a"))
	ci.draw_arc(Vector2(780, 330), 34, PI, TAU, 12, Color("1a1a1a"), 40, true)
	# A train on its way.
	if since < 5.0:
		var tx := 100 + since * 150.0
		rr(tx, 318, 34, 22, R8_ENGINES[maxi(0, turn - 1) % 4], 4)
		c(tx + 34, 324, 4, Color(1, 0.9, 0.6))
		for k in range(3):
			c(tx + 10 - k * 8, 300 - k * 12 - since * 4, 6 + k * 2, Color(1, 1, 1, 0.5))


func _rc_tracks() -> Array:
	var cells: Array = st.get("yard", [])
	var caps: Array = clues.get("caps", [3, 3, 2])
	var out := []
	var at := 0
	for cap in caps:
		var row := []
		for k in range(int(cap)):
			if at + k < cells.size() and int(cells[at + k]) != 0:
				row.append(int(cells[at + k]))
		out.append(row)
		at += int(cap)
	return out


func _rc_passes_tunnel() -> bool:
	return str(st.get("dest", "")) in ["post", "loop", "gap", "nowhere"]


func _rc2() -> void:
	_rc_wall()
	var since := _rc_ran()
	r(0, 220, 960, 152, R8_BAIZE_D)
	# The tunnel mouth and its sign (lit by a passing engine's lamp).
	ci.draw_arc(Vector2(110, 330), 50, PI, TAU, 12, Color("1a1a1a"), 60, true)
	r(40, 70, 150, 110, Color("3a2a1a"))
	if since < 5.0 and _rc_passes_tunnel():
		_rc_sign_face(115, 125, 0.4)
	# Points and the post office.
	ln(40, 330, 360, 330, R8_RAIL, 4)
	ln(200, 330, 360, 290, R8_RAIL, 4)
	r(250, 240, 90, 50, Color("e8d060"))
	# Bookcase.
	r(390, 30, 220, 340, R8_PANEL_D)
	for k in range(8):
		r(400 + k * 25, 80 + (k % 2) * 6, 20, 90, Color.from_hsv(k * 0.13, 0.5, 0.6))
		r(400 + k * 25, 230, 20, 90, Color.from_hsv(k * 0.17 + 0.3, 0.4, 0.5))
	if flag("branch_open"):
		r(650, 60, 270, 150, R8_BAIZE)
		ln(650, 160, 920, 160, R8_RAIL, 4)
		r(780, 150, 40, 40, Color("3a6ab0") if not flag("bridge_in") else Color("a02a2a"))
		r(860, 110, 50, 40, Color("e8e0d0"))
	# Workbench.
	r(640, 300, 290, 70, Color("8a6a4a"))
	if not flag("got_notes"):
		r(680, 280, 80, 30, PAPER)
	if not flag("got_board"):
		rr(800, 280, 70, 24, Color("1e1e22"), 3)
	if since < 5.0 and _rc_passes_tunnel():
		var tx := 60 + since * 120.0
		rr(tx, 318, 34, 22, R8_ENGINES[maxi(0, int(st.get("turn", [0])[0]) - 1) % 4], 4)


## The sign: a book's spine and the shelf's place for it.
func _rc_sign_face(x: float, y: float, s: float) -> void:
	c(x, y, 140 * s, Color(1, 0.92, 0.6, 0.35))
	var book := int(clues.get("book", 0))
	for k in range(8):
		var lit: bool = k == book
		r(x - 150 * s + k * 38 * s, y - 80 * s, 30 * s, 160 * s, Color("a02a2a") if lit else Color(1, 1, 1, 0.08))
	r(x - 150 * s + book * 38 * s + 5 * s, y, 20 * s, 8 * s, BRASS)


func _rcstation() -> void:
	board(R8_BAIZE)
	r(120, 240, 720, 160, Color("c8b48a"))
	r(420, 40, 140, 280, Color("c8b48a"))
	c(490, 100, 50, CREAM)
	ln(490, 100, 490, 64, INK, 4)
	ln(490, 100, 516, 112, INK, 4)
	if not flag("got_key"):
		r(470, 150, 40, 60, Color("2a1a10"))
		item("rckey", 490, 186, 2.0)
		home()


func _rccontrol() -> void:
	board(R8_PANEL_D)
	rr(100, 30, 760, 410, Color("2a2a2a"), 10)
	if not flag("powered"):
		c(480, 100, 20, Color("4a1a1a"))
		r(474, 90, 12, 24, Color("0a0a0a"))
	else:
		c(480, 100, 20, Color("3a9a4a"))
	var p: Array = st.get("points1", [0, 0])
	var labels := ["rctext.p1", "rctext.p2"]
	for i in range(2):
		var x := 250 + i * 230.0
		rr(x - 90, 200, 180, 160, Color("4a4a4a"), 8)
		ln(x, 340, x + (40 if int(p[i]) == 1 else -40), 230, CREAM, 10)
		txt(x, 196, tr(labels[i]), 16, CREAM)
	rr(660, 220, 200, 140, Color("c03a2a"), 70)
	txt(760, 300, tr("rctext.run"), 24, CREAM)
	_rc_route(160, 150, 0.3)


## A small diagram of where a run would end, from the points.
func _rc_route(x: float, y: float, s: float) -> void:
	var dest := str(st.get("dest", ""))
	var names := {"yard": "rctext.yard", "dairy": "rctext.dairy", "post": "rctext.post", "loop": "rctext.loop", "gap": "rctext.nowhere", "nowhere": "rctext.nowhere"}
	poly([x + 540 * s, y - 14, x + 556 * s, y - 7, x + 540 * s, y], CREAM)
	txt(x + 566 * s, y, tr(names.get(dest, "rctext.yard")), 18, CREAM, false)


func _rcturntable() -> void:
	board(R8_BAIZE)
	c(400, 200, 160, R8_BAIZE_D)
	ring(400, 200, 160, R8_RAIL, 6)
	var turn := int(st.get("turn", [0])[0])
	var deck := -PI / 2 + turn * PI / 5
	ln(400 - cos(deck) * 155, 200 - sin(deck) * 155, 400 + cos(deck) * 155, 200 + sin(deck) * 155, R8_PANEL_D, 22)
	ln(400 - cos(deck) * 155, 200 - sin(deck) * 155, 400 + cos(deck) * 155, 200 + sin(deck) * 155, R8_RAIL, 6)
	for k in range(4):
		var x := 130 + k * 160.0
		rr(x - 60, 340, 120, 70, R8_ENGINES[k], 8)
		c(x - 40, 420, 12, Color("1a1a1a"))
		c(x + 40, 420, 12, Color("1a1a1a"))
		txt(x, 330, str(k + 1), 20, CREAM)
		if flag("engine_ok") and k == 3:
			rr(x - 36, 350, 72, 26, Color("1e1e22"), 4)
			txt(x, 370, "8:15", 18, CREAM)
	arrow_btn(760, 160, 100, 100, 3)


func _rcyard() -> void:
	board(R8_BAIZE)
	var yard := _rc_tracks()
	var caps: Array = clues.get("caps", [3, 3, 2])
	for a in range(3):
		var y := 105 + a * 130.0
		r(60, y - 6, 640, 12, R8_RAIL)
		r(60, y - 30, 20, 60, Color("8a2a2a"))
		txt(100, y - 36, str(a + 1), 20, CREAM)
		for q in range(int(caps[a])):
			ring(130 + q * 150 + 60, y, 6, Color(1, 1, 1, 0.2), 2)
		for q in range(yard[a].size()):
			var col: Color = R8_WAGONS[int(yard[a][q])]
			rr(130 + q * 150, y - 40, 120, 60, col, 8)
			_rc_cargo(int(yard[a][q]), 190 + q * 150, y - 10)
		var k := 0
		for b in range(3):
			if a != b:
				rr(740 + k * 100.0, 60 + a * 130.0, 86, 90, Color(0, 0, 0, 0.35), 10)
				poly([756 + k * 100.0, 92 + a * 130.0, 776 + k * 100.0, 105 + a * 130.0, 756 + k * 100.0, 118 + a * 130.0], CREAM)
				txt(800 + k * 100.0, 118 + a * 130.0, str(b + 1), 30, CREAM)
				k += 1


func _rc_cargo(kind: int, x: float, y: float) -> void:
	match kind:
		1:
			for q in range(3):
				r(x - 40 + q * 28, y - 16, 20, 16, Color("ffe8a0"))
		2:
			r(x - 20, y - 14, 40, 26, CREAM)
			ln(x - 20, y - 14, x, y, INK, 2)
			ln(x + 20, y - 14, x, y, INK, 2)
		3:
			for q in range(4):
				c(x - 24 + q * 16, y - 12, 9, Color("101010"))
		4:
			for q in range(3):
				r(x - 40, y - 20 + q * 10, 80, 8, Color("c09060"))
		_:
			rr(x - 40, y - 20, 80, 30, Color("2a4a6a"), 14)


func _rcpoints() -> void:
	board(R8_PANEL_D)
	rr(60, 20, 840, 150, R8_BAIZE, 8)
	r(120, 40, 120, 80, Color("e8d060"))
	txt(180, 150, tr("rctext.post"), 16, INK)
	ln(260, 110, 880, 110, R8_RAIL, 4)
	var p: Array = st.get("points2", [0, 0])
	var labels := ["rctext.p3", "rctext.p4"]
	for i in range(2):
		var x := 270 + i * 240.0
		rr(x - 90, 200, 180, 160, Color("4a4a4a"), 8)
		ln(x, 340, x + (40 if int(p[i]) == 1 else -40), 230, CREAM, 10)
		txt(x, 196, tr(labels[i]), 16, CREAM)
	rr(680, 220, 200, 140, Color("c03a2a"), 70)
	txt(780, 300, tr("rctext.run"), 24, CREAM)
	_rc_route(180, 400, 0.3)


func _rcsign() -> void:
	board(Color("1a1410"))
	var since := _rc_ran()
	r(80, 30, 600, 400, Color("2a2018"))
	if since < 5.0 and _rc_passes_tunnel():
		_rc_sign_face(380, 230, 1.6)
	rr(720, 300, 200, 130, Color("c03a2a"), 60)
	txt(820, 375, tr("rctext.run"), 22, CREAM)


func _rcshelf() -> void:
	board(R8_PANEL_D)
	r(90, 70, 780, 340, Color("3a2414"))
	for i in range(8):
		var x := 110 + i * 92.0
		var col := Color("a02a2a") if i == 5 else Color.from_hsv(i * 0.13 + 0.05, 0.45, 0.55)
		if flag("branch_open") and i == 5:
			continue
		r(x, 90 + (i % 3) * 8, 80, 300 - (i % 3) * 8, col)
		r(x + 30, 200, 20, 8, BRASS)
	if flag("branch_open"):
		r(110 + 5 * 92, 90, 80, 300, Color("0a0a0a"))


func _rcbench() -> void:
	board(R8_PANEL)
	r(40, 140, 880, 320, Color("8a6a4a"))
	if flag("got_notes"):
		rr(80, 20, 480, 420, PAPER, 4)
		_s8_text(100, 54, 440, "rctext.notes", 16, INK)
	else:
		rr(80, 160, 340, 240, PAPER, 4)
		for k in range(8):
			r(100, 190 + k * 24, 300, 3, Color(INK, 0.4))
	if not flag("got_board"):
		rr(600, 260, 280, 120, Color("1e1e22"), 10)
		txt(740, 340, "8:15", 52, CREAM)


func _rcgap() -> void:
	board(R8_BAIZE)
	r(120, 60, 720, 360, R8_BAIZE_D)
	ln(120, 240, 400, 240, R8_RAIL, 10)
	ln(560, 240, 840, 240, R8_RAIL, 10)
	r(400, 250, 160, 170, Color("3a6ab0"))
	if flag("bridge_in"):
		r(390, 226, 180, 30, Color("a02a2a"))
	r(700, 140, 120, 80, Color("e8e0d0"))
	txt(760, 190, "?", 30, INK)


# --- Harvest Moon -----------------------------------------------------------------

func _mi_inside() -> void:
	r(0, 0, 960, 372, M8_WOOD)
	for i in range(0, 960, 60):
		r(i, 0, 5, 372, M8_WOOD_D)
	r(0, 372, 960, 100, M8_WOOD_D)
	for k in range(14):
		c(fmod(k * 73.0 + t * 6.0, 960), fmod(k * 41.0 + t * 9.0, 372), 1.5, Color(M8_FLOUR, 0.6))


func _mi_turning() -> bool:
	return flag("turning")


func _mi1() -> void:
	_mi_inside()
	# Sacks (the handle under them).
	for k in range(5):
		poly([40 + k * 58, 370, 90 + k * 58, 370, 96 + k * 58, 250, 64 + k * 58, 232, 46 + k * 58, 250], Color("c8a878"))
	# Brake rope, hoist with trapdoor, chute and bins, the half-door.
	ln(375, 30, 375 + (4.0 * sin(t * 3.0) if _mi_turning() else 0.0), 370, Color("c8b898"), 6)
	r(420, 30, 170, 20, M8_WOOD_D)
	ln(505, 50, 505, 200, Color("6a6a6a"), 4)
	ci.draw_arc(Vector2(505, 210), 12, 0, PI, 8, Color("6a6a6a"), 4, true)
	r(430, 240, 150, 20, Color("4a3020") if int(st.get("traps", [0])[0]) == 0 else Color("1a1008"))
	r(670, 50, 50, 230, M8_WOOD_D)
	if flag("ground"):
		r(686, 50, 18, 230, Color(M8_FLOUR, 0.7))
	poly([620, 370, 700, 370, 700, 290, 620, 290], M8_FLOUR if not flag("got_flour") else Color(0, 0, 0, 0))
	poly([710, 370, 780, 370, 780, 300, 710, 300], Color("b08a5a") if not flag("got_bran") else Color(0, 0, 0, 0))
	r(800, 50, 140, 320, M8_WOOD_D)
	r(810, 60, 120, 140, M8_SKY)
	c(870, 130, 26, Color("e8c8a0"))


func _mi2() -> void:
	_mi_inside()
	# Winding wheel.
	var cap := int(st.get("cap", [0])[0])
	ring(120, 140, 80, M8_WOOD_D, 10)
	for k in range(6):
		var a := k * PI / 3 + cap * PI / 4
		ln(120, 140, 120 + cos(a) * 78, 140 + sin(a) * 78, M8_WOOD_D, 6)
	if flag("crank_on"):
		r(190, 130, 30, 12, M8_WOOD_D)
	# The window onto the sails.
	_mi_view(240, 30, 300, 200, 0.4)
	# Millstones and gears.
	r(240, 300, 300, 70, M8_STONE)
	var turning := flag("gears_ok")
	var sa := t * 4.0 if turning else 0.0
	for k in range(6):
		ln(390, 335, 390 + cos(sa + k) * 120, 335 + sin(sa + k) * 24, Color("8a847c"), 2)
	ring(300, 270, 26, M8_WOOD_D, 8)
	ring(480, 270, 26, M8_WOOD_D, 8)
	# Clutch, slate, song board.
	r(620, 200, 20, 170, M8_WOOD_D)
	ln(630, 330, 630 + (30 if int(st.get("clutch", [0])[0]) == 1 else -30), 220, Color("6a6a6a"), 8)
	r(720, 40, 210, 170, Color("2a2a2a"))
	for k in range(5):
		r(740, 70 + k * 26, 170, 3, Color(1, 1, 1, 0.5))
	r(720, 230, 210, 140, Color("c8a878"))
	for k in range(4):
		r(740, 260 + k * 24, 170, 3, Color(INK, 0.5))


## Through the window: fields, poplars bending in gusts, the moon, the sails.
func _mi_view(x: float, y: float, w: float, h: float, s: float) -> void:
	r(x, y, w, h, M8_SKY)
	r(x, y, w, h * 0.35, M8_SKY_HI)
	r(x, y + h * 0.75, w, h * 0.25, M8_FIELD)
	c(x + w * 0.85, y + h * (0.72 - 0.04 * sin(t * 0.2)), h * 0.1, Color("fff2c0"))
	var gust := fmod(t, 8.0) < 2.0
	for k in range(3):
		var px := x + w * (0.6 + k * 0.08)
		var bend := (10.0 * s * 2.5) if gust else 2.0
		poly([px - 6, y + h * 0.76, px + 6, y + h * 0.76, px + bend + 3, y + h * 0.35, px + bend - 3, y + h * 0.35], Color("4a6a2a"))
	if gust:
		for k in range(8):
			var lx := x + w * 0.62 + fmod(t * 120.0 + k * 31.0, w * 0.35)
			c(lx, y + h * (0.4 + 0.03 * k), 3, Color("8a9a2a"))
	# The sails: turning once the brake is off.
	var sa := t * 1.4 if _mi_turning() else 0.3
	var cx := x + w * 0.3
	var cy := y + h * 0.4
	var cloth: Array = st.get("cloth", [0, 0, 0, 0])
	for k in range(4):
		var a := sa + k * PI / 2
		var ex := cx + cos(a) * h * 0.38
		var ey := cy + sin(a) * h * 0.38
		ln(cx, cy, ex, ey, Color("5a3a24"), 4)
		var amount := int(cloth[k]) / 2.0
		if amount > 0:
			var nx := -sin(a) * h * 0.08 * amount
			var ny := cos(a) * h * 0.08 * amount
			poly([cx + cos(a) * h * 0.1, cy + sin(a) * h * 0.1, ex, ey, ex + nx, ey + ny, cx + cos(a) * h * 0.1 + nx, cy + sin(a) * h * 0.1 + ny], Color(1, 1, 1, 0.7))
		# The tip's small sun or moon.
		var sun: Array = clues.get("sun", [0, 2])
		var is_sun := false
		for v in sun:
			if int(v) == k:
				is_sun = true
		if is_sun:
			c(ex, ey, 4 * s * 2.5, Color("f8c830"))
		else:
			c(ex, ey, 4 * s * 2.5, Color("e8e8f0"))
			c(ex + 2 * s * 2.5, ey - 1, 3.4 * s * 2.5, M8_SKY)


func _misacks() -> void:
	board(M8_WOOD_D)
	var marks := ["barn", "cow", "apple", "well", "oak"]
	var loaded := int(st.get("loaded", [0])[0])
	for i in range(5):
		var x := 135 + i * 172.0
		poly([x - 70, 420, x + 70, 420, x + 76, 200, x + 30, 170, x - 30, 170, x - 76, 200], Color("c8a878"))
		_mi_mark(marks[i], x, 300)
	if not flag("got_crank"):
		r(420, 400, 160, 20, M8_WOOD)
		r(560, 380, 20, 40, M8_WOOD)
	txt(480, 40, "%d / 3" % loaded if flag("hoist_ready") else "", 24, CREAM)


func _mi_mark(mark: String, x: float, y: float) -> void:
	var col := Color("5a3a24")
	match mark:
		"barn":
			poly([x - 24, y + 20, x + 24, y + 20, x + 24, y - 6, x, y - 24, x - 24, y - 6], col)
		"cow":
			c(x, y, 18, col)
			c(x - 18, y - 16, 7, col)
			c(x + 18, y - 16, 7, col)
		"apple":
			c(x, y + 4, 18, Color("a02a2a"))
			ln(x, y - 14, x + 6, y - 24, col, 3)
		"well":
			ring(x, y, 18, col, 5)
			ln(x - 22, y - 22, x + 22, y - 22, col, 4)
		_:
			c(x, y - 8, 20, Color("4a6a2a"))
			r(x - 4, y + 8, 8, 18, col)


func _mihoist() -> void:
	board(M8_WOOD)
	ln(310, 30, 310, 300, Color("6a6a6a"), 8)
	ci.draw_arc(Vector2(310, 320), 30, 0, PI, 10, Color("6a6a6a"), 8, true)
	var open := int(st.get("traps", [0])[0]) == 1
	r(80, 400, 460, 40, Color("1a1008") if open else M8_WOOD_D)
	rr(600, 160, 220, 200, M8_WOOD_D, 8)
	ln(710, 340, 710 + (50 if open else -50), 190, Color("c8b898"), 12)
	if flag("hoist_ready"):
		c(310, 120, 12, Color("3a9a4a"))


## The chute's flaps: the top one sends the meal to the sieve, which splits
## fine flour (left flap) from bran (right flap).
static func flap_rect(i: int) -> Rect2:
	return [Rect2(410, 70, 140, 80), Rect2(230, 210, 140, 80), Rect2(590, 210, 140, 80)][i]


func _michute() -> void:
	board(M8_WOOD_D)
	var flaps: Array = st.get("flaps", [0, 0, 0])
	var flowing := flag("hoisted") and flag("gears_ok")
	var flour := Color(M8_FLOUR, 0.85)
	var bran := Color("c09a6a")
	# The sieve between the top flap and the two lower ones.
	rr(400, 160, 160, 34, M8_WOOD, 6)
	for k in range(8):
		ln(410 + k * 18, 166, 410 + k * 18, 188, M8_WOOD_D, 2)
	for i in range(3):
		var rect := flap_rect(i)
		rr(rect.position.x, rect.position.y, rect.size.x, rect.size.y, M8_WOOD, 8)
		var cx := rect.position.x + rect.size.x / 2
		var cy := rect.position.y + rect.size.y / 2
		var right := int(flaps[i]) == 1
		ln(cx - 40, cy - 24 if right else cy + 24, cx + 40, cy + 24 if right else cy - 24, CREAM, 10)
	poly([120, 450, 320, 450, 330, 340, 110, 340], M8_FLOUR if not flag("got_flour") else Color(0, 0, 0, 0))
	poly([640, 450, 840, 450, 850, 340, 630, 340], Color("b08a5a") if not flag("got_bran") else Color(0, 0, 0, 0))
	if flowing and not flag("ground"):
		ln(480, 20, 480, 80, flour, 8)
		if int(flaps[0]) == 1:
			ln(520, 140, 480, 170, flour, 8)
			ln(440, 190, 300, 230, flour, 6)
			ln(520, 190, 660, 230, bran, 6)
			ln(300, 280, 220 if int(flaps[1]) == 0 else 360, 380 if int(flaps[1]) == 0 else 450, flour, 6)
			ln(660, 280, 740 if int(flaps[2]) == 1 else 600, 380 if int(flaps[2]) == 1 else 450, bran, 6)
		else:
			ln(440, 140, 380, 450, flour, 8)
	if flag("ground") and not flag("got_flour"):
		c(220, 345, 40, Color(1, 1, 1, 0.7))
	# Spilt flour where a flap sends it astray.
	if flowing and not flag("ground"):
		for k in range(6):
			c(380 + k * 40, 452, 14, Color(M8_FLOUR, 0.5))


func _midoor() -> void:
	if int(st.get("talk", [0])[0]) != 0:
		_s8_talk("greta")
		return
	board(M8_WOOD)
	r(60, 40, 260, 380, M8_WOOD_D)
	r(80, 60, 220, 180, M8_SKY)
	c(190, 160, 44, Color("e8c8a0"))
	poly([120, 240, 260, 240, 250, 200, 130, 200], Color("6a3a5a"))
	# The loading door with its counterweight chain, the cart outside.
	r(380, 250, 200, 200, M8_WOOD_D if not flag("door_open") else M8_SKY)
	ln(460, 40, 460, 230, Color("6a6a6a"), 4)
	if flag("door_open"):
		poly([440, 200, 480, 200, 486, 160, 434, 160], Color("b08a5a"))
	else:
		ci.draw_arc(Vector2(460, 230), 10, 0, PI, 8, Color("6a6a6a"), 4, true)
	r(600, 340, 320, 80, Color("7a4a2a"))
	c(650, 430, 24, Color("3a2a1a"))
	c(870, 430, 24, Color("3a2a1a"))


func _miwheel() -> void:
	board(M8_WOOD)
	var cap := int(st.get("cap", [0])[0])
	ring(480, 220, 180, M8_WOOD_D, 16)
	for k in range(8):
		var a := k * PI / 4 + cap * PI / 4
		ln(480, 220, 480 + cos(a) * 176, 220 + sin(a) * 176, M8_WOOD_D, 8)
	if flag("crank_on"):
		r(640, 210, 70, 24, M8_WOOD_D)
		c(712, 222, 14, M8_WOOD)
	# The cap's direction on a compass rose.
	ring(480, 220, 60, CREAM, 3)
	var a2 := -PI / 2 + cap * PI / 4
	poly([480 + cos(a2) * 56, 220 + sin(a2) * 56, 480 + cos(a2 + 2.6) * 20, 220 + sin(a2 + 2.6) * 20, 480 + cos(a2 - 2.6) * 20, 220 + sin(a2 - 2.6) * 20], Color("c03a2a"))
	txt(480, 145, "N", 20, CREAM)
	txt(480, 420, DIRS8[cap], 28, CREAM)
	arrow_btn(80, 330, 130, 100, 2)
	arrow_btn(750, 330, 130, 100, 3)


func _miwindow() -> void:
	board(M8_WOOD)
	_mi_view(40, 20, 880, 340, 1.0)
	var cloth: Array = st.get("cloth", [0, 0, 0, 0])
	for i in range(4):
		var x := 180 + i * 200.0
		rr(x - 70, 380, 140, 80, M8_WOOD_D, 8)
		r(x - 50, 400, 100, 40, Color(1, 1, 1, 0.15))
		r(x - 50, 400, int(cloth[i]) * 50, 40, Color(1, 1, 1, 0.8))
		txt(x, 455, str(i + 1), 14, CREAM)


func _migears() -> void:
	board(M8_WOOD)
	var rack: Array = clues.get("rack", [12, 16, 24])
	var g: Array = st.get("gears", [0, 0])
	var labels := ["mitext.wallower", "mitext.nut"]
	for i in range(2):
		var x := 240 + i * 300.0
		var teeth := int(rack[int(g[i])])
		var rad := 30 + teeth * 3.0
		var spin := t * (1.0 + i) if flag("turning") else 0.0
		ring(x, 170, rad, M8_WOOD_D, 14)
		for k in range(teeth):
			var a := spin + k * TAU / teeth
			ln(x + cos(a) * rad, 170 + sin(a) * rad, x + cos(a) * (rad + 12), 170 + sin(a) * (rad + 12), M8_WOOD_D, 5)
		txt(x, 176, str(teeth), 30, CREAM)
		txt(x, 46, tr(labels[i]), 16, CREAM)
	# The song painted on the beam, and the stones' count.
	_s8_text(660, 70, 270, "mitext.song", 16, CREAM)
	r(100, 300, 760, 150, M8_STONE)
	var ratio := int(st.get("ratio", 0))
	var sa := t * ratio * 0.2 if flag("turning") else 0.0
	for k in range(8):
		ln(480, 375, 480 + cos(sa + k) * 300, 375 + sin(sa + k) * 50, Color("8a847c"), 3)
	if flag("turning"):
		rr(400, 330, 160, 60, Color(0, 0, 0, 0.5), 8)
		txt(480, 372, "× %d" % ratio, 30, CREAM)
