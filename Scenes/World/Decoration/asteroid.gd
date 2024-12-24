@tool
extends Mineable
class_name Asteroid

@export_range(1, 12, 1) var SIZE: int = 5:
	get:
		return SIZE
	set(value):
		SIZE = clampi(value, 1, 12)
		if is_node_ready():
			_reload()

static var AsteroidScene := preload("res://Scenes/World/Decoration/asteroid.tscn")
static var CollectableScene := preload("res://Scenes/World/Decoration/collectable.tscn")

static var Asteroid1 := preload("res://Assets/Asteroids/Asteroid1.png")
static var Asteroid2 := preload("res://Assets/Asteroids/Asteroid2.png")
static var Asteroid3 := preload("res://Assets/Asteroids/Asteroid3.png")
static var Asteroid4 := preload("res://Assets/Asteroids/Asteroid4.png")
static var Asteroid5 := preload("res://Assets/Asteroids/Asteroid5.png")
static var Asteroid6 := preload("res://Assets/Asteroids/Asteroid6.png")
static var Asteroid7 := preload("res://Assets/Asteroids/Asteroid7.png")
static var Asteroid8 := preload("res://Assets/Asteroids/Asteroid8.png")
static var Asteroid9 := preload("res://Assets/Asteroids/Asteroid9.png")
static var Asteroid10 := preload("res://Assets/Asteroids/Asteroid10.png")
static var Asteroid11 := preload("res://Assets/Asteroids/Asteroid11.png")
static var Asteroid12 := preload("res://Assets/Asteroids/Asteroid12.png")

@onready var Sprite := $Icon
@onready var Collider := $CollisionShape2D

func _ready():
	_reload()

func _reload():
	MaxHealth = SIZE * 30 - 10
	Health = SIZE * 30 - 10
	MaxMiningHealth = SIZE * 20
	MiningHealth = SIZE * 20
	MaxResources = SIZE * 4 - 1
	ResourcesLeft = SIZE * 4 - 1
	mass = minf(SIZE * 30 - 10, 3**SIZE)
	Radius = 8 + SIZE * 7
	var Shape: CircleShape2D = CircleShape2D.new()
	Shape.radius = 8 + SIZE * 7
	Collider.shape = Shape
	
	if SIZE == 1:
		Sprite.texture = Asteroid1
	elif SIZE == 2:
		Sprite.texture = Asteroid2
	elif SIZE == 3:
		Sprite.texture = Asteroid3
	elif SIZE == 4:
		Sprite.texture = Asteroid4
	elif SIZE == 5:
		Sprite.texture = Asteroid5
	elif SIZE == 6:
		Sprite.texture = Asteroid6
	elif SIZE == 7:
		Sprite.texture = Asteroid7
	elif SIZE == 8:
		Sprite.texture = Asteroid8
	elif SIZE == 9:
		Sprite.texture = Asteroid9
	elif SIZE == 10:
		Sprite.texture = Asteroid10
	elif SIZE == 11:
		Sprite.texture = Asteroid11
	elif SIZE == 12:
		Sprite.texture = Asteroid12

func _on_damaged(damageTaken):
	for i in damageTaken:
		$GPUParticles2D.emit_particle(self.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)

var deaded: bool = false

func _on_killed():
	if !is_node_ready():
		Health = MaxHealth
		return
	
	if deaded && !is_queued_for_deletion():
		queue_free()
		return
	
	if is_queued_for_deletion() || deaded || !is_instance_valid(self) || self == null:
		return
	
	if SIZE > 1:
		var splitDir: Vector2 = Vector2.RIGHT.rotated(randf_range(0, deg_to_rad(359.99999)))
		
		var p1: Asteroid = AsteroidScene.instantiate()
		p1.SIZE = floori(SIZE * 0.5)
		p1.global_position = global_position + splitDir * Radius * 0.5
		p1.linear_velocity = linear_velocity + splitDir
		p1.rotation = -rotation
		p1.angular_velocity = angular_velocity
		call_deferred("_spawn", p1)#.call_deferred("add_child", p1)
		#get_parent().add_child(p1)
		
		var p2: Asteroid = AsteroidScene.instantiate()
		p2.SIZE = ceili(SIZE * 0.5)
		p2.global_position = global_position - splitDir * Radius * 0.5
		p2.linear_velocity = linear_velocity - splitDir
		p2.rotation = rotation
		p2.angular_velocity = -angular_velocity
		call_deferred("_spawn", p2)#.call_deferred("add_child", p2)
		#get_parent().add_child(p2)
	else:
		var col: Collectable = CollectableScene.instantiate()
		col.COLLECTION = RollMineable()
		col.global_position = global_position
		col.linear_velocity = linear_velocity
		col.angular_velocity = angular_velocity
		col.rotation = rotation
		call_deferred("_spawn", col)#.call_deferred("add_child", col)
		#get_parent().add_child(col)

	deaded = true
	queue_free()

func _spawn(p: Node2D):
	get_parent().add_child(p)

func _on_resource_mined(global_pos):
	if ResourcesLeft < 1:
		if SIZE > 1:
			SIZE -= 1
			_reload()


func _on_body_entered(body):
	if body is not Entity:
		return
	var other: Entity = body
	var blunt: float = 0.05 * maxf(other.mass - self.mass, other.mass) * (self.linear_velocity - other.linear_velocity).length()
	var abrasion: float = 0.4 * absf(self.mass * self.angular_velocity + other.mass * other.angular_velocity)
	
	var abrasionResistance = 1
	var bluntResistance = 3
	var grace = 2
	
	var ddd = (blunt / bluntResistance) + (abrasion / abrasionResistance) - grace
	if ddd > 0:
		Damage(ddd)
