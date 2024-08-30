class_name Main
extends Node2D
## Main game handler

@onready var hazard_container: Node2D = $Hazards


func spawn_hazard(hazard: Hazard, location: Vector2) -> void:
	hazard.position = location
	hazard_container.add_child(hazard)
