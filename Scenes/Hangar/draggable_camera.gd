extends Camera2D

@export var speed: float = 128
@export var grace: int = 4
#var _zoom: float = 1.0
var _clickPos: Vector2 = Vector2(0, 0)
var _clicked: bool = false
var _isGraced: bool = false
var _fakePos: Vector2 = Vector2(0, 0)

func _process(delta):
	var dir: Vector2 = Vector2(0, 0)
	if Input.is_action_pressed("backward"):
		dir.y += 1
	if Input.is_action_pressed("forward"):
		dir.y -= 1
	if Input.is_action_pressed("turn left"):
		dir.x -= 1
	if Input.is_action_pressed("turn right"):
		dir.x += 1
	dir = dir.normalized()
	if Input.is_action_pressed("boost"):
		dir *= 2
	
	#if Input.is_action_just_pressed("zoom in"):
	#	zoomIn()
	#if Input.is_action_just_pressed("zoom out"):
	#	zoomOut()
	#if Input.is_action_just_pressed("reset zoom"):
	#	_zoom = 1.0
	#_zoom = clampf(_zoom, 0.188, 1)
	#zoom.x = _zoom
	#zoom.y = _zoom
	
	if Input.is_action_pressed("drag"):
		position_smoothing_enabled = false
		var _newClickPos: Vector2 = get_global_mouse_position()
		if !_clicked:
			_clickPos = _newClickPos
			_clicked = true
			_isGraced = false
		if _isGraced || _clickPos.distance_to(_newClickPos) > grace:
			var child := $TechTree
			child.position -= (_clickPos - _newClickPos)
			_fakePos += (_clickPos - _newClickPos)
			_clickPos = _newClickPos
			_isGraced = true
	else:
		position += dir * speed * delta
		position += _fakePos
		_fakePos = Vector2(0, 0)
		_clicked = false
		var child := $TechTree
		child.position = Vector2(0, 0)
	position = Vector2(roundi(position.x), roundi(position.y))
	
	$Background/TextureRect.position.x = -32 - int(position.x + _fakePos.x) % 32
	$Background/TextureRect.position.y = -32 - int(position.y + _fakePos.y) % 32

#func zoomIn():
	#_zoom += 0.1 * _zoom

#func zoomOut():
	#_zoom -= 0.1 * _zoom
