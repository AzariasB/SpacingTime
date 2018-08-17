extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ennemy = load("res://scenes/Ennemy.tscn")

func _ready():
	$Timer.connect("timeout", self, "spawn_ennemy")

func spawn_ennemy():
	add_child(ennemy.instance())