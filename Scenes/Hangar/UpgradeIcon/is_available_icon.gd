@tool
extends Sprite2D

var time : float = 0.0

func _ready():
	time = 0

func _process(delta):
	time += delta
	rotation_degrees = 1 * sin(time * 1.0)
	scale.x = 0.975 + 0.05 * cos(time * 0.5)
	scale.y = 0.975 + 0.05 * cos(time * 0.5)
