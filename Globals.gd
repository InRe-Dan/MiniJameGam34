extends Node
## Global fields and methods

const audience_padding: float = 16.0
const spectator_placement_max_attempts: int = 8

var time_slowed: bool = false
var level_reached = 3
var current_level
var screen_shake : float = 0

# Game difficulty parameters ====================================
## Number of QTE keypresses required per character in a joke
var joke_difficulty : float
## Chance of hazards being thrown directly at the player
var hazard_accuracy : float
## How big the spectators think the player is. The higher it is, the precise
## they are at aiming directly at the player
var player_radius : int

func setup_level_1() -> void:
	current_level = 1
	hazard_accuracy = 0.3
	player_radius = 150
	joke_difficulty = 0.1
func setup_level_2() -> void:
	current_level = 2
	hazard_accuracy = 0.5
	player_radius = 100
	joke_difficulty = 0.2
func setup_level_3() -> void:
	current_level = 3
	hazard_accuracy = 0.7
	player_radius = 50
	joke_difficulty = 0.3
