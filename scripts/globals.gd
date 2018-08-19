extends Node

signal score_changed
var BORDERS = Rect2(-1000, -500, 2000, 1000)
var score = 0 setget _set_score, _get_score
var remaining_timecontrol = 0
var player_lost = false

var cursor = load("res://images/ui/cursor_pointer3D.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	randomize()

func pos_outside():
	var spwn_side = randi() % 4
	match(spwn_side):
		0: return Vector2(BORDERS.position.x, rand_range(BORDERS.position.y, BORDERS.end.y))
		1: return Vector2(rand_range(BORDERS.position.x, BORDERS.end.x ), BORDERS.position.y )
		2: return Vector2(BORDERS.end.x, rand_range(BORDERS.position.y, BORDERS.end.y) )
		_: return Vector2(rand_range(BORDERS.position.x, BORDERS.end.x), BORDERS.end.y)
	
func pos_inside():
	return Vector2(
		rand_range(BORDERS.position.x, BORDERS.end.x),
		rand_range(BORDERS.position.y, BORDERS.end.y)
	)

func increment_score():
	_set_score(score + 1)

func _set_score(val):
	score = val
	self.emit_signal("score_changed", score)
	
func _get_score():
	return score