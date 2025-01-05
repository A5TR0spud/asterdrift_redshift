extends Sprite2D


func _process(delta):
	rotation += $"..".constant_angular_velocity * delta
