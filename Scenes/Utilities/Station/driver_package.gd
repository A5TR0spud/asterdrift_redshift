@tool
extends Sprite2D
class_name DriverCanister

@export var Type: Materials.Mats = Materials.Mats.Synthetics:
	get:
		return Type
	set(value):
		Type = value
		if is_node_ready():
			_reload()

var _time: float = 0.0
const _speed: float = 518.0
var _start: Vector2
var _end: Node2D

func _reload() -> void:
	var te: AtlasTexture = texture
	if Type == Materials.Mats.Ceramics:
		te.region.position = Vector2(0, 0)
	elif Type == Materials.Mats.Organics:
		te.region.position = Vector2(9, 0)
	elif Type == Materials.Mats.Metals:
		te.region.position = Vector2(0, 14)
	elif Type == Materials.Mats.Synthetics:
		te.region.position = Vector2(9, 14)
	else:
		te.region.position = Vector2(18, 0)
	
func _ready() -> void:
	_reload()
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
