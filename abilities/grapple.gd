extends RefCounted

const RANGE := 480.0
var attached := false
var target := Vector2.ZERO
var candidate := Vector2.ZERO
var has_candidate := false

func tick(p, delta: float) -> void:
	has_candidate = false
	var nearest := RANGE
	for point: Vector2 in p.room.anchors:
		var offset: Vector2 = point - p.global_position
		var distance := offset.length()
		if distance < 40 or distance > nearest or offset.x * p.facing < -20:
			continue
		var ray := PhysicsRayQueryParameters2D.create(p.global_position, point, 1, [p.get_rid()])
		if not p.get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
			continue
		nearest = distance
		candidate = point
		has_candidate = true
	if Input.is_action_just_pressed("skill") and has_candidate:
		target = candidate
		attached = true
	if not Input.is_action_pressed("skill"):
		attached = false
	if attached:
		var offset: Vector2 = target - p.global_position
		p.velocity = offset.normalized() * minf(540, offset.length() / delta)

func status() -> String:
	if attached:
		return "Grapple: ATTACHED | release X to let go"
	return "Grapple: %s | range 480" % ("TARGET READY" if has_candidate else "no visible target ahead")

func draw_overlay(p) -> void:
	if attached:
		p.draw_line(Vector2.ZERO, target - p.global_position, Color("f2ca72"), 3)
	elif has_candidate:
		p.draw_line(Vector2.ZERO, candidate - p.global_position, Color(0.95, 0.8, 0.45, 0.35), 1)
		p.draw_rect(Rect2(candidate - p.global_position - Vector2(13, 13), Vector2(26, 26)), Color("f2ca72"), false, 2)
