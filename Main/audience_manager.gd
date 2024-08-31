class_name AudienceManager extends Node2D
## Handles instantiating audience members

@export var spawn_y_level : Marker2D

@onready var spectator_scene: PackedScene = preload("res://Hazard/spectator.tscn")
@onready var main : Main = get_tree().get_first_node_in_group("main")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(5):
		create_spectator()

func generate_random_spawn_position() -> Vector2:
	var vec : Vector2
	vec.y = spawn_y_level.global_position.y + (randf() - 0.5) * 2 * 30
	vec.x = spawn_y_level.global_position.x + (randf() - 0.5) * 2 * spawn_y_level.gizmo_extents
	return vec

## Creates a new audience member at a random position
func create_spectator() -> void:
	var spectator: Spectator = spectator_scene.instantiate() as Spectator
	spectator.global_position = generate_random_spawn_position()
	
	# Telling the spectator where they should stay for a while
	var iteration: int = 0
	while true:
		# Failed to place
		if iteration > Globals.spectator_placement_max_attempts:
			spectator.objective_position = Vector2(randf_range(0, 720), randf_range(0,480 - (Globals.stage_radius + Globals.audience_padding)))
			break
		iteration += 1
		spectator.objective_position = Vector2(randf_range(0, 720), randf_range(0,480))
		if spectator.objective_position.distance_squared_to(Globals.stage_center) > pow(Globals.stage_radius + Globals.audience_padding, 2.0):
			break

	add_child(spectator)
