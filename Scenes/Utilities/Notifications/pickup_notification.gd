extends Panel
class_name PickupNotification

@export var Duration: float = 1
var _timeLeft: float = 1

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

enum Sources {
	NONE,
	UPCYCLER,
}

static var MetalTex := preload("res://Assets/Hangar/Resources/Metal.png")
static var CeramicTex := preload("res://Assets/Hangar/Resources/Ceramics.png")
static var SyntheticTex := preload("res://Assets/Hangar/Resources/Synthetics.png")
static var OrganicTex := preload("res://Assets/Hangar/Resources/Organics.png")
static var CoreTex := preload("res://Assets/Hangar/Resources/Component.png")
static var EnergyTex := preload("res://Assets/Hangar/Resources/Energy.png")
static var BackupEnergyTex := preload("res://Assets/Hangar/Resources/Backup.png")

static var UpcyclerTex := preload("res://Assets/Hangar/Upgrades/Upcycler.png")

@onready var ResultSprite := $Control/HBoxContainer/Icon
@onready var Clipper := $Control
@onready var SourceSprite := $Control/Source

func _ready():
	_reload()

func _reload():
	size.x = 1
	_timeLeft = Duration
	ResultSprite.texture = turnMatEnumToSprite(Result)
	SourceSprite.visible = Source != Sources.NONE
	SourceSprite.texture = turnSourceEnumToSprite(Source)

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

func turnSourceEnumToSprite(input: Sources) -> Texture2D:
	if input == Sources.UPCYCLER:
		return UpcyclerTex
	return UpcyclerTex

func _physics_process(delta):
	if is_queued_for_deletion() || !is_node_ready():
		return
	
	#size.x = lerpf(1, 76, clampf(10.0 * (Duration - _timeLeft), 0, 1))
	custom_minimum_size.y = lerpf(0, 27, clampf(10.0 * _timeLeft, 0, 1))
	Clipper.size.y = lerpf(1, 27, clampf(10.0 * _timeLeft, 0, 1))
	
	if _timeLeft <= 0:
		#hide()
		queue_free()
	_timeLeft -= delta
