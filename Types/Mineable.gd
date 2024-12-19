extends Entity
class_name Mineable

@export var MaxMiningHealth: float = 100
@export_storage var MiningHealth: float = 100
@export var MaxResources: int = 20
@export_storage var ResourcesLeft: int = 20
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Materials") var MineWeights: Materials 

@warning_ignore("unused_signal")
signal resource_mined(global_pos: Vector2)

func _ready():
	ResourcesLeft = MaxResources
	MiningHealth = MaxMiningHealth

func RollMineable() -> Materials.Mats:
	var total = MineWeights.Metals + MineWeights.Ceramics + MineWeights.Synthetics + MineWeights.Organics + MineWeights.Components
	var sel = randi_range(1, total)
	if sel <= MineWeights.Metals:
		return Materials.Mats.Metals
	sel -= MineWeights.Metals
	if sel <= MineWeights.Ceramics:
		return Materials.Mats.Ceramics
	sel -= MineWeights.Ceramics
	if sel <= MineWeights.Synthetics:
		return Materials.Mats.Synthetics
	sel -= MineWeights.Synthetics
	if sel <= MineWeights.Organics:
		return Materials.Mats.Organics
	sel -= MineWeights.Organics
	if sel <= MineWeights.Components:
		return Materials.Mats.Components
	sel -= MineWeights.Components
	return Materials.Mats.Metals

func Mine(global_pos: Vector2, mining_damage: float) -> void:
	MiningHealth -= mining_damage
	var shouldBeLeft = ceili(float(MaxResources) * (MiningHealth / MaxMiningHealth))
	if ResourcesLeft > shouldBeLeft:
		ResourcesLeft -= 1
		emit_signal("resource_mined", global_pos) 
