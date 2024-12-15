extends Node2D

@onready var Resources: ResourceCounter = $CanvasLayer/Control/ResourceCounter
@onready var CoreAssembler = $CanvasLayer/Control/CoreAssembler

func _ready():
	MaterialsManager.Load()
	Resources.Display = MaterialsManager.Mats

func _on_tech_tree_reload_display():
	if is_node_ready():
		Resources.Display = MaterialsManager.Mats
		CoreAssembler._reload()


func _on_cheat_pressed():
	MaterialsManager.Mats.Ceramics = 10000
	MaterialsManager.Mats.Metals = 10000
	MaterialsManager.Mats.Components = 10000
	MaterialsManager.Mats.Synthetics = 10000
	MaterialsManager.Mats.Organics = 10000
	MaterialsManager.Save()
	$Camera2D/TechTree._reloadChildren(0)
	Resources.Display = MaterialsManager.Mats
