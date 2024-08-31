class_name AudienceManager extends Node2D
## Handles instantiating audience members

@onready var spectator_scene: PackedScene = preload("res://Hazard/spectator.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(24):
		create_spectator()


## Creates a new audience member at a random position
func create_spectator() -> void:
	var spectator: Spectator = spectator_scene.instantiate() as Spectator
	var iteration: int = 0
	while true:
		# Failed to place
		if iteration > Globals.spectator_placement_max_attempts:
			spectator.position = Vector2(randf_range(0, 720), randf_range(0,480 - (Globals.stage_radius + Globals.audience_padding)))
			break
		iteration += 1
		spectator.position = Vector2(randf_range(0, 720), randf_range(0,480))
		if spectator.position.distance_squared_to(Globals.stage_center) > pow(Globals.stage_radius + Globals.audience_padding, 2.0):
			break
	add_child(spectator)
