## Draws Midnight in Serenissima on top of ArtIsland: twenty places of a city
## of canals on carnival night (SR0 … SR19), its map and its close-ups.
## Hotspot rectangles come from views_city.gd.
class_name ArtCity
extends ArtIsland

const SR_SKY_TOP := Color("0a1230")
const SR_SKY_LOW := Color("22305e")
const SR_WATER := Color("13294a")
const SR_STONE := Color("8a8478")
const SR_PAVE := Color("4a4540")
const SR_GOLD := Color("e8b84a")
const SR_GOLD_D := Color("a8781e")
const SR_LIT := Color("ffcf6a")
const SR_DARKWIN := Color("1a1c2e")
const SR_HOUSES := [Color("b0603a"), Color("c8944a"), Color("c87a6a"), Color("d0b890"), Color("8a3a2a"), Color("9a8c7a"), Color("b8805a")]
const SR_LANTERNS := [Color("e8403a"), Color("f0c040"), Color("4a8ae8"), Color("4ac87a"), Color("b060e8")]
const SR_CLOAKS := [Color("5a2a5a"), Color("2a3a6a"), Color("6a1a1a"), Color("1a1a1a"), Color("2a5a4a")]
const SR_SYMBOLS := ["book", "sword", "crown", "ball", "key", "fish"]


func draw_view(view: String) -> void:
	if CityViews.is_place(view):
		_sr_place(CityViews.place_index(view))
		home()
		return
	match view:
		"srmap": _srmap()
		"srstage": _srstage()
		"srcafe": _srcafe()
		"srmasks": _srmasks()
		"srglass": _srglass()
		"srtoss": _srtoss()
		"srfoyer": _srfoyer()
		"srcourt": _srcourt()
		"srcasket": _srcasket()
		"srtop": _srtop()
		"srsong": _srsong()
		"srlagoon": _srlagoon()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"srticket":
			at(x, y, -0.2, s)
			rr(-16, -9, 32, 18, Color("e8d8b0"), 2)
			r(4, -9, 2, 18, Color("8a3a2a"))
			c(-6, 0, 4, SR_GOLD_D)
		"srcoffee":
			at(x, y, 0.0, s)
			rr(-9, -6, 18, 16, Color("f2f2f2"), 3)
			ring(10, 1, 5, Color("f2f2f2"), 2)
			r(-8, -6, 16, 4, Color("4a2a1a"))
			for k in range(2):
				ln(-3 + k * 6, -10, -1 + k * 6, -16 + 2 * sin(t * 4.0 + k), Color(1, 1, 1, 0.5), 1.5)
		"srbellkey", "srcratekey":
			super.item("key", x, y, s)
			return
		"srbread":
			at(x, y, 0.0, s)
			rr(-16, -8, 32, 16, Color("c8904a"), 8)
			for k in range(3):
				ln(-8 + k * 8, -6, -4 + k * 8, 6, Color("8a5a2a"), 2)
		"srfeather":
			at(x, y, -0.6, s)
			poly([0, -18, 6, -6, 4, 10, 0, 16, -4, 10, -6, -6], Color("3aa060"))
			ln(0, -16, 0, 18, Color("1a5a30"), 1.5)
		"srslip":
			at(x, y, 0.1, s)
			r(-12, -14, 24, 28, PAPER)
			for k in range(4):
				ln(-8, -8 + k * 6, 8, -8 + k * 6, Color(INK, 0.5), 1)
		"srcoin":
			at(x, y, 0.0, s)
			c(0, 0, 11, Color("c8ccd0"))
			ring(0, 0, 8, Color("8a9098"), 2)
		"srtaper":
			at(x, y, -0.4, s)
			r(-2, -18, 4, 34, Color("f0e6c8"))
		"srflame":
			at(x, y, -0.4, s)
			r(-2, -12, 4, 30, Color("f0e6c8"))
			c(0, -16, 4 + sin(t * 9.0), FIRE)
			c(0, -17, 2, AMBER)
		"srlantern", "srlamp":
			at(x, y, 0.0, s)
			ln(0, -18, 0, -12, IRON, 2)
			poly([-9, -12, 9, -12, 7, 10, -7, 10], Color(1, 0.8, 0.4, 0.85) if name == "srlamp" else Color(0.7, 0.8, 0.85, 0.55))
			r(-10, 10, 20, 4, IRON)
			r(-8, -14, 16, 3, IRON)
		"sroar":
			at(x, y, -0.8, s)
			r(-2, -18, 4, 30, WOOD)
			poly([-5, 10, 5, 10, 4, 22, -4, 22], WOOD_D)
		"srmask":
			_sr_mask(x, y, 0.22 * s, 0, true, 1, true)
			return
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	if room != CityViews.ROOM:
		super.card(room, w, h)
		return
	for k in range(6):
		r(0, k * h * 0.1, w, h * 0.1 + 1, SR_SKY_TOP.lerp(SR_SKY_LOW, k / 5.0))
	# Fireworks.
	for k in range(3):
		var phase := fmod(t * 0.5 + k * 0.33, 1.0)
		_sr_burst(w * (0.2 + 0.22 * k), h * (0.2 + 0.05 * k), 16.0 * phase, SR_LANTERNS[(k * 2) % 5], 1.0 - phase, 0.9)
	# Houses and the canal.
	for k in range(5):
		r(k * w / 5.0, h * 0.4 + (k % 2) * 8, w / 5.0 + 1, h * 0.25, SR_HOUSES[k].darkened(0.35))
		r(k * w / 5.0 + 10, h * 0.5, 6, 9, SR_LIT)
	r(0, h * 0.65, w, h * 0.35, SR_WATER)
	for k in range(5):
		var wx := fmod(k * 41.0 + t * 10.0, w)
		ln(wx, h * 0.7 + k * 6, wx + 14, h * 0.7 + k * 6, Color(SR_GOLD, 0.5), 1.5)
	# A gondola gliding by.
	var gx := fmod(t * 18.0, w + 80.0) - 40.0
	poly([gx - 30, h * 0.76, gx + 30, h * 0.76, gx + 36, h * 0.72, gx + 26, h * 0.8, gx - 26, h * 0.8], Color("101010"))
	ln(gx + 16, h * 0.76, gx + 24, h * 0.56, WOOD, 2)
	# Lanterns on a line, swaying.
	ln(0, h * 0.08, w, h * 0.14, Color("3a2a1a"), 1.5)
	for k in range(5):
		var lx := w * (0.1 + 0.2 * k)
		var ly := h * (0.09 + 0.012 * k) + 2 * sin(t * 2.0 + k)
		c(lx, ly + 6, 5, SR_LANTERNS[k])
	_sr_mask(w * 0.78, h * 0.3 + 2 * sin(t * 2.0), 0.12, 0, true, 1, true)


# --- Shared --------------------------------------------------------------------

func _sr_lantern_of(i: int) -> Color:
	var list: Array = clues.get("lanterns", [])
	return SR_LANTERNS[int(list[i]) % 5] if i < list.size() else SR_GOLD


func _sr_sky(horizon: float = 372.0) -> void:
	for k in range(8):
		r(0, k * horizon / 8.0, 960, horizon / 8.0 + 1, SR_SKY_TOP.lerp(SR_SKY_LOW, k / 7.0))
	for k in range(26):
		var sx := float((k * 137) % 960)
		var sy := float((k * 71) % int(horizon * 0.6))
		c(sx, sy, 1.2 + 0.6 * sin(t * 2.0 + k), Color(1, 1, 0.9, 0.6))
	c(860, 90, 22, Color("f4ecd0"))
	c(870, 84, 20, SR_SKY_TOP.lerp(SR_SKY_LOW, 0.3))
	if st.get("done", false):
		for k in range(5):
			var phase := fmod(t * 0.4 + k * 0.2, 1.0)
			_sr_burst(120.0 + k * 180.0, 70.0 + (k % 2) * 50.0, 90.0 * phase, SR_LANTERNS[k], 1.0 - phase)


func _sr_burst(x: float, y: float, rad: float, col: Color, alpha: float, dot: float = 2.5) -> void:
	for k in range(12):
		var a := TAU * k / 12.0
		var p := Vector2(x + cos(a) * rad, y + sin(a) * rad + rad * rad * 0.004)
		c(p.x, p.y, dot, Color(col, alpha))
		ln(x + cos(a) * rad * 0.6, y + sin(a) * rad * 0.6, p.x, p.y, Color(col, alpha * 0.5), dot * 0.6)


func _sr_house(x: float, w: float, top: float, col: Color, seed: int, base: float = 372.0) -> void:
	r(x, top, w, base - top, col.darkened(0.3))
	r(x - 4, top - 8, w + 8, 10, col.darkened(0.5))
	# A Venetian chimney like a funnel.
	if seed % 2 == 0:
		r(x + w * 0.7, top - 34, 8, 26, col.darkened(0.45))
		poly([x + w * 0.7 - 8, top - 34, x + w * 0.7 + 16, top - 34, x + w * 0.7 + 10, top - 46, x + w * 0.7 - 2, top - 46], col.darkened(0.45))
	var cols := maxi(1, int(w / 56.0))
	var rows := maxi(1, int((base - top - 60) / 70.0))
	for j in range(rows):
		for i in range(cols):
			var wx := x + (w - cols * 56.0) / 2.0 + i * 56.0 + 14
			var wy := top + 24 + j * 70.0
			var lit := (seed * 7 + i * 3 + j * 5) % 3 != 0
			r(wx, wy + 10, 28, 34, SR_LIT if lit else SR_DARKWIN)
			c(wx + 14, wy + 10, 14, SR_LIT if lit else SR_DARKWIN)
			r(wx - 3, wy + 44, 34, 4, col.lightened(0.1))


func _sr_pave(top: float = 372.0) -> void:
	r(0, top, 960, 472 - top, SR_PAVE)
	for k in range(12):
		ln(k * 90.0 - 40, top, k * 110.0 - 140, 472, SR_PAVE.darkened(0.25), 1.5)
	for j in range(4):
		ln(0, top + 14 + j * j * 9.0, 960, top + 14 + j * j * 9.0, SR_PAVE.darkened(0.25), 1.5)


func _sr_water(top: float, bottom: float = 472.0) -> void:
	r(0, top, 960, bottom - top, SR_WATER)
	for k in range(14):
		var wx := fmod(k * 173.0 + t * 14.0, 1000.0) - 30.0
		var wy := top + 8 + (k * 13) % int(maxf(bottom - top - 10, 10))
		ln(wx, wy, wx + 36, wy, Color(SR_GOLD, 0.35), 2)


func _sr_festoon(y: float) -> void:
	var pts := PackedVector2Array()
	for k in range(17):
		pts.append(Vector2(k * 60.0, y + 18.0 * sin(PI * k / 16.0)))
	ci.draw_polyline(pts, Color("2a1e14"), 2.0, true)
	for k in range(1, 16):
		var p := pts[k]
		c(p.x, p.y + 8 + 1.5 * sin(t * 2.0 + k), 5, SR_LANTERNS[k % 5])


## The place's big lantern: its colour belongs to the place.
func _sr_lantern(i: int) -> void:
	var rect: Rect2 = CityViews.LANTERN
	var cx := rect.get_center().x
	var sway := 3.0 * sin(t * 1.5)
	ln(cx, 0, cx + sway, rect.position.y + 14, IRON, 2)
	var col := _sr_lantern_of(i)
	c(cx + sway, rect.position.y + 44, 30, Color(col, 0.18))
	poly([cx + sway - 16, rect.position.y + 18, cx + sway + 16, rect.position.y + 18, cx + sway + 22, rect.position.y + 50, cx + sway, rect.position.y + 74, cx + sway - 22, rect.position.y + 50], col)
	ln(cx + sway - 18, rect.position.y + 34, cx + sway + 18, rect.position.y + 34, Color(SR_GOLD_D, 0.8), 2)
	r(cx + sway - 8, rect.position.y + 12, 16, 7, SR_GOLD_D)


## A masked figure in a cloak.
func _sr_figure(x: float, y: float, s: float, cloak: int, hat: bool = true, mask_col: int = 0) -> void:
	var sway := 3.0 * sin(t * 1.3 + x * 0.01)
	at(x + sway, y, 0.0, s)
	poly([-26, 0, 26, 0, 16, -92, -16, -92], SR_CLOAKS[cloak % SR_CLOAKS.size()])
	c(0, -106, 16, Color("e8c8a8"))
	var mc: Color = [Color("f2ead8"), SR_GOLD, Color("c8ccd0")][mask_col % 3]
	poly([-16, -114, 16, -114, 14, -98, 6, -94, 0, -100, -6, -94, -14, -98], mc)
	c(-7, -108, 2.5, INK)
	c(7, -108, 2.5, INK)
	if hat:
		poly([-30, -118, 30, -118, 0, -140], Color("1a1a1a"))
	home()


func _sr_mask(x: float, y: float, s: float, colour: int, ears: bool, feather: int, sparkle: bool) -> void:
	at(x, y, 0.0, s)
	var col: Color = [SR_GOLD, Color("c8ccd8"), Color("2a2a32")][colour]
	if feather > 0:
		var fc: Color = Color("3aa060") if feather == 1 else Color("f2f2f2")
		for k in range(5):
			var a := -PI * 0.5 + (k - 2) * 0.3
			poly([0, -40, cos(a) * 60 - 8, -40 + sin(a) * 90, cos(a) * 64, -40 + sin(a) * 96, cos(a) * 60 + 8, -40 + sin(a) * 90], fc)
	if ears:
		poly([-70, -30, -56, -86, -30, -46], col)
		poly([70, -30, 56, -86, 30, -46], col)
	poly([-80, -40, 80, -40, 76, 10, 40, 40, 0, 26, -40, 40, -76, 10], col)
	poly([-50, -20, -20, -24, -14, -6, -48, -2], INK)
	poly([50, -20, 20, -24, 14, -6, 48, -2], INK)
	ln(-70, 10, -30, 34, col.darkened(0.3), 3)
	ln(70, 10, 30, 34, col.darkened(0.3), 3)
	if ears:
		for k in range(3):
			ln(-40, 14 + k * 6, -80, 8 + k * 10, col.lightened(0.4), 1.5)
			ln(40, 14 + k * 6, 80, 8 + k * 10, col.lightened(0.4), 1.5)
	if sparkle:
		c(30 + 10 * sin(t * 3.0), -30, 4, Color(1, 1, 0.8, 0.8))
	home()


func _sr_symbol(kind: int, x: float, y: float, s: float, col: Color) -> void:
	at(x, y, 0.0, s)
	match SR_SYMBOLS[kind % 6]:
		"book":
			poly([-18, -12, 0, -8, 0, 14, -18, 10], col)
			poly([18, -12, 0, -8, 0, 14, 18, 10], col.lightened(0.2))
		"sword":
			poly([-3, -22, 3, -22, 3, 10, -3, 10], col.lightened(0.3))
			r(-12, 8, 24, 4, col)
			r(-2, 12, 4, 10, col)
		"crown":
			poly([-18, 12, 18, 12, 18, -6, 9, 4, 0, -14, -9, 4, -18, -6], col)
		"ball":
			c(0, 0, 15, col)
			ring(0, 0, 15, col.darkened(0.3), 2)
		"key":
			ring(-10, 0, 7, col, 4)
			r(-3, -2, 24, 4, col)
			r(14, 2, 4, 8, col)
		"fish":
			poly([-18, 0, 0, -10, 14, 0, 0, 10], col)
			poly([14, 0, 22, -8, 22, 8], col)
	home()


func _sr_gondola(x: float, y: float, s: float) -> void:
	at(x, y, 0.0, s)
	poly([-150, -6, 140, -6, 150, 6, -140, 6], Color("0e0e10"))
	poly([140, -6, 160, -40, 172, -42, 150, 6], Color("0e0e10"))
	poly([-150, -6, -140, 6, -166, -14], Color("0e0e10"))
	r(-40, -16, 80, 12, Color("2a1a1a"))
	poly([156, -40, 174, -44, 172, -30], STEEL)
	home()


func _sr_name(i: int) -> void:
	var name := tr("srplace.%d" % i)
	var width := font.get_string_size(name, HORIZONTAL_ALIGNMENT_LEFT, -1, 18).x
	rr(12, 10, width + 24, 34, Color(0.05, 0.04, 0.03, 0.75), 8)
	txt(24, 34, name, 18, SR_GOLD, false)


func _sr_minimap(i: int) -> void:
	var m: Rect2 = CityViews.MINIMAP
	rr(m.position.x, m.position.y, m.size.x, m.size.y, Color(0.95, 0.89, 0.75, 0.92), 6)
	var sx := (m.size.x - 12) / 960.0
	var sy := (m.size.y - 10) / 472.0
	var o := m.position + Vector2(6, 5)
	r(o.x + 600 * sx, o.y + 340 * sy, 360 * sx, 132 * sy, Color("7fa8c2"))
	for k in range(CityViews.PLACES):
		var p: Vector2 = CityViews.MAP_AT[k]
		if CityViews.seen(st, k):
			c(o.x + p.x * sx, o.y + p.y * sy, 2.2, Color("2a3a5a"))
	var me: Vector2 = CityViews.MAP_AT[i]
	c(o.x + me.x * sx, o.y + me.y * sy, 4, Color("c83a3a"))
	ring(o.x + me.x * sx, o.y + me.y * sy, 6 + sin(t * 4.0), Color("c83a3a"), 1.5)


## The ways out, with the names of the places already seen.
func _sr_exits(i: int) -> void:
	var exits: Dictionary = CityViews.EXITS[i]
	for d in ["l", "r", "f", "b"]:
		if not exits.has(d):
			continue
		var rect: Rect2 = CityViews.ARROW[d]
		arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, CityViews.ARROW_DIR[d])
		var to := int(exits[d])
		var label := tr("srplace.%d" % to) if CityViews.seen(st, to) else "?"
		var size := 13
		var width := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		var lx := rect.get_center().x
		var ly := rect.end.y + 16
		if d == "l":
			lx = maxf(rect.position.x + width / 2.0 + 2, lx)
		elif d == "r":
			lx = minf(958.0 - width / 2.0 - 2, lx)
		else:
			lx = rect.end.x + width / 2.0 + 10
			ly = rect.get_center().y + 5
		rr(lx - width / 2.0 - 5, ly - 14, width + 10, 19, Color(0, 0, 0, 0.55), 5)
		txt(lx, ly, label, size, CREAM)


# --- The places ----------------------------------------------------------------

func _sr_place(i: int) -> void:
	match i:
		0: _sr_piazza()
		1: _sr_clocktower()
		2: _sr_belltower()
		3: _sr_molo()
		4: _sr_cafe()
		5: _sr_maskshop()
		6: _sr_bridge()
		7: _sr_market()
		8: _sr_glassworks()
		9: _sr_bookshop()
		10: _sr_arsenale()
		11: _sr_campo()
		12: _sr_laundry()
		13: _sr_church()
		14: _sr_theatre()
		15: _sr_squero()
		16: _sr_palazzo()
		17: _sr_passage()
		18: _sr_quay()
		19: _sr_barge()
	_sr_lantern(i)
	_sr_name(i)
	_sr_minimap(i)
	_sr_exits(i)


func _sr_spot(view: String, id: String) -> Rect2:
	for spot in CityViews.SPOTS[view]:
		if spot[0] == id:
			return spot[1]
	return Rect2()


func _sr_piazza() -> void:
	_sr_sky()
	# Arcades on both sides.
	for side in [0, 1]:
		var x0 := 0.0 if side == 0 else 700.0
		r(x0, 120, 260, 252, Color("b8a890").darkened(0.4))
		for k in range(5):
			var ax := x0 + 10 + k * 50.0
			r(ax, 260, 34, 112, Color("1a1612"))
			c(ax + 17, 260, 17, Color("1a1612"))
			r(ax + 6, 150, 22, 40, SR_LIT if (k + side) % 2 == 0 else SR_DARKWIN)
	# The basilica: domes and a golden front.
	var b := _sr_spot("SR0", "basilica")
	r(b.position.x, b.position.y + 50, b.size.x, 190, Color("c8a878").darkened(0.35))
	for k in range(5):
		var dx := b.position.x + 30 + k * 60.0
		c(dx, b.position.y + 50, 26 if k % 2 == 0 else 20, Color("6a7a7a"))
		r(dx - 2, b.position.y + 14 - (k % 2) * 4, 4, 14, SR_GOLD)
		r(dx - 22, b.position.y + 110, 44, 120, Color("2a1e18"))
		c(dx, b.position.y + 110, 22, SR_GOLD_D)
	_sr_pave(300)
	# The stage: the cushion empty (or the card on it).
	var s := _sr_spot("SR0", "stage")
	r(s.position.x, s.position.y + 90, s.size.x, 50, WOOD)
	poly([s.position.x - 10, s.position.y, s.end.x + 10, s.position.y, s.end.x, s.position.y + 20, s.position.x, s.position.y + 20], Color("8a1a2a"))
	r(s.get_center().x - 4, s.position.y + 40, 8, 50, SR_GOLD_D)
	rr(s.get_center().x - 40, s.position.y + 30, 80, 20, Color("a8202a"), 8)
	if not flag("got_card"):
		r(s.get_center().x - 12, s.position.y + 22, 24, 10, Color("f0e6d0"))
	# Pigeons, and their keeper.
	var p := _sr_spot("SR0", "pigeons")
	if flag("got_feather"):
		for k in range(7):
			var px := p.position.x + k * 30.0 + 20 * sin(t + k)
			var py := 80.0 + 30 * sin(t * 1.3 + k * 2.0)
			poly([px - 10, py, px, py - 6 * sin(t * 12.0 + k), px + 10, py, px, py + 3], Color("8a8a9a"))
	else:
		for k in range(8):
			var px := p.position.x + 14 + k * 23.0
			var py := p.position.y + 34 + (k % 3) * 6 + 2 * sin(t * 3.0 + k)
			c(px, py, 8, Color("8a8a9a"))
			c(px + 7, py - 6, 4, Color("6a6a7a"))
	var lady := _sr_spot("SR0", "pigeonlady")
	poly([lady.position.x + 10, lady.end.y, lady.end.x - 10, lady.end.y, lady.end.x - 24, lady.position.y + 40, lady.position.x + 24, lady.position.y + 40], Color("4a3a4a"))
	c(lady.get_center().x, lady.position.y + 26, 16, Color("d8b8a0"))
	poly([lady.get_center().x - 20, lady.position.y + 20, lady.get_center().x + 20, lady.position.y + 20, lady.get_center().x, lady.position.y], Color("3a2a3a"))
	# The column with its winged lion holding a book.
	var col := _sr_spot("SR0", "lioncolumn")
	r(col.position.x + 18, col.position.y + 60, 24, col.size.y - 60, Color("c8c0b0").darkened(0.3))
	r(col.position.x + 8, col.position.y + 50, 44, 12, Color("c8c0b0").darkened(0.2))
	poly([col.position.x, col.position.y + 50, col.end.x, col.position.y + 50, col.end.x - 6, col.position.y + 20, col.position.x + 10, col.position.y + 14], SR_GOLD_D)
	poly([col.position.x + 30, col.position.y + 20, col.position.x + 70, col.position.y - 6, col.position.x + 44, col.position.y + 28], SR_GOLD_D)
	_sr_symbol(0, col.position.x + 12, col.position.y + 36, 0.5, PAPER)
	# Revellers.
	var crowd := _sr_spot("SR0", "crowd")
	for k in range(3):
		_sr_figure(crowd.position.x + 20 + k * 40.0, crowd.end.y, 0.7, k + 1, k != 1, k)
	_sr_festoon(60)


func _sr_clocktower() -> void:
	_sr_sky()
	_sr_house(0, 260, 120, SR_HOUSES[2], 3)
	_sr_house(700, 260, 90, SR_HOUSES[3], 4)
	# The tower: the bell with its two bronze moors, the blue and gold face.
	r(390, 100, 180, 272, Color("d8c8a8").darkened(0.35))
	var m := _sr_spot("SR1", "moors")
	r(m.position.x, m.position.y + 34, m.size.x, 8, SR_STONE)
	ci.draw_arc(Vector2(480, m.position.y + 26), 18, PI, TAU, 12, Color("5a4a2a"), 14, true)
	var swing := 0.0 if fmod(t, 6.0) > 1.0 else sin(fmod(t, 6.0) * PI) * 0.6
	for k in [-1, 1]:
		var fx: float = 480 + k * 50
		r(fx - 8, m.position.y + 6, 16, 30, Color("3a2a1a"))
		c(fx, m.position.y + 2, 8, Color("3a2a1a"))
		ln(fx, m.position.y + 14, fx - k * 24 * cos(swing), m.position.y + 6 - 18 * sin(swing), Color("3a2a1a"), 4)
	var f := _sr_spot("SR1", "clockface")
	var cc := f.get_center()
	c(cc.x, cc.y, 76, SR_GOLD_D)
	c(cc.x, cc.y, 68, Color("1e3a8a"))
	for k in range(12):
		var a := TAU * k / 12.0
		c(cc.x + cos(a) * 56, cc.y + sin(a) * 56, 4, SR_GOLD)
	# The time: a quarter past eleven when you came, midnight at the end.
	var mins := 0 if st.get("done", false) else mini(59, 15 + int(st.get("secs", 0)) / 40)
	var hour := 0 if st.get("done", false) else 11
	var ma := TAU * mins / 60.0 - PI / 2
	var ha := TAU * (hour + mins / 60.0) / 12.0 - PI / 2
	ln(cc.x, cc.y, cc.x + cos(ha) * 34, cc.y + sin(ha) * 34, SR_GOLD, 5)
	ln(cc.x, cc.y, cc.x + cos(ma) * 52, cc.y + sin(ma) * 52, SR_GOLD, 3)
	c(cc.x, cc.y, 6, SR_GOLD)
	# The archway under the tower and its plaque.
	r(430, 286, 100, 86, Color("15100c"))
	c(480, 286, 50, Color("15100c"))
	var p := _sr_spot("SR1", "plaque")
	rr(p.position.x + 20, p.position.y - 50, p.size.x - 40, 26, SR_STONE.darkened(0.2), 3)
	_sr_pave()
	var crowd := _sr_spot("SR1", "crowd")
	for k in range(3):
		_sr_figure(crowd.position.x + 30 + k * 55.0, crowd.end.y, 0.75, k + 2, k != 0, k + 1)
	_sr_festoon(50)


func _sr_belltower() -> void:
	_sr_sky()
	_sr_house(0, 330, 140, SR_HOUSES[0], 2)
	_sr_house(620, 340, 160, SR_HOUSES[4], 5)
	# The campanile: red brick to the sky, a green spire.
	r(420, 60, 120, 312, Color("9a4a32").darkened(0.3))
	for k in range(14):
		ln(420, 70 + k * 22, 540, 70 + k * 22, Color("6a2a1a", 0.5), 1)
	r(410, 0, 140, 60, Color("d8c8a8").darkened(0.4))
	for k in range(3):
		r(424 + k * 42, 8, 26, 44, Color("1a1612"))
	var d := _sr_spot("SR2", "towerdoor")
	r(d.position.x, d.position.y + 20, d.size.x, d.size.y - 20, Color("15100c") if flag("tower_open") else WOOD_D)
	c(d.get_center().x, d.position.y + 20, d.size.x / 2.0, Color("15100c") if flag("tower_open") else WOOD_D)
	if not flag("tower_open"):
		c(d.end.x - 18, d.get_center().y + 10, 5, BRASS)
		r(d.end.x - 22, d.get_center().y + 16, 8, 14, IRON)
	_sr_pave()
	var mu := _sr_spot("SR2", "musicians")
	for k in range(3):
		_sr_figure(mu.position.x + 30 + k * 50.0, mu.end.y, 0.7, k, false, (k + 2) % 3)
	ln(mu.position.x + 40, mu.position.y + 40, mu.position.x + 70, mu.position.y + 20, WOOD, 3)
	for k in range(3):
		var nx := mu.position.x + 60 + k * 30 + 8 * sin(t + k)
		var ny := mu.position.y - 10 - fmod(t * 20.0 + k * 20.0, 60.0)
		c(nx, ny, 4, Color(SR_GOLD, 0.8))
		ln(nx + 4, ny, nx + 4, ny - 12, Color(SR_GOLD, 0.8), 1.5)


func _sr_molo() -> void:
	_sr_sky(210)
	# The lagoon, the island church, the fireworks barge far out.
	_sr_water(210, 300)
	var l := _sr_spot("SR3", "lagoon")
	r(l.position.x + 20, 186, 90, 24, Color("3a3a4a"))
	poly([l.position.x + 40, 186, l.position.x + 60, 150, l.position.x + 80, 186], Color("3a3a4a"))
	poly([l.position.x + 220, 210, l.position.x + 330, 210, l.position.x + 320, 222, l.position.x + 230, 222], Color("2a2a2a"))
	for k in range(5):
		ln(l.position.x + 240 + k * 18, 210, l.position.x + 240 + k * 18, 196, SR_LANTERNS[k], 3)
	# The quay and its striped poles.
	_sr_pave(300)
	r(0, 300, 960, 8, SR_STONE)
	_sr_water(372)
	for k in range(4):
		var px := 570.0 + k * 100
		r(px, 330, 10, 110, Color("f2f2f2"))
		for j in range(4):
			r(px, 334 + j * 26, 10, 12, Color("2a4aa8"))
		c(px + 5, 330, 7, SR_GOLD_D)
	# The gondolier, his gondola, and his song.
	var g := _sr_spot("SR3", "gondolier")
	poly([g.position.x + 20, g.end.y, g.end.x - 20, g.end.y, g.end.x - 26, g.position.y + 50, g.position.x + 26, g.position.y + 50], Color("f2f2f2"))
	for k in range(4):
		r(g.position.x + 26, g.position.y + 60 + k * 20, g.size.x - 52, 8, Color("1a1a1a"))
	c(g.get_center().x, g.position.y + 34, 16, Color("e0b890"))
	r(g.get_center().x - 26, g.position.y + 14, 52, 6, Color("e8d090"))
	r(g.get_center().x - 14, g.position.y + 2, 28, 14, Color("e8d090"))
	r(g.get_center().x - 14, g.position.y + 12, 28, 4, Color("c83a3a"))
	var gd := _sr_spot("SR3", "gondola")
	_sr_gondola(gd.get_center().x, gd.get_center().y + 6 + 2 * sin(t * 1.5), 0.95)
	if flag("oar_in"):
		ln(gd.position.x + 260, gd.position.y - 30, gd.position.x + 300, gd.position.y + 40, WOOD, 5)
	if flag("lamp_on"):
		c(gd.position.x + 60, gd.position.y - 4, 14, Color(1, 0.8, 0.4, 0.4))
		item("srlamp", gd.position.x + 60, gd.position.y, 1.1)
	var so := _sr_spot("SR3", "song")
	for k in range(2):
		var nx := so.position.x + 20 + k * 26
		var ny := so.position.y + 40 - 8 * sin(t * 2.0 + k)
		c(nx, ny, 6, Color(SR_GOLD, 0.9 if flag("paid") else 0.45))
		ln(nx + 6, ny, nx + 6, ny - 22, Color(SR_GOLD, 0.9 if flag("paid") else 0.45), 2)


func _sr_cafe() -> void:
	_sr_sky()
	_sr_house(0, 960, 100, SR_HOUSES[1], 6)
	# The café: awning, bar and window.
	for k in range(12):
		poly([80 + k * 40.0, 200, 120 + k * 40.0, 200, 116 + k * 40.0, 236, 84 + k * 40.0, 236], Color("c83a3a") if k % 2 == 0 else Color("f2e6d0"))
	r(600, 236, 300, 136, Color("2a1a12"))
	r(610, 246, 280, 70, Color(SR_LIT, 0.5))
	var cup := _sr_spot("SR4", "cup")
	r(cup.position.x - 30, cup.end.y, 130, 10, WOOD)
	if not flag("got_coffee"):
		item("srcoffee", cup.get_center().x, cup.get_center().y + 6, 1.4)
		rr(cup.position.x - 6, cup.position.y - 24, 84, 20, PAPER, 3)
	_sr_pave()
	var tb := _sr_spot("SR4", "tables")
	for k in range(3):
		var tx := tb.position.x + 60 + k * 130.0
		ci.draw_set_transform(Vector2(tx, tb.position.y + 50), 0.0, Vector2(1, 0.35))
		c(0, 0, 50, Color("e8e0d0"))
		home()
		r(tx - 3, tb.position.y + 54, 6, 70, IRON)
		c(tx, tb.position.y + 44, 4, FIRE if fmod(t + k, 0.5) < 0.25 else AMBER)
		for j in [-1, 1]:
			r(tx + j * 56 - 10, tb.position.y + 60, 20, 6, IRON)
			r(tx + j * 56 - 8, tb.position.y + 66, 4, 54, IRON)
			r(tx + j * 56 + 4, tb.position.y + 66, 4, 54, IRON)
	var mu := _sr_spot("SR4", "musicians")
	r(mu.position.x, mu.position.y, mu.size.x, mu.size.y, Color(SR_LIT, 0.6))
	_sr_figure(mu.get_center().x, mu.end.y, 0.55, 4, false, 1)
	ln(mu.get_center().x - 10, mu.end.y - 40, mu.get_center().x + 20, mu.end.y - 60, WOOD, 3)
	r(mu.position.x - 6, mu.end.y - 4, mu.size.x + 12, 8, IRON)
	var w := _sr_spot("SR4", "waiter")
	poly([w.position.x + 20, w.end.y, w.end.x - 20, w.end.y, w.end.x - 24, w.position.y + 50, w.position.x + 24, w.position.y + 50], Color("1a1a1a"))
	r(w.position.x + 30, w.position.y + 54, w.size.x - 60, 90, Color("f2f2f2"))
	c(w.get_center().x, w.position.y + 34, 16, Color("e0b890"))
	ln(w.end.x - 20, w.position.y + 70, w.end.x + 10, w.position.y + 60, Color("f2f2f2"), 5)
	ci.draw_set_transform(Vector2(w.end.x + 14, w.position.y + 58), 0.0, Vector2(1, 0.3))
	c(0, 0, 22, STEEL)
	home()
	_sr_festoon(40)


func _sr_maskshop() -> void:
	_sr_sky()
	_sr_house(0, 960, 30, SR_HOUSES[4], 1)
	var wl := _sr_spot("SR5", "wall")
	r(wl.position.x - 10, wl.position.y - 10, wl.size.x + 20, wl.size.y + 20, SR_GOLD_D)
	r(wl.position.x, wl.position.y, wl.size.x, wl.size.y, Color("3a1a1a"))
	r(wl.position.x, wl.position.y, wl.size.x, wl.size.y, Color(SR_LIT, 0.25))
	for k in range(12):
		var mx := wl.position.x + 50 + (k % 6) * 84.0
		var my := wl.position.y + 70 + int(k / 6) * 140.0
		_sr_mask(mx, my, 0.3, k % 3, k % 2 == 0, (k + 1) % 3, false)
	_sr_pave()
	var m := _sr_spot("SR5", "maker")
	poly([m.position.x + 16, m.end.y, m.end.x - 16, m.end.y, m.end.x - 26, m.position.y + 50, m.position.x + 26, m.position.y + 50], Color("6a4a2a"))
	r(m.position.x + 32, m.position.y + 60, m.size.x - 64, 110, Color("d8c8a8"))
	c(m.get_center().x, m.position.y + 34, 17, Color("e0b890"))
	ring(m.get_center().x, m.position.y + 32, 18, Color("8a8a8a"), 3)
	ln(m.end.x - 20, m.position.y + 80, m.end.x + 10, m.position.y + 70, WOOD, 3)
	c(m.end.x + 12, m.position.y + 69, 3, SR_GOLD)


func _sr_bridge() -> void:
	_sr_sky()
	_sr_house(0, 300, 80, SR_HOUSES[5], 0)
	_sr_house(640, 320, 100, SR_HOUSES[2], 7)
	_sr_water(300)
	# The great bridge with its shops, arched over the canal.
	# The stone bridge: a deck stepping up to the middle, one wide arch.
	var stone := Color("e0d4b8").darkened(0.35)
	var pts := [80.0, 300.0, 200.0, 200.0, 760.0, 200.0, 880.0, 300.0, 720.0, 300.0]
	for k in range(1, 16):
		var a := PI * k / 16.0
		pts.append_array([480.0 + cos(a) * 240.0, 300.0 - sin(a) * 70.0])
	pts.append_array([240.0, 300.0])
	poly(pts, stone)
	for k in range(9):
		ln(200 + k * 70.0, 200, 200 + k * 70.0, 214, stone.darkened(0.3), 3)
	ln(200, 214, 760, 214, stone.darkened(0.3), 3)
	var sh := _sr_spot("SR6", "shops")
	for k in range(4):
		var sx := sh.position.x + 20 + k * 62.0
		r(sx, sh.position.y + 40, 50, 80, Color("2a1a12"))
		r(sx + 4, sh.position.y + 44, 42, 40, Color(SR_LIT, 0.7) if k % 2 == 0 else Color(SR_LIT, 0.35))
		poly([sx - 4, sh.position.y + 40, sx + 54, sh.position.y + 40, sx + 25, sh.position.y + 14], Color("6a2a1a"))
	var bb := _sr_spot("SR6", "bridgeboats")
	_sr_gondola(bb.get_center().x + 40 * sin(t * 0.3), bb.get_center().y, 0.7)
	var crowd := _sr_spot("SR6", "crowd")
	for k in range(3):
		_sr_figure(crowd.position.x + 30 + k * 60.0, crowd.end.y, 0.65, k + 3, k != 2, k)


func _sr_market() -> void:
	_sr_sky()
	_sr_house(0, 960, 140, SR_HOUSES[0], 9)
	_sr_pave(320)
	for key in ["fish", "fruit", "baker"]:
		var s := _sr_spot("SR7", key)
		var awning: Color = {"fish": Color("2a6a8a"), "fruit": Color("2a8a4a"), "baker": Color("c88a2a")}[key]
		for k in range(4):
			poly([s.position.x + k * s.size.x / 4.0, s.position.y, s.position.x + (k + 1) * s.size.x / 4.0, s.position.y, s.position.x + (k + 1) * s.size.x / 4.0 - 4, s.position.y + 30, s.position.x + k * s.size.x / 4.0 + 4, s.position.y + 30], awning if k % 2 == 0 else Color("f2e6d0"))
		r(s.position.x + 6, s.position.y + 30, 6, s.size.y - 30, WOOD_D)
		r(s.end.x - 12, s.position.y + 30, 6, s.size.y - 30, WOOD_D)
		r(s.position.x, s.end.y - 60, s.size.x, 16, WOOD)
	var f := _sr_spot("SR7", "fish")
	for k in range(5):
		_sr_symbol(5, f.position.x + 30 + k * 34.0, f.end.y - 70, 0.9, Color("9ab0c0"))
	var fr := _sr_spot("SR7", "fruit")
	for k in range(8):
		c(fr.position.x + 24 + k * 18.0, fr.end.y - 68 - (k % 2) * 8, 9, [Color("e84a2a"), Color("f0a020"), Color("8ac83a")][k % 3])
	var b := _sr_spot("SR7", "baker")
	if not flag("got_bread"):
		for k in range(4):
			item("srbread", b.position.x + 40 + k * 34.0, b.end.y - 70, 0.9)
	else:
		for k in range(3):
			item("srbread", b.position.x + 40 + k * 34.0, b.end.y - 70, 0.9)
	c(b.get_center().x, b.position.y + 70, 16, Color("e0b890"))
	r(b.get_center().x - 14, b.position.y + 46, 28, 10, Color("f2f2f2"))
	r(b.get_center().x - 22, b.position.y + 86, 44, 40, Color("f2f2f2"))


func _sr_glassworks() -> void:
	_sr_sky()
	_sr_house(0, 960, 40, SR_HOUSES[5], 11)
	r(300, 100, 380, 272, Color("1a1210"))
	var fu := _sr_spot("SR8", "furnace")
	ci.draw_arc(Vector2(fu.get_center().x, fu.end.y), 140, PI, TAU, 20, Color("7a3a2a"), 40, true)
	c(fu.get_center().x, fu.end.y - 60, 40, Color(1, 0.5 + 0.1 * sin(t * 6.0), 0.1, 0.9))
	c(fu.get_center().x, fu.end.y - 60, 24, Color(1, 0.85, 0.4))
	var sg := _sr_spot("SR8", "sign")
	ln(sg.position.x, sg.position.y - 10, sg.end.x, sg.position.y - 10, IRON, 3)
	rr(sg.position.x + 10, sg.position.y, sg.size.x - 20, sg.size.y, WOOD_D, 6)
	poly([sg.get_center().x - 12, sg.end.y - 14, sg.get_center().x + 12, sg.end.y - 14, sg.get_center().x + 22, sg.position.y + 40, sg.get_center().x + 6, sg.position.y + 16, sg.get_center().x - 6, sg.position.y + 16, sg.get_center().x - 22, sg.position.y + 40], Color(0.5, 0.8, 0.9, 0.8))
	_sr_pave()
	var g := _sr_spot("SR8", "glassblower")
	poly([g.position.x + 16, g.end.y, g.end.x - 16, g.end.y, g.end.x - 24, g.position.y + 50, g.position.x + 24, g.position.y + 50], Color("5a4a3a"))
	c(g.get_center().x, g.position.y + 34, 16, Color("e0b890"))
	ln(g.position.x + 10, g.position.y + 70, g.position.x - 80, g.position.y + 90, IRON, 4)
	c(g.position.x - 82, g.position.y + 90, 10, Color(1, 0.6, 0.2, 0.9))


func _sr_bookshop() -> void:
	_sr_sky()
	_sr_house(0, 960, 60, SR_HOUSES[3], 13)
	r(80, 80, 560, 292, Color("2a1a12"))
	r(80, 80, 560, 292, Color(SR_LIT, 0.2))
	var bk := _sr_spot("SR9", "books")
	# Books piled in a gondola and a bathtub, against the high water.
	_sr_gondola(bk.get_center().x, bk.end.y - 10, 1.0)
	for k in range(30):
		var bx := bk.position.x + 30 + (k % 10) * 32.0
		var by := bk.end.y - 30 - int(k / 10) * 26.0
		r(bx, by, 26, 22, [Color("8a2a2a"), Color("2a4a8a"), Color("2a6a3a"), Color("c8a04a")][k % 4])
	for k in range(4):
		r(bk.position.x, bk.position.y + k * 40.0, bk.size.x, 6, WOOD)
	var cat := _sr_spot("SR9", "bookcat")
	ci.draw_set_transform(Vector2(cat.get_center().x, cat.get_center().y + 10), 0.0, Vector2(1.4, 0.8))
	c(0, 0, 22, Color("2a2a2a"))
	home()
	c(cat.position.x + 20, cat.position.y + 30, 12, Color("2a2a2a"))
	poly([cat.position.x + 12, cat.position.y + 22, cat.position.x + 14, cat.position.y + 8, cat.position.x + 20, cat.position.y + 20], Color("2a2a2a"))
	poly([cat.position.x + 22, cat.position.y + 20, cat.position.x + 28, cat.position.y + 8, cat.position.x + 30, cat.position.y + 22], Color("2a2a2a"))
	c(cat.position.x + 16, cat.position.y + 30, 2, SR_GOLD if fmod(t, 4.0) > 0.2 else Color("2a2a2a"))
	_sr_pave()
	var s := _sr_spot("SR9", "bookseller")
	poly([s.position.x + 16, s.end.y, s.end.x - 16, s.end.y, s.end.x - 24, s.position.y + 50, s.position.x + 24, s.position.y + 50], Color("3a4a3a"))
	c(s.get_center().x, s.position.y + 34, 16, Color("e0b890"))
	ring(s.get_center().x - 6, s.position.y + 32, 5, IRON, 1.5)
	ring(s.get_center().x + 6, s.position.y + 32, 5, IRON, 1.5)


func _sr_arsenale() -> void:
	_sr_sky()
	# The old shipyard's gate between two towers.
	r(220, 40, 120, 332, Color("9a4a32").darkened(0.35))
	r(620, 40, 120, 332, Color("9a4a32").darkened(0.35))
	for x in [220, 620]:
		for k in range(5):
			r(x + k * 26, 28, 16, 14, Color("9a4a32").darkened(0.35))
	var g := _sr_spot("SR10", "gate")
	r(g.position.x - 20, g.position.y, g.size.x + 40, g.size.y + 102, Color("d8c8a8").darkened(0.35))
	r(g.position.x + 30, g.position.y + 80, g.size.x - 60, g.size.y + 22, Color("15100c"))
	c(g.get_center().x, g.position.y + 80, g.size.x / 2.0 - 30, Color("15100c"))
	poly([g.position.x - 30, g.position.y, g.end.x + 30, g.position.y, g.get_center().x, g.position.y - 50], Color("d8c8a8").darkened(0.4))
	_sr_symbol(0, g.get_center().x, g.position.y - 18, 0.6, SR_GOLD_D)
	_sr_pave()
	# Four stone lions, each with a paw on something.
	var casket: Array = clues.get("casket", [0, 0, 0, 0])
	for k in range(4):
		var lx: float = [170.0, 320.0, 650.0, 800.0][k]
		var ly := 360.0
		r(lx - 50, ly - 20, 100, 30, SR_STONE.darkened(0.2))
		ci.draw_set_transform(Vector2(lx, ly - 50), 0.0, Vector2(1.3, 0.7))
		c(0, 0, 40, Color("c8c0b0").darkened(0.25))
		home()
		c(lx - 34, ly - 74, 22, Color("c8c0b0").darkened(0.25))
		ring(lx - 34, ly - 74, 24, Color("a89070").darkened(0.3), 6)
		c(lx - 40, ly - 78, 3, INK)
		r(lx - 50, ly - 40, 14, 22, Color("c8c0b0").darkened(0.25))
		c(lx - 40, ly - 34, 24, Color("c8c0b0").darkened(0.45))
		_sr_symbol(int(casket[k]), lx - 40, ly - 34, 0.95, Color("f0e8d8"))
		ln(lx + 50, ly - 50, lx + 64, ly - 80, Color("c8c0b0").darkened(0.25), 6)


func _sr_campo() -> void:
	_sr_sky()
	_sr_house(0, 360, 110, SR_HOUSES[6], 15)
	_sr_house(360, 260, 150, SR_HOUSES[3], 16)
	_sr_house(620, 340, 90, SR_HOUSES[1], 17)
	_sr_pave(330)
	var w := _sr_spot("SR11", "well")
	r(w.position.x + 30, w.position.y + 40, w.size.x - 60, w.size.y - 40, Color("c8c0b0").darkened(0.3))
	r(w.position.x + 20, w.position.y + 30, w.size.x - 40, 14, Color("c8c0b0").darkened(0.2))
	for k in range(3):
		r(w.position.x + 50 + k * 40, w.position.y + 60, 20, 50, Color("c8c0b0").darkened(0.45))
	var ts := _sr_spot("SR11", "toss")
	for k in range(6):
		poly([ts.position.x + k * 40.0, ts.position.y + 40, ts.position.x + (k + 1) * 40.0, ts.position.y + 40, ts.get_center().x, ts.position.y], Color("c83a3a") if k % 2 == 0 else Color("f2e6d0"))
	r(ts.position.x, ts.position.y + 40, ts.size.x, ts.size.y - 40, Color("2a1a12"))
	r(ts.position.x + 10, ts.position.y + 50, ts.size.x - 20, 120, Color(SR_LIT, 0.4))
	for k in range(5):
		var bx := ts.position.x + 40 + k * 40.0
		r(bx - 6, ts.position.y + 120, 12, 36, Color("2a6a3a"))
		r(bx - 3, ts.position.y + 106, 6, 14, SR_GOLD if k == 2 else Color("2a6a3a"))
	r(ts.position.x, ts.position.y + 170, ts.size.x, 20, Color("c83a3a"))
	var ch := _sr_spot("SR11", "children")
	for k in range(3):
		var bounce := absf(sin(t * 3.0 + k)) * 12.0
		_sr_figure(ch.position.x + 30 + k * 60.0, ch.end.y - bounce, 0.5, k + 1, false, k)


func _sr_laundry() -> void:
	_sr_sky()
	_sr_house(0, 420, 20, SR_HOUSES[2], 19)
	_sr_house(540, 420, 30, SR_HOUSES[6], 20)
	r(420, 0, 120, 372, SR_SKY_LOW.darkened(0.2))
	var l := _sr_spot("SR12", "laundry")
	for row in range(2):
		var y0 := l.position.y + 10 + row * 60.0
		ln(l.position.x, y0, l.end.x, y0 + 10, Color("2a1e14"), 1.5)
		for k in range(8):
			var cx := l.position.x + 30 + k * 86.0
			var sway := 4.0 * sin(t * 2.0 + k + row)
			poly([cx, y0 + k * 1.2, cx + 50, y0 + k * 1.2, cx + 50 + sway, y0 + 40, cx + sway, y0 + 40], [Color("f2f2f2"), Color("c83a3a"), Color("4a8ae8"), Color("f0c040")][(k + row) % 4])
	var s := _sr_spot("SR12", "singer")
	r(s.position.x, s.position.y, s.size.x, s.size.y, Color(SR_LIT, 0.8))
	c(s.get_center().x, s.get_center().y, 18, Color("e0b890"))
	poly([s.get_center().x - 20, s.end.y, s.get_center().x + 20, s.end.y, s.get_center().x, s.get_center().y + 10], Color("8a2a5a"))
	if fmod(t, 3.0) < 2.0:
		c(s.end.x + 16, s.position.y + 10 - fmod(t, 3.0) * 10, 4, Color(SR_GOLD, 0.8))
	_sr_pave()


func _sr_church() -> void:
	_sr_sky()
	_sr_house(0, 300, 120, SR_HOUSES[5], 21)
	_sr_house(700, 260, 140, SR_HOUSES[0], 22)
	# The church front, white stone, and its steps.
	poly([300, 372, 700, 372, 700, 120, 500, 40, 300, 120], Color("e8e0d0").darkened(0.4))
	c(500, 120, 30, Color("1a1612"))
	var p := _sr_spot("SR13", "portal")
	r(p.position.x + 40, p.position.y + 100, p.size.x - 80, p.size.y - 100, WOOD_D)
	c(p.get_center().x, p.position.y + 100, p.size.x / 2.0 - 40, WOOD_D)
	for k in range(4):
		r(300 - k * 14, 330 + k * 12, 400 + k * 28, 12, Color("e8e0d0").darkened(0.45 + k * 0.03))
	_sr_pave(372)
	var rg := _sr_spot("SR13", "ringer")
	poly([rg.position.x, rg.end.y, rg.end.x, rg.end.y, rg.end.x - 20, rg.position.y + 40, rg.position.x + 30, rg.position.y + 50], Color("4a3a2a"))
	c(rg.position.x + 40, rg.position.y + 40, 16, Color("e0b890"))
	if not flag("got_bellkey"):
		for k in range(3):
			var zx := rg.position.x + 60 + k * 14
			var zy := rg.position.y + 20 - k * 14 - fmod(t * 10.0, 14.0)
			txt(zx, zy, "z", 14 + k * 3, Color(CREAM, 0.7))
	var tp := _sr_spot("SR13", "tapers")
	r(tp.position.x, tp.position.y + 30, tp.size.x, tp.size.y - 30, WOOD)
	for k in range(5 if not flag("got_taper") else 4):
		r(tp.position.x + 10 + k * 14, tp.position.y + 4, 5, 30, Color("f0e6c8"))
	var cd := _sr_spot("SR13", "candles")
	r(cd.position.x, cd.position.y + 60, cd.size.x, 8, IRON)
	r(cd.get_center().x - 4, cd.position.y + 68, 8, cd.size.y - 68, IRON)
	for k in range(6):
		var cx := cd.position.x + 12 + k * 21.0
		r(cx - 3, cd.position.y + 40, 6, 20, Color("f0e6c8"))
		c(cx, cd.position.y + 34 + sin(t * 8.0 + k), 4, FIRE)
		c(cx, cd.position.y + 34, 12, Color(1, 0.7, 0.3, 0.15))


func _sr_theatre() -> void:
	_sr_sky()
	_sr_house(0, 960, 160, SR_HOUSES[3], 23)
	# The theatre's columns and pediment.
	poly([340, 100, 760, 100, 550, 40], Color("e8e0d0").darkened(0.35))
	r(340, 100, 420, 20, Color("e8e0d0").darkened(0.3))
	for k in range(5):
		r(352 + k * 96.0, 120, 22, 252, Color("e8e0d0").darkened(0.35))
	var d := _sr_spot("SR14", "door")
	r(d.position.x, d.position.y, d.size.x, d.size.y, Color(SR_LIT, 0.7) if flag("foyer_open") else Color("5a1a1a"))
	r(d.get_center().x - 2, d.position.y, 4, d.size.y, Color("3a0a0a"))
	var ps := _sr_spot("SR14", "posters")
	for k in range(2):
		rr(ps.position.x + 10 + k * 96, ps.position.y, 84, 130, PAPER.darkened(0.2), 3)
		_sr_mask(ps.position.x + 52 + k * 96, ps.position.y + 50, 0.22, k, k == 0, 1 + k, false)
		for j in range(3):
			ln(ps.position.x + 20 + k * 96, ps.position.y + 90 + j * 10, ps.position.x + 84 + k * 96, ps.position.y + 90 + j * 10, Color(INK, 0.5), 2)
	_sr_pave()
	var dm := _sr_spot("SR14", "doorman")
	poly([dm.position.x + 14, dm.end.y, dm.end.x - 14, dm.end.y, dm.end.x - 22, dm.position.y + 50, dm.position.x + 22, dm.position.y + 50], Color("6a1a2a"))
	for k in range(4):
		c(dm.get_center().x, dm.position.y + 70 + k * 20, 3, SR_GOLD)
	c(dm.get_center().x, dm.position.y + 34, 16, Color("e0b890"))
	poly([dm.get_center().x - 24, dm.position.y + 22, dm.get_center().x + 24, dm.position.y + 22, dm.get_center().x, dm.position.y], Color("1a1a1a"))
	_sr_festoon(30)


func _sr_squero() -> void:
	_sr_sky()
	# The boatyard's wooden house with its balcony.
	r(80, 100, 520, 220, Color("6a4a2a").darkened(0.2))
	poly([60, 100, 620, 100, 340, 40], Color("5a3a1a").darkened(0.2))
	for k in range(5):
		r(100 + k * 100, 130, 60, 50, Color(SR_LIT, 0.5) if k % 2 == 1 else SR_DARKWIN)
	_sr_pave(320)
	_sr_water(400)
	var o := _sr_spot("SR15", "oars")
	r(o.position.x, o.position.y + 20, o.size.x, 10, WOOD_D)
	for k in range(5 if not flag("got_oar") else 4):
		var ox := o.position.x + 16 + k * 26.0
		r(ox, o.position.y + 20, 6, o.size.y - 40, WOOD)
		poly([ox - 6, o.end.y - 30, ox + 12, o.end.y - 30, ox + 10, o.end.y, ox - 4, o.end.y], WOOD)
	var h := _sr_spot("SR15", "hull")
	poly([h.position.x, h.end.y, h.end.x, h.end.y, h.end.x - 20, h.position.y + 20, h.position.x + 30, h.position.y], Color("101012"))
	var b := _sr_spot("SR15", "boatbuilder")
	poly([b.position.x + 14, b.end.y, b.end.x - 14, b.end.y, b.end.x - 22, b.position.y + 50, b.position.x + 22, b.position.y + 50], Color("3a4a6a"))
	c(b.get_center().x, b.position.y + 34, 16, Color("e0b890"))
	var swing := sin(t * 4.0) * 0.5
	ln(b.position.x + 10, b.position.y + 80, b.position.x - 20, b.position.y + 70 + 20 * swing, WOOD, 4)
	r(b.position.x - 30, b.position.y + 62 + 20 * swing, 16, 12, IRON)


func _sr_palazzo() -> void:
	_sr_sky()
	_sr_house(0, 300, 80, SR_HOUSES[6], 25)
	_sr_house(660, 300, 60, SR_HOUSES[5], 26)
	# The palazzo: pink stone, pointed windows, and its green door.
	r(300, 20, 360, 352, Color("d89a8a").darkened(0.35))
	var bal := _sr_spot("SR16", "balcony")
	for k in range(4):
		var wx := bal.position.x + 20 + k * 44.0
		r(wx, bal.position.y + 20, 28, 50, SR_LIT if k != 2 else SR_DARKWIN)
		poly([wx, bal.position.y + 20, wx + 28, bal.position.y + 20, wx + 14, bal.position.y], SR_LIT if k != 2 else SR_DARKWIN)
	r(bal.position.x, bal.end.y - 14, bal.size.x, 14, Color("e8e0d0").darkened(0.3))
	var d := _sr_spot("SR16", "door")
	r(d.position.x, d.position.y + 30, d.size.x, d.size.y - 30, Color("15100c") if flag("court_open") else Color("1e5a3a"))
	c(d.get_center().x, d.position.y + 30, d.size.x / 2.0, Color("15100c") if flag("court_open") else Color("1e5a3a"))
	if not flag("court_open"):
		c(d.get_center().x, d.get_center().y, 8, BRASS)
		ring(d.get_center().x, d.get_center().y + 14, 10, BRASS, 3)
	_sr_pave()
	var p := _sr_spot("SR16", "porter")
	poly([p.position.x + 14, p.end.y, p.end.x - 14, p.end.y, p.end.x - 22, p.position.y + 50, p.position.x + 22, p.position.y + 50], Color("2a3a2a"))
	c(p.get_center().x, p.position.y + 34, 16, Color("e0b890"))
	ln(p.end.x - 10, p.position.y + 50, p.end.x - 10, p.end.y, WOOD_D, 4)


func _sr_passage() -> void:
	_sr_sky()
	_sr_house(0, 960, 30, SR_HOUSES[4], 27)
	var p := _sr_spot("SR17", "passage")
	r(p.position.x, p.position.y + 60, p.size.x, p.size.y - 60, Color("08070a"))
	c(p.get_center().x, p.position.y + 60, p.size.x / 2.0, Color("08070a"))
	# At the far end a little light, and a cat passing now and then.
	c(p.get_center().x, p.end.y - 60, 30, Color(SR_LIT, 0.25))
	if fmod(t, 9.0) < 3.0:
		var cx := p.position.x + 40 + fmod(t, 9.0) * 70.0
		ci.draw_set_transform(Vector2(cx, p.end.y - 16), 0.0, Vector2(1.6, 0.7))
		c(0, 0, 12, Color("1a1a1a"))
		home()
	var s := _sr_spot("SR17", "shrine")
	rr(s.position.x, s.position.y, s.size.x, s.size.y, Color("e8e0d0").darkened(0.3), 8)
	r(s.position.x + 14, s.position.y + 14, s.size.x - 28, s.size.y - 40, Color("2a4a8a"))
	c(s.get_center().x, s.position.y + 40, 12, Color("e8d8c0"))
	c(s.get_center().x, s.end.y - 16, 5 + sin(t * 7.0), FIRE)
	_sr_pave()


func _sr_quay() -> void:
	_sr_sky(220)
	_sr_water(220, 320)
	var b := _sr_spot("SR18", "barge")
	r(b.position.x, b.position.y + 70, b.size.x, 30, Color("2a2a2a"))
	r(b.position.x + 30, b.position.y + 50, 60, 20, WOOD)
	for k in range(5):
		r(b.position.x + 140 + k * 26, b.position.y + 20, 8, 50, SR_LANTERNS[k].darkened(0.2))
		poly([b.position.x + 138 + k * 26, b.position.y + 20, b.position.x + 150 + k * 26, b.position.y + 20, b.position.x + 144 + k * 26, b.position.y + 6], SR_LANTERNS[k])
	r(b.position.x + 110, b.position.y - 20, 4, 90, WOOD_D)
	if flag("mask_raised"):
		_sr_mask(b.position.x + 112, b.position.y - 30, 0.15, 0, true, 1, true)
	_sr_pave(320)
	r(0, 320, 960, 8, SR_STONE)
	var f := _sr_spot("SR18", "fishermen")
	for k in range(2):
		_sr_figure(f.position.x + 50 + k * 80.0, f.end.y, 0.7, 3 - k, false, 0)
		ln(f.position.x + 60 + k * 80.0, f.end.y - 70, f.position.x + 120 + k * 80.0, f.position.y - 40, WOOD, 2)
		ln(f.position.x + 120 + k * 80.0, f.position.y - 40, f.position.x + 124 + k * 80.0, f.end.y + 40, Color(1, 1, 1, 0.4), 1)


func _sr_barge() -> void:
	_sr_sky(300)
	_sr_water(300)
	# Far off, the city's lights.
	for k in range(30):
		r(k * 32.0, 280 - (k * 37) % 40, 24, 20 + (k * 37) % 40, Color("1a1a2a"))
		r(k * 32.0 + 8, 288 - (k * 37) % 40, 5, 6, SR_LIT)
	# The deck.
	poly([40, 360, 920, 360, 880, 440, 80, 440], WOOD_D)
	for k in range(10):
		ln(80 + k * 82.0, 360, 90 + k * 80.0, 440, WOOD, 2)
	var cr := _sr_spot("SR19", "crate")
	r(cr.position.x, cr.position.y + 20, cr.size.x, cr.size.y - 20, WOOD)
	for k in range(3):
		r(cr.position.x, cr.position.y + 30 + k * 30, cr.size.x, 4, WOOD_D)
	if flag("got_mask"):
		poly([cr.position.x, cr.position.y + 20, cr.end.x, cr.position.y + 20, cr.end.x - 20, cr.position.y - 20, cr.position.x - 10, cr.position.y], WOOD.lightened(0.1))
	else:
		rr(cr.get_center().x - 12, cr.position.y + 50, 24, 26, IRON, 4)
	var p := _sr_spot("SR19", "pole")
	r(p.get_center().x - 5, p.position.y + 20, 10, p.size.y - 20, WOOD_D)
	if flag("mask_raised"):
		c(p.get_center().x, p.position.y + 40, 60, Color(SR_GOLD, 0.2))
		_sr_mask(p.get_center().x, p.position.y + 40, 0.35, 0, true, 1, true)
	# The rockets: launched in order of the procession, each one leaves.
	var order: Array = []
	var lanterns: Array = clues.get("lanterns", [])
	for place in clues.get("route", []):
		if int(place) < lanterns.size():
			order.append(int(lanterns[int(place)]))
	var gone := {}
	var launched := int(st.get("launched", [0])[0])
	for k in range(mini(launched, order.size())):
		gone[order[k]] = true
	for k in range(5):
		var rx: float = CityViews.ROCKET_X + k * CityViews.ROCKET_GAP
		r(rx - 30, 350, 60, 16, IRON)
		if gone.has(k) or st.get("done", false):
			var phase := fmod(t * 0.5 + k * 0.2, 1.0)
			_sr_burst(rx, 90 + (k % 2) * 40, 70 * phase, SR_LANTERNS[k], 1.0 - phase)
			continue
		r(rx - 10, 220, 20, 130, Color("e8e0d0").darkened(0.2))
		poly([rx - 14, 220, rx + 14, 220, rx, 180], SR_LANTERNS[k])
		r(rx - 10, 300, 20, 14, SR_LANTERNS[k])
		ln(rx, 350, rx + 6, 366, Color("8a7a5a"), 2)


# --- Close-ups -------------------------------------------------------------------

func _srmap() -> void:
	r(0, 0, 960, 472, Color("2a1e14"))
	rr(16, 8, 928, 456, Color("f1e3c0"), 12)
	# Canals and the lagoon.
	var water := Color("7fa8c2")
	poly([600, 340, 944, 300, 944, 464, 540, 464], water)
	var canal := PackedVector2Array([Vector2(16, 220), Vector2(120, 225), Vector2(220, 205), Vector2(300, 205), Vector2(430, 190), Vector2(540, 170), Vector2(600, 300), Vector2(640, 350)])
	ci.draw_polyline(canal, water, 22.0, true)
	ci.draw_polyline(PackedVector2Array([Vector2(700, 8), Vector2(700, 180), Vector2(730, 240), Vector2(780, 330)]), water, 14.0, true)
	ci.draw_polyline(PackedVector2Array([Vector2(16, 340), Vector2(120, 330), Vector2(300, 330), Vector2(380, 340), Vector2(540, 340)]), water, 12.0, true)
	# Streets between places that are seen.
	var frontier := {}
	for k in range(CityViews.PLACES - 1):
		var exits: Dictionary = CityViews.EXITS[k]
		for d in exits:
			var to := int(exits[d])
			if to == 19:
				continue
			if CityViews.seen(st, k) or CityViews.seen(st, to):
				var a: Vector2 = CityViews.MAP_AT[k]
				var b: Vector2 = CityViews.MAP_AT[to]
				ln(a.x, a.y, b.x, b.y, Color("8a6a4a"), 5)
				if CityViews.seen(st, k) and not CityViews.seen(st, to):
					frontier[to] = true
	var here := CityViews.place_index(CityViews.here)
	for k in range(CityViews.PLACES):
		var p: Vector2 = CityViews.MAP_AT[k]
		if CityViews.seen(st, k):
			c(p.x, p.y, 13, _sr_lantern_of(k).darkened(0.1))
			ring(p.x, p.y, 13, Color("2a3a5a"), 3)
			txt(p.x, p.y - 20, tr("srplace.%d" % k), 13, Color("2a1a10"))
		elif frontier.has(k):
			c(p.x, p.y, 10, Color("b8b0a0"))
			txt(p.x, p.y + 5, "?", 14, Color("5a4a3a"))
		if k == here:
			ring(p.x, p.y, 20 + 2 * sin(t * 4.0), Color("c83a3a"), 4)
	# A compass rose.
	poly([60, 50, 68, 80, 60, 74, 52, 80], Color("5a3a1a"))
	txt(60, 46, "N", 16, Color("5a3a1a"))


func _srstage() -> void:
	r(0, 0, 960, 472, Color("3a0a14"))
	for k in range(12):
		poly([k * 80.0, 0, k * 80.0 + 80, 0, k * 80.0 + 60 + 10 * sin(t + k), 472, k * 80.0 + 20 + 10 * sin(t + k), 472], Color("5a1220") if k % 2 == 0 else Color("4a0e1a"))
	r(420, 340, 120, 132, SR_GOLD_D)
	r(380, 330, 200, 14, SR_GOLD)
	ci.draw_set_transform(Vector2(480, 270), 0.0, Vector2(1, 0.45))
	c(0, 0, 160, Color("a8202a"))
	c(0, -10, 140, Color("c02a34"))
	home()
	for k in range(4):
		var tx: float = [330.0, 630.0, 330.0, 630.0][k]
		var ty: float = [240.0, 240.0, 300.0, 300.0][k]
		c(tx, ty, 10, SR_GOLD)
	if flag("got_card"):
		rr(300, 40, 360, 330, Color("f0e6d0"), 6)
		ring(480, 120, 50, Color("1a1a1a"), 3)
		_sr_mask(480, 120, 0.4, 2, true, 0, false)
		ci.draw_multiline_string(font, Vector2(330, 210), tr("srtext.card"), HORIZONTAL_ALIGNMENT_CENTER, 300, 20, -1, INK)
	else:
		r(456, 236, 48, 30, Color("f0e6d0"))
		ln(456, 236, 504, 266, Color(INK, 0.3), 1)


func _srcafe() -> void:
	r(0, 0, 960, 472, Color("1a1410"))
	r(0, 0, 960, 140, Color(SR_LIT, 0.25))
	for k in range(4):
		var tx := 140.0 + k * 230
		ci.draw_set_transform(Vector2(tx, 150), 0.0, Vector2(1, 0.3))
		c(0, 0, 90, Color("e8e0d0"))
		home()
		r(tx - 6, 156, 12, 220, IRON)
		r(tx - 50, 370, 100, 10, IRON)
		c(tx - 20, 140, 10, Color("f2f2f2"))
		c(tx + 24, 144, 6, FIRE if fmod(t + k, 0.6) < 0.3 else AMBER)
	# The chairs' legs, and something small beneath one of them.
	for k in range(7):
		var cx := 60.0 + k * 140
		for j in range(4):
			r(cx + j * 18, 300, 5, 120, IRON_D)
		r(cx - 4, 296, 66, 8, IRON)
	r(0, 420, 960, 52, Color("2a2420"))
	if not flag("got_ticket"):
		at(587, 404, 0.25, 1.0)
		rr(-20, -10, 40, 20, Color("c8b890"), 2)
		r(6, -10, 2, 20, Color("8a3a2a"))
		home()


func _srmasks() -> void:
	r(0, 0, 960, 472, Color("3a1a1a"))
	for k in range(8):
		r(0, k * 60.0, 960, 2, Color("2a0a0a"))
	var masks: Array = clues.get("masks", [])
	for k in range(mini(6, masks.size())):
		var m: Array = masks[k]
		var cx: float = CityViews.MASK_AT.x + (k % 3) * CityViews.MASK_GAP.x + 90
		var cy: float = CityViews.MASK_AT.y + int(k / 3) * CityViews.MASK_GAP.y + 100
		ln(cx, cy - 90, cx, cy - 70, SR_GOLD_D, 2)
		c(cx, cy - 92, 4, SR_GOLD_D)
		_sr_mask(cx, cy, 0.85, int(m[0]), int(m[1]) == 1, int(m[2]), false)


func _srglass() -> void:
	r(0, 0, 960, 472, Color("140c0a"))
	# The furnace's mouth.
	c(160, 260, 150, Color("5a2a1a"))
	c(160, 260, 110, Color(1, 0.55 + 0.1 * sin(t * 7.0), 0.15))
	c(160, 260, 70, Color(1, 0.85, 0.45))
	# The gather on its pipe: its glow changes as it cools.
	var g: Array = clues.get("glow", [6, 2])
	var cycle := int(g[0])
	var phase := int(st.get("secs", 0)) % cycle
	var col := Color(1, 0.98, 0.85)
	if phase >= cycle - int(g[1]):
		col = Color(1, 0.55, 0.15)
	elif phase >= 2:
		col = Color(1, 0.88, 0.35)
	ln(300, 300, 700, 260, IRON, 8)
	c(470, 282, 70, Color(col, 0.25))
	c(470, 282, 50, col)
	# The glasses already blown.
	var done := int(st.get("glass", [0, 0])[0])
	for k in range(3):
		var gx := 380.0 + k * 90
		var made := k < done or flag("got_lantern")
		poly([gx - 20, 440, gx + 20, 440, gx + 26, 400, gx, 380, gx - 26, 400], Color(0.6, 0.85, 0.95, 0.75) if made else Color(1, 1, 1, 0.08))
	var s := Rect2(700, 30, 220, 110)
	rr(s.position.x, s.position.y, s.size.x, s.size.y, WOOD_D, 6)
	_s8_text(s.position.x + 14, s.position.y + 30, s.size.x - 28, "srtext.glass", 16, CREAM)
	c(s.end.x - 30, s.end.y - 20, 12, Color(1, 0.55, 0.15))


func _srtoss() -> void:
	r(0, 0, 960, 472, Color("2a1a12"))
	for k in range(12):
		poly([k * 80.0, 0, k * 80.0 + 80, 0, 480, -200], Color("c83a3a") if k % 2 == 0 else Color("f2e6d0"))
		r(k * 80.0, 0, 80, 40, Color("c83a3a") if k % 2 == 0 else Color("f2e6d0"))
	# The turning stand: five bottles, one with a gold neck.
	var g: Array = clues.get("toss", [5, 2])
	var cycle := int(g[0])
	var phase := int(st.get("secs", 0)) % cycle
	r(470, 160, 20, 230, IRON)
	ci.draw_set_transform(Vector2(480, 360), 0.0, Vector2(1, 0.3))
	c(0, 0, 170, WOOD)
	home()
	for k in range(5):
		# The gold one faces you at the end of each turn.
		var a := TAU * (k + phase - (cycle - (int(g[1]) + 1) / 2.0)) / 5.0 + PI / 2
		var bx := 480 + cos(a) * 150
		var depth := sin(a)
		var by := 330 + depth * 30
		var s := 0.8 + depth * 0.25
		var front := k == 0
		at(bx, by, 0.0, s)
		r(-14, -70, 28, 70, Color("2a6a3a").darkened(0.3 - depth * 0.3))
		r(-7, -100, 14, 30, SR_GOLD if front else Color("2a6a3a").darkened(0.3 - depth * 0.3))
		home()
	# The rings already on.
	var hits := int(st.get("rings", [0, 0])[0])
	for k in range(3):
		ring(380 + k * 100, 440, 22, SR_GOLD if k < hits or flag("got_coin") else Color(1, 1, 1, 0.15), 6)
	var b := Rect2(720, 150, 140, 220)
	_sr_figure(b.get_center().x, b.end.y, 1.2, 2, true, 1)


func _srfoyer() -> void:
	r(0, 0, 960, 472, Color("3a0a14"))
	for k in range(6):
		c(80 + k * 160.0, 30, 16, Color(SR_LIT, 0.5 + 0.2 * sin(t * 2.0 + k)))
	# The poster: tonight's procession on the city's plan.
	rr(220, 20, 520, 432, PAPER, 6)
	ring(480, 70, 30, SR_GOLD_D, 3)
	_sr_mask(480, 70, 0.25, 0, true, 1, false)
	var o := Vector2(250, 120)
	var sc := 0.48
	poly([o.x + 600 * sc, o.y + 340 * sc, o.x + 944 * sc, o.y + 300 * sc, o.x + 944 * sc, o.y + 464 * sc, o.x + 540 * sc, o.y + 464 * sc], Color("a8c8d8"))
	for k in range(CityViews.PLACES - 1):
		var exits: Dictionary = CityViews.EXITS[k]
		for d in exits:
			var a: Vector2 = CityViews.MAP_AT[k]
			var b: Vector2 = CityViews.MAP_AT[int(exits[d])]
			if int(exits[d]) != 19:
				ln(o.x + a.x * sc, o.y + a.y * sc, o.x + b.x * sc, o.y + b.y * sc, Color(INK, 0.25), 2)
	var route: Array = clues.get("route", [])
	for k in range(route.size()):
		var p: Vector2 = CityViews.MAP_AT[int(route[k])]
		if k > 0:
			var q: Vector2 = CityViews.MAP_AT[int(route[k - 1])]
			ln(o.x + q.x * sc, o.y + q.y * sc, o.x + p.x * sc, o.y + p.y * sc, Color("a8202a"), 5)
		c(o.x + p.x * sc, o.y + p.y * sc, 11, Color("a8202a"))
		txt(o.x + p.x * sc, o.y + p.y * sc + 6, str(k + 1), 14, CREAM)
	_s8_text(250, 400, 460, "srtext.poster", 16, INK)


func _srcourt() -> void:
	r(0, 0, 960, 472, Color("d89a8a").darkened(0.5))
	for k in range(4):
		r(60 + k * 230.0, 40, 120, 160, Color("15100c"))
		c(120 + k * 230.0, 40, 60, Color("15100c"))
	r(0, 220, 960, 252, SR_PAVE)
	c(480, 160, 40, Color("c8c0b0").darkened(0.4))
	# The bench with the diary, the casket, a sleeping cat.
	var d := Rect2(120, 250, 240, 120)
	r(d.position.x, d.position.y + 50, d.size.x, 14, WOOD)
	r(d.position.x + 10, d.position.y + 64, 10, 56, WOOD_D)
	r(d.end.x - 20, d.position.y + 64, 10, 56, WOOD_D)
	rr(d.position.x + 50, d.position.y + 10, 140, 40, Color("5a2a1a"), 4)
	r(d.get_center().x - 2, d.position.y + 10, 4, 40, PAPER)
	var cs := Rect2(560, 240, 200, 130)
	rr(cs.position.x + 20, cs.position.y + 30, cs.size.x - 40, cs.size.y - 40, Color("5a3a1a") if not flag("casket_open") else Color("3a2a1a"), 6)
	for k in range(4):
		_sr_symbol(k, cs.position.x + 50 + k * 34, cs.position.y + 60, 0.4, SR_GOLD)
	var cat := Rect2(780, 300, 120, 70)
	ci.draw_set_transform(Vector2(cat.get_center().x, cat.get_center().y + 6), 0.0, Vector2(1.6, 0.7))
	c(0, 0, 26 + 1.5 * sin(t * 2.0), Color("c87a3a"))
	home()
	c(cat.position.x + 20, cat.position.y + 30, 14, Color("c87a3a"))


func _srcasket() -> void:
	board(Color("3a2a1a"))
	rr(140, 60, 680, 360, Color("5a3a1a"), 10)
	if flag("casket_open"):
		rr(180, 100, 600, 280, Color("2a0a14"), 8)
		if not flag("got_cratekey"):
			item("srcratekey", 480, 240, 3.0)
		return
	var vals: Array = st.get("casket", [0, 0, 0, 0])
	for k in range(4):
		var x := 240 + k * 160.0
		_s8_arrows(x, 210)
		rr(x - 40, 190, 80, 80, PAPER, 8)
		_sr_symbol(int(vals[k]), x, 230, 1.2, INK)


func _srtop() -> void:
	r(0, 0, 960, 472, Color("05060c"))
	# Through the telescope: one eighth of the city at a time.
	var at_dir := int(st.get("scope", [0])[0])
	var scope: Array = clues.get("scope", [5, 2])
	var cx := 480.0
	var cy := 230.0
	c(cx, cy, 210, SR_SKY_LOW)
	for k in range(9):
		var hx := cx - 200 + k * 50.0
		var hh := 60.0 + ((k * 7 + at_dir * 13) % 5) * 20.0
		r(hx, cy + 80 - hh, 46, hh + 120, SR_HOUSES[(k + at_dir) % SR_HOUSES.size()].darkened(0.45))
		r(hx + 14, cy + 100 - hh, 10, 14, SR_LIT)
	if at_dir == int(scope[0]) or at_dir == 4 or at_dir == 6:
		r(cx - 210, cy + 90, 420, 120, SR_WATER)
	if at_dir == int(scope[0]):
		# The fireworks barge, and someone climbing onto it with a sack.
		r(cx - 80, cy + 110, 180, 20, Color("2a2a2a"))
		for k in range(5):
			r(cx - 40 + k * 20, cy + 80, 6, 30, SR_LANTERNS[k].darkened(0.3))
		_sr_figure(cx + 20, cy + 110, 0.6, 3, false, 2)
		c(cx + 40, cy + 70, 10, Color("8a7a5a"))
	elif at_dir == int(scope[1]):
		# A reveller in a cat mask dancing on a bridge.
		ci.draw_arc(Vector2(cx, cy + 160), 120, PI, TAU, 16, Color("c8c0b0").darkened(0.3), 16, true)
		_sr_figure(cx + 10 * sin(t * 3.0), cy + 44, 0.6, 3, false, 2)
	ci.draw_arc(Vector2(cx, cy), 340, 0, TAU, 64, Color("05060c"), 280, true)
	ring(cx, cy, 202, BRASS_D, 6)
	for k in range(8):
		var a := TAU * k / 8.0 - PI / 2
		c(cx + cos(a) * 224, cy + sin(a) * 224, 5 if k != at_dir else 8, SR_GOLD if k == at_dir else BRASS_D)
	arrow_btn(40, 200, 72, 72, 2)
	arrow_btn(848, 200, 72, 72, 3)


func _srsong() -> void:
	board(WOOD_D)
	rr(140, 20, 680, 440, PAPER, 6)
	for k in range(3):
		c(180 + k * 26, 50, 6, INK)
		ln(186 + k * 26, 50, 186 + k * 26, 30, INK, 2)
	_s8_text(180, 90, 600, "srtext.song", 19, INK)


func _srlagoon() -> void:
	r(0, 0, 960, 472, Color("2a2420"))
	var cv: Dictionary = clues.get("canals", {})
	var w := int(cv.get("w", 8))
	var h := int(cv.get("h", 5))
	var blocked: Array = cv.get("blocked", [])
	var o: Vector2 = CityViews.CANAL_AT
	var cs: float = CityViews.CANAL_CELL
	var stm: Array = clues.get("steamer", [7, 3, 20])
	for i in range(w * h):
		var cx := o.x + (i % w) * cs
		var cy := o.y + int(i / w) * cs
		var house := false
		for b in blocked:
			if int(b) == i:
				house = true
		if house:
			r(cx, cy, cs, cs, SR_HOUSES[i % SR_HOUSES.size()].darkened(0.35))
			r(cx + 8, cy + 8, cs - 16, cs - 16, SR_HOUSES[i % SR_HOUSES.size()].darkened(0.5))
			r(cx + 20, cy + 22, 8, 10, SR_LIT)
		else:
			r(cx, cy, cs, cs, SR_WATER)
			ln(cx + 10 + fmod(t * 8.0 + i * 7, 40.0), cy + 30 + (i % 3) * 10, cx + 26 + fmod(t * 8.0 + i * 7, 40.0), cy + 30 + (i % 3) * 10, Color(SR_GOLD, 0.3), 1.5)
	# Landmarks of the song: the little bridge, the stone lion, the red
	# house, the lamp, the broad canal with its steamer.
	var cell := func(i: int) -> Vector2: return o + Vector2((i % w) * cs, int(i / w) * cs)
	var br: Vector2 = cell.call(9)
	ci.draw_arc(br + Vector2(cs / 2, cs + 20), 40, PI * 1.2, PI * 1.8, 10, Color("d8c8a8"), 8, true)
	var li: Vector2 = cell.call(4)
	ci.draw_set_transform(li + Vector2(cs / 2, cs / 2 + 6), 0.0, Vector2(1.2, 0.8))
	c(0, 0, 20, Color("c8c0b0"))
	home()
	c(li.x + 22, li.y + 26, 12, Color("c8c0b0"))
	ring(li.x + 22, li.y + 26, 14, Color("a89070"), 4)
	var rh: Vector2 = cell.call(27)
	r(rh.x + 4, rh.y + 4, cs - 8, cs - 8, Color("c83a3a"))
	var lp: Vector2 = cell.call(21)
	c(lp.x + cs - 10, lp.y + 10, 10, Color(SR_LIT, 0.4))
	c(lp.x + cs - 10, lp.y + 10, 5, SR_LIT)
	var sc: Vector2 = cell.call(int(stm[2]))
	r(sc.x, sc.y - 6, cs, cs + 12, SR_WATER.lightened(0.08))
	var secs := int(st.get("secs", 0))
	if secs % int(stm[0]) >= int(stm[0]) - int(stm[1]):
		var k := float(secs % int(stm[0]) - (int(stm[0]) - int(stm[1])))
		var sy := sc.y - 20 + k * 30.0
		rr(sc.x + 12, sy, cs - 24, 50, Color("e8e0d0"), 8)
		r(sc.x + 28, sy - 14, 14, 16, Color("2a2a2a"))
		c(sc.x + 35, sy - 24 - fmod(t * 20.0, 20.0), 8, Color(1, 1, 1, 0.3))
	# The molo where you start, the barge waiting.
	var start: Vector2 = cell.call(int(cv.get("start", 16)))
	r(start.x - 40, start.y + 10, 40, cs - 20, SR_STONE)
	var goal: Vector2 = cell.call(int(cv.get("goal", 39)))
	r(goal.x + 6, goal.y + 30, cs - 12, 24, Color("2a2a2a"))
	for k in range(5):
		r(goal.x + 12 + k * 10, goal.y + 14, 5, 16, SR_LANTERNS[k])
	# The gondola.
	var at_cell := int(st.get("boat", [16])[0])
	var gp: Vector2 = cell.call(at_cell) + Vector2(cs / 2, cs / 2)
	poly([gp.x - 28, gp.y - 2, gp.x + 26, gp.y - 2, gp.x + 32, gp.y - 12, gp.x + 22, gp.y + 6, gp.x - 22, gp.y + 6], Color("0e0e10"))
	c(gp.x - 18, gp.y - 6, 4, AMBER)
	# The compass and the pole controls.
	poly([816, 320, 824, 360, 816, 352, 808, 360], CREAM)
	txt(816, 314, "N", 16, CREAM)
	var pad: Dictionary = CityViews.PAD
	var dirs := {"n": 0, "s": 1, "w": 2, "e": 3}
	for d in ["n", "w", "e", "s"]:
		var rect: Rect2 = pad[d]
		arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, dirs[d])
