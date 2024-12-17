extends Node2D

@onready var Player := $".."

func _ready():
	if UpgradesManager.Load("StasisBay") < 1:
		hide()
		queue_free()
	else:
		show()

func _on_area_2d_body_exited(body: Node2D):
	if Player.CAN_MOVE:
		_tryCaptureResource(body)

func _physics_process(delta):
	if !Player.CAN_MOVE || Player.IS_IN_GARAGE:
		hide()
		return
	
	for body in $Area2D.get_overlapping_bodies():
		if body is Entity:
			if body.isResource:
				var x: Vector2 = -body.linear_velocity + Player.linear_velocity
				x = x.normalized()
				if UpgradesManager.Load("TractorBay") > 0:
					var dirToCenter: Vector2 = body.global_position - global_position
					dirToCenter = -dirToCenter.normalized() * 2
					x += dirToCenter
				body.apply_force(x)

func _tryCaptureResource(body: Node2D) -> void:
	if body is Entity:
		if body.isResource:
			var dirToCenter: Vector2 = body.global_position - global_position
			dirToCenter = -dirToCenter.normalized()
			if UpgradesManager.Load("BetterBay") > 0:
				body.linear_velocity = (Player.GetCurrentMaxSpeed() + 1) * dirToCenter + Player.linear_velocity
			else:
				body.linear_velocity = Player.linear_velocity + dirToCenter * 8
