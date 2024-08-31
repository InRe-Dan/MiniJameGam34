class_name Main
extends Node2D
## Main game handler

@export var passive_satisfaction_increase = 0.01
@onready var approval_rating : TextureProgressBar = %ApprovalRating

signal satisfaction_changed

var satisfaction : float = 1.0:
	set(x):
		satisfaction = clamp(x, 0, 1)
		if approval_rating:
			approval_rating.target = satisfaction
		satisfaction_changed.emit()

func _process(delta : float) -> void:
	satisfaction += delta * passive_satisfaction_increase

func _on_joke_system_joke_failed() -> void:
	satisfaction += 0.05
func _on_joke_system_joke_success() -> void:
	satisfaction -= 0.1
func _on_player_got_hit() -> void:
	satisfaction += 0.05
