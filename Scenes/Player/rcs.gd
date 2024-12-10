extends Node2D

@export var TURN_SPEED_DEGREES: float = 180.0

func _ready():
	if !$"..".CAN_MOVE:
		hide()
	if UpgradesManager.Load("RCSThrust") < 1:
		queue_free()

func _physics_process(delta):
	if !$"..".CAN_MOVE:
		hide()
		return
	else:
		show()
	
	var turn: int = 0
	if Input.is_action_pressed("turn left"):
		turn -= 1
	if Input.is_action_pressed("turn right"):
		turn += 1
	
	var deg: float = TURN_SPEED_DEGREES
	if UpgradesManager.Load("Booster") > 0 && Input.is_action_pressed("boost"):
		deg *= 0.5
	
	rotate(turn * deg_to_rad(deg) * delta)
