extends CanvasLayer


func _ready():
	$EndScreen/RestartButton.connect("pressed", get_tree(), "reload_current_scene")
	$EndScreen/MenuButton.connect("pressed", get_tree(), "change_scene", ["res://scenes/Menu.tscn"])