#@tool
class_name Garage
extends Node2D

const SHIP_PATH = "user://ship.tres"

@onready var Visuals = $Player/ShipVisuals

@onready var HullColor = $CanvasLayer/Control/ShipEditorVH/HullColor
@onready var CockpitColor = $CanvasLayer/Control/ShipEditorVH/CockpitColor
@onready var AccentTypeSelector = $CanvasLayer/Control/ShipEditorVH/AccentTypeSelector
@onready var AccentColor = $CanvasLayer/Control/ShipEditorVH/AccentColor
@onready var BlinkerOnColor = $CanvasLayer/Control/ShipEditorVH/BlinkerOnColor
@onready var BlinkerOffColor = $CanvasLayer/Control/ShipEditorVH/BlinkerOffColor
@onready var BlinkerInterval = $CanvasLayer/Control/ShipEditorVH/BlinkerInterval
@onready var BlinkerInterp = $CanvasLayer/Control/ShipEditorVH/BlinkerInterp
@onready var InlineColor = $CanvasLayer/Control/ShipEditorVH/InlineColor
@onready var OutlineColor = $CanvasLayer/Control/ShipEditorVH/OutlineColor

var currentShipIsSaved : bool = false

static var CachedShip : ShipData = ShipData.new()

func _ready():
	$Player.IS_IN_GARAGE = true
	LoadShip()

func SaveShip():
	var data := CachedShip

	var error := ResourceSaver.save(data, SHIP_PATH)
	if error:
		print("An error happened while saving data: ", error)

func LoadShip():
	if FileAccess.file_exists(SHIP_PATH):
		var data : ShipData = load(SHIP_PATH) #ResourceLoader.load also works
		CachedShip.copy(data)
		_ReloadFromCached()
	else:
		print(SHIP_PATH, " does not exist! Defaulting.")
		CachedShip = ShipData.new()

func _ReloadFromCached():
	HullColor.Selected = CachedShip.hull_int
	CockpitColor.Selected = CachedShip.cockpit_int
	AccentColor.Selected = CachedShip.accent_color_int
	AccentTypeSelector.select(CachedShip.accent_type_int)
	Visuals.ACCENT_TYPE = _indexToAccent(CachedShip.accent_type_int)
	BlinkerOnColor.Selected = CachedShip.blinker_on_int
	BlinkerOffColor.Selected = CachedShip.blinker_off_int
	BlinkerInterval.value = CachedShip.blinker_interval
	BlinkerInterp.button_pressed = CachedShip.blinker_interp
	InlineColor.Selected = CachedShip.inline_int
	OutlineColor.Selected = CachedShip.outline_int
	# The colors are explicitly set so that manually edited save data displays correctly
	#Visuals.HULL_COLOR = CachedShip.hull_color
	#Visuals.COCKPIT_COLOR = CachedShip.cockpit_color
	#Visuals.ACCENT_COLOR = CachedShip.accent_color
	#Visuals.ACCENT_TYPE = CachedShip.accent_type
	#Visuals.BLINKER_ON_COLOR = CachedShip.blinker_on
	#Visuals.BLINKER_OFF_COLOR = CachedShip.blinker_off
	#Visuals.INLINE_COLOR = CachedShip.inline
	#Visuals.OUTLINE_COLOR = CachedShip.outline
	# nevermind it wont work

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/main_menu.tscn")

func _on_hull_color_color_changed(newColor, newIndex):
	Visuals.HULL_COLOR = newColor
	CachedShip.hull_int = newIndex
	CachedShip.hull_color = newColor

func _on_cockpit_color_color_changed(newColor, newIndex):
	Visuals.COCKPIT_COLOR = newColor
	CachedShip.cockpit_int = newIndex
	CachedShip.cockpit_color = newColor

func _on_accent_color_color_changed(newColor, newIndex):
	Visuals.ACCENT_COLOR = newColor
	CachedShip.accent_color_int = newIndex
	CachedShip.accent_color = newColor

func _on_blinker_on_color_color_changed(newColor, newIndex):
	Visuals.BLINKER_ON_COLOR = newColor
	CachedShip.blinker_on_int = newIndex
	CachedShip.blinker_on = newColor

func _on_blinker_off_color_color_changed(newColor, newIndex):
	Visuals.BLINKER_OFF_COLOR = newColor
	CachedShip.blinker_off_int = newIndex
	CachedShip.blinker_off = newColor

func _on_inline_color_color_changed(newColor, newIndex):
	Visuals.INLINE_COLOR = newColor
	CachedShip.inline_int = newIndex
	CachedShip.inline = newColor

func _on_outline_color_color_changed(newColor, newIndex):
	Visuals.OUTLINE_COLOR = newColor
	CachedShip.outline_int = newIndex
	CachedShip.outline = newColor

func _on_blinker_interval_value_changed(value):
	Visuals.BLINKER_INTERVAL = value
	CachedShip.blinker_interval = value

func _on_blinker_interp_toggled(toggled_on):
	Visuals.BLINKER_INTERPOLATION = toggled_on
	CachedShip.blinker_interp = toggled_on

func _on_accent_type_selector_item_selected(index):
	Visuals.ACCENT_TYPE = _indexToAccent(index)
	CachedShip.accent_type = _indexToAccent(index)
	CachedShip.accent_type_int = index

func _indexToAccent(i : int):
	if i == 1:
		return ShipData.AccentTypes.STANDARD
	if i == 2:
		return ShipData.AccentTypes.GREEBLE
	if i == 3:
		return ShipData.AccentTypes.HORNET
	return ShipData.AccentTypes.NONE


func _on_reset_button_pressed():
	CachedShip = ShipData.new()
	_ReloadFromCached()

func _on_save_button_pressed():
	SaveShip()

func _on_discard_button_pressed():
	LoadShip()
