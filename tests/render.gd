extends SceneTree

func _initialize() -> void:
	call_deferred("run")

func capture(name: String) -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://output/" + name + ".png")

func run() -> void:
	var lab = preload("res://mechanics_lab.tscn").instantiate()
	root.add_child(lab)
	await capture("hub")
	var courses: Array = [lab.BASELINE] + lab.LEVELS
	for entry in courses:
		if OS.get_cmdline_user_args().size() and entry.ID != OS.get_cmdline_user_args()[0]:
			continue
		for index in entry.rooms().size():
			lab.start_course(entry, index)
			await capture("%s-%d" % [entry.ID, index + 1])
	print("RENDER PASS")
	quit()
