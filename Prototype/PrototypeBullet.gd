extends Sprite


export var points := 10.0
export var delete_points := 1

var bulletSpeed
var direction
var damage


func _physics_process(delta: float) -> void:
	global_position += bulletSpeed * direction * delta


func delete() -> void:
	Global.update_score(delete_points)
	queue_free()


func _on_screen_exited() -> void:
	# print("Freeing bullet...")
	queue_free()
