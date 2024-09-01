extends Node2D
## Responsible for spawning hazards

@export var base_spawn_frequency : float = 1.2
@export var hazards: Array[HazardSpawnData]

var hazardData: Array[HazardSpawnData] = []

@onready var hazard_container: Node2D = $Hazards
@onready var audience: Node2D = $Audience
@onready var effects_container: Node2D = $Effects
@onready var main : Main = get_tree().get_first_node_in_group("main")

var effects: Array[Status] = []

## Calculated based on base weight and satisfaction
## Hazard value points thrown per second
## (Later on we might have hazards with higher values to make them cost more)
var hazard_frequency : int = 1
## Scales hazard frequency after each throw to add some randomness
var frequency_modifier : float = 1.0

var time_since_last_hazard : float = 0

func recalculate_frequency() -> void:
	if main.satisfaction > 0.9:
		hazard_frequency = 0
	else:
		hazard_frequency = 10 * (1 - main.satisfaction) + 3

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for data: HazardSpawnData in hazards:
		hazardData.append(data)

	recalculate_frequency()


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_hazard += delta
	if hazard_frequency and time_since_last_hazard > 1 / (hazard_frequency * frequency_modifier):
		spawn_hazard(get_hazard())


## Spawns a hazard
func spawn_hazard(hazard: Hazard) -> void:
	var spectator: Spectator = audience.get_children().pick_random()
	hazard.spawn_lingering.connect(_on_hazard_deployed, ConnectFlags.CONNECT_DEFERRED)
	hazard.create_status.connect(_on_effect_created, ConnectFlags.CONNECT_DEFERRED)
	spectator.prepare_hazard(hazard)
	time_since_last_hazard = 0.
	# Between 0.6 and 1.4
	frequency_modifier = 0.6 + randf() * 0.8
	if Globals.time_slowed: frequency_modifier *= 0.25


## Returns a random hazard
func get_hazard() -> Hazard:
	return (hazardData.pick_random() as HazardSpawnData).hazard.instantiate()
	

## Hazard deployed by spectator
func _on_hazard_deployed(hazard: Hazard) -> void:
	hazard_container.add_child(hazard)


## Status effect create
func _on_effect_created(effect: Status) -> void:
	effects.append(effect)
	effects_container.add_child(effect)
	effect.ended.connect(_on_effect_deleted, ConnectFlags.CONNECT_DEFERRED)
	if effect is SlowTime:
		Globals.time_slowed = true


## Status effect delete
func _on_effect_deleted(effect: Status) -> void:
	var last_effect
	if effect is SlowTime:
		last_effect = true
		for e in effects:
			if e is SlowTime and not e == effect:
				last_effect = false
				break
		if last_effect: Globals.time_slowed = false
	
	effects.remove_at(effects.find(effect))
	effect.queue_free()


func _on_main_satisfaction_changed(new: float) -> void:
	recalculate_frequency()
