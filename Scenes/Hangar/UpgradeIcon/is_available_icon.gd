@tool
extends Sprite2D

var time : float = 0.0

func _ready():
	time = 0

func _process(delta):
	time += delta
	rotation_degrees = 15 * sin(time * 1.0)
	scale.x = 1.15 + 0.3 * cos(time * 0.5)
	scale.y = 1.15 + 0.3 * cos(time * 0.5)
