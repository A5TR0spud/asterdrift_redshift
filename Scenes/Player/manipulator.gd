@tool
extends Node2D

var Target: Collectable = null
var TargetQueue: Array[Collectable] = []
var GraspedCollectable: Collectable = null
var TargetPosition: Vector2 = Vector2(0, 0)
var RetractPosition: Vector2 = Vector2(0, 1)

@onready var GrabBox :Area2D= $GrabBox
@onready var ArmBase := $BaseSprite
@onready var ForeArm := $BaseSprite/ArmSprite
@onready var LHSGrab : Node2D= $BaseSprite/ArmSprite/LHSGrabber
@onready var RHSGrab :Node2D= $BaseSprite/ArmSprite/RHSGrabber
@onready var ManipCo := $ManipulatorArea/CollisionShape2D
@onready var Player := $".."
@onready var Extendo: Line2D = $BaseSprite/Extendo

@export var RANGE: int = 32:
	get:
		return RANGE
	set(value):
		RANGE = value
		if is_node_ready():
			ManipCo.shape.radius = RANGE
@export var EXTEND_SPEED: float = 32.0
@export var RETRACT_SPEED: float = 32.0

func _ready():
	if !Engine.is_editor_hint():
		GrabBox.position = Vector2(0, 0)
	Extendo.points[0] = Vector2(0, 0)
	ManipCo.shape.radius = RANGE
	Target = null
	GraspedCollectable = null
	TargetQueue = []
	TargetPosition = Vector2(0, 0)

func _physics_process(delta):
	if Player == null || !Player.CAN_MOVE:
		return
	#if no target, get new target
	if Target == null && TargetQueue.size() > 0:
		var x = TargetQueue.pop_front()
		if is_instance_valid(x):
			Target = x
	#if target is invalid, null target
	if Target != null:
		if !is_instance_valid(Target):
			Target = null
	#if grabbed is invalid, null grabbed
	if GraspedCollectable != null:
		if !is_instance_valid(GraspedCollectable):
			GraspedCollectable = null
	#if target is too far, null target
	if Target != null:
		#the collectable hitbox is 4px wide so we add 4px to the length check
		if Target.global_position.distance_to(global_position) > RANGE + 4:
			Target = null
	#set target position
	if Target != null:
		TargetPosition = Target.global_position - global_position
		RetractPosition = TargetPosition
	else:
		TargetPosition = Vector2(0, 0)
	
	#if grabbed exists, reset target position to 0, 0
	if GraspedCollectable != null:
		TargetPosition = Vector2(0, 0)
		GraspedCollectable.IgnoredByLaser = true
	
	#if target position is too far, move it back
	if TargetPosition.length() > RANGE:
		TargetPosition = TargetPosition.normalized() * RANGE
	var vel: float = TargetPosition.length() - GrabBox.position.length()
	#cap movement to SPEED
	vel = clampf(vel, -RETRACT_SPEED * delta, EXTEND_SPEED * delta)
	if !Engine.is_editor_hint():
		#properly apply rotations to target position (from player etc)
		if TargetPosition.distance_squared_to(Vector2.ZERO) < 1:
			GrabBox.position = Vector2(0, GrabBox.position.length() + vel).rotated(RetractPosition.angle() - deg_to_rad(90))
		else:
			GrabBox.position = Vector2(0, GrabBox.position.length() + vel).rotated(TargetPosition.angle() - deg_to_rad(90))
	#if grabbox is too far, yank it back
	if GrabBox.position.length() > RANGE:
		GrabBox.position = GrabBox.position.normalized() * RANGE
	#sync hooked material to hook
	if GraspedCollectable != null:
		GraspedCollectable.global_position = GrabBox.global_position
		#if it's at the bay, TAKE IT
		if GrabBox.position.length() < 5:
			_popGrasped()
	_applyArm()

func _applyArm():
	if !is_node_ready():
		return
	var extend: float = GrabBox.position.length()
	if extend < 9.22:
		ArmBase.hide()
	else:
		ArmBase.show()
	ArmBase.rotation = GrabBox.position.angle() - deg_to_rad(90)
	ForeArm.position = Vector2(0, extend - 13)
	Extendo.points[1] = Vector2(0, extend - 12)
	LHSGrab.rotation_degrees = -45 if GraspedCollectable == null else 0
	RHSGrab.rotation_degrees = 45 if GraspedCollectable == null else 0

func _on_manipulator_area_body_entered(body: Node2D) -> void:
	if body is Collectable:
		if Target == null:
			Target = body
		elif !TargetQueue.has(body):
			TargetQueue.append(body)

func _on_grab_box_body_entered(body):
	if body is Collectable:
		GraspedCollectable = body
		RetractPosition = body.global_position - global_position

func _popGrasped():
	if GraspedCollectable != null:
		GraspedCollectable.Collect()
		GraspedCollectable = null
