extends RefCounted

const ID = "wall_jump"
const TITLE = "WALL JUMP"
const SUMMARY = "Use walls as footholds: climb, alternate, transfer."
const ABILITY = preload("res://abilities/wall_jump.gd")
const CONTROLS = "A/D: move / push into wall | SPACE: ground jump | X/SHIFT: wall kick | F1-F3: checkpoints"

static func rooms() -> Array:
	return [
		{"name": "Single wall", "question": "Climb: can repeated kicks turn a tall wall into a route?",
		"hint": "Jump against the wall, tap X, then steer back into it. Repeat to climb.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 310, 50, 70),
		"platforms": [Rect2(40, 600, 410, 40), Rect2(450, 380, 790, 260)], "hazards": []},
		{"name": "Narrow shaft", "question": "Alternate: trade horizontal control for height between two walls.",
		"hint": "Jump into the right wall. Kick left, reach the left wall, then kick right.",
		"spawn": Vector2(500, 590), "exit": Rect2(1160, 210, 50, 70),
		"platforms": [Rect2(400, 160, 840, 20), Rect2(400, 200, 30, 440), Rect2(430, 610, 150, 30), Rect2(580, 280, 660, 360)], "hazards": []},
		{"name": "Wall transfer", "question": "Transfer: combine wall kicks and ledge jumps on stepped walls.",
		"hint": "Climb the first wall, use its top to approach the second, then kick up again.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 270, 50, 70),
		"platforms": [Rect2(40, 600, 330, 40), Rect2(370, 460, 70, 180), Rect2(555, 340, 685, 300)],
		"hazards": [Rect2(440, 635, 115, 25)]},
	]

