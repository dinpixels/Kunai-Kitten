extends Node

onready var bug0 := preload("res://Prototype/Bug0.tscn")
onready var bug1 := preload("res://Prototype/Bug1.tscn")

onready var spawnTimer := $SpawnTimer
onready var enemyLayer := $YSort


# Set Global.stage as reference to self
func _init() -> void:
	Global.stage = self


# Then, it's safe to set other references when this parent is ready
func _ready() -> void:
	randomize()

	# DON'T REMOVE THIS
	# IT MAKES REPLAY WORK
	get_tree().paused = false

	Global.score = 0
	Global.combo = 0
	Global.boss_count = 0

	Global.enemy_layer = $YSort
	Global.hp_texture = $HUD/HPTexture
	Global.boss_texture = $HUD/BossTexture
	Global.margin = $HUD/Margin
	Global.margin2 = $HUD/Margin2


func spawn_enemy() -> void:
	# Randomize enemy if there are other enemies to choose from
	var enemy
	var pick := randi() % 2

	match pick:
		0: enemy = bug0.instance()
		1: enemy = bug1.instance()

	enemy.global_position = get_random_position_offscreen()
	enemyLayer.add_child(enemy)


func get_random_position_offscreen() -> Vector2:
	var randx
	var randy
	var distance_offscreen := 100

	var screensize
	screensize = get_tree().get_root().size

	var rng := RandomNumberGenerator.new()
	rng.randomize()


	if rng.randi() % 2 == 0: # Top or Bottom
		randx = int(rng.randi_range(0, screensize.x))
		randy = -distance_offscreen if rng.randi() % 2 == 0 else screensize.y + distance_offscreen

	else: # Left or Right
		randy = int(rng.randi_range(0, screensize.y))
		randx = -distance_offscreen if rng.randi() % 2 == 0 else screensize.x + distance_offscreen

	return Vector2(randx, randy)


func _on_timeout() -> void:
	# Spawn only when boss haven't encountered yet
	if Global.boss_count == 0:
		spawn_enemy()
		spawnTimer.start(randi() % 6)
