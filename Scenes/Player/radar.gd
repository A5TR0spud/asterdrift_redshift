extends Area2D
class_name RadarClass

var TrackedBodies: Array[Entity] = []
static var RadarArrowPrefab := preload("res://Scenes/Player/radar_arrow.tscn")

@onready var List := $"../PlayerUI/Control/Radar/List"
@onready var Radar := $"../PlayerUI/Control/Radar"
@onready var RadarPlayer := $"../PlayerUI/Control/Radar/PlayerIndicator"
@onready var Player := $".."

func _ready():
	if UpgradesManager.Load("Dish") + UpgradesManager.Load("Radar") < 1 || !Player.CAN_MOVE || Player.IS_IN_GARAGE:
		queue_free()
		hide()
		Radar.hide()
		Radar.queue_free()
	else:
		show()
		TrackedBodies = []

func _physics_process(delta):
	if !Player.CAN_MOVE:
		hide()
		queue_free()
		Radar.hide()
		Radar.queue_free()
		return
	
	var i: int = 0
	if UpgradesManager.LoadIsEnabled("CameraMode"):
		RadarPlayer.rotation_degrees = Player.rotation_degrees + 90
	for arrow: RadarArrow in List.get_children():
		var tracked: Entity = TrackedBodies[i]
		var pos: Vector2 = (tracked.global_position - global_position) / 768.0 * 64.0
		if !UpgradesManager.LoadIsEnabled("CameraMode"):
			pos = pos.rotated(-Player.rotation - deg_to_rad(90))
		arrow.position = pos
		if tracked.isAsteroid:
			arrow.Type = Materials.Mats.Danger
			arrow.scale.x = tracked.Radius / 16.0 / 2.0
			arrow.scale.y = tracked.Radius / 16.0 / 2.0
			arrow.z_index = 4
		if tracked is Collectable:
			arrow.Type = tracked.COLLECTION
			arrow.scale.x = 1.0
			arrow.scale.y = 1.0
			arrow.z_index = 5
		i += 1

func _on_body_entered(body):
	if body is Entity:
		if UpgradesManager.Load("Dish") > 0 && body.isAsteroid:
			TrackedBodies.append(body)
		elif UpgradesManager.Load("Radar") > 0 && body is Collectable:
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
