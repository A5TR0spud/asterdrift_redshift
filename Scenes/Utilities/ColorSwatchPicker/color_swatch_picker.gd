@tool
extends GridContainer

var Swatch : PackedScene = preload("res://Scenes/Utilities/ColorSwatchPicker/color_swatch.tscn")
@export var Colors : Array[Color] :
	get:
		return Colors
	set(value):
		Colors = value
		_reload()
@export var Selected : int = 0 :
	get:
		return Selected
	set(value):
		Selected = value
		_select()
var color := Color.MAGENTA
var is_readied := false
var is_initiated := false
signal colorChanged(newColor : Color, newIndex : int)

func _select():
	if !is_readied:
		return
	if Colors.size() < 1:
		return
	if get_children().size() + 1 <= Selected:
		Selected = get_children().size() - 1
	for child in get_children():
		child.find_child("Selected").hide()
	get_child(Selected).find_child("Selected").show()
	color = get_child(Selected).color
	emit_signal("colorChanged", color, Selected)

func _ready():
	is_readied = true
	_reload()
	if Colors.size() < 1:
		return
	if !is_initiated:
		get_child(Selected).find_child("Selected").show()
		color = get_child(Selected).color
		is_initiated = true

func _reload():
	if !is_readied:
		return
	for child in get_children():
		child.queue_free()
	var i : int = 0
	for coloru in Colors:
		var swatch : TextureButton = Swatch.instantiate()
		swatch.color = coloru
		add_child(swatch)
		swatch.pressed.connect(_onColorSwatchPressed.bind(coloru, i))
		i += 1

func _onColorSwatchPressed(color_touse: Color, index: int) -> void:
	color = color_touse
	Selected = index
	
