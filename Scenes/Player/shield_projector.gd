extends Area2D

@onready var Player := $".."
@onready var Sprite := $BounceShield

var _time: float = 5.0
var _Duration: float = 0.2
var _trackedObjects: Array[Entity] = []

func _ready():
	if UpgradesManager.Load("EnergyShield") < 1:
		queue_free()
		return
	else:
		show()
	_time = 5.0
	_trackedObjects = []

func _on_body_entered(body):
	if !Player.CAN_MOVE:
		return
	
	if body is Entity:
		if body.DangerousCollision:
			var dxy: Vector2 = body.linear_velocity
			var dir: Vector2 = body.global_position - global_position
			dir = dir.normalized()
			var tar: Vector2 = dir * (Player.MAX_SPEED + 1)
			body.linear_velocity = tar
			# 0.0625 = 1/16
			# * 0.01 for asteroid mass
			RunHandler.TimeLeft -= dxy.distance_to(tar) * body.mass * 0.000625
			_time = 0.0

func _process(delta):
	if _time < _Duration:
		Sprite.show()
		var scalar: float = _time / _Duration * 0.2 + 0.9
		var alpha: float = 1 - _time / _Duration
		Sprite.scale = Vector2(scalar, scalar)
		Sprite.modulate.a = alpha
	else:
		Sprite.hide()
	_time += delta
