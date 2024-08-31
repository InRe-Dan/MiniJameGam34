class_name Spectator extends CharacterBody2D
## Represents a single audience member who is able to create hazards

@onready var eyesight : ShapeCast2D = $Shapecast

signal hazard_deployed(hazard)

var queue: Array[Hazard]
var objective_position : Vector2
var called_back : bool = false
var reached_target : bool = false

signal ready_to_despawn

func set_new_objective() -> void:
	# Reattempt a few times
	for i in range(5):
		eyesight.target_position = Vector2.from_angle(randf() * TAU) * 100
		if eyesight.is_colliding():
			continue;
		else:
			objective_position = global_position + eyesight.target_position
			reached_target = false
			return
	# If we failed entirely, try again later
	get_tree().create_timer(randf() * 0.5).timeout.connect(set_new_objective)


func check_position() -> void:
	if reached_target:
		return
	if global_position.distance_squared_to(objective_position) < 100:
		reached_target = true
		if called_back:
			ready_to_despawn.emit()
		get_tree().create_timer(0.5 + randf() * 0.7).timeout.connect(set_new_objective)
		

func _process(delta : float) -> void:
	velocity = global_position.direction_to(objective_position) * 50
	check_position()
	move_and_slide()

## Create a hazard
func prepare_hazard(hazard: Hazard) -> void:
	queue.append(hazard)
	
	# Start animation if not already playing
	# TODO: REPLACE
	release()

## Animation finished
func release() -> void:
	if queue.size() == 0: return
	
	# Dequeue hazard
	var hazard: Hazard = queue[0]
	queue.remove_at(0)
	
	hazard.position = position
	hazard_deployed.emit(hazard)
	
## Tells the spectator to go back to the spawn zone so that he can be despawned
## When the spectator reaches the position, ready_to_despawn is emitted
func call_back(target : Vector2i) -> void:
	objective_position = target
	called_back = true
