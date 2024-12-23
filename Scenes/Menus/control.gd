extends Control


func _on_play_pressed():
	#get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://Scenes/Hangar/hangar.tscn"))
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")
	#get_tree().change_scene_to_packed(HangarThing)


func _on_garage_pressed():
	get_tree().change_scene_to_file("res://Scenes/Garage/Garage.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/options.tscn")


func _on_quit_pressed():
	get_tree().quit()
