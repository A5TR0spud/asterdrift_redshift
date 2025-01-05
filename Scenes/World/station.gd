extends StaticBody2D

func _ready():
	if Engine.is_editor_hint():
		return
	rotation_degrees = 12.5
	if UpgradesManager.Load("Borealis") < 1:
		hide()
		queue_free()
	else:
		show()
