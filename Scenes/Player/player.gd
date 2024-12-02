extends Node2D
class_name Player

@export var SPEED : float = 12.5
@export var TURN_ACCEL : float = 0.9
@export var TURN_MAX_SPEED : float = 8.0
@export var TURN_DAMPENING : float = 0.5
@export var DRAG_COEFFICIENT : float = 0.9
@export var ANGULAR_DRAG : float = 0.99
@export var IS_IN_GARAGE : bool = false
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
		

func _physics_process(delta):
	if IS_IN_GARAGE:
		return
	_inputDir = Vector2(0, 0)
	if Input.is_action_pressed("forward"):
		_inputDir.y+= -1
	if Input.is_action_pressed("backward"):
		_inputDir.y+=  1
	if Input.is_action_pressed("strafe right"):
		_inputDir.x+=  1
	if Input.is_action_pressed("strafe left"):
		_inputDir.x+= -1
	_inputDir = _inputDir.normalized().rotated(rotation)
	
	_velocity.x += _inputDir.x * SPEED * delta
	_velocity.y += _inputDir.y * SPEED * delta
	
	_velocity *= DRAG_COEFFICIENT
	
	rotation_degrees -= 90
	var angleToCursor : float = rad_to_deg(get_angle_to(get_global_mouse_position()))
	_angularVelocity *= ANGULAR_DRAG
	# var willLand : float = (_angularVelocity / log(ANGULAR_DRAG)) * (ANGULAR_DRAG ** 20)
	if absf(angleToCursor) > absf(_angularVelocity):
		_angularVelocity += clampf(angleToCursor, -TURN_ACCEL, TURN_ACCEL)
		#willLand = (_angularVelocity / log(ANGULAR_DRAG)) * (ANGULAR_DRAG ** 20)
	else:
		_angularVelocity *= TURN_DAMPENING
	
	_angularVelocity = clampf(_angularVelocity, -absf(TURN_MAX_SPEED), absf(TURN_MAX_SPEED))
	
	rotation_degrees += _angularVelocity
	rotation_degrees += 90
	position.x += _velocity.x
	position.y += _velocity.y
