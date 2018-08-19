extends RigidBody2D

export(int) var rotation_speed = 200
export(int) var move_speed = 2000
export(float) var invincible_time = 2.0
export(float)var max_health = 100.0
export(float)var max_time_control = 100.0
export(float) var max_boost = 100.0

var input_rotation = 0
var speed_multiplier = 1
var globals
var time_control = max_time_control
var tween_values = [Color(1,1,1,1), Color(1,0,0,0.5)]
var flipped = false

onready var cam = $Camera2D
onready var tween = $Tween
onready var dead_particles = get_node("../DeadExplosion")
onready var health = max_health
onready var boost = max_boost
onready var HUD = get_node("../../PlayerHUD")
onready var sounds = get_tree().root.get_node("/root/Sounds")


var invicible_timer = null

func _ready():
	globals = get_tree().root.get_node("/root/globals")
	set_process(true)
	sounds.get_node("Engine").play()


func _lost():
	globals.player_lost = true
	HUD.get_node("EndScreen").visible = true
	sounds.get_node("Engine").stop()
	sounds.get_node("Lost").play()
	dead_particles.visible = true
	dead_particles.global_position = get_global_transform_with_canvas().origin
	dead_particles.emitting = true
	get_parent().remove_child(self)

func _add_boost(add_b):
	if add_b == 0: return boost <= 0
	boost = clamp(boost + add_b, 0, max_boost)
	HUD.get_node("Boost").percentage = boost / max_boost
	return boost <= 0

func get_input(dt):
	if Input.is_action_pressed("ui_left"):
		input_rotation = -1
	elif Input.is_action_pressed("ui_right"):
		input_rotation = 1
	else:
		input_rotation = 0
	
	var animation = "default"
	var boost_multiplier = 0.5
	if Input.is_action_pressed("ui_up") and boost > 0:
		animation = "accelerate"
		speed_multiplier = 1.5
	elif Input.is_action_pressed("ui_down") and boost > 0:
		speed_multiplier = 1/1.5
		animation = "deccelerate"
	else:
		boost_multiplier = 0
		speed_multiplier = 1
	_add_boost(-1 * boost_multiplier)
	$Sprite/LeftPropeller.play(animation)
	$Sprite/RightPropeller.play(animation)
	
	if Input.is_action_pressed("ui_select"):
		$Sprite/LeftWeapon.shoot()
		$Sprite/RightWeapon.shoot()
	else:
		$Sprite/LeftWeapon.stop()
		$Sprite/RightWeapon.stop()
		
	
func _physics_process(delta):
	get_input(delta)
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
		_process_hit(bodies[0])

func _add_health(add):
	if add == 0: return health <= 0
	health = clamp(health + add, 0, max_health)
	HUD.get_node("Health").percentage = health / max_health
	
	if health <= 0:
		_lost()
		return false
		
	return true

func _process_hit(body):
	if body.name == "AsteroidBody" and not _add_health(-10):
		return
	elif body.name == "EnnemyBody" and not _add_health(-20):
		return
	elif body.name == "SmallAsteroidBody" and not _add_health(-5):
		return
	elif body.name == "PowerupBody":
		_collect_powerup(body)
		return
	
	sounds.get_node("Hit").play()
	$Area2D/CollisionPolygon2D2.disabled = true
	invicible_timer = Timer.new()
	invicible_timer.wait_time = invincible_time
	invicible_timer.one_shot = true
	invicible_timer.connect("timeout", self, "end_invincibility")
	invicible_timer.start()
	add_child(invicible_timer)
	_start_tween()
	tween.connect("tween_completed", self, "_start_tween")

func _collect_powerup(body):
	sounds.get_node("Powerup").play()
	var powerup = body.get_parent()
	var b_type = powerup.type
	if b_type == powerup.POW_HEALTH:
		_add_health(powerup.value)
	elif b_type == powerup.POW_BOOST:
		_add_boost(powerup.value)
	powerup.get_parent().remove_child(powerup)
	

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