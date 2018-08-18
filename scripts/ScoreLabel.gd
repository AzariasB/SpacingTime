extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var globals  = get_tree().root.get_node("/root/globals")
	globals.connect("score_changed", self, "_update_score")

func _update_score(score):
	text = str(score)