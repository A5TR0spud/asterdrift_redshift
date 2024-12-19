@tool
extends Node2D
class_name NeedleLaserManager

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

@export var APOLLO: bool = false

@onready var LaserPrefab := preload("res://Scenes/Player/needle_laser.tscn")

var Entities: Array[Entity] = []

func _ready() -> void:
	_reloadVisuals()
	_reloadCollisions()
	_reloadLasers()
	Instance = self
	if !Engine.is_editor_hint():
		show()

func _reloadLasers() -> void:
	for child in List.get_children():
		if child is NeedleLaserClass:
			child.free()
	if !APOLLO:
		for i in LASER_COUNT:
			var prefab: NeedleLaserClass = LaserPrefab.instantiate()
			prefab.doesOrbit = i != 0
			if LASER_COUNT - 1 > 0:
				prefab._initialAngle = deg_to_rad((i - 1) * 360.0 / (LASER_COUNT - 1))
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
	if APOLLO:
		$ApolloCorona.show()
		$ApolloCorona.size.x = RANGE * 2.0
		$ApolloCorona.size.y = RANGE * 2.0
		$ApolloCorona.position.x = -RANGE
		$ApolloCorona.position.y = -RANGE
	else:
		$ApolloCorona.hide()
	for child in List.get_children():
		if child is NeedleLaserClass:
			child.Line.width = WIDTH
			child.VisLaserInterval = Visuals.BLINKER_INTERVAL
			child._laserColorOn = _laserifyColor(Visuals.BLINKER_ON_COLOR)
			child._laserColorOff = _laserifyColor(Visuals.BLINKER_OFF_COLOR)
			child.Player = Player
			if LASER_COUNT > 1:
				child.RANGE = RANGE + 7
			else:
				child.RANGE = RANGE
			child.KNOCKBACK_COEF = KNOCKBACK_COEF
			child.MINING_COEF = MINING_COEF
			child.CAN_ATTRACT = CAN_ATTRACT
			child.DAMAGE_COEF = DAMAGE_COEF
			child.WIDTH = WIDTH

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

static var Instance: NeedleLaserManager

func _physics_process(delta) -> void:
	if !Player.CAN_MOVE:
		hide()
		return
	if !is_node_ready() || Engine.is_editor_hint():
		return
	
	_closestEntity = _tryNullifyTarget(_closestEntity)
	_farthestEntity = _tryNullifyTarget(_farthestEntity)
	_fastestEntity = _tryNullifyTarget(_fastestEntity)
	_slowestEntity = _tryNullifyTarget(_slowestEntity)
	
	if AUTO_LASER && !APOLLO:
		for col in Entities:
			if !is_instance_valid(col):
				Entities.erase(col)
		for col: Entity in Entities:
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
	
	if APOLLO:
		for ent: Entity in Entities:
			var dir: Vector2 = ent.global_position - Player.global_position
			dir = dir.normalized()
			var pos: Vector2 = ent.global_position - dir * ent.Radius
			var potency: float = 0.6 * float(LASER_COUNT) / float(Entities.size())
			ApplyLaserEffects(ent, pos, dir, -dir, delta, potency)
	
	if !APOLLO:
		var i = -1
		for child in List.get_children():
			if child is NeedleLaserClass:
				i += 1
				child._laserFiring = false
				if !child.is_node_ready():
					continue
				if Input.is_action_pressed("fire"):
					child._laserFiring = true
					child.Target.global_position = get_global_mouse_position()
					continue
				if !AUTO_LASER:
					continue
				if i % 4 == 0:
					if _closestEntity != null:
						child._laserFiring = true
						child.Target.global_position = _closestEntity.global_position
				elif i % 4 == 1:
					if _farthestEntity != null:
						child._laserFiring = true
						child.Target.global_position = _farthestEntity.global_position
				elif i % 4 == 2:
					if _fastestEntity != null:
						child._laserFiring = true
						child.Target.global_position = _fastestEntity.global_position
				elif i % 4 == 3:
					if _slowestEntity != null:
						child._laserFiring = true
						child.Target.global_position = _slowestEntity.global_position

func _on_ship_visuals_firemalasar():
	_reloadVisuals()

func _tryNullifyTarget(target) -> Entity:
	if !is_instance_valid(target):
		target = null
	
	if target != null && target is not Entity:
		target = null
	
	if target != null && target is Entity:
		if target.global_position.distance_to(global_position) > RANGE + target.Radius:
			target = null
		elif target.IgnoredByLaser:
			target = null
	return target

static func ApplyLaserEffects(target: Entity, global_pos: Vector2, laser_direction: Vector2, normal: Vector2, delta: float = 1.0, potency: float = 1.0) -> void:
	var doDamage: float = 0.0
	if target.DangerousCollision || target.isAsteroid:
		var kb: Vector2 = Instance.FORCE * (laser_direction * 1.1 - normal).normalized()
		if Instance.CAN_ATTRACT:
			kb *= 0.5
		target.apply_force(potency * kb * Instance.KNOCKBACK_COEF, global_pos - target.global_position)
		doDamage += Instance.DAMAGE_COEF * delta
	if target.isResource && Instance.CAN_ATTRACT:
		var kbDir: Vector2 = -laser_direction * 2.0 + normal
		var extraPower: float = 1.0
		if UpgradesManager.Load("BetterTractorNeedle") > 0:
			extraPower *= 2
			var antiOrbit: Vector2 = Instance.Player.linear_velocity - target.linear_velocity
			var coe: float = absf((-laser_direction + Instance.Player.linear_velocity).dot(target.linear_velocity + Instance.Player.linear_velocity))
			antiOrbit = antiOrbit.normalized()
			kbDir = kbDir * (coe) - antiOrbit * (1.0 - coe) * 2.0
		target.apply_force(potency * extraPower * Instance.FORCE * kbDir.normalized() * 0.08 * Instance.KNOCKBACK_COEF, global_pos - target.global_position)
	if target is Mineable && Instance.MINING_COEF > 0:
		target.Mine(global_pos + normal * 4, potency * Instance.MINING_COEF * delta)
	if target.hasHealth && doDamage > 0:
		target.Damage(potency * doDamage)


func _on_laser_area_body_entered(body):
	if body is Entity:
		Entities.append(body)


func _on_laser_area_body_exited(body):
	if Entities.has(body):
		Entities.erase(body)
