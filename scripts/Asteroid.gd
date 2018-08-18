extends RigidBody2D

var BORDERS
var small = load("res://scenes/SmallAsteroid.tscn")
var puff = load("res://scenes/Puff.tscn")

func _ready():
	# Choose on which side to spawn, and where to go, and how to rotate
	BORDERS = get_tree().root.get_node("/root/globals").BORDERS
	if name != "SmallAsteroidBody":
		spawn_inside(BORDERS)
	set_process(true)
	self.connect("body_entered", self, "body_collide")

func body_collide(body):
	if body.name == "EnnemyBody":
		var  par = body.get_parent().get_parent().get_parent()
		par.get_parent().remove_child(par)
		var n_puff = puff.instance()
		n_puff.global_position = global_position
		get_tree().root.add_child(n_puff)
	elif "SimpleBullet" in body.name:
		body.get_parent().remove_child(body)
	print(body.name)
	explode()

func spawn_inside(borders):
	var x_pos = rand_range(BORDERS.position.x, BORDERS.end.x)
	var y_pos = rand_range(BORDERS.position.y, BORDERS.end.y)
	global_position = Vector2(x_pos, y_pos)
	
	angular_velocity = rand_range(0, 2 * PI) + 0.1
	
	var angle = rand_range(0, 2 * PI)
	linear_velocity = Vector2(cos(angle), sin(angle)) * 20
	

func _physics_process(delta):
	if not BORDERS.has_point(global_position):
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