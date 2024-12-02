@tool
extends Node2D

@export var ACCENT_TYPE : ShipData.AccentTypes = ShipData.AccentTypes.STANDARD:
	get:
		return ACCENT_TYPE
	set(value):
		ACCENT_TYPE = value
		_processChanges()

var isReadied : bool = false

func _ready():
	isReadied = true
	_processChanges()

func _processChanges():
	if !isReadied:
		return
	for child : Node2D in get_children():
		child.hide()
	if ACCENT_TYPE == ShipData.AccentTypes.NONE:
		return
	if ACCENT_TYPE == ShipData.AccentTypes.STANDARD:
		$Standard.show()
	elif ACCENT_TYPE == ShipData.AccentTypes.HORNET:
		$Hornet.show()
	elif ACCENT_TYPE == ShipData.AccentTypes.GREEBLE:
		$Greeble.show()
