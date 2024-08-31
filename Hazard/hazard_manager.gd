extends Node2D
## Responsible for spawning hazards

@export var base_spawn_frequency : float = 1.2
@export var hazards: Array[HazardSpawnData]

var hazardData: Array[HazardSpawnData] = []

@onready var hazard_container: Node2D = $Hazards
@onready var audience: Node2D = $Audience
@onready var main : Main = get_tree().get_first_node_in_group("main")

## Calculated based on base weight and satisfaction
## Hazard value points thrown per second
## (Later on we might have hazards with higher values to make them cost more)
var hazard_frequency : int = 1
## Scales hazard frequency after each throw to add some randomness
var frequency_modifier : float = 1.0

var time_since_last_hazard : float = 0

func recalculate_frequency() -> void:
	hazard_frequency = 10 * (1 - main.satisfaction) + 3

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for data: HazardSpawnData in hazards:
		hazardData.append(data)

	recalculate_frequency()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_hazard += delta
	if time_since_last_hazard > 1 / (hazard_frequency * frequency_modifier):
		spawn_hazard(get_hazard())


## Spawns a hazard
func spawn_hazard(hazard: Hazard) -> void:
	var spectator: Spectator = audience.get_children().pick_random()
	spectator.prepare_hazard(hazard)
	time_since_last_hazard = 0.
	# Between 0.6 and 1.4
	frequency_modifier = 0.6 + randf() * 0.8


## Returns a random hazard
func get_hazard() -> Hazard:
	return (hazardData.pick_random() as HazardSpawnData).hazard.instantiate()
	

## Hazard deployed by spectator
func _on_hazard_deployed(hazard: Hazard) -> void:
	hazard_container.add_child(hazard)


func _on_main_satisfaction_changed(new: float) -> void:
	recalculate_frequency()
