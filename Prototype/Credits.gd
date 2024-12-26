extends CanvasLayer

onready var player := $Player
onready var scroll := $MenuPanel/Scroll
onready var item := $MenuPanel/Scroll/Items/Graphics/Works
onready var backinfo := $MenuPanel/BackInfo

var last_item : bool


func _ready() -> void:
	last_item = false
	item.grab_focus()


func show_back_info() -> void:
	backinfo.visible = true
	player.play("idle")


func _input(event: InputEvent) -> void:
	if last_item == true:
		if event.is_action_pressed("spacebar"):
			Global.go_to_menu_page()


func _on_last_item_focus_entered() -> void:
	last_item = true
	item.release_focus()
	show_back_info()
