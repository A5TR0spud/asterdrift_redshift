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
static var ClockTex := preload("res://Assets/Hangar/Resources/Clock.png")

func Get(mat: Mats) -> int:
	if mat == Mats.Metals:
		return Metals
	if mat == Mats.Ceramics:
		return Ceramics
	if mat == Mats.Organics:
		return Organics
	if mat == Mats.Synthetics:
		return Synthetics
	if mat == Mats.Components:
		return Components
	return 0

func Set(mat: Mats, value: int = 0) -> void:
	if mat == Mats.Metals:
		Metals = value
	elif mat == Mats.Ceramics:
		Ceramics = value
	elif mat == Mats.Organics:
		Organics = value
	elif mat == Mats.Synthetics:
		Synthetics = value
	elif mat == Mats.Components:
		Components = value

func SetTo(mats: Materials, coef: int = 1) -> void:
	Set(Mats.Metals, mats.Metals * coef)
	Set(Mats.Ceramics, mats.Ceramics * coef)
	Set(Mats.Synthetics, mats.Synthetics * coef)
	Set(Mats.Organics, mats.Organics * coef)
	Set(Mats.Components, mats.Components * coef)

func SetAll(value: int = 0, includeCores: bool = false) -> void:
	Set(Mats.Metals, value)
	Set(Mats.Ceramics, value)
	Set(Mats.Organics, value)
	Set(Mats.Synthetics, value)
	if includeCores:
		Set(Mats.Components, value)

func Add(mat: Mats, value: int = 1) -> void:
	if mat == Mats.Metals:
		Metals += value
	elif mat == Mats.Ceramics:
		Ceramics += value
	elif mat == Mats.Organics:
		Organics += value
	elif mat == Mats.Synthetics:
		Synthetics += value
	elif mat == Mats.Components:
		Components += value

func AddBy(mats: Materials, coef: int = 1) -> void:
	Add(Mats.Metals, mats.Metals * coef)
	Add(Mats.Ceramics, mats.Ceramics * coef)
	Add(Mats.Synthetics, mats.Synthetics * coef)
	Add(Mats.Organics, mats.Organics * coef)
	Add(Mats.Components, mats.Components * coef)

func AddAll(value: int = 1, includeCores: bool = true) -> void:
	Add(Mats.Metals, value)
	Add(Mats.Ceramics, value)
	Add(Mats.Organics, value)
	Add(Mats.Synthetics, value)
	if includeCores:
		Add(Mats.Components, value)

func Remove(mat: Mats, value: int = 1) -> void:
	if mat == Mats.Metals:
		Metals -= value
	elif mat == Mats.Ceramics:
		Ceramics -= value
	elif mat == Mats.Organics:
		Organics -= value
	elif mat == Mats.Synthetics:
		Synthetics -= value
	elif mat == Mats.Components:
		Components -= value

func RemoveBy(mats: Materials, coef: int = 1) -> void:
	Remove(Mats.Metals, mats.Metals * coef)
	Remove(Mats.Ceramics, mats.Ceramics * coef)
	Remove(Mats.Synthetics, mats.Synthetics * coef)
	Remove(Mats.Organics, mats.Organics * coef)
	Remove(Mats.Components, mats.Components * coef)

func RemoveAll(value: int = 1, includeCores: bool = true) -> void:
	Remove(Mats.Metals, value)
	Remove(Mats.Ceramics, value)
	Remove(Mats.Organics, value)
	Remove(Mats.Synthetics, value)
	if includeCores:
		Remove(Mats.Components, value)

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
	Clock,
	# Radar
	Danger,
}

static func TurnMatEnumToSprite(input: Mats) -> Texture2D:
	if input == Materials.Mats.Metals:
		return MetalTex
	elif input == Mats.Synthetics:
		return SyntheticTex
	elif input == Mats.Ceramics:
		return CeramicTex
	elif input == Mats.Organics:
		return OrganicTex
	elif input == Mats.Components:
		return CoreTex
	elif input == Mats.Energy:
		return EnergyTex
	elif input == Mats.BackupEnergy:
		return BackupEnergyTex
	elif input == Mats.Clock:
		return ClockTex
	return MetalTex
