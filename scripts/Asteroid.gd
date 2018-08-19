extends RigidBody2D

var BORDERS
var global
var small = load("res://scenes/SmallAsteroid.tscn")
var puff = load("res://scenes/Puff.tscn")
var point = load("res://scenes/GainPoint.tscn")
onready var timer = null
onready var sound = get_tree().root.get_node("/root/Sounds")

func _ready():
	# Choose on which side to spawn, and where to go, and how to rotate
	BORDERS = get_tree().root.get_node("/root/globals").BORDERS
	global = get_tree().root.get_node("/root/globals")
	if name != "SmallAsteroidBody":
		spawn()
		timer = $Timer
		$Timer.connect("timeout", self, "_destroy_timer")
	set_process(true)
	self.connect("body_entered", self, "body_collide")

func body_collide(body):
	if body.name == "EnnemyBody":
		var  par = body.get_parent().get_parent().get_parent()
		par.get_parent().remove_child(par)
		var n_puff = puff.instance()
		n_puff.global_position = global_position
		get_tree().root.add_child(n_puff)
		sound.get_node("Ennemy").play()
		if not globals.player_lost:
			global.increment_score()
			sound.get_node("Point").play()
			var p = point.instance()
			p.global_position = global_position
			get_tree().root.add_child(p)
	elif "SimpleBullet" in body.name:
		body.get_parent().remove_child(body)
	explode()

func _destroy_timer():
	remove_child(timer)
	timer = null

func spawn():
	var from = globals.pos_outside()
	var to = globals.pos_outside()
	global_position = from
	var angle = to.angle_to_point(from)
	angular_velocity = rand_range(-PI, PI)
	linear_velocity = Vector2(cos(angle), sin(angle)) * rand_range(50, 100)


func _physics_process(delta):
	if timer == null and not BORDERS.has_point(global_position):
		var pool = get_parent().get_parent()
		pool.remove_child(get_parent())


func explode():
	var asteroids = get_parent().get_parent()
	print("---------")
	print(name)
	print(get_parent().name)
	print(asteroids.name)
	print("--------------")
	if name == "AsteroidBody":
		var a2 = small.instance()
		a2.global_position = global_position
		var a2Body = a2.get_node("SmallAsteroidBody")
		var angle = rand_range(0, 2 * PI)
		a2Body.linear_velocity = Vector2(cos(angle),sin(angle)) * rand_range(50,100)
		a2Body.angular_velocity = rand_range(0 , 2 * PI)
		asteroids.add_child(a2)
	asteroids.remove_child(get_parent())