extends Node


var allowed_to_press := false

onready var player := $Player


func _ready() -> void:
	player.stop(true)
	player.play("timeline")


func _unhandled_input(event: InputEvent) -> void:
	if allowed_to_press == true:
		if event.is_action_pressed("spacebar"):
			# print(player.current_animation_position)
			continue_timeline()


func stop_timeline() -> void:
	player.stop(false) # Pause at current seconds
	allowed_to_press = true


func continue_timeline() -> void:
	allowed_to_press = false
	player.play("timeline")
