extends Node2D


func _ready():
	for child : Upgrade in get_children():
		child.ReloadVisible()
