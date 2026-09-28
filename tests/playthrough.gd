extends SceneTree

var lab
var errors := 0
var routes: Dictionary

func _initialize() -> void:
	call_deferred("run")

func set_inputs(step: Dictionary) -> void:
	for action in ["move_left", "move_right", "jump", "skill"]:
		var pressed: bool = step.get(action, false)
		if pressed and not Input.is_action_pressed(action):
			Input.action_press(action)
		elif not pressed and Input.is_action_pressed(action):
			Input.action_release(action)

func run() -> void:
	routes = JSON.parse_string(FileAccess.get_file_as_string("res://tests/routes.json"))
	lab = preload("res://mechanics_lab.tscn").instantiate()
	root.add_child(lab)
	await physics_frame
	var courses: Array = [lab.BASELINE] + lab.LEVELS
	for entry in courses:
		if OS.get_cmdline_user_args().size() and entry.ID != OS.get_cmdline_user_args()[0]:
			continue
		for index in entry.rooms().size():
			set_inputs({})
			lab.start_course(entry, index)
			for tick in 6:
				await physics_frame
			var key := "%s:%d" % [entry.ID, index]
			var route: Array = routes.get(key, [])
			for step: Dictionary in route:
				set_inputs(step)
				for tick in int(step.get("frames", 360)):
					await physics_frame
					if lab.completed or lab.failures > 0:
						break
					if step.has("x") and lab.player.position.x >= step.x:
						break
					if step.has("left_x") and lab.player.position.x <= step.left_x:
						break
					if step.has("y_above") and lab.player.position.y <= step.y_above:
						break
					if step.get("land", false) and tick > 5 and lab.player.is_on_floor():
						break
				if lab.completed or lab.failures > 0:
					break
			set_inputs({})
			if not lab.completed or lab.failures > 0:
				printerr("FAIL %s: pos=%s retries=%s" % [key, lab.player.position, lab.failures])
				errors += 1
			else:
				print("PASS %s: %.2fs from spawn" % [key, lab.elapsed])
			# State reset must recreate ability and clear momentum at this checkpoint.
			lab.toggle_skill()
			assert(not lab.skill_enabled and not lab.player.ability_enabled)
			assert(lab.player.velocity == Vector2.ZERO)
			assert(lab.player.position == entry.rooms()[index]["spawn"])
			lab.retry()
			assert(not lab.player.ability_enabled and not lab.completed)
			lab.show_hub()
			assert(lab.in_hub and lab.player == null)
	set_inputs({})
	print("RESULT: %d failed routes" % errors)
	quit(1 if errors else 0)
