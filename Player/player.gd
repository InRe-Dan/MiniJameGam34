class_name Player
extends CharacterBody2D
## Player character

@export var movement_speed: float
@export var acceleration: float

var speed_mod: float = 1.0

signal got_hit

@onready var stun_timer: Timer = $StunTimer

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(get_input_vector() * movement_speed * speed_mod, delta * acceleration)
	
	move_and_slide()
	
	
## Returns the player's input vector
func get_input_vector() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	

## Hits the player with the hazard
func hit(impulse: Vector2, satisfaction: float, hitstun: float) -> void:
	velocity += impulse
	stun(hitstun)
	got_hit.emit(satisfaction)


## Applies stun
func stun(stun_duration: float) -> void:
	if stun_timer.is_stopped() or stun_duration > stun_timer.wait_time:
		stun_timer.stop()
		stun_timer.wait_time = stun_duration
		stun_timer.start()
		_on_stun_start()
	

## Stun period began
func _on_stun_start() -> void:
	speed_mod = 0.5


## Stun period ended
func _on_stun_end() -> void:
	speed_mod = 1.0
