extends Panel
class_name Notification

@export var Duration: float = 3
var _timeLeft: float = 3

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
static var RTGTex := preload("res://Assets/Hangar/Upgrades/RTG.png")

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
	RTG,
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
	elif input == Sources.RTG:
		return RTGTex
	return HydroponicTex
