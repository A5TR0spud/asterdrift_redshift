@tool
extends Entity
class_name Collectable

@export var COLLECTION : Materials.Mats = Materials.Mats.Metals:
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
	if COLLECTION == Materials.Mats.Metals:
		Icon.texture = MetalTex
		Magnetism = 1.75
	elif COLLECTION == Materials.Mats.Ceramics:
		Icon.texture = CeramicTex
		Magnetism = 1.1
	elif COLLECTION == Materials.Mats.Synthetics:
		Icon.texture = SyntheticTex
		Magnetism = 1.0
	elif COLLECTION == Materials.Mats.Organics:
		Icon.texture = OrganicTex
		Magnetism = 0.9
	elif COLLECTION == Materials.Mats.Components:
		Icon.texture = CoreTex
		Magnetism = 1.5

static var ProcessorCount: int = 0
static var ComposterCount: int = 0
static var FurnaceCount: int = 0
static var RecyclerCount: int = 0
static var UpcyclerCount: int = 0
static var KilnCount: int = 0
static var ScrapperCount: int = 0
static var ForgeCount: int = 0

func Collect():
	_onCollected(COLLECTION)
	queue_free()

func _onCollected(type: Materials.Mats, Sources: Array[Notification.Sources] = []) -> void:
	if UpgradesManager.Load("Dynamo") > 0:
		# energy += 1/518 * velocity
		# velocity = velocity * 517/518
		var percent: float = PlayerClass.Instance.linear_velocity.length() / PlayerClass.Instance.GetCurrentMaxSpeed()
		RunHandler.TimeLeft += percent * 0.125
		PlayerClass.Instance.linear_velocity *= 0.85
	
	if _tryUpcycle(type, Sources):
		return
	
	if type == Materials.Mats.Components:
		RunHandler.Mats.Components += 1
		NotificationsManager.SendPickupNotification(Materials.Mats.Components)
		return
	
	if _tryRecycle(type, Sources):
		return
	
	if type == Materials.Mats.Metals:
		_onMetalCollected(Sources)
	elif type == Materials.Mats.Ceramics:
		_onCeramicCollected(Sources)
	elif type == Materials.Mats.Synthetics:
		_onSyntheticCollected(Sources)
	elif type == Materials.Mats.Organics:
		_onOrganicCollected(Sources)

func _tryRecycle(type: Materials.Mats, Sources: Array[Notification.Sources]) -> bool:
	if UpgradesManager.Load("Recycler") < 1:
		return false
	var target := _getLowestResourceFromMaterials(MaterialsManager.Mats, _getLowestResourceFromMaterials(RunHandler.Mats, Materials.Mats.Organics))
	
	RecyclerCount += 1
	if RecyclerCount % 4 == 0:
		if target == type:
			RecyclerCount -= 1
			return false
		Sources.append(Notification.Sources.RECYCLER)
		NotificationsManager.SendTransformNotification(type, target, Sources)
		if target == Materials.Mats.Metals:
			RunHandler.Mats.Metals += 1
		elif target == Materials.Mats.Synthetics:
			RunHandler.Mats.Synthetics += 1
		elif target == Materials.Mats.Ceramics:
			RunHandler.Mats.Ceramics += 1
		elif target == Materials.Mats.Organics:
			RunHandler.Mats.Organics += 1
		return true
	return false

func _tryUpcycle(type: Materials.Mats, Sources: Array[Notification.Sources]) -> bool:
	if UpgradesManager.Load("Upcycler") < 1:
		return false
	UpcyclerCount += 1
	if UpcyclerCount % 7 == 0:
		if randi_range(1, 250) == 1 && type != Materials.Mats.Components:
			RunHandler.Mats.Components += 1
			Sources.append(TransformNotification.Sources.UPCYCLER)
			NotificationsManager.SendTransformNotification(type, Materials.Mats.Components, Sources)
			return true
		var target := _getLowestResourceFromMaterials(RunHandler.Mats, _getLowestResourceFromMaterials(MaterialsManager.Mats, Materials.Mats.Synthetics))
		var upcycleCopy: Array[Notification.Sources] = [Notification.Sources.UPCYCLER]
		if target == Materials.Mats.Metals:
			_onMetalCollected(upcycleCopy)
		elif target == Materials.Mats.Organics:
			_onOrganicCollected(upcycleCopy)
		elif target == Materials.Mats.Synthetics:
			_onSyntheticCollected(upcycleCopy)
		elif target == Materials.Mats.Ceramics:
			_onCeramicCollected(upcycleCopy)
		else:
			_onSyntheticCollected(upcycleCopy)
	return false

func _getLowestResourceFromMaterials(mat: Materials, tiebreaker: Materials.Mats = Materials.Mats.Metals) -> Materials.Mats:
	var metal: int = mat.Metals
	var synth: int = mat.Synthetics
	var ceram: int = mat.Ceramics
	var organ: int = mat.Organics
	
	var thing: Array[int] = [metal, synth, ceram, organ]
	var index: int = 0
	var tied: bool = false
	for i: int in thing.size():
		if thing[i] < thing[index]:
			index = i
			tied = false
	
	if tied:
		return tiebreaker
	
	if index == 0:
		return Materials.Mats.Metals
	elif index == 1:
		return Materials.Mats.Synthetics
	elif index == 2:
		return Materials.Mats.Ceramics
	elif index == 3:
		return Materials.Mats.Organics
	
	return tiebreaker

func _onMetalCollected(Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Kiln") > 0 && !Sources.has(Notification.Sources.KILN):
		KilnCount += 1
		if KilnCount % 2 == 0:
			if UpgradesManager.Load("Hephaestus") > 0 && !Sources.has(Notification.Sources.HEPHAESTUS):
				_onCeramicCollected([Notification.Sources.HEPHAESTUS, Notification.Sources.KILN])
			else:
				RunHandler.Mats.Ceramics += 1
				Sources.append(Notification.Sources.KILN)
				NotificationsManager.SendTransformNotification(Materials.Mats.Metals, Materials.Mats.Ceramics, Sources)
				return
	RunHandler.Mats.Metals += 1
	NotificationsManager.SendPickupNotification(Materials.Mats.Metals, Sources)

func _onCeramicCollected(Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Scrapper") > 0 && !Sources.has(Notification.Sources.SCRAPPER):
		ScrapperCount += 1
		if ScrapperCount % 2 == 0:
			RunHandler.Mats.Synthetics += 1
			Sources.append(Notification.Sources.SCRAPPER)
			NotificationsManager.SendTransformNotification(Materials.Mats.Ceramics, Materials.Mats.Synthetics, Sources)
			return
	if UpgradesManager.Load("Forge") > 0:
		ForgeCount += 1
		if ForgeCount % 2 == 0:
			if UpgradesManager.Load("Hephaestus") > 0 && !Sources.has(Notification.Sources.HEPHAESTUS):
				_onMetalCollected([Notification.Sources.HEPHAESTUS, Notification.Sources.FORGE])
			else:
				RunHandler.Mats.Metals += 1
				Sources.append(Notification.Sources.FORGE)
				NotificationsManager.SendTransformNotification(Materials.Mats.Ceramics, Materials.Mats.Metals, Sources)
				return
	RunHandler.Mats.Ceramics += 1
	NotificationsManager.SendPickupNotification(Materials.Mats.Ceramics, Sources)

func _onSyntheticCollected(Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Composter") > 0 && !Sources.has(Notification.Sources.COMPOSTER):
		ComposterCount += 1
		if ComposterCount % 2 == 0:
			RunHandler.Mats.Organics += 1
			Sources.append(Notification.Sources.COMPOSTER)
			NotificationsManager.SendTransformNotification(Materials.Mats.Synthetics, Materials.Mats.Organics, Sources)
			return
	RunHandler.Mats.Synthetics += 1
	NotificationsManager.SendPickupNotification(Materials.Mats.Synthetics, Sources)

func _onOrganicCollected(Sources: Array[Notification.Sources] = []):
	#synthesizer
	if UpgradesManager.Load("Processor") > 0 && !Sources.has(Notification.Sources.SYNTHESIZER):
		ProcessorCount += 1
		if ProcessorCount % 2 == 0:
			RunHandler.Mats.Synthetics += 1
			Sources.append(Notification.Sources.SYNTHESIZER)
			NotificationsManager.SendTransformNotification(Materials.Mats.Organics, Materials.Mats.Synthetics, Sources)
			return
	#furnace
	if UpgradesManager.Load("Combustor") > 0 && !Sources.has(Notification.Sources.FURNACE):
		FurnaceCount += 1
		if FurnaceCount % 2 == 0:
			RunHandler.TimeLeft += 1
			Sources.append(Notification.Sources.FURNACE)
			NotificationsManager.SendTransformNotification(Materials.Mats.Organics, Materials.Mats.Energy, Sources)
			return
	RunHandler.Mats.Organics += 1
	NotificationsManager.SendPickupNotification(Materials.Mats.Organics, Sources)
