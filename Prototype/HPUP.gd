extends AnimatedSprite


export var points := 10
export var heal_points := 10.0
export var duration := 0.5

var spawn_direction := 1
var target_position := Vector2.ZERO
var target = null

var positionA := Vector2.ZERO
var positionB := Vector2.ZERO
var positionC := Vector2.ZERO

var time = 0.0

onready var detector := $Detector
onready var tween := $Tween
onready var timer := $Timer


func _ready() -> void:
	randomize()

	playing = true
	timer.wait_time = duration

	if get_node("/root/Prototype/TestPlayer") != null:
		target = get_node("/root/Prototype/TestPlayer")
		target_position = target.global_position

	var old_x := global_position.x
	var old_y := global_position.y

	var randx = randi() % 2
	var rand_offset = rand_range(1.0, 30.0)

	if randx == 0:
		spawn_direction = 1
	else:
		spawn_direction = -1

	positionA = global_position

	positionB = Vector2(
	global_position.x + (old_x / 2) + rand_offset * spawn_direction,
	global_position.y - (old_y / 2))

	positionC = Vector2(
	global_position.x + (old_x / 2) + rand_offset * spawn_direction, old_y)

	scale.x *= spawn_direction


func _physics_process(delta: float) -> void:
	if not timer.time_left <= 0:
		spawn_arc(delta)


func spawn_arc(delta: float) -> void:
	time += delta / duration
	var q0 = positionA.linear_interpolate(positionB, min(time, 1.0))
	var q1 = positionB.linear_interpolate(positionC, min(time, 1.0))
	position = q0.linear_interpolate(q1, min(time, 1.0))


func _on_timeout() -> void:
	tween.interpolate_property(self, "position", global_position, target_position,
	1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()


func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_layer() == 1:
		area.get_parent().heal(heal_points)
		#Global.update_health(Global.health + heal_points)
		Global.update_score(points)
		queue_free()
