@tool
extends OptionButton

var _i : int = 0

func _ready():
	while item_count > 0:
		remove_item(0)
	_add(ShipData.AccentTypes.NONE)
	_add(ShipData.AccentTypes.STANDARD)
	_add(ShipData.AccentTypes.GREEBLE)
	_add(ShipData.AccentTypes.HORNET)
	select(1)

func _add(emu : ShipData.AccentTypes):
	add_item(_enumToString(emu), _i)
	_i+=1

func _enumToString(emu : ShipData.AccentTypes):
	if (emu == ShipData.AccentTypes.NONE):
		return "None"
	if (emu == ShipData.AccentTypes.STANDARD):
		return "Standard"
	if (emu == ShipData.AccentTypes.GREEBLE):
		return "Greeble"
	if (emu == ShipData.AccentTypes.HORNET):
		return "Hornet"
