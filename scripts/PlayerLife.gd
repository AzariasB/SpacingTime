extends Node2D


export(bool) var tweening = true
export(float) var width = 10.0
export(float) var height = 10.0
export(Color) var inside_color = null
export(Color) var outline_color = null
export(Color) var secondary_color = null

var outline_rect = Rect2()
var lifebar_rect = Rect2()
var secondary_rect = Rect2()

var percentage = 1.0 setget _set_percentage, _get_percentage

var _tween = null
var _values = []

func _set_percentage(val):
	if not tweening:
		percentage = val
		_update_width(percentage * width)
		return
	
	_values.append(val)
	if _tween == null:
		_tween = Tween.new()
		_tween.connect("tween_completed", self, "_tween_completed")
		add_child(_tween)
		_tween_completed(null, ":_update_secondary")

func _get_percentage():
	return percentage

func _tween_completed(obj = null, path = null):
	if path != ":_update_secondary": return
	
	if _values.size() > 0:
		var next = _values.pop_front()
		percentage = next
		var target = width * percentage
		_tween.interpolate_method(self, "_update_width", lifebar_rect.size.x, target, 0.5,  Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		_tween.interpolate_method(self, "_update_secondary", lifebar_rect.size.x, target, 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		_tween.start()
	else:
		remove_child(_tween)
		_tween = null

func _update_secondary(size):
	secondary_rect.size.x =size
	update()

func _update_width(size):
	lifebar_rect.size.x = size
	update()

func _ready():
	outline_rect = Rect2(global_position - Vector2(1, 1), Vector2(width + 2, height + 2))
	lifebar_rect = Rect2(global_position, Vector2(width, height))
	secondary_rect = Rect2(global_position, Vector2(width, height))


func _draw():
	draw_rect(outline_rect, outline_color, false)
	if tweening:
		draw_rect(secondary_rect, secondary_color, true)
	draw_rect(lifebar_rect, inside_color, true)