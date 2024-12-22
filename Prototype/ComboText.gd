extends RichTextLabel


export (Color) var base_color := Color("ea38a6")

onready var blitz := $Blitz
onready var tween := $Tween


func _init() -> void:
	Global.combo_text = self


func _ready() -> void:
	Global.combo_text_base_color = base_color

	blitz.visible = false
	blitz.emitting = false

	# Set value of text's custom color by base_color hint value
	set("custom_colors/default_color", base_color)

	bbcode_text = "[right][color={0}]{1}[/color][/right]".format([base_color.to_html(false), String(Global.combo)], "{_}")

	# print(bbcode_text)
