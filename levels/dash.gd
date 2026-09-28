extends RefCounted

const ID = "dash"
const TITLE = "DASH"
const SUMMARY = "Charges x activation: single, double, airborne chain."
const ABILITY = preload("res://abilities/dash.gd")
const CONTROLS = "A/D + SPACE | X/SHIFT: dash | C: 1/2/3 charges | V: ground+air / air-only | F1-F3: checkpoints"

static func rooms() -> Array:
	return [
		{"name": "Single dash", "question": "One charge: extend a jump across a wide gap.",
		"hint": "Jump near the edge, dash near the top. C / V change rules on this same layout.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"dash_charges": 1, "dash_air_only": false,
		"platforms": [Rect2(40, 600, 320, 40), Rect2(640, 600, 600, 40)],
		"hazards": [Rect2(360, 635, 280, 25)]},
		{"name": "Double dash", "question": "Two charges: budget both bursts before landing on a small island.",
		"hint": "Release X between bursts. Dash twice in the first gap, land to refill, then repeat.",
		"spawn": Vector2(80, 580), "exit": Rect2(1160, 530, 50, 70),
		"dash_charges": 2, "dash_air_only": false,
		"platforms": [Rect2(40, 600, 260, 40), Rect2(735, 600, 100, 40), Rect2(1090, 600, 150, 40)],
		"hazards": [Rect2(300, 635, 435, 25), Rect2(835, 635, 255, 25)]},
		{"name": "Air-only chain", "question": "Three charges + air-only: jump first, then chain across a long pit.",
		"hint": "X on the floor does nothing. Keep each burst separate; all charges return on landing.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"dash_charges": 3, "dash_air_only": true,
		"platforms": [Rect2(40, 600, 240, 40), Rect2(895, 600, 345, 40)],
		"hazards": [Rect2(280, 635, 615, 25)]},
	]
