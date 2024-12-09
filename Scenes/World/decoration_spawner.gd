extends Node2D

var CollectableScene = preload("res://Scenes/World/Decoration/collectable.tscn")

var CollectableTimer : float = 0.0

@export var InitialCollectables : int = 15
@export var CollectableInterval : float = 1.0
@export var CollectableRadius : int = 1024
@onready var Player = $"../Player"

func _ready() -> void:
	CollectableTimer = 0
	for i in InitialCollectables:
		_createCollectable(true)

func _physics_process(delta) -> void:
	if !RunHandler.IsInRun():
		return
	CollectableTimer += delta
	if CollectableTimer > CollectableInterval:
		_createCollectable()
		CollectableTimer -= CollectableInterval

func _createCollectable(canBeInside : bool = false) -> void:
	var instance : Collectable = CollectableScene.instantiate()
	var dir : Vector2 = Vector2.RIGHT
	dir = dir.rotated(randf_range(0, deg_to_rad(360)))
	
	instance.COLLECTION = _rollCollectable()
	if instance.COLLECTION == Collectable.ResourcesEnum.Organic:
		instance.COLLECTION = _rollCollectable()
	
	add_child(instance)
	var offset = CollectableRadius
	if canBeInside:
		offset = randf_range(256, CollectableRadius / 2.0)
	dir *= offset
	instance.global_position = Player.global_position + dir
	

func _rollCollectable() -> Collectable.ResourcesEnum:
	var type := randi_range(0, 3)
	if type == 0:
		return Collectable.ResourcesEnum.Metal
	elif type == 1:
		return Collectable.ResourcesEnum.Ceramic
	elif type == 2:
		return Collectable.ResourcesEnum.Synthetic
	elif type == 3:
		return Collectable.ResourcesEnum.Organic
	
	#default
	return Collectable.ResourcesEnum.Metal
