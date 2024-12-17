extends Panel
class_name TransformNotification

@export var Duration: float = 3
var _timeLeft: float = 3

@export var Victim: Materials.Mats = Materials.Mats.Organics:
	get:
		return Victim
	set(value):
		Victim = value
		if is_node_ready():
			_reload()
@export var Result: Materials.Mats = Materials.Mats.Energy:
	get:
		return Result
	set(value):
		Result = value
		if is_node_ready():
			_reload()
@export var Source: Sources = Sources.NONE:
	get:
		return Source
	set(value):
		Source = value
		if is_node_ready():
			_reload()

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

@onready var VictimSprite := $Control/HBoxContainer/Victim
@onready var ResultSprite := $Control/HBoxContainer/Result
@onready var SourceSprite := $Control/Source
@onready var Clipper := $Control

enum Sources {
	NONE,
	HYDROPONIC,
	FURNACE,
	COMPOSTER,
	RECYCLER,
	SYNTHESIZER,
	UPCYCLER,
}

func _ready():
	_reload()

func _reload():
	size.x = 1
	_timeLeft = Duration
	VictimSprite.texture = turnMatEnumToSprite(Victim)
	ResultSprite.texture = turnMatEnumToSprite(Result)
	SourceSprite.visible = Source != Sources.NONE
	SourceSprite.texture = turnSourceEnumToSprite(Source)

func turnSourceEnumToSprite(input: Sources) -> Texture2D:
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
	return HydroponicTex

func turnMatEnumToSprite(input: Materials.Mats) -> Texture2D:
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

func _physics_process(delta):
	if is_queued_for_deletion() || !is_node_ready():
		return
	
	#size.x = lerpf(1, 116, clampf(10.0 * (Duration - _timeLeft), 0, 1))
	custom_minimum_size.y = lerpf(0, 27, clampf(10.0 * _timeLeft, 0, 1))
	Clipper.size.y = lerpf(1, 32, clampf(10.0 * _timeLeft, 0, 1))
	
	if _timeLeft <= 0:
		#hide()
		queue_free()
	_timeLeft -= delta
