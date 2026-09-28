extends RefCounted

var lock_time := 0.0
var push := 0.0
var touching := false
var contact_grace := 0.0
var last_normal := 0.0

func tick(p, delta: float) -> void:
	touching = p.is_on_wall() and not p.is_on_floor()
	contact_grace = maxf(0, contact_grace - delta)
	if touching:
		contact_grace = 0.10
		last_normal = p.get_wall_normal().x
	if touching and p.velocity.y > 80:
		p.velocity.y = 80
	if contact_grace > 0 and not p.is_on_floor() and lock_time <= 0 and Input.is_action_just_pressed("skill"):
		push = last_normal * 310
		p.velocity.y = -440
		lock_time = 0.14
		contact_grace = 0
	if lock_time > 0:
		p.velocity.x = push
		lock_time -= delta

func status() -> String:
	return "Wall kick: %s | push into wall to slide" % ("READY" if touching else "touch a wall in air")

func draw_overlay(p) -> void:
	if touching:
		p.draw_rect(Rect2(-18, -18, 36, 36), Color("65d9eb"), false, 2)
