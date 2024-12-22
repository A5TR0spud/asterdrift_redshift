extends Panel
class_name Notification

@export var Duration: float = 3
var _timeLeft: float = 3

static var MetalTex := preload("res://Assets/Hangar/Resources/Metal.png")
static var CeramicTex := preload("res://Assets/Hangar/Resources/Ceramics.png")
static var SyntheticTex := preload("res://Assets/Hangar/Resources/Synthetics.png")
static var OrganicTex := preload("res://Assets/Hangar/Resources/Organics.png")
static var CoreTex := preload("res://Assets/Hangar/Resources/Component.png")
static var EnergyTex := preload("res://Assets/Hangar/Resources/Energy.png")
static var BackupEnergyTex := preload("res://Assets/Hangar/Resources/Backup.png")

static var HydroponicTex := preload("res://Assets/Hangar/Upgrades/Hydroponics.png")
static var FurnaceTex := preload("res://Assets/Hangar/Upgrades/Combustor.png")
static var ComposterTex := preload("res://Assets/Hangar/Upgrades/Composter.png")
static var RecyclerTex := preload("res://Assets/Hangar/Upgrades/Recycler.png")
static var SynthesizerTex := preload("res://Assets/Hangar/Upgrades/Processor.png")
static var UpcyclerTex := preload("res://Assets/Hangar/Upgrades/Upcycler.png")
static var KilnTex := preload("res://Assets/Hangar/Upgrades/Kiln.png")
static var ScrapperTex := preload("res://Assets/Hangar/Upgrades/Scrapper.png")
static var ForgeTex := preload("res://Assets/Hangar/Upgrades/Forge.png")
static var HephaestusTex := preload("res://Assets/Hangar/Upgrades/Anvil.png")

enum Sources {
	HYDROPONIC,
	FURNACE,
	COMPOSTER,
	RECYCLER,
	SYNTHESIZER,
	UPCYCLER,
	KILN,
	SCRAPPER,
	FORGE,
	HEPHAESTUS,
}

func _ready():
	_reload()

func _reload():
	size.x = 1
	_timeLeft = Duration

func TurnSourceEnumToSprite(input: Sources) -> Texture2D:
	if input == Sources.HYDROPONIC:
		return HydroponicTex
	elif input == Sources.FURNACE:
		return FurnaceTex
	elif input == Sources.COMPOSTER:
		return ComposterTex
	elif input == Sources.SYNTHESIZER:
		return SynthesizerTex
	elif input == Sources.RECYCLER:
		return RecyclerTex
	elif input == Sources.UPCYCLER:
		return UpcyclerTex
	elif input == Sources.KILN:
		return KilnTex
	elif input == Sources.FORGE:
		return ForgeTex
	elif input == Sources.SCRAPPER:
		return ScrapperTex
	elif input == Sources.HEPHAESTUS:
		return HephaestusTex
	return HydroponicTex

func TurnMatEnumToSprite(input: Materials.Mats) -> Texture2D:
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
