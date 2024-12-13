@tool
extends Node2D

@onready var Area := $LaserArea
@onready var ACol := $LaserArea/CollisionShape2D
@onready var Player := $".."
@onready var Visuals := $"../ShipVisuals"
@onready var List := $LaserList

@onready var Collect := preload("res://Scenes/World/Decoration/collectable.tscn")

@export var RANGE: int = 8 * 16:
	get:
		return RANGE
	set(value):
		RANGE = value
		if is_node_ready():
			ACol.shape.radius = RANGE

@export var LASER_COUNT: int = 1:
	get:
		return LASER_COUNT
	set(value):
		LASER_COUNT = value
		if is_node_ready():
			_reloadLasers()

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

@onready var LaserPrefab := preload("res://Scenes/Player/needle_laser.tscn")

func _ready() -> void:
	_reloadVisuals()
	_reloadCollisions()
	_reloadLasers()
	if !Engine.is_editor_hint():
		show()

func _reloadLasers() -> void:
	for child in List.get_children():
		if child is NeedleLaserClass:
			child.free()
	for i in LASER_COUNT:
		var prefab: NeedleLaserClass = LaserPrefab.instantiate()
		prefab.doesOrbit = i != 0
		if LASER_COUNT - 1 > 0:
			prefab._initialAngle = deg_to_rad((i - 1) * 360 / (LASER_COUNT - 1))
		List.add_child(prefab)
	_reloadVisuals()
	_reloadCollisions()

func _reloadCollisions() -> void:
	if CAN_ATTRACT:
		#4 is resource
		Area.collision_mask |= 4
		for child in List.get_children():
			if child is NeedleLaserClass:
				child.Ray.collision_mask |= 4

func _reloadVisuals() -> void:
	if !is_node_ready():
		return
	var i: int = 0
	for child in List.get_children():
		if child is NeedleLaserClass:
			child.Line.width = WIDTH
			child.VisLaserInterval = Visuals.BLINKER_INTERVAL
			child._laserColorOn = _laserifyColor(Visuals.BLINKER_ON_COLOR)
			child._laserColorOff = _laserifyColor(Visuals.BLINKER_OFF_COLOR)
			child.Player = Player
			if LASER_COUNT > 1 && i != 0:
				child.RANGE = RANGE + 16
			else:
				child.RANGE = RANGE
			child.KNOCKBACK_COEF = KNOCKBACK_COEF
			child.MINING_COEF = MINING_COEF
			child.CAN_ATTRACT = CAN_ATTRACT
			child.DAMAGE_COEF = DAMAGE_COEF
			child.WIDTH = WIDTH
			i += 1

func _laserifyColor(col: Color) -> Color:
	if col.r + col.g + col.b < 0.5:
		col = Color.WHITE
	col.r = col.r * 0.5 + 0.5
	col.g = col.g * 0.5 + 0.5
	col.b = col.b * 0.5 + 0.5
	col.a = 1
	return col

var _closestEntity: Entity = null
var _farthestEntity: Entity = null
var _fastestEntity: Entity = null
var _slowestEntity: Entity = null

func _physics_process(delta) -> void:
	if !Player.CAN_MOVE:
		hide()
		return
	if !is_node_ready() || Engine.is_editor_hint():
		return
	
	if !is_instance_valid(_closestEntity):
		_closestEntity = null
	if !is_instance_valid(_farthestEntity):
		_farthestEntity = null
	if !is_instance_valid(_fastestEntity):
		_fastestEntity = null
	if !is_instance_valid(_slowestEntity):
		_slowestEntity = null
	
	if _closestEntity != null:
		if _closestEntity.global_position.distance_to(global_position) > RANGE + _closestEntity.Radius:
			_closestEntity = null
		elif _closestEntity.IgnoredByLaser:
			_closestEntity = null
	if _farthestEntity != null:
		if _farthestEntity.global_position.distance_to(global_position) > RANGE + _farthestEntity.Radius:
			_farthestEntity = null
		elif _farthestEntity.IgnoredByLaser:
			_farthestEntity = null
	if _fastestEntity != null:
		if _fastestEntity.global_position.distance_to(global_position) > RANGE + _fastestEntity.Radius:
			_fastestEntity = null
		elif _fastestEntity.IgnoredByLaser:
			_fastestEntity = null
	if _slowestEntity != null:
		if _slowestEntity.global_position.distance_to(global_position) > RANGE + _slowestEntity.Radius:
			_slowestEntity = null
		elif _slowestEntity.IgnoredByLaser:
			_slowestEntity = null
	
	var collidersList : Array[Node2D] = Area.get_overlapping_bodies()
	for col in collidersList:
		if col is Entity:
			if col.IgnoredByLaser:
				continue
			if !col.isAsteroid && !col.DangerousCollision:
				if col.isResource && !CAN_ATTRACT:
					continue
			
			if _closestEntity == null:
				_closestEntity = col
			if _farthestEntity == null:
				_farthestEntity = col
			if _fastestEntity == null:
				_fastestEntity = col
			if _slowestEntity == null:
				_slowestEntity = col
			#close
			var test1: float = col.global_position.distance_to(global_position) - col.Radius
			var test2: float = _closestEntity.global_position.distance_to(global_position) - _closestEntity.Radius
			if test1 < test2:
				_closestEntity = col
			#far
			test2 = _farthestEntity.global_position.distance_to(global_position) - _closestEntity.Radius
			if test1 > test2:
				_farthestEntity = col
			#fast
			test1 = col.linear_velocity.length()
			test2 = _fastestEntity.linear_velocity.length()
			if test1 > test2:
				_fastestEntity = col
			#slow
			test2 = _slowestEntity.linear_velocity.length()
			if test1 < test2:
				_slowestEntity = col
	
	var i = -1
	for child in List.get_children():
		if child is NeedleLaserClass:
			i += 1
			child._laserFiring = false
			if !child.is_node_ready():
				continue
			if i % 4 == 0:
				if Input.is_action_pressed("fire"):
					child._laserFiring = true
					child.Target.global_position = get_global_mouse_position()
				elif AUTO_LASER && _closestEntity != null:
					child._laserFiring = true
					child.Target.global_position = _closestEntity.global_position
			elif i % 4 <= 1:
				if _farthestEntity != null:
					child._laserFiring = true
					child.Target.global_position = _farthestEntity.global_position
			elif i % 4 <= 2:
				if _fastestEntity != null:
					child._laserFiring = true
					child.Target.global_position = _fastestEntity.global_position
			elif i % 4 <= 3:
				if _slowestEntity != null:
					child._laserFiring = true
					child.Target.global_position = _slowestEntity.global_position

func _on_ship_visuals_firemalasar():
	_reloadVisuals()
