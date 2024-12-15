@tool
extends GridContainer
class_name ResourceCounter

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Materials") var Display: Materials:
	get:
		return Display
	set(value):
		Display = value
		if is_node_ready():
			_updateDisplay()
## If true, non-core resources will be sorted by quantity
@export var SORT: bool = false:
	get:
		return SORT
	set(value):
		SORT = value
		if is_node_ready():
			_updateDisplay()
## If false, displays with 0 will be culled
@export var ALWAYS_SHOW : bool = false:
	get:
		return ALWAYS_SHOW
	set(value):
		ALWAYS_SHOW = value
		if is_node_ready():
			_updateDisplay()
## If false, text will be hidden, showing only the numbers
@export var SHOW_TEXT : bool = true:
	get:
		return SHOW_TEXT
	set(value):
		SHOW_TEXT = value
		if is_node_ready():
			_updateDisplay()
## If true, replaces numbers with boolean icons (negative for false, positive for true)
@export var BOOL_ICON : bool = false:
	get:
		return BOOL_ICON
	set(value):
		BOOL_ICON = value
		if is_node_ready():
			_updateDisplay()
@export var FONT_SIZE : int = 16:
	get:
		return FONT_SIZE
	set(value):
		FONT_SIZE = value
		if is_node_ready():
			_updateDisplay()


func _ready():
	_updateDisplay()

@onready var ON_ICON := preload("res://Assets/Hangar/Upgrades/Meta/BooleanIconTrue.png")
@onready var OFF_ICON := preload("res://Assets/Hangar/Upgrades/Meta/BooleanIconFalse.png")

func _updateDisplay():
	$Metals/Bool.visible = BOOL_ICON
	$Metals/Bool.texture = ON_ICON if Display.Metals > 0 else OFF_ICON
	$Metals/Bool.custom_minimum_size.y = FONT_SIZE + 7
	$Metals/Label.text = ""
	if !BOOL_ICON:
		$Metals/Label.text += String.num(Display.Metals)
	if SHOW_TEXT:
		$Metals/Label.text += " Metallics" if Display.Metals != 1 else " Metallic"
	
	$Ceramics/Bool.visible = BOOL_ICON
	$Ceramics/Bool.texture = ON_ICON if Display.Ceramics > 0 else OFF_ICON
	$Ceramics/Bool.custom_minimum_size.y = FONT_SIZE + 7
	$Ceramics/Label.text = ""
	if !BOOL_ICON:
		$Ceramics/Label.text += String.num(Display.Ceramics)
	if SHOW_TEXT:
		$Ceramics/Label.text += " Ceramics" if Display.Ceramics != 1 else " Ceramic"
	
	$Synthetic/Bool.visible = BOOL_ICON
	$Synthetic/Bool.texture = ON_ICON if Display.Synthetics > 0 else OFF_ICON
	$Synthetic/Bool.custom_minimum_size.y = FONT_SIZE + 7
	$Synthetic/Label.text = ""
	if !BOOL_ICON:
		$Synthetic/Label.text = String.num(Display.Synthetics)
	if SHOW_TEXT:
		$Synthetic/Label.text += " Synthetics" if Display.Synthetics != 1 else " Synthetic"
	
	$Organics/Bool.visible = BOOL_ICON
	$Organics/Bool.texture = ON_ICON if Display.Organics > 0 else OFF_ICON
	$Organics/Bool.custom_minimum_size.y = FONT_SIZE + 7
	$Organics/Label.text = ""
	if !BOOL_ICON:
		$Organics/Label.text = String.num(Display.Organics)
	if SHOW_TEXT:
		$Organics/Label.text += " Organics" if Display.Organics != 1 else " Organic"
	
	$Components/Bool.visible = BOOL_ICON
	$Components/Bool.texture = ON_ICON if Display.Components > 0 else OFF_ICON
	$Components/Bool.custom_minimum_size.y = FONT_SIZE + 7
	$Components/Label.text = ""
	if !BOOL_ICON:
		$Components/Label.text = String.num(Display.Components)
	if SHOW_TEXT:
		$Components/Label.text += " Cores" if Display.Components != 1 else " Core"
	
	$Metals/Label.label_settings.font_size = FONT_SIZE
	
	var b: bool = Engine.is_editor_hint()
	$Metals.visible = b || ALWAYS_SHOW || Display.Metals != 0
	$Ceramics.visible = b || ALWAYS_SHOW || Display.Ceramics != 0
	$Synthetic.visible = b || ALWAYS_SHOW || Display.Synthetics != 0
	$Organics.visible = b || ALWAYS_SHOW || Display.Organics != 0
	$Components.visible = b || ALWAYS_SHOW || Display.Components != 0
	
	if SORT && !Engine.is_editor_hint():
		_sort()

func _sort() -> void:
	var ceram: int = Display.Ceramics
	$Ceramics.vv = ceram
	var organ: int = Display.Organics
	$Organics.vv = organ
	var metal: int = Display.Metals
	$Metals.vv = metal
	var synth: int = Display.Synthetics
	$Synthetic.vv = synth
	for child: Node in get_children():
		if child is RScore:
			for child2: Node in get_children():
				if child2 is RScore:
					if child.vv > child2.vv && child.get_index() > child2.get_index():
						move_child(child, child2.get_index())
