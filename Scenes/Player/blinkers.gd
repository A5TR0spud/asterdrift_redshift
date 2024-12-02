@tool
extends Sprite2D

@export var ON_COLOR : Color = Color(1, 0, 0)
@export var OFF_COLOR : Color
@export var INTERVAL : float = 1.0
@export var COLOR_INTERP : bool = false
var _time : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_time += delta / (INTERVAL * 0.5)
	_time = _time - 2.0 * floori(_time * 0.5)
	var x = absf(1.0 - _time)
	var y = x
	if (!COLOR_INTERP):
		y = 1 if x > 0.5 else 0
	self_modulate = lerp(OFF_COLOR, ON_COLOR, y)
