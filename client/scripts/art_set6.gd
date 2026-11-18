## Draws the rooms of the sixth set on top of ArtSet5: Graf Alpina (Z1, Z2),
## Albatross (V1, V2) and Base 70° South (R1, R2), with their close-ups.
## Hotspots are in views_set6.gd.
class_name ArtSet6
extends ArtSet5

const Z_MAHOG := Color("5a2e1e")
const Z_MAHOG_D := Color("44200f")
const Z_DUSK := Color("f2a35a")
const Z_DUSK_HI := Color("f7cf8e")
const Z_ICE := Color("e6eef6")
const Z_ICE_D := Color("b9c8d8")
const V_WOOD := Color("6a4a30")
const V_WOOD_D := Color("4e3420")
const V_SEA := Color("2f3f4a")
const V_SKY := Color("5f6b74")
const R_WALL := Color("c9ced3")
const R_WALL_D := Color("aab1b8")
const R_RED := Color("c8322a")
const R_YELLOW := Color("e8b828")
const R_UV := Color("a060ff")
const R_FACES := ["beard", "hat", "glasses", "scarf"]


func draw_view(view: String) -> void:
	match view:
		"Z1": _z1()
		"Z2": _z2()
		"zphoto": _zphoto()
		"zcab": _zcab()
		"ztelegram": _ztelegram()
		"zbook": _zbook()
		"zcompass": _zcompass()
		"zwindow": _zwindow()
		"zvalves": _zvalves()
		"zchart": _zchart()
		"V1": _v1()
		"V2": _v2()
		"vbell": _vbell()
		"vlocker": _vlocker()
		"vdiagram": _vdiagram()
		"vlog": _vlog()
		"vballast": _vballast()
		"vwindow": _vwindow()
		"vchart": _vchart()
		"vcompass": _vcompass()
		"R1": _r1()
		"R2": _r2()
		"rboard": _rboard()
		"rlog": _rlog()
		"rmap": _rmap()
		"rradio": _rradio()
		"rcrates": _rcrates()
		"rairlock": _rairlock()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"zmagnet":
			at(x, y, -0.4, s)
			r(-18, -6, 18, 12, RED)
			r(0, -6, 18, 12, Color("3060c0"))
		"horseshoe":
			at(x, y, 0.0, s)
			ci.draw_arc(Vector2(0, -2), 12, 0, PI, 16, RED, 8, true)
			r(-16, -16, 8, 14, RED)
			r(8, -16, 8, 14, RED)
			r(-16, -20, 8, 5, SILVER)
			r(8, -20, 8, 5, SILVER)
		"binoculars":
			at(x, y, 0.0, s)
			rr(-17, -8, 14, 20, Color("2a2a2a"), 4)
			rr(3, -8, 14, 20, Color("2a2a2a"), 4)
			r(-3, -4, 6, 6, BRASS)
			c(-10, 13, 6, Color("8fb0c8"))
			c(10, 13, 6, Color("8fb0c8"))
		"filters":
			at(x, y, 0.0, s)
			for k in range(3):
				rr(-16 + k * 6, -14 + k * 4, 20, 22, [Color(0.85, 0.2, 0.2, 0.75), Color(0.2, 0.7, 0.3, 0.75), Color(0.25, 0.4, 0.9, 0.75)][k], 3)
		"telhandle":
			at(x, y, 0.6, s)
			r(-3, -18, 6, 30, BRASS)
			c(0, -20, 6, BRASS_D)
			r(-8, 10, 16, 6, BRASS_D)
		"uvlamp":
			at(x, y, -0.5, s)
			rr(-6, -4, 26, 10, Color("303040"), 3)
			rr(-14, -7, 10, 16, Color("404058"), 3)
			c(-15, 1, 5, R_UV)
		"rfuse":
			at(x, y, 0.4, s)
			rr(-16, -7, 32, 14, Color("e8e2d0"), 6)
			r(-20, -5, 6, 10, STEEL)
			r(14, -5, 6, 10, STEEL)
			r(-4, -7, 8, 14, R_RED)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	match room:
		"zeppelin":
			r(0, 0, w, h, Z_DUSK)
			r(0, 0, w, h * 0.4, Z_DUSK_HI)
			poly([0, h, 0, h * 0.75, w * 0.3, h * 0.55, w * 0.55, h * 0.72, w * 0.8, h * 0.5, w, h * 0.68, w, h], Z_ICE)
			ci.draw_set_transform(Vector2(w * 0.5, h * 0.32), 0.0, Vector2(1.0, 0.32))
			c(0, 0, w * 0.36, Color("d8d0c0"))
			home()
			rr(w * 0.44, h * 0.42, w * 0.14, h * 0.07, Z_MAHOG, 2)
		"ship":
			r(0, 0, w, h, V_SKY)
			poly([0, h * 0.6, w * 0.25, h * 0.5, w * 0.5, h * 0.62, w * 0.75, h * 0.48, w, h * 0.6, w, h, 0, h], V_SEA)
			poly([w * 0.2, h * 0.62, w * 0.8, h * 0.56, w * 0.72, h * 0.75, w * 0.26, h * 0.78], Color("2a2a2a"))
			r(w * 0.42, h * 0.38, w * 0.16, h * 0.2, CREAM)
			r(w * 0.6, h * 0.3, w * 0.06, h * 0.26, Color("b0302a"))
			for k in range(5):
				ln(w * (0.1 + k * 0.2), 0, w * (0.05 + k * 0.2), h * 0.4, Color(1, 1, 1, 0.25), 1)
		"polar":
			r(0, 0, w, h, Color("e8ecf0"))
			for k in range(14):
				ln(fmod(k * 37.0 + t * 30.0, w), 0, fmod(k * 37.0 + t * 30.0, w) - 14, h, Color(1, 1, 1, 0.6), 2)
			rr(w * 0.25, h * 0.45, w * 0.5, h * 0.32, R_RED, 3)
			r(w * 0.3, h * 0.52, w * 0.1, h * 0.08, R_YELLOW)
			ln(w * 0.7, h * 0.45, w * 0.7, h * 0.12, Color("404040"), 2)
			r(0, h * 0.8, w, h * 0.2, Color("f6f8fa"))
		_:
			super.card(room, w, h)


# --- Graf Alpina -----------------------------------------------------------------

func _z_wall() -> void:
	r(0, 0, 960, 372, Z_MAHOG)
	for k in range(9):
		r(k * 120.0, 0, 4, 372, Z_MAHOG_D)
	r(0, 372, 960, 100, Color("3a2416"))
	for k in range(8):
		r(0, 380 + k * 12.0, 960, 2, Color("2e1c10"))


## The Alps at dusk; turned towards the valley once the course holds.
func _z_land(x: float, y: float, w: float, h: float, valley: bool, close: bool) -> void:
	r(x, y, w, h, Z_DUSK)
	r(x, y, w, h * 0.35, Z_DUSK_HI)
	c(x + w * 0.8, y + h * 0.3, h * 0.12, Color("fff0c0"))
	if not valley:
		poly([x, y + h, x, y + h * 0.6, x + w * 0.2, y + h * 0.35, x + w * 0.4, y + h * 0.62, x + w * 0.6, y + h * 0.3, x + w * 0.85, y + h * 0.58, x + w, y + h * 0.45, x + w, y + h], Z_ICE)
		poly([x + w * 0.2, y + h * 0.35, x + w * 0.27, y + h * 0.5, x + w * 0.13, y + h * 0.5], Color("ffffff"))
		poly([x + w * 0.6, y + h * 0.3, x + w * 0.68, y + h * 0.46, x + w * 0.52, y + h * 0.46], Color("ffffff"))
		for k in range(5):
			ln(x + w * (0.1 + k * 0.18), y + h * 0.75, x + w * (0.2 + k * 0.18), y + h * 0.9, Z_ICE_D, 3)
		return
	poly([x, y + h, x, y + h * 0.45, x + w * 0.25, y + h * 0.3, x + w * 0.5, y + h * 0.5, x + w * 0.75, y + h * 0.28, x + w, y + h * 0.42, x + w, y + h], Z_ICE_D)
	poly([x, y + h, x + w * 0.2, y + h * 0.62, x + w * 0.8, y + h * 0.6, x + w, y + h], Color("6a8a4a"))
	# The landing field with its mooring mast and the ground crew's panels.
	var fx := x + w * 0.5
	var fy := y + h * 0.78
	ci.draw_set_transform(Vector2(fx, fy), 0.0, Vector2(1.0, 0.4))
	c(0, 0, w * 0.18, Color("8aaa5a"))
	home()
	ln(fx + w * 0.12, fy, fx + w * 0.12, fy - h * 0.2, Color("3a3a3a"), 3)
	if not close:
		for k in range(3):
			r(fx - 14 + k * 10, fy - 2, 6, 4, Color("ffffff"))
		return
	var panels: Array = clues.get("panels", [0, 0, 0])
	for k in range(3):
		_z_digit(int(panels[k]), fx - w * 0.12 + k * w * 0.08, fy - h * 0.06, w * 0.05)


## A digit laid out in white cloth panels (seven segments, seen from above).
func _z_digit(d: int, x: float, y: float, s: float) -> void:
	var seg: String = ["1111110", "0110000", "1101101", "1111001", "0110011", "1011011", "1011111", "1110000", "1111111", "1111011"][d % 10]
	var parts := [[0, 0, 1, 0.18], [0.82, 0, 0.18, 0.5], [0.82, 0.5, 0.18, 0.5], [0, 0.82, 1, 0.18], [0, 0.5, 0.18, 0.5], [0, 0, 0.18, 0.5], [0, 0.41, 1, 0.18]]
	for k in range(7):
		if seg[k] == "1":
			var p: Array = parts[k]
			r(x + p[0] * s, y + p[1] * s * 1.6, p[2] * s, p[3] * s * 1.6, Color("ffffff"))


func _z_clock(x: float, y: float, rad: float, hm: Array) -> void:
	c(x, y, rad, CREAM)
	ring(x, y, rad, BRASS, 3)
	for k in range(12):
		var a := k * TAU / 12
		ln(x + sin(a) * rad * 0.8, y - cos(a) * rad * 0.8, x + sin(a) * rad * 0.92, y - cos(a) * rad * 0.92, INK, 2)
	var h := (int(hm[0]) % 12 + int(hm[1]) / 60.0) * TAU / 12
	var m := int(hm[1]) * TAU / 60
	ln(x, y, x + sin(h) * rad * 0.5, y - cos(h) * rad * 0.5, INK, 3)
	ln(x, y, x + sin(m) * rad * 0.78, y - cos(m) * rad * 0.78, INK, 2)


## A cipher sign: a ring with a notch at one of ten places, clockwise from the top.
func _z_sign(d: int, x: float, y: float, rad: float, col: Color) -> void:
	ring(x, y, rad, col, rad * 0.18)
	var a := -PI / 2 + d * TAU / 10
	c(x + cos(a) * rad, y + sin(a) * rad, rad * 0.26, col)
	c(x, y, rad * 0.12, col)


func _z_church(x: float, y: float, s: float, col: Color) -> void:
	r(x - 6 * s, y - 10 * s, 12 * s, 24 * s, col)
	poly([x - 8 * s, y - 10 * s, x, y - 24 * s, x + 8 * s, y - 10 * s], col)
	r(x - 12 * s, y + 2 * s, 24 * s, 12 * s, col)


func _z1() -> void:
	_z_wall()
	rr(52, 22, 616, 216, BRASS_D, 10)
	_z_land(60, 30, 600, 200, flag("aligned"), false)
	for k in range(1, 4):
		r(60 + k * 150.0, 30, 6, 200, BRASS_D)
	# The wall clock (the current time).
	_z_clock(885, 85, 38, clues.get("wall_clock", [4, 20]))
	# The steering wheel.
	ring(170, 310, 46, Color("8a5a30"), 8)
	for k in range(8):
		var a := k * TAU / 8
		ln(170, 310, 170 + cos(a) * 60, 310 + sin(a) * 60, Color("8a5a30"), 5)
	# The binnacle with its compass.
	rr(440, 300, 80, 72, BRASS_D, 8)
	c(480, 290, 40, BRASS)
	c(480, 290, 32, CREAM)
	var n := deg_to_rad(float(st.get("needle", 0)))
	ln(480, 290, 480 + sin(n) * 26, 290 - cos(n) * 26, RED, 3)
	# The radio desk with the telegram.
	rr(700, 300, 240, 72, Z_MAHOG_D, 4)
	rr(860, 230, 70, 72, Color("2a2a2a"), 6)
	c(895, 266, 14, Color("6a8a5a"))
	rr(730, 240, 100, 56, PAPER, 3)
	for k in range(3):
		_z_sign(int(clues.get("telegram", [0, 0, 0])[k]), 755 + k * 25, 268, 8, INK)


func _z2() -> void:
	_z_wall()
	# The captain's cabinet; its lock shows a church.
	rr(60, 80, 200, 280, Z_MAHOG_D, 6)
	rr(76, 96, 168, 248, Color("6a3a24"), 4)
	rr(140, 190, 40, 40, BRASS, 4)
	_z_church(160, 212, 0.7, INK)
	# The photograph.
	rr(300, 50, 170, 130, BRASS_D, 4)
	r(310, 60, 150, 110, Color("d8c8a0"))
	ci.draw_set_transform(Vector2(385, 90), 0.0, Vector2(1.0, 0.3))
	c(0, 0, 50, Color("8a7a60"))
	home()
	for k in range(5):
		r(320 + k * 28, 140, 22, 26, Color("8a7a60"))
	_z_church(420, 140, 0.8, Color("6a5a40"))
	# The code book on its shelf.
	r(500, 170, 190, 8, Z_MAHOG_D)
	for k in range(7):
		rr(508 + k * 25, 80 + (k % 3) * 8, 20, 90 - (k % 3) * 8, [Color("6a2a2a"), Color("2a4a6a"), Color("4a5a2a")][k % 3], 2)
	# The chart table with its paperweight.
	rr(470, 250, 280, 120, Z_MAHOG_D, 6)
	r(480, 230, 260, 30, PAPER)
	if not flag("got_horseshoe"):
		item("horseshoe", 700, 240, 0.9)
	# The gas valves.
	rr(780, 50, 160, 320, Color("6a5a40"), 8)
	for k in range(3):
		c(860, 110 + k * 90, 26, BRASS)
		c(860, 110 + k * 90, 10, BRASS_D)
	# A lamp.
	r(340, 230, 10, 50, BRASS_D)
	poly([320, 230, 370, 230, 360, 200, 330, 200], Color("e8c070"))


func _zphoto() -> void:
	board(Z_MAHOG_D)
	rr(120, 20, 720, 440, BRASS_D, 8)
	r(140, 40, 680, 400, Color("d8c8a0"))
	# The airship over the town.
	ci.draw_set_transform(Vector2(440, 130), 0.0, Vector2(1.0, 0.28))
	c(0, 0, 220, Color("8a7a60"))
	home()
	rr(410, 180, 80, 28, Color("6a5a40"), 4)
	for k in range(9):
		var hx := 170 + k * 70.0
		r(hx, 330 - (k % 3) * 14, 56, 110 + (k % 3) * 14, Color("8a7a60"))
		poly([hx - 4, 330 - (k % 3) * 14, hx + 28, 300 - (k % 3) * 14, hx + 60, 330 - (k % 3) * 14], Color("6a5a40"))
	# The church tower with its clock: small, but readable.
	r(640, 210, 60, 230, Color("7a6a50"))
	poly([630, 210, 670, 140, 710, 210], Color("5a4a30"))
	_z_clock(670, 250, 18, clues.get("church", [0, 0]))


func _zcab() -> void:
	board(Z_MAHOG_D)
	rr(200, 40, 560, 400, Color("6a3a24"), 12)
	if flag("cab_open"):
		rr(230, 80, 500, 320, Color("1e100a"), 8)
		if not flag("got_cab"):
			item("zmagnet", 400, 240, 3.0)
			item("binoculars", 580, 240, 3.0)
		return
	rr(440, 80, 80, 80, BRASS, 8)
	_z_church(480, 125, 1.5, INK)
	kit_wheels(st.get("cab", [0, 0, 0, 0]), 360, 270)


func _ztelegram() -> void:
	board(Z_MAHOG_D)
	rr(120, 40, 720, 400, PAPER, 6)
	r(120, 40, 720, 60, Color("e8d8a8"))
	# A telegraph mast and lightning: a radio message.
	ln(180, 90, 180, 50, INK, 4)
	poly([200, 52, 214, 70, 206, 70, 218, 90, 198, 70, 206, 70], INK)
	var tel: Array = clues.get("telegram", [0, 0, 0])
	for k in range(3):
		_z_sign(int(tel[k]), 300 + k * 180, 260, 60, INK)
	ln(170, 380, 790, 380, Color("c9b98a"), 2)


func _zbook() -> void:
	board(Z_MAHOG_D)
	rr(100, 30, 760, 420, Color("6a2a2a"), 10)
	r(120, 44, 360, 392, PAPER)
	r(480, 44, 360, 392, PAPER)
	r(478, 44, 4, 392, Color("c9b98a"))
	# The left page burnt away, the right one with three samples left.
	for k in range(8):
		c(140 + (k * 53) % 330, 70 + (k * 97) % 360, 40 + (k % 3) * 12, Color("2a1a10"))
	var samples: Array = clues.get("samples", [0, 0, 0])
	for k in range(3):
		var y := 110 + k * 120.0
		_z_sign(int(samples[k]), 580, y, 34, INK)
		ln(630, y, 690, y, INK, 3)
		txt(740, y + 18, str(int(samples[k])), 52, INK)
	c(820, 420, 50, Color("2a1a10"))
	c(500, 60, 30, Color("2a1a10"))


func _zcompass() -> void:
	board(Z_MAHOG_D)
	var cc := Set6Views.COMPASS
	c(cc.x, cc.y, 150, BRASS_D)
	c(cc.x, cc.y, 138, CREAM)
	for k in range(36):
		var a := k * TAU / 36
		var l := 18.0 if k % 9 == 0 else 8.0
		ln(cc.x + sin(a) * (138 - l), cc.y - cos(a) * (138 - l), cc.x + sin(a) * 136, cc.y - cos(a) * 136, INK, 2)
	poly([cc.x, cc.y - 132, cc.x - 10, cc.y - 110, cc.x + 10, cc.y - 110], RED)
	# The course set on the wheels, as a brass mark on the rose.
	var course: Array = st.get("course", [0, 0, 0])
	var heading := int(course[0]) * 100 + int(course[1]) * 10 + int(course[2])
	if heading < 360:
		var a := deg_to_rad(float(heading))
		poly([cc.x + sin(a) * 150, cc.y - cos(a) * 150, cc.x + sin(a - 0.06) * 172, cc.y - cos(a - 0.06) * 172, cc.x + sin(a + 0.06) * 172, cc.y - cos(a + 0.06) * 172], BRASS)
	var n := deg_to_rad(float(st.get("needle", 0)))
	ln(cc.x - sin(n) * 40, cc.y + cos(n) * 40, cc.x + sin(n) * 120, cc.y - cos(n) * 120, RED, 6)
	ln(cc.x - sin(n) * 40, cc.y + cos(n) * 40, cc.x, cc.y, Color("3060c0"), 6)
	c(cc.x, cc.y, 10, BRASS_D)
	# The four slots: empty, a magnet pulling (red end in), or pushing (blue end in).
	var slots: Array = st.get("slots", [0, 0, 0, 0])
	for i in range(4):
		var p := Set6Views.slot_xy(i)
		rr(p.x - 40, p.y - 40, 80, 80, Color(0, 0, 0, 0.3), 10)
		var v := int(slots[i])
		if v == 0:
			ring(p.x, p.y, 20, Color(1, 1, 1, 0.3), 3)
			continue
		var inward := (cc - p).normalized()
		var near := RED if v == 1 else Color("3060c0")
		var far := Color("3060c0") if v == 1 else RED
		ln(p.x, p.y, p.x + inward.x * 30, p.y + inward.y * 30, near, 18)
		ln(p.x, p.y, p.x - inward.x * 30, p.y - inward.y * 30, far, 18)
	# The course wheels.
	rr(580, 90, 160, 60, BRASS_D, 6)
	ring(660, 120, 20, CREAM, 3)
	poly([660, 102, 654, 120, 666, 120], RED)
	kit_wheels(course, 660, 250)


func _zwindow() -> void:
	board(BRASS_D)
	_z_land(20, 20, 920, 432, flag("aligned"), flag("aligned") and flag("bino"))


func _zvalves() -> void:
	board(Z_MAHOG_D)
	rr(160, 40, 640, 420, Color("6a5a40"), 12)
	# A gas cell and a downward arrow: let gas out to descend.
	ci.draw_set_transform(Vector2(480, 110), 0.0, Vector2(1.0, 0.4))
	c(0, 0, 80, Color("d8d0c0"))
	home()
	poly([470, 150, 490, 150, 490, 166, 500, 166, 480, 182, 460, 166, 470, 166], CREAM)
	kit_wheels(st.get("valve", [0, 0, 0]), 400, 270)
	c(760, 80, 14, Color("4ad04a") if st.get("done", false) else Color("3a2a1a"))


func _zchart() -> void:
	board(Z_MAHOG_D)
	rr(100, 40, 760, 400, PAPER, 6)
	for k in range(6):
		poly([140 + k * 120, 400, 200 + k * 120, 200 + (k % 2) * 60, 260 + k * 120, 400], Color("e0d8c0"))
	for k in range(8):
		ln(120, 80 + k * 45, 840, 80 + k * 45, Color("d8c8a0"), 1)
	ln(200, 380, 760, 120, Color("8a3a24"), 3)
	if not flag("got_horseshoe"):
		item("horseshoe", 640, 310, 2.6)


# --- Albatross -------------------------------------------------------------------

func _v_wall() -> void:
	r(0, 0, 960, 372, V_WOOD)
	for k in range(10):
		r(0, k * 38.0, 960, 2, V_WOOD_D)
	r(0, 372, 960, 100, Color("3a2a1a"))
	for k in range(16):
		r(k * 60.0, 372, 2, 100, Color("2e2014"))


## The flash state of a lighthouse showing `n` flashes in a group.
func _v_flash(n: int, phase: float) -> bool:
	var cyc := fmod(t + phase, 6.0)
	if cyc >= n * 0.6:
		return false
	return fmod(cyc, 0.6) < 0.3


func _v_sea(x: float, y: float, w: float, h: float, lights: bool) -> void:
	r(x, y, w, h, V_SKY)
	var sea_y := y + h * 0.55
	r(x, sea_y, w, h * 0.45, V_SEA)
	for k in range(7):
		var wx := x + fmod(k * 140.0 + t * 30.0, w)
		poly([wx, sea_y + 20 + (k % 3) * 18, wx + 40, sea_y + 6 + (k % 3) * 18, wx + 80, sea_y + 20 + (k % 3) * 18], Color("4a5a64"))
	for k in range(20):
		var rx := x + fmod(k * 53.0 + t * 90.0, w)
		ln(rx, y + fmod(k * 31.0 + t * 200.0, h), rx - 8, y + fmod(k * 31.0 + t * 200.0, h) + 20, Color(1, 1, 1, 0.25), 1)
	if not lights:
		return
	var seen: Array = clues.get("seen", [1, 1])
	for side in range(2):
		var lx := x + w * (0.25 + side * 0.5)
		r(lx - 4, sea_y - h * 0.12, 8, h * 0.12, Color("d8d8d0"))
		var on := _v_flash(int(seen[side]), side * 2.3)
		c(lx, sea_y - h * 0.13, 6 if not on else 12, Color("fff2a0") if on else Color("6a6a60"))
		if on:
			poly([lx, sea_y - h * 0.13, lx - w * 0.12, sea_y - h * 0.2, lx - w * 0.12, sea_y - h * 0.06], Color(1, 0.95, 0.6, 0.25))


func _v_inclinometer(x: float, y: float, s: float) -> void:
	var tanks: Array = st.get("tanks", [4, 4, 4])
	var tilt := (int(tanks[2]) - int(tanks[0])) * 0.06
	ci.draw_arc(Vector2(x, y), 34 * s, PI * 0.15, PI * 0.85, 16, BRASS, 4 * s, true)
	ln(x, y, x + sin(tilt) * 30 * s, y + cos(tilt) * 30 * s, INK, 3 * s)
	c(x, y + 34 * s, 3 * s, RED)


func _v1() -> void:
	_v_wall()
	rr(52, 22, 856, 206, V_WOOD_D, 8)
	_v_sea(60, 30, 840, 190, true)
	for k in range(1, 4):
		r(60 + k * 210.0, 30, 8, 190, V_WOOD_D)
	# Ship's bell and the refit plaque.
	ln(100, 232, 100, 248, BRASS_D, 3)
	poly([80, 300, 86, 260, 114, 260, 120, 300], BRASS)
	rr(165, 255, 60, 30, BRASS_D, 3)
	var plaque: Array = clues.get("plaque", [0, 0, 0, 0])
	txt(195, 277, "%d%d%d%d" % [int(plaque[0]), int(plaque[1]), int(plaque[2]), int(plaque[3])], 16, CREAM)
	# Steering compass, wheel, engine telegraph, inclinometer, log book.
	rr(260, 290, 90, 82, V_WOOD_D, 6)
	c(305, 284, 32, BRASS)
	c(305, 284, 24, CREAM)
	ring(480, 300, 50, Color("8a5a30"), 9)
	for k in range(8):
		var a := k * TAU / 8 + 0.2
		ln(480, 300, 480 + cos(a) * 66, 300 + sin(a) * 66, Color("8a5a30"), 6)
	rr(640, 300, 50, 72, BRASS_D, 6)
	c(665, 270, 34, BRASS)
	c(665, 270, 26, CREAM)
	if flag("got_cab") or st.get("done", false):
		ln(665, 270, 665, 240, INK, 4)
	_v_inclinometer(790, 260, 1.0)
	rr(850, 320, 90, 40, Color("2a3a5a"), 4)


func _v2() -> void:
	_v_wall()
	# Signal locker: its lock shows a bell.
	rr(60, 70, 170, 290, STEEL.darkened(0.2), 6)
	rr(120, 140, 50, 40, BRASS, 4)
	poly([132, 172, 136, 150, 154, 150, 158, 172], INK)
	# The ballast diagram on the wall.
	rr(260, 40, 330, 170, PAPER, 4)
	for k in range(3):
		rr(290 + k * 100, 80, 70, 100, Color(0, 0, 0, 0.0), 2)
		ring(325 + k * 100, 130, 30, Color(0.3, 0.2, 0.2, 0.5), 2)
	for k in range(12):
		ln(280 + (k * 37) % 300, 60 + (k * 23) % 130, 300 + (k * 37) % 300, 70 + (k * 23) % 130, [RED, LEAF, Color("3a5ac8")][k % 3], 2)
	# Chart table, the captain's cabinet, the ballast panel.
	rr(260, 250, 330, 120, V_WOOD_D, 6)
	r(270, 236, 310, 26, PAPER)
	rr(610, 220, 100, 150, V_WOOD_D, 6)
	if not flag("level"):
		ln(615, 230, 705, 360, Color(0, 0, 0, 0.25), 2)
	rr(730, 50, 210, 310, STEEL.darkened(0.3), 8)
	for k in range(3):
		rr(750 + k * 64, 90, 48, 160, Color("1e2a30"), 4)
		var lv := int(st.get("tanks", [0, 0, 0])[k])
		r(752 + k * 64, 248 - lv * 19.5, 44, lv * 19.5, Color("3a6a8a"))
	_v_inclinometer(835, 310, 0.8)


func _vbell() -> void:
	board(V_WOOD_D)
	ln(480, 20, 480, 70, Color("c8b080"), 8)
	poly([300, 400, 340, 110, 620, 110, 660, 400], BRASS)
	poly([300, 400, 660, 400, 680, 430, 280, 430], BRASS_D)
	c(480, 110, 40, BRASS_D)
	# The year, engraved small near the rim.
	var y: Array = clues.get("bell", [0, 0, 0, 0])
	txt(560, 392, "%d%d%d%d" % [int(y[0]), int(y[1]), int(y[2]), int(y[3])], 18, Color("6a4a14"))


func _vlocker() -> void:
	board(V_WOOD_D)
	rr(220, 40, 520, 400, STEEL.darkened(0.15), 10)
	if flag("locker_open"):
		rr(250, 70, 460, 340, Color("1a2024"), 6)
		if not flag("got_locker"):
			item("filters", 480, 240, 4.0)
		return
	rr(440, 80, 80, 70, BRASS, 6)
	poly([458, 138, 466, 96, 494, 96, 502, 138], INK)
	kit_wheels(st.get("locker", [0, 0, 0, 0]), 360, 270)


func _vdiagram() -> void:
	board(V_WOOD_D)
	rr(40, 30, 700, 420, PAPER, 6)
	# Three tanks, port, centre, starboard.
	for k in range(3):
		rr(110 + k * 200, 140, 140, 260, Color(0, 0, 0, 0), 4)
		ln(110 + k * 200, 140, 110 + k * 200, 400, INK, 3)
		ln(250 + k * 200, 140, 250 + k * 200, 400, INK, 3)
		ln(110 + k * 200, 400, 250 + k * 200, 400, INK, 3)
	c(180, 110, 8, RED)
	c(580, 110, 8, LEAF)
	# The three plans printed over each other; a glass hides its own colour.
	var cols := [Color("d03a2a"), Color("2a9a3a"), Color("2a5ad0")]
	var plans: Array = clues.get("plans", [])
	var hidden: Array = st.get("filt", [0, 0, 0])
	for p in range(plans.size()):
		if flag("glass_in") and int(hidden[p]) == 1:
			continue
		var plan: Array = plans[p]
		for k in range(3):
			var lv := int(plan[k])
			var ly := 400 - lv * 30.0 + (p - 1) * 3
			ln(114 + k * 200, ly, 246 + k * 200, ly, cols[p], 5)
			txt(180 + k * 200 + (p - 1) * 6, 300 + (p - 1) * 4, str(lv), 60, Color(cols[p], 0.8))
	if not flag("glass_in"):
		return
	for i in range(3):
		var on := int(hidden[i]) == 1
		rr(770, 60 + i * 130.0, 150, 120, Color(cols[i], 0.85 if on else 0.3), 10)
		if on:
			ring(845, 120 + i * 130.0, 20, CREAM, 4)


func _vlog() -> void:
	board(V_WOOD_D)
	rr(140, 20, 680, 440, Color("2a3a5a"), 10)
	r(160, 36, 640, 408, PAPER)
	var today := int(clues.get("today", 0))
	var cols := [Color("d03a2a"), Color("2a9a3a"), Color("2a5ad0")]
	var days := [0, 1, 0, today]
	for k in range(4):
		var y := 80 + k * 95.0
		ln(180, y + 40, 780, y + 40, Color("c9b98a"), 2)
		weather("cloud" if k % 2 else "rain", 240, y, 1.4, INK)
		ln(320, y + 30, 320, y - 20, INK, 3)
		poly([322, y - 20, 380, y - 8, 322, y + 4], cols[days[k]])
		for j in range(5):
			ln(420 + j * 60, y, 460 + j * 60, y + 4, Color("8a8070"), 2)


func _vballast() -> void:
	board(STEEL.darkened(0.4))
	var tanks: Array = st.get("tanks", [0, 0, 0])
	for k in range(3):
		var x := 140 + k * 300.0
		rr(x - 10, 90, 160, 230, Color("1e2a30"), 8)
		var lv := int(tanks[k])
		r(x, 310 - lv * 26.0, 140, lv * 26.0, Color("3a6a8a"))
		for j in range(9):
			ln(x - 8, 310 - j * 26.0, x + 4, 310 - j * 26.0, CREAM, 2)
	c(210, 70, 9, RED)
	c(810, 70, 9, LEAF)
	# Valves between the tanks, the sea cock and the pump on the centre one.
	for v in range(2):
		var vx := 330 + v * 300.0
		r(vx - 40, 300, 80, 12, STEEL)
		c(vx, 365, 30, RED.darkened(0.2))
		for k in range(4):
			var a := k * PI / 4
			ln(vx - cos(a) * 26, 365 - sin(a) * 26, vx + cos(a) * 26, 365 + sin(a) * 26, CREAM, 3)
	rr(420, 20, 120, 60, Color("2a4a6a"), 8)
	for k in range(3):
		ci.draw_arc(Vector2(450 + k * 30, 54), 12, PI, TAU, 8, CREAM, 3, true)
	rr(420, 400, 120, 60, Color("4a3a2a"), 8)
	poly([480, 450, 462, 420, 498, 420], CREAM)
	r(474, 410, 12, 14, CREAM)
	rr(20, 8, 160, 76, Color("1e2a30"), 8)
	_v_inclinometer(100, 26, 1.1)


func _vwindow() -> void:
	board(V_WOOD_D)
	_v_sea(40, 30, 880, 420, true)


func _v_light_icon(n: int, x: float, y: float) -> void:
	r(x - 5, y, 10, 30, INK)
	poly([x - 8, y, x, y - 12, x + 8, y], INK)
	for k in range(n):
		c(x - (n - 1) * 6 + k * 12, y + 44, 4, Color("d0a020"))


func _vchart() -> void:
	board(V_WOOD_D)
	rr(60, 20, 840, 440, Color("e8e0c8"), 6)
	poly([60, 20, 900, 20, 900, 90, 700, 120, 500, 80, 300, 110, 60, 80], Color("d8c89a"))
	for k in range(10):
		ln(80, 140 + k * 30, 880, 140 + k * 30, Color(0.4, 0.5, 0.7, 0.15), 1)
	var pos: Array = clues.get("positions", [])
	for k in range(pos.size()):
		var p: Array = pos[k]
		var cx := 200 + k * 280.0
		var cy := 250.0
		_v_light_icon(int(p[0]), cx - 70, cy - 30)
		_v_light_icon(int(p[1]), cx + 70, cy - 30)
		# An anchor: a position.
		ln(cx, cy - 20, cx, cy + 20, INK, 4)
		ci.draw_arc(Vector2(cx, cy + 10), 14, 0, PI, 10, INK, 4, true)
		ln(cx - 10, cy - 12, cx + 10, cy - 12, INK, 3)
		var course: Array = p[2]
		txt(cx, cy + 90, "%d%d%d°" % [int(course[0]), int(course[1]), int(course[2])], 34, INK)


func _vcompass() -> void:
	board(V_WOOD_D)
	c(480, 110, 80, BRASS_D)
	c(480, 110, 70, CREAM)
	poly([480, 46, 472, 66, 488, 66], RED)
	kit_wheels(st.get("course", [0, 0, 0]), 400, 270)


# --- Base 70° South --------------------------------------------------------------

func _r_wall() -> void:
	r(0, 0, 960, 372, R_WALL)
	for k in range(8):
		r(k * 128.0, 0, 3, 372, R_WALL_D)
	r(0, 372, 960, 100, Color("6a6e72"))
	for k in range(20):
		r(k * 48.0, 372, 2, 100, Color("5a5e62"))


func _r_face(kind: int, x: float, y: float, s: float) -> void:
	if kind == 0:
		c(x, y + 4 * s, 20 * s, Color("7a4a2a"))
	c(x, y, 18 * s, Color("f0c8a0"))
	c(x - 6 * s, y - 3 * s, 2.5 * s, INK)
	c(x + 6 * s, y - 3 * s, 2.5 * s, INK)
	match kind:
		0:
			ci.draw_arc(Vector2(x, y - 2 * s), 18 * s, PI * 1.1, PI * 1.9, 12, Color("7a4a2a"), 6 * s, true)
			ci.draw_arc(Vector2(x, y + 2 * s), 16 * s, 0.15, PI - 0.15, 14, Color("7a4a2a"), 10 * s, true)
			ln(x - 8 * s, y + 6 * s, x + 8 * s, y + 6 * s, Color("7a4a2a"), 4 * s)
		1:
			ci.draw_arc(Vector2(x, y - 6 * s), 18 * s, PI, TAU, 12, R_RED, 10 * s, true)
			c(x, y - 28 * s, 6 * s, CREAM)
		2:
			ring(x - 7 * s, y - 3 * s, 6 * s, INK, 2 * s)
			ring(x + 7 * s, y - 3 * s, 6 * s, INK, 2 * s)
			ci.draw_arc(Vector2(x, y + 4 * s), 7 * s, 0.4, PI - 0.4, 8, INK, 2 * s, true)
		_:
			rr(x - 18 * s, y + 10 * s, 36 * s, 10 * s, Color("2f8a4a"), 4 * s)
			r(x + 6 * s, y + 18 * s, 8 * s, 14 * s, Color("2f8a4a"))
	if kind != 0 and kind != 2:
		ci.draw_arc(Vector2(x, y + 4 * s), 7 * s, 0.4, PI - 0.4, 8, INK, 2 * s, true)


## Shifts: dawn (sun rising), day (sun), dusk (sun setting), night (moon).
func _r_shift(k: int, x: float, y: float, s: float) -> void:
	match k:
		0, 2:
			ci.draw_arc(Vector2(x, y + 6 * s), 14 * s, PI, TAU, 12, Color("f0a030"), 14 * s, true)
			ln(x - 22 * s, y + 6 * s, x + 22 * s, y + 6 * s, INK, 2 * s)
			var dy := -1.0 if k == 0 else 1.0
			ln(x + 18 * s, y - 8 * s, x + 18 * s, y - 8 * s - dy * 14 * s, INK, 2 * s)
			poly([x + 13 * s, y - 8 * s - dy * 10 * s, x + 23 * s, y - 8 * s - dy * 10 * s, x + 18 * s, y - 8 * s - dy * 18 * s], INK)
		1:
			c(x, y, 12 * s, Color("f0c030"))
			for j in range(8):
				var a := j * TAU / 8
				ln(x + cos(a) * 16 * s, y + sin(a) * 16 * s, x + cos(a) * 22 * s, y + sin(a) * 22 * s, Color("f0c030"), 2 * s)
		_:
			c(x, y, 14 * s, Color("e8e8f0"))
			c(x + 7 * s, y - 4 * s, 12 * s, Color("2a3040"))


func _r1() -> void:
	_r_wall()
	# The window: white-out.
	rr(620, 30, 300, 120, Color("8a9098"), 6)
	r(630, 40, 280, 100, Color("f0f2f4"))
	for k in range(16):
		var sx := 630 + fmod(k * 41.0 + t * 120.0, 280.0)
		ln(sx, 40 + (k * 13) % 100, sx - 12, 46 + (k * 13) % 100, Color(0.8, 0.82, 0.85), 2)
	# The duty board.
	rr(50, 50, 240, 220, Color("8a6a40"), 6)
	for k in range(4):
		_r_shift(k, 85 + k * 56, 90, 0.7)
		rr(65 + k * 56, 130, 40, 50, CREAM, 4)
	rr(150, 210, 40, 40, STEEL, 4)
	# The map, the log book, the radio desk.
	rr(320, 40, 270, 190, Color("e8e0c8"), 4)
	for k in range(5):
		ci.draw_arc(Vector2(450, 140), 20.0 + k * 16, 0.3, 5.0, 20, Color("9a8a6a"), 2, true)
	rr(330, 290, 130, 60, Color("2a4a7a"), 4)
	rr(610, 230, 320, 140, Color("5a6066"), 6)
	rr(630, 180, 160, 100, Color("3a3e44"), 6)
	for k in range(3):
		c(660 + k * 50, 240, 16, STEEL)
	c(770, 200, 7, Color("5aff5a") if flag("power") else Color("2a3a2a"))
	rr(810, 190, 100, 90, Color("e8e4d8"), 4)


func _r_crate_cells(i: int) -> Rect2:
	var at: Array = st.get("crates", [])
	var sizes: Array = clues.get("crates", [])
	if i >= sizes.size() or at.size() < i * 2 + 2:
		return Rect2()
	var len := int(sizes[i][0])
	var lying := int(sizes[i][1]) == 1
	var cell := Set6Views.STORE_CELL
	return Rect2(Set6Views.STORE_X + int(at[i * 2]) * cell, Set6Views.STORE_Y + int(at[i * 2 + 1]) * cell, cell * (len if lying else 1), cell * (1 if lying else len))


func _r2() -> void:
	_r_wall()
	# The frozen store, seen from the door.
	rr(50, 50, 400, 320, Color("8a9aa8"), 6)
	for k in range(7):
		rr(70 + (k % 4) * 90, 80 + floorf(k / 4.0) * 120, 80, 100, R_RED if k == 2 else Color("a07a4a"), 4)
	# The team photo.
	rr(490, 50, 170, 110, Color("3a3a3a"), 4)
	r(500, 60, 150, 90, Color("d8dce0"))
	for k in range(4):
		_r_face(k, 525 + k * 34, 110, 0.7)
	# The generator.
	rr(470, 210, 220, 160, R_YELLOW, 8)
	rr(490, 230, 80, 60, Color("3a3a3a"), 4)
	c(640, 260, 18, Color("3a3a3a"))
	c(640, 260, 8, Color("5aff5a") if flag("power") else Color("6a2a2a"))
	# The airlock.
	rr(730, 30, 210, 340, Color("6a7078"), 10)
	ring(835, 180, 50, Color("4a4e54"), 10)
	for k in range(4):
		var a := k * PI / 4
		ln(835 - cos(a) * 50, 180 - sin(a) * 50, 835 + cos(a) * 50, 180 + sin(a) * 50, Color("4a4e54"), 6)
	rr(880, 270, 40, 50, Color("2a2a2a"), 4)
	c(835, 60, 8, R_RED)


func _rboard() -> void:
	board(Color("6a5a40"))
	rr(140, 40, 680, 400, Color("8a6a40"), 10)
	if flag("board_open"):
		rr(180, 80, 600, 320, Color("2a2018"), 6)
		if not flag("got_board"):
			item("uvlamp", 480, 240, 3.2)
		return
	var vals: Array = st.get("board", [0, 0, 0, 0])
	for k in range(4):
		var cx := 300 + k * 120.0
		_r_shift(k, cx, 120, 1.3)
		arrow_btn(cx - 30, 220, 60, 46, 0)
		rr(cx - 30, 272, 60, 80, CREAM, 6)
		_r_face(int(vals[k]) % 4, cx, 310, 1.1)
		arrow_btn(cx - 30, 358, 60, 46, 1)


## The log book's notes: a's shift directly before b's (touching boxes),
## a's earlier than b's (an arrow with dots), a not on a shift (a cross).
func _rlog() -> void:
	board(Color("6a6e72"))
	rr(120, 20, 720, 440, Color("2a4a7a"), 10)
	r(140, 34, 680, 412, PAPER)
	for k in range(4):
		_r_shift(k, 260 + k * 150, 80, 1.0)
		if k < 3:
			poly([320 + k * 150, 74, 336 + k * 150, 80, 320 + k * 150, 86], INK)
	ln(160, 118, 800, 118, INK, 2)
	var notes: Array = clues.get("notes", [])
	for k in range(notes.size()):
		var n: Array = notes[k]
		var y := 170 + k * 72.0
		_r_face(int(n[1]), 300, y, 1.0)
		match int(n[0]):
			0:
				rr(380, y - 16, 36, 32, Color(0, 0, 0, 0), 3)
				ring(398, y, 2, INK, 1)
				rr(372, y - 14, 34, 28, Color("d8d0b8"), 3)
				rr(406, y - 14, 34, 28, Color("c8c0a8"), 3)
				poly([458, y, 440, y - 8, 440, y + 8], INK)
				_r_face(int(n[2]), 560, y, 1.0)
			1:
				for j in range(4):
					c(380 + j * 18, y, 3, INK)
				ln(450, y, 500, y, INK, 3)
				poly([500, y - 8, 516, y, 500, y + 8], INK)
				_r_face(int(n[2]), 560, y, 1.0)
			_:
				ln(390, y - 14, 418, y + 14, RED, 5)
				ln(418, y - 14, 390, y + 14, RED, 5)
				_r_shift(int(n[2]), 560, y, 1.0)


func _rmap() -> void:
	board(Color("6a6e72"))
	rr(100, 20, 760, 440, Color("ece6d4"), 6)
	for k in range(9):
		ci.draw_arc(Vector2(420, 260), 30.0 + k * 22, 0.2, 5.2, 28, Color("a89a7a"), 2, true)
	for k in range(6):
		ln(100 + k * 152, 20, 100 + k * 152, 460, Color(0.4, 0.4, 0.5, 0.2), 1)
	# Printed grid numbers along the edges.
	var printed: Array = clues.get("printed", [0, 0, 0, 0])
	txt(130, 60, "%d%d" % [int(printed[0]), int(printed[1])], 26, INK)
	txt(820, 440, "%d%d" % [int(printed[2]), int(printed[3])], 26, INK)
	# The station and its radio mast.
	rr(600, 300, 50, 30, R_RED, 3)
	ln(660, 330, 660, 260, INK, 3)
	poly([650, 262, 660, 248, 670, 262], INK)
	if not flag("uv_seen"):
		return
	r(100, 20, 760, 440, Color(0.45, 0.2, 0.9, 0.18))
	var freq: Array = clues.get("freq", [0, 0, 0])
	for k in range(3):
		txt(700 + k * 46, 250, str(int(freq[k])), 52, Color(0.85, 0.6, 1.0, 0.95))
	ci.draw_arc(Vector2(660, 248), 26, -0.8, 0.8, 8, Color(0.85, 0.6, 1.0), 3, true)


func _rradio() -> void:
	board(Color("4a4e54"))
	rr(120, 40, 400, 380, Color("5a6066"), 10)
	c(320, 100, 12, Color("5aff5a") if flag("power") else Color("2a3a2a"))
	kit_wheels(st.get("radio", [0, 0, 0]), 240, 270)
	# The teleprinter.
	rr(560, 60, 360, 360, Color("d8d4c8"), 8)
	r(600, 90, 280, 220, Color("f6f2e6"))
	if flag("printed"):
		var msg: Array = clues.get("message", [])
		for k in range(msg.size()):
			_r_face(int(msg[k]), 640 + k * 68, 200, 1.0)


func _rcrates() -> void:
	board(Color("8a9aa8"))
	var x := Set6Views.STORE_X
	var y := Set6Views.STORE_Y
	var cell := Set6Views.STORE_CELL
	rr(x - 12, y - 12, cell * 6 + 24, cell * 6 + 24, Color("5a6066"), 8)
	r(x, y, cell * 6, cell * 6, Color("c8d2da"))
	# The way out on the right of the red crate's row.
	r(x + cell * 6, y + cell * 2, 16, cell, Color("c8d2da"))
	var sel := int(st.get("sel", [0])[0])
	var sizes: Array = clues.get("crates", [])
	for i in range(sizes.size()):
		if i == 0 and flag("crates_done"):
			continue
		var b := _r_crate_cells(i)
		rr(b.position.x + 3, b.position.y + 3, b.size.x - 6, b.size.y - 6, R_RED if i == 0 else Color("a07a4a"), 6)
		ln(b.position.x + 8, b.position.y + 8, b.end.x - 8, b.end.y - 8, Color(0, 0, 0, 0.2), 2)
		if i == sel:
			ci.draw_rect(Rect2(b.position + Vector2(2, 2), b.size - Vector2(4, 4)), R_YELLOW, false, 4)
	var size := cell * 6
	arrow_btn(x + size / 2 - 50, y - 48, 100, 40, 0)
	arrow_btn(x + size / 2 - 50, y + size + 8, 100, 40, 1)
	arrow_btn(x - 80, y + size / 2 - 50, 60, 100, 2)
	arrow_btn(x + size + 20, y + size / 2 - 50, 60, 100, 3)
	rr(70, 370, 130, 70, Color(0, 0, 0, 0.3), 12)
	ci.draw_arc(Vector2(135, 405), 20, -2.6, 2.2, 20, CREAM, 4, true)
	if flag("crates_done") and not flag("got_crate"):
		rr(780, 170, 140, 70, R_RED, 6)
		item("rfuse", 850, 205, 1.6)


func _rairlock() -> void:
	board(Color("4a4e54"))
	rr(160, 30, 640, 420, Color("6a7078"), 14)
	c(480, 100, 12, Color("5aff5a") if flag("printed") else R_RED)
	kit_wheels(st.get("airlock", [0, 0, 0, 0]), 360, 270)
