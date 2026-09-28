extends SceneTree

var lab
var errors := 0

func _initialize() -> void:
	call_deferred("run")

func check(value: bool, message: String) -> void:
	if value:
		print("PASS ", message)
	else:
		errors += 1
		printerr("FAIL ", message)

func frames(count: int) -> void:
	for i in count:
		await physics_frame

func key(code: Key) -> void:
	var event := InputEventKey.new()
	event.physical_keycode = code
	event.pressed = true
	Input.parse_input_event(event)
	await frames(2)
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	await frames(2)

func skill() -> void:
	Input.action_press("skill")
	await frames(3)
	Input.action_release("skill")
	await frames(2)

func start(index: int, room_index := 0) -> void:
	Input.action_release("skill")
	Input.action_release("move_right")
	lab.start_course(lab.LEVELS[index], room_index)
	await frames(6)

func run() -> void:
	lab = preload("res://mechanics_lab.tscn").instantiate()
	root.add_child(lab)
	await frames(3)
	await key(KEY_6)
	check(lab.course.ID == "gravity_flip" and not lab.in_hub, "hub numeric navigation")
	await key(KEY_F3)
	check(lab.section == 2, "F3 selects checkpoint")
	await key(KEY_X)
	check(lab.player.gravity_sign == -1, "physical X reverses gravity")
	await key(KEY_R)
	check(lab.player.gravity_sign == 1 and lab.failures == 1, "R resets gravity and checkpoint")
	await key(KEY_B)
	await key(KEY_X)
	check(not lab.skill_enabled and lab.player.gravity_sign == 1, "B disables skill and resets momentum")
	await key(KEY_ESCAPE)
	check(lab.in_hub, "Escape returns to hub")
	await key(KEY_1)
	await key(KEY_C)
	await key(KEY_V)
	check(lab.world.data.dash_charges == 2 and lab.world.data.dash_air_only, "C/V independently change dash rules")
	await key(KEY_R)
	check(lab.world.data.dash_charges == 2 and lab.world.data.dash_air_only, "retry preserves comparison rules")
	await key(KEY_F1)
	check(lab.world.data.dash_charges == 1 and not lab.world.data.dash_air_only, "checkpoint selection restores dash presets")
	await start(0, 2)
	await skill()
	check(lab.player.ability.charges == 3 and lab.player.position.x < 100, "air-only dash refuses grounded activation")
	Input.action_press("jump")
	await frames(8)
	Input.action_release("jump")
	await skill()
	check(lab.player.ability.charges == 2, "air-only dash consumes one airborne charge")
	await start(1)
	Input.action_press("jump")
	await frames(10)
	await skill()
	check(not lab.player.ability.available, "double jump consumes air resource")
	var before: float = lab.player.velocity.y
	await skill()
	check(lab.player.velocity.y > before, "third jump cannot reset vertical velocity")
	Input.action_release("jump")
	await start(2)
	await skill()
	check(lab.player.velocity.y >= 0, "wall kick cannot activate on open ground")
	await start(3)
	# Contract fixture: inspect falling behavior; route tests separately start at actual spawn.
	lab.player.position = Vector2(400, 400)
	lab.player.velocity = Vector2(0, 500)
	Input.action_press("skill")
	await frames(4)
	check(lab.player.velocity.y <= 65.1, "glide caps falling speed")
	Input.action_release("skill")
	await frames(4)
	check(lab.player.velocity.y > 100, "releasing glide restores falling")
	await start(4, 2)
	lab.player.position = Vector2(420, 520)
	lab.world.anchors = [Vector2(770, 310)]
	await skill()
	check(not lab.player.ability.attached, "grapple rejects target occluded by solid wall")
	lab.player.position = Vector2(470, 260)
	lab.player.velocity = Vector2.ZERO
	await skill()
	check(lab.player.ability.has_candidate, "grapple sees target from above wall")
	await start(5)
	lab.completed = true
	lab.player.set_physics_process(false)
	await key(KEY_ENTER)
	check(lab.section == 1 and not lab.completed, "Enter advances cleared checkpoint")
	lab.section = 2
	lab.load_room()
	lab.completed = true
	lab.player.set_physics_process(false)
	await key(KEY_ENTER)
	check(lab.in_hub, "Enter returns to hub after final checkpoint")
	await start(0)
	Input.action_press("move_right")
	await frames(150)
	Input.action_release("move_right")
	check(lab.failures > 0 and not lab.completed, "walking into pit respawns at checkpoint")
	check(lab.player.ability.charges == 1, "death refills skill state")
	# Layout and language checks use actual Godot Control bounds, including cleared labels.
	for entry in lab.LEVELS:
		for index in entry.rooms().size():
			lab.records["%s:%d" % [entry.ID, index]] = 1.0
	lab.show_hub()
	await frames(3)
	var fits := true
	for control in lab.ui.get_children():
		if control is Control and (control.position.x + control.size.x > 1280 or control.position.y + control.size.y > 720):
			fits = false
			printerr("Overflow: ", control.text if control is Label or control is Button else control.name)
	check(fits, "completed hub controls fit 1280x720 canvas")
	fits = true
	for entry in lab.LEVELS:
		for index in entry.rooms().size():
			lab.start_course(entry, index)
			await frames(3)
			for control in lab.ui.get_children():
				if control is Control and (control.position.x + control.size.x > 1280 or control.position.y + control.size.y > 720):
					fits = false
					printerr("Overflow in ", entry.ID, ": ", control.text if control is Label or control is Button else control.name)
			if lab.status_label.position.x + lab.status_label.size.x > lab.timer_label.position.x:
				fits = false
	check(fits, "all course text fits canvas and status stays clear of timer")
	print("CHECKS RESULT: %d failures" % errors)
	quit(1 if errors else 0)
