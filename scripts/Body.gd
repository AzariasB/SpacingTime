extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var rotation_speed = 200
export(int) var move_speed = 2000
var input_rotation = 0
var speed_multiplier = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
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
	
	$LeftPropeller.play(animation)
	$RightPropeller.play(animation)
	
	if Input.is_action_pressed("ui_select"):
		$LeftWeapon.shoot()
		$RightWeapon.shoot()
	else:
		$LeftWeapon.stop()
		$RightWeapon.stop()
		
	
func _physics_process(delta):
	get_input()
	if input_rotation != 0:
		angular_velocity = input_rotation * rotation_speed * delta
	linear_velocity = Vector2(cos(rotation), sin(rotation)) * delta * move_speed * speed_multiplier


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
