extends RefCounted

var charges := 1
var capacity := 1
var air_only := false
var active := 0.0
var cooldown := 0.0
var direction := 1.0
var initialized := false

func tick(p, delta: float) -> void:
	if not initialized:
		capacity = p.room.data.get("dash_charges", 1)
		air_only = p.room.data.get("dash_air_only", false)
		charges = capacity
		initialized = true
	cooldown = maxf(0, cooldown - delta)
	if active <= 0:
		p.velocity.x = clampf(p.velocity.x, -p.speed, p.speed)
	if p.is_on_floor() and active <= 0 and cooldown <= 0:
		charges = capacity
	if active <= 0 and cooldown <= 0 and charges > 0 and Input.is_action_just_pressed("skill") and (not air_only or not p.is_on_floor()):
		charges -= 1
		active = 0.20
		cooldown = 0.28
		direction = p.facing
	if active > 0:
		p.velocity = Vector2(direction * 850, 0)
		active -= delta
		if p.is_on_wall():
			active = 0

func status() -> String:
	return "Dash %d/%d | %s | land to refill" % [charges, capacity, "AIR ONLY" if air_only else "ground + air"]

func draw_overlay(p) -> void:
	if active > 0:
		p.draw_line(Vector2(-p.facing * 50, 0), Vector2.ZERO, Color("65d9eb"), 12)
