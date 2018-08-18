extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(int) var rotation_speed = 200
export(int) var move_speed = 2000
export(float) var invincible_time = 2.0
export(float)var max_health = 100

var input_rotation = 0
var speed_multiplier = 1
var globals
var health = max_health
var tween_values = [Color(1,1,1,1), Color(1,0,0,0.5)]
var flipped = false

onready var cam = $Camera2D
onready var tween = $Tween

var invicible_timer = null

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
	
	if invicible_timer != null: return
	
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() > 0:
		hit_by_spaceship()


func hit_by_spaceship():
		health -= 10
		# update life display
		$Area2D/CollisionPolygon2D2.disabled = true
		invicible_timer = Timer.new()
		invicible_timer.wait_time = invincible_time
		invicible_timer.one_shot = true
		invicible_timer.connect("timeout", self, "end_invincibility")
		invicible_timer.start()
		add_child(invicible_timer)
		_start_tween()
		tween.connect("tween_completed", self, "_start_tween")

func _start_tween(a= null, b = null):
	if invicible_timer == null:
		$Sprite.modulate = tween_values[0]
		flipped = false
	else:
		var c1 = tween_values[1] if flipped else tween_values[0]
		var c2 = tween_values[0] if flipped else tween_values[1]
		tween.interpolate_property($Sprite, "modulate", c1, c2 ,0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		flipped = not flipped

func end_invincibility():
	if invicible_timer != null:
		$Area2D/CollisionPolygon2D2.disabled = false
		remove_child(invicible_timer)
	invicible_timer = null
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
