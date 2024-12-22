extends Node2D

onready var player := $Player


func _init() -> void:
	Global.slash_animation = self


func _ready() -> void:
	visible = false


func _on_animation_started(anim_name: String) -> void:
	if anim_name == "slash":
		visible = true


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "slash":
		visible = false
		player.clear_caches()
		Global.reset_blitz()
