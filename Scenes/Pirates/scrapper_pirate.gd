extends PirateEntity

@export var MaxSpeed: float = 128.0

var prevVel: Vector2 = Vector2.RIGHT

func PhysicsProcess(delta):
	if linear_velocity.length() > 1:
		if absf(linear_velocity.angle_to(prevVel)) < deg_to_rad(90):
			rotation = lerp_angle(rotation, linear_velocity.angle() + deg_to_rad(90), delta)
		prevVel = linear_velocity
	
	linear_velocity *= maxf(1.0 - delta, 0)
	linear_velocity += faction_dir * 16.0 * delta
	linear_velocity -= linear_velocity.normalized() * 8.0 * delta
	
	TrackingArea.rotation = linear_velocity.angle() + deg_to_rad(90)
	
	var avoid: Vector2 = Vector2.ZERO
	for ent in GetTrackedEntities():
		var dir = ent.global_position - global_position
		var dist = dir.length()
		if dist < 0.001:
			continue
		if !ent.isResource:
			avoid -= dir.normalized() / dist
		else:
			avoid += dir.normalized() * 0.05
	linear_velocity += avoid.normalized() * 4.0
	
	if linear_velocity.length() > MaxSpeed:
		linear_velocity = linear_velocity.normalized() * MaxSpeed


func _on_body_entered(body: Node2D):
	if body is Collectable:
		body.queue_free()
