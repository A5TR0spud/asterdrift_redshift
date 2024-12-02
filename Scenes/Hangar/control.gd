extends Control


func _on_run_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/World.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")
