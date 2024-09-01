extends Node
## Global fields and methods

const audience_padding: float = 16.0
const spectator_placement_max_attempts: int = 8

var time_slowed: bool = false
var ultra_instinct: bool = false
var level_reached = 3
var current_level
var screen_shake : float = 1.0
var spawn_data: LevelSpawnData

var time_played: float = 0.0
var jokes_told: int = 0
var laughs_got: int = 0
var tomatos_sold: int = 0
var near_misses: int = 0

# Game difficulty parameters ====================================
## Number of QTE keypresses required per character in a joke
var joke_difficulty : float
## Chance of hazards being thrown directly at the player
var hazard_accuracy : float
## Accuracy of hazard throws (measured in degrees)
var accuracy_cone_angle : int

func setup_level_1() -> void:
	current_level = 1
	hazard_accuracy = 0.3
	accuracy_cone_angle = 60
	joke_difficulty = 0.1
	spawn_data = load("res://Main/LevelSpawnSets/night1.tres")
func setup_level_2() -> void:
	current_level = 2
	hazard_accuracy = 0.5
	accuracy_cone_angle = 50
	joke_difficulty = 0.2
	spawn_data = load("res://Main/LevelSpawnSets/night2.tres")
func setup_level_3() -> void:
	current_level = 3
	hazard_accuracy = 0.7
	accuracy_cone_angle = 30
	joke_difficulty = 0.3
	spawn_data = load("res://Main/LevelSpawnSets/night3.tres")
