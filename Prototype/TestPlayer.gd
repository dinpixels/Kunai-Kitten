extends AnimatedSprite

export var hp := 100.00
export var atkDmg := 10.00
export var bulletSpeed := 900.00
export var rotation_speed := 5.0
export var hit_duration := 0.3

onready var protobull = preload("res://Prototype/PrototypeBullet.tscn")

onready var aimline := $AimLine
onready var pointer := $AimLine/Pointer
onready var guideline := $AimLine/GuideLine
onready var guidelineEnd := $AimLine/Pointer/GuideLineEnd
onready var hitbox := $Hitbox
onready var shadow := $Hitbox/Shadow
onready var charge := $Hitbox/Charge
onready var tween := $Tween
onready var player := $Animation
onready var shader := material


func _init() -> void:
	Global.player = self


func _ready() -> void:
	randomize()

	# Set global values
	Global.update_health(hp)
	material.set_shader_param("whiten", false)

	pointer.position.x = aimline.cast_to.x
	guideline.points[0] = to_local(pointer.global_position)
	guideline.points[1] = to_local(guidelineEnd.global_position)
	aimline.global_rotation = 0

	charge.visible = false
	charge.emitting = false
	play("idle")


func _physics_process(delta: float) -> void:
	# DON'T REMOVE! FOR DEBUG/TESTS
	# aimline.look_at(get_global_mouse_position())
	aimline.rotation += rotation_speed * delta

	if aimline.rotation_degrees >= 360 or aimline.rotation_degrees <= -360:
		aimline.rotation_degrees = 0

	if guidelineEnd.global_position.x >= 360:
		flip_h = false
		hitbox.position.x = offset.x + 8 
	else:
		flip_h = true
		hitbox.position.x = offset.x - 8

	# print("AimLine Rotation Degrees: " + String(aimline.rotation_degrees))


# Drawn nodes like Line2D will update per frame cycle to match
# physics_process' cycle
func _update() -> void:
	guideline.points[0] = to_local(pointer.global_position)
	guideline.points[1] = to_local(guidelineEnd.global_position)


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("spacebar"):

		var bullet = protobull.instance()
		var direction = (pointer.global_position - aimline.global_position).normalized()

		bullet.global_position = pointer.global_position
		bullet.global_rotation = aimline.global_rotation
		bullet.direction = direction
		bullet.damage = atkDmg
		bullet.bulletSpeed = bulletSpeed

		get_parent().add_child(bullet)


		play("shoot" + String(randi() % 3))
		match animation:
			"shoot0":
				tween.interpolate_property(self, "offset", offset, Vector2.ZERO, 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
				tween.start()

			"shoot1":
				tween.interpolate_property(self, "offset:y", offset.y, -12, 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
				tween.start()


			"shoot2":
				if guidelineEnd.global_position.x >= 360:
					tween.interpolate_property(self, "offset:x", offset.x, -22, 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
					tween.start()
				else:
					tween.interpolate_property(self, "offset:x", offset.x, 22, 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
					tween.start()

		yield(get_tree().create_timer(0.1), "timeout")
		play("idle")

		if guidelineEnd.global_position.x >= 360:
			tween.interpolate_property(self, "offset", offset, Vector2(-11, 0), 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			tween.start()
		else:
			tween.interpolate_property(self, "offset", offset, Vector2(11, 0), 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			tween.start()

		rotation_speed *= -0.5
		yield(get_tree().create_timer(0.5), "timeout")
		rotation_speed *= 2

		# print(rotation_speed)

func _process(delta: float) -> void:
	if Input.is_action_pressed("spacebar"):
		if Global.can_blitz == true:
			Global.blitz_charge += delta

			if Global.blitz_charge > 1:
				Global.camera.zoom = lerp(Global.camera.zoom, Vector2(0.9, 0.9), 0.5)
				Global.camera.add_trauma(1.0)
				play("charge")
				charge.visible = true
				charge.emitting = true

			if Global.blitz_charge > 2:
				Global.camera.zoom = lerp(Global.camera.zoom, Vector2(0.85, 0.85), 0.5)

			if Global.blitz_charge > 2.5:
				Global.camera.zoom = lerp(Global.camera.zoom, Vector2.ONE, 0.5)
				Global.start_blitz()
				# print("Blitz ready!")

	if Input.is_action_just_released("spacebar"):
		charge.visible = false
		charge.emitting = false

		play("idle")

	# print(Global.can_blitz)


func vanish() -> void:
	visible = false
	hitbox.monitorable = false
	hitbox.monitoring = false
	stop()


func appear() -> void:
	visible = true
	hitbox.monitorable = true
	hitbox.monitoring = true


func heal(heal_points: float) -> void:
	hp += heal_points
	if hp >= 100.0:
		hp = 100.0
	Global.update_health(hp)


func damage_health(damage: float) -> void:
	hp -= damage
	Global.update_health(hp)
	Global.reset_combo()
	Global.reset_blitz()

	player.play("hit_flash")
	#shader.set_shader_param("whiten", true)
	#yield(get_tree().create_timer(hit_duration), "timeout")
	#shader.set_shader_param("whiten", false)

	if not Global.camera.zoom == Vector2.ONE:
		Global.camera.zoom = lerp(Global.camera.zoom, Vector2.ONE, 0.5)
		play("idle")
		charge.visible = false
		charge.emitting = false

	if hp <= 0:
		game_over()


func game_over() -> void:
	# print("GAME OVER! No more health left!")
	Global.go_to_gameover_page()


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == 8:
		#frame_freeze(0.25, hit_duration)
		damage_health(area.get_parent().damage)
