extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(SpriteFrames) var accelerate_frames = null
export(SpriteFrames) var deccelerate_frames = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func accelerate():
	visible = true
	frames = accelerate_frames
	play()
	
func stop():
	visible = false

func deccelerate():
	visible = true
	frames = deccelerate_frames
