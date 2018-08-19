extends Node

export(float) var max_timecontrol = 1000.0

onready var timecontrol = max_timecontrol
onready var globals = get_tree().root.get_node("/root/globals")

func _ready():
	set_process(true)
	
func _process(delta):
	var old_tc = timecontrol

	if Input.is_action_pressed("time_travel"):
		timecontrol = max(0, timecontrol - delta * 20)
		$TimeCooldown.stop()
		$TimeCooldown.start()
	
	if $TimeCooldown.is_stopped():
		timecontrol = min(max_timecontrol, timecontrol + delta * 5)

	globals.remaining_timecontrol = timecontrol
	if timecontrol != old_tc:
		$PlayerHUD/TimeControl.percentage = timecontrol / max_timecontrol