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
	instance.COLLECTION = Collectable.ResourcesEnum.Metal
	var dir : Vector2 = Vector2.RIGHT
	dir = dir.rotated(randf_range(0, deg_to_rad(360)))
	
	var type := randi_range(0, 3)
	if type == 0:
		instance.COLLECTION = Collectable.ResourcesEnum.Metal
	elif type == 1:
		instance.COLLECTION = Collectable.ResourcesEnum.Ceramic
	elif type == 2:
		instance.COLLECTION = Collectable.ResourcesEnum.Synthetic
	elif type == 3:
		instance.COLLECTION = Collectable.ResourcesEnum.Organic
	
	add_child(instance)
	var offset = CollectableRadius
	if canBeInside:
		offset = randf_range(256, CollectableRadius / 2.0)
	dir *= offset
	instance.global_position = Player.global_position + dir
	
