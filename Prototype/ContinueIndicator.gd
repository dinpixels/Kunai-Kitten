extends Sprite


func _ready() -> void:
	$Player.clear_queue()
	$Player.clear_caches()


func _on_visibility_changed() -> void:
	if visible == true:
		$Player.play("hover")
	else:
		$Player.stop(true)
