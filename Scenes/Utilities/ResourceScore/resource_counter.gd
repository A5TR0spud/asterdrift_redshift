@tool
extends GridContainer

@export var METAL : int = 0:
	get:
		return METAL
	set(value):
		METAL = value
		if is_node_ready():
			_updateDisplay()
@export var CERAMIC : int = 0:
	get:
		return CERAMIC
	set(value):
		CERAMIC = value
		if is_node_ready():
			_updateDisplay()
@export var SYNTHETIC : int = 0:
	get:
		return SYNTHETIC
	set(value):
		SYNTHETIC = value
		if is_node_ready():
			_updateDisplay()
@export var ORGANIC : int = 0:
	get:
		return ORGANIC
	set(value):
		ORGANIC = value
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
@export var SHOW_TEXT : bool = true:
	get:
		return SHOW_TEXT
	set(value):
		SHOW_TEXT = value
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

func _updateDisplay():
	$Metals/Label.text = String.num(METAL)
	if SHOW_TEXT:
		$Metals/Label.text += " Metallics" if METAL != 1 else " Metallic"
	$Ceramics/Label.text = String.num(CERAMIC)
	if SHOW_TEXT:
		$Ceramics/Label.text += " Ceramics" if CERAMIC != 1 else " Ceramic"
	$Synthetic/Label.text = String.num(SYNTHETIC)
	if SHOW_TEXT:
		$Synthetic/Label.text += " Synthetics" if SYNTHETIC != 1 else " Synthetic"
	$Organics/Label.text = String.num(ORGANIC)
	if SHOW_TEXT:
		$Organics/Label.text += " Organics" if ORGANIC != 1 else " Organic"
	
	$Metals/Label.label_settings.font_size = FONT_SIZE
	
	$Metals.hide()
	if ALWAYS_SHOW || METAL != 0:
		$Metals.show()
	$Ceramics.hide()
	if ALWAYS_SHOW || CERAMIC != 0:
		$Ceramics.show()
	$Synthetic.hide()
	if ALWAYS_SHOW || SYNTHETIC != 0:
		$Synthetic.show()
	$Organics.hide()
	if ALWAYS_SHOW || ORGANIC != 0:
		$Organics.show()
	
