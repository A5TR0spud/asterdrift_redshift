extends Entity
class_name Asteroid

@export_range(1, 5, 1) var SIZE: int = 5

func _on_damaged(damageTaken):
	for i in damageTaken * 5:
		$GPUParticles2D.emit_particle(self.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
