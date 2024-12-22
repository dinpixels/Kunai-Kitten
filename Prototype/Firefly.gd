extends CPUParticles2D


func _on_visibility_changed() -> void:
	emitting = visible
