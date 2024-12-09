extends Entity


func _on_damaged(damageTaken):
	for i in damageTaken * 5:
		$GPUParticles2D.emit_particle(self.transform, Vector2.ZERO, Color.WHITE, Color.WHITE, 0)
