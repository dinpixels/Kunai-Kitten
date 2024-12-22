extends AnimatedSprite

export var hp := 30.00
export var speed := 100.00
export var bodyDmg := 15.00
export var atkDmg := 5.00
export var hit_duration := 0.3
export var hit_points := 10
export var kill_points := 10

export (Vector2) var indicator_margin := Vector2(10, 10)

onready var protobull = preload("res://Prototype/PrototypeEnemyBullet.tscn")
onready var deathDust = preload("res://Prototype/Dust.tscn")
onready var hp_up = preload("res://Prototype/HPUP.tscn")

onready var aimline = $AimLine
onready var pointer = $AimLine/Pointer
onready var atkTimer = $AtkTimer
onready var playerDetector = $AimLine/Pointer/PlayerDetector
onready var playerDetectorCollision = $AimLine/Pointer/PlayerDetector/Collision
onready var indicator := $OffscreenIndicator
onready var tween = $Tween
onready var player = $Animation
onready var shader := material

var target = null
var direction = 0
var player_in_range := false
var offscreen := true


func _ready() -> void:
	randomize()

	pointer.position.x = aimline.cast_to.x
	aimline.global_rotation = 0

	if get_node("/root/Prototype/TestPlayer") != null:
		target = get_node("/root/Prototype/TestPlayer")
		direction = (global_position - target.global_position).normalized()

	if global_position.x >= target.global_position.x:
		flip_h = false
	else:
		flip_h = true

	play("idle")
	indicator.play("idle")


func _physics_process(delta: float) -> void:
	aimline.look_at(target.global_position)

	if not player_in_range:
		global_position -= speed * direction * delta

	update_indicator()


func update_indicator() -> void:
	if offscreen == true:
		indicator.global_position.x = clamp(position.x, indicator_margin.x, 720 - indicator_margin.x)

		indicator.global_position.y = clamp(position.y, indicator_margin.y, 480 - indicator_margin.y)

		# Check if in left or right offscreen
		if global_position.x <= 0:
			indicator.rotation_degrees = -90
		elif global_position.x >= 720:
			indicator.rotation_degrees = 90

		# Check if in up or down offscreen
		if global_position.y <= 0:
			# indicator.rotation_degrees = 0
			pass
		elif global_position.y >= 480:
			indicator.rotation_degrees = 180

		indicator.show()

	else:
		indicator.hide()
		indicator.stop()


func shoot_vomit() -> void:
	var bullet = protobull.instance()
	var bulletDirection = (pointer.global_position - aimline.global_position).normalized()

	bullet.global_position = pointer.global_position
	bullet.global_rotation = aimline.global_rotation
	bullet.direction = bulletDirection
	bullet.damage = atkDmg
	get_parent().get_parent().add_child(bullet)

	speed_scale = 10
	play("attack")
	tween.interpolate_property(self, "offset:y", offset.y, -48, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

	atkTimer.start(3.0)


func _on_animation_finished() -> void:
	if animation == "attack":
		speed_scale = 1
		play("idle")
		tween.interpolate_property(self, "offset:y", offset.y, 0, 0.2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_PlayerDetector_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "TestPlayer":
		player_in_range = true
		atkTimer.start(1.0)
		# print(player_in_range)
		# print(area.get_parent().name)

		# Stop detecting player, remove signal, and disable collision shape as it is no longer needed
		playerDetector.disconnect("area_entered", self, "_on_PlayerDetector_area_entered")
		set_deferred("monitoring", false)
		playerDetectorCollision.set_deferred("disabled", true)


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == 4:
		damage_health(area.get_parent().damage)


func damage_health(damage: float) -> void:
	hp -= damage

	player.play("hit_flash")
	#shader.set_shader_param("whiten", true)
	#yield(get_tree().create_timer(hit_duration), "timeout")
	#shader.set_shader_param("whiten", false)

	Global.update_combo(1)
	Global.update_score(hit_points)

	if hp <= 0:
		die()


func die() -> void:
	var dust = deathDust.instance()
	dust.global_position = global_position
	dust.resize(2.5)
	get_parent().get_parent().call_deferred("add_child", dust)

	var rand_hp_drops := randi() % 7

	for x in rand_hp_drops:
		var hp_drop = hp_up.instance()
		hp_drop.global_position = global_position
		
		get_parent().get_parent().call_deferred("add_child", hp_drop)

	Global.update_score(kill_points)

	queue_free()


func _on_AtkTimer_timeout() -> void:
	shoot_vomit()


func _on_screen_entered() -> void:
	offscreen = false


func _on_screen_exited() -> void:
	#print("Freeing enemy...")
	queue_free()


func _on_tree_exited() -> void:
	#print("Freed enemy from tree!")
	pass
