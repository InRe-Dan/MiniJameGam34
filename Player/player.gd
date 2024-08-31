class_name Player
extends CharacterBody2D
## Player character

@export var movement_speed: float
@export var acceleration: float

signal got_hit

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(get_input_vector() * movement_speed, delta * acceleration)
	
	move_and_slide()
	
	
## Returns the player's input vector
func get_input_vector() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	

## Hits the player with the hazard
func hit(impulse: Vector2, satisfaction: float) -> void:
	velocity += impulse
	got_hit.emit(satisfaction)
