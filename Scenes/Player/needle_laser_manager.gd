@tool
extends Node2D

@onready var Area := $LaserArea
@onready var ACol := $LaserArea/CollisionShape2D
@onready var Line := $LaserLine
@onready var Target := $LaserTarget
@onready var Ray := $LaserRay
@onready var Endpoint := $Endpoint
@onready var Player := $".."
@onready var Visuals := $"../ShipVisuals"

@onready var Collect := preload("res://Scenes/World/Decoration/collectable.tscn")

@export var RANGE: int = 8 * 16:
	get:
		return RANGE
	set(value):
		RANGE = value
		if is_node_ready():
			ACol.shape.radius = RANGE

@export var KNOCKBACK_COEF: float = 1
@export_storage var FORCE: float = 35
@export var MINING_COEF: float = 0
@export var CAN_ATTRACT: bool = false:
	get:
		return CAN_ATTRACT
	set(value):
		CAN_ATTRACT = value
		if is_node_ready():
			_reloadCollisions()
@export var DAMAGE_COEF: float = 1
@export var AUTO_LASER: bool = false
@export var WIDTH: int = 1:
	get:
		return WIDTH
	set(value):
		WIDTH = value
		if is_node_ready():
			_reloadVisuals()

var _laserColorOn: Color
var _laserColorOff: Color
var _laserTime: float
var _colTime: float = 0.0
var _laserFiring: bool = false

func _ready() -> void:
	Ray.add_exception($"..")
	#Ray.add_exception($"../CollisionShape2D")
	_colTime = 0.0
	_reloadVisuals()
	_reloadCollisions()

func _reloadCollisions() -> void:
	if CAN_ATTRACT:
		#4 is resource
		Area.collision_mask |= 4
		Ray.collision_mask |= 4

func _reloadVisuals() -> void:
	if !is_node_ready():
		return
	Line.width = WIDTH
	_laserColorOn = _laserifyColor(Visuals.BLINKER_ON_COLOR)
	_laserColorOff = _laserifyColor(Visuals.BLINKER_OFF_COLOR)

func _process(delta):
	_laserTime += delta / (Visuals.BLINKER_INTERVAL * 0.5)
	_laserTime = _laserTime - 2.0 * floori(_laserTime * 0.5)
	var x = absf(1.0 - _laserTime)
	var c: Color = lerp(_laserColorOff, _laserColorOn, x)
	$LaserLine.default_color = c
	$Endpoint/Color.modulate = c

func _laserifyColor(col: Color) -> Color:
	if col.r + col.g + col.b < 0.5:
		col = Color.WHITE
	col.r = col.r * 0.5 + 0.5
	col.g = col.g * 0.5 + 0.5
	col.b = col.b * 0.5 + 0.5
	col.a = 1
	return col

var _autoTargettedEntity: Entity = null

func _physics_process(delta) -> void:
	if !Player.CAN_MOVE:
		hide()
		return
	_laserFiring = false
	
	if !is_instance_valid(_autoTargettedEntity):
		_autoTargettedEntity = null
	if _autoTargettedEntity != null:
		if _autoTargettedEntity.global_position.distance_to(global_position) > RANGE + _autoTargettedEntity.Radius:
			_autoTargettedEntity = null
		elif _autoTargettedEntity.IgnoredByLaser:
			_autoTargettedEntity = null
	
	if !Engine.is_editor_hint() && Input.is_action_pressed("fire"):
		var v: Vector2 = get_local_mouse_position()
		Target.position = v
	if !Engine.is_editor_hint() && AUTO_LASER && !Input.is_action_pressed("fire"):
		var dis: float = -000.000
		if _autoTargettedEntity != null:
			dis = _autoTargettedEntity.global_position.distance_to(global_position) - _autoTargettedEntity.Radius
		for thing in Area.get_overlapping_bodies():
			if thing is Entity:
				if thing.isPlayer:
					continue
				if thing.IgnoredByLaser:
					continue
				if !thing.isAsteroid && !thing.DangerousCollision:
					if thing.isResource && !CAN_ATTRACT:
						continue
				var tes: float = thing.global_position.distance_to(global_position) - thing.Radius
				if tes < dis || _autoTargettedEntity == null:
					_autoTargettedEntity = thing
					dis = tes
	if _autoTargettedEntity != null && !Input.is_action_pressed("fire"):
		Target.global_position = _autoTargettedEntity.global_position
		_laserFiring = true
	
	Target.position = Target.position.normalized() * RANGE
	
	if !Engine.is_editor_hint() && Input.is_action_pressed("fire"):
		_laserFiring = true
	
	Ray.position = Vector2.ZERO
	Ray.target_position = Target.position
	Endpoint.position = Target.position
	
	if _laserFiring:
		Ray.force_update_transform()
		Ray.force_raycast_update()
		show()
	elif !Engine.is_editor_hint():
		hide()
	
	if _laserFiring && Ray.is_colliding() && is_instance_valid(Ray.get_collider()):
		var point: Vector2 = Ray.get_collision_point()
		Endpoint.position = point - global_position
		var c: Object = Ray.get_collider()
		if c is Entity:
			var normal: Vector2 = Ray.get_collision_normal()
			var doDamage: float = 0.0
			if c.DangerousCollision || c.isAsteroid:
				var dir: Vector2 = Target.position.normalized()
				var kb: Vector2 = FORCE * (dir * 1.1 - normal).normalized()
				if CAN_ATTRACT:
					kb *= 0.5
				c.apply_force(kb * KNOCKBACK_COEF, point - c.global_position)
				doDamage += DAMAGE_COEF * delta
			if c.isResource && CAN_ATTRACT:
				var dir: Vector2 = -Target.position.normalized()
				var kb: Vector2 = FORCE * (dir * 2.0 + normal).normalized()
				c.apply_force(kb * 0.08 * KNOCKBACK_COEF, point - c.global_position)
			if c.isMineable:
				_colTime += delta * MINING_COEF
				var dd = 5
				if CAN_ATTRACT:
					dd -= 1
				if _colTime > dd:
					_colTime -= 5
					doDamage += 10
					var scene: Collectable = Collect.instantiate()
					get_tree().root.get_child(0).add_child(scene)
					scene.global_position = point + normal * 4
					scene.linear_velocity = normal * 8 * MINING_COEF
					var m: Materials.Mats = c.RollMineable()
					if m == Materials.Mats.Metals:
						scene.COLLECTION = Collectable.ResourcesEnum.Metal
					elif m == Materials.Mats.Ceramics:
						scene.COLLECTION = Collectable.ResourcesEnum.Ceramic
					elif m == Materials.Mats.Synthetics:
						scene.COLLECTION = Collectable.ResourcesEnum.Synthetic
					elif m == Materials.Mats.Organics:
						scene.COLLECTION = Collectable.ResourcesEnum.Organic
					elif m == Materials.Mats.Components:
						scene.COLLECTION = Collectable.ResourcesEnum.Core
			if c.hasHealth && doDamage > 0:
				c.Damage(doDamage)
	Line.points[1] = Endpoint.position


func _on_ship_visuals_firemalasar():
	_reloadVisuals()
