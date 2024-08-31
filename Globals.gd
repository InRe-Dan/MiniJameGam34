extends Node
## Global fields and methods

var joke_system : JokeSystem

const stage_radius: float = 240.0
const audience_padding: float = 16.0
const stage_center: Vector2 = Vector2(360, 480)
const spectator_placement_max_attempts: int = 8
## Number of QTE keypresses required per character in a joke
const joke_difficulty : float = 0.1

var time_slowed: bool = false
