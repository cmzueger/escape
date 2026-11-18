## Draws The Quiet House on top of ArtSet6: the same floor in 1905 (H1, H2),
## 1938 (J1, J2), 1969 (U1, U2) and today (X1, X2), with the close-ups.
## Hotspots are in views_house.gd.
class_name ArtHouse
extends ArtSet6

## Clara's key stickers, keys 0..7.
const CLARA := [Color("d03a2a"), Color("e8842a"), Color("e8c62a"), Color("3a9a4a"), Color("2a6ad0"), Color("4a3aa0"), Color("8a4ab0"), Color("e07aa8")]
const ERA_WALL := {"h": Color("2f4a3a"), "j": Color("c8b48a"), "u": Color("c8742a"), "x": Color("e8e4dc")}
const ERA_FLOOR := {"h": Color("4a2e1a"), "j": Color("6a4a2a"), "u": Color("7a5a3a"), "x": Color("b8a890")}


func draw_view(view: String) -> void:
	match view:
		"H1", "J1", "U1", "X1":
			_hq_parlour(view.substr(0, 1).to_lower())
		"H2", "J2", "U2", "X2":
			_hq_room(view.substr(0, 1).to_lower())
		"hpiano", "upiano", "xpiano":
			_hq_keys(view.substr(0, 1))
		"hstove", "jstove", "ustove", "xstove":
			_hq_stove_close(view.substr(0, 1))
		"hclock":
			_hq_clock_close()
		"hbed":
			_hq_bed()
		"hbox", "ubox":
			_hq_musicbox(view.substr(0, 1))
		"hhat":
			_hq_hat()
		"hnote", "jnote", "unotes", "xnotes":
			_hq_notes(view.substr(0, 1))
		"jphone", "uintercom", "xphone":
			_hq_phone(view.substr(0, 1))
		"jfuses":
			_hq_fuses()
		"jpanels":
			_hq_panels()
		"jcourt", "ucourt", "xcourt":
			_hq_court(view.substr(0, 1))
		"urecord":
			_hq_record()
		"udesk":
			_hq_desk()
		"xplan":
			_hq_plan()
		"xwall":
			_hq_walls()
		_:
			super.draw_view(view)
			return
	home()


func item(name: String, x: float, y: float, s: float = 1.0) -> void:
	match name:
		"hcrank":
			super.item("crank", x, y, s * 0.8)
			return
		"wkey", "hdoorkey", "jkey", "xkey":
			super.item("dkey", x, y, s * (1.2 if name == "hdoorkey" else 1.0))
			return
		"uglass":
			at(x, y, 0.0, s)
			ring(-9, 0, 8, GOLD, 3)
			ring(9, 0, 8, GOLD, 3)
			ln(-1, 0, 1, 0, GOLD, 3)
			ln(9, 8, 14, 20, GOLD, 2)
		"handset":
			at(x, y, -0.4, s)
			rr(-18, -5, 36, 10, Color("e8e0c8"), 5)
			rr(-22, -9, 10, 18, Color("e8e0c8"), 4)
			rr(12, -9, 10, 18, Color("e8e0c8"), 4)
		"hammer":
			at(x, y, 0.5, s)
			r(-2, -6, 4, 26, WOOD)
			r(-10, -12, 20, 8, STEEL)
		"matches":
			super.item("matches", x, y, s)
			return
		_:
			super.item(name, x, y, s)
			return
	home()


func card(room: String, w: float, h: float) -> void:
	var era: String = {"house1905": "h", "house1938": "j", "house1969": "u", "housenow": "x"}.get(room, "")
	if era == "":
		super.card(room, w, h)
		return
	r(0, 0, w, h, ERA_WALL[era])
	# The narrow house with its lit window, the year's light.
	rr(w * 0.32, h * 0.12, w * 0.36, h * 0.88, Color("6a5a4a"), 3)
	poly([w * 0.28, h * 0.14, w * 0.5, h * 0.0, w * 0.72, h * 0.14], Color("4a3a2a"))
	var walker := int(t * 0.6) % 6
	var glow := Color("ffd890") if era != "u" else Color("ffb870")
	for k in range(3):
		for j in range(2):
			var lit := (k == 1 and j == 0) or k * 2 + j == walker
			var flicker := 0.85 + 0.15 * sin(t * 9.0 + k * 3.0 + j)
			r(w * (0.38 + j * 0.15), h * (0.22 + k * 0.24), w * 0.09, h * 0.14, Color(glow, flicker) if lit else Color("2a2a3a"))
	if era == "u":
		# The television's blue light in the living room.
		r(w * 0.38, h * 0.46, w * 0.09, h * 0.14, Color(0.5, 0.6, 1.0, 0.35 + 0.25 * sin(t * 11.0)))
	for k in range(3):
		var up := fmod(t * 6.0 + k * 9.0, 27.0)
		c(w * 0.62 + 3.0 * sin(t + k), h * 0.08 - up, 3 + up * 0.15, Color(0.85, 0.85, 0.85, 0.35 * (1.0 - up / 27.0)))
	txt(w * 0.5, h * 0.95, {"h": "1905", "j": "1938", "u": "1969", "x": "∞"}[era] if era != "x" else "", 12, CREAM)


# --- The floor in each era ------------------------------------------------------

func _hq_wall(era: String) -> void:
	var wall: Color = ERA_WALL[era]
	r(0, 0, 960, 372, wall)
	match era:
		"h":
			for i in range(16):
				for j in range(6):
					c(30 + i * 60, 30 + j * 60, 6, wall.lightened(0.08))
		"j":
			for i in range(24):
				r(i * 40.0, 0, 14, 372, wall.darkened(0.05))
		"u":
			for i in range(10):
				for j in range(4):
					ring(48 + i * 96, 48 + j * 96, 30, wall.lightened(0.12), 6)
		_:
			for i in range(8):
				r(60 + i * 110.0, 40 + (i * 37) % 200, 60, 40, wall.darkened(0.06))
	r(0, 372, 960, 100, ERA_FLOOR[era])
	for i in range(12):
		r(i * 80.0, 372, 2, 100, ERA_FLOOR[era].darkened(0.2))


func _hq_piano(x: float, y: float, era: String) -> void:
	if era == "x":
		poly([x, y + 220, x + 10, y + 30, x + 120, y, x + 240, y + 30, x + 250, y + 220], Color("d8d4cc"))
		return
	rr(x, y + 20, 250, 180, Color("2a1a12"), 6)
	r(x + 10, y + 110, 230, 30, CREAM)
	for k in range(14):
		r(x + 12 + k * 16.4, y + 110, 1.5, 30, INK)
	r(x + 20, y + 200, 12, 30, Color("2a1a12"))
	r(x + 218, y + 200, 12, 30, Color("2a1a12"))


func _hq_stove(x: float, y: float, era: String) -> void:
	var tile: Color = Color("5a7a8a") if era == "x" else Color("3a6a8a")
	rr(x, y, 160, 310, Color("2a2a2a"), 6)
	for j in range(7):
		for i in range(3):
			rr(x + 8 + i * 50, y + 10 + j * 42, 46, 38, tile, 3)
	if era == "x":
		poly([x - 6, y + 160, x + 166, y + 140, x + 170, y + 320, x - 10, y + 320], Color(0.85, 0.84, 0.8, 0.6))


func _hq_parlour(era: String) -> void:
	_hq_wall(era)
	match era:
		"h":
			_hq_piano(40, 150, era)
			_hq_stove(400, 60, era)
			_hq_clock(650, 90, 40)
			c(660, 210, 26, Color("ffe8a0"))
			r(656, 230, 8, 40, BRASS_D)
			door(790, 40, 150, 332)
		"j":
			_hq_piano(30, 170, era)
			_hq_stove(300, 60, era)
			rr(500, 50, 110, 140, Color("4a4a4a"), 6)
			for k in range(4):
				rr(510 + (k % 2) * 50, 70 + floorf(k / 2.0) * 56, 40, 46, Color("2a2a2a"), 3)
			_hq_phone_small(550, 300, Color("1a1a1a"))
			for k in range(3):
				rr(640 + k * 56, 260, 50, 110, Color("8a6a4a"), 3)
			var lit := flag("lamp_on")
			ln(710, 0, 710, 40, INK, 2)
			poly([670, 80, 750, 80, 730, 40, 690, 40], Color("ffe8a0") if lit else Color("6a6a5a"))
			door(820, 40, 120, 332)
		"u":
			_hq_piano(30, 170, era)
			_hq_stove(300, 60, era)
			rr(500, 300, 190, 70, Color("8a6a4a"), 6)
			c(570, 290, 50, Color("1a1a1a"))
			c(570, 290, 14, Color("c03a2a"))
			rr(510, 90, 90, 70, Color("8a5a3a"), 4)
			rr(730, 220, 180, 150, Color("4a4a4a"), 14)
			rr(750, 240, 140, 100, Color("6a7a7a"), 20)
		_:
			_hq_piano(30, 170, era)
			_hq_stove(300, 60, era)
			_hq_phone_small(560, 320, Color("2a2a2a"))
			poly([660, 370, 680, 220, 900, 200, 920, 370], Color("d8d4cc"))


func _hq_room(era: String) -> void:
	_hq_wall(era)
	# The window onto the courtyard, in every era.
	var wx := 380.0 if era == "h" else 360.0
	rr(wx, 40, 230 if era == "h" else 240, 220, Color("5a3a2a"), 6)
	r(wx + 12, 52, (230 if era == "h" else 240) - 24, 196, Color("2a3040") if era != "x" else Color("9ab0c0"))
	match era:
		"h":
			rr(30, 220, 320, 150, Color("8a5a3a"), 8)
			rr(40, 200, 300, 40, Color("6a4a2a"), 8)
			rr(60, 250, 120, 50, CREAM, 10)
			rr(380, 280, 220, 90, Color("6a4a2a"), 4)
			rr(440, 250, 90, 40, Color("8a5a2a"), 6)
			rr(650, 40, 260, 332, Color("5a3a2a"), 6)
			r(778, 50, 4, 312, Color("3a2416"))
			if flag("ward_open"):
				r(660, 50, 116, 312, Color("1a1008"))
				rr(680, 260, 80, 60, Color("8a3a5a"), 6)
		"j":
			rr(40, 240, 280, 130, Color("6a4a2a"), 6)
			rr(80, 200, 80, 60, Color("2a2a2a"), 6)
			rr(660, 60, 140, 110, BRASS_D, 4)
			r(670, 70, 120, 90, Color("d8c8a0"))
			rr(680, 240, 160, 120, Color("6a4a2a"), 10)
			c(760, 290, 30, Color("c8a878"))
		"u":
			rr(40, 230, 290, 140, Color("c8a878"), 4)
			rr(60, 40, 200, 160, Color("e83a8a"), 4)
			c(160, 120, 50, Color("f0d040"))
			rr(660, 140, 110, 110, Color("c8c0b0"), 8)
			c(715, 180, 14, Color("2a2a2a"))
			door(800, 40, 140, 332)
		_:
			rr(40, 60, 260, 230, Color("f0ece0"), 4)
			for k in range(4):
				ln(60, 90 + k * 50, 280, 90 + k * 50, Color("3a5ad0", 0.6), 2)
			rr(380, 290, 200, 80, Color("c83a2a"), 6)
			for k in range(8):
				r(316, 70 + k * 38, 48, 6, Color("a0a0a0"))
			ln(320, 60, 320, 370, Color("a0a0a0"), 6)
			ln(360, 60, 360, 370, Color("a0a0a0"), 6)
			for k in range(6):
				rr(640 + k * 48, 40, 44, 330, Color("d8d0c0") if k != 3 else Color("d8d0c4"), 2)


func _hq_clock(x: float, y: float, rad: float) -> void:
	c(x, y, rad, CREAM)
	ring(x, y, rad, BRASS_D, 4)
	ln(x, y, x + rad * 0.4, y - rad * 0.3, INK, 3)
	ln(x, y, x - rad * 0.1, y - rad * 0.75, INK, 2)


func _hq_phone_small(x: float, y: float, col: Color) -> void:
	rr(x - 50, y, 100, 60, col, 8)
	rr(x - 40, y - 18, 80, 18, col, 8)
	c(x, y + 30, 18, Color(1, 1, 1, 0.15))


## A treble clef sticker with dots under it.
func _hq_clef(x: float, y: float, s: float, dots: int) -> void:
	rr(x - 16 * s, y - 26 * s, 32 * s, 52 * s, CREAM, 4 * s)
	ci.draw_arc(Vector2(x, y + 4 * s), 8 * s, 0.5, TAU - 0.3, 12, INK, 2.5 * s, true)
	ln(x + 2 * s, y - 20 * s, x + 2 * s, y + 18 * s, INK, 2.5 * s)
	ci.draw_arc(Vector2(x - 3 * s, y - 14 * s), 6 * s, -1.5, 1.6, 8, INK, 2.5 * s, true)
	for k in range(dots):
		c(x - (dots - 1) * 3 * s + k * 6 * s, y + 34 * s, 2 * s, INK)


# --- Close-ups ---------------------------------------------------------------------

func _hq_keys(era: String) -> void:
	board(Color("2a1a12"))
	var x0 := HouseViews.KEY_X
	var w := HouseViews.KEY_W
	rr(x0 - 20, 30, w * 8 + 40, 130, Color("1a100a"), 8)
	# The lid's compartment.
	var lid_flag: String = {"h": "tune_ok", "u": "tune_ok", "x": "tune_ok"}[era]
	if flag(lid_flag):
		rr(300, 40, 360, 90, Color("0a0604"), 6)
	else:
		rr(300, 40, 360, 90, Color("2a1a12"), 6)
		r(470, 80, 20, 10, BRASS)
	for i in range(8):
		rr(x0 + i * w, 220, w - 6, 230, CREAM, 6)
		var fade := 1.0 if era == "h" else (0.8 if era == "j" else (0.6 if era == "u" else 0.45))
		c(x0 + i * w + w / 2 - 3, 410, 14, Color(CLARA[i], fade))
	for i in [0, 1, 3, 4, 5]:
		rr(x0 + (i + 1) * w - 22, 220, 34, 140, Color("1a1a1a"), 4)
	if flag("got_xkey") or flag("got_wkey") or flag("got_glass"):
		return
	if flag(lid_flag):
		match era:
			"h":
				item("wkey", 480, 85, 2.0)
			"u":
				item("uglass", 480, 85, 2.0)
			_:
				item("xkey", 480, 85, 2.0)


func _hq_stove_close(era: String) -> void:
	board(ERA_WALL[era if era != "h" else "h"].darkened(0.2))
	rr(200, 20, 560, 440, Color("2a2a2a"), 10)
	for j in range(5):
		for i in range(6):
			var tx := 220 + i * 90.0
			var ty := 40 + j * 84.0
			rr(tx, ty, 84, 78, Color("3a6a8a"), 4)
			ci.draw_arc(Vector2(tx + 42, ty + 39), 22, 0, TAU, 16, Color("5a8aaa"), 3, true)
	match era:
		"h":
			_hq_clef(352, 220, 1.4, int(clues.get("clefs", [0, 0, 0])[1]))
		_:
			var got := flag("got_note") or flag("got_notes")
			if got:
				r(500, 260, 90, 80, Color("0a0a0a"))
				rr(380, 320, 200, 100, PAPER, 4)
				for k in range(4):
					ln(400, 345 + k * 18, 560, 345 + k * 18, Color("8a7a5a"), 2)
			else:
				ln(510, 275, 560, 320, Color("1a2a3a"), 3)
				ln(560, 320, 580, 300, Color("1a2a3a"), 3)
	if era == "x":
		rr(640, 60, 200, 120, Color("4a4a4a"), 8)
		var open := int(st.get("damper", [0])[0]) == 1
		ln(740, 120, 740 + (60 if open else 0), 120 - (0 if open else 50), BRASS, 10)
		c(740, 120, 12, BRASS_D)
		if flag("fire"):
			for k in range(5):
				c(300 + k * 70, 380, 26, Color(1.0, 0.5 + 0.1 * sin(t * 6 + k), 0.1, 0.8))


func _hq_clock_close() -> void:
	board(ERA_WALL["h"].darkened(0.2))
	_hq_clock(480, 220, 180)
	_hq_clef(590, 330, 1.0, int(clues.get("clefs", [0, 0, 0])[0]))


func _hq_bed() -> void:
	board(ERA_WALL["h"].darkened(0.2))
	rr(60, 60, 840, 120, Color("6a4a2a"), 10)
	_hq_clef(820, 120, 1.8, int(clues.get("clefs", [0, 0, 0])[2]))
	rr(60, 180, 840, 260, Color("e8e0d0"), 10)
	rr(120, 230, 260, 120, CREAM, 30)
	if not flag("got_crank"):
		item("hcrank", 360, 350, 2.0)


func _hq_musicbox(era: String) -> void:
	board(Color("2a1a12"))
	rr(220, 200, 520, 220, Color("8a5a2a"), 10)
	poly([220, 200, 740, 200, 700, 60, 260, 60], Color("6a3a1a"))
	# The pin cylinder and the comb: each pin row in a key's colour.
	rr(270, 250, 420, 80, Color("c8b080"), 20)
	var tune: Array = clues.get("box", [])
	var running := era == "u" or flag("wound")
	for k in range(tune.size()):
		var px := 300 + k * (360.0 / maxf(1, tune.size()))
		var col: Color = CLARA[int(tune[k])]
		c(px, 290, 10, col if running else Color(col, 0.3))
	for k in range(8):
		r(280 + k * 50, 345, 30, 50, Color(CLARA[k], 0.85))
	if era == "h" and not flag("wound"):
		ring(760, 300, 20, BRASS_D, 6)


func _hq_hat() -> void:
	board(Color("1a1008"))
	rr(220, 40, 520, 400, Color("8a3a5a"), 30)
	if flag("hat_open"):
		rr(260, 90, 440, 320, Color("2a1018"), 20)
		rr(320, 140, 320, 200, PAPER, 4)
		for k in range(6):
			ln(340, 170 + k * 26, 610, 170 + k * 26, Color("8a7a5a"), 2)
		if not flag("got_hat"):
			item("hdoorkey", 560, 300, 2.4)
		return
	var sizes := [0.7, 1.0, 1.3]
	for i in range(3):
		_hq_clef(400 + i * 80, 140, sizes[i], 0)
	kit_wheels(st.get("hat", [0, 0, 0]), 400, 270)


## The notes found in the house, as far as this era knows them.
func _hq_notes(era: String) -> void:
	board(Color("3a2a1a"))
	var keys: Array = {"h": ["hstory.clara"], "j": ["jstory.marie"], "u": ["ustory.marie", "ustory.berta"], "x": ["xstory.marie", "xstory.berta", "xstory.jost"]}[era]
	var w := 880.0 / keys.size() if era != "u" else 270.0
	for k in range(keys.size()):
		var x := 40 + k * (w + 8)
		rr(x, 20, w - 8, 440, PAPER, 4)
		ci.draw_multiline_string(font, Vector2(x + 14, 52), tr(keys[k]), HORIZONTAL_ALIGNMENT_LEFT, w - 36, 17 if keys.size() < 3 else 15, -1, INK)
	if era == "j":
		var p: Array = clues.get("phone", [])
		txt(480, 420, "%d %d %d %d" % [int(p[0]), int(p[1]), int(p[2]), int(p[3])], 40, INK)
	if era == "u":
		# Berta's sketch of the courtyard, drawn from the other side.
		rr(600, 60, 320, 360, PAPER, 4)
		for j in range(3):
			for i in range(3):
				var marked := j * 3 + i == int(clues.get("sketch", 0))
				rr(630 + i * 96, 90 + j * 110, 70, 80, Color("8a7a5a"), 2)
				if marked:
					ln(620 + i * 96, 80 + j * 110, 710 + i * 96, 180 + j * 110, RED, 4)
					ln(710 + i * 96, 80 + j * 110, 620 + i * 96, 180 + j * 110, RED, 4)
		poly([760, 418, 740, 400, 780, 400], INK)
	if era == "u" or era == "x":
		# Marie's old number, still on her note.
		txt(40 + (w - 8) / 2, 400, "3 8 1 5", 26 if era == "u" else 22, INK)
	if era == "x":
		var paris: Array = clues.get("paris", [])
		txt(40 + 2 * (w + 8) + (w - 8) / 2, 320, "%d %d %d %d" % [int(paris[0]), int(paris[1]), int(paris[2]), int(paris[3])], 26, INK)


func _hq_phone(era: String) -> void:
	board(Color("2a2a2a") if era != "u" else Color("c8c0b0"))
	var at := int(st.get("talk", [0])[0])
	if at == 0:
		if era == "u":
			rr(560, 120, 300, 200, Color("e8e0d0"), 10)
			c(710, 200, 30, Color("2a2a2a") if flag("intercom") else Color("8a8a8a"))
		else:
			kit_wheels(st.get("phone", [0, 0, 0, 0]), 140, 270)
			rr(560, 120, 300, 200, Color("1a1a1a"), 30)
			rr(600, 150, 220, 40, Color("3a3a3a"), 20)
		return
	var lines: Array = clues.get("lines", [])
	if at - 1 >= lines.size():
		return
	var line: Dictionary = lines[at - 1]
	rr(60, 30, 840, 200, Color("f0e8d8"), 12)
	ci.draw_multiline_string(font, Vector2(84, 70), tr(str(line["text"])), HORIZONTAL_ALIGNMENT_LEFT, 790, 22, -1, INK)
	var choices: Array = line["choices"]
	for i in range(choices.size()):
		rr(60, 250 + i * 70.0, 840, 62, Color("4a3a2a"), 10)
		ci.draw_multiline_string(font, Vector2(84, 288 + i * 70.0), tr(str(choices[i])), HORIZONTAL_ALIGNMENT_LEFT, 790, 20, 2, CREAM)


func _hq_fuses() -> void:
	board(Color("4a4a4a"))
	var vals: Array = st.get("fuses", [0, 0, 0, 0])
	var many := 0
	for v in vals:
		many += int(v)
	for i in range(4):
		var x := 150 + i * 170.0
		rr(x, 120, 150, 260, Color("2a2a2a"), 8)
		var on := int(vals[i]) == 1
		rr(x + 50, 200 if on else 260, 50, 80, CREAM, 6)
		_hq_room_icon(i, x + 75, 160)
	c(480, 60, 18, Color("ffe8a0") if flag("lamp_on") else (Color("c83a2a") if many > 2 else Color("3a3a3a")))


## Kitchen (a pot), parlour (a piano), stairs, shop (a sign).
func _hq_room_icon(k: int, x: float, y: float) -> void:
	match k:
		0:
			rr(x - 18, y - 6, 36, 20, CREAM, 4)
			ln(x - 24, y - 6, x + 24, y - 6, CREAM, 3)
		1:
			rr(x - 20, y - 14, 40, 28, CREAM, 3)
			for j in range(5):
				r(x - 16 + j * 7, y, 4, 12, INK)
		2:
			for j in range(4):
				r(x - 20 + j * 10, y + 10 - j * 8, 12, 4 + j * 8, CREAM)
		_:
			rr(x - 20, y - 12, 40, 24, CREAM, 3)
			ln(x, y - 22, x, y - 12, CREAM, 2)


func _hq_panels() -> void:
	board(Color("6a4a2a"))
	for i in range(6):
		rr(60 + i * 140.0, 60, 130, 360, Color("8a6a4a"), 6)
		rr(76 + i * 140.0, 80, 98, 320, Color("7a5a3a"), 4)
	if flag("got_box"):
		var m := int(clues.get("marked", 1))
		rr(76 + m * 140.0, 80, 98, 320, Color("1a1008"), 4)


## The courtyard and the opposite wing, three floors of three windows.
func _hq_court(era: String) -> void:
	board(Color("5a3a2a"))
	r(20, 20, 920, 432, Color("6a5a4a"))
	r(20, 20, 920, 60, Color("2a3040") if era != "x" else Color("9ab0c0"))
	if era == "x":
		# The roof with its three chimneys (the plan seen from the courtyard,
		# so mirrored): the neighbour's always smokes, ours once the stove burns.
		for k in range(3):
			rr(240 + k * 220, 0, 50, 70, Color("7a4a3a"), 3)
		for k in [1, 2]:
			if k == 2 and not flag("fire"):
				continue
			for j in range(6):
				c(265 + k * 220 + sin(t * 2 + j) * 10, 60 - j * 12, 14 + j * 3, Color(0.9, 0.9, 0.9, 0.5 - j * 0.07))
	var pots: Array = clues.get("pots", [])
	for j in range(3):
		for i in range(3):
			var x := 120 + i * 270.0
			var y := 110 + j * 115.0
			rr(x, y, 180, 95, Color("4a3a2a"), 4)
			var lit := era == "j" and j == 1 and i == 1 and flag("lamp_on")
			r(x + 8, y + 8, 164, 79, Color("ffe8a0") if lit else Color("2a3040"))
			if lit:
				# The stairwell window reflects the lit parlour: six panels, one marked, mirrored.
				var m := 5 - int(clues.get("marked", 1))
				for p in range(6):
					rr(x + 14 + p * 26, y + 30, 22, 50, Color("8a6a4a"), 2)
				_hq_clef(x + 25 + m * 26, y + 52, 0.4, 0)
			if era == "u" and j * 3 + i < pots.size():
				var near := flag("glass_on")
				for p in range(3):
					rr(x + 30 + p * 44, y + 60, 30, 26, Color("b85a3a"), 3)
					if near:
						txt(x + 45 + p * 44, y + 82, str(int(pots[j * 3 + i][p])), 18, CREAM)


func _hq_record() -> void:
	board(Color("7a5a3a"))
	rr(80, 40, 560, 420, Color("8a6a4a"), 10)
	c(360, 230, 170, Color("1a1a1a"))
	for k in range(6):
		ring(360, 230, 60 + k * 18, Color("2a2a2a"), 2)
	c(360, 230, 50, Color("c03a2a"))
	var sp := int(st.get("speed", [0])[0])
	rr(110, 340, 200, 90, Color("4a3a2a"), 8)
	for k in range(3):
		var on := k == sp
		c(150 + k * 60, 385, 20, CREAM if on else Color("6a5a4a"))
		c(150 + k * 60, 385, 8 + k * 3, INK if on else Color("4a3a2a"))
	ln(600, 80, 480, 260, STEEL, 8)
	# The sleeve: the pianist, and the first half of the tune in her colours.
	rr(660, 40, 260, 400, Color("e8e0d0"), 6)
	c(790, 150, 60, Color("3a3a3a"))
	c(790, 130, 24, Color("f0c8a0"))
	var half: Array = clues.get("record", [])
	for k in range(half.size()):
		c(710 + k * 52, 290, 16, CLARA[int(half[k])])
	txt(790, 380, "C. L.", 30, INK)


func _hq_desk() -> void:
	board(Color("c8a878"))
	rr(200, 40, 560, 400, Color("a07a4a"), 8)
	if flag("drawer_open"):
		rr(240, 80, 480, 320, Color("2a1a0a"), 6)
		if not flag("got_handset"):
			item("handset", 480, 240, 3.0)
		return
	for k in range(3):
		rr(380 + (k - 1) * 80 - 36, 140, 72, 40, Color("b85a3a"), 4)
	kit_wheels(st.get("drawer", [0, 0, 0]), 400, 270)


## The renovation plan: the floor from above, its walls and three flues.
func _hq_plan() -> void:
	board(Color("8a8a8a"))
	rr(60, 20, 840, 440, Color("f0ece0"), 6)
	for k in range(12):
		ln(60, 40 + k * 36, 900, 40 + k * 36, Color(0.3, 0.4, 0.8, 0.15), 1)
	r(140, 80, 680, 8, Color("2a3a8a"))
	r(140, 360, 680, 8, Color("2a3a8a"))
	r(140, 80, 8, 288, Color("2a3a8a"))
	r(812, 80, 8, 288, Color("2a3a8a"))
	r(480, 80, 6, 288, Color("2a3a8a"))
	for k in range(3):
		var fx := 220 + k * 240.0
		ring(fx, 84, 16, Color("2a3a8a"), 4)
		if k == 0:
			rr(fx - 20, 110, 40, 60, Color("2a3a8a", 0.6), 3)
	for k in range(6):
		ln(500 + k * 52, 70, 500 + k * 52, 96, Color("2a3a8a"), 2)


func _hq_walls() -> void:
	board(Color("b8b0a0"))
	if flag("niche_open"):
		r(60, 40, 840, 400, Color("d8d0c0"))
		rr(360, 100, 240, 300, Color("2a1a10"), 6)
		rr(200, 160, 560, 260, Color("8a5a3a"), 10)
		kit_wheels(st.get("box", [0, 0, 0, 0]), 360, 290)
		return
	for i in range(6):
		rr(60 + i * 140.0, 40, 130, 400, Color("d8d0c0"), 4)
		for k in range(8):
			r(66 + i * 140.0, 60 + k * 48, 118, 2, Color("c8c0b0"))
