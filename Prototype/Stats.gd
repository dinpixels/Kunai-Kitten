extends CanvasLayer


onready var score_text := $MenuPanel/Records/Session/Score
onready var hiscore_text := $MenuPanel/Records/Session/Hiscore
onready var combo_text := $MenuPanel/Records/Session/Combo
onready var hicombo_text := $MenuPanel/Records/Session/HighestCombo


func _ready() -> void:
	score_text.bbcode_text = score_text.bbcode_text % String(Global.score)

	hiscore_text.bbcode_text = hiscore_text.bbcode_text % String(Global.high_score)

	combo_text.bbcode_text = combo_text.bbcode_text % String(Global.combo)

	hicombo_text.bbcode_text = hicombo_text.bbcode_text % String(Global.high_combo)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar"):
		Global.go_to_menu_page()
