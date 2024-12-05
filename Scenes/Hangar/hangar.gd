extends Node2D

@onready var Resources = $CanvasLayer/Control/ResourceCounter

func _ready():
	MaterialsManager.Load()
	Resources.METAL = MaterialsManager.Metals
	Resources.CERAMIC = MaterialsManager.Ceramics
	Resources.SYNTHETIC = MaterialsManager.Synthetics
	Resources.ORGANIC = MaterialsManager.Organics

func _physics_process(delta):
	Resources.METAL = MaterialsManager.Metals
	Resources.CERAMIC = MaterialsManager.Ceramics
	Resources.SYNTHETIC = MaterialsManager.Synthetics
	Resources.ORGANIC = MaterialsManager.Organics
