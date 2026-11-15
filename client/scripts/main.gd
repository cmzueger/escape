## Hut 2847: the game screen. The rules live in Rust (RoomLink); this script
## shows the views (Art, Views), the bar with time, inventory and hints, and
## the panels (title, story, hints, menu, end).
extends Control

const SAVE_PATH := "user://hut2847.cfg"
const SCENE_H := 472.0
const LANGS := ["en", "de", "fr", "it", "es"]
const SLOTS := 6
const HINT_RECT := Rect2(800, 484, 136, 44)
const MENU_RECT := Rect2(908, 8, 44, 44)
const LEFT_RECT := Rect2(6, 200, 52, 72)
const RIGHT_RECT := Rect2(902, 200, 52, 72)
const BACK_RECT := Rect2(10, 414, 100, 52)

var link := RoomLink.new()
var art := Art.new()
var st: Dictionary = {}
var clues: Dictionary = {}
var view := "A"
var selected := ""
## load (rules not there yet), title, play, ending (solved, before the end panel), end
var mode := "load"
var seconds := 0.0

var _time := 0.0
var _sent := 0
var _message := ""
var _message_left := 0.0
var _glint := 0.0
var _prefs := ConfigFile.new()
var _scene: Control
var _light: ColorRect
var _over: Control
var _hud: Control
var _panels: Control
var _panel_open := false


func _ready() -> void:
	_prefs.load(SAVE_PATH)
	var lang: String = _prefs.get_value("prefs", "lang", OS.get_locale_language())
	TranslationServer.set_locale(lang if lang in LANGS else "en")
	theme = _make_theme()
	art.font = ThemeDB.fallback_font
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
	if _message_left > 0.0:
		_message_left -= delta
		if _message_left <= 0.0:
			_over.queue_redraw()
	if _glint > 0.0:
		_glint -= delta
		_over.queue_redraw()
	if Views.animated(_shown_view()):
		_scene.queue_redraw()


func _boot() -> void:
	clues = link.send("clues")
	var saved: String = _prefs.get_value("game", "save", "")
	var answer := {}
	if saved != "":
		answer = link.send("load " + saved)
	if not answer.get("ok", false):
		answer = link.send("new")
	st = answer.get("state", {})
	_show_title()


func _shown_view() -> String:
	return view if mode in ["play", "ending", "end"] else "A"


func _has_game() -> bool:
	return not st.get("done", false) and (int(st.get("secs", 0)) > 0 or not st.get("flags", []).is_empty())


# --- Drawing -----------------------------------------------------------------

func _refresh() -> void:
	var lights := Views.lights(_shown_view(), st)
	var material: ShaderMaterial = _light.material
	material.set_shader_parameter("dark", lights["dark"])
	var warm: Array = lights["warm"]
	for i in range(4):
		material.set_shader_parameter("warm%d" % i, warm[i] if i < warm.size() else Vector4.ZERO)
	material.set_shader_parameter("cold", lights["cold"])
	_scene.queue_redraw()
	_over.queue_redraw()
	_hud.queue_redraw()
	if OS.has_feature("web"):
		JavaScriptBridge.eval("if(window.hut){window.hut.view=%s;window.hut.mode=%s;}" % [JSON.stringify(view), JSON.stringify(mode)])


func _draw_scene() -> void:
	art.ci = _scene
	art.st = st
	art.clues = clues
	if mode == "load":
		art.r(0, 0, 960, SCENE_H, Color("0d0907"))
		return
	art.draw_view(_shown_view())


func _draw_over() -> void:
	if mode != "play" and mode != "ending":
		return
	art.ci = _over
	if mode == "play":
		if not Views.is_closeup(view):
			art.arrow_btn(LEFT_RECT.position.x, LEFT_RECT.position.y, LEFT_RECT.size.x, LEFT_RECT.size.y, 2)
			art.arrow_btn(RIGHT_RECT.position.x, RIGHT_RECT.position.y, RIGHT_RECT.size.x, RIGHT_RECT.size.y, 3)
		if Views.back(view) != "":
			art.arrow_btn(BACK_RECT.position.x, BACK_RECT.position.y, BACK_RECT.size.x, BACK_RECT.size.y, 1)
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
	art.r(0, SCENE_H, 960, 540 - SCENE_H, Color("0d0907"))
	if mode == "load":
		art.txt(480, 280, tr("ui.loading"), 22, Art.CREAM)
		return
	if mode == "title":
		return
	# Time.
	art.ring(40, 506, 11, Art.CREAM, 2)
	art.ln(40, 506, 40, 498, Art.CREAM, 2)
	art.ln(40, 506, 46, 508, Art.CREAM, 2)
	art.txt(62, 515, _clock_text(int(seconds)), 24, Art.CREAM, false)
	# Inventory.
	var inv: Array = st.get("inv", [])
	for i in range(SLOTS):
		var slot := _slot_rect(i)
		var held: bool = i < inv.size() and inv[i] == selected
		if held:
			art.rr(slot.position.x - 3, slot.position.y - 3, slot.size.x + 6, slot.size.y + 6, Art.AMBER, 10)
		art.rr(slot.position.x, slot.position.y, slot.size.x, slot.size.y, Color("3b2a1e") if held else Color("241810"), 8)
		if i < inv.size():
			art.item(inv[i], slot.get_center().x, slot.get_center().y, 1.05)
	art.home()
	# Hint.
	art.rr(HINT_RECT.position.x, HINT_RECT.position.y, HINT_RECT.size.x, HINT_RECT.size.y, Color("241810"), 22)
	art.txt(HINT_RECT.get_center().x, HINT_RECT.get_center().y + 7, tr("ui.hint"), 20, Art.CREAM)


func _slot_rect(i: int) -> Rect2:
	return Rect2(196 + i * 74, 480, 62, 52)


func _clock_text(secs: int) -> String:
	return "%d:%02d" % [secs / 60, secs % 60]


# --- Playing -------------------------------------------------------------------

func _flag(name: String) -> bool:
	return st.get("flags", []).has(name)


func _spots() -> Array:
	return Views.spots(view, st)


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
				select_item("" if selected == inv[i] else str(inv[i]))
				return
		if HINT_RECT.has_point(pos):
			_show_hint()
		return
	if MENU_RECT.has_point(pos):
		_show_menu()
		return
	if not Views.is_closeup(view):
		if LEFT_RECT.has_point(pos):
			go_view(Views.beside(view, -1))
			return
		if RIGHT_RECT.has_point(pos):
			go_view(Views.beside(view, 1))
			return
	if Views.back(view) != "" and BACK_RECT.has_point(pos):
		go_view(Views.back(view))
		return
	for spot in _spots():
		if spot[1].has_point(pos):
			_hit(spot)
			return
	_glint = 0.9


func select_item(item: String) -> void:
	selected = item
	if item != "":
		_say(tr("item." + item))
	_hud.queue_redraw()


func go_view(next: String) -> void:
	if next == "":
		return
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
		_apply(link.send(action.substr(4)))
	elif selected != "":
		var answer := link.send("use %s %s" % [selected, id])
		selected = ""
		if action.begins_with("go:") and answer.get("msg", "") == "msg.no_use":
			go_view(action.substr(3))
		else:
			_apply(answer)
	elif action.begins_with("go:"):
		go_view(action.substr(3))
	else:
		_apply(link.send("tap " + id))


func _apply(answer: Dictionary) -> void:
	if not answer.get("ok", false):
		push_warning("room: %s" % answer.get("error", "?"))
		return
	st = answer["state"]
	var msg: String = answer.get("msg", "")
	if msg != "":
		_say(tr(msg))
	if selected != "" and not st.get("inv", []).has(selected):
		selected = ""
	if msg == "msg.cup_open":
		get_tree().create_timer(1.0).timeout.connect(func() -> void:
			if view == "lock" and mode == "play":
				go_view("C"))
	if st.get("done", false) and mode == "play":
		mode = "ending"
		link.send("time %d" % int(seconds))
		st = link.send("state").get("state", st)
		_finish()
		get_tree().create_timer(2.6).timeout.connect(_show_end)
	else:
		_save()
	_refresh()


func _say(text: String) -> void:
	_message = text
	_message_left = clampf(1.6 + text.length() * 0.05, 2.5, 6.0)
	_over.queue_redraw()


func _save() -> void:
	if mode != "play":
		return
	_prefs.set_value("game", "save", link.send("save").get("save", ""))
	_prefs.set_value("game", "view", view)
	_prefs.save(SAVE_PATH)


## The game is won: the best result is kept, the saved game is gone.
func _finish() -> void:
	var halves := int(st.get("halves", 2))
	var secs := int(st.get("secs", 0))
	var best_halves := int(_prefs.get_value("best", "halves", 0))
	var best_secs := int(_prefs.get_value("best", "secs", 0))
	var better := halves > best_halves or (halves == best_halves and secs < best_secs)
	_prefs.set_value("best", "new", better)
	if better:
		_prefs.set_value("best", "halves", halves)
		_prefs.set_value("best", "secs", secs)
	_prefs.set_value("game", "save", "")
	_prefs.save(SAVE_PATH)


func start_new() -> void:
	st = link.send("new").get("state", {})
	seconds = 0.0
	_sent = 0
	view = "A"
	selected = ""
	_message_left = 0.0
	mode = "play"
	_refresh()
	_show_intro()


func continue_game() -> void:
	seconds = float(st.get("secs", 0))
	_sent = int(seconds)
	var saved_view: String = _prefs.get_value("game", "view", "A")
	var beyond: bool = not (saved_view in Views.MAIN_ROOM or saved_view == "lock")
	view = "A" if Views.spots(saved_view, st).is_empty() or (beyond and not _flag("door2_open")) else saved_view
	selected = ""
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


func _label(box: Container, text: String, size: int = 20, colour: Color = Art.CREAM) -> Label:
	var label := Label.new()
	label.text = text
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
	button.pressed.connect(pressed)
	box.add_child(button)
	return button


func _row(box: Container) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	box.add_child(row)
	return row


func _stars(box: Container, halves: int, rad: float) -> void:
	var stars := Control.new()
	stars.custom_minimum_size = Vector2(rad * 7.2, rad * 2.2)
	stars.draw.connect(func() -> void:
		art.ci = stars
		for i in range(3):
			art.star(stars.size.x / 2 + (i - 1) * rad * 2.3, rad * 1.15, rad, clampi(halves - i * 2, 0, 2)))
	box.add_child(stars)


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


func _show_title() -> void:
	mode = "title"
	_refresh()
	var box := _open_panel(520.0, 0.2)
	_label(box, "HUT 2847", 58, Art.AMBER)
	_label(box, tr("title.tagline"), 19, Color(Art.CREAM, 0.8))
	if _has_game():
		_button(box, "%s  (%s)" % [tr("ui.continue"), _clock_text(int(st.get("secs", 0)))], continue_game)
		_button(box, tr("ui.new"), start_new)
	else:
		_button(box, tr("ui.play"), start_new)
	var best := int(_prefs.get_value("best", "halves", 0))
	if best > 0:
		var row := _row(box)
		_label(row, tr("ui.best") % _clock_text(int(_prefs.get_value("best", "secs", 0))), 17, Color(Art.CREAM, 0.8)).autowrap_mode = TextServer.AUTOWRAP_OFF
		_stars(row, best, 11)
	_languages(box, _show_title)
	var window := DisplayServer.window_get_size()
	if window.y > window.x:
		_label(box, tr("ui.rotate"), 22, Art.AMBER)


func _show_intro() -> void:
	var box := _open_panel(640.0, 0.55)
	for key in ["intro.1", "intro.2", "intro.3"]:
		_label(box, tr(key), 20)
	_label(box, tr("intro.how"), 16, Color(Art.CREAM, 0.65))
	_button(box, tr("ui.start"), _close_panel)


func _show_menu() -> void:
	var box := _open_panel(420.0)
	_label(box, tr("ui.paused"), 28, Art.AMBER)
	_button(box, tr("ui.resume"), _close_panel)
	_button(box, tr("ui.restart"), func() -> void:
		var ask := _open_panel(460.0)
		_label(ask, tr("ui.confirm_restart"), 22)
		var row := _row(ask)
		_button(row, tr("ui.yes"), start_new)
		_button(row, tr("ui.no"), _show_menu))
	_button(box, tr("ui.to_title"), func() -> void:
		_save()
		st = link.send("state").get("state", st)
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
		_label(box, tr("hint.%d.%d" % [puzzle, i]), 20, Art.CREAM if i == level else Color(Art.CREAM, 0.55))
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
	mode = "end"
	_refresh()
	var box := _open_panel(600.0, 0.5)
	_label(box, tr("end.title"), 34, Art.AMBER)
	_label(box, tr("end.text"), 19)
	_stars(box, int(st.get("halves", 2)), 30)
	var hints := 0
	for h in st.get("hints", []):
		hints += int(h)
	_label(box, "%s     %s" % [tr("end.time") % _clock_text(int(st.get("secs", 0))), tr("end.hints") % hints], 22)
	if _prefs.get_value("best", "new", false):
		_label(box, tr("end.best"), 20, Art.AMBER)
	_button(box, tr("end.again"), func() -> void:
		st = link.send("new").get("state", {})
		view = "A"
		_show_title())
