extends RefCounted

var available := true

func tick(p, _delta: float) -> void:
	if p.is_on_floor():
		available = true
	elif available and Input.is_action_just_pressed("skill"):
		p.velocity.y = p.jump_velocity
		available = false

func status() -> String:
	return "Air jump: %s | land to refill" % ("READY" if available else "USED")

func draw_overlay(p) -> void:
	if available:
		p.draw_rect(Rect2(-5, -23, 10, 4), Color("65d9eb"))
