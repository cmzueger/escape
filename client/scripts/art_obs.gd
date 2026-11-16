## Draws Col Sidereal (the study S1 to S3, the dome D1 to D3 and their
## close-ups) on top of ArtLight; other views are drawn by the parents. What
## the clues show comes from the rules ("clues"); hotspots are in
## views_obs.gd.
class_name ArtObs
extends ArtLight

const O_WALL := Color("575a7c")
const O_WALL_D := Color("474a68")
const O_FLOOR := Color("3e3c4c")
const O_FLOOR_D := Color("31303e")
const NIGHT_SKY := Color("0b0d22")
const SILVER := Color("c8ccd8")
const SILVER_D := Color("8a8fa2")
const O_WOOD := Color("5a5068")
const O_WOOD_D := Color("433b50")
const O_PAPER := Color("e4e4f0")
const VIOLET := Color("8a6fd0")
const MOON := Color("f2f4ff")
const BOOK_COLOURS := {
	"blue": Color("3b6fb0"), "orange": Color("d98a3a"), "red": Color("c0453c"), "grey": Color("8a8f98"),
	"green": Color("4f9a5a"), "violet": Color("8a5fc0"), "white": Color("e8e8ee"), "yellow": Color("dcc04a"),
}
## Each constellation: its stars in a 30 x 30 box and the lines between them.
const STARS := {
	"arc": [[[2, 22], [8, 11], [15, 7], [22, 11], [28, 22]], [[0, 1], [1, 2], [2, 3], [3, 4]]],
	"w": [[[2, 7], [8, 23], [15, 11], [22, 23], [28, 7]], [[0, 1], [1, 2], [2, 3], [3, 4]]],
	"kite": [[[15, 2], [24, 12], [15, 20], [6, 12], [15, 29]], [[0, 1], [1, 2], [2, 3], [3, 0], [2, 4]]],
	"hook": [[[20, 2], [20, 14], [17, 24], [9, 27], [4, 20]], [[0, 1], [1, 2], [2, 3], [3, 4]]],
	"cross": [[[15, 2], [15, 28], [3, 13], [27, 13], [15, 13]], [[0, 4], [4, 1], [2, 4], [4, 3]]],
	"y": [[[4, 3], [26, 3], [15, 15], [15, 28]], [[0, 2], [1, 2], [2, 3]]],
	"tri": [[[15, 3], [27, 25], [3, 25]], [[0, 1], [1, 2], [2, 0]]],
	"arrow": [[[3, 15], [27, 15], [19, 6], [19, 24], [12, 15]], [[0, 4], [4, 1], [1, 2], [1, 3]]],
}
## Where each plaque hangs: the dome view and its x.
const PLAQUES := [["D1", 140], ["D1", 300], ["D1", 800], ["D2", 200], ["D2", 760], ["D3", 100], ["D3", 250], ["D3", 400]]
const PLAQUE_Y := 262.0


func draw_view(view: String) -> void:
	match view:
		"S1": _study1()
		"S2": _study2()
		"S3": _study3()
		"D1": _dome1()
		"D2": _dome2()
		"D3": _dome3()
		"clocks": _clocks()
		"notes": _notes()
		"drawer": _drawer()
		"books": _books()
		"cabinet": _cabinet()
		"skymap": _skymap()
		"board": _switchboard()
		"atlas": _atlas()
		"plani": _plani()
		"box": _box()
		"orrery": _orrery()
		"scope": _scope()
		"balance": _balance()
		"plate": _plate()
		"door": _door()
		_:
			super.draw_view(view)
			return
	home()


# --- Small pictures ---------------------------------------------------------------

func constel(name: String, x: float, y: float, s: float, col: Color) -> void:
	var data: Array = STARS.get(name, [[], []])
	var pts: Array = data[0]
	for seg in data[1]:
		var a: Array = pts[seg[0]]
		var b: Array = pts[seg[1]]
		ln(x + (a[0] - 15) * s, y + (a[1] - 15) * s, x + (b[0] - 15) * s, y + (b[1] - 15) * s, Color(col, col.a * 0.6), maxf(1.2, 1.3 * s))
	for p in pts:
		c(x + (p[0] - 15) * s, y + (p[1] - 15) * s, maxf(1.8, 2.3 * s), col)


func shape_at(i: int) -> String:
	var shapes: Array = clues.get("shapes", [])
	return shapes[i] if i >= 0 and i < shapes.size() else ""


func sun(x: float, y: float, rad: float, col: Color) -> void:
	c(x, y, rad * 0.55, col)
	for i in range(8):
		var a := TAU * i / 8.0
		ln(x + cos(a) * rad * 0.75, y + sin(a) * rad * 0.75, x + cos(a) * rad, y + sin(a) * rad, col, 2.5)


func star5(x: float, y: float, rad: float, col: Color) -> void:
	var pts := []
	for i in range(10):
		var a := TAU * i / 10.0 - PI / 2
		var d := rad if i % 2 == 0 else rad * 0.45
		pts.append_array([x + cos(a) * d, y + sin(a) * d])
	poly(pts, col)


func dial(x: float, y: float, rad: float, hm: Array, face: Color) -> void:
	c(x, y, rad + 6, SILVER_D)
	c(x, y, rad, face)
	for i in range(12):
		var a := TAU * i / 12.0
		ln(x + cos(a) * rad * 0.84, y + sin(a) * rad * 0.84, x + cos(a) * rad * 0.96, y + sin(a) * rad * 0.96, INK, maxf(1.5, rad * 0.03))
	var m := float(hm[1])
	var h := float(hm[0]) + m / 60.0
	var ha := TAU * h / 12.0 - PI / 2
	var ma := TAU * m / 60.0 - PI / 2
	ln(x, y, x + cos(ha) * rad * 0.52, y + sin(ha) * rad * 0.52, INK, maxf(3, rad * 0.07))
	ln(x, y, x + cos(ma) * rad * 0.8, y + sin(ma) * rad * 0.8, INK, maxf(2, rad * 0.04))
	c(x, y, maxf(3, rad * 0.06), INK)


func planet(name: String, x: float, y: float, rad: float) -> void:
	match name:
		"red":
			c(x, y, rad, Color("c8553f"))
		"ringed":
			c(x, y, rad, Color("d9c27a"))
			ci.draw_arc(Vector2(x, y), rad * 1.6, -0.5, PI + 0.5, 16, Color("efe2b0"), maxf(2, rad * 0.25), true)
		_:
			c(x, y, rad * 0.8, Color("9aa0ae"))


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"gkey":
			super.item("dkey", x, y, s * 1.2)
			return
		"akey":
			super.item("key", x, y, s * 0.8)
			return
		"page":
			at(x, y, 0.0, s)
			poly([-13, -17, 9, -17, 13, -11, 11, 17, -13, 17], O_PAPER)
			for k in range(3):
				ln(-8, -8 + k * 8, 7, -8 + k * 8, INK.lightened(0.3), 2)
		"eyepiece":
			at(x, y, 0.0, s)
			rr(-9, -16, 18, 22, SILVER, 3)
			rr(-13, 4, 26, 12, SILVER_D, 3)
			c(0, -16, 7, Color("7fb2d6"))
		"plate":
			at(x, y, 0.0, s)
			rr(-16, -13, 32, 26, IRON_D, 3)
			rr(-12, -9, 24, 18, Color(0.75, 0.8, 0.95, 0.5), 2)
		"weights":
			at(x, y, 0.0, s)
			for k in range(3):
				rr(-17 + k * 12, -4 - k * 4, 11, 16 + k * 4, SILVER_D, 2)
				r(-14 + k * 12, -8 - k * 4, 5, 5, SILVER)
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	if room != "obs":
		super.card(room, w, h)
		return
	r(0, 0, w, h, NIGHT_SKY)
	for i in range(40):
		c(fmod(i * 61.0, w), fmod(i * 37.0, h * 0.8), 0.8 + (i % 3) * 0.5, Color(1, 1, 1, 0.45 + 0.4 * sin(t * 1.5 + i)))
	c(w * 0.8, h * 0.26, 15, MOON)
	c(w * 0.83, h * 0.22, 13, NIGHT_SKY)
	poly([0, h, 0, h * 0.72, w * 0.25, h * 0.5, w * 0.42, h * 0.74, w * 0.6, h * 0.56, w * 0.85, h * 0.8, w, h * 0.7, w, h], Color("23263f"))
	r(w * 0.36, h * 0.6, w * 0.2, h * 0.4, SILVER_D)
	var dome := []
	for k in range(13):
		var a := PI + PI * k / 12.0
		dome.append_array([w * 0.46 + cos(a) * w * 0.115, h * 0.6 + sin(a) * h * 0.3])
	poly(dome, SILVER)
	poly([w * 0.44, h * 0.6, w * 0.455, h * 0.31, w * 0.485, h * 0.31, w * 0.49, h * 0.6], NIGHT_SKY)


# --- The study -----------------------------------------------------------------------

func study_wall() -> void:
	r(0, 0, 960, 372, O_WALL)
	for i in range(13):
		r(i * 80.0, 0, 2, 250, O_WALL_D)
	r(0, 250, 960, 122, O_WALL_D)
	r(0, 250, 960, 5, O_WOOD_D)
	for i in range(13):
		r(i * 80.0 + 10, 266, 60, 94, O_WALL_D.darkened(0.12))
	r(0, 372, 960, 100, O_FLOOR)
	for i in range(9):
		ln(i * 120 - 20, 372, i * 150 - 150, 472, O_FLOOR_D, 2)
	r(0, 368, 960, 6, O_WOOD_D)


func _desk_lamp(x: float, y: float) -> void:
	rr(x - 15, y - 14, 30, 14, SILVER_D, 5)
	ci.draw_arc(Vector2(x - 12, y - 14), 24, -PI / 2, 0.1, 12, SILVER_D, 5, true)
	poly([x - 34, y - 44, x - 6, y - 44, x + 2, y - 30, x - 42, y - 30], VIOLET.darkened(0.2))
	c(x - 20, y - 30, 6, Color("fff1a8"))


func _study1() -> void:
	study_wall()
	# The way out, with its time lock.
	r(40, 104, 134, 270, O_WOOD_D)
	r(50, 114, 114, 260, O_WOOD)
	r(50, 232, 114, 3, O_WOOD_D)
	rr(118, 214, 38, 46, SILVER_D, 5)
	for k in range(4):
		rr(122.0 + k * 8.0, 226, 6, 12, O_PAPER, 1)
	c(137, 248, 4, IRON_D)
	# Two clocks: sun time and star time.
	sun(280, 52, 13, AMBER)
	dial(280, 122, 44, clues.get("sun_clock", [12, 0]), O_PAPER)
	star5(400, 52, 12, MOON)
	dial(400, 122, 44, clues.get("star_clock", [12, 0]), O_PAPER)
	# The note with three colours.
	rr(520, 104, 112, 54, O_PAPER, 2)
	c(576, 108, 4, RED)
	var note: Array = clues.get("note_colours", [])
	for i in range(note.size()):
		rr(530.0 + i * 32.0, 118, 28, 32, INK, 3)
		rr(532.0 + i * 32.0, 120, 24, 28, BOOK_COLOURS.get(note[i], INK), 2)
	# Desk, notebook, planisphere, lamp.
	rr(480, 296, 330, 16, O_WOOD, 3)
	r(494, 312, 14, 64, O_WOOD_D)
	r(782, 312, 14, 64, O_WOOD_D)
	if flag("drawer_open"):
		rr(604, 318, 152, 36, Color("15141f"), 3)
		rr(600, 340, 160, 28, O_WOOD, 3)
	else:
		rr(604, 314, 152, 34, O_WOOD_D, 3)
		for k in range(3):
			rr(650.0 + k * 22.0, 322, 16, 18, O_PAPER, 2)
	poly([500, 296, 508, 278, 546, 280, 544, 296], O_PAPER)
	poly([544, 296, 546, 280, 584, 278, 590, 296], O_PAPER.darkened(0.06) if flag("page_in") else O_WOOD.lightened(0.1))
	ci.draw_set_transform(Vector2(660, 288), 0.0, Vector2(1.0, 0.32))
	c(0, 0, 40, SILVER_D)
	c(0, 0, 34, Color("2a2d4f"))
	for i in range(8):
		c(cos(i * 0.785) * 22, sin(i * 0.785) * 22, 3, MOON)
	home()
	_desk_lamp(770, 296)


func _book_row(x: float, y: float, w: float, h: float, big: bool) -> void:
	var books: Array = clues.get("books", [])
	for i in range(books.size()):
		var bx := x + i * w
		var col: Color = BOOK_COLOURS.get(books[i]["colour"], INK)
		rr(bx + 2, y, w - 4, h, col, 3)
		r(bx + 2, y + h * 0.12, w - 4, 3, col.darkened(0.3))
		r(bx + 2, y + h * 0.84, w - 4, 3, col.darkened(0.3))
		var ink := INK if col.get_luminance() > 0.5 else Color.WHITE
		constel(books[i]["shape"], bx + w / 2, y + h * 0.48, 1.9 if big else 0.72, ink)


func _study2() -> void:
	study_wall()
	# Bookshelf.
	rr(56, 56, 372, 322, O_WOOD_D, 4)
	for k in range(3):
		r(66, 66 + k * 104.0, 352, 94, Color("1f1e2c"))
	var dull := [Color("4a4660"), Color("5d5876"), Color("3d3a52"), Color("686283")]
	for k in [0, 2]:
		for i in range(13):
			var bh: float = 62.0 + (i * 7 + k * 5) % 22
			r(70 + i * 26.0, 66 + k * 104.0 + 94 - bh, 22, bh, dull[(i + k) % 4])
	_book_row(104, 174, 34, 90, false)
	# The atlas in its glass case.
	r(520, 318, 20, 58, O_WOOD_D)
	rr(462, 300, 136, 20, O_WOOD, 3)
	if flag("atlas_open"):
		poly([476, 300, 486, 276, 530, 278, 528, 300], O_PAPER)
		poly([528, 300, 530, 278, 574, 276, 584, 300], O_PAPER.darkened(0.06))
	else:
		rr(486, 282, 88, 18, VIOLET.darkened(0.3), 2)
		rr(468, 246, 124, 56, Color(0.8, 0.85, 1, 0.2), 4)
		rr(522, 290, 16, 14, SILVER, 2)
	# Instrument cabinet.
	rr(640, 150, 160, 226, O_WOOD_D, 4)
	if flag("cabinet_open"):
		r(650, 160, 140, 206, Color("15141f"))
		r(650, 260, 140, 5, O_WOOD_D)
		if not flag("got_cabinet"):
			item("eyepiece", 700, 236, 1.5)
			item("fuse", 750, 340, 1.4)
	else:
		r(650, 160, 68, 206, O_WOOD)
		r(722, 160, 68, 206, O_WOOD)
		rr(690, 244, 60, 30, SILVER_D, 3)
		for k in range(4):
			rr(696.0 + k * 13.0, 250, 10, 18, O_PAPER, 1)
	# The stair to the dome, behind its gate.
	r(838, 40, 112, 334, Color("1f1e2c"))
	for i in range(8):
		poly([838, 360 - i * 40.0, 950, 340 - i * 40.0, 950, 352 - i * 40.0, 838, 372 - i * 40.0], O_WOOD if i % 2 == 0 else O_WOOD_D)
	if not flag("gate_open"):
		for k in range(6):
			r(842 + k * 20.0, 120, 5, 254, SILVER_D)
		r(838, 120, 112, 6, SILVER_D)
		r(838, 240, 112, 6, SILVER_D)
		rr(880, 228, 28, 30, SILVER, 4)
	else:
		poly([838, 120, 820, 132, 820, 380, 838, 374], SILVER_D)


func _study3() -> void:
	study_wall()
	# The wall map of the sky.
	rr(70, 44, 500, 268, O_WOOD_D, 4)
	r(82, 56, 476, 244, Color("14173a"))
	var shapes: Array = clues.get("shapes", [])
	for i in range(shapes.size()):
		constel(shapes[i], MAP_SPOTS_O[i][0] * 0.55 + 62, MAP_SPOTS_O[i][1] * 0.55 + 50, 0.9, MOON)
	# The switchboard.
	rr(640, 96, 250, 210, SILVER_D.darkened(0.3), 6)
	var lamps: Array = st.get("lamps", [0, 0, 0, 0, 0, 0])
	for k in range(lamps.size()):
		c(672.0 + k * 37.0, 160, 11, AMBER if int(lamps[k]) == 1 and flag("fuse_in") else Color("2a2836"))
		rr(664.0 + k * 37.0, 220, 16, 34, SILVER, 3)
	rr(742, 112, 46, 20, IRON_D, 3)
	# A globe.
	r(648, 380, 44, 8, O_WOOD_D)
	r(666, 350, 8, 32, O_WOOD_D)
	c(670, 322, 34, Color("3d5f8a"))
	ci.draw_arc(Vector2(670, 322), 38, -1.2, 1.9, 20, SILVER_D, 4, true)
	poly([650, 306, 668, 300, 676, 318, 660, 330], Color("6f9a6a"))


# --- The dome -------------------------------------------------------------------------

func dome_wall() -> void:
	r(0, 0, 960, 380, O_WALL)
	for i in range(9):
		var x := i * 120.0
		var pts := PackedVector2Array()
		for k in range(9):
			var f := k / 8.0
			pts.append(Vector2(x + (480 - x) * 0.5 * f * f, 380 - 420 * f))
		ci.draw_polyline(pts, O_WALL_D, 5, true)
	for i in range(4):
		var pts2 := PackedVector2Array()
		for k in range(17):
			pts2.append(Vector2(k * 60.0, 232 - i * 70.0 - (40 - i * 4.0) * (1.0 - pow((k * 60.0 - 480) / 480.0, 2))))
		ci.draw_polyline(pts2, O_WALL_D, 3, true)
	# The rail the dome turns on.
	r(0, 316, 960, 20, SILVER_D.darkened(0.35))
	r(0, 316, 960, 3, SILVER_D)
	var deck := [0.0, 472.0, 0.0, 372.0]
	for k in range(1, 17):
		deck.append_array([k * 60.0, 372.0 - _curve(k * 60.0)])
	deck.append_array([960.0, 472.0])
	poly(deck, O_FLOOR)
	for i in range(9):
		ln(i * 120.0, 376 - _curve(i * 120.0), i * 170.0 - 200, 472, O_FLOOR_D, 2)


## The plaques of one dome view, the slit and the moonbeam.
func _plaques(view: String) -> void:
	var dome := int(st.get("dome", 0))
	var lit := int(st.get("lit", -1))
	var digits: Array = clues.get("plaque_digits", [])
	for i in range(PLAQUES.size()):
		if PLAQUES[i][0] != view:
			continue
		var x: float = PLAQUES[i][1]
		if i == dome:
			# The slit stands over this plaque: sky, stars, the moon.
			poly([x - 46, 0, x + 46, 0, x + 36, 190, x - 36, 190], SILVER_D)
			poly([x - 38, 0, x + 38, 0, x + 30, 182, x - 30, 182], NIGHT_SKY)
			for k in range(22):
				c(x - 26 + fmod(k * 23.0, 52.0), 8 + fmod(k * 41.0, 164.0), 0.9 + (k % 3) * 0.5, Color(1, 1, 1, 0.5 + 0.4 * sin(t * 1.3 + k)))
			c(x + 6, 52, 15, MOON)
			c(x + 13, 48, 13, NIGHT_SKY)
		if i == lit:
			poly([x - 44, PLAQUE_Y - 44, x + 44, PLAQUE_Y - 44, x + 150, 0, x - 150, 0], Color(0.8, 0.84, 1, 0.07))
			rr(x - 44, PLAQUE_Y - 44, 88, 88, Color(0.8, 0.84, 1, 0.35), 8)
		rr(x - 36, PLAQUE_Y - 36, 72, 72, SILVER_D, 6)
		rr(x - 31, PLAQUE_Y - 31, 62, 62, Color("2a2d4f"), 4)
		if i == lit and i < digits.size():
			constel(shape_at(i), x, PLAQUE_Y - 12, 1.0, MOON)
			txt(x, PLAQUE_Y + 26, str(int(digits[i])), 28, MOON)
		else:
			constel(shape_at(i), x, PLAQUE_Y, 1.5, SILVER)
		rr(x - 26, 318, 52, 20, Color("15141f"), 4)
		txt(x, 334, "%d h" % (i * 3), 16, MOON)


func _dome1() -> void:
	dome_wall()
	_plaques("D1")
	# The telescope on its pier.
	poly([520, 396, 532, 300, 572, 300, 584, 396], SILVER_D)
	ci.draw_set_transform(Vector2(552, 292), -1.0, Vector2.ONE)
	rr(-120, -22, 250, 44, SILVER, 14)
	rr(112, -30, 46, 60, SILVER_D, 8)
	rr(-146, -12, 30, 24, SILVER_D, 4)
	if flag("eye_on"):
		rr(-168, -8, 24, 16, IRON_D, 3)
	home()
	c(552, 292, 22, SILVER_D)
	c(552, 292, 9, O_WALL_D)
	# The counterweight bar.
	ln(552, 292, 640, 330, SILVER_D, 7)
	if flag("weights_on"):
		rr(626, 318, 26, 30, IRON_D, 4)


func _dome2() -> void:
	dome_wall()
	_plaques("D2")
	# The wheel that turns the dome.
	var spin := float(st.get("dome", 0)) * 0.785
	rr(440, 300, 80, 76, SILVER_D.darkened(0.3), 6)
	ring(480, 236, 54, SILVER, 9)
	for k in range(4):
		var a := spin + k * PI / 4
		ln(480 - cos(a) * 54, 236 - sin(a) * 54, 480 + cos(a) * 54, 236 + sin(a) * 54, SILVER, 6)
	c(480, 236, 12, SILVER_D)
	c(480, 356, 7, AMBER if flag("power") else Color("2a2836"))
	arrow_btn(350, 204, 64, 64, 2)
	arrow_btn(546, 204, 64, 64, 3)


func _dome3() -> void:
	dome_wall()
	_plaques("D3")
	# The orrery on its table.
	rr(540, 338, 190, 12, O_WOOD, 3)
	r(626, 350, 18, 40, O_WOOD_D)
	rr(600, 318, 70, 22, SILVER_D if not flag("orrery_open") else Color("15141f"), 3)
	ln(635, 318, 635, 250, SILVER_D, 4)
	c(635, 244, 15, AMBER)
	var names := ["red", "ringed", "grey"]
	var places: Array = st.get("planets", [0, 0, 0])
	for k in range(3):
		var rx := 46.0 + k * 26.0
		ci.draw_set_transform(Vector2(635, 244), 0.0, Vector2(1.0, 0.3))
		ring(0, 0, rx, SILVER, 2)
		home()
		var a := float(places[k]) * 0.785 - PI / 2
		planet(names[k], 635 + cos(a) * rx, 244 + sin(a) * rx * 0.3, 7)
	# The box on the wall.
	rr(790, 130, 120, 100, SILVER_D.darkened(0.25), 5)
	if flag("box_open"):
		r(800, 140, 100, 80, Color("15141f"))
	else:
		for k in range(4):
			rr(808.0 + k * 22.0, 166, 18, 26, O_PAPER, 2)


# --- Close-ups ------------------------------------------------------------------------

func obs_board() -> void:
	board(Color("2c2d44"))


func _clocks() -> void:
	obs_board()
	sun(270, 70, 26, AMBER)
	dial(270, 262, 150, clues.get("sun_clock", [12, 0]), O_PAPER)
	star5(690, 70, 24, MOON)
	dial(690, 262, 150, clues.get("star_clock", [12, 0]), O_PAPER)
	for x in [270.0, 690.0]:
		for i in range(1, 13):
			var a := TAU * i / 12.0 - PI / 2
			txt(x + cos(a) * 104, 262 + sin(a) * 104 + 8, str(i), 22, INK)


func _notes() -> void:
	obs_board()
	rr(110, 22, 740, 430, VIOLET.darkened(0.45), 8)
	r(128, 36, 350, 402, O_PAPER)
	var soft := INK.lightened(0.4)
	var tonight: Array = clues.get("tonight", [1, 1, 0])
	# Left page: tonight, and how to find what stands on the meridian.
	txt(300, 100, "%d. %d." % [int(tonight[0]), int(tonight[1])], 40, INK)
	txt(300, 156, "%d h" % int(tonight[2]), 40, INK)
	ln(170, 186, 430, 186, soft, 2)
	ring(300, 300, 78, INK, 3)
	ring(300, 300, 56, soft, 2)
	poly([300, 206, 310, 224, 290, 224], RED)
	for i in range(8):
		c(300 + cos(i * 0.785) * 38, 300 + sin(i * 0.785) * 38, 3.5, INK)
	ci.draw_arc(Vector2(300, 300), 96, -0.3, 0.6, 12, RED, 3, true)
	poly([384, 362, 376, 340, 396, 346], RED)
	# Right page: the planets, if the torn page is back.
	if flag("page_in"):
		r(482, 36, 350, 402, O_PAPER.darkened(0.04))
		var planets: Array = clues.get("planets", [])
		for i in range(planets.size()):
			var y := 120.0 + i * 110.0
			planet(planets[i]["planet"], 570, y, 26)
			ln(630, y, 690, y, soft, 3)
			poly([704, y, 688, y - 9, 688, y + 9], soft)
			txt(752, y + 16, str(int(planets[i]["digit"])), 46, INK)
	else:
		poly([482, 36, 520, 36, 506, 90, 524, 150, 500, 220, 520, 300, 502, 370, 516, 438, 482, 438], O_PAPER.darkened(0.04))
	r(478, 36, 4, 402, soft)


func _shape_wheels(values: Array, x0: float, y0: float) -> void:
	for i in range(values.size()):
		var cx := x0 + i * 100.0
		arrow_btn(cx - 38, y0 - 66, 76, 48, 0)
		rr(cx - 38, y0 - 10, 76, 92, Color("2a2d4f"), 6)
		constel(shape_at(int(values[i])), cx, y0 + 36, 2.2, MOON)
		arrow_btn(cx - 38, y0 + 90, 76, 48, 1)


func _drawer() -> void:
	obs_board()
	rr(140, 40, 680, 400, O_WOOD, 10)
	if flag("drawer_open"):
		rr(190, 90, 580, 300, Color("15141f"), 6)
		if not flag("got_drawer"):
			item("gkey", 380, 240, 3.2)
			item("page", 590, 240, 3.0)
	else:
		rr(190, 90, 580, 300, O_WOOD_D, 6)
		_shape_wheels(st.get("drawer", [0, 0, 0]), 380, 210)


func _books() -> void:
	obs_board()
	rr(60, 40, 840, 400, O_WOOD_D, 6)
	r(76, 56, 808, 368, Color("1f1e2c"))
	_book_row(96, 84, 96, 330, true)


func _cabinet() -> void:
	obs_board()
	rr(200, 30, 560, 420, O_WOOD_D, 10)
	if flag("cabinet_open"):
		rr(230, 60, 500, 360, Color("15141f"), 6)
		if not flag("got_cabinet"):
			item("eyepiece", 380, 250, 3.6)
			txt(380, 350, str(int(clues.get("eyepiece_weight", 0))), 22, SILVER_D)
			item("fuse", 590, 250, 3.0)
	else:
		rr(230, 60, 500, 360, O_WOOD, 6)
		# The plaque: sun time minus star time.
		rr(330, 74, 300, 76, SILVER, 5)
		dial(380, 112, 24, [12, 0], O_PAPER)
		sun(424, 92, 10, INK)
		r(458, 108, 36, 7, INK)
		dial(550, 112, 24, [12, 0], O_PAPER)
		star5(594, 92, 9, INK)
		_wheels(st.get("cabinet", [0, 0, 0, 0]), 360, 262)


const MAP_SPOTS_O := [[430, 96], [760, 120], [170, 330], [820, 330], [640, 250], [300, 170], [560, 380], [150, 110]]


func _skymap() -> void:
	obs_board()
	rr(50, 16, 860, 440, O_WOOD_D, 6)
	r(66, 30, 828, 412, Color("14173a"))
	for i in range(70):
		c(70 + fmod(i * 97.0, 820.0), 34 + fmod(i * 61.0, 404.0), 0.8 + (i % 3) * 0.5, Color(1, 1, 1, 0.3))
	var shapes: Array = clues.get("shapes", [])
	for i in range(mini(shapes.size(), MAP_SPOTS_O.size())):
		constel(shapes[i], MAP_SPOTS_O[i][0], MAP_SPOTS_O[i][1], 2.2, MOON)
	# The comet's path.
	var path: Array = clues.get("path", [])
	var pts := PackedVector2Array()
	for name in path:
		var k := shapes.find(name)
		if k >= 0:
			pts.append(Vector2(MAP_SPOTS_O[k][0], MAP_SPOTS_O[k][1] + 44))
	if pts.size() >= 2:
		for k in range(pts.size() - 1):
			ci.draw_dashed_line(pts[k], pts[k + 1], AMBER, 3, 12)
		c(pts[0].x, pts[0].y, 5, AMBER)
		var last := pts[pts.size() - 1]
		var dir := (last - pts[pts.size() - 2]).normalized()
		var side := Vector2(-dir.y, dir.x)
		ci.draw_colored_polygon(PackedVector2Array([last + dir * 20, last + side * 11, last - side * 11]), AMBER)


func _switchboard() -> void:
	obs_board()
	rr(100, 40, 760, 400, SILVER_D.darkened(0.35), 10)
	rr(420, 60, 120, 48, IRON_D, 5)
	if flag("fuse_in"):
		item("fuse", 480, 84, 2.0)
	var lamps: Array = st.get("lamps", [0, 0, 0, 0, 0, 0])
	for k in range(lamps.size()):
		var x := 190.0 + k * 116.0
		var on: bool = int(lamps[k]) == 1 and flag("fuse_in")
		if on:
			c(x, 200, 44, Color(1, 0.76, 0.3, 0.25))
		c(x, 200, 30, AMBER if on else Color("2a2836"))
		ring(x, 200, 30, IRON_D, 4)
		rr(x - 26, 300, 52, 84, IRON_D, 6)
		rr(x - 12, 312 if on else 344, 24, 30, SILVER, 4)
	if flag("power"):
		r(160, 262, 640, 6, AMBER)


func _atlas() -> void:
	obs_board()
	rr(90, 18, 780, 438, VIOLET.darkened(0.45), 8)
	r(108, 32, 370, 410, O_PAPER)
	r(482, 32, 370, 410, O_PAPER.darkened(0.04))
	var decs: Array = clues.get("declinations", [])
	var shapes: Array = clues.get("shapes", [])
	# In the order of the books, not of the dome.
	var order := [1, 6, 3, 7, 0, 4, 5, 2]
	for n in range(order.size()):
		var i: int = order[n]
		if i >= shapes.size() or i >= decs.size():
			continue
		var x := 150.0 + floorf(n / 4.0) * 374.0
		var y := 86.0 + (n % 4) * 100.0
		constel(shapes[i], x + 30, y, 1.7, INK)
		txt(x + 150, y + 10, "%d h" % (i * 3), 28, INK)
		var dec := int(decs[i])
		txt(x + 260, y + 10, "%s%d°" % ["+" if dec > 0 else ("−" if dec < 0 else ""), absi(dec)], 28, INK)
		ln(x - 20, y + 48, x + 310, y + 48, Color(INK, 0.2), 1)


func _ring_xy(degrees: float, rad: float) -> Vector2:
	var a := deg_to_rad(degrees) - PI / 2
	return Vector2(480 + cos(a) * rad, 236 + sin(a) * rad)


func _plani() -> void:
	obs_board()
	var turn := float(st.get("plani", 0)) * 15.0
	c(480, 236, 226, SILVER_D)
	c(480, 236, 218, O_PAPER)
	# The fixed ring of months.
	for m in range(1, 13):
		var p := _ring_xy((m - 1) * 30.0, 198)
		txt(p.x, p.y + 8, str(m), 22, INK)
		var a := _ring_xy((m - 1) * 30.0 + 15.0, 180)
		var b := _ring_xy((m - 1) * 30.0 + 15.0, 216)
		ln(a.x, a.y, b.x, b.y, Color(INK, 0.35), 1.5)
	# The disc that turns: hours on its rim, the sky inside.
	c(480, 236, 178, SILVER_D)
	c(480, 236, 174, Color("1a1d44"))
	for h in range(24):
		var p2 := _ring_xy(h * 15.0 + turn, 158)
		txt(p2.x, p2.y + 6, str(h), 15, MOON)
	c(480, 236, 140, Color("14173a"))
	var disc: Array = clues.get("disc", [])
	for k in range(disc.size()):
		var p3 := _ring_xy(k * 45.0 + turn, 104)
		constel(disc[k], p3.x, p3.y, 1.3, MOON)
	c(480, 236, 5, SILVER)
	# The meridian: the mark at the top.
	poly([480, 104, 470, 60, 490, 60], RED)
	ln(480, 104, 480, 236, Color(RED, 0.5), 2)
	arrow_btn(120, 200, 96, 76, 2)
	arrow_btn(744, 200, 96, 76, 3)


func _box() -> void:
	obs_board()
	rr(200, 30, 560, 420, SILVER_D.darkened(0.3), 10)
	if flag("box_open"):
		rr(230, 60, 500, 360, Color("15141f"), 6)
		if not flag("got_box"):
			item("plate", 380, 240, 3.4)
			item("akey", 590, 240, 2.8)
	else:
		rr(230, 60, 500, 360, SILVER_D.darkened(0.1), 6)
		# A comet marks what opens it.
		c(520, 100, 9, INK)
		poly([512, 96, 440, 84, 440, 116, 514, 106], Color(INK, 0.5))
		_wheels(st.get("box", [0, 0, 0, 0]), 360, 250)


func _orrery() -> void:
	obs_board()
	var cx := 330.0
	var cy := 236.0
	c(cx, cy, 216, SILVER_D)
	c(cx, cy, 208, Color("1a1d44"))
	for i in range(8):
		var a := i * 0.785 - PI / 2
		constel(shape_at(i), cx + cos(a) * 180, cy + sin(a) * 180, 1.15, MOON)
		ln(cx + cos(a + 0.39) * 156, cy + sin(a + 0.39) * 156, cx + cos(a + 0.39) * 206, cy + sin(a + 0.39) * 206, SILVER_D, 2)
	c(cx, cy, 150, Color("14173a"))
	c(cx, cy, 18, AMBER)
	var names := ["red", "ringed", "grey"]
	var places: Array = st.get("planets", [0, 0, 0])
	for k in range(3):
		var rad := 54.0 + k * 40.0
		ring(cx, cy, rad, Color(SILVER, 0.5), 2)
		var a2 := float(places[k]) * 0.785 - PI / 2
		planet(names[k], cx + cos(a2) * rad, cy + sin(a2) * rad, 13)
		# One row of buttons per planet.
		var y := 96.0 + k * 96.0
		planet(names[k], 640, y + 30, 16)
		arrow_btn(690, y, 76, 60, 2)
		arrow_btn(776, y, 76, 60, 3)
	# The drawer in the base.
	rr(620, 384, 240, 64, O_WOOD_D, 6)
	if flag("orrery_open"):
		rr(630, 392, 220, 48, Color("15141f"), 4)
		if not flag("got_weights"):
			item("weights", 740, 418, 2.0)
	else:
		c(740, 416, 6, SILVER)


func _counter(x: float, y: float, text: String) -> void:
	arrow_btn(x - 60, y - 70, 120, 50, 0)
	rr(x - 60, y - 14, 120, 76, Color("15141f"), 6)
	txt(x, y + 42, text, 40, AMBER)
	arrow_btn(x - 60, y + 68, 120, 50, 1)


func _scope() -> void:
	obs_board()
	# The tube from the side: eyepiece and camera at the left end.
	rr(250, 60, 680, 120, SILVER, 30)
	rr(880, 46, 60, 148, SILVER_D, 10)
	rr(170, 84, 90, 72, SILVER_D, 8)
	if flag("eye_on"):
		rr(104, 98, 70, 44, IRON_D, 6)
		c(104, 120, 16, Color("7fb2d6"))
	else:
		c(170, 120, 20, Color("15141f"))
	# The camera's plate holder on top.
	rr(280, 26, 120, 40, IRON_D, 5)
	if flag("exposed"):
		rr(290, 32, 100, 28, Color(0.75, 0.8, 0.95, 0.6), 3)
	else:
		r(290, 44, 100, 4, Color("15141f"))
	# The setting circles.
	_counter(330, 300, "%d h" % int(st.get("ra", 0)))
	var dec := int(st.get("dec", 0))
	_counter(520, 300, "%s%d°" % ["+" if dec > 0 else ("−" if dec < 0 else ""), absi(dec)])
	# The counterweight bar.
	ln(600, 180, 800, 300, SILVER_D, 12)
	rr(770, 280, 110, 90, IRON_D if flag("weights_on") else Color(0, 0, 0, 0.25), 8)
	c(600, 180, 24, SILVER_D)
	var level := Color("69d06a") if st.get("balanced", false) else Color("3a2c22")
	c(700, 214, 9, level)


func _balance() -> void:
	obs_board()
	var want := int(clues.get("eyepiece_weight", 0)) + int(clues.get("camera_weight", 0))
	var sum := int(st.get("sum", 0)) if flag("weights_on") else 0
	var tilt := 0.0 if st.get("balanced", false) else (0.1 if sum > want else -0.1)
	if not flag("eye_on"):
		tilt = 0.1
	ci.draw_set_transform(Vector2(480, 130), tilt, Vector2.ONE)
	rr(-400, -10, 800, 20, SILVER, 8)
	# Left end: eyepiece and camera, with their weights engraved.
	rr(-390, 10, 110, 80, IRON_D, 6)
	txt(-335, 62, str(int(clues.get("camera_weight", 0))), 30, SILVER)
	if flag("eye_on"):
		rr(-260, 10, 80, 60, SILVER_D, 6)
		txt(-220, 52, str(int(clues.get("eyepiece_weight", 0))), 30, INK)
	# Right end: the hooks.
	var weights: Array = clues.get("weights", [])
	var hung: Array = st.get("weights", [0, 0, 0, 0, 0])
	for k in range(weights.size()):
		if flag("weights_on") and int(hung[k]) == 1:
			var wx := 60.0 + k * 70.0
			r(wx - 2, 10, 4, 22, SILVER_D)
			rr(wx - 26, 30, 52, 44.0 + float(weights[k]) * 2.0, IRON_D, 5)
			txt(wx, 62, str(int(weights[k])), 22, SILVER)
	home()
	poly([480, 140, 450, 250, 510, 250], SILVER_D)
	c(480, 132, 12, IRON_D)
	c(480, 220, 8, Color("69d06a") if st.get("balanced", false) else Color("3a2c22"))
	# The shelf of counterweights.
	rr(180, 400, 600, 14, O_WOOD, 3)
	for k in range(weights.size()):
		var x := 250.0 + k * 115.0
		if not flag("weights_on"):
			rr(x - 30, 300, 60, 100, Color(0, 0, 0, 0.25), 6)
		elif int(hung[k]) == 0:
			var h := 50.0 + float(weights[k]) * 3.0
			rr(x - 30, 400 - h, 60, h, IRON_D, 6)
			r(x - 6, 392 - h, 12, 10, SILVER_D)
			txt(x, 392, str(int(weights[k])), 24, SILVER)
		else:
			rr(x - 30, 392, 60, 6, Color(0, 0, 0, 0.3), 3)


func _plate() -> void:
	obs_board()
	rr(120, 30, 720, 412, IRON_D, 8)
	r(140, 50, 680, 372, Color("d9dce8"))
	for i in range(50):
		c(146 + fmod(i * 97.0, 668.0), 56 + fmod(i * 61.0, 360.0), 1.0 + (i % 3) * 0.6, Color(0.1, 0.1, 0.2, 0.5))
	# The comet (a negative: dark on light).
	c(480, 150, 16, Color("1a1d2e"))
	poly([470, 140, 300, 80, 320, 120, 472, 162], Color(0.1, 0.11, 0.18, 0.55))
	var photo: Array = clues.get("photo", [])
	for i in range(photo.size()):
		constel(photo[i], 230.0 + i * 166.0, 320, 2.0, Color("1a1d2e"))


func _door() -> void:
	obs_board()
	rr(140, 20, 680, 440, O_WOOD_D, 8)
	rr(160, 40, 640, 400, O_WOOD, 6)
	rr(270, 70, 420, 330, SILVER_D.darkened(0.25), 12)
	# The time lock: a clock that waits, and a small camera plate.
	dial(360, 122, 30, [11, 55], O_PAPER)
	rr(560, 100, 60, 44, IRON_D, 4)
	rr(568, 108, 44, 28, Color(0.75, 0.8, 0.95, 0.6) if flag("exposed") else Color("15141f"), 2)
	c(480, 122, 9, Color("69d06a") if flag("exposed") else Color("3a2c22"))
	_wheels(st.get("door", [0, 0, 0, 0]), 360, 262)
