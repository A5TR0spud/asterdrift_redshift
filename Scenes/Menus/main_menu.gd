extends Node2D


func _ready():
	var newSize: Vector2 = Vector2(960, 540)
	newSize.x = DataManager.Load("ResolutionX", newSize.x)
	newSize.y = DataManager.Load("ResolutionY", newSize.y)
	
	if DataManager.Load("ResolutionIndex", -1) == -1:
		newSize = DisplayServer.screen_get_size() * 0.5
	
	var root = get_tree().root
	root.content_scale_size = newSize
		#ResourceLoader.load_threaded_request("res://Scenes/World/World.tscn")
	#ResourceLoader.load_threaded_request("res://Scenes/Menus/options.tscn")
	#ResourceLoader.load_threaded_request("res://Scenes/Garage/Garage.tscn")
