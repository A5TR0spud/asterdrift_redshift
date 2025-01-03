extends Node2D


func _ready():
	var newSize: Vector2i = Vector2i(960, 540)
	newSize.x = DataManager.Load("ResolutionX", newSize.x)
	newSize.y = DataManager.Load("ResolutionY", newSize.y)
	
	if DataManager.Load("ResolutionIndex", -1) == -1:
		newSize = Options.AdaptScreen()
	
	var root = get_tree().root
	root.content_scale_size = newSize
