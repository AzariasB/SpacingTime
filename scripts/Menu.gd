extends CanvasLayer



func _ready():
	$Container/QuitButton.connect("pressed", get_tree(), "quit")
	$Container/PlayButton.connect("pressed", self, "_start")
	$Container/HelpButton.connect("pressed", get_tree(), "change_scene", ["res://scenes/Help.tscn"])

func _start():
	get_tree().root.get_node("/root/Sounds/Start").play()
	get_tree().change_scene("res://scenes/Main.tscn")