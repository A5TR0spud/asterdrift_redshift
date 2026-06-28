extends Sprite2D
class_name DriverCanister

var _time: float = 0.0
const _speed: float = 518.0
var _start: Vector2
var _end: Node2D

func _ready() -> void:
	hide()

func OffsetBeginning(amount: Vector2) -> void:
	_start += amount
	_setAlongPath()

func Dispatch(start: Vector2, end: Node2D) -> void:
	_time = 0.0
	_start = start
	_end = end
	_setAlongPath()
	show()

func _physics_process(delta: float) -> void:
	_time += delta
	_setAlongPath()

func _setAlongPath() -> void:
	var end: Vector2 = _end.global_position
	var dist: float = _start.distance_to(end)
	var t: float = _time * _speed / dist
	if t >= 1.0:
		hide()
		queue_free()
	else:
		rotation = _start.angle_to_point(end) + 1.57079632679
		global_position = _start * (1.0 - t) + end * t
