extends Node2D



@onready var Player = $"../Player"

@export var InitialCollectables : int = 15
@export var CollectableInterval : float = 1.0
@export var CollectableRadius : int = 1024
var CollectableScene = preload("res://Scenes/World/Decoration/collectable.tscn")
var CollectableTimer : float = 0.0

@export var InitialAsteroids : int = 15
@export var AsteroidInterval : float = 2.0
@export var AsteroidRadius : int = 1024
var AsteroidScene = preload("res://Scenes/World/Decoration/asteroid.tscn")
var AsteroidTimer : float = 0.0


func _ready() -> void:
	CollectableTimer = 0
	for i in InitialCollectables:
		_createCollectable(true)
	AsteroidTimer = 0
	for i in InitialAsteroids:
		_createAsteroid(true)

func _physics_process(delta) -> void:
	if !RunHandler.IsInRun():
		return
	CollectableTimer += delta
	if CollectableTimer > CollectableInterval:
		_createCollectable()
		CollectableTimer -= CollectableInterval
	AsteroidTimer += delta
	if AsteroidTimer > AsteroidInterval:
		_createAsteroid()
		AsteroidTimer -= AsteroidInterval

func _createCollectable(canBeInside : bool = false) -> void:
	var instance : Collectable = CollectableScene.instantiate()
	var dir : Vector2 = Vector2.RIGHT
	dir = dir.rotated(randf_range(0, deg_to_rad(360)))
	
	instance.COLLECTION = _rollCollectable()
	var offset = CollectableRadius
	if canBeInside:
		offset = randf_range(256, CollectableRadius / 2.0)
	dir *= offset
	instance.global_position = Player.global_position + dir
	add_child(instance)
	
	

func _rollCollectable() -> Collectable.ResourcesEnum:
	var metalWeight = 100
	var ceramicWeight = 100
	var syntheticWeight = 100
	var OrganicWeight = 50
	var CoreWeight = 1
	
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

func _createAsteroid(canBeInside : bool = false) -> void:
	var instance: Entity = AsteroidScene.instantiate()
	var dir : Vector2 = Vector2.RIGHT
	dir = dir.rotated(randf_range(0, deg_to_rad(360)))

	var offset = AsteroidRadius
	if canBeInside:
		offset = randf_range(10 + Player.Radius + instance.Radius, AsteroidRadius / 2.0)
	else:
		offset = randf_range(1024, AsteroidRadius)
	dir *= offset
	instance.global_position = Player.global_position + dir
	
	var x = randf() * randf() * randf_range(-64, 64)
	var y = randf() * randf() * randf_range(-64, 64)
	var r = randf() * randf_range(-30, 30)
	instance.linear_velocity = Vector2(x, y).normalized()
	instance.angular_velocity = deg_to_rad(r)
	instance.rotation_degrees = randf_range(0, 359.9999999)
	
	add_child(instance)
	
