extends TextureProgress


onready var tween := $Tween

var head_animate
var tween_ready := false


func _init() -> void:
	Global.health_bar = self


func animate_value(new_hp: float) -> void:
	if tween_ready == true:
		tween.interpolate_property(self, "value", value, new_hp, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		tween.start()

		if new_hp < value:
			Global.health_bar_avatar_state("shake")
		elif new_hp > value:
			Global.health_bar_avatar_state("heal")


func _on_Tween_ready() -> void:
	tween_ready = true


func _on_Player_animation_finished(anim_name: String) -> void:
	if anim_name == "shake" or anim_name == "heal":
		Global.health_bar_avatar_state("normal")
