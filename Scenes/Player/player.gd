extends RigidBody2D

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

var _inputDir : Vector2

@onready var ShipVisuals = $ShipVisuals

func _ready():
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

func _process(delta):
	# move_and_collide(linear_velocity * delta)
	# rotate(deg_to_rad(angular_velocity * delta))
	pass

func _physics_process(delta):
	if IS_IN_GARAGE:
		return
	
	var targetAngularAccel : float = 0
	var targetLinearAccel : Vector2 = Vector2(0, 0)
	
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
		
		#if inputting, apply that force
		if _inputDir.length() > 0.5:
			_inputDir = _inputDir.normalized().rotated(rotation)
		#if not inputting, apply opposite velocity
		elif Stats.Has_RCS:
			#decceleration when no input (it's actually just inputting opposite your velocity)
			_inputDir = -linear_velocity.normalized()
		
		targetLinearAccel = _inputDir * ACCEL_FORCE
	
	if CAN_MOVE && Stats.Has_RCS:
		var angleToCursor : float = get_angle_to(get_global_mouse_position())
		var x := deg_to_rad(TURN_ACCEL_DEGREES)
		var coef := 3.5
		var angle_landing_if_deccel_now := angular_velocity / coef
		var dif := angle_difference(angleToCursor, angle_landing_if_deccel_now)
		if dif < 0:
			targetAngularAccel += coef * x * delta
		elif dif > 0:
			targetAngularAccel -= coef * x * delta
		#else:
		#	if sign(angular_velocity) == sign(angleToCursor) || absf(angular_velocity) > deg_to_rad(TURN_ACCEL_DEGREES):
		#		targetAngularAccel += angleToCursor * delta * 0.50
		#	else:
		#		targetAngularAccel += angleToCursor * delta * 1.33
	
	if targetLinearAccel.length() > ACCEL_FORCE:
		targetLinearAccel = targetLinearAccel.normalized() * ACCEL_FORCE
	apply_force(targetLinearAccel)
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED
	
	angular_velocity += deg_to_rad(clampf(rad_to_deg(targetAngularAccel), -TURN_ACCEL_DEGREES, TURN_ACCEL_DEGREES))
	angular_velocity = deg_to_rad(clampf(rad_to_deg(angular_velocity), -absf(TURN_MAX_SPEED_DEGREES), absf(TURN_MAX_SPEED_DEGREES)))
