extends Entity
class_name PlayerClass

@export var ACCEL_FORCE : float = 32.0
@export var MAX_SPEED : float = 64.0
@export var TURN_ACCEL_DEGREES : float = 180.0
@export var TURN_MAX_SPEED_DEGREES : float = 360.0
#@export var TURN_DAMPENING : float = 50.0
#@export var DRAG_COEFFICIENT : float = 0.9
# @export var ANGULAR_DRAG : float = 0.99
@export var IS_IN_GARAGE : bool = false
@export var CAN_MOVE : bool = true
@export @onready var Stats : PlayerStatBlock = $PlayerStatBlock

signal damage(amount: float)

var _inputDir : Vector2

@onready var ShipVisuals = $ShipVisuals
@onready var Manipulator = $Manipulator
@onready var Laser = $NeedleLaserManager
@onready var RCSCursor := $RCS/RCSTarget
@onready var RCS := $RCS

func _ready():
	_handleStats()
	
	linear_velocity = Vector2(0.0, 0.0)
	angular_velocity = 0.0
	rotation_degrees = -90
	if FileAccess.file_exists(Garage.SHIP_PATH):
		var data : ShipData = load(Garage.SHIP_PATH)
		Garage.CachedShip.copy(data)
	else:
		print(Garage.SHIP_PATH, " does not exist! Defaulting.")
		Garage.CachedShip = ShipData.new()
	
	var toBe : ShipData = Garage.CachedShip
	ShipVisuals.HULL_COLOR = toBe.hull_color
	ShipVisuals.COCKPIT_COLOR = toBe.cockpit_color
	ShipVisuals.ACCENT_COLOR = toBe.accent_color
	ShipVisuals.ACCENT_TYPE = toBe.accent_type
	ShipVisuals.BLINKER_ON_COLOR = toBe.blinker_on
	ShipVisuals.BLINKER_OFF_COLOR = toBe.blinker_off
	ShipVisuals.BLINKER_INTERVAL = toBe.blinker_interval
	ShipVisuals.BLINKER_INTERPOLATION = toBe.blinker_interp
	ShipVisuals.INLINE_COLOR = toBe.inline
	ShipVisuals.OUTLINE_COLOR = toBe.outline
	# move_and_collide(linear_velocity * delta)
	# rotate(deg_to_rad(angular_velocity * delta))
	pass

func _physics_process(delta):
	if IS_IN_GARAGE:
		return
	
	var targetAngularAccel : float = 0
	var targetLinearAccel : Vector2 = Vector2(0, 0)
	
	var thrustDirection: float = 0
	if Stats.Has_RCS && Stats.Has_Better_RCS:
		thrustDirection = $RCS.rotation - deg_to_rad(90)
	else:
		thrustDirection = rotation
	
	_inputDir = Vector2(0, 0)
	if CAN_MOVE:
		if Input.is_action_pressed("forward"):
			_inputDir.x += 1
		if Input.is_action_pressed("backward"):
			_inputDir.x += -1
		if Input.is_action_pressed("strafe right"):
			if Stats.Has_RCS:
				_inputDir.y += 1
			else:
				targetAngularAccel += deg_to_rad(TURN_ACCEL_DEGREES) * delta
		if Input.is_action_pressed("strafe left"):
			if Stats.Has_RCS:
				_inputDir.y += -1
			else:
				targetAngularAccel += -deg_to_rad(TURN_ACCEL_DEGREES) * delta
		if Input.is_action_pressed("turn right"):
			if !Stats.Has_RCS:
				targetAngularAccel += deg_to_rad(TURN_ACCEL_DEGREES) * delta
			if !UpgradesManager.LoadIsEnabled("MovementMode"):
				_inputDir.y += 1
		if Input.is_action_pressed("turn left"):
			if !Stats.Has_RCS:
				targetAngularAccel -= deg_to_rad(TURN_ACCEL_DEGREES) * delta
			if !UpgradesManager.LoadIsEnabled("MovementMode"):
				_inputDir.y += -1
		
		if !UpgradesManager.LoadIsEnabled("MovementMode"):
			if _inputDir.length() > 0.5:
				_inputDir = Vector2(1, 0)
		
		#if inputting, apply that force
		if _inputDir.length() > 0.5:
			#reduce drifting if not strafing
			if Stats.Has_Better_RCS && absf(_inputDir.y) < 0.5:
				var reduceDrift := linear_velocity.normalized().rotated(-thrustDirection)
				_inputDir.y -= sign(reduceDrift.y) if absf(reduceDrift.y) > 0.1 else 0
			if Stats.Has_Better_RCS && absf(_inputDir.x) < 0.5:
				var reduceDrift := linear_velocity.normalized().rotated(-thrustDirection)
				_inputDir.x -= sign(reduceDrift.x) if absf(reduceDrift.x) > 0.1 else 0
			_inputDir = _inputDir.normalized().rotated(thrustDirection)
		#if not inputting, apply opposite velocity
		elif Stats.Has_RCS:
			#decceleration when no input (it's actually just inputting opposite your velocity)
			_inputDir = -linear_velocity.normalized()
		
		targetLinearAccel = _inputDir * ACCEL_FORCE
	
	if CAN_MOVE && Stats.Has_RCS:
		var angleToCursor : float = get_angle_to(RCSCursor.global_position)
		var x := deg_to_rad(TURN_ACCEL_DEGREES)
		var coef := 4.5 if Stats.Has_Better_RCS else 3.5
		var angle_landing_if_deccel_now := angular_velocity / coef
		var dif := angle_difference(angleToCursor, angle_landing_if_deccel_now)
		if absf(dif) < deg_to_rad(5):
			targetAngularAccel = -angular_velocity * delta * coef
		elif dif < 0:
			targetAngularAccel += coef * x * delta
		elif dif > 0:
			targetAngularAccel -= coef * x * delta
		#targetAngularAccel = clampf(targetAngularAccel, -absf(angleToCursor) * delta, absf(angleToCursor) * delta)

	if targetLinearAccel.length() > ACCEL_FORCE:
		targetLinearAccel = targetLinearAccel.normalized() * ACCEL_FORCE
	
	if Input.is_action_pressed("boost"):
		targetLinearAccel *= 2
		targetAngularAccel *= 0.5
	
	apply_force(targetLinearAccel)
	
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	angular_velocity += deg_to_rad(clampf(rad_to_deg(targetAngularAccel), -TURN_ACCEL_DEGREES, TURN_ACCEL_DEGREES))
	angular_velocity = deg_to_rad(clampf(rad_to_deg(angular_velocity), -absf(TURN_MAX_SPEED_DEGREES), absf(TURN_MAX_SPEED_DEGREES)))
	
	# around here would be calls to set thruster visuals based on acceleration

func _handleStats():
	var x: int
	var y: float
	
	if Stats.Has_Better_RCS:
		ACCEL_FORCE += 32
	
	ACCEL_FORCE += 32 * UpgradesManager.Load("Stage0")
	MAX_SPEED += 16 * UpgradesManager.Load("Stage0")
	MAX_SPEED += 64 * UpgradesManager.Load("Booster")
	
	# Manipulator Stats
	if IS_IN_GARAGE || UpgradesManager.Load("Manipulator") < 1:
		Manipulator.queue_free()
	else:
		x = Manipulator.RANGE
		x += 8 * UpgradesManager.Load("BigSpool")
		Manipulator.RANGE = x
		y = Manipulator.EXTEND_SPEED
		y += 32 * UpgradesManager.Load("HookPropel")
		Manipulator.EXTEND_SPEED = y
		y = Manipulator.RETRACT_SPEED
		y += 32 * UpgradesManager.Load("RapidWinch")
		Manipulator.RETRACT_SPEED = y
	
	# Laser Stats
	if IS_IN_GARAGE || UpgradesManager.Load("Laser") < 1:
		Laser.queue_free()
	else:
		x = Laser.RANGE
		x += 16 * UpgradesManager.Load("SpareBattery")
		if UpgradesManager.Load("StrongLaser") > 0:
			x -= 32
		Laser.RANGE = x
		y = Laser.KNOCKBACK_COEF
		y += 2 * UpgradesManager.Load("HeavyLaser")
		if UpgradesManager.Load("StrongLaser") > 0:
			y *= 2
		Laser.KNOCKBACK_COEF = y
		y = Laser.DAMAGE_COEF
		y += 3 * UpgradesManager.Load("StrongLaser")
		Laser.DAMAGE_COEF = y
		y = Laser.MINING_COEF
		y += UpgradesManager.Load("MiningLaser")
		Laser.MINING_COEF = y
		x = Laser.WIDTH
		if UpgradesManager.Load("HeavyLaser") > 0:
			x += 1
		if UpgradesManager.Load("StrongLaser") > 0:
			x += 1
		Laser.WIDTH = x
		Laser.AUTO_LASER = UpgradesManager.Load("AutoPhoton") > 0
		if UpgradesManager.Load("TractorNeedle") > 0:
			Laser.CAN_ATTRACT = true

func _on_body_entered(body : PhysicsBody2D):
	if body is not Entity:
		return
	var other: Entity = body
	if other.DangerousCollision:
		var blunt: float = 0.05 * (self.mass * self.linear_velocity - other.mass * other.linear_velocity).length()
		var abrasion: float = 1 * absf(self.mass * self.angular_velocity + other.mass * other.angular_velocity)
		
		var abrasionResistance = UpgradesManager.Load("AbrResistance") + 1
		var bluntResistance = UpgradesManager.Load("BluntRes") + 1
		var grace = 5
		
		var ddd = (blunt / bluntResistance) + (abrasion / abrasionResistance) - grace
		#damage = maxf(damage, 0)
		#print("Player took damage: ", damage)
		#print("Abrasive: ", abrasion)
		#print("Bludgeon: ", blunt)
		if ddd > 0:
			emit_signal("damage", ddd)
