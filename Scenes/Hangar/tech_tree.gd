extends Node2D

signal reload_display

func _ready():
	_reloadChildren(0)
	for child : Upgrade in get_children():
		child.upgrade_successfully_bought.connect(_reloadChildren)

func _reloadChildren(_ignored):
	emit_signal("reload_display")
	for child : Upgrade in get_children():
		child.ReloadVisible()
