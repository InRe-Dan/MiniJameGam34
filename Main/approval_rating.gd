class_name ApprovalRating extends TextureProgressBar

@export var speed : float = 1.0

var target : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = move_toward(value, target, speed * delta)
