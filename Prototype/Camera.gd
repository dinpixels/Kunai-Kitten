extends Camera2D

# How quickly the shaking stops [0, 1].
export (float, 0.0, 1.0) var decay := 0.5

# Maximum hor/ver shake in pixels.
export var max_offset = Vector2(2, 2)

# Maximum rotation in radians (use sparingly).
export var max_roll = 0.1


var trauma = 0.0 # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


func _init() -> void:
	Global.camera = self


func _ready() -> void:
	randomize()


func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)


func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	offset.x = max_offset.x * amount * rand_range(-1, 1)
	offset.y = max_offset.y * amount * rand_range(-1, 1)
