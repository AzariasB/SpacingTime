extends Node2D

enum POW_TYPE {
	POW_HEALTH,
	POW_BOOST	
}

var type = POW_HEALTH
var value = 10

export(Texture) var health_texture = null
export(Texture) var boost_texture = null

onready var globals = get_tree().root.get_node("/root/globals")

func _ready():
	if type == POW_HEALTH:
		$PowerupBody/Sprite.texture = health_texture
	else:
		$PowerupBody/Sprite.texture = boost_texture
	spawn()

func spawn():
	var from = globals.pos_outside()
	var to = globals.pos_outside()
	global_position = from
	var angle = to.angle_to_point(from)
	$PowerupBody.angular_velocity = rand_range(-PI, PI)
	$PowerupBody.linear_velocity = Vector2(cos(angle), sin(angle)) * rand_range(50, 100)