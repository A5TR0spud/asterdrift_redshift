extends Node2D


func _ready():
	_reloadChildren(0)
	for child : Upgrade in get_children():
		child.upgrade_successfully_bought.connect(_reloadChildren)

func _reloadChildren(_ignored):
	for child : Upgrade in get_children():
		child.ReloadVisible()
