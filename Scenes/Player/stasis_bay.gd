extends Node2D

@onready var Player := $".."

func _ready():
	if UpgradesManager.Load("StasisBay") < 1:
		hide()
		queue_free()
	else:
		show()

func _on_area_2d_body_exited(body: Node2D):
	_tryCaptureResource(body)

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Entity:
			if body.isResource:
				var x: Vector2 = -body.linear_velocity + Player.linear_velocity
				var dirToCenter: Vector2 = body.global_position - global_position
				dirToCenter = -dirToCenter.normalized() * 2
				x = x.normalized() * 1
				body.apply_force(x + dirToCenter)

func _tryCaptureResource(body: Node2D) -> void:
	if body is Entity:
		if body.isResource:
			var dirToCenter: Vector2 = body.global_position - global_position
			dirToCenter = -dirToCenter.normalized() * 8
			body.linear_velocity = Player.linear_velocity + dirToCenter
