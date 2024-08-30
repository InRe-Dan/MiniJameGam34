extends Node
## Responsible for spawning hazards

const spawn_radius: float = 64.0 + sqrt(pow(360.0, 2.0) + pow(480.0, 2.0))

@export var global_spawn_weight: float
@export var hazards: Array[HazardSpawnData]

var main: Main

var hazardData: Array[HazardSpawnData] = []


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_tree().root.get_node("Main")
	
	for data: HazardSpawnData in hazards:
		hazardData.append(data)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rand: float = randf()
	if rand < global_spawn_weight * delta:
		# Spawn hazard this frame
		main.spawn_hazard(get_hazard(), get_position())


## Returns a random hazard
func get_hazard() -> Hazard:
	return (hazardData.pick_random() as HazardSpawnData).hazard.instantiate()
	

## Returns a random position outside the viewport
func get_position() -> Vector2:
	var angle: float = randf_range(0, PI)
	return Vector2(cos(angle), -sin(angle)) * spawn_radius + Globals.stage_center
