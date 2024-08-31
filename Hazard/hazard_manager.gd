extends Node2D
## Responsible for spawning hazards

@export var global_spawn_weight: float
@export var hazards: Array[HazardSpawnData]

var hazardData: Array[HazardSpawnData] = []

@onready var hazard_container: Node2D = $Hazards
@onready var audience: Node2D = $Audience


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for data: HazardSpawnData in hazards:
		hazardData.append(data)
	
	for spectator: Node in audience.get_children():
		spectator.hazard_deployed.connect(_on_hazard_deployed)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rand: float = randf()
	if rand < global_spawn_weight * delta:
		# Spawn hazard this frame
		spawn_hazard(get_hazard())


## Spawns a hazard
func spawn_hazard(hazard: Hazard) -> void:
	var spectator: Spectator = audience.get_children().pick_random()
	spectator.prepare_hazard(hazard)


## Returns a random hazard
func get_hazard() -> Hazard:
	return (hazardData.pick_random() as HazardSpawnData).hazard.instantiate()
	

## Hazard deployed by spectator
func _on_hazard_deployed(hazard: Hazard) -> void:
	hazard_container.add_child(hazard)
