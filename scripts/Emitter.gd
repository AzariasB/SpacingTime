extends Particles2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(GradientTexture) var defaultcolor = null
export(GradientTexture) var accelerateColor = null
export(GradientTexture) var deccelerateColor = null

func _ready():
	print(process_material)
	
func accelerate():
	process_material.color_ramp = accelerateColor
	
func deccelerate():
	process_material.color_ramp = deccelerateColor

func stop():
	process_material.color_ramp = defaultcolor

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
