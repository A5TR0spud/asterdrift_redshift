extends Node2D

@export var TURN_SPEED_DEGREES: float = 180.0

@export_storage var inputDir: Vector2 = Vector2.ZERO

func _ready():
	inputDir = Vector2.ZERO
	if !$"..".CAN_MOVE:
		hide()
	if UpgradesManager.Load("RCSThrust") < 1 || $"..".IS_IN_GARAGE:
		queue_free()

func _process(delta):
	if !$"..".CAN_MOVE:
		hide()
		return
	else:
		show()
	
	if UpgradesManager.LoadIsEnabled("MovementMode"):
		var turn: int = 0
		if Input.is_action_pressed("turn left"):
			turn -= 1
		if Input.is_action_pressed("turn right"):
			turn += 1
		
		var deg: float = TURN_SPEED_DEGREES
		if UpgradesManager.Load("Booster") > 0 && Input.is_action_pressed("boost"):
			deg *= 0.5
		
		rotate(turn * deg_to_rad(deg) * delta)
	else:
		var tempDir: Vector2 = Vector2.ZERO
		if Input.is_action_pressed("forward"):
			tempDir.x += 1
		if Input.is_action_pressed("backward"):
			tempDir.x -= 1
		if Input.is_action_pressed("strafe left") || Input.is_action_pressed("turn left"):
			tempDir.y -= 1
		if Input.is_action_pressed("strafe right") || Input.is_action_pressed("turn right"):
			tempDir.y += 1
		if tempDir.length() > 0.5:
			inputDir = tempDir
		rotation = inputDir.angle()
