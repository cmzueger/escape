## Locked In: the catalogue of rooms and the game screen. The rules live in
## Rust (RoomLink); this script shows the views (Art, ArtLight, Views), the
## bar with time, inventory and hints, the panels, and plays the sounds.
extends Control

const SAVE_PATH := "user://hut2847.cfg"
const SCENE_H := 472.0
const LANGS := ["en", "de", "fr", "it", "es"]
const TITLES := {
	"hut": "Hut 2847", "light": "Gale Rock Light", "obs": "Col Sidereal",
	"orangery": "The Orangery", "theatre": "Curtain Call", "chess": "The Grandmaster's Study",
	"beach": "Low Tide", "train": "Night Train", "alch": "The Alchemist's Cellar",
}
## Texts of the lighthouse have their keys with an "l" in front, those of
## the observatory with an "o".
const PREFIX := {"hut": "", "light": "l", "obs": "o", "orangery": "g", "theatre": "t", "chess": "c",
	"beach": "b", "train": "n", "alch": "a"}
const SLOTS := 8
const HINT_RECT := Rect2(800, 484, 136, 44)
const MENU_RECT := Rect2(908, 8, 44, 44)
const LEFT_RECT := Rect2(6, 200, 52, 72)
const RIGHT_RECT := Rect2(902, 200, 52, 72)
const BACK_RECT := Rect2(10, 414, 100, 52)
const UP_RECT := Rect2(490, 6, 100, 50)
const UNLOCKS := ["msg.cup_open", "msg.door2_unlocked", "msg.drawer_open", "msg.safe_open", "msg.baro_open",
	"lmsg.hatch1_open", "lmsg.chest_open", "lmsg.hatch2_open", "lmsg.locker_open", "lmsg.hatch3_open",
	"omsg.drawer_open", "omsg.cabinet_open", "omsg.box_open", "omsg.gate_open", "omsg.atlas_open", "omsg.orrery_open", "omsg.door_open",
	"gmsg.cab_open", "gmsg.shed_open", "gmsg.door_open", "tmsg.trunk_open", "tmsg.trap_open", "tmsg.masks_open",
	"tmsg.door_open", "tmsg.key_in", "cmsg.drawer_open", "cmsg.safe_open", "cmsg.clock_open", "cmsg.cab_open",
	"cmsg.king_safe", "cmsg.king_down", "cmsg.door_open", "cmsg.key_in",
	"bmsg.box_open", "bmsg.locker_open", "bmsg.clock_open", "bmsg.tin_open", "bmsg.door_open", "bmsg.kite_down",
	"nmsg.case_open", "nmsg.brief_open", "nmsg.panel_open", "nmsg.seat_up", "nmsg.handle_in",
	"amsg.cab_open", "amsg.balanced", "amsg.rings_ok", "amsg.gold", "amsg.door_open"]
const WRONG := ["msg.no_use", "lmsg.no_use", "msg.signal_wrong", "lmsg.lamp_wrong", "lmsg.lamp_not_ready",
	"lmsg.oil_little", "lmsg.oil_much", "lmsg.crank_free", "msg.stove_need", "msg.bucket_cold", "msg.key_wrong",
	"omsg.no_use", "omsg.wheel_dead", "omsg.board_dead", "omsg.scope_sags", "omsg.see_dome", "omsg.see_stars", "omsg.bar_empty",
	"gmsg.no_use", "tmsg.no_use", "cmsg.no_use", "gmsg.can_empty", "gmsg.pot_hard", "gmsg.valves_stuck",
	"tmsg.desk_dead", "tmsg.masks_wrong", "tmsg.spot_high", "cmsg.king_attacked", "cmsg.square_taken",
	"bmsg.no_use", "nmsg.no_use", "amsg.no_use", "bmsg.kite_wrong", "bmsg.no_slot", "nmsg.seat_empty",
	"nmsg.no_socket", "amsg.step_wrong", "amsg.too_hot", "amsg.too_cold", "amsg.bellows_torn", "amsg.bellows_early"]

var link := RoomLink.new()
var art := ArtSet3.new()
var sound := Sound.new()
var rooms: Array = []
var room := "hut"
var st: Dictionary = {}
var clues: Dictionary = {}
var view := "A"
var selected := ""
## load (rules not there yet), title (the catalogue), play, ending (solved,
## before the end panel), end
var mode := "load"
var seconds := 0.0
## Lightning on its own (the lighthouse); tests switch it off.
var storm := true

var _time := 0.0
var _sent := 0
var _message := ""
var _message_left := 0.0
var _glint := 0.0
var _flash_left := 0.0
var _next_flash := 5.0
var _prefs := ConfigFile.new()
var _scene: Control
var _light: ColorRect
var _over: Control
var _hud: Control
var _panels: Control
var _panel_open := false


func _ready() -> void:
	_prefs.load(SAVE_PATH)
	_migrate_prefs()
	var lang: String = _prefs.get_value("prefs", "lang", OS.get_locale_language())
	TranslationServer.set_locale(lang if lang in LANGS else "en")
	theme = _make_theme()
	art.font = ThemeDB.fallback_font
	add_child(sound)
	sound.set_muted(_prefs.get_value("prefs", "muted", false))
	_scene = _layer(Rect2(0, 0, 960, SCENE_H), _draw_scene)
	_scene.clip_contents = true
	_light = ColorRect.new()
	_light.position = Vector2.ZERO
	_light.size = Vector2(960, SCENE_H)
	_light.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = load("res://scripts/light.gdshader")
	_light.material = material
	add_child(_light)
	_over = _layer(Rect2(0, 0, 960, SCENE_H), _draw_over)
	_hud = _layer(Rect2(0, 0, 960, 540), _draw_hud)
	_panels = Control.new()
	_panels.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panels.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panels)
	_refresh()


## Version 0.1 kept the hut's game and best result in "game" and "best".
func _migrate_prefs() -> void:
	if _prefs.has_section("game") or _prefs.has_section("best"):
		for pair in [["game", "save", "save"], ["game", "view", "view"], ["best", "halves", "halves"], ["best", "secs", "secs_best"]]:
			if _prefs.has_section_key(pair[0], pair[1]):
				_prefs.set_value("room_hut", pair[2], _prefs.get_value(pair[0], pair[1]))
		for section in ["game", "best"]:
			if _prefs.has_section(section):
				_prefs.erase_section(section)
		_prefs.save(SAVE_PATH)


func _layer(rect: Rect2, draw_it: Callable) -> Control:
	var layer := Control.new()
	layer.position = rect.position
	layer.size = rect.size
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layer.draw.connect(draw_it)
	add_child(layer)
	return layer


func _process(delta: float) -> void:
	_time += delta
	art.t = _time
	if mode == "load":
		if link.ready():
			_boot()
		elif link.failure() != "" and not _panel_open:
			var box := _open_panel()
			_label(box, tr("ui.failed"), 22)
			_label(box, link.failure(), 14, Color(1, 1, 1, 0.5))
		_hud.queue_redraw()
		return
	if mode == "play" and not _panel_open:
		seconds += delta
		if int(seconds) > _sent:
			_sent = int(seconds)
			link.send("time %d" % _sent)
			_hud.queue_redraw()
			if _sent % 5 == 0:
				_save()
	_lightning(delta)
	if _message_left > 0.0:
		_message_left -= delta
		if _message_left <= 0.0:
			_over.queue_redraw()
	if _glint > 0.0:
		_glint -= delta
		_over.queue_redraw()
	if mode != "title" and Views.animated(view):
		_scene.queue_redraw()


## The lighthouse's storm: every few seconds a flash, then thunder.
func _lightning(delta: float) -> void:
	var before := art.flash
	if room == "light" and mode in ["play", "ending"]:
		if storm:
			_next_flash -= delta
			if _next_flash <= 0.0:
				strike()
		if _flash_left > 0.0:
			_flash_left -= delta
			# Two quick flashes, then a slow fade.
			var age := 1.7 - _flash_left
			art.flash = 1.0 if age < 0.12 else (0.35 if age < 0.22 else clampf(_flash_left / 1.4, 0.0, 1.0))
		else:
			art.flash = 0.0
	else:
		art.flash = 0.0
	if art.flash != before:
		(_light.material as ShaderMaterial).set_shader_parameter("flash", art.flash)


## Lightning now (also called by tests).
func strike() -> void:
	_flash_left = 1.7
	_next_flash = randf_range(6.0, 10.0)
	get_tree().create_timer(randf_range(0.5, 1.6)).timeout.connect(func() -> void:
		if room == "light" and mode == "play":
			sound.play("thunder", randf_range(-6.0, 0.0), 0.1))


func _boot() -> void:
	rooms = link.send("rooms").get("rooms", [])
	_show_title()


func _key(section: String) -> String:
	return "room_" + section


func _has_game(id: String) -> bool:
	return str(_prefs.get_value(_key(id), "save", "")) != ""


# --- Drawing -----------------------------------------------------------------

func _refresh() -> void:
	# The hotspots of some views depend on the clues.
	art.st = st
	art.clues = clues
	var lights := Views.lights(view, st) if mode != "title" and mode != "load" else {"dark": 0.0, "warm": [], "cold": Vector4.ZERO}
	var material: ShaderMaterial = _light.material
	material.set_shader_parameter("dark", lights["dark"])
	var warm: Array = lights["warm"]
	for i in range(4):
		material.set_shader_parameter("warm%d" % i, warm[i] if i < warm.size() else Vector4.ZERO)
	material.set_shader_parameter("cold", lights["cold"])
	material.set_shader_parameter("tint", lights.get("tint", Vector3.ZERO))
	_scene.queue_redraw()
	_over.queue_redraw()
	_hud.queue_redraw()
	_ambience()
	if OS.has_feature("web"):
		JavaScriptBridge.eval("if(window.hut){window.hut.view=%s;window.hut.mode=%s;window.hut.room=%s;}" % [JSON.stringify(view), JSON.stringify(mode), JSON.stringify(room)])


## Which atmospheres belong to this place.
func _ambience() -> void:
	var levels := {}
	if mode == "title":
		levels["amb_wind"] = 0.35
	elif mode != "load" and room == "light":
		var floor_of := view
		while not floor_of in LightViews.FLOORS and LightViews.PARENT.has(floor_of):
			floor_of = LightViews.PARENT[floor_of]
		levels["amb_sea"] = 0.55 + 0.15 * LightViews.FLOORS.find(floor_of)
		if view == "L2":
			levels["amb_fire"] = 0.25
	elif mode != "load" and room == "beach":
		levels["amb_sea"] = 0.3
	elif mode != "load" and room == "train":
		levels["amb_wind"] = 0.3
		levels["amb_tick"] = 0.5
	elif mode != "load" and room == "alch":
		levels["amb_fire"] = 0.6 if view in ["A1", "furnace"] else 0.25
	elif mode != "load" and room == "orangery":
		levels["amb_wind"] = 0.12
	elif mode != "load" and room == "theatre":
		levels["amb_static"] = 0.05 if st.get("mix", "") != "" else 0.0
	elif mode != "load" and room == "chess":
		levels["amb_fire"] = 0.7 if view == "C1" else 0.3
		levels["amb_tick"] = 1.0 if view == "cclock" else 0.35
	elif mode != "load" and room == "obs":
		var up: bool = Views.reachable(view, {"flags": []}) == false
		levels["amb_wind"] = 0.3 if up else 0.14
		if view in ["S1", "clocks", "door"]:
			levels["amb_tick"] = 0.6 if view == "S1" else 1.0
	elif mode != "load":
		var inner: bool = not (view in Views.MAIN_ROOM or view == "lock")
		levels["amb_wind"] = 0.55 if inner else 0.85
		if _flag("stove_lit"):
			levels["amb_fire"] = 0.8 if view == "A" else (0.15 if inner else 0.4)
		if view == "clock":
			levels["amb_tick"] = 1.0
		elif view == "E":
			levels["amb_tick"] = 0.45
		if view == "radio" and st.get("power", false) and not _flag("tuned"):
			levels["amb_static"] = 0.8
	sound.ambience(levels)


func _draw_scene() -> void:
	art.ci = _scene
	art.st = st
	art.clues = clues
	if mode == "load" or mode == "title":
		art.r(0, 0, 960, SCENE_H, Color("0d0907"))
		if mode == "title":
			for k in range(6):
				art.c(480, 60, 180.0 + k * 70.0, Color(1, 0.6, 0.23, 0.012))
		return
	art.draw_view(view)


func _rect(rect: Rect2, dir: int) -> void:
	art.arrow_btn(rect.position.x, rect.position.y, rect.size.x, rect.size.y, dir)


func _draw_over() -> void:
	if mode != "play" and mode != "ending":
		return
	art.ci = _over
	if mode == "play":
		if Views.beside(view, 1) != "":
			_rect(LEFT_RECT, 2)
			_rect(RIGHT_RECT, 3)
		if Views.back(view) != "":
			_rect(BACK_RECT, 1)
		if Views.up(view, st) != "":
			_rect(UP_RECT, 0)
		art.rr(MENU_RECT.position.x, MENU_RECT.position.y, MENU_RECT.size.x, MENU_RECT.size.y, Color(0, 0, 0, 0.35), 10)
		for k in range(3):
			art.rr(MENU_RECT.position.x + 11, MENU_RECT.position.y + 13 + k * 8, 22, 3, Art.CREAM, 1)
	if _glint > 0.0:
		var alpha := clampf(_glint / 0.5, 0.0, 1.0)
		for spot in _spots():
			if str(spot[2]).begins_with("cmd:"):
				continue
			var centre: Vector2 = spot[1].get_center()
			art.c(centre.x, centre.y, 9, Color(1, 0.95, 0.75, 0.22 * alpha))
			art.c(centre.x, centre.y, 3.5, Color(1, 0.97, 0.85, 0.9 * alpha))
	if _message_left > 0.0 and _message != "":
		var size := 20
		var width := art.font.get_string_size(_message, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		while width > 780.0 and size > 13:
			size -= 1
			width = art.font.get_string_size(_message, HORIZONTAL_ALIGNMENT_LEFT, -1, size).x
		var alpha2 := clampf(_message_left / 0.4, 0.0, 1.0)
		art.rr(480 - width / 2 - 20, 422, width + 40, 40, Color(0.05, 0.035, 0.03, 0.86 * alpha2), 12)
		art.txt(480, 449, _message, size, Color(Art.CREAM, alpha2))


func _draw_hud() -> void:
	art.ci = _hud
	art.st = st
	art.clues = clues
	if mode == "title":
		art.r(0, SCENE_H, 960, 540 - SCENE_H, Color("0d0907"))
		return
	art.r(0, SCENE_H, 960, 540 - SCENE_H, Color("0d0907"))
	if mode == "load":
		art.txt(480, 280, tr("ui.loading"), 22, Art.CREAM)
		return
	# Time.
	art.ring(34, 506, 11, Art.CREAM, 2)
	art.ln(34, 506, 34, 498, Art.CREAM, 2)
	art.ln(34, 506, 40, 508, Art.CREAM, 2)
	art.txt(54, 515, _clock_text(int(seconds)), 24, Art.CREAM, false)
	# Inventory.
	var inv: Array = st.get("inv", [])
	for i in range(SLOTS):
		var slot := _slot_rect(i)
		var held: bool = i < inv.size() and inv[i] == selected
		if held:
			art.rr(slot.position.x - 3, slot.position.y - 3, slot.size.x + 6, slot.size.y + 6, Art.AMBER, 10)
		art.rr(slot.position.x, slot.position.y, slot.size.x, slot.size.y, Color("3b2a1e") if held else Color("241810"), 8)
		if i < inv.size():
			art.item(inv[i], slot.get_center().x, slot.get_center().y, 1.0)
	art.home()
	# Hint.
	art.rr(HINT_RECT.position.x, HINT_RECT.position.y, HINT_RECT.size.x, HINT_RECT.size.y, Color("241810"), 22)
	art.txt(HINT_RECT.get_center().x, HINT_RECT.get_center().y + 7, tr("ui.hint"), 20, Art.CREAM)


func _slot_rect(i: int) -> Rect2:
	return Rect2(150 + i * 66, 480, 56, 52)


func _clock_text(secs: int) -> String:
	return "%d:%02d" % [secs / 60, secs % 60]


# --- Playing -------------------------------------------------------------------

func _flag(name: String) -> bool:
	return st.get("flags", []).has(name)


func _spots() -> Array:
	return Views.spots(view, st, art)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tap(event.position)


## A tap at a point of the 960 x 540 screen.
func tap(pos: Vector2) -> void:
	if mode != "play" or _panel_open:
		return
	if pos.y >= SCENE_H:
		var inv: Array = st.get("inv", [])
		for i in range(mini(SLOTS, inv.size())):
			if _slot_rect(i).has_point(pos):
				tap_item(str(inv[i]))
				return
		if HINT_RECT.has_point(pos):
			sound.play("tap")
			_show_hint()
		return
	if MENU_RECT.has_point(pos):
		sound.play("tap")
		_show_menu()
		return
	if Views.beside(view, 1) != "":
		if LEFT_RECT.has_point(pos):
			go_view(Views.beside(view, -1))
			return
		if RIGHT_RECT.has_point(pos):
			go_view(Views.beside(view, 1))
			return
	if Views.back(view) != "" and BACK_RECT.has_point(pos):
		go_view(Views.back(view))
		return
	if Views.up(view, st) != "" and UP_RECT.has_point(pos):
		go_view(Views.up(view, st))
		return
	for spot in _spots():
		if spot[1].has_point(pos):
			_hit(spot)
			return
	_glint = 0.9


## A tap on a carried item: picks it, puts it back, or, with another item
## in hand, tries the two together.
func tap_item(item: String) -> void:
	if selected != "" and selected != item:
		var answer := link.send("use %s %s" % [selected, item])
		if answer.get("ok", false) and not str(answer.get("msg", "")).ends_with("no_use"):
			selected = ""
			_apply(answer, "use")
			return
	select_item("" if selected == item else item)


func select_item(item: String) -> void:
	selected = item
	if item != "":
		sound.play("tap")
		_say(tr("item." + item))
	_hud.queue_redraw()


func go_view(next: String) -> void:
	if next == "":
		return
	sound.play("tap" if Views.is_closeup(next) or Views.is_closeup(view) else "step")
	view = next
	_refresh()


## Taps the hotspot with this id in the current view; false if there is none.
func tap_spot(id: String) -> bool:
	for spot in _spots():
		if spot[0] == id:
			_hit(spot)
			return true
	return false


func _hit(spot: Array) -> void:
	var id: String = spot[0]
	var action: String = spot[2]
	if view in ["B", "C"] and not _flag("lamp_lit"):
		_say(tr("msg.too_dark"))
		return
	if action.begins_with("cmd:"):
		_apply(link.send(action.substr(4)), action.substr(4))
	elif selected != "":
		var answer := link.send("use %s %s" % [selected, id])
		selected = ""
		if action.begins_with("go:") and str(answer.get("msg", "")).ends_with("no_use"):
			go_view(action.substr(3))
		else:
			_apply(answer, "use")
	elif action.begins_with("go:"):
		go_view(action.substr(3))
	else:
		_apply(link.send("tap " + id), "tap")


func _solved_count(state: Dictionary) -> int:
	var n := 0
	for s in state.get("solved", []):
		n += 1 if s else 0
	return n


func _apply(answer: Dictionary, command: String = "") -> void:
	if not answer.get("ok", false):
		push_warning("room: %s" % answer.get("error", "?"))
		return
	var before := st
	st = answer["state"]
	var msg: String = answer.get("msg", "")
	if msg != "":
		_say(tr(msg))
	if selected != "" and not st.get("inv", []).has(selected):
		selected = ""
	_sounds(before, msg, command)
	if msg == "msg.cup_open":
		get_tree().create_timer(1.0).timeout.connect(func() -> void:
			if view == "lock" and mode == "play":
				go_view("C"))
	if st.get("done", false) and mode == "play":
		mode = "ending"
		link.send("time %d" % int(seconds))
		st = link.send("state").get("state", st)
		_finish()
		get_tree().create_timer(3.2 if room == "light" else 2.6).timeout.connect(_show_end)
	else:
		_save()
	_refresh()


func _sounds(before: Dictionary, msg: String, command: String) -> void:
	var word := command.get_slice(" ", 0)
	if st.get("done", false) and not before.get("done", false):
		if room == "light":
			sound.play("match")
		get_tree().create_timer(0.7).timeout.connect(func() -> void: sound.play("win"))
		return
	if msg in WRONG:
		sound.play("thud")
	elif msg in UNLOCKS:
		sound.play("unlock")
	elif msg in ["msg.lamp_lit", "msg.stove_lit"]:
		sound.play("match")
	elif msg == "msg.clock_open":
		sound.play("cuckoo")
	elif msg in ["msg.power", "omsg.power"]:
		sound.play("hum")
	elif msg == "omsg.exposed":
		sound.play("unlock")
	elif word == "mix":
		sound.play("pour")
	elif word == "bellows":
		sound.play("step")
	elif word == "dome":
		sound.play("gear")
	elif msg in ["lmsg.wind", "lmsg.gear_on", "lmsg.gear_off"]:
		sound.play("gear")
	elif msg in ["msg.bucket_melt", "lmsg.oil_in", "gmsg.can_full", "gmsg.bloomed", "gmsg.grown", "gmsg.fountain"] or word == "oil":
		sound.play("pour")
	elif word == "key":
		sound.play("beep_l" if command.ends_with("l") else "beep_s", 0.0, 0.0)
	elif word in ["wire", "valve"]:
		sound.play("gear")
	elif word in ["dial", "clock", "baro", "tune", "pin", "lamp", "planet", "weight", "ra", "dec", "plani",
			"turn", "flip", "mask", "bulb", "king", "pull", "seat", "empty"]:
		sound.play("tick")
	elif st.get("inv", []).size() > before.get("inv", []).size():
		sound.play("pick")
	else:
		sound.play("tap")
	if _solved_count(st) > _solved_count(before):
		get_tree().create_timer(0.35).timeout.connect(func() -> void: sound.play("chime"))


func _say(text: String) -> void:
	_message = text
	_message_left = clampf(1.6 + text.length() * 0.05, 2.5, 6.0)
	_over.queue_redraw()


func _save() -> void:
	if mode != "play":
		return
	_prefs.set_value(_key(room), "save", link.send("save").get("save", ""))
	_prefs.set_value(_key(room), "view", view)
	_prefs.set_value(_key(room), "secs", int(seconds))
	_prefs.save(SAVE_PATH)


## The room is solved: the best result is kept, the saved game is gone.
func _finish() -> void:
	var halves := int(st.get("halves", 2))
	var secs := int(st.get("secs", 0))
	var best_halves := int(_prefs.get_value(_key(room), "halves", 0))
	var best_secs := int(_prefs.get_value(_key(room), "secs_best", 0))
	var better := halves > best_halves or (halves == best_halves and secs < best_secs)
	_prefs.set_value(_key(room), "new", better)
	if better:
		_prefs.set_value(_key(room), "halves", halves)
		_prefs.set_value(_key(room), "secs_best", secs)
	_prefs.set_value(_key(room), "save", "")
	_prefs.save(SAVE_PATH)


func _best(id: String) -> Array:
	var halves := int(_prefs.get_value(_key(id), "halves", 0))
	return [halves, int(_prefs.get_value(_key(id), "secs_best", 0))]


func _enter(id: String) -> void:
	room = id
	st = link.send("room " + id).get("state", {})
	clues = link.send("clues")
	selected = ""
	_message_left = 0.0
	_next_flash = 4.0


## A room from its beginning.
func start_new(id: String = "") -> void:
	_enter(id if id != "" else room)
	seconds = 0.0
	_sent = 0
	view = Views.first(room)
	mode = "play"
	_refresh()
	_show_intro()


## A room from its saved game.
func continue_game(id: String = "") -> void:
	_enter(id if id != "" else room)
	var answer := link.send("load " + str(_prefs.get_value(_key(room), "save", "")))
	if not answer.get("ok", false):
		start_new(room)
		return
	st = answer["state"]
	seconds = float(st.get("secs", 0))
	_sent = int(seconds)
	var saved_view: String = _prefs.get_value(_key(room), "view", "")
	view = saved_view if Views.reachable(saved_view, st) and not Views.spots(saved_view, st, art).is_empty() else Views.first(room)
	mode = "play"
	_close_panel()
	_refresh()


# --- Panels --------------------------------------------------------------------

func _make_theme() -> Theme:
	var th := Theme.new()
	th.default_font_size = 20
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color(0.085, 0.058, 0.045, 0.95)
	panel.border_color = Color(Art.BRASS, 0.55)
	panel.set_border_width_all(2)
	panel.set_corner_radius_all(16)
	panel.set_content_margin_all(26)
	th.set_stylebox("panel", "PanelContainer", panel)
	for state in ["normal", "hover", "pressed", "disabled", "focus"]:
		var box := StyleBoxFlat.new()
		box.bg_color = {"hover": Color("5a3d24"), "pressed": Color("2a1c12"), "disabled": Color("2a1c12")}.get(state, Color("46301e"))
		box.set_corner_radius_all(12)
		box.content_margin_left = 22
		box.content_margin_right = 22
		box.content_margin_top = 10
		box.content_margin_bottom = 10
		if state == "focus":
			box.bg_color = Color(0, 0, 0, 0)
		th.set_stylebox(state, "Button", box)
	th.set_color("font_color", "Button", Art.CREAM)
	th.set_color("font_hover_color", "Button", Color.WHITE)
	th.set_color("font_pressed_color", "Button", Art.AMBER)
	th.set_color("font_disabled_color", "Button", Art.AMBER)
	th.set_color("font_color", "Label", Art.CREAM)
	return th


func _close_panel() -> void:
	for child in _panels.get_children():
		_panels.remove_child(child)
		child.queue_free()
	_panel_open = false


## Opens an empty panel in the middle of the screen; returns its column.
func _open_panel(width: float = 560.0, dim: float = 0.45) -> VBoxContainer:
	_close_panel()
	_panel_open = true
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, dim)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panels.add_child(shade)
	var centre := CenterContainer.new()
	centre.set_anchors_preset(Control.PRESET_FULL_RECT)
	_panels.add_child(centre)
	var panel := PanelContainer.new()
	centre.add_child(panel)
	var box := VBoxContainer.new()
	box.custom_minimum_size.x = width
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)
	return box


func _label(box: Container, text: String, size: int = 20, colour: Color = Art.CREAM, wrap: bool = true) -> Label:
	var label := Label.new()
	label.text = text
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	box.add_child(label)
	return label


func _button(box: Container, text: String, pressed: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(func() -> void:
		sound.play("tap")
		pressed.call())
	box.add_child(button)
	return button


func _row(box: Container, gap: int = 10) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", gap)
	box.add_child(row)
	return row


## A small picture drawn with Art; `paint` gets the control.
func _picture(box: Container, size: Vector2, paint: Callable, moving: bool = false) -> Control:
	var picture := Control.new()
	picture.custom_minimum_size = size
	picture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	picture.clip_contents = true
	picture.draw.connect(func() -> void:
		art.ci = picture
		paint.call(picture)
		art.home())
	if moving:
		var clock := Timer.new()
		clock.wait_time = 0.05
		clock.autostart = true
		clock.timeout.connect(picture.queue_redraw)
		picture.add_child(clock)
	box.add_child(picture)
	return picture


func _stars(box: Container, halves: int, rad: float) -> void:
	_picture(box, Vector2(rad * 7.2, rad * 2.2), func(p: Control) -> void:
		for i in range(3):
			art.star(p.size.x / 2 + (i - 1) * rad * 2.3, rad * 1.15, rad, clampi(halves - i * 2, 0, 2)))


func _languages(box: Container, again: Callable) -> void:
	var row := _row(box)
	for lang in LANGS:
		var button := _button(row, lang.to_upper(), func() -> void:
			TranslationServer.set_locale(lang)
			_prefs.set_value("prefs", "lang", lang)
			_prefs.save(SAVE_PATH)
			again.call())
		button.add_theme_font_size_override("font_size", 16)
		button.disabled = TranslationServer.get_locale().begins_with(lang)
	var mute := _button(row, tr("ui.sound_off") if sound.muted else tr("ui.sound_on"), func() -> void:
		sound.set_muted(not sound.muted)
		_prefs.set_value("prefs", "muted", sound.muted)
		_prefs.save(SAVE_PATH)
		again.call())
	mute.add_theme_font_size_override("font_size", 16)


## The catalogue: a card per room, three to a row.
func _show_title() -> void:
	mode = "title"
	_refresh()
	_close_panel()
	_panel_open = true
	var page := VBoxContainer.new()
	page.set_anchors_preset(Control.PRESET_FULL_RECT)
	page.alignment = BoxContainer.ALIGNMENT_CENTER
	page.add_theme_constant_override("separation", 6)
	_panels.add_child(page)
	page.add_theme_constant_override("separation", 5)
	_label(page, "LOCKED IN", 30, Art.AMBER, false)
	var cards: HBoxContainer = null
	for i in range(rooms.size()):
		if i % 3 == 0:
			cards = _row(page, 10)
		_card(cards, rooms[i])
	_languages(page, _show_title)
	var window := DisplayServer.window_get_size()
	if window.y > window.x:
		_label(page, tr("ui.rotate"), 18, Art.AMBER)


## One room: picture on the left, name, difficulty and best result on the
## right, the buttons below.
func _card(row: Container, entry: Dictionary) -> void:
	var id: String = entry["id"]
	var card := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.085, 0.058, 0.045, 0.96)
	style.border_color = Color(Art.BRASS, 0.5)
	style.set_border_width_all(2)
	style.set_corner_radius_all(14)
	style.set_content_margin_all(7)
	card.add_theme_stylebox_override("panel", style)
	row.add_child(card)
	var box := VBoxContainer.new()
	box.custom_minimum_size.x = 278
	box.add_theme_constant_override("separation", 4)
	card.add_child(box)
	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 9)
	box.add_child(top)
	_picture(top, Vector2(96, 66), func(p: Control) -> void: art.card(id, p.size.x, p.size.y), true)
	var facts := VBoxContainer.new()
	facts.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	facts.add_theme_constant_override("separation", 0)
	top.add_child(facts)
	var title: String = TITLES.get(id, id)
	if title.length() > 16:
		# A long name takes two lines instead of being cut.
		var long_name := _label(facts, title, 15, Art.AMBER, true)
		long_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		long_name.add_theme_constant_override("line_spacing", -3)
	else:
		_fit(_label(facts, title, 18, Art.AMBER, false))
	var level := int(entry.get("difficulty", 1))
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 6)
	facts.add_child(line)
	_picture(line, Vector2(72, 24), func(_p: Control) -> void:
		for i in range(3):
			art.padlock(11.0 + i * 24.0, 11, i < level))
	_fit(_label(line, "%s · %s" % [tr("diff.%d" % level), tr("ui.minutes") % int(entry.get("minutes", 30))], 13, Art.CREAM, false))
	var result := HBoxContainer.new()
	result.add_theme_constant_override("separation", 6)
	facts.add_child(result)
	var best := _best(id)
	_stars(result, best[0], 8)
	_fit(_label(result, _clock_text(best[1]) if best[0] > 0 else "", 14, Color(Art.CREAM, 0.8), false))
	var buttons := HBoxContainer.new()
	buttons.add_theme_constant_override("separation", 6)
	box.add_child(buttons)
	if _has_game(id):
		_slim(_button(buttons, "%s  %s" % [tr("ui.continue"), _clock_text(int(_prefs.get_value(_key(id), "secs", 0)))], func() -> void: continue_game(id)), 15, 2.4)
		_slim(_button(buttons, tr("ui.new_short"), func() -> void: start_new(id)), 13, 1.0)
	else:
		_slim(_button(buttons, tr("ui.play"), func() -> void: start_new(id)), 15, 1.0)


## A low button that shares its row and never widens the card.
func _slim(button: Button, size: int, share: float) -> void:
	button.add_theme_font_size_override("font_size", size)
	button.clip_text = true
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.size_flags_stretch_ratio = share
	for state in ["normal", "hover", "pressed"]:
		var slim: StyleBoxFlat = theme.get_stylebox(state, "Button").duplicate()
		slim.content_margin_top = 2
		slim.content_margin_bottom = 2
		slim.content_margin_left = 6
		slim.content_margin_right = 6
		button.add_theme_stylebox_override(state, slim)


## A label that is cut short with "…" instead of widening its card.
func _fit(label: Label) -> void:
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.clip_text = true
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _show_intro() -> void:
	var box := _open_panel(640.0, 0.55)
	_label(box, TITLES.get(room, ""), 28, Art.AMBER)
	for i in [1, 2, 3]:
		_label(box, tr("%sintro.%d" % [PREFIX[room], i]), 20)
	_label(box, tr("intro.how"), 16, Color(Art.CREAM, 0.65))
	_button(box, tr("ui.start"), _close_panel)


func _show_menu() -> void:
	var box := _open_panel(480.0)
	_label(box, tr("ui.paused"), 28, Art.AMBER)
	_button(box, tr("ui.resume"), _close_panel)
	_button(box, tr("ui.restart"), func() -> void:
		var ask := _open_panel(460.0)
		_label(ask, tr("ui.confirm_restart"), 22)
		var row := _row(ask)
		_button(row, tr("ui.yes"), func() -> void: start_new(room))
		_button(row, tr("ui.no"), _show_menu))
	_button(box, tr("ui.to_title"), func() -> void:
		_save()
		_show_title())
	_languages(box, _show_menu)


func _show_hint() -> void:
	_hint_panel(link.send("hintinfo " + view))


func _hint_panel(info: Dictionary) -> void:
	var puzzle := int(info.get("puzzle", 1))
	var level := int(info.get("level", 0))
	st = info.get("state", st)
	var box := _open_panel(620.0)
	_label(box, tr("hint.title"), 28, Art.AMBER)
	if level == 0:
		_label(box, tr("hint.ask"), 20)
	for i in range(1, level + 1):
		_label(box, tr("%shint.%d.%d" % [PREFIX[room], puzzle, i]), 20, Art.CREAM if i == level else Color(Art.CREAM, 0.55))
	if level >= 3:
		_label(box, tr("hint.last"), 16, Color(Art.CREAM, 0.55))
	var row := _row(box)
	if level < 3:
		_button(row, tr("hint.show") if level == 0 else tr("hint.more"), func() -> void:
			_hint_panel(link.send("hint " + view))
			_save())
	_button(row, tr("ui.close"), func() -> void:
		_close_panel()
		_refresh())


func _show_end() -> void:
	if mode != "ending":
		return
	mode = "end"
	_refresh()
	var box := _open_panel(600.0, 0.4)
	_label(box, tr("%send.title" % PREFIX[room]), 34, Art.AMBER)
	_label(box, tr("%send.text" % PREFIX[room]), 19)
	_stars(box, int(st.get("halves", 2)), 30)
	var hints := 0
	for h in st.get("hints", []):
		hints += int(h)
	_label(box, "%s     %s" % [tr("end.time") % _clock_text(int(st.get("secs", 0))), tr("end.hints") % hints], 22)
	if _prefs.get_value(_key(room), "new", false):
		_label(box, tr("end.best"), 20, Art.AMBER)
	_button(box, tr("end.again"), _show_title)
