extends Entity
class_name Asteroid

@export_range(1, 5, 1) var SIZE: int = 5

@onready var res := preload("res://Scenes/World/Decoration/collectable.tscn")

func _on_damaged(damageTaken):
	for i in damageTaken * 5:
		$GPUParticles2D.emit_particle(self.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)

func _on_killed():
	if randf() > 0.1:
		return
	var p: Collectable = res.instantiate()
	p.COLLECTION = Collectable.ResourcesEnum.Core
	p.global_position = global_position
	get_tree().root.get_child(0).add_child(p)
