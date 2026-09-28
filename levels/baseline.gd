extends RefCounted

const ID = "baseline"
const TITLE = "BASELINE"
const SUMMARY = "Calibrate movement and variable jump height."
const ABILITY = null
const CONTROLS = "Move: A / D or arrows     Jump: hold SPACE, release to cut height"

static func rooms() -> Array:
	return [{
		"name": "Basic crossing", "question": "Get comfortable with acceleration and jump height.",
		"hint": "Jump from the edge. Reach the green exit on the right.",
		"spawn": Vector2(90, 580), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 600, 470, 40), Rect2(610, 600, 630, 40)],
		"hazards": [Rect2(510, 635, 100, 25)],
	}]
