extends Area2D
class_name RadarClass

var TrackedBodies: Array[Entity] = []
static var RadarArrowPrefab := preload("res://Scenes/Player/radar_arrow.tscn")

@onready var List := $ArrowList
@onready var Player := $".."

func _ready():
	if UpgradesManager.Load("Dish") < 1 || !Player.CAN_MOVE || Player.IS_IN_GARAGE:
		queue_free()
		hide()
	else:
		show()
		TrackedBodies = []

func _physics_process(delta):
	if !Player.CAN_MOVE:
		hide()
		queue_free()
		return
	
	var i: int = 0
	for arrow: RadarArrow in List.get_children():
		var tracked: Entity = TrackedBodies[i]
		arrow.rotation = global_position.angle_to_point(tracked.global_position)
		arrow.Offset = global_position.distance_to(tracked.global_position) * 0.125
		if tracked.isAsteroid:
			arrow.Type = Materials.Mats.Danger
		if tracked is Collectable:
			arrow.Type = tracked.COLLECTION
		i += 1

func _on_body_entered(body):
	if body is Entity:
		TrackedBodies.append(body)
		_reload_child_count()

func _on_body_exited(body):
	if TrackedBodies.has(body):
		TrackedBodies.erase(body)
		_reload_child_count()

func _reload_child_count() -> void:
	var shouldBeChildren: int = 0
	
	for body: Entity in TrackedBodies:
		if !is_instance_valid(body):
			TrackedBodies.erase(body)
			continue
		if body.isAsteroid && UpgradesManager.Load("Dish"):
			shouldBeChildren += 1
		if body is Collectable && UpgradesManager.Load("Radar"):
			shouldBeChildren += 1
	var dif = shouldBeChildren - List.get_child_count()
	if dif > 0:
		for i in dif:
			var prefab := RadarArrowPrefab.instantiate()
			List.add_child(prefab)
	while dif < 0:
		List.remove_child(List.get_child(0))
		dif += 1
