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
			_reloadIcon()

@onready var Icon := $Icon
var MetalTex := preload("res://Assets/Hangar/Resources/Metal.png")
var CeramicTex := preload("res://Assets/Hangar/Resources/Ceramics.png")
var SyntheticTex := preload("res://Assets/Hangar/Resources/Synthetics.png")
var OrganicTex := preload("res://Assets/Hangar/Resources/Organics.png")
var CoreTex := preload("res://Assets/Hangar/Resources/Component.png")

func _ready():
	_reloadIcon()

func _reloadIcon():
	if COLLECTION == ResourcesEnum.Metal:
		Icon.texture = MetalTex
	elif COLLECTION == ResourcesEnum.Ceramic:
		Icon.texture = CeramicTex
	elif COLLECTION == ResourcesEnum.Synthetic:
		Icon.texture = SyntheticTex
	elif COLLECTION == ResourcesEnum.Organic:
		Icon.texture = OrganicTex
	elif COLLECTION == ResourcesEnum.Core:
		Icon.texture = CoreTex
