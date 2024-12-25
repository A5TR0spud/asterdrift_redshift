extends Node2D
class_name Options

var resIndex: int = 1
var Resolution: Vector2 = Vector2(960, 540)

@onready var ResButton := $CanvasLayer/Control/VBoxContainer/Resolution/OptionButton
@onready var VisAster := $CanvasLayer/Control/VBoxContainer/VisibleAsteroids/CheckButton

func _ready():
	resIndex = DataManager.Load("ResolutionIndex", resIndex)
	Resolution.x = DataManager.Load("ResolutionX", Resolution.x)
	Resolution.y = DataManager.Load("ResolutionY", Resolution.y)
	ResButton.select(resIndex)
	_on_option_button_item_selected(resIndex)
	
	VisAster.button_pressed = DataManager.Load("HighVisAsteroids", false)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _on_option_button_item_selected(index):
	var root = get_tree().root
	var newSize: Vector2 = Vector2(960, 540)
	if index == 0:
		newSize = Vector2(960, 540)
	elif index == 1:
		newSize = Vector2(1280, 720)
	elif index == 2:
		newSize = AdaptScreen()
	root.content_scale_size = newSize
	resIndex = index
	DataManager.Save("ResolutionIndex", resIndex)
	DataManager.Save("ResolutionX", newSize.x)
	DataManager.Save("ResolutionY", newSize.y)

func _on_check_button_toggled(toggled_on: bool):
	DataManager.Save("HighVisAsteroids", toggled_on)
	Asteroid.ShaderSet = false

static func AdaptScreen() -> Vector2:
	var newSize: Vector2 = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	while newSize.length_squared() > Vector2(1280, 720).length_squared():
		newSize *= 0.5
	return newSize
