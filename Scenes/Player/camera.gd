extends Camera2D

@export var Player : PlayerClass

var _zoom : float = 2.0
var _last_pos : Vector2

func _ready():
	_last_pos = Player.global_position

func _process(delta):
	if !UpgradesManager.LoadIsEnabled("CameraMode"):
		if UpgradesManager.Load("RCSThrust") < 1:
			rotation = Player.rotation + deg_to_rad(90)
		else:
			rotation = Player.RCS.rotation
	
	if Input.is_action_just_pressed("zoom in"):
		zoomIn()
	if Input.is_action_just_pressed("zoom out"):
		zoomOut()
	if Input.is_action_just_pressed("reset zoom"):
		_zoom = 2
	_zoom = clampf(_zoom, maxZoomOut(), 5)
	zoom.x = _zoom
	zoom.y = _zoom
	
	global_position = Player.global_position

func zoomIn():
	_zoom += 0.1 * _zoom

func zoomOut():
	_zoom -= 0.1 * _zoom

func maxZoomOut() -> float:
	var zoomOut: float = 1
	var radarDish: int = UpgradesManager.Load("Dish")
	zoomOut += 0.5 * radarDish
	return 2 / zoomOut
