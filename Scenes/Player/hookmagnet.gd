@tool
extends Area2D

@export var RANGE: int = 80:
	get:
		return RANGE
	set(value):
		RANGE = value
		if is_node_ready():
			_reload()

@export var FORCE_COEF: float = 1.0
@export_storage var isRepelling: bool = false

const MAGNETINTERVAL: float = 0.12
var _magnetTimer: float = 0.3

func _ready():
	_reload()
	if !Engine.is_editor_hint() && UpgradesManager.Load("Magnet") < 1:
		queue_free()

func _physics_process(delta):
	if !$"..".CAN_MOVE:
		hide()
		return
	
	_magnetTimer += delta
	if _magnetTimer < MAGNETINTERVAL:
		return
	_magnetTimer -= MAGNETINTERVAL
	
	var closest: Entity = null
	var cloDist: float = -000.000
	for bod in get_overlapping_bodies():
		if bod is Entity:
			var dif: Vector2 = bod.global_position - global_position
			var dir: Vector2 = dif.normalized()
			var len: float = dif.length() - bod.Radius
			
			var test: float = ((bod.global_position + bod.linear_velocity) - (global_position + $"..".linear_velocity)).length()
			#if bod.isAsteroid || bod.DangerousCollision:
			#	test *= 2
			if test < cloDist || closest == null:
				closest = bod
				cloDist = test
			
			if len < 1:
				len = 1
			var strength: float = (RANGE * 100 * -bod.Magnetism) / (len ** 2)
			strength *= FORCE_COEF
			if isRepelling:
				strength *= -1
			bod.apply_impulse(dir * strength * _magnetTimer)
			#$"..".apply_force(-dir * strength)
	
	if closest != null:
		isRepelling = closest.isAsteroid || closest.DangerousCollision
	elif !Engine.is_editor_hint():
		$Attract.hide()
		$Repel.hide()
	if closest != null && !Engine.is_editor_hint():
		if isRepelling:
			$Attract.hide()
			$Repel.show()
		else:
			$Attract.show()
			$Repel.hide()

func _reload():
	$CollisionShape2D.shape.radius = RANGE
	$Attract.scale.x = RANGE / 8.0
	$Attract.position.x = -RANGE
	$Attract.scale.y = RANGE / 8.0
	$Attract.position.y = -RANGE
	$Repel.scale.x = RANGE / 8.0
	$Repel.position.x = -RANGE
	$Repel.scale.y = RANGE / 8.0
	$Repel.position.y = -RANGE
