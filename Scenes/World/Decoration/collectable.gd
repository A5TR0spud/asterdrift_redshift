@tool
extends RigidBody2D

enum ResourcesEnum {
	Metal,
	Ceramic,
	Synthetic,
	Organic,
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

func _on_body_entered(body):
	if body is PhysicsBody2D:
		var a : PhysicsBody2D = body
		if !(a.collision_layer & 2):
			return
	else:
		return
	if COLLECTION == ResourcesEnum.Metal:
		RunHandler.METAL += 1
	elif COLLECTION == ResourcesEnum.Ceramic:
		RunHandler.CERAMIC += 1
	elif COLLECTION == ResourcesEnum.Synthetic:
		RunHandler.SYNTHETIC += 1
	elif COLLECTION == ResourcesEnum.Organic:
		RunHandler.ORGANIC += 1
	queue_free()
