extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$MenuButton.connect("pressed", get_tree(), "change_scene", ["res://scenes/Menu.tscn"])
	$Screen1/NextButton.connect("pressed", self, "toggle_help")
	$Screen2/PreviousButton.connect("pressed", self, "toggle_help")

func toggle_help():
	if $Screen1.visible:
		$Screen1.visible = false
		$Screen2.visible = true
	else:
		$Screen2.visible = false
		$Screen1.visible = true