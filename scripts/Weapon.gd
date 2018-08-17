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
	var rot = get_parent().rotation
	var bullet = bullet_type.instance()
	bullet.position = position
	bullet.linear_velocity = Vector2(cos(rot), sin(rot)) * bullet_speed
	bullet.angular_velocity = 0
	add_child(bullet)

func shoot():
	if $ResetTimer.is_stopped():
		$ResetTimer.start()
		try_shoot()
	is_shooting = true
	
func stop():
	is_shooting = false

