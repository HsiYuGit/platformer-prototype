extends Node2D

var data: Dictionary
var anchors: Array = []

func build(spec: Dictionary) -> void:
	data = spec
	anchors = data.get("anchors", [])
	for rect: Rect2 in data["platforms"]:
		var body := StaticBody2D.new()
		body.position = rect.get_center()
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = rect.size
		collision.shape = shape
		body.add_child(collision)
		add_child(body)
	queue_redraw()

func _draw() -> void:
	if data.is_empty():
		return
	for x in range(40, 1241, 40):
		draw_line(Vector2(x, 160), Vector2(x, 640), Color("202a34"))
	for y in range(160, 641, 40):
		draw_line(Vector2(40, y), Vector2(1240, y), Color("202a34"))
	for rect: Rect2 in data["platforms"]:
		draw_rect(rect, Color("647382"))
		draw_line(rect.position, rect.position + Vector2(rect.size.x, 0), Color("b6c2cc"), 3)
	for rect: Rect2 in data.get("hazards", []):
		draw_rect(rect, Color("ad3e4b"))
		for x in range(int(rect.position.x), int(rect.end.x), 16):
			draw_line(Vector2(x, rect.position.y), Vector2(minf(x + 10, rect.end.x), rect.end.y), Color("f58287"), 2)
	var start: Vector2 = data["spawn"]
	draw_rect(Rect2(start + Vector2(-24, 16), Vector2(48, 5)), Color("65d9eb"))
	var finish: Rect2 = data["exit"]
	draw_rect(finish, Color(0.25, 0.85, 0.58, 0.14))
	draw_rect(finish, Color("77e3a5"), false, 3)
	draw_string(ThemeDB.fallback_font, finish.position + Vector2(0, -10), "EXIT", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("77e3a5"))
	for point: Vector2 in anchors:
		draw_rect(Rect2(point - Vector2(8, 8), Vector2(16, 16)), Color("f2ca72"))
		draw_arc(point, 20, 0, TAU, 24, Color("f2ca72"), 1)

func touches_hazard(player_rect: Rect2) -> bool:
	for rect: Rect2 in data.get("hazards", []):
		if rect.intersects(player_rect):
			return true
	return false
