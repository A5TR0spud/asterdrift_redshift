extends Node2D
class_name Options

var selIndex: int = 1
var Resolution: Vector2 = Vector2(960, 540)

func _ready():
	selIndex = DataManager.Load("ResolutionIndex", selIndex)
	Resolution.x = DataManager.Load("ResolutionX", Resolution.x)
	Resolution.y = DataManager.Load("ResolutionY", Resolution.y)
	$CanvasLayer/Control/OptionButton.select(selIndex)
	_on_option_button_item_selected(selIndex)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")


func _on_option_button_item_selected(index):
	var root = get_tree().root
	var newSize: Vector2 = Vector2(960, 540)
	if index == 0:
		newSize = Vector2(960, 540)
	elif index == 1:
		newSize = Vector2(1024, 576)
	elif index == 2:
		newSize = 0.5 * DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	root.content_scale_size = newSize
	selIndex = index
	DataManager.Save("ResolutionIndex", selIndex)
	DataManager.Save("ResolutionX", newSize.x)
	DataManager.Save("ResolutionY", newSize.y)
