extends CharacterBody2D

@export var speed := 250.0
@export var acceleration := 1800.0
@export var deceleration := 2200.0
@export var jump_velocity := -400.0
@export var gravity := 1000.0
@export var fall_gravity_multiplier := 1.5
@export var jump_cut_multiplier := 0.5

var ability: RefCounted
var ability_enabled := true
var gravity_sign := 1.0
var facing := 1.0
var room: Node2D

static func configure_input() -> void:
	var bindings := {
		"move_left": [KEY_A, KEY_LEFT], "move_right": [KEY_D, KEY_RIGHT],
		"jump": [KEY_SPACE], "skill": [KEY_X, KEY_SHIFT],
		"retry": [KEY_R], "hub": [KEY_ESCAPE], "compare": [KEY_B],
		"next_room": [KEY_ENTER],
	}
	for action in bindings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for key in bindings[action]:
			var event := InputEventKey.new()
			event.physical_keycode = key
			if not InputMap.action_has_event(action, event):
				InputMap.action_add_event(action, event)

func _ready() -> void:
	configure_input()

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		facing = direction
	velocity.x = move_toward(velocity.x, direction * speed, (acceleration if direction else deceleration) * delta)
	up_direction = Vector2(0, -gravity_sign)
	if not is_on_floor():
		var multiplier := fall_gravity_multiplier if velocity.y * gravity_sign > 0 else 1.0
		velocity.y += gravity * gravity_sign * multiplier * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity * gravity_sign
	if Input.is_action_just_released("jump") and velocity.y * gravity_sign < 0:
		velocity.y *= jump_cut_multiplier
	if ability != null and ability_enabled:
		ability.tick(self, delta)
	move_and_slide()
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(-15, -15, 30, 30), Color("e6edf2"))
	draw_rect(Rect2(5 * facing - 3, -6 * gravity_sign, 6, 6), Color("25323d"))
	if ability != null and ability_enabled:
		ability.draw_overlay(self)

func skill_status() -> String:
	if ability == null:
		return "Basic movement only"
	return ability.status() if ability_enabled else "SKILL OFF / baseline comparison"

