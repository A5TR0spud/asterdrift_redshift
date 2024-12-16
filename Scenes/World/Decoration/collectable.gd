@tool
extends Entity
class_name Collectable

enum ResourcesEnum {
	Metal,
	Ceramic,
	Synthetic,
	Organic,
	Core,
}

@export var COLLECTION : ResourcesEnum = ResourcesEnum.Metal:
	get:
		return COLLECTION
	set(value):
		COLLECTION = value
		if is_node_ready():
			_reload()

@onready var Icon := $Icon
var MetalTex := preload("res://Assets/Hangar/Resources/Metal.png")
var CeramicTex := preload("res://Assets/Hangar/Resources/Ceramics.png")
var SyntheticTex := preload("res://Assets/Hangar/Resources/Synthetics.png")
var OrganicTex := preload("res://Assets/Hangar/Resources/Organics.png")
var CoreTex := preload("res://Assets/Hangar/Resources/Component.png")

func _ready():
	_reload()

func _reload():
	if COLLECTION == ResourcesEnum.Metal:
		Icon.texture = MetalTex
		Magnetism = 1.75
	elif COLLECTION == ResourcesEnum.Ceramic:
		Icon.texture = CeramicTex
		Magnetism = 1.1
	elif COLLECTION == ResourcesEnum.Synthetic:
		Icon.texture = SyntheticTex
		Magnetism = 1.0
	elif COLLECTION == ResourcesEnum.Organic:
		Icon.texture = OrganicTex
		Magnetism = 0.9
	elif COLLECTION == ResourcesEnum.Core:
		Icon.texture = CoreTex
		Magnetism = 1.5

func Collect():
	if COLLECTION == Collectable.ResourcesEnum.Metal:
		RunHandler.Mats.Metals += 1
	elif COLLECTION == Collectable.ResourcesEnum.Ceramic:
		RunHandler.Mats.Ceramics += 1
	elif COLLECTION == Collectable.ResourcesEnum.Synthetic:
		RunHandler.Mats.Synthetics += 1
	elif COLLECTION == Collectable.ResourcesEnum.Organic:
		RunHandler.Mats.Organics += 1
		if UpgradesManager.Load("Farm") > 0:
			RunHandler.TimeLeft += 0.5
	elif COLLECTION == Collectable.ResourcesEnum.Core:
		RunHandler.Mats.Components += 1
	queue_free()
