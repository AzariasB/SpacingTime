extends CanvasLayer



func _ready():
	$Container/QuitButton.connect("pressed", get_tree(), "quit")
	$Container/PlayButton.connect("pressed", get_tree(), "change_scene", ["res://scenes/Main.tscn"])
	$Container/HelpButton.connect("pressed", get_tree(), "change_scene", ["res://scenes/Help.tscn"])