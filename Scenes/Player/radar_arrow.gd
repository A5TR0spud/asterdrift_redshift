@tool
extends Node2D
class_name RadarArrow

static var RadarMetalTex := preload("res://Assets/Ships/Upgrades/RadarMetal.png")
static var RadarCeramicTex := preload("res://Assets/Ships/Upgrades/RadarCeramic.png")
static var RadarDangerTex := preload("res://Assets/Ships/Upgrades/RadarDanger.png")
static var RadarOrganicTex := preload("res://Assets/Ships/Upgrades/RadarOrganic.png")
static var RadarCoreTex := preload("res://Assets/Ships/Upgrades/RadarCore.png")
static var RadarSyntheticTex := preload("res://Assets/Ships/Upgrades/RadarSynthetic.png")

@export var Offset: float = 0.0:
	get:
		return Offset
	set(value):
		Offset = value
		if is_node_ready():
			_reload()
@export var Type: Materials.Mats:
	get:
		return Type
	set(value):
		Type = value
		if is_node_ready():
			_reload()

func _ready():
	_reload()

func _reload():
	$Offset.position.y = Offset
	$Offset/Sprite.texture = _matToRadar(Type)

func _matToRadar(input: Materials.Mats) -> Texture2D:
	if input == Materials.Mats.Metals:
		return RadarMetalTex
	elif input == Materials.Mats.Ceramics:
		return RadarCeramicTex
	elif input == Materials.Mats.Synthetics:
		return RadarSyntheticTex
	elif input == Materials.Mats.Organics:
		return RadarOrganicTex
	elif input == Materials.Mats.Danger:
		return RadarDangerTex
	elif input == Materials.Mats.Components:
		return RadarCoreTex
	return RadarMetalTex
