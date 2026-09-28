extends Node2D

const PLAYER = preload("res://player.tscn")
const ROOM = preload("res://room.gd")
const BASELINE = preload("res://levels/baseline.gd")
const LEVELS: Array = [preload("res://levels/dash.gd"), preload("res://levels/double_jump.gd")]

var ui: Control
var world: Node2D
var player: CharacterBody2D
var course = BASELINE
var section := 0
var in_hub := true
var completed := false
var skill_enabled := true
var failures := 0
var elapsed := 0.0
var records: Dictionary = {}
var status_label: Label
var result_label: Label
var dash_charges_override := 0
var dash_air_override := -1

func _ready() -> void:
	preload("res://player.gd").configure_input()
	var layer := CanvasLayer.new()
	add_child(layer)
	ui = Control.new()
	layer.add_child(ui)
	show_hub()

func clear_view() -> void:
	for child in ui.get_children():
		ui.remove_child(child)
		child.queue_free()
	if is_instance_valid(world):
		remove_child(world)
		world.queue_free()
	world = null
	player = null

func label_at(text: String, pos: Vector2, size := 18, color := Color("dce5ed")) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	ui.add_child(label)
	return label

func button_at(text: String, rect: Rect2, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.position = rect.position
	button.size = rect.size
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 17)
	button.pressed.connect(callback)
	ui.add_child(button)
	return button

func show_hub() -> void:
	clear_view()
	in_hub = true
	label_at("MOVEMENT LAB", Vector2(48, 28), 34)
	label_at("One skill. Three obstacle patterns. Choose any checkpoint.", Vector2(50, 78), 20)
	label_at("COURSE / TEST QUESTION", Vector2(50, 137), 14, Color("91a4b5"))
	label_at("CHECKPOINTS   ([OK] means cleared this session)", Vector2(640, 137), 14, Color("91a4b5"))
	for i in LEVELS.size():
		var entry = LEVELS[i]
		var y := 177.0 + i * 71
		label_at("%d  %s" % [i + 1, entry.TITLE], Vector2(50, y), 22)
		label_at(entry.SUMMARY, Vector2(50, y + 31), 15, Color("a4b6c5"))
		var rooms: Array = entry.rooms()
		for j in rooms.size():
			var key := "%s:%d" % [entry.ID, j]
			var prefix := "[OK] " if records.has(key) else ""
			button_at(prefix + "%d. %s" % [j + 1, rooms[j]["name"]], Rect2(630 + j * 199, y, 191, 55), start_course.bind(entry, j))
	button_at("0. Basic movement", Rect2(50, 634, 220, 42), start_course.bind(BASELINE, 0))
	label_at("A/D: move   SPACE: jump   X/SHIFT: skill   R: retry   ESC: hub", Vector2(300, 640), 17)
	label_at("Grey: solid    Red stripes: hazard    Cyan: checkpoint    Green: exit", Vector2(300, 671), 15, Color("91a4b5"))

func start_course(entry, room_index: int) -> void:
	course = entry
	section = room_index
	skill_enabled = true
	failures = 0
	dash_charges_override = 0
	dash_air_override = -1
	load_room()

func load_room() -> void:
	clear_view()
	in_hub = false
	completed = false
	elapsed = 0.0
	var spec: Dictionary = course.rooms()[section]
	if course.ID == "dash":
		if dash_charges_override > 0:
			spec["dash_charges"] = dash_charges_override
		if dash_air_override >= 0:
			spec["dash_air_only"] = bool(dash_air_override)
	world = ROOM.new()
	add_child(world)
	world.build(spec)
	player = PLAYER.instantiate()
	player.position = spec["spawn"]
	player.room = world
	player.ability_enabled = skill_enabled
	if course.ABILITY != null:
		player.ability = course.ABILITY.new()
	world.add_child(player)
	label_at("%s  /  %02d  %s" % [course.TITLE, section + 1, spec["name"]], Vector2(40, 22), 28)
	button_at("Hub [ESC]", Rect2(1090, 24, 150, 38), show_hub)
	label_at(spec["question"], Vector2(40, 66), 19)
	label_at(spec["hint"], Vector2(40, 100), 17, Color("f2ca72"))
	status_label = label_at("", Vector2(40, 658), 17)
	label_at(course.CONTROLS, Vector2(40, 691), 15, Color("a4b6c5"))
	result_label = label_at("", Vector2(40, 132), 18, Color("77e3a5"))
	button_at("Retry [R]", Rect2(845, 650, 130, 37), retry)
	button_at("Skill ON/OFF [B]", Rect2(988, 650, 252, 37), toggle_skill)

func retry() -> void:
	if in_hub:
		return
	failures += 1
	load_room()

func toggle_skill() -> void:
	if in_hub:
		return
	skill_enabled = not skill_enabled
	failures = 0
	load_room()

func next_room() -> void:
	if section + 1 < course.rooms().size():
		section += 1
		failures = 0
		dash_charges_override = 0
		dash_air_override = -1
		load_room()
	else:
		show_hub()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if in_hub:
		if event.physical_keycode == KEY_0:
			start_course(BASELINE, 0)
		var index: int = event.physical_keycode - KEY_1
		if index >= 0 and index < LEVELS.size():
			start_course(LEVELS[index], 0)
		return
	if event.is_action_pressed("hub"):
		show_hub()
	elif event.is_action_pressed("retry"):
		retry()
	elif event.is_action_pressed("compare"):
		toggle_skill()
	elif course.ID == "dash" and event.physical_keycode == KEY_C:
		dash_charges_override = int(world.data["dash_charges"]) % 3 + 1
		failures = 0
		load_room()
	elif course.ID == "dash" and event.physical_keycode == KEY_V:
		dash_air_override = 0 if world.data["dash_air_only"] else 1
		failures = 0
		load_room()
	elif completed and event.is_action_pressed("next_room"):
		next_room()
	elif event.physical_keycode >= KEY_F1 and event.physical_keycode <= KEY_F3:
		var index: int = event.physical_keycode - KEY_F1
		if index < course.rooms().size():
			section = index
			failures = 0
			dash_charges_override = 0
			dash_air_override = -1
			load_room()

func _physics_process(delta: float) -> void:
	if in_hub or not is_instance_valid(player):
		return
	if not completed:
		elapsed += delta
	status_label.text = "%s   |   %.1fs   Retries: %d   CP %d/%d" % [player.skill_status(), elapsed, failures, section + 1, course.rooms().size()]
	if completed:
		return
	var bounds := Rect2(player.position - Vector2(14, 14), Vector2(28, 28))
	if player.position.y > 710 or player.position.y < 152 or player.position.x < 16 or player.position.x > 1264 or world.touches_hazard(bounds):
		retry.call_deferred()
	elif world.data["exit"].intersects(bounds):
		completed = true
		player.set_physics_process(false)
		var key := "%s:%d" % [course.ID, section]
		if skill_enabled and dash_charges_override == 0 and dash_air_override == -1:
			records[key] = minf(records.get(key, INF), elapsed)
		result_label.text = "CLEAR!  %.1fs / %d retries   |   ENTER: %s   R: replay   ESC: hub" % [elapsed, failures, "next checkpoint" if section + 1 < course.rooms().size() else "return to hub"]

