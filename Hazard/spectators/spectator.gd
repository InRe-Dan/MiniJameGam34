class_name Spectator extends CharacterBody2D
## Represents a single audience member who is able to create hazards

@onready var eyesight : ShapeCast2D = $Shapecast

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
var colours : ColorPalette = preload("res://Hazard/spectators/palette.tres")

signal hazard_deployed(hazard)

var queue: Array[Hazard]
var objective_position : Vector2
var called_back : bool = false
var reached_target : bool = false
var time_spent_walking : float = 0
var max_walk_time : float = 8.0

func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	var scheme : ColorScheme = colours.palette.pick_random()
	(sprite.material as ShaderMaterial).set_shader_parameter("main", scheme.main)
	(sprite.material as ShaderMaterial).set_shader_parameter("accent", scheme.accent)

func set_new_objective() -> void:
	if called_back: return
	time_spent_walking = 0
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
	if global_position.distance_squared_to(objective_position) < 100 or time_spent_walking > max_walk_time:
		reached_target = true
		time_spent_walking = 0
		if called_back:
			queue_free()
		get_tree().create_timer(0.5 + randf() * 0.7).timeout.connect(set_new_objective)
		

func _process(delta : float) -> void:
	$Debug.text = ""
	if called_back:
		$Debug.text += "C"
	if reached_target:
		$Debug.text += " R"
	$Debug.text += "\n" + str(time_spent_walking)

	if not reached_target:
		time_spent_walking += delta
		velocity = global_position.direction_to(objective_position) * 50
		if velocity.x > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		var player : Node2D = get_tree().get_first_node_in_group("player")
		sprite.flip_h = true if global_position.direction_to(player.global_position).x < 0 else false
		velocity = Vector2.ZERO
	check_position()
	move_and_slide()

## Create a hazard
func prepare_hazard(hazard: Hazard) -> void:
	queue.append(hazard)
	#print("preparing ", hazard)
	# Start animation if not already playing
	# TODO: REPLACE
	release()

## Animation finished
func release() -> void:
	#print("ready to release")
	if queue.size() == 0: 
		return
	
	# Dequeue hazard
	var hazard: Hazard = queue.pop_front()
	
	hazard.position = position
	hazard_deployed.emit(hazard)
	
## Tells the spectator to go back to the spawn zone so that he can be despawned
## When the spectator reaches the position, ready_to_despawn is emitted
func call_back(target_y : float) -> void:
	objective_position.y = target_y
	called_back = true
	reached_target = false
	time_spent_walking = 0
