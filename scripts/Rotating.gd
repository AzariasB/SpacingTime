extends Sprite


func _ready():
	set_process(true)

func _process(delta):
	global_rotation += delta