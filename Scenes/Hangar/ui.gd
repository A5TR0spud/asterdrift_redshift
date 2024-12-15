extends CanvasLayer


func _ready():
	if !Engine.is_editor_hint():
		show()
