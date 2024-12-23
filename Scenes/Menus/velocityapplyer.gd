extends Node2D


func _ready():
	for child in $List.get_children():
		if child is RigidBody2D:
			var dir: Vector2 = Vector2.RIGHT.rotated(deg_to_rad(360) * randf())
			var scalar: float = randf() * randf() * 64.0
			var vel: Vector2 = dir * scalar
			child.linear_velocity = vel
			child.rotation = randf() * 360.0
			child.angular_velocity = deg_to_rad(randf_range(-180, 180)) * randf()


func _on_area_2d_body_exited(body: Node2D):
	var rad: float = 0.0
	if body is Entity:
		rad = body.Radius
	
	if body.global_position.y < 0:
		body.global_position.y += 540 + rad * 2 + 5
	elif body.global_position.y > 540:
		body.global_position.y -= 540 + rad * 2 + 5
	if body.global_position.x < 0:
		body.global_position.x += 960 + rad * 2 + 5
	elif body.global_position.x > 960:
		body.global_position.x -= 960 + rad * 2 + 5
