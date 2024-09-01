class_name Main
extends Node2D
## Main game handler

@export var scene_center : Marker2D
@export var passive_satisfaction_increase = 0.005

@onready var approval_rating: HBoxContainer = %ApprovalRating
@onready var success_player: AudioStreamPlayer = $Audio/SuccessSound
@onready var hazard_manager

var game_over_scene : PackedScene = preload("res://menus/game_over.tscn")

signal satisfaction_changed(new : float)

var satisfaction : float = 1.0:
	set(x):
		if x < 0:
			game_over()
		satisfaction = clamp(x, 0, 1)
		if approval_rating:
			approval_rating.target = satisfaction
		satisfaction_changed.emit(satisfaction)


func _ready() -> void:
	Globals.time_played = 0.0
	Globals.jokes_told = 0
	Globals.laughs_got = 0
	Globals.tomatos_sold = 0
	Globals.near_misses = 0


func game_over() -> void:
	$UI.add_child(game_over_scene.instantiate())
	process_mode = PROCESS_MODE_DISABLED

func _process(delta : float) -> void:
	Globals.time_played += delta
	satisfaction += delta * passive_satisfaction_increase

func _on_joke_system_joke_failed() -> void:
	satisfaction += 0.05
func _on_joke_system_joke_success() -> void:
	satisfaction -= 0.1
	#success_player.stream = success_audio.pick_random()
	#success_player.play()
func _on_player_got_hit(satisfaction_change: float) -> void:
	satisfaction += satisfaction_change
func _on_v_slider_value_changed(value: float) -> void:
	satisfaction = value
