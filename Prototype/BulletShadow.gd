extends Sprite

var direction
var speed

func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta
