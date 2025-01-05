extends Node2D



@onready var Player = $"../Player"

var CollectableScene = preload("res://Scenes/World/Decoration/collectable.tscn")

@export var Metals: int = 101
@export var Ceramics: int = 101
@export var Synthetics: int = 101
@export var Organics: int = 75
@export var Cores: int = 2

@export var InitialAsteroids : int = 180
var AsteroidScene = preload("res://Scenes/World/Decoration/asteroid.tscn")

var collectCounter: int = 0

var CometScene = preload("res://Scenes/World/Decoration/comet.tscn")

@export var InitialComets: int = 90

var CometDir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	collectCounter = 0
	CometDir = Vector2.RIGHT.rotated(randf() * deg_to_rad(359.99999))
	for i in Metals + Ceramics + Synthetics + Organics + Cores:
		_createCollectable()
	for i in InitialAsteroids:
		_createAsteroid()
	for i in InitialComets:
		_createComet()

func _createCollectable() -> void:
	var instance : Collectable = CollectableScene.instantiate()
	var pos : Vector2 = Vector2.ZERO
	
	instance.COLLECTION = _rollCollectable()
	pos.x = randf_range(-5000, 5000)
	pos.y = randf_range(-5000, 5000)
	if pos.length() < 256:
		pos = pos.normalized() * 256
	instance.global_position = pos
	add_child(instance)
	
	collectCounter += 1

func _rollCollectable() -> Materials.Mats:
	var type := collectCounter
	
	type -= Metals
	if type <= 0:
		return Materials.Mats.Metals
	type -= Ceramics
	if type <= 0:
		return Materials.Mats.Ceramics
	type -= Synthetics
	if type <= 0:
		return Materials.Mats.Synthetics
	type -= Organics
	if type <= 0:
		return Materials.Mats.Organics
	type -= Cores
	if type <= 0:
		return Materials.Mats.Components
	
	#default, something borked
	return Materials.Mats.Metals

func _createAsteroid() -> void:
	var instance: Asteroid = AsteroidScene.instantiate()
	var pos : Vector2 = Vector2.ZERO
	pos.x = randf_range(-5000, 5000)
	pos.y = randf_range(-5000, 5000)
	var size = min(randi_range(1, 12), randi_range(1, 12))
	instance.SIZE = size
	
	if pos.length() < 256 + instance.Radius:
		pos = pos.normalized() * (256 + instance.Radius)
	instance.global_position = pos
	
	var x = randf() * randf() * randf_range(-64, 64)
	var y = randf() * randf() * randf_range(-64, 64)
	var r = randf() * randf_range(-30, 30)
	instance.linear_velocity = Vector2(x, y).normalized()
	instance.angular_velocity = deg_to_rad(r)
	instance.rotation_degrees = randf_range(0, 359.9999999)
	
	add_child(instance)
	
func _createComet() -> void:
	var instance: Comet = CometScene.instantiate()
	var pos : Vector2 = Vector2.ZERO
	pos.x = randf_range(-5000, 5000)
	pos.y = randf_range(-5000, 5000)
	if pos.length() < 256:
		pos = pos.normalized() * 256
	instance.global_position = pos
	
	var motionDir = CometDir * 10.0 + Vector2.RIGHT.rotated(deg_to_rad(359.999) * randf())
	motionDir = motionDir.normalized()
	var speed = randfn(518+256, 518)
	
	instance.linear_velocity = motionDir * speed
	instance.angular_velocity = randfn(0, deg_to_rad(180))
	instance.rotation_degrees = randf_range(0, 359.9999999)
	
	add_child(instance)
