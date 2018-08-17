extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var BORDERS = Rect2()

func _ready():
	BORDERS = get_tree().root.get_node("/root/globals").BORDERS
	set_process(true)
	
func _physics_process(delta):
	if not BORDERS.has_point(global_position):
		get_parent().remove_child(self)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
