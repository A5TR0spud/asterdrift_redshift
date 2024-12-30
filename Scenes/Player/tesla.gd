extends Area2D

@onready var Player := $".."

var Entities: Array[Entity] = []

func _ready():
	if UpgradesManager.Load("Tesla") < 1 || Player.IS_IN_GARAGE:
		hide()
		queue_free()
	else:
		show()
		Entities = []

func _physics_process(delta):
	if !Player.CAN_MOVE:
		hide()
		return
	
	hide()
	for ent: Entity in Entities:
		if !is_instance_valid(ent):
			Entities.erase(ent)
			continue
		ent.Damage(delta * 0.05 * ent.MaxHealth)
		show()

func _on_body_entered(body):
	if body is Entity:
		if body.hasHealth && (body.DangerousCollision || body.isAsteroid || body.isEnemy):
			Entities.append(body)

func _on_body_exited(body):
	if Entities.has(body):
		Entities.erase(body)
