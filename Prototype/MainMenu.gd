extends CanvasLayer


onready var player := $Player
onready var tween := $Tween

onready var startgame := $Menu/StartGame
onready var help := $Menu/Help
onready var scores := $Menu/Scores
onready var credits := $Menu/Credits
onready var quit := $Menu/Quit

# 4 to jump to 0 (> START GAME) after timeout
var menu_item := 4


func _ready() -> void:
	Global.score = 0
	Global.combo = 0
	Global.boss_count = 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar"):
		match menu_item:
			0: Global.go_to_gameplay()
			1: Global.go_to_help_page()
			2: Global.go_to_score_page()
			3: Global.go_to_credits_page()
			4: Global.quit_game()


func _on_timeout() -> void:
	menu_item += 1

	if menu_item == 5:
		menu_item = 0

	match menu_item:
		0:
			quit.bbcode_text = "QUIT"
			tween.interpolate_property(quit, "rect_position:x", quit.rect_position.x, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()

			startgame.bbcode_text = "> START GAME"
			tween.interpolate_property(startgame, "rect_position:x", startgame.rect_position.x, 20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()


		1:
			startgame.bbcode_text = "START GAME"
			tween.interpolate_property(startgame, "rect_position:x", startgame.rect_position.x, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()

			help.bbcode_text = "> HELP"
			tween.interpolate_property(help, "rect_position:x", help.rect_position.x, 20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()

		2:
			help.bbcode_text = "HELP"
			tween.interpolate_property(help, "rect_position:x", help.rect_position.x, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()

			scores.bbcode_text = "> SCORES"
			tween.interpolate_property(scores, "rect_position:x", scores.rect_position.x, 20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()


		3:
			scores.bbcode_text = "SCORES"
			tween.interpolate_property(scores, "rect_position:x", scores.rect_position.x, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()


			credits.bbcode_text = "> CREDITS"
			tween.interpolate_property(credits, "rect_position:x", credits.rect_position.x, 20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()


		4:
			credits.bbcode_text = "CREDITS"
			tween.interpolate_property(credits, "rect_position:x", credits.rect_position.x, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()


			quit.bbcode_text = "> QUIT"
			tween.interpolate_property(quit, "rect_position:x", quit.rect_position.x, 20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
			tween.start()
		
