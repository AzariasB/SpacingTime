extends Node

signal score_changed
var BORDERS = Rect2(-1000, -500, 2000, 1000)
var score = 0 setget _set_score, _get_score

func increment_score():
	_set_score(score + 1)

func _set_score(val):
	score = val
	self.emit_signal("score_changed", score)
	
func _get_score():
	return score