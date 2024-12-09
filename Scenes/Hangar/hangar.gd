extends Node2D

@onready var Resources: ResourceCounter = $CanvasLayer/Control/ResourceCounter

func _ready():
	MaterialsManager.Load()
	Resources.Display = MaterialsManager.Mats

func _on_tech_tree_reload_display():
	if is_node_ready():
		Resources.Display = MaterialsManager.Mats
