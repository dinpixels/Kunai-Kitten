extends AnimatedSprite


export var hit_points := 50
export var attack_damage := 7.5

var life := 0.0
var direction = 0
var target = null

var allowed_attack := false

onready var bullet = preload("res://Prototype/PrototypeEnemyBullet.tscn")
onready var hp_up = preload("res://Prototype/HPUP.tscn")

onready var aimline := $AimLine
onready var pointer := $AimLine/Pointer
onready var attack_timer := $AtkTimer

onready var pattern := $Pattern
onready var shader := material


func _init() -> void:
	Global.boss_itself = self


func _ready() -> void:
	pointer.position.x = aimline.cast_to.x
	aimline.global_rotation = 0

	if get_node("/root/Prototype/TestPlayer") != null:
		target = get_node("/root/Prototype/TestPlayer")
		direction = (global_position - target.global_position).normalized()


func _on_visibility_changed() -> void:
	if Global.boss_count == 1:
		pattern.play("start")
		if visible == false:
			pattern.stop(true)


func allow_attack() -> void:
	allowed_attack = true
	attack_timer.start()


func _physics_process(_delta: float) -> void:
	if allowed_attack == true:
		aimline.look_at(target.global_position)


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "start":
		pattern.play("pseudobot")
		life = Global.boss_life
		# print("Boss life: " + String(life))


func _on_Hitbox_area_entered(area: Area2D) -> void:
	if Global.boss_count == 1:
		if area.get_collision_layer() == 4:
			damage_health(area.get_parent().damage)


func attack_player() -> void:
	var attack = bullet.instance()
	var attack_direction = (pointer.global_position - aimline.global_position).normalized()

	attack.global_position = pointer.global_position
	attack.global_rotation = aimline.global_rotation
	attack.direction = attack_direction
	attack.damage = attack_damage
	get_parent().add_child(attack)

	attack_timer.start(3.0)



func damage_health(damage: float) -> void:
	life += damage

	shader.set_shader_param("whiten", true)
	yield(get_tree().create_timer(0.5), "timeout")
	shader.set_shader_param("whiten", false)

	Global.update_combo(1)
	Global.update_score(hit_points)
	Global.damage_boss_bar(life)

	var rand_hp_drops := randi() % 4

	for x in rand_hp_drops:
		var hp_drop = hp_up.instance()
		hp_drop.global_position = global_position
		
		get_parent().call_deferred("add_child", hp_drop)

	if life >= 500:
		life = 500
		die()


func die() -> void:
	# Continue playing the dialogue where it left off
	Global.start_dialogue_again()


func _on_AtkTimer_timeout() -> void:
	attack_player()
