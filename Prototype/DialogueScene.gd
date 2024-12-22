extends CanvasLayer

onready var characters := $Characters
onready var margin := $Margin
onready var darkenbg := $DarkenBG
onready var mockup := $Mockup

onready var protagonist_sprite := $Characters/Protagonist
onready var boss_sprite := $Characters/Boss
onready var continue_indicator := $ContinueIndicator
onready var player := $Player

var allowed_to_press := false


func _init() -> void:
	Global.dialogue_scene = self


func _ready() -> void:
	player.clear_queue()
	player.clear_caches()

	dialogue_hide()

	# For testing this specific scene
	#yield(get_tree().create_timer(1.0), "timeout")
	#player.play("timeline")

	protagonist_sprite.animation = "normal"
	boss_sprite.animation = "right"


func dialogue_hide() -> void:
	characters.hide()
	margin.hide()
	darkenbg.hide()
	mockup.hide()

	player.stop(false)
	allowed_to_press = false
	show_continue_indicator(false)


func start() -> void:
	characters.show()
	margin.show()
	darkenbg.show()
	mockup.show()

	player.play("timeline")


func start_boss_attack() -> void:
	Global.start_boss_attack()


func _unhandled_input(event: InputEvent) -> void:
	if allowed_to_press == true and Global.boss_count == 0:
		if event.is_action_pressed("spacebar"):
			# print(player.current_animation_position)
			continue_timeline()

	# Change back to 9000 after tests
	# Including BossBarProgress.gd script
	if Global.boss_count == 1 and Global.boss_bar.value >= 500:
		if event.is_action_pressed("spacebar"):
			continue_timeline()


func stop_act() -> void:
	Global.boss_count = 1
	player.stop(false)
	allowed_to_press = true
	Global.end_dialogue()


func stop_timeline() -> void:
	player.stop(false) # Pause at current seconds
	allowed_to_press = true
	show_continue_indicator(true)


func show_continue_indicator(_visible: bool) -> void:
	continue_indicator.visible = _visible


func continue_timeline() -> void:
	allowed_to_press = false
	show_continue_indicator(false)
	player.play("timeline")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "timeline":
		Global.go_to_score_page()
