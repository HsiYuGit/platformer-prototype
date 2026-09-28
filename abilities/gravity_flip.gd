extends RefCounted

var cooldown := 0.0
var direction := 1.0

func tick(p, delta: float) -> void:
	cooldown = maxf(0, cooldown - delta)
	if Input.is_action_just_pressed("skill") and cooldown <= 0:
		p.gravity_sign *= -1
		p.up_direction = Vector2(0, -p.gravity_sign)
		p.velocity.y = 0
		cooldown = 0.20
	direction = p.gravity_sign

func status() -> String:
	return "Gravity: %s | X to reverse" % ("DOWN" if direction > 0 else "UP")

func draw_overlay(p) -> void:
	var end := Vector2(0, 31 * direction)
	p.draw_line(Vector2(0, 19 * direction), end, Color("65d9eb"), 3)
	p.draw_line(end, end + Vector2(-5, -6 * direction), Color("65d9eb"), 2)
	p.draw_line(end, end + Vector2(5, -6 * direction), Color("65d9eb"), 2)
