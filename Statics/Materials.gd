extends Resource
class_name Materials

@export var Metals : int = 0
@export var Ceramics : int = 0
@export var Synthetics : int = 0
@export var Organics : int = 0
@export var Components : int = 0

static var MetalTex := preload("res://Assets/Hangar/Resources/Metal.png")
static var CeramicTex := preload("res://Assets/Hangar/Resources/Ceramics.png")
static var SyntheticTex := preload("res://Assets/Hangar/Resources/Synthetics.png")
static var OrganicTex := preload("res://Assets/Hangar/Resources/Organics.png")
static var CoreTex := preload("res://Assets/Hangar/Resources/Component.png")
static var EnergyTex := preload("res://Assets/Hangar/Resources/Energy.png")
static var BackupEnergyTex := preload("res://Assets/Hangar/Resources/Backup.png")
static var DangerTex := preload("res://Assets/Hangar/Resources/Danger.png")

enum Mats {
	# Materials
	Metals,
	Ceramics,
	Synthetics,
	Organics,
	Components,
	# Notifications
	Energy,
	BackupEnergy,
	# Radar
	Danger,
}

static func TurnMatEnumToSprite(input: Mats) -> Texture2D:
	if input == Materials.Mats.Metals:
		return MetalTex
	elif input == Materials.Mats.Synthetics:
		return SyntheticTex
	elif input == Materials.Mats.Ceramics:
		return CeramicTex
	elif input == Materials.Mats.Organics:
		return OrganicTex
	elif input == Materials.Mats.Components:
		return CoreTex
	elif input == Materials.Mats.Energy:
		return EnergyTex
	elif input == Materials.Mats.BackupEnergy:
		return BackupEnergyTex
	return MetalTex
