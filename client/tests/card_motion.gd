## Renders every room's card picture at two moments and lists the cards that
## do not move (every card should be animated). With "-- <folder>" it also
## saves a sheet of all cards.
##   xvfb-run -a godot --path client --script res://tests/card_motion.gd [-- <folder>]
extends SceneTree

const W := 192
const H := 132


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var folder: String = args[0] if args.size() > 0 else ""
	var main: Control = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in range(5):
		await process_frame
	var ids: Array = []
	for entry in main.rooms:
		ids.append(entry["id"])
	var still := []
	var sheet := Image.create(W * 6, H * int(ceil(ids.size() / 6.0)), false, Image.FORMAT_RGBA8)
	for n in range(ids.size()):
		var frames := []
		for moment in [0.4, 1.9]:
			var view := SubViewport.new()
			view.size = Vector2i(W, H)
			view.render_target_update_mode = SubViewport.UPDATE_ONCE
			var canvas := Control.new()
			canvas.size = Vector2(W, H)
			var id: String = ids[n]
			canvas.draw.connect(func() -> void:
				main.art.ci = canvas
				main.art.t = moment
				main.art.card(id, W, H)
				main.art.home())
			view.add_child(canvas)
			root.add_child(view)
			await process_frame
			await RenderingServer.frame_post_draw
			frames.append(view.get_texture().get_image())
			view.queue_free()
		var a: Image = frames[0]
		var b: Image = frames[1]
		var changed := 0
		for y in range(0, H, 2):
			for x in range(0, W, 2):
				if a.get_pixel(x, y).is_equal_approx(b.get_pixel(x, y)) == false:
					changed += 1
		if changed < 20:
			still.append(ids[n])
		a.convert(Image.FORMAT_RGBA8)
		sheet.blit_rect(a, Rect2i(0, 0, W, H), Vector2i((n % 6) * W, (n / 6) * H))
	if folder != "":
		DirAccess.make_dir_recursive_absolute(folder)
		sheet.save_png(folder + "/cards.png")
	print("still cards: %s" % [still])
	print("RESULT: %s" % ("PASS" if still.is_empty() else "FAIL"))
	quit(0 if still.is_empty() else 1)
