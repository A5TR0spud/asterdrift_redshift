extends Sprite2D

var time : float = 0.0

func _ready():
	time = 0

func _process(delta):
	time += delta
	rotation_degrees = 5.0 * sin(time * 1.0)
	scale.x = 0.9820 + 0.025 * cos(time * 0.5)
	scale.y = 0.9820 + 0.025 * cos(time * 0.5)
