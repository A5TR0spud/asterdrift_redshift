extends Node2D



@onready var Player = $"../Player"

@export var InitialCollectables : int = 380
var CollectableScene = preload("res://Scenes/World/Decoration/collectable.tscn")

@export var InitialAsteroids : int = 180
var AsteroidScene = preload("res://Scenes/World/Decoration/asteroid.tscn")


func _ready() -> void:
	for i in InitialCollectables:
		_createCollectable()
	for i in InitialAsteroids:
		_createAsteroid()

func _createCollectable() -> void:
	var instance : Collectable = CollectableScene.instantiate()
	var pos : Vector2 = Vector2.ZERO
	
	instance.COLLECTION = _rollCollectable()
	pos.x = randf_range(-2500, 2500)
	pos.y = randf_range(-2500, 2500)
	if pos.length() < 256:
		pos = pos.normalized() * 256
	instance.global_position = pos
	add_child(instance)
	
	

func _rollCollectable() -> Collectable.ResourcesEnum:
	var metalWeight = 100
	var ceramicWeight = 100
	var syntheticWeight = 100
	var OrganicWeight = 75
	var CoreWeight = 2
	
	var totalWeight = metalWeight + ceramicWeight + syntheticWeight + OrganicWeight + CoreWeight
	var type := randi_range(0, totalWeight)
	
	type -= metalWeight
	if type <= 0:
		return Collectable.ResourcesEnum.Metal
	type -= ceramicWeight
	if type <= 0:
		return Collectable.ResourcesEnum.Ceramic
	type -= syntheticWeight
	if type <= 0:
		return Collectable.ResourcesEnum.Synthetic
	type -= OrganicWeight
	if type <= 0:
		return Collectable.ResourcesEnum.Organic
	type -= CoreWeight
	if type <= 0:
		return Collectable.ResourcesEnum.Core
	
	#default, something borked
	return Collectable.ResourcesEnum.Metal

func _createAsteroid() -> void:
	var instance: Entity = AsteroidScene.instantiate()
	var pos : Vector2 = Vector2.ZERO
	pos.x = randf_range(-2500, 2500)
	pos.y = randf_range(-2500, 2500)
	if pos.length() < 256:
		pos = pos.normalized() * 256
	instance.global_position = pos
	
	var x = randf() * randf() * randf_range(-64, 64)
	var y = randf() * randf() * randf_range(-64, 64)
	var r = randf() * randf_range(-30, 30)
	instance.linear_velocity = Vector2(x, y).normalized()
	instance.angular_velocity = deg_to_rad(r)
	instance.rotation_degrees = randf_range(0, 359.9999999)
	
	add_child(instance)
	
