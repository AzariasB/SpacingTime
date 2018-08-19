extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var asteroid = load("res://scenes/Asteroid.tscn")
var ennemy = load("res://scenes/Ennemy.tscn")
var powerup = load("res://scenes/Powerup.tscn")

export(Texture) var health_texture = null
export(Texture) var boost_texture  = null

func _ready():
	$UfoTimer.connect("timeout", self, "spawn_ennemy")
	if get_node("AsteroidTimer") != null:
		$AsteroidTimer.connect("timeout", self, "spawn_asteroid")
	if get_node("Powerupstimer") != null:
		$PowerupsTimer.connect("timeout", self, "spawn_powerup")

func spawn_ennemy():
	$Ennemies.add_child(ennemy.instance())
	
func spawn_asteroid():
	$Asteroids.add_child(asteroid.instance())
	
	
func spawn_powerup():
	var type = randi() % 2
	var p_instance = powerup.instance()

	if type == 0:
		p_instance.type = p_instance.POW_HEALTH
	else:
		p_instance.type = p_instance.POW_BOOST
	$Powerups.add_child(p_instance)