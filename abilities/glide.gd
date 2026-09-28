extends RefCounted

var active := false

func tick(p, _delta: float) -> void:
	active = Input.is_action_pressed("skill") and not p.is_on_floor() and p.velocity.y > 0
	if active:
		p.velocity.y = minf(p.velocity.y, 65)

func status() -> String:
	return "Glide: %s | hold X to slow descent" % ("OPEN" if active else "CLOSED")

func draw_overlay(p) -> void:
	if active:
		p.draw_line(Vector2(-28, -23), Vector2(28, -23), Color("65d9eb"), 5)
		p.draw_line(Vector2(-28, -23), Vector2.ZERO, Color("65d9eb"), 1)
		p.draw_line(Vector2(28, -23), Vector2.ZERO, Color("65d9eb"), 1)
