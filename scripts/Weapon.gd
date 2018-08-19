extends Node2D

var bullet_type = load("res://scenes/SimpleBullet.tscn")

var bullet_speed = 1000
var is_shooting = false

func _ready():
	$ResetTimer.connect("timeout", self, "try_shoot")
	$ResetTimer.start()

func try_shoot():
	if not is_shooting:
		$ResetTimer.stop()
		return
	get_tree().root.get_node("/root/Sounds/Shoot").play()
	var rot = get_global_transform().get_rotation() - PI / 2
	var bullet = bullet_type.instance()
	bullet.global_rotation = global_rotation
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(cos(rot), sin(rot)) * bullet_speed
	bullet.angular_velocity = 0
	get_tree().root.get_node("/root/Root").add_child(bullet)

func shoot():
	if $ResetTimer.is_stopped():
		$ResetTimer.start()
		try_shoot()
	is_shooting = true
	
func stop():
	is_shooting = false

