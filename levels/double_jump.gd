extends RefCounted

const ID = "double_jump"
const TITLE = "DOUBLE JUMP"
const SUMMARY = "Spend one extra jump on height, distance or timing."
const ABILITY = preload("res://abilities/double_jump.gd")
const CONTROLS = "A/D: move | SPACE: ground jump | X/SHIFT: one air jump | Land to refill | F1-F3: checkpoints"

static func rooms() -> Array:
	return [
		{"name": "High ledge", "question": "Height: can a second jump reach a ledge above the normal jump arc?",
		"hint": "Jump near the edge, then press X near the top of your first jump.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 400, 50, 70),
		"platforms": [Rect2(40, 600, 360, 40), Rect2(470, 470, 770, 170)],
		"hazards": [Rect2(400, 635, 70, 25)]},
		{"name": "Long gap", "question": "Distance: delay the second jump to extend your time in the air.",
		"hint": "Keep moving right. Spend the air jump just after the first apex.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 600, 320, 40), Rect2(640, 600, 600, 40)],
		"hazards": [Rect2(360, 635, 280, 25)]},
		{"name": "Late recovery", "question": "Timing: save the air jump until you have passed the low ceiling.",
		"hint": "Walk off the ledge, pass under the overhang, then press X to recover onto the far platform.",
		"spawn": Vector2(80, 430), "exit": Rect2(1150, 470, 50, 70),
		"platforms": [Rect2(40, 450, 360, 30), Rect2(330, 350, 180, 60), Rect2(610, 540, 630, 100)],
		"hazards": [Rect2(400, 635, 210, 25)]},
	]
