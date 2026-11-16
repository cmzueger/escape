## Draws the rooms of the third set on top of ArtSet2: Low Tide (B1, B2),
## Night Train (N1, N2) and The Alchemist's Cellar (A1, A2), with their
## close-ups. Hotspots are in views_set3.gd.
class_name ArtSet3
extends ArtSet2

const SAND := Color("e2c890")
const SAND_D := Color("c9ac72")
const SEA_BLUE := Color("4fa8c8")
const HUT_WHITE := Color("f2efe4")
const HUT_BLUE := Color("5f9ac0")
const PANEL := Color("7a4a34")
const PANEL_D := Color("5e3626")
const SEAT_RED := Color("8a2f3a")
const VAULT := Color("4a4a56")
const VAULT_D := Color("3a3a46")
const GOLD := Color("f0c040")


func draw_view(view: String) -> void:
	match view:
		"B1": _b1()
		"B2": _b2()
		"bbox": _bbox()
		"bbottle": _bbottle()
		"kites": _kites()
		"tideclock": _tideclock()
		"bwindow": _bwindow()
		"N1": _n1()
		"N2": _n2()
		"ncase": _ncase()
		"timetable": _timetable()
		"nticket": _nticket()
		"nbrief": _nbrief()
		"npanel": _npanel()
		"A1": _a1()
		"A2": _a2()
		"vials": _vials()
		"abook": _abook()
		"achart": _achart()
		"scales": _scales()
		"disc": _disc()
		"furnace": _furnace()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"corkscrew":
			at(x, y, 0.0, s)
			rr(-14, -16, 28, 8, WOOD_D, 4)
			for k in range(5):
				ln(-5 if k % 2 == 0 else 5, -8 + k * 6, 5 if k % 2 == 0 else -5, -2 + k * 6, STEEL, 3)
		"spade":
			at(x, y, 0.5, s)
			ln(0, -18, 0, 4, WOOD_D, 4)
			poly([-9, 2, 9, 2, 7, 16, 0, 20, -7, 16], STEEL)
		"hand":
			at(x, y, 0.6, s)
			poly([-3, 14, 3, 14, 1, -18, -1, -18], BRASS)
			c(0, 12, 5, BRASS_D)
		"token":
			at(x, y, 0.0, s)
			c(0, 0, 13, BRASS_D)
			c(0, 0, 10, BRASS)
			star5(0, 0, 6, BRASS_D)
		"punch":
			at(x, y, 0.0, s)
			poly([-16, -4, 10, -10, 14, -4, -16, 2], STEEL)
			poly([-16, 4, 10, 10, 14, 4, -16, -2], STEEL.darkened(0.2))
			c(8, 0, 4, IRON_D)
		"brake":
			at(x, y, 0.0, s)
			rr(-5, -18, 10, 30, RED, 4)
			rr(-12, 10, 24, 8, IRON_D, 3)
		"nugget":
			at(x, y, 0.0, s)
			poly([-12, 6, -8, -8, 4, -12, 13, -2, 9, 10, -4, 12], Color("8a8f98"))
			poly([-4, -2, 4, -8, 8, 0, 0, 4], Color("b0b5be"))
		"bellows":
			at(x, y, 0.0, s)
			poly([-14, -10, 8, -4, 8, 4, -14, 10], WOOD_D)
			poly([8, -3, 18, -1, 18, 1, 8, 3], STEEL)
			r(-18, -3, 6, 6, WOOD)
		"crucible":
			at(x, y, 0.0, s)
			poly([-13, -10, 13, -10, 8, 12, -8, 12], Color("c9c2b0"))
			r(-13, -12, 26, 4, Color("a9a290"))
		"elixir":
			at(x, y, 0.0, s)
			poly([-4, -16, 4, -16, 4, -6, 11, 12, -11, 12, -4, -6], Color(0.8, 0.9, 0.95, 0.7))
			poly([-7, 2, 7, 2, 11, 12, -11, 12], paint("orange"))
		"goldkey":
			home()
			at(x, y, 0.0, s)
			ring(-10, 0, 7, GOLD, 4)
			ln(-3, 0, 17, 0, GOLD, 4)
			ln(11, 0, 11, 7, GOLD, 4)
			ln(16, 0, 16, 6, GOLD, 4)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"beach":
			r(0, 0, w, h, Color("9fd4ea"))
			r(0, h * 0.5, w, h * 0.2, SEA_BLUE)
			r(0, h * 0.68, w, h * 0.32, SAND)
			c(w * 0.8, h * 0.22, h * 0.13, Color("fff1a8"))
			for k in range(4):
				r(w * 0.2 + k * w * 0.07, h * 0.3, w * 0.07, h * 0.5, HUT_WHITE if k % 2 == 0 else HUT_BLUE)
			poly([w * 0.17, h * 0.3, w * 0.34, h * 0.1, w * 0.51, h * 0.3], RED)
			star5(w * 0.66, h * 0.84, h * 0.09, Color("e8887a"))
		"train":
			r(0, 0, w, h, Color("141a2e"))
			for i in range(20):
				c(fmod(i * 53.0 + t * 30.0, w), fmod(i * 29.0, h * 0.5), 1.2, Color(1, 1, 1, 0.6))
			rr(w * 0.06, h * 0.36, w * 0.88, h * 0.4, Color("3a5a4a"), 8)
			for k in range(4):
				rr(w * 0.12 + k * w * 0.2, h * 0.44, w * 0.14, h * 0.18, Color("ffd98a"), 3)
			r(0, h * 0.82, w, 4, STEEL)
			for k in range(3):
				c(w * 0.2 + k * w * 0.3, h * 0.8, h * 0.07, IRON_D)
		"alch":
			r(0, 0, w, h, Color("2a2a36"))
			c(w * 0.5, h * 0.62, h * 0.6, Color(0.4, 0.9, 0.5, 0.14))
			poly([w * 0.44, h * 0.2, w * 0.56, h * 0.2, w * 0.56, h * 0.46, w * 0.72, h * 0.88, w * 0.28, h * 0.88, w * 0.44, h * 0.46], Color(0.8, 0.9, 0.95, 0.5))
			poly([w * 0.38, h * 0.62, w * 0.62, h * 0.62, w * 0.72, h * 0.88, w * 0.28, h * 0.88], Color("4fd07a"))
			for k in range(3):
				c(w * 0.44 + k * w * 0.06, h * 0.5 - fmod(t * 14.0 + k * 9.0, h * 0.3), 3, Color(0.5, 0.95, 0.6, 0.7))
			sign_of("sun", w * 0.16, h * 0.3, h / 90.0, GOLD)
			sign_of("moon", w * 0.84, h * 0.3, h / 90.0, SILVER)
		_:
			super.card(room, w, h)


# === Low Tide ========================================================================

func shell(kind: String, x: float, y: float, s: float) -> void:
	match kind:
		"spiral":
			c(x, y, 11 * s, Color("e8b89a"))
			ci.draw_arc(Vector2(x, y), 6 * s, 0.5, 5.0, 12, Color("a8684a"), 2.5 * s, true)
			poly([x + 8 * s, y - 4 * s, x + 20 * s, y, x + 8 * s, y + 6 * s], Color("e8b89a"))
		"scallop":
			var fan := [x, y + 9 * s]
			for k in range(9):
				var a := PI + PI * k / 8.0
				fan.append_array([x + cos(a) * 14 * s, y + 4 * s + sin(a) * 14 * s])
			poly(fan, Color("f0d8e0"))
			for k in range(1, 8):
				var a2 := PI + PI * k / 8.0
				ln(x, y + 8 * s, x + cos(a2) * 13 * s, y + 4 * s + sin(a2) * 13 * s, Color("c890a8"), 1.5 * s)
		_:
			star5(x, y, 13 * s, Color("e8703a"))
			c(x, y, 3 * s, Color("f6a070"))


func _hut(sea: bool) -> void:
	for i in range(16):
		r(i * 60.0, 0, 60, 372, HUT_WHITE if i % 2 == 0 else HUT_BLUE.lightened(0.45))
	r(0, 0, 960, 14, HUT_BLUE)
	r(0, 372, 960, 100, SAND_D)
	for i in range(8):
		r(i * 128.0, 372, 3, 100, SAND_D.darkened(0.12))
	r(0, 366, 960, 8, HUT_BLUE)
	if sea:
		pass


func _shells(wall: String, spots: Dictionary) -> void:
	for entry in clues.get("shells", []):
		var places: Array = spots.get(entry["kind"], [])
		for k in range(mini(int(entry[wall]), places.size())):
			shell(entry["kind"], places[k][0], places[k][1], 1.0)


func _b1() -> void:
	_hut(false)
	# Locker.
	rr(40, 150, 150, 226, HUT_BLUE, 4)
	if flag("locker_open"):
		r(50, 160, 130, 206, Color("2a3a48"))
		if not flag("got_locker"):
			item("spade", 96, 290, 2.2)
			item("hand", 150, 300, 1.6)
	else:
		r(113, 160, 4, 206, HUT_BLUE.darkened(0.2))
		rr(102, 250, 26, 30, BRASS, 4)
	# Buoys on the wall.
	var buoy := [RED, Color("f0efe6"), Color("e8c23a")]
	for k in range(3):
		ln(250 + k * 50.0, 14, 250 + k * 50.0, 70, Color("c8a66a"), 3)
		c(250 + k * 50.0, 90, 20, buoy[k])
		r(232 + k * 50.0, 86, 36, 8, Color("2a3a48"))
	# Shelf with the ship in a bottle.
	rr(250, 230, 400, 12, WOOD, 3)
	rr(400, 196, 100, 34, Color(0.75, 0.92, 0.9, 0.6), 16)
	r(496, 206, 22, 14, Color("8a6a3a") if not flag("bottle_open") else Color(0, 0, 0, 0))
	poly([426, 222, 474, 222, 468, 228, 432, 228], WOOD_D)
	poly([450, 200, 450, 222, 468, 222], PAPER)
	# The tide clock.
	c(730, 150, 54, HUT_BLUE.darkened(0.2))
	c(730, 150, 46, PAPER)
	if flag("hand_on"):
		var a := TAU * float(st.get("tide", [0])[0]) / 6.0 - PI / 2
		ln(730, 150, 730 + cos(a) * 36, 150 + sin(a) * 36, BRASS_D, 5)
	c(730, 150, 5, INK)
	_shells("b1", {"spiral": [[280, 218], [330, 218], [600, 218]], "scallop": [[560, 216]], "star": [[240, 420], [700, 410], [520, 440], [330, 400]]})
	# Towel and the door.
	poly([196, 150, 236, 150, 236, 260, 196, 250], Color("e8887a"))
	r(840, 104, 110, 272, HUT_BLUE.darkened(0.15))
	r(850, 114, 90, 252, HUT_BLUE)
	c(866, 250, 8, BRASS)


func _b2() -> void:
	_hut(true)
	# The window on the sea.
	rr(80, 60, 380, 230, HUT_BLUE.darkened(0.15), 4)
	r(94, 74, 352, 202, Color("9fd4ea"))
	r(94, 190, 352, 86, SEA_BLUE)
	for k in range(5):
		ln(110 + k * 70.0 + 10 * sin(t + k), 210 + k % 2 * 24.0, 150 + k * 70.0 + 10 * sin(t + k), 210 + k % 2 * 24.0, Color(1, 1, 1, 0.5), 2)
	r(330, 120, 10, 156, WOOD_D)
	r(266, 74, 6, 202, HUT_BLUE.darkened(0.15))
	# Kites under the roof.
	var kites: Array = clues.get("kites", [])
	for k in range(kites.size()):
		var kx := 560.0 + k * 120.0
		poly([kx, 40, kx + 26, 80, kx, 130, kx - 26, 80], paint(kites[(k + 1) % kites.size()]))
		ln(kx, 130, kx + 20 * sin(k * 2.0), 200, INK.lightened(0.3), 1.5)
	# Bench with the shell box.
	rr(520, 300, 380, 12, WOOD, 3)
	r(534, 312, 10, 64, WOOD_D)
	r(876, 312, 10, 64, WOOD_D)
	rr(600, 256, 110, 44, Color("3d7a8a"), 5)
	rr(640, 268, 30, 20, BRASS, 3)
	_shells("b2", {"spiral": [[770, 288]], "scallop": [[840, 286]], "star": [[560, 286], [480, 420], [730, 430], [860, 400], [420, 440]]})
	# The patch of sand with its little flag.
	ci.draw_set_transform(Vector2(240, 430), 0.0, Vector2(1.0, 0.32))
	c(0, 0, 120, SAND)
	home()
	if flag("dug"):
		rr(206, 410, 68, 36, STEEL.darkened(0.2), 5)
		c(240, 428, 7, Color("14100c") if not flag("tin_open") else BRASS)
	else:
		ln(240, 430, 240, 392, WOOD_D, 3)
		poly([240, 392, 266, 400, 240, 408], RED)
	# A fishing net.
	for k in range(5):
		ln(900 - k * 14.0, 20, 940, 60 + k * 30.0, Color(0.3, 0.4, 0.4, 0.5), 1.5)


func _bbox() -> void:
	board(Color("3d7a8a"))
	rr(160, 30, 640, 420, Color("2f6270"), 10)
	if flag("box_open"):
		rr(220, 80, 520, 330, Color("14262c"), 6)
		if not flag("got_box"):
			item("corkscrew", 480, 250, 4.0)
	else:
		rr(310, 54, 340, 90, BRASS, 5)
		var k := 0
		for entry in clues.get("shells", []):
			shell(entry["kind"], 380.0 + k * 100.0, 100, 1.6)
			k += 1
		kit_wheels(st.get("box", [0, 0, 0]), 400, 270)


func _bbottle() -> void:
	board(Color("5f9ac0"))
	if flag("bottle_open"):
		# The paper that was rolled up inside: one kite.
		rr(300, 40, 360, 400, PAPER, 6)
		var col := paint(clues.get("wanted_kite", ""))
		poly([480, 90, 560, 210, 480, 350, 400, 210], col)
		ln(480, 90, 480, 350, INK, 3)
		ln(400, 210, 560, 210, INK, 3)
		ln(480, 350, 500, 420, INK, 2)
	else:
		rr(220, 150, 440, 180, Color(0.75, 0.92, 0.9, 0.6), 80)
		rr(650, 200, 90, 80, Color(0.75, 0.92, 0.9, 0.6), 10)
		rr(730, 210, 60, 60, Color("8a6a3a"), 8)
		poly([330, 290, 550, 290, 520, 316, 360, 316], WOOD_D)
		poly([440, 180, 440, 288, 530, 288], PAPER)
		poly([430, 200, 430, 288, 360, 288], PAPER.darkened(0.08))
		rr(456, 226, 50, 30, Color(1, 1, 1, 0.9), 3)


## Where the kite of each hook hangs (the strings cross).
const KITE_AT := [1, 2, 0]


func _kites() -> void:
	board(Color("9fd4ea"))
	var kites: Array = clues.get("kites", [])
	for i in range(kites.size()):
		var hook_x := 300.0 + i * 180.0
		var kite_x: float = 300.0 + KITE_AT[i] * 180.0
		var string := PackedVector2Array()
		for k in range(13):
			var f := k / 12.0
			string.append(Vector2(lerpf(hook_x, kite_x, f * f * (3 - 2 * f)) + 30 * sin(f * PI * 2 + i), lerpf(400, 150, f)))
		ci.draw_polyline(string, INK.lightened(0.2), 2.5, true)
		var down: bool = flag("kite_down") and kites[i] == clues.get("wanted_kite", "")
		if not down:
			poly([kite_x, 40, kite_x + 40, 100, kite_x, 170, kite_x - 40, 100], paint(kites[i]))
			ln(kite_x, 40, kite_x, 170, INK, 2)
			ln(kite_x - 40, 100, kite_x + 40, 100, INK, 2)
		rr(hook_x - 34, 396, 68, 56, WOOD_D, 8)
		ci.draw_arc(Vector2(hook_x, 420), 12, 0, PI, 10, BRASS, 5, true)


func _tideclock() -> void:
	board(Color("5f9ac0"))
	c(400, 236, 196, HUT_BLUE.darkened(0.25))
	c(400, 236, 180, PAPER)
	for k in range(6):
		var a := TAU * k / 6.0 - PI / 2
		txt(400 + cos(a) * 140, 236 + sin(a) * 140 + 12, str(k + 1), 34, INK)
		for w in range(k + 1):
			ci.draw_arc(Vector2(400 + cos(a) * 96 - 4, 244 + sin(a) * 96 - w * 5), 5, PI, TAU, 6, SEA_BLUE, 2, true)
	if flag("hand_on"):
		var a2 := TAU * float(st.get("tide", [0])[0]) / 6.0 - PI / 2
		poly([400 + cos(a2) * 120, 236 + sin(a2) * 120, 400 + cos(a2 + 1.4) * 12, 236 + sin(a2 + 1.4) * 12, 400 + cos(a2 - 1.4) * 12, 236 + sin(a2 - 1.4) * 12], BRASS_D)
		arrow_btn(60, 200, 96, 76, 2)
		arrow_btn(644, 200, 96, 76, 3)
	c(400, 236, 10, INK)
	rr(770, 150, 150, 180, HUT_BLUE.darkened(0.25), 8)
	if flag("clock_open"):
		rr(782, 162, 126, 156, Color("14262c"), 6)
		if not flag("got_token"):
			item("token", 845, 240, 2.6)
	else:
		c(845, 240, 8, BRASS)


func _bwindow() -> void:
	r(0, 0, 960, 472, Color("9fd4ea"))
	c(760, 90, 44, Color("fff1a8"))
	var mark := float(clues.get("tide_mark", 1))
	var water := 400.0 - mark * 50.0 + 4 * sin(t * 1.5)
	r(0, water, 960, 472 - water, SEA_BLUE)
	for k in range(8):
		ln(k * 130.0 + 20 * sin(t + k), water + 30 + (k % 3) * 40.0, k * 130.0 + 60 + 20 * sin(t + k), water + 30 + (k % 3) * 40.0, Color(1, 1, 1, 0.45), 3)
	# The tide post with its marks.
	rr(450, 60, 44, 380, WOOD_D, 4)
	for k in range(1, 7):
		var y := 400.0 - k * 50.0
		r(450, y, 44, 4, PAPER)
		txt(520, y + 10, str(k), 30, INK)
	r(0, 0, 960, 20, HUT_BLUE.darkened(0.15))
	r(0, 452, 960, 20, HUT_BLUE.darkened(0.15))
	r(0, 0, 20, 472, HUT_BLUE.darkened(0.15))
	r(940, 0, 20, 472, HUT_BLUE.darkened(0.15))


# === Night Train ====================================================================

## A station's sign.
func sign_of(name: String, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match name:
		"lake":
			for k in [-6.0, 4.0]:
				ci.draw_arc(Vector2(-7, k), 7, PI, TAU, 10, col, 3, true)
				ci.draw_arc(Vector2(7, k), 7, 0, PI, 10, col, 3, true)
		"bridge":
			ln(-15, -6, 15, -6, col, 3.5)
			ci.draw_arc(Vector2(0, 10), 13, PI, TAU, 12, col, 3.5, true)
			ln(-15, -6, -15, 10, col, 3.5)
			ln(15, -6, 15, 10, col, 3.5)
		"tower":
			poly([-6, 12, 6, 12, 4, -6, -4, -6], col)
			poly([-9, -6, 9, -6, 0, -16], col)
		"mill":
			for k in range(4):
				var a := k * PI / 2 + 0.5
				ln(0, -2, cos(a) * 15, -2 + sin(a) * 15, col, 4)
			poly([-5, 14, 5, 14, 3, 0, -3, 0], col)
		"peak":
			poly([-15, 12, 0, -14, 15, 12], col)
			poly([-5, -5, 0, -14, 5, -5, 0, -1], PAPER)
		"sun":
			ring(0, 0, 11, col, 3)
			c(0, 0, 3, col)
		"moon":
			ci.draw_arc(Vector2(0, 0), 11, 0.9, TAU - 0.9, 14, col, 3.5, true)
			ci.draw_arc(Vector2(7, 0), 9, 2.2, TAU - 2.2, 12, col, 3, true)
		"fire", "air":
			poly([0, -13, 13, 11, -13, 11], col)
			poly([0, -6, 7, 8, -7, 8], PAPER if name == "air" else col.lightened(0.3))
			if name == "air":
				ln(-12, -1, 12, -1, col, 3)
		"water", "earth":
			poly([0, 13, 13, -11, -13, -11], col)
			poly([0, 6, 7, -8, -7, -8], PAPER if name == "earth" else col.lightened(0.3))
			if name == "earth":
				ln(-12, 1, 12, 1, col, 3)
	home()


func _carriage() -> void:
	r(0, 0, 960, 372, PANEL)
	for i in range(9):
		rr(i * 120.0 + 8, 196, 104, 170, PANEL_D, 4)
	r(0, 186, 960, 6, PANEL_D)
	r(0, 0, 960, 30, PANEL_D)
	r(0, 372, 960, 100, Color("3a2a3a"))
	for i in range(12):
		r(i * 80.0, 372, 40, 100, Color("4a3448"))


func _night_window(x: float, y: float, w: float, h: float) -> void:
	rr(x - 10, y - 10, w + 20, h + 20, BRASS_D, 8)
	r(x, y, w, h, Color("0d1428"))
	for i in range(14):
		var lx := x + w - fmod(i * 97.0 + t * (160.0 + i * 12.0), w)
		c(lx, y + 20 + fmod(i * 41.0, h - 60), 2.5, Color(1, 0.9, 0.6, 0.8))
	var hills := [x, y + h, x, y + h * 0.7]
	for k in range(1, 9):
		hills.append_array([x + w * k / 8.0, y + h * (0.62 + 0.1 * sin(k * 1.3 + t * 0.8))])
	hills.append_array([x + w, y + h])
	poly(hills, Color("141e30"))


func _n1() -> void:
	_carriage()
	_night_window(300, 70, 360, 180)
	rr(290, 60, 380, 26, SEAT_RED.darkened(0.3), 4)
	# The luggage rack.
	for k in range(2):
		r(40 + k * 620.0, 116, 260, 5, BRASS)
		for j in range(6):
			ln(50 + k * 620.0 + j * 48.0, 116, 50 + k * 620.0 + j * 48.0, 132, BRASS, 2)
	rr(70, 44, 170, 72, Color("5a4630"), 8)
	rr(130, 62, 50, 26, PAPER, 3)
	sign_of(clues.get("tag", ""), 155, 76, 0.6, INK)
	rr(720, 56, 120, 60, Color("3d5a6a"), 14)
	# Four seats with their numbers.
	var seats: Array = clues.get("seats", [])
	var xs := [60.0, 170.0, 690.0, 800.0]
	for i in range(mini(seats.size(), 4)):
		var x: float = xs[i]
		rr(x, 150, 100, 150, SEAT_RED, 10)
		rr(x + 30, 134, 40, 22, BRASS, 3)
		txt(x + 50, 152, str(int(seats[i])), 16, INK)
		var up: bool = flag("seat_up") and int(seats[i]) == int(clues.get("seat", -1))
		if up:
			rr(x - 4, 250, 108, 14, SEAT_RED.darkened(0.3), 4)
			rr(x + 6, 300, 88, 60, Color("14100c"), 4)
			rr(x + 14, 310, 72, 44, Color("2a2a30"), 5)
			rr(x + 40, 322, 20, 12, BRASS, 2)
		else:
			rr(x - 4, 300, 108, 40, SEAT_RED.lightened(0.08), 10)
			r(x, 340, 100, 36, PANEL_D)


func _n2() -> void:
	_carriage()
	# The folding table: timetable and ticket.
	rr(160, 290, 380, 14, PANEL_D, 3)
	poly([200, 304, 220, 372, 240, 304], BRASS_D)
	poly([460, 304, 480, 372, 500, 304], BRASS_D)
	poly([190, 290, 204, 246, 330, 246, 344, 290], PAPER)
	for k in range(4):
		ln(214, 256 + k * 9.0, 322, 256 + k * 9.0, INK.lightened(0.3), 1.5)
	if flag("got_case"):
		poly([400, 290, 406, 268, 490, 268, 496, 290], Color("f0d8a0"))
	# A reading lamp and a coat.
	rr(60, 60, 60, 20, BRASS, 6)
	c(90, 86, 12, Color("fff1a8"))
	poly([580, 60, 640, 60, 660, 250, 560, 250], Color("3a3a4a"))
	# The conductor's panel.
	rr(690, 110, 110, 130, STEEL.darkened(0.3), 6)
	var panel: Array = st.get("panel", [])
	for i in range(panel.size()):
		c(716.0 + (i % 3) * 28.0, 140.0 + floorf(i / 3.0) * 28.0, 8, AMBER if int(panel[i]) == 1 else IRON_D)
	if flag("handle_in"):
		rr(738, 216, 14, 40, RED, 4)
	# The sliding door.
	r(836, 40, 114, 336, BRASS_D)
	r(846, 50, 94, 326, PANEL_D)
	rr(858, 70, 70, 110, Color("0d1428"), 4)
	rr(852, 220, 12, 50, BRASS, 4)


func _ncase() -> void:
	board(Color("3a2a3a"))
	rr(120, 60, 720, 380, Color("5a4630"), 16)
	if flag("case_open"):
		rr(170, 110, 620, 290, Color("14100c"), 8)
		if not flag("got_case"):
			item("punch", 380, 250, 4.0)
			rr(520, 200, 180, 100, Color("f0d8a0"), 4)
	else:
		# The luggage tag.
		poly([130, 30, 300, 30, 330, 64, 300, 98, 130, 98], PAPER)
		c(150, 64, 6, INK)
		sign_of(clues.get("tag", ""), 236, 64, 1.6, INK)
		kit_wheels(st.get("case", [0, 0, 0]), 400, 240)


func _timetable() -> void:
	board(Color("3a2a3a"))
	rr(250, 14, 460, 444, PAPER, 4)
	ln(480, 60, 480, 420, INK.lightened(0.5), 3)
	var line: Array = clues.get("line", [])
	for i in range(line.size()):
		var y := 80.0 + i * 84.0
		c(480, y, 9, INK)
		sign_of(line[i]["sign"], 370, y, 1.5, INK)
		txt(590, y + 14, "%02d:%02d" % [int(line[i]["h"]), int(line[i]["m"])], 38, INK)


func _nticket() -> void:
	board(Color("3a2a3a"))
	rr(160, 100, 640, 270, Color("f0d8a0"), 8)
	for k in range(12):
		c(160, 122 + k * 21.0, 7, Color("3a2a3a"))
		c(800, 122 + k * 21.0, 7, Color("3a2a3a"))
	# The journey and the seat.
	var journey: Array = clues.get("journey", ["", ""])
	sign_of(journey[0], 270, 180, 2.0, INK)
	ln(320, 180, 400, 180, INK, 4)
	poly([420, 180, 398, 168, 398, 192], INK)
	sign_of(journey[1], 480, 180, 2.0, INK)
	rr(240, 250, 90, 70, SEAT_RED, 10)
	txt(420, 304, str(int(clues.get("seat", 0))), 50, INK)
	# Where the conductor punches.
	rr(590, 140, 170, 190, Color("e4c888"), 4)
	var punch: Array = clues.get("punch", [])
	for i in range(punch.size()):
		var x := 625.0 + (i % 3) * 50.0
		var y := 180.0 + floorf(i / 3.0) * 50.0
		if flag("punched") and int(punch[i]) == 1:
			c(x, y, 13, Color("3a2a3a"))
		else:
			ring(x, y, 13, Color(0, 0, 0, 0.12), 2)


func _nbrief() -> void:
	board(Color("3a2a3a"))
	rr(120, 60, 720, 380, Color("2a2a30"), 16)
	if flag("brief_open"):
		rr(170, 110, 620, 290, Color("0a0a10"), 8)
		if not flag("got_brief"):
			item("brake", 480, 250, 4.0)
	else:
		# A ticket marks what opens it.
		rr(410, 76, 140, 50, Color("f0d8a0"), 4)
		ln(440, 101, 500, 101, INK, 3)
		poly([516, 101, 498, 92, 498, 110], INK)
		var value: Array = st.get("brief", [0, 0, 0, 0])
		var line: Array = clues.get("line", [])
		for i in range(value.size()):
			var cx := 360.0 + i * 80.0
			arrow_btn(cx - 30, 180, 60, 46, 0)
			rr(cx - 32, 232, 64, 84, PAPER, 6)
			if not line.is_empty():
				sign_of(line[int(value[i]) % line.size()]["sign"], cx, 274, 1.6, INK)
			arrow_btn(cx - 30, 322, 60, 46, 1)


func _npanel() -> void:
	board(Color("3a2a3a"))
	rr(160, 30, 640, 420, STEEL.darkened(0.3), 12)
	# The punch's sign.
	item("punch", 240, 100, 2.0)
	var panel: Array = st.get("panel", [])
	for i in range(panel.size()):
		var x := 380.0 + (i % 3) * 100.0
		var y := 120.0 + floorf(i / 3.0) * 100.0
		rr(x - 40, y - 40, 80, 80, IRON_D, 10)
		c(x, y, 26, AMBER if int(panel[i]) == 1 else Color("14100c"))
	rr(690, 180, 80, 150, IRON_D, 8)
	if flag("panel_open"):
		rr(712, 200, 36, 110, Color("0a0a10"), 6)
		if flag("handle_in"):
			rr(720, 190, 20, 90, RED, 6)
	else:
		rr(700, 190, 60, 130, STEEL, 6)


# === The Alchemist's Cellar ==========================================================

func _vault() -> void:
	r(0, 0, 960, 372, VAULT)
	for i in range(6):
		ci.draw_arc(Vector2(96 + i * 192.0, 150), 100, PI, TAU, 20, VAULT_D, 10, true)
		r(i * 192.0 - 5, 150, 10, 222, VAULT_D)
	for i in range(6):
		for j in range(5):
			r(float((i * 173 + j * 97) % 960), 170 + i * 34.0, 46, 3, VAULT_D)
	r(0, 372, 960, 100, Color("3a3430"))
	for i in range(8):
		r(i * 128.0, 372, 3, 100, Color("2c2824"))


func _flask(x: float, y: float, s: float, colour: Color) -> void:
	poly([x - 6 * s, y - 34 * s, x + 6 * s, y - 34 * s, x + 6 * s, y - 16 * s, x + 18 * s, y + 10 * s, x - 18 * s, y + 10 * s, x - 6 * s, y - 16 * s], Color(0.8, 0.9, 0.95, 0.45))
	if colour.a > 0.0:
		poly([x - 10 * s, y - 6 * s, x + 10 * s, y - 6 * s, x + 18 * s, y + 10 * s, x - 18 * s, y + 10 * s], colour)


func _vial_colour(i: int) -> Color:
	var names: Array = st.get("vial_colours", ["", "", ""])
	var name: String = names[i] if i < names.size() else ""
	if name == "":
		return Color(0, 0, 0, 0)
	return Color("7a5a3a") if name == "brown" else paint(name)


func _a1() -> void:
	_vault()
	# Jars on a shelf, candles.
	rr(80, 110, 360, 10, WOOD_D, 3)
	for k in range(6):
		rr(96 + k * 56.0, 66, 34, 44, [Color("6a8a5a"), Color("8a6a4a"), Color("5a6a8a")][k % 3], 6)
		r(100 + k * 56.0, 60, 26, 8, WOOD)
	for k in range(2):
		r(500 + k * 40.0, 80, 10, 40, CREAM)
		poly([505 + k * 40.0, 64 + 2 * sin(t * 9.0 + k), 510 + k * 40.0, 80, 500 + k * 40.0, 80], FIRE)
	# The workbench: vials and scales.
	rr(80, 296, 560, 16, WOOD, 3)
	r(96, 312, 16, 66, WOOD_D)
	r(608, 312, 16, 66, WOOD_D)
	rr(150, 270, 190, 12, WOOD_D, 3)
	for i in range(3):
		_flask(190.0 + i * 55.0, 258, 0.9, _vial_colour(i) if not flag("got_elixir") or i < 2 else Color(0, 0, 0, 0))
	ln(500, 296, 500, 220, BRASS_D, 6)
	var lean := float(st.get("tilt", 0)) * 0.12
	ci.draw_set_transform(Vector2(500, 222), lean, Vector2.ONE)
	r(-70, -3, 140, 6, BRASS)
	ln(-64, 0, -64, 34, BRASS_D, 2)
	ln(64, 0, 64, 34, BRASS_D, 2)
	ci.draw_arc(Vector2(-64, 34), 22, 0, PI, 10, BRASS, 4, true)
	ci.draw_arc(Vector2(64, 34), 22, 0, PI, 10, BRASS, 4, true)
	home()
	# The furnace.
	rr(690, 150, 220, 230, Color("5a4a44"), 8)
	rr(740, 240, 120, 110, Color("14100c"), 50)
	var heat := int(st.get("heat", 0))
	if int(st.get("step", 0)) > 0:
		poly([776, 330, 824, 330, 816, 300, 784, 300], Color("c9c2b0"))
	if heat > 0:
		poly([760, 348, 780, 320 - heat * 4.0, 800, 338, 820, 316 - heat * 4.0, 840, 348], FIRE)
	r(780, 100, 40, 54, Color("4a3c38"))


func _a2() -> void:
	_vault()
	# The book on its lectern.
	poly([150, 380, 170, 300, 230, 300, 250, 380], WOOD_D)
	poly([120, 300, 140, 250, 200, 254, 196, 300], PAPER)
	poly([196, 300, 200, 254, 260, 250, 280, 300], PAPER.darkened(0.06))
	# The chart on the wall.
	rr(330, 70, 200, 160, PAPER, 3)
	var pairs: Array = clues.get("sign_colours", [])
	for i in range(pairs.size()):
		sign_of(pairs[i]["sign"], 370.0 + (i % 2) * 100.0, 110.0 + floorf(i / 2.0) * 70.0, 0.9, INK)
	# The cabinet.
	rr(580, 150, 140, 226, WOOD_D, 4)
	if flag("cab_open"):
		r(590, 160, 120, 206, Color("14100c"))
		if not flag("got_cab"):
			item("nugget", 650, 300, 2.4)
	else:
		r(590, 160, 58, 206, WOOD)
		r(652, 160, 58, 206, WOOD)
		for i in range(3):
			c(620.0 + i * 30.0, 260, 9, Color("14100c"))
	# The disc in the floor.
	ci.draw_set_transform(Vector2(420, 426), 0.0, Vector2(1.0, 0.3))
	c(0, 0, 130, BRASS_D)
	ring(0, 0, 96, BRASS, 6)
	ring(0, 0, 60, BRASS, 6)
	c(0, 0, 30, Color("14100c") if flag("rings_ok") else BRASS)
	home()
	# An owl, a skull, the door.
	c(820, 100, 22, Color("8a7a5a"))
	c(812, 96, 6, AMBER)
	c(828, 96, 6, AMBER)
	c(60, 356, 18, CREAM)
	r(784, 150, 130, 226, Color("3a2a22"))
	r(794, 160, 110, 216, Color("4a3830"))
	c(849, 260, 16, GOLD if flag("gold") else BRASS_D)
	sign_of("sun", 849, 260, 0.9, INK)


func _vials() -> void:
	board(Color("2a2a36"))
	var primaries: Array = clues.get("primaries", [])
	for i in range(3):
		var x := 260.0 + i * 220.0
		rr(x - 90, 40, 180, 420, Color(0, 0, 0, 0.25), 10)
		_flask(x, 210, 3.6, _vial_colour(i))
		for p in range(primaries.size()):
			c(x - 56 + p * 56.0, 300, 24, INK)
			c(x - 56 + p * 56.0, 300, 21, paint(primaries[p]))
		rr(x - 40, 350, 80, 44, Color(0, 0, 0, 0.4), 8)
		ln(x, 358, x, 376, CREAM, 4)
		poly([x, 388, x - 10, 374, x + 10, 374], CREAM)
	if flag("cab_open") and not flag("got_elixir"):
		rr(60, 410, 840, 44, Color(0.4, 0.9, 0.5, 0.25), 8)


func _abook() -> void:
	board(Color("2a2a36"))
	rr(60, 16, 840, 440, Color("4a2a2a"), 8)
	r(76, 30, 400, 412, PAPER)
	r(484, 30, 400, 412, PAPER.darkened(0.04))
	# Left: three vials and their signs; the day's three signs for the disc.
	var formula: Array = clues.get("formula", [])
	for i in range(formula.size()):
		var x := 150.0 + i * 120.0
		_flask(x, 120, 1.6, Color(0, 0, 0, 0.12))
		sign_of(formula[i], x, 190, 1.4, INK)
	ln(96, 236, 456, 236, INK.lightened(0.5), 2)
	var today: Array = clues.get("today", [])
	for i in range(today.size()):
		# The first sign belongs to the outer ring.
		var rad := 82.0 - i * 26.0
		ring(170, 340, rad, INK.lightened(0.3), 3)
		sign_of(today[i], 340, 270.0 + i * 56.0, 1.0, INK)
		ln(170 + rad, 340, 316, 270.0 + i * 56.0, INK.lightened(0.5), 1.5)
	poly([170, 250, 160, 232, 180, 232], RED)
	# Right: the furnace's steps, then the bellows as often as the metal weighs.
	var steps: Array = clues.get("steps", [])
	for i in range(steps.size()):
		var y := 90.0 + i * 86.0
		txt(520, y + 12, "%d." % (i + 1), 30, INK.lightened(0.3))
		item(steps[i], 620, y, 2.2)
		poly([760, y, 730, y - 14, 730, y + 14], INK.lightened(0.4))
		rr(790, y - 26, 60, 52, INK, 20)
	var y4 := 90.0 + steps.size() * 86.0
	txt(520, y4 + 12, "%d." % (steps.size() + 1), 30, INK.lightened(0.3))
	item("bellows", 610, y4, 2.0)
	txt(680, y4 + 10, "×", 30, INK)
	r(720, y4 - 4, 60, 5, INK)
	ci.draw_arc(Vector2(730, y4 + 16), 12, 0, PI, 8, INK, 3, true)
	item("nugget", 730, y4 + 14, 0.8)
	ci.draw_arc(Vector2(770, y4 + 16), 12, 0, PI, 8, INK, 3, true)


func _achart() -> void:
	board(Color("2a2a36"))
	rr(160, 20, 640, 432, PAPER, 4)
	var pairs: Array = clues.get("sign_colours", [])
	for i in range(pairs.size()):
		var y := 80.0 + i * 100.0
		sign_of(pairs[i]["sign"], 300, y, 2.4, INK)
		ln(380, y, 520, y, INK.lightened(0.4), 3)
		var name: String = pairs[i]["colour"]
		c(620, y, 40, INK)
		c(620, y, 36, Color("7a5a3a") if name == "brown" else paint(name))


func _scales() -> void:
	board(Color("2a2a36"))
	var tilt := float(st.get("tilt", 0))
	var pans: Array = st.get("pans", [0, 0, 0])
	var weights: Array = clues.get("weights", [])
	poly([480, 150, 450, 420, 510, 420], BRASS_D)
	ci.draw_set_transform(Vector2(480, 150), tilt * 0.12, Vector2.ONE)
	rr(-300, -8, 600, 16, BRASS, 6)
	for side in [-1.0, 1.0]:
		ln(side * 280, 0, side * 280, 120, BRASS_D, 3)
		ci.draw_arc(Vector2(side * 280, 120), 90, 0, PI, 16, BRASS, 6, true)
	home()
	# What lies in the pans (the left one sinks when it is heavier).
	var drop := -tilt * 34.0
	if flag("got_cab"):
		item("nugget", 152, 326 + drop, 2.6)
	for i in range(weights.size()):
		if int(pans[i]) == 0:
			continue
		var left: bool = int(pans[i]) == 1
		var wx := (214.0 + i * 46.0) if left else (714.0 + i * 46.0)
		var wy := 352.0 + (drop if left else -drop)
		var tall := 34.0 + float(weights[i]) * 3.0
		rr(wx - 20, wy - tall, 40, tall, STEEL, 5)
		r(wx - 6, wy - tall - 8, 12, 9, STEEL.darkened(0.2))
		txt(wx, wy - 8, str(int(weights[i])), 22, INK)
	c(480, 150, 14, IRON_D)
	c(480, 250, 9, Color("69d06a") if flag("balanced") else Color("3a2c22"))
	# The weights on the bench; a tap moves each: off, left, right.
	for i in range(weights.size()):
		var x := 380.0 + i * 100.0
		rr(x - 40, 384, 80, 70, Color(0, 0, 0, 0.3), 8)
		if int(pans[i]) == 0:
			var tall2 := 30.0 + float(weights[i]) * 2.0
			rr(x - 20, 446 - tall2, 40, tall2, STEEL, 5)
			txt(x, 440, str(int(weights[i])), 22, INK)
	rr(700, 384, 200, 70, WOOD_D, 6)
	if flag("balanced"):
		rr(710, 392, 180, 54, Color("14100c"), 4)
		if not flag("got_bellows"):
			item("bellows", 800, 420, 2.2)
	else:
		c(800, 420, 7, BRASS)


func _disc() -> void:
	board(Color("2a2a36"))
	var rings: Array = clues.get("rings", [])
	var turned: Array = st.get("rings", [0, 0, 0])
	c(400, 236, 226, BRASS_D)
	for k in range(rings.size()):
		var rad := 196.0 - k * 60.0
		c(400, 236, rad + 28, Color("3a3430") if k % 2 == 0 else Color("4a4440"))
		for j in range(6):
			var a := TAU * (j - float(turned[k])) / 6.0 - PI / 2
			sign_of(rings[k][j], 400 + cos(a) * rad, 236 + sin(a) * rad, 1.1, GOLD)
		arrow_btn(690, 90.0 + k * 100.0, 76, 64, 2)
		arrow_btn(776, 90.0 + k * 100.0, 76, 64, 3)
		ring(900, 122.0 + k * 100.0, 10.0 + (2 - k) * 8.0, GOLD, 3)
	c(400, 236, 44, Color("14100c") if flag("rings_ok") else BRASS)
	if flag("rings_ok") and not flag("got_crucible"):
		item("crucible", 400, 236, 2.0)
	poly([400, 30, 388, 4, 412, 4], RED)
	ln(400, 30, 400, 190, Color(RED, 0.35), 2)


func _furnace() -> void:
	board(Color("2a2a36"))
	rr(160, 30, 520, 420, Color("5a4a44"), 12)
	rr(250, 150, 340, 270, Color("14100c"), 150)
	var step := int(st.get("step", 0))
	var heat := int(st.get("heat", 0))
	if heat > 0:
		var f := 8.0 * sin(t * 9.0)
		poly([300, 416, 340, 360 - heat * 14.0 + f, 380, 400, 420, 340 - heat * 16.0 - f, 460, 400, 500, 360 - heat * 14.0 + f, 540, 416], FIRE)
	if step > 0:
		poly([360, 400, 480, 400, 464, 320, 376, 320], Color("c9c2b0"))
		if step > 1:
			item("nugget", 420, 318, 2.0)
		if step > 2:
			poly([378, 330, 462, 330, 466, 350, 374, 350], paint("orange"))
	if flag("gold"):
		c(420, 330, 60, Color(1, 0.85, 0.3, 0.35))
	# The bellows and how hot it is.
	rr(720, 250, 180, 150, WOOD_D, 10)
	item("bellows", 810, 325, 4.0)
	rr(730, 40, 60, 190, Color("14100c"), 8)
	for k in range(6):
		r(736, 210 - k * 30.0, 12, 3, CREAM)
	rr(752, 216 - heat * 30.0, 30, heat * 30.0 + 6, FIRE, 4)
