extends Node2D

var finished = 0

func _ready():
	$PositionTween.connect("tween_completed",self, "_finished")
	var mod = $Numeral.modulate
	var cp = mod
	cp.a = 0
	$PositionTween.interpolate_property($Numeral, "position", Vector2(0, 0), Vector2(0, -50), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$PositionTween.interpolate_property($Numeral, "modulate", mod, cp, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$PositionTween.start()
	
func _finished(a,b):
	finished += 1
	if finished == 2:
		get_parent().remove_child(self)