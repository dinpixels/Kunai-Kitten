extends TextureRect


onready var timer := $Timer
onready var countdown := $Countdown


func _ready() -> void:
	countdown.bbcode_text = "[center]" + String(int(timer.wait_time)) + "[/center]"


func _physics_process(_delta: float) -> void:
	countdown.bbcode_text = "[center]" + String(int(timer.time_left)) + "[/center]"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spacebar"):
		Global.go_to_gameplay()


func _on_timeout() -> void:
	Global.go_to_menu_page()
