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
	for id in ["hut", "light", "obs"]:
		main.start_new(id)
		main._close_panel()
		main.seconds = 754.0
		main._save()
	var widest := 0.0
	for lang in main.LANGS:
		TranslationServer.set_locale(lang)
		main._show_title()
		await process_frame
		await process_frame
		for card in main._panels.get_child(0).get_child(2).get_children():
			widest = maxf(widest, card.get_global_rect().end.x)
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("%s/title_%s.png" % [folder, lang])
	print("cards end at x = %d (screen: 960)" % int(widest))
	print("RESULT: %s" % ("PASS" if widest <= 960.0 else "FAIL"))
	quit(0 if widest <= 960.0 else 1)
