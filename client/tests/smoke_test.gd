## Plays both rooms through the client's hotspots and checks that they can
## be escaped, the hints, the score, the saved games and the sounds.
##   godot --headless --path client --script res://tests/smoke_test.gd
## With a display, "-- shots <folder>" also saves a picture of every view:
##   xvfb-run -a godot --path client --script res://tests/smoke_test.gd -- shots /tmp/shots
## Contains the solutions.
extends SceneTree

const WIRES := [2, 1, 1, 1, 2, 0, 1, 3, 2, 0, 1, 3, 0, 0, 0]

var main: Control
var failures := 0
var shots := ""
var shot_no := 0


func check(ok: bool, what: String) -> void:
	print("  ok   " if ok else "  FAIL ", what)
	if not ok:
		failures += 1


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() >= 2 and args[0] == "shots":
		shots = args[1]
		DirAccess.make_dir_recursive_absolute(shots)
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://hut2847.cfg"))
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	main.storm = false
	_run()


func shot(name: String) -> void:
	if shots == "":
		return
	await process_frame
	await RenderingServer.frame_post_draw
	shot_no += 1
	root.get_texture().get_image().save_png("%s/%02d_%s.png" % [shots, shot_no, name])


func flag(name: String) -> bool:
	return main.st.get("flags", []).has(name)


func use(item: String, spot: String) -> void:
	main.select_item(item)
	check(main.tap_spot(spot), "use %s on %s" % [item, spot])


func tap(spot: String, times: int = 1) -> void:
	for i in range(times):
		if not main.tap_spot(spot):
			check(false, "hotspot %s in view %s" % [spot, main.view])
			return


func _run() -> void:
	print("Locked In smoke test")
	for i in range(10):
		await process_frame
	check(main.mode == "title" and main.rooms.size() == 2, "the catalogue with two rooms (mode %s)" % main.mode)
	await shot("title")
	main.start_new("hut")
	await shot("intro")
	main._close_panel()
	check(main.mode == "play" and main.view == "A", "a new game starts at the stove wall")

	# Act 1.
	await shot("A_dark")
	main.go_view("B")
	await shot("B_dark")
	tap("hats")
	check(main._message == tr("msg.too_dark"), "too dark before the lamp burns")
	main.go_view("A")
	tap("coat")
	use("matches", "lamp")
	check(flag("lamp_lit"), "lamp lit")
	await shot("A_lamp")
	main.go_view("B")
	await shot("B")
	main.go_view("C")
	await shot("C")
	tap("cupboard")
	check(main.view == "lock", "the cupboard's lock opens as a close-up")
	await shot("lock")
	tap("cup_up0", 4)
	tap("cup_down1", 3)
	tap("cup_digit2", 3)
	check(flag("cup_open"), "cupboard open")
	await create_timer(1.3).timeout
	check(main.view == "C", "back at the cupboard by itself")
	await shot("C_open")
	tap("cupboard")
	tap("woodbox")
	tap("bucket")
	check(main.st["inv"].size() == 4, "matches, kindling, log, bucket carried")
	main.go_view("A")
	use("log", "stove")
	use("kindling", "stove")
	use("matches", "stove")
	check(flag("stove_lit"), "stove lit")
	use("bucket", "stove")
	await shot("A_warm")
	main.go_view("B")
	tap("door2")
	check(main.view == "B", "the warden's door is locked")
	use("key", "door2")
	check(flag("door2_open"), "warden's door unlocked")
	await shot("B_open")
	tap("door2")
	check(main.view == "D", "into the warden's room")

	# Hints: free to look, half a star each.
	main._show_hint()
	check(int(main.st["halves"]) == 6, "asking about a hint is free")
	await shot("hint")
	main._close_panel()

	# Act 2.
	await shot("D")
	tap("logbook")
	await shot("logbook")
	main.go_view("E")
	await shot("E")
	tap("clock")
	await shot("clock")
	tap("hour_on", 4)
	tap("minute_on", 5)
	check(flag("clock_open"), "cuckoo out")
	await shot("clock_open")
	tap("cuckoo")
	main.go_view("D")
	use("dkey", "drawer")
	check(main.st["inv"].has("paper"), "paper from the drawer")
	main.go_view("E")
	tap("map")
	await shot("map")
	check(main.view == "map", "map close-up")
	use("paper", "map")
	check(flag("map_overlay"), "paper on the map")
	await shot("map_paper")
	main.go_view("E")
	tap("safe")
	await shot("safe")
	tap("safe_up0", 6)
	tap("safe_up1", 1)
	tap("safe_down2", 1)
	tap("safe_up3", 3)
	check(flag("safe_open"), "strongbox open")
	await shot("safe_open")
	tap("safe")
	main.go_view("D")
	tap("baro")
	await shot("baro")
	tap("ring_left", 7)
	check(flag("baro_open"), "barometer open")
	await shot("baro_open")
	tap("baro_crank")
	check(int(main.st["act"]) == 3, "act 3")

	# Save and continue: back to the title, then on.
	main._save()
	var before: Dictionary = main.st.duplicate(true)
	main._show_title()
	check(main.mode == "title" and main._has_game("hut") and not main._has_game("light"), "a saved game is offered")
	await shot("title_saved")
	main.continue_game("hut")
	check(main.st["flags"] == before["flags"] and main.st["inv"] == before["inv"], "the saved game is restored")

	# Act 3.
	main.go_view("D")
	tap("radio")
	await shot("radio_dead")
	use("crank", "crank_slot")
	tap("radio_back")
	check(main.view == "wiring", "cable board")
	await shot("wiring")
	use("fuse", "fuse_slot")
	for i in range(15):
		while int(main.st["wire"][i]) != WIRES[i] and not main.st["wired"]:
			tap("tile%d" % i)
	check(main.st["power"], "radio has power")
	await shot("wiring_done")
	main.go_view("radio")
	tap("knob_c_down", 3)
	tap("knob_f_down", 3)
	check(flag("tuned"), "tuned to the hut's altitude")
	await shot("radio_tuned")
	for s in "lsslsl":
		tap("key_long" if s == "l" else "key_short")
	check(main.st["done"], "signal answered")
	check(main.mode == "ending", "ending")
	await create_timer(3.0).timeout
	check(main.mode == "end", "end screen")
	check(int(main.st["halves"]) == 6, "three stars without hints")
	await shot("end")
	check(main._best("hut")[0] == 6 and not main._has_game("hut"), "best result kept, saved game gone")
	for name in ["match", "unlock", "pick", "chime", "cuckoo", "hum", "beep_l", "win", "step"]:
		check(main.sound.history.has(name), "sound: " + name)
	await _lighthouse()

	# Every text exists in every language.
	for lang in main.LANGS:
		TranslationServer.set_locale(lang)
		var missing := []
		for key in ["ui.play", "msg.too_dark", "msg.antenna", "hint.9.3", "item.crank", "end.title", "lhint.10.3", "lmsg.pressure", "lend.text", "diff.2"]:
			if tr(key) == key:
				missing.append(key)
		check(missing.is_empty(), "texts in %s %s" % [lang, missing])

	print("RESULT: %s" % ("PASS" if failures == 0 else "FAIL (%d)" % failures))
	quit(0 if failures == 0 else 1)


func dial(lock: String, code: Array, from: Array, size: int = 10) -> void:
	for i in range(code.size()):
		tap("%s_up%d" % [lock, i], (int(code[i]) - int(from[i]) + size) % size)


## Gale Rock Light, floor by floor.
func _lighthouse() -> void:
	main._show_title()
	main.start_new("light")
	main._close_panel()
	check(main.room == "light" and main.view == "L1", "the lighthouse starts in the store room")
	await shot("L1")
	tap("hatch1")
	check(main.view == "L1", "the first hatch is locked")
	tap("magnet")
	tap("rope")
	tap("gear_b")
	main.tap_item("magnet")
	main.tap_item("rope")
	check(main.st["inv"].has("line"), "magnet and rope tied together")
	use("line", "grating")
	use("key", "hatch1")
	tap("hatch1")
	check(main.view == "L2", "up to the keeper's room")
	await shot("L2")
	tap("chest")
	await shot("chest")
	dial("chest", [3, 5, 2, 0], [0, 0, 0, 0], 6)
	check(flag("chest_open"), "sea chest open")
	tap("chest")
	main.go_view("L2")
	tap("matches")
	tap("tidebook")
	await shot("tide")
	main.go_view("L2")
	tap("hatch2")
	check(main.view == "hatch2", "the second hatch has a lock")
	await shot("hatch2")
	dial("hatch2", [2, 2, 0, 5], [0, 0, 0, 0])
	check(flag("hatch2_open"), "second hatch open")
	main.go_view("L2")
	check(Views.up("L2", main.st) == "L3", "the way up is shown")
	tap("hatch2")
	await shot("L3")
	tap("flagchart")
	await shot("flags")
	main.go_view("L3")
	tap("slate")
	await shot("slate")
	main.go_view("L3")
	tap("chart")
	await shot("chart")
	main.go_view("L3")
	tap("window")
	await shot("window_dark")
	main.strike()
	await create_timer(0.05).timeout
	check(main.art.flash > 0.9, "lightning")
	await shot("window_flash")
	main.go_view("L3")
	tap("locker")
	await shot("locker")
	dial("locker", [7, 3, 0, 5], [0, 0, 0, 0])
	tap("locker")
	check(main.st["inv"].has("handle") and main.st["inv"].has("gear_a"), "handle and gear from the locker")
	main.go_view("L3")
	use("handle", "hatch3")
	tap("hatch3")
	check(main.view == "L4", "the lamp room")
	await shot("L4")
	tap("gear_d")
	use("matches", "lamp")
	check(main._message == tr("lmsg.lamp_not_ready"), "the lamp is not ready")

	# Save and continue on the top floor.
	main._save()
	main._show_title()
	check(main._has_game("light"), "the lighthouse's saved game is offered")
	main.continue_game("light")
	check(main.view == "L4" and main.st["inv"].size() == 6, "back in the lamp room with everything")

	# Oil: 4 litres in the big can.
	for v in ["L3", "L2", "L1"]:
		main.go_view(v)
	tap("barrel")
	await shot("oil")
	for spot in ["fill_a", "pour_a", "empty_b", "pour_a", "fill_a", "pour_a"]:
		tap(spot)
	check(main.st["cans"] == [4.0, 3.0], "4 litres measured")
	await shot("oil_4")
	tap("can")
	for v in ["L1", "L2", "L3", "L4"]:
		main.go_view(v)
	use("can", "reservoir")
	check(flag("oil_in"), "oil in the reservoir")
	tap("clockwork")
	await shot("gears")
	use("gear_c", "peg0")
	use("gear_a", "peg1")
	use("gear_d", "peg2")
	use("crank", "crank_slot")
	check(flag("wound"), "clockwork wound")
	await shot("gears_done")
	main.go_view("L4")
	tap("valves")
	await shot("valves")
	tap("valve_a")
	tap("valve_b", 3)
	tap("valve_c", 2)
	check(main.st["pressure"], "pressure in the green")
	main.go_view("L4")
	tap("drum")
	for pin in [4, 6, 7]:
		tap("pin%d" % pin)
	await shot("drum")
	main.go_view("L4")
	use("matches", "lamp")
	check(main._message == tr("lmsg.lamp_wrong") and not main.st["done"], "wrong direction: the ship holds its course")
	tap("bearing")
	dial("bearing", [2, 3, 5], main.st["bearing"])
	await shot("bearing")
	main.go_view("L4")
	await shot("L4_ready")
	use("matches", "lamp")
	check(main.st["done"], "the lamp burns")
	await shot("L4_lit")
	await create_timer(3.6).timeout
	check(main.mode == "end", "end screen")
	check(int(main.st["halves"]) == 6 and main._best("light")[0] == 6, "three stars for the lighthouse")
	await shot("light_end")
	for name in ["pour", "gear", "thud"]:
		check(main.sound.history.has(name), "sound: " + name)
	main._show_title()
	await shot("title_played")
