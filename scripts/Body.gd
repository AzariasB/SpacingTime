extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var rotation_speed = 200
export(int) var move_speed = 2000
var input_rotation = 0
var speed_multiplier = 1
onready var cam = $Camera2D
var globals

func _ready():
	globals = get_tree().root.get_node("/root/globals")
	#cam.limit_left = globals.BORDERS.position.x
	#cam.limit_right = globals.BORDERS.end.x
	#cam.limit_top = globals.BORDERS.position.y
	#cam.limit_bottom = globals.BORDERS.end.y
	set_process(true)

func get_input():
	if Input.is_action_pressed("ui_left"):
		input_rotation = -1
	elif Input.is_action_pressed("ui_right"):
		input_rotation = 1
	else:
		input_rotation = 0
	
	var animation = "default"
	if Input.is_action_pressed("ui_up"):
		animation = "accelerate"
		speed_multiplier = 1.5
	elif Input.is_action_pressed("ui_down"):
		speed_multiplier = 1/1.5
		animation = "deccelerate"
	else:
		speed_multiplier = 1
	
	$Sprite/LeftPropeller.play(animation)
	$Sprite/RightPropeller.play(animation)
	
	"""if Input.is_action_pressed("ui_select"):
		$Sprite/LeftWeapon.shoot()
		$Sprite/RightWeapon.shoot()
	else:
		$Sprite/LeftWeapon.stop()
		$Sprite/RightWeapon.stop()
	"""
		
	
func _physics_process(delta):
	get_input()
	if input_rotation != 0:
		angular_velocity = input_rotation * rotation_speed * delta
	linear_velocity = Vector2(cos(rotation), sin(rotation)) * delta * move_speed * speed_multiplier
	
	var c_pos = cam.get_camera_position()
	if c_pos.y < cam.limit_top:
		position.y = cam.limit_bottom
	elif c_pos.y > cam.limit_bottom:
		position.y = cam.limit_top
		
	if c_pos.x < cam.limit_left + 50:
		position.x = cam.limit_right
	elif c_pos.x > cam.limit_right - 50:
		position.x = cam.limit_left

	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
