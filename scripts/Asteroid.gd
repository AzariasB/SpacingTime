extends RigidBody2D

var BORDERS
var global
var small = load("res://scenes/SmallAsteroid.tscn")
var puff = load("res://scenes/Puff.tscn")
onready var timer = $Timer


func _ready():
	# Choose on which side to spawn, and where to go, and how to rotate
	BORDERS = get_tree().root.get_node("/root/globals").BORDERS
	global = get_tree().root.get_node("/root/globals")
	if name != "SmallAsteroidBody":
		spawn()
	set_process(true)
	self.connect("body_entered", self, "body_collide")

func body_collide(body):
	if body.name == "EnnemyBody":
		var  par = body.get_parent().get_parent().get_parent()
		print(par.name)
		par.get_parent().remove_child(par)
		var n_puff = puff.instance()
		n_puff.global_position = global_position
		global.increment_score()
		get_tree().root.add_child(n_puff)
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
		get_parent().remove_child(self)


func explode():
	if name == "AsteroidBody":
		var a2 = small.instance()
		a2.global_position = global_position
		var a2Body = a2.get_node("SmallAsteroidBody")
		var angle = rand_range(0, 2 * PI)
		a2Body.linear_velocity = Vector2(cos(angle),sin(angle)) * 20
		a2Body.angular_velocity = rand_range(0 , 2 * PI)
		get_parent().add_child(a2)
	get_parent().remove_child(self)