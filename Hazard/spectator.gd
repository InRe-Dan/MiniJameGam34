class_name Spectator extends Node2D
## Represents a single audience member who is able to create hazards

signal hazard_deployed(hazard)

var queue: Array[Hazard]


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
	
