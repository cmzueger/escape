## Every arrow a view draws lies on a hotspot, and every wheel's up and down
## hotspot has its arrow: pictures and hotspots agree. Needs a display:
##   xvfb-run -a godot --path client --resolution 960x540 --script res://tests/layout_check.gd
## Each room is checked at its start and, for the rooms of the kit, with every
## flag set (all locks open), visiting every view it can reach.
extends SceneTree

var main: Control
var failures := 0
var checked := 0


func _initialize() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://hut2847.cfg"))
	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	main.storm = false
	_run()


func _views(room: String) -> Array:
	var todo := [Views.first(room)]
	var seen := {}
	while not todo.is_empty():
		var at: String = todo.pop_back()
		if seen.has(at) or Views.room_of(at) != room:
			continue
		seen[at] = true
		var next := [Views.back(at), Views.beside(at, -1), Views.beside(at, 1), Views.up(at, main.st)]
		for spot in Views.spots(at, main.st, main.art):
			if str(spot[2]).begins_with("go:"):
				next.append(str(spot[2]).substr(3))
		for n in next:
			if n != "" and not seen.has(n):
				todo.append(n)
	return seen.keys()


func _check_views(room: String, label: String) -> void:
	for v in _views(room):
		main.go_view(v)
		await process_frame
		await RenderingServer.frame_post_draw
		var spots: Array = main._spots()
		var bad := []
		for a in main.scene_arrows:
			var centre: Vector2 = (a as Rect2).get_center()
			var hit := false
			for spot in spots:
				if (spot[1] as Rect2).has_point(centre):
					hit = true
			if not hit:
				bad.append("arrow at %s has no hotspot" % centre)
		var wheel := RegEx.create_from_string("_(up|down)\\d+$")
		for spot in spots:
			if wheel.search(str(spot[0])) == null:
				continue
			var has := false
			for a in main.scene_arrows:
				if (spot[1] as Rect2).has_point((a as Rect2).get_center()):
					has = true
			if not has:
				bad.append("hotspot %s has no arrow" % spot[0])
		checked += 1
		if not bad.is_empty():
			failures += 1
			print("  FAIL %s %s %s: %s" % [room, label, v, bad])


func _run() -> void:
	for i in range(10):
		await process_frame
	for entry in main.rooms:
		var room: String = entry["id"]
		main.start_new(room)
		main._close_panel()
		await _check_views(room, "start")
		# All flags set: load the room's save with every flag bit on.
		var parts: PackedStringArray = str(main.link.send("save").get("save", "")).split(".")
		if parts.size() == 8 and parts[0] == "K1":
			for n in range(40, 0, -1):
				parts[2] = "%x" % ((1 << n) - 1)
				var answer: Dictionary = main.link.send("load " + ".".join(parts))
				if answer.get("ok", false):
					main.st = answer["state"]
					await _check_views(room, "open")
					break
	print("%d views checked" % checked)
	print("RESULT: %s" % ("PASS" if failures == 0 else "FAIL (%d)" % failures))
	quit(0 if failures == 0 else 1)
