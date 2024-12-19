@tool
extends Node2D
class_name NeedleLaserClass

@onready var Line := $LaserLine
@onready var Target := $LaserTarget
@onready var Ray := $LaserRay
@onready var Endpoint := $Endpoint
@export var Player: PlayerClass
@export var VisLaserInterval: float

@onready var Collect := preload("res://Scenes/World/Decoration/collectable.tscn")

@export var RANGE: int = 8 * 16:
	get:
		return RANGE
	set(value):
		RANGE = value

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

@export var _laserColorOn: Color
@export var _laserColorOff: Color
var _laserTime: float
@export var _laserFiring: bool = false
@export var _initialAngle: float = 0

func _ready() -> void:
	_laserFiring = false
	_reloadVisuals()
	_reloadCollisions()

func _reloadCollisions() -> void:
	if CAN_ATTRACT:
		#4 is resource
		Ray.collision_mask |= 4

func _reloadVisuals() -> void:
	if !is_node_ready():
		return
	Line.width = WIDTH

func _process(delta):
	_laserTime += delta / (VisLaserInterval * 0.5)
	_laserTime = _laserTime - 2.0 * floori(_laserTime * 0.5)
	var x = absf(1.0 - _laserTime)
	var c: Color = lerp(_laserColorOff, _laserColorOn, x)
	$LaserLine.default_color = c
	$Endpoint/Color.modulate = c

@export var orbitTime: float = 0
@export var doesOrbit: bool = false

func _physics_process(delta) -> void:
	if Player == null:
		return
	if !Player.CAN_MOVE:
		hide()
		return
	
	if doesOrbit:
		position.y = 7.0 * sin(_initialAngle + orbitTime)
		position.x = 7.0 * cos(_initialAngle + orbitTime)
		orbitTime += delta
	
	Target.position = Target.position.normalized() * RANGE
	
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
			var dir: Vector2 = Target.position.normalized()
			NeedleLaserManager.ApplyLaserEffects(c, dir, point, normal, delta)
	Line.points[1] = Endpoint.position
