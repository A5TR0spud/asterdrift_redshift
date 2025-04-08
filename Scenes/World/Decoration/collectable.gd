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

static var ComposterCount: int = 0
static var FurnaceCount: int = 0
static var RecyclerCount: int = 0
static var UpcyclerCount: int = 0
static var KilnCount: int = 0
static var ScrapperCount: int = 0
static var ForgeCount: int = 0
static var ProcessorCount: int = 0

func Collect():
	_onCollected(COLLECTION)
	queue_free()

const DYNAMO_COEF: float = 1.0 / 64.0
const DYNAMO_POWER: float = 0.1
const DYNAMO_SLOW: float = 1.0 - 2.0 * DYNAMO_POWER

func _onCollected(type: Materials.Mats, Sources: Array[Notification.Sources] = []) -> void:
	if UpgradesManager.Load("Dynamo") > 0:
		var percent: float = PlayerClass.Instance.linear_velocity.length() * DYNAMO_COEF
		RunHandler.TimeLeft += percent * DYNAMO_POWER
		PlayerClass.Instance.linear_velocity *= DYNAMO_SLOW
	
	if _tryUpcycle(type, Sources):
		return
	
	if type == Materials.Mats.Components:
		RunHandler.AddResource(Materials.Mats.Components)
		NotificationsManager.SendPickupNotification(Materials.Mats.Components)
		return
	
	if _tryRecycle(type, Sources):
		return
	
	if type == Materials.Mats.Metals:
		_onMetalCollected(type, Sources)
	elif type == Materials.Mats.Ceramics:
		_onCeramicCollected(type, Sources)
	elif type == Materials.Mats.Synthetics:
		_onSyntheticCollected(type, Sources)
	elif type == Materials.Mats.Organics:
		_onOrganicCollected(type, Sources)

func _tryRecycle(type: Materials.Mats, Sources: Array[Notification.Sources]) -> bool:
	if UpgradesManager.Load("Recycler") < 1:
		return false
	var target := _getLowestResourceFromMaterials(MaterialsManager.Mats, _getLowestResourceFromMaterials(RunHandler.BayMats, Materials.Mats.Organics))
	
	RecyclerCount += 1
	if RecyclerCount % 4 == 0:
		if target == type:
			RecyclerCount -= 1
			return false
		Sources.append(Notification.Sources.RECYCLER)
		if RunHandler.AddResource(target):
			NotificationsManager.SendTransformNotification(type, target, Sources)
			return true
	return false

func _tryUpcycle(type: Materials.Mats, Sources: Array[Notification.Sources]) -> bool:
	if UpgradesManager.Load("Upcycler") < 1:
		return false
	var toReturn: bool = false
	UpcyclerCount += 1
	if UpcyclerCount % 7 == 0:
		RunHandler.UpcyclerCount += 1
		if RunHandler.UpcyclerCount >= 250 && type != Materials.Mats.Components:
			RunHandler.AddResource(Materials.Mats.Components)
			RunHandler.UpcyclerCount -= 250
			Sources.append(TransformNotification.Sources.UPCYCLER)
			NotificationsManager.SendTransformNotification(type, Materials.Mats.Components, Sources)
			toReturn = true
		else:
			var target := _getLowestResourceFromMaterials(RunHandler.BayMats, _getLowestResourceFromMaterials(MaterialsManager.Mats, Materials.Mats.Synthetics))
			var upcycleCopy: Array[Notification.Sources] = [Notification.Sources.UPCYCLER]
			if target == Materials.Mats.Metals:
				_onMetalCollected(target, upcycleCopy)
			elif target == Materials.Mats.Organics:
				_onOrganicCollected(target, upcycleCopy)
			elif target == Materials.Mats.Synthetics:
				_onSyntheticCollected(target, upcycleCopy)
			elif target == Materials.Mats.Ceramics:
				_onCeramicCollected(target, upcycleCopy)
			else:
				_onSyntheticCollected(target, upcycleCopy)
		if UpgradesManager.Load("Demeter") > 0:
			_onOrganicCollected(Materials.Mats.Organics, [Notification.Sources.DEMETER])
	return toReturn

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

func _onMetalCollected(type: Materials.Mats = Materials.Mats.Metals, Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Kiln") > 0 && !Sources.has(Notification.Sources.KILN):
		KilnCount += 1
		if KilnCount % 2 == 0:
			if UpgradesManager.Load("Hephaestus") > 0 && !Sources.has(Notification.Sources.HEPHAESTUS):
				_onCeramicCollected(Materials.Mats.Ceramics, [Notification.Sources.HEPHAESTUS, Notification.Sources.KILN])
			else:
				Sources.append(Notification.Sources.KILN)
				if UpgradesManager.Load("ProdLine") > 0:
					_onCeramicCollected(type, Sources)
				else:
					if RunHandler.AddResource(Materials.Mats.Ceramics):
						NotificationsManager.SendTransformNotification(type, Materials.Mats.Ceramics, Sources)
				return
	if RunHandler.AddResource(Materials.Mats.Metals):
		NotificationsManager.SendPickupNotification(Materials.Mats.Metals, Sources)

func _onCeramicCollected(type: Materials.Mats = Materials.Mats.Ceramics, Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Scrapper") > 0 && !Sources.has(Notification.Sources.SCRAPPER):
		ScrapperCount += 1
		if ScrapperCount % 2 == 0:
			Sources.append(Notification.Sources.SCRAPPER)
			if UpgradesManager.Load("ProdLine") > 0:
				_onSyntheticCollected(type, Sources)
			else:
				if RunHandler.AddResource(Materials.Mats.Synthetics):
					NotificationsManager.SendTransformNotification(type, Materials.Mats.Synthetics, Sources)
			return
	if UpgradesManager.Load("Forge") > 0:
		ForgeCount += 1
		if ForgeCount % 2 == 0:
			if UpgradesManager.Load("Hephaestus") > 0 && !Sources.has(Notification.Sources.HEPHAESTUS):
				_onMetalCollected(Materials.Mats.Metals, [Notification.Sources.HEPHAESTUS, Notification.Sources.FORGE])
			else:
				Sources.append(Notification.Sources.FORGE)
				if UpgradesManager.Load("ProdLine") > 0:
					_onMetalCollected(type, Sources)
				else:
					if RunHandler.AddResource(Materials.Mats.Metals):
						NotificationsManager.SendTransformNotification(type, Materials.Mats.Metals, Sources)
				return
	if RunHandler.AddResource(Materials.Mats.Ceramics):
		NotificationsManager.SendPickupNotification(Materials.Mats.Ceramics, Sources)

func _onSyntheticCollected(type: Materials.Mats = Materials.Mats.Synthetics, Sources: Array[Notification.Sources] = []):
	if UpgradesManager.Load("Composter") > 0 && !Sources.has(Notification.Sources.COMPOSTER):
		ComposterCount += 1
		if ComposterCount % 2 == 0:
			Sources.append(Notification.Sources.COMPOSTER)
			if UpgradesManager.Load("ProdLine") > 0:
				_onOrganicCollected(type, Sources)
			else:
				if RunHandler.AddResource(Materials.Mats.Organics):
					NotificationsManager.SendTransformNotification(type, Materials.Mats.Organics, Sources)
			return
	if RunHandler.AddResource(Materials.Mats.Synthetics):
		NotificationsManager.SendPickupNotification(Materials.Mats.Synthetics, Sources)

func _onOrganicCollected(type: Materials.Mats = Materials.Mats.Organics, Sources: Array[Notification.Sources] = []):
	#synthesizer
	if UpgradesManager.Load("Processor") > 0 && !Sources.has(Notification.Sources.SYNTHESIZER):
		ProcessorCount += 1
		if ProcessorCount % 2 == 0:
			Sources.append(Notification.Sources.SYNTHESIZER)
			if UpgradesManager.Load("ProdLine") > 0:
				_onSyntheticCollected(type, Sources)
			else:
				if RunHandler.AddResource(Materials.Mats.Synthetics):
					NotificationsManager.SendTransformNotification(type, Materials.Mats.Synthetics, Sources)
			return
	#furnace
	if UpgradesManager.Load("Combustor") > 0 && !Sources.has(Notification.Sources.FURNACE):
		FurnaceCount += 1
		if FurnaceCount % 2 == 0:
			Sources.append(Notification.Sources.FURNACE)
			RunHandler.TimeLeft += 1
			NotificationsManager.SendTransformNotification(type, Materials.Mats.Energy, Sources)
			return
	if RunHandler.AddResource(Materials.Mats.Organics):
		NotificationsManager.SendPickupNotification(Materials.Mats.Organics, Sources)
