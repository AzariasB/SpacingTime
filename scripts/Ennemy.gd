extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum PATH_TYPE {
	SIMPLE,
	SINUSOIDAL,
	RANDOM
}
var path_type = PATH_TYPE.SIMPLE
var BORDERS
var f_path

onready var globals = get_tree().root.get_node("/root/globals")

func _ready():
	f_path = $Path2D/PathFollow2D
	BORDERS = globals.BORDERS
	$Path2D.curve = Curve2D.new()
	create_path()
	set_process(true)
	

func create_path():
	var starting_pos = Vector2()
	var ending_pos = Vector2()
	var is_vertical = (randi() % 2) == 1
	if is_vertical:
		var from_top = (randi() % 2) == 1
		starting_pos.x = rand_range(BORDERS.position.x, BORDERS.end.x)
		ending_pos.x = rand_range(BORDERS.position.x, BORDERS.end.x)
		starting_pos.y = BORDERS.position.y if from_top else BORDERS.end.y
		ending_pos.y = BORDERS.end.y if from_top else BORDERS.position.y
	else: 
		var from_left = (randi() % 2) == 1
		starting_pos.y = rand_range(BORDERS.position.y, BORDERS.end.y)
		ending_pos.y = rand_range(BORDERS.position.y, BORDERS.end.y)
		starting_pos.x = BORDERS.position.x if from_left else BORDERS.end.x
		ending_pos.x = BORDERS.end.x if from_left else BORDERS.position.x
	
	$Path2D/PathFollow2D.position = starting_pos
	$Path2D.curve.add_point(starting_pos)
	$Path2D.curve.add_point(ending_pos)	

func _physics_process(delta):
	if Input.is_action_pressed("time_travel") and globals.remaining_timecontrol > 0 and not globals.player_lost:
		var u_of = f_path.unit_offset - (delta / 10)
		f_path.unit_offset = max(0, u_of)
	else:
		f_path.unit_offset += (delta / 10)
	if f_path.unit_offset >= 1.0:
		get_parent().remove_child(self)