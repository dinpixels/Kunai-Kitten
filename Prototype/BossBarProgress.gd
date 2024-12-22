extends TextureProgress

# Change back to 4000 all of this stat
export (float, 0.0, 4000.0, 0.05) var starting_value := 4000.0


func _init() -> void:
	Global.boss_bar = self


func _ready() -> void:
	value = starting_value
	max_value = starting_value
	update_progress(Global.score)


func update_progress(_score: float) -> void:
	# If progress is complete (inversely)
	# Reset to '<= 0' after testing (while 8900 during test)
	if Global.boss_count == 0:
		value = starting_value - _score
		if value <= 0:
			Global.start_boss_fight()
