@tool
extends Node2D

signal firemalasar

@export_color_no_alpha var HULL_COLOR : Color = Color("363d52"):
	get:
		return HULL_COLOR;
	set(value):
		HULL_COLOR = value
		_ProcessValues()
@export_color_no_alpha var COCKPIT_COLOR : Color = Color("01001f"):
	get:
		return COCKPIT_COLOR;
	set(value):
		COCKPIT_COLOR = value
		_ProcessValues()
@export_color_no_alpha var ACCENT_COLOR : Color = Color("478cbf"):
	get:
		return ACCENT_COLOR;
	set(value):
		ACCENT_COLOR = value
		_ProcessValues()
@export var ACCENT_TYPE : ShipData.AccentTypes = ShipData.AccentTypes.STANDARD:
	get:
		return ACCENT_TYPE
	set(value):
		ACCENT_TYPE = value
		_ProcessValues()
@export_color_no_alpha var BLINKER_ON_COLOR : Color = Color(1, 0, 0):
	get:
		return BLINKER_ON_COLOR;
	set(value):
		BLINKER_ON_COLOR = value
		_ProcessValues()
@export_color_no_alpha var BLINKER_OFF_COLOR : Color = Color(0, 0, 0, 1.0):
	get:
		return BLINKER_OFF_COLOR;
	set(value):
		BLINKER_OFF_COLOR = value
		_ProcessValues()
@export_range(0.5, 5) var BLINKER_INTERVAL : float = 1.0:
	get:
		return BLINKER_INTERVAL;
	set(value):
		BLINKER_INTERVAL = value
		_ProcessValues()
@export var BLINKER_INTERPOLATION : bool = false:
	get:
		return BLINKER_INTERPOLATION;
	set(value):
		BLINKER_INTERPOLATION = value
		_ProcessValues()
@export_color_no_alpha var INLINE_COLOR : Color = Color("212532"):
	get:
		return INLINE_COLOR;
	set(value):
		INLINE_COLOR = value
		_ProcessValues()
@export_color_no_alpha var OUTLINE_COLOR : Color = Color("338bff"):
	get:
		return OUTLINE_COLOR;
	set(value):
		OUTLINE_COLOR = value
		_ProcessValues()

var readied : bool = false

func _ready():
	readied = true
	_ProcessValues()

#func ResetSelfModulate():
#	for child : Node2D in get_children():
	#	child.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _ProcessValues():
	#ResetSelfModulate()
	if !readied:
		return
	#ship visuals
	$Hull.modulate = HULL_COLOR
	$Cockpit.modulate = COCKPIT_COLOR
	$Accents.modulate = ACCENT_COLOR
	$Accents.ACCENT_TYPE = ACCENT_TYPE
	$Blinkers.ON_COLOR = BLINKER_ON_COLOR
	$Blinkers.OFF_COLOR = BLINKER_OFF_COLOR
	$Blinkers.INTERVAL = BLINKER_INTERVAL
	$Blinkers.COLOR_INTERP = BLINKER_INTERPOLATION
	$Inline.modulate = INLINE_COLOR
	$Outline.modulate = OUTLINE_COLOR
	
	#manipulator visuals
	if is_instance_valid($"../Manipulator"):
		$"../Manipulator/BaseSprite/ArmSprite".self_modulate = HULL_COLOR
		$"../Manipulator/BaseSprite/ArmSprite/ArmAccent".self_modulate = ACCENT_COLOR
		$"../Manipulator/BaseSprite/ArmSprite/RHSGrabber".self_modulate = HULL_COLOR
		$"../Manipulator/BaseSprite/ArmSprite/LHSGrabber".self_modulate = HULL_COLOR
		$"../Manipulator/BaseSprite/ArmSprite/RHSGrabber/RHSGAccent".self_modulate = ACCENT_COLOR
		$"../Manipulator/BaseSprite/ArmSprite/LHSGrabber/LHSGAccent".self_modulate = ACCENT_COLOR
		$"../Manipulator/BaseSprite/Extendo".default_color = INLINE_COLOR
	
	emit_signal("firemalasar")
