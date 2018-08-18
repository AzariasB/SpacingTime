extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.connect("animation_finished", self, "_remove_self")
	playing = true

func _remove_self():
	get_parent().remove_child(self)