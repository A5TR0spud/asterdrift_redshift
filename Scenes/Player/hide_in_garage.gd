extends Node2D

@onready var Player: PlayerClass = $".."

func _ready():
	if Player.IS_IN_GARAGE:
		queue_free()
		hide()
	else:
		show()
