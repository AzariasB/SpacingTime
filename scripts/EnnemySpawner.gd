extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var asteroid = load("res://scenes/Asteroid.tscn")
var ennemy = load("res://scenes/Ennemy.tscn")

func _ready():
	$UfoTimer.connect("timeout", self, "spawn_ennemy")
	$AsteroidTimer.connect("timeout", self, "spawn_asteroid")

func spawn_ennemy():
	$Ennemies.add_child(ennemy.instance())
	
func spawn_asteroid():
	$Asteroids.add_child(asteroid.instance())