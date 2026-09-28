extends RefCounted

const ID = "gravity_flip"
const TITLE = "GRAVITY FLIP"
const SUMMARY = "Read the ceiling as a floor; reverse to choose a route."
const ABILITY = preload("res://abilities/gravity_flip.gd")
const CONTROLS = "A/D: move | SPACE: jump away from current floor | X/SHIFT: reverse gravity | F1-F3: checkpoints"

static func rooms() -> Array:
	return [
		{"name": "Ceiling bridge", "question": "Inversion: turn an overhead surface into a bridge across the pit.",
		"hint": "Stand under the ceiling before flipping. Walk along its underside, then flip down near the exit.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 600, 240, 40), Rect2(200, 200, 850, 30), Rect2(960, 600, 280, 40)],
		"hazards": [Rect2(280, 635, 680, 25)]},
		{"name": "Alternating", "question": "Route planning: alternate surfaces to avoid floor and ceiling hazards.",
		"hint": "Pass the first red block on the ceiling. Stop in the middle gap, flip down, then pass under the next.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 600, 1200, 40), Rect2(40, 180, 1200, 20)],
		"hazards": [Rect2(360, 420, 160, 180), Rect2(720, 200, 180, 260)]},
		{"name": "Broken ceiling", "question": "Transfers: switch between separated ceiling slabs and an intermediate floor.",
		"hint": "Use the first ceiling, flip down onto the middle island, then flip up toward the second ceiling.",
		"spawn": Vector2(80, 580), "exit": Rect2(1160, 530, 50, 70),
		"platforms": [Rect2(40, 600, 240, 40), Rect2(220, 220, 310, 30), Rect2(550, 530, 180, 30), Rect2(780, 290, 270, 30), Rect2(1080, 600, 160, 40)],
		"hazards": [Rect2(280, 635, 800, 25)]},
	]
