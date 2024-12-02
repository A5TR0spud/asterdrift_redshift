extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Hangar/hangar.tscn")


func _on_garage_pressed():
	get_tree().change_scene_to_file("res://Scenes/Garage/Garage.tscn")


func _on_options_pressed():
	pass


func _on_quit_pressed():
	get_tree().quit()
