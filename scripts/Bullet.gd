extends RigidBody2D


var BORDERS = Rect2()

func _ready():
	BORDERS = get_tree().root.get_node("/root/globals").BORDERS
	set_process(true)
	
func _physics_process(delta):
	if not BORDERS.has_point(global_position):
		get_parent().remove_child(self)