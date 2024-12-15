extends RigidBody2D
class_name Entity

signal damaged(damageTaken: float)
signal killed

@export var DangerousCollision := false
@export var isMineable := false
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Materials") var MineWeights: Materials 
@export var isAsteroid := false
@export var isResource := false
@export var isEnemy := false
@export var isPlayer := false
@export var hasHealth := false
@export var MaxHealth: float = 100
@export_storage var Health: float = 100
@export var Magnetism: float = 0
@export var Radius: float = 4
@export var IgnoredByLaser: bool = false

func _ready():
	if hasHealth:
		Health = MaxHealth

func Damage(amount: float) -> bool:
	if !hasHealth:
		return false
	Health -= amount
	emit_signal("damaged", amount)
	if Health <= 0:
		Kill()
	return true

func Kill() -> void:
	emit_signal("killed")

func RollMineable() -> Materials.Mats:
	var total = MineWeights.Metals + MineWeights.Ceramics + MineWeights.Synthetics + MineWeights.Organics
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
	return Materials.Mats.Metals
