class_name AudienceManager extends Node2D
## Handles instantiating audience members

@export var spawn_y_level : Marker2D
@export var audience_amount_tolerance : int = 4
@export var debug_label : Label

@onready var spectator_scene: PackedScene = preload("res://Hazard/spectators/spectator.tscn")
@onready var main : Main = get_tree().get_first_node_in_group("main")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(calculate_target_audience_members(1.0)):
		create_spectator()
	

func _process(delta : float) -> void:
	if not debug_label:
		return
	debug_label.text = ""
	debug_label.text += "Current children         : " + str(get_child_count())
	debug_label.text += "\nCurrent goal             : " + str(calculate_target_audience_members(main.satisfaction))
	debug_label.text += "\nCurrent uncalled children: " + str(count_valid_children())

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
		if spectator.objective_position.distance_squared_to(main.scene_center.global_position) > pow(main.scene_center.gizmo_extents + Globals.audience_padding, 2.0):
			break
	spectator.hazard_deployed.connect(get_parent()._on_hazard_deployed)
	add_child(spectator)

# Returns the number of audience members that should exist at this point
func calculate_target_audience_members(satisfaction : float) -> int:
	# Base of 5, scaling up to 50
	return 5 + (1 - satisfaction) * 45

# Count the number of children that aren't called back.
func count_valid_children() -> int:
	var counter : int = 0
	for child : Spectator in get_children():
		if !child.called_back:
			counter += 1
	return counter
	

## Change how many audience members there are by calling some back or spawning
func adjust_audience_members(goal : int) -> void:
	var real_child_count = count_valid_children()
	var decrease : bool = true if goal < real_child_count else false
	var difference : int = abs(goal - real_child_count)
	print("goal: ", goal)
	if decrease:
		var children : Array = get_children()
		children.shuffle()
		for i in range(difference):
			children[i].call_back(spawn_y_level.global_position.y)
	else:
		for i in range(difference):
			create_spectator()


func _on_main_satisfaction_changed(new : float) -> void:
	var goal : int = calculate_target_audience_members(new)
	if abs(goal - count_valid_children()) > audience_amount_tolerance:
		adjust_audience_members(goal)
	
