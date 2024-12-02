@tool
extends TextureButton

var color := Color.MAGENTA :
	get:
		return color
	set(value):
		color = value
		_setColor()

var is_readied := false

func _ready():
	is_readied = true
	_setColor()

func _setColor():
	if !is_readied:
		return
	$Swatch.color = color
