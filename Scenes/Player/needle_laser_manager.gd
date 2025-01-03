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
@export var ARTEMIS: bool = false

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
		$ApolloCorona.scale.x = RANGE / 8.0
		$ApolloCorona.scale.y = RANGE / 8.0
		$ApolloCorona.position.x = -RANGE
		$ApolloCorona.position.y = -RANGE
		$ApolloCorona.modulate.a = 0.9
		if ARTEMIS:
			var x: ShaderMaterial = $ApolloCorona.material
			var c1: Color = _laserifyColor(Visuals.BLINKER_ON_COLOR, true)
			var c2: Color = _laserifyColor(Visuals.BLINKER_OFF_COLOR, false)
			c2.a = 0
			x.set_shader_parameter("Color1", c1)
			x.set_shader_parameter("Color2", c2)
			x.set_shader_parameter("coronaCount", 6)
			x.set_shader_parameter("coronaSpeed", 0.3)
			x.set_shader_parameter("coronaPercent", 0.01)
			x.set_shader_parameter("coronaPercentPulse", 0.005)
			x.set_shader_parameter("coronaPercentPulseSpeed", 1.0)
			x.set_shader_parameter("coronaFadeOut", true)
			var y: ShaderMaterial = $ApolloCorona/ApolloFlare.material
			y.set_shader_parameter("Color1", c1)
			y.set_shader_parameter("Color2", c2)
			y.set_shader_parameter("layers", 3)
			y.set_shader_parameter("sharpness", 27)
			#y.set_shader_parameter("coronaCount", 6)
			$ApolloCorona.modulate.a = 0.5
	else:
		$ApolloCorona.hide()
	for child in List.get_children():
		if child is NeedleLaserClass:
			child.Line.width = WIDTH
			child.VisLaserInterval = Visuals.BLINKER_INTERVAL if UpgradesManager.Load("Artemis") < 1 else 5
			child._laserColorOn = _laserifyColor(Visuals.BLINKER_ON_COLOR, true)
			child._laserColorOff = _laserifyColor(Visuals.BLINKER_OFF_COLOR, false)
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
			child.ARTEMIS = ARTEMIS

func _laserifyColor(col: Color, on: bool) -> Color:
	if ARTEMIS:
		if UpgradesManager.Load("Apollo") > 0:
			if on:
				col = Color(1, 0.5, 1, 1)
			if !on:
				col = Color(0.5, 0.5, 1, 1)
			return col
		if on:
			col = Color(0.6, 0.5, 1, 1)
		if !on:
			col = Color(0.5, 0.8, 1, 1)
		return col
	
	#if col.r + col.g + col.b < 0.5:
		#col = Color.WHITE
	col.r = col.r * 0.5 + 0.5
	col.g = col.g * 0.5 + 0.5
	col.b = col.b * 0.5 + 0.5
	col.a = 1
	return col

#auto
var _closestEntity: Entity = null
var _farthestEntity: Entity = null
var _fastestEntity: Entity = null
var _slowestEntity: Entity = null
var _arbitraryEntity: Entity = null
var _closestCollectable: Entity = null
var _farthestCollectable: Entity = null
var _closestThreat: Entity = null

#artemis
var _focusFireTarget: Entity = null
var _artemisTarget: Entity = null
var _firstTarget: Entity = null
var _lastTarget: Entity = null
var _approachingTarget: Entity = null
var _divergingTarget: Entity = null

#smart
var _divergingResource: Entity = null
var _divergingResourceWeight: float = 0
var _approachingThreat: Entity = null
var _approachingThreatWeight: float = 0

static var Instance: NeedleLaserManager

const RETARGET_INTERVAL: float = 0.25
var _retarget_timer: float = 0
var _force_retarget: bool = true

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
	_arbitraryEntity = _tryNullifyTarget(_arbitraryEntity)
	_closestCollectable = _tryNullifyTarget(_closestCollectable)
	_farthestCollectable = _tryNullifyTarget(_farthestCollectable)
	_closestThreat = _tryNullifyTarget(_closestThreat)
	if ARTEMIS:
		_firstTarget = _tryNullifyTarget(_firstTarget)
		_lastTarget = _tryNullifyTarget(_lastTarget)
		_approachingTarget = _tryNullifyTarget(_approachingTarget)
		_divergingTarget = _tryNullifyTarget(_divergingTarget)
		_approachingThreat = _tryNullifyTarget(_approachingThreat)
		_divergingResource = _tryNullifyTarget(_divergingResource)
		
		_artemisTarget = _tryNullifyTarget(_artemisTarget)
		if _artemisTarget == null:
			_force_retarget = true
	
	if !_isLaserTargetable(_focusFireTarget):
		_focusFireTarget = null
	
	_retarget_timer -= delta
	
	if AUTO_LASER && !APOLLO && (_retarget_timer <= 0 || _force_retarget):
		_retarget_timer = RETARGET_INTERVAL
		_force_retarget = false
		var priRes: bool = UpgradesManager.LoadIsEnabled("PriorityResource")
		var targetOnlyRes: bool = false
		for col in Entities:
			if !is_instance_valid(col):# || _tryNullifyTarget(col) == null || !_isLaserTargetable(col):
				Entities.erase(col)
				continue
			if _isLaserTargetable(col):
				if priRes && col.isResource:
					targetOnlyRes = true
		for col: Entity in Entities:
			if !_isLaserTargetable(col):
				continue
			if _firstTarget == null:
				_firstTarget = col
			_lastTarget = col
			#near
			var test1: float = col.global_position.distance_squared_to(global_position) - col.Radius
			var test2: float = -1
			if _closestEntity != null:
				test2 = _closestEntity.global_position.distance_squared_to(global_position) - _closestEntity.Radius
			if test1 < test2 || _closestEntity == null:
				if targetOnlyRes:
					if col.isResource:
						_closestEntity = col
						_closestThreat = col
				else:
					_closestEntity = col
					if col.DangerousCollision:
						_closestThreat = col
				if col.isResource:
					_closestCollectable = col
			#far
			if _farthestEntity != null:
				test2 = _farthestEntity.global_position.distance_squared_to(global_position)
			if test1 > test2 || _farthestEntity == null:
				if targetOnlyRes:
					if col.isResource:
						_farthestEntity = col
				else:
					_farthestEntity = col
				if col.isResource:
					_farthestCollectable = col
			#fast
			test1 = col.linear_velocity.length_squared()
			if _fastestEntity != null:
				test2 = _fastestEntity.linear_velocity.length_squared()
			if test1 > test2 || _fastestEntity == null:
				if targetOnlyRes:
					if col.isResource:
						_fastestEntity = col
				else:
					_fastestEntity = col
			#slow
			if _slowestEntity != null:
				test2 = _slowestEntity.linear_velocity.length_squared()
			if test1 < test2 || _slowestEntity == null:
				if targetOnlyRes:
					if col.isResource:
						_slowestEntity = col
				else:
					_slowestEntity = col
			
			#artemis-exclusives beyond this point
			if !ARTEMIS:
				continue
			#approaching
			var dir: Vector2 = col.global_position - global_position
			var vdr: Vector2 = col.linear_velocity - Player.linear_velocity
			var coe: float = dir.dot(vdr)
			test1 = vdr.length_squared() * coe
			if _approachingTarget != null:
				dir = _approachingTarget.global_position - global_position
				vdr = _approachingTarget.linear_velocity - Player.linear_velocity
				coe = dir.dot(vdr)
				test2 = vdr.length_squared() * coe
			if test1 < test2 || _approachingTarget == null:
				if col.DangerousCollision || col.isAsteroid || col.isEnemy:
					_approachingThreat = col
					_approachingThreatWeight = -test2 / dir.length()
				
				if targetOnlyRes:
					if col.isResource:
						_approachingTarget = col
				else:
					_approachingTarget = col
			#diverging
			if _divergingTarget != null:
				dir = _divergingTarget.global_position - global_position
				vdr = _divergingTarget.linear_velocity - Player.linear_velocity
				coe = dir.dot(vdr)
				test2 = vdr.length_squared() * coe
			if test1 > test2 || _divergingTarget == null:
				if col.isResource:
					_divergingResource = col
					_divergingResourceWeight = test2 * 0.5
				
				if targetOnlyRes:
					if col.isResource:
						_divergingTarget = col
				else:
					_divergingTarget = col
		if _closestCollectable == null:
			_closestCollectable = _closestEntity
		if _farthestCollectable == null:
			_farthestCollectable = _farthestEntity
		if _closestThreat == null:
			_closestThreat = _fastestEntity
		if ARTEMIS:
			var artSetting: int = UpgradesManager.Load("ArtemisSetting")
			if artSetting == 2:
				#first
				_artemisTarget = _firstTarget
			elif artSetting == 3:
				#last
				_artemisTarget = _lastTarget
			elif artSetting == 4:
				#near
				_artemisTarget = _closestEntity
			elif artSetting == 5:
				#far
				_artemisTarget = _farthestEntity
			elif artSetting == 6:
				#approaching
				_artemisTarget = _approachingTarget
			elif artSetting == 7:
				#diverging
				_artemisTarget = _divergingTarget
			else:
				#smart
				if _approachingThreatWeight > _divergingResourceWeight:
					_artemisTarget = _approachingThreat
				else:
					_artemisTarget = _divergingResource
	
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
				if Input.is_action_pressed("fire") && UpgradesManager.LoadIsEnabled("CursorOverride"):
					child._laserFiring = true
					child.beingManuallyControlled = true
					child.Target.global_position = get_global_mouse_position()
					if UpgradesManager.Load("FocusFire"):
						var ray: RayCast2D = child.Ray
						child.Target.position = child.Target.position.normalized() * child.RANGE
						ray.position = Vector2.ZERO
						ray.target_position = child.Target.position
						ray.force_update_transform()
						ray.force_raycast_update()
						if ray.is_colliding():
							var col := ray.get_collider()
							if col is Entity:
								if _isLaserTargetable(col):
									_focusFireTarget = col
						else:
							_focusFireTarget = null
					continue
				else:
					child.beingManuallyControlled = false
				if !AUTO_LASER:
					continue
				if UpgradesManager.Load("FocusFire") > 0 && _tryTarget(child, _focusFireTarget):
					continue
				if ARTEMIS && _tryTarget(child, _artemisTarget):
					continue
				if i % 8 == 0:
					_tryTarget(child, _closestEntity)
				elif i % 8 == 1:
					_tryTarget(child, _farthestEntity)
				elif i % 8 == 2:
					_tryTarget(child, _fastestEntity)
				elif i % 8 == 3:
					_tryTarget(child, _slowestEntity)
				elif i % 8 == 4:
					_tryTarget(child, _arbitraryEntity)
				elif i % 8 == 5:
					_tryTarget(child, _closestCollectable)
				elif i % 8 == 6:
					_tryTarget(child, _farthestCollectable)
				elif i % 8 == 7:
					_tryTarget(child, _closestThreat)

func _tryTarget(child: NeedleLaserClass, target: Entity) -> bool:
	if is_instance_valid(target) && target != null && _isTargetInRange(target):
		child.Target.global_position = target.global_position
		child._laserFiring = true
		if child.ARTEMIS:
			child.artemisEntity = target
		return true
	else:
		child._laserFiring = false
	return false

func _on_ship_visuals_firemalasar():
	_reloadVisuals()

func _isLaserTargetable(target) -> bool:
	if _tryNullifyTarget(target, true) == null:
		return false
	if target is not Entity:
		return false
	if target.IgnoredByLaser:
		return false
	if target.DangerousCollision || target.isAsteroid:
		return true
	if target.isResource && CAN_ATTRACT:
		return true
	return false

func _isTargetInRange(target) -> bool:
	if _tryNullifyTarget(target, true) == null:
		return false
	return target.global_position.distance_to(global_position) <= RANGE + target.Radius

func _tryNullifyTarget(target, ignoreDistance: bool = false) -> Entity:
	if target == null:
		return null
	
	if !is_instance_valid(target):
		return null
	
	if target is Entity:
		if !ignoreDistance && !_isTargetInRange(target):
			return null
		if target.IgnoredByLaser:
			return null
	else:
		return null
	
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
			if antiOrbit.length_squared() > 0.1:
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
		_force_retarget = true


func _on_laser_area_body_exited(body):
	if Entities.has(body):
		Entities.erase(body)
		_force_retarget = true
