extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(Texture) var accelerate_texture = null
export(Texture) var deccelerate_texture = null


func accelerate():
	texture = accelerate_texture
	visible = true
	
func deccelerate():
	texture = deccelerate_texture
	visible = true

func disable():
	visible = false