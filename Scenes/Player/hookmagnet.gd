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

const MAGNET_STRENGTH: float = 200

@export_storage var _trackedTargets: Array[Entity] = []

@onready var Player := $".."

func _ready():
	if !Engine.is_editor_hint() && UpgradesManager.Load("Magnet") < 1:
		queue_free()
	elif !Engine.is_editor_hint():
		RANGE += 16 * UpgradesManager.Load("BiggerCoil")
		FORCE_COEF += UpgradesManager.Load("StrongerCoil")
		_reload()
		show()
		if UpgradesManager.Load("StasisBay") > 0:
			$StasisBay.show()
		else:
			$StasisBay.hide()
		#if UpgradesManager.Load("TractorBay") > 0:
		#	$TractorBay.show()
		#else:
		$TractorBay.hide()

func _physics_process(delta):
	if !Player.CAN_MOVE:
		hide()
		return
	
	if Engine.is_editor_hint():
		return
	
	var closest: Entity = null
	var cloDist: float = -000.000
	$TractorBay.hide()
	for bod in _trackedTargets:
		if !is_instance_valid(bod):
			_trackedTargets.erase(bod)
			continue
		if bod is Entity:
			var dif: Vector2 = bod.global_position - global_position
			var dir: Vector2 = dif.normalized()
			var lenx: float = dif.length() - bod.Radius
			if lenx < 1:
				lenx = 1
			
			if bod.isResource:
				if UpgradesManager.Load("StasisBay") > 0:
					var antiOrbit: Vector2 = Player.linear_velocity - bod.linear_velocity
					var coe: float = absf((dir + Player.linear_velocity).dot(bod.linear_velocity + Player.linear_velocity))
					antiOrbit = antiOrbit.normalized()
					var kbDir: Vector2 = -antiOrbit * (1.0 - coe)
					kbDir *= maxf(kbDir.dot(-dir), 0)
					if kbDir.length() > 1:
						kbDir = kbDir.normalized()
					bod.apply_force(kbDir * FORCE_COEF * 59.0)
				if UpgradesManager.Load("TractorBay") > 0:
					bod.apply_force(-dir * FORCE_COEF * MAGNET_STRENGTH * 5 / (lenx * 0.5 + 0.5))
					$TractorBay.show()
					continue
			
			var test: float = ((bod.global_position + bod.linear_velocity) - (global_position + $"..".linear_velocity)).length()
			if test < cloDist || closest == null:
				closest = bod
				cloDist = test
			
			var strength: float = (RANGE * MAGNET_STRENGTH * -bod.Magnetism) / (lenx ** 2)
			strength *= FORCE_COEF
			if isRepelling:
				strength *= -1
				if bod.isResource && UpgradesManager.Load("StasisBay") > 0:
					strength *= 0.5
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
	$StasisBay.scale.x = RANGE / 8.0
	$StasisBay.position.x = -RANGE
	$StasisBay.scale.y = RANGE / 8.0
	$StasisBay.position.y = -RANGE
	$TractorBay.scale.x = RANGE / 8.0
	$TractorBay.position.x = -RANGE
	$TractorBay.scale.y = RANGE / 8.0
	$TractorBay.position.y = -RANGE

func _on_body_entered(body):
	if body is Entity:
		_trackedTargets.append(body)

func _on_body_exited(body: Node2D):
	if _trackedTargets.has(body):
		_trackedTargets.erase(body)
	#if body is Entity && Player.CAN_MOVE:
	#	if UpgradesManager.Load("StasisBay") > 0 && body.isResource:
	#		var dir: Vector2 = Player.global_position - body.global_position
	#		dir = dir.normalized()
	#		body.linear_velocity = Player.linear_velocity + 2.0 * dir
