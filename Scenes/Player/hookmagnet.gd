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

const MAGNETINTERVAL: float = 1.0
var _magnetTimer: float = 0.3

const MAGNET_STRENGTH: float = 200

@export_storage var _trackedTargets: Array[Entity] = []

func _ready():
	_reload()
	if !Engine.is_editor_hint() && UpgradesManager.Load("Magnet") < 1:
		queue_free()
	else:
		show()

func _physics_process(delta):
	if !$"..".CAN_MOVE:
		hide()
		return
	
	if Engine.is_editor_hint():
		return
	
	_magnetTimer += delta
	if _magnetTimer > MAGNETINTERVAL:
		_trackedTargets.clear()
		for teet in get_overlapping_bodies():
			if teet is Entity:
				_trackedTargets.append(teet)
		_magnetTimer = 0
	
	var closest: Entity = null
	var cloDist: float = -000.000
	for bod in _trackedTargets:
		if !is_instance_valid(bod):
			_trackedTargets.erase(bod)
			continue
		if bod is Entity:
			var dif: Vector2 = bod.global_position - global_position
			var dir: Vector2 = dif.normalized()
			var lenx: float = dif.length() - bod.Radius
			
			var test: float = ((bod.global_position + bod.linear_velocity) - (global_position + $"..".linear_velocity)).length()
			if test < cloDist || closest == null:
				closest = bod
				cloDist = test
			
			if lenx < 1:
				lenx = 1
			var strength: float = (RANGE * MAGNET_STRENGTH * -bod.Magnetism) / (lenx ** 2)
			strength *= FORCE_COEF
			if isRepelling:
				strength *= -1
			bod.apply_force(dir * strength)
	
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

func _on_body_entered(body):
	if body is Entity:
		_trackedTargets.append(body)

func _on_body_exited(body):
	if _trackedTargets.has(body):
		_trackedTargets.erase(body)
