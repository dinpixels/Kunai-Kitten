extends Node


var stage
var player
var enemy_layer
var boss_itself

var dialogue_scene

var hp_texture
var health_bar
var health_avatar_player

var combo_text
var combo_text_tween
var combo_text_base_color
var blitz_super_particles

var score_text

var margin
var margin2

var boss_texture
var boss_bar

var camera
var slash_animation

var health := 0.0
var max_health := 100.0

var blitz_charge := 0.0
var can_blitz := false
var hit_count := 0

var boss_fight := false

var score := 0
var combo := 0
var high_score : int = 0
var high_combo : int = 0

var boss_count := 0
var boss_life := 0.0


onready var menu_page := preload("res://Prototype/MainMenu.tscn")

onready var game_page := preload("res://Prototype/Prototype.tscn")

onready var help_page := preload("res://Prototype/Help.tscn")

onready var score_page := preload("res://Prototype/Stats.tscn")

onready var credits_page := preload("res://Prototype/Credits.tscn")

onready var gameover_page := preload("res://Prototype/GameOver.tscn")


func _ready() -> void:
	get_viewport().pause_mode = Node.PAUSE_MODE_PROCESS
	pause_mode = Node.PAUSE_MODE_PROCESS


func go_to_menu_page() -> void:
	get_tree().change_scene_to(menu_page)


func go_to_gameplay() -> void:
	get_tree().change_scene_to(game_page)


func go_to_help_page() -> void:
	get_tree().change_scene_to(help_page)


func go_to_score_page() -> void:
	get_tree().change_scene_to(score_page)


func go_to_credits_page() -> void:
	get_tree().change_scene_to(credits_page)


func go_to_gameover_page() -> void:
	get_tree().change_scene_to(gameover_page)


func quit_game() -> void:
	get_tree().quit()


func start_boss_fight() -> void:
	stage_hide()
	boss_bar.max_value = 500
	boss_bar.value = 0
	dialogue_scene.start()


func start_dialogue_again() -> void:
	stage_hide()
	dialogue_scene.start()


func end_dialogue() -> void:
	boss_life = boss_bar.value
	stage_show()


func stage_hide() -> void:
	player.hide()
	enemy_layer.hide()
	boss_itself.hide()

	hp_texture.hide()
	boss_bar.hide()
	boss_texture.hide()

	margin.hide()
	margin2.hide()

	slash_animation.hide()
	slash_animation.player.stop(true)

	get_tree().paused = true


func stage_show() -> void:
	get_tree().paused = false

	player.show()
	enemy_layer.show()

	hp_texture.show()
	boss_bar.show()
	boss_texture.show()

	margin.show()
	margin2.show()

	slash_animation.hide()
	slash_animation.player.stop(true)

	if boss_count == 1:
		boss_itself.show()


func start_boss_attack() -> void:
	boss_itself.allow_attack()


func show_player() -> void:
	player.appear()


func start_blitz() -> void:
	slash_animation.get_node("Player").play("slash")
	player.vanish()
	frame_freeze(0.2, 1.5)

	yield(get_tree().create_timer(1.5), "timeout")

	player.appear()

	# Remove all enemies
	for bug in enemy_layer.get_children():
		# Set the damage to 250 (or random)
		# to balance on the boss fight
		bug.damage_health(999)

	# Remove all projectiles
	for bullet in stage.get_children():           
		if bullet is Sprite and "Bullet" in bullet.name:
			bullet.delete()

	if boss_count == 1:
		boss_itself.damage_health(250)
		update_combo(1)


func health_bar_avatar_state(_animation: String) -> void:
	health_avatar_player.play(_animation)


func toggle_blitz_super(_switch: bool) -> void:
	blitz_super_particles.visible = _switch
	blitz_super_particles.emitting = _switch

	if _switch == true:
		combo_text.bbcode_text = "[right][rainbow freq=1.0 sat=0.8 val=0.8]{0}[/rainbow][/right]".format([String(combo)], "{_}")
	else:
		combo_text.bbcode_text = "[right][color={0}]{1}[/color][/right]".format([combo_text_base_color.to_html(false), String(combo)], "{_}")


func reset_combo() -> void:
	combo = 0
	hit_count = 0
	toggle_blitz_super(false)


func reset_blitz() -> void:
	can_blitz = false
	blitz_charge = 0
	toggle_blitz_super(false)


func update_health(_health: float) -> void:
	health = _health

	# Prevent from overlapping max health
	if health > max_health:
		health = max_health

	health_bar.animate_value(health)


func update_score(_points: int) -> void:
	score += _points

	if score > high_score:
		high_score = score

	if score >= 9999999:
		score = 9999999

	score_text.bbcode_text = String(score).pad_zeros(7)

	boss_bar.update_progress(score)

	# print("Score: " + str(score))


func update_boss_bar(_damage: float) -> void:
	boss_bar.value += _damage


func damage_boss_bar(_damage: float) -> void:
	boss_bar.value = _damage


func update_combo(_hit: int) -> void:
	combo += _hit

	if _hit > 0:
		hit_count += 1

	if hit_count > 10:
		hit_count = 0

	# Set it to 10
	if combo >= 1:
		if hit_count == 10:
			can_blitz = true

		# Show particles and rainbow effect on combo/hit counter
		# only when necessary, i.e. more than 10 combo and hit count
		if can_blitz == true:
			toggle_blitz_super(true)
		else:
			toggle_blitz_super(false)

		# Reset combo/hit counter vfx after Blitz super
		if _hit == 0:
			toggle_blitz_super(false)

	if combo > 0:
		combo_text_tween.interpolate_property(combo_text, "rect_scale", combo_text.rect_scale, Vector2(1.5, 1.5), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		combo_text_tween.start()

		combo_text_tween.interpolate_property(combo_text, "rect_position:x", combo_text.rect_position.x, -20, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		combo_text_tween.start()

		yield(get_tree().create_timer(0.5), "timeout")

		combo_text_tween.interpolate_property(combo_text, "rect_scale", combo_text.rect_scale, Vector2.ONE, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		combo_text_tween.start()

		combo_text_tween.interpolate_property(combo_text, "rect_position:x", combo_text.rect_position.x, 0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		combo_text_tween.start()

	if combo > high_combo:
		high_combo = combo

	if combo >= 999:
		combo = 999

	# combo_text.show_combo(combo)

	# print("Combo: " + str(combo))


func frame_freeze(timescale, duration) -> void:
	Engine.time_scale = timescale
	yield(get_tree().create_timer(duration * timescale), "timeout")
	Engine.time_scale = 1.0
