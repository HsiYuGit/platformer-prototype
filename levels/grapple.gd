extends RefCounted

const ID = "grapple"
const TITLE = "GRAPPLE PULL"
const SUMMARY = "Choose visible anchors; pull, release and reconnect."
const ABILITY = preload("res://abilities/grapple.gd")
const CONTROLS = "A/D: face / move | SPACE: jump | Hold X/SHIFT: pull to highlighted anchor | Release + press: reconnect"

static func rooms() -> Array:
	return [
		{"name": "One anchor", "question": "Reach: use an overhead anchor to cross a gap beyond jump range.",
		"hint": "Walk near the edge until the gold target highlights. Hold X to pull; release and move right to land.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 480, 50, 70),
		"platforms": [Rect2(40, 600, 260, 40), Rect2(740, 550, 500, 90)],
		"anchors": [Vector2(620, 300)], "hazards": [Rect2(300, 635, 440, 25)]},
		{"name": "Anchor chain", "question": "Sequence: connect two anchors without touching the ground.",
		"hint": "Reach the first anchor, release X, then press again to select the next highlighted anchor.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 530, 50, 70),
		"platforms": [Rect2(40, 600, 210, 40), Rect2(930, 600, 310, 40)],
		"anchors": [Vector2(450, 320), Vector2(800, 280)], "hazards": [Rect2(250, 635, 680, 25)]},
		{"name": "Blocked sight", "question": "Routing: solid walls block targeting, so approach from above.",
		"hint": "The far anchor is behind a wall. Use the high anchor first, then reconnect over the wall.",
		"spawn": Vector2(80, 580), "exit": Rect2(1150, 510, 50, 70),
		"platforms": [Rect2(40, 600, 260, 40), Rect2(560, 360, 60, 280), Rect2(900, 580, 340, 60)],
		"anchors": [Vector2(470, 260), Vector2(770, 310)], "hazards": [Rect2(300, 635, 260, 25), Rect2(620, 635, 280, 25)]},
	]
