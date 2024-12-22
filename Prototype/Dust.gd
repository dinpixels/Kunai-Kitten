extends CPUParticles2D


func _ready() -> void:
	emitting = true
	yield(get_tree().create_timer(1.25), "timeout")
	queue_free()


func resize(_scale: float) -> void:
	scale.x = _scale
	scale.y = _scale
