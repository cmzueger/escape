## Pictures of the catalogue in every language, with a game in progress in
## each room (the widest cards).
##   xvfb-run -a godot --path client --script res://tests/title_shots.gd -- <folder>
extends SceneTree


func _initialize() -> void:
	var folder := OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(folder)
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://hut2847.cfg"))
	var main: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in range(10):
		await process_frame
	for id in ["hut", "light", "obs", "orangery", "theatre", "chess", "beach", "train", "alch", "attic", "watch", "museum", "tree", "gondola", "praline", "toyshop", "zeppelin", "ship", "polar", "house1905", "house1938", "house1969", "housenow", "press", "magic", "noir", "filter", "railway", "mill", "aviary", "mirrors", "school", "spring", "summer", "autumn", "winter", "carnival"]:
		main.start_new(id)
		main._close_panel()
		main.seconds = 754.0
		main._save()
	var widest := 0.0
	var lowest := 0.0
	for lang in main.LANGS:
		TranslationServer.set_locale(lang)
		main._show_title()
		await process_frame
		await process_frame
		for part in main._panels.get_child(0).get_children():
			lowest = maxf(lowest, part.get_global_rect().end.y)
			if part is ScrollContainer:
				for row in part.get_child(0).get_children():
					for card in row.get_children():
						widest = maxf(widest, card.get_global_rect().end.x)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("%s/title_%s.png" % [folder, lang])
	print("cards end at x = %d, rows at y = %d (screen: 960 x 540)" % [int(widest), int(lowest)])
	var fits := widest <= 960.0 and lowest <= 540.0
	print("RESULT: %s" % ("PASS" if fits else "FAIL"))
	quit(0 if fits else 1)
