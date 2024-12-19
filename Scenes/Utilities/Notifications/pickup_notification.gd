extends Notification
class_name PickupNotification

@export var Result: Materials.Mats = Materials.Mats.Energy:
	get:
		return Result
	set(value):
		Result = value
		if is_node_ready():
			_reload()
@export var Source: Array[Sources] = []:
	get:
		return Source
	set(value):
		Source = value
		if is_node_ready():
			_reload()

@onready var ResultSprite := $Control/HBoxContainer/Icon
@onready var Clipper := $Control
@onready var SourcesNode := $Control/Sources

func _ready():
	_reload()

func _reload():
	size.x = 1
	_timeLeft = Duration
	ResultSprite.texture = TurnMatEnumToSprite(Result)
	for child in SourcesNode.get_children():
		child.queue_free()
	for source: Sources in Source:
		var tex = TextureRect.new()
		tex.texture = TurnSourceEnumToSprite(source)
		tex.size = Vector2(32, 32)
		SourcesNode.add_child(tex)
		SourcesNode.move_child(tex, 0)

func _physics_process(delta):
	if is_queued_for_deletion() || !is_node_ready():
		return
	
	#size.x = lerpf(1, 76, clampf(10.0 * (Duration - _timeLeft), 0, 1))
	custom_minimum_size.y = lerpf(0, 27, clampf(10.0 * _timeLeft, 0, 1))
	Clipper.size.y = lerpf(0, 32, clampf(10.0 * _timeLeft, 0, 1))
	
	if _timeLeft <= 0:
		#hide()
		queue_free()
	_timeLeft -= delta
