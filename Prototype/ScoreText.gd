extends RichTextLabel


func _init() -> void:
	Global.score_text = self


func _ready() -> void:
	bbcode_text = String(Global.score).pad_zeros(7)
