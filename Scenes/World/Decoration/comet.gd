extends Mineable
class_name Comet


func _ready():
	Health = MaxHealth

func _on_resource_mined(_global_pos):
	if ResourcesLeft < 1:
		Kill()


func _on_killed():
	if ResourcesLeft > 1:
		Mine(global_position, 1)
	queue_free()


func _on_body_entered(body):
	if body is not Entity:
		return
	var other: Entity = body
	var blunt: float = 0.05 * maxf(other.mass - self.mass, other.mass) * (self.linear_velocity - other.linear_velocity).length()
	var abrasion: float = 0.4 * absf(self.mass * self.angular_velocity + other.mass * other.angular_velocity)
	
	var abrasionResistance = 0.9
	var bluntResistance = 0.1
	var grace = -10
	
	var ddd = (blunt / bluntResistance) + (abrasion / abrasionResistance) - grace
	if ddd > 0:
		Damage(ddd)
