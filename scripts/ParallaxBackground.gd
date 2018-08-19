extends ParallaxBackground

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	
func _process(delta):
	$ParallaxLayer2.motion_offset.x += delta * 50