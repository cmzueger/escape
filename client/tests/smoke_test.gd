## Plays the whole room through the client's hotspots and checks that it can
## be escaped, the hints, the score and the saved game.
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
	print("Hut 2847 smoke test")
	for i in range(10):
		await process_frame
	check(main.mode == "title", "title screen (mode %s)" % main.mode)
	await shot("title")
	main.start_new()
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
	main.st = main.link.send("new")["state"]
	main._boot()
	check(main.mode == "title" and main._has_game(), "a saved game is offered")
	main.continue_game()
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
	check(int(main._prefs.get_value("best", "halves", 0)) == 6, "best result kept")

	# Every text exists in every language.
	for lang in main.LANGS:
		TranslationServer.set_locale(lang)
		var missing := []
		for key in ["ui.play", "msg.too_dark", "msg.antenna", "hint.9.3", "item.crank", "end.title"]:
			if tr(key) == key:
				missing.append(key)
		check(missing.is_empty(), "texts in %s %s" % [lang, missing])

	print("RESULT: %s" % ("PASS" if failures == 0 else "FAIL (%d)" % failures))
	quit(0 if failures == 0 else 1)
