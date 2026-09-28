extends CharacterBody2D

@export var speed := 250.0
@export var acceleration := 1800.0
@export var deceleration := 2200.0

@export var jump_velocity := -400.0
@export var gravity := 1000.0
@export var fall_gravity_multiplier := 1.5
@export var jump_cut_multiplier := 0.5

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")

	# Horizontal movement
	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * speed,
			acceleration * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			deceleration * delta
		)

	# Gravity
	if not is_on_floor():
		var current_gravity = gravity

		if velocity.y > 0:
			current_gravity *= fall_gravity_multiplier

		velocity.y += current_gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Release jump early → lower jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	move_and_slide()
