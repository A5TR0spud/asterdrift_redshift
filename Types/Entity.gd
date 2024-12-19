extends RigidBody2D
class_name Entity

signal damaged(damageTaken: float)
signal killed

@export var DangerousCollision := false
@export var isAsteroid := false
@export var isResource := false
@export var isEnemy := false
@export var isPlayer := false
@export var hasHealth := false
@export var MaxHealth: float = 100:
	get:
		return MaxHealth
	set(value):
		MaxHealth = value
		if Health > MaxHealth:
			Health = MaxHealth
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
