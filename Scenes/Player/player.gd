extends Node2D

@export var ACCEL : float = 256
@export var MAX_SPEED : float = 512
@export var TURN_ACCEL : float = 180.0
@export var TURN_MAX_SPEED : float = 180.0
@export var TURN_DAMPENING : float = 0.5
@export var DRAG_COEFFICIENT : float = 0.9
@export var ANGULAR_DRAG : float = 0.99
@export var IS_IN_GARAGE : bool = false
@export var CAN_MOVE : bool = true
var _velocity : Vector2 = Vector2(0.0, 0.0)
var _angularVelocity : float = 0.0
var _inputDir : Vector2

@onready var ShipVisuals = $ShipVisuals

func _ready():
	_velocity = Vector2(0.0, 0.0)
	_angularVelocity = 0.0
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
	position.x += _velocity.x * delta
	position.y += _velocity.y * delta
	rotation_degrees += _angularVelocity * delta

func _physics_process(delta):
	if IS_IN_GARAGE:
		return
	_inputDir = Vector2(0, 0)
	if CAN_MOVE:
		if Input.is_action_pressed("forward"):
			_inputDir.y+= -1
		if Input.is_action_pressed("backward"):
			_inputDir.y+=  1
		if Input.is_action_pressed("strafe right"):
			_inputDir.x+=  1
		if Input.is_action_pressed("strafe left"):
			_inputDir.x+= -1
	_inputDir = _inputDir.normalized().rotated(rotation)
	
	_velocity.x += _inputDir.x * ACCEL * delta
	_velocity.y += _inputDir.y * ACCEL * delta

	if CAN_MOVE:
		_velocity *= DRAG_COEFFICIENT * (1.0 - delta)
	
	if _velocity.length() > MAX_SPEED:
		_velocity = _velocity.normalized() * MAX_SPEED
	
	rotation_degrees -= 90
	if CAN_MOVE:
		var angleToCursor : float = rad_to_deg(get_angle_to(get_global_mouse_position()))
		_angularVelocity *= ANGULAR_DRAG * (1.0 - delta)
		# var willLand : float = (_angularVelocity / log(ANGULAR_DRAG)) * (ANGULAR_DRAG ** 20)
		if absf(angleToCursor) > absf(_angularVelocity):
			_angularVelocity += clampf(angleToCursor, -TURN_ACCEL, TURN_ACCEL)
			#willLand = (_angularVelocity / log(ANGULAR_DRAG)) * (ANGULAR_DRAG ** 20)
		else:
			_angularVelocity *= TURN_DAMPENING * (1.0 - delta)
	
	_angularVelocity = clampf(_angularVelocity, -absf(TURN_MAX_SPEED), absf(TURN_MAX_SPEED))
	rotation_degrees += 90
	
