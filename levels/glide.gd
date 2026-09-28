extends RefCounted

const ID = "glide"
const TITLE = "GLIDE"
const SUMMARY = "Trade altitude for range; open and close to steer descent."
const ABILITY = preload("res://abilities/glide.gd")
const CONTROLS = "A/D: move | SPACE: jump | Hold X/SHIFT while falling: glide | Release: drop | F1-F3: checkpoints"

static func rooms() -> Array:
	return [
		{"name": "Long descent", "question": "Range: convert starting height into a long horizontal crossing.",
		"hint": "Walk off the high platform and hold X. Glide slows falling; it cannot lift you.",
		"spawn": Vector2(80, 320), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 340, 260, 30), Rect2(980, 600, 260, 40)],
		"hazards": [Rect2(300, 635, 680, 25)]},
		{"name": "Height window", "question": "Vertical control: fit between a hanging block and a dangerous floor.",
		"hint": "Release X before the hanging block to descend below it, then reopen before the red floor.",
		"spawn": Vector2(80, 280), "exit": Rect2(1150, 480, 50, 70),
		"platforms": [Rect2(40, 300, 220, 30), Rect2(550, 160, 150, 240), Rect2(960, 550, 280, 90)],
		"hazards": [Rect2(520, 540, 330, 100), Rect2(260, 635, 700, 25)]},
		{"name": "Landing island", "question": "Precision: close the glide to land, then launch below the hanging hazard.",
		"hint": "Aim for the middle island. Stop moving and release X to land before the next crossing.",
		"spawn": Vector2(80, 280), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 300, 240, 30), Rect2(650, 470, 100, 30), Rect2(1030, 600, 210, 40)],
		"hazards": [Rect2(860, 160, 70, 280), Rect2(280, 635, 750, 25)]},
	]
