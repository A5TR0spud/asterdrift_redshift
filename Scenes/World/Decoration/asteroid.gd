extends Entity
class_name Asteroid

@export_range(1, 5, 1) var SIZE: int = 5

@onready var res := preload("res://Scenes/World/Decoration/collectable.tscn")

func _on_damaged(damageTaken):
	for i in damageTaken * 5:
		$GPUParticles2D.emit_particle(self.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)

func _on_killed():
	if is_queued_for_deletion():
		return
	if randf() > 0.9:
		var p: Collectable = res.instantiate()
		p.COLLECTION = Collectable.ResourcesEnum.Core
		p.global_position = global_position
		get_parent().add_child(p)
	queue_free()
