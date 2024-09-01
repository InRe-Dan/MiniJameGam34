class_name Player
extends CharacterBody2D
## Player character

@export var movement_speed: float
@export var acceleration: float

var speed_mod: float = 1.0

signal got_hit

@onready var stun_timer: Timer = $StunTimer
@onready var speech : Speech = $Speech
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _process(delta : float) -> void:
	$CanvasLayer/Key.global_position = global_position + Vector2(5, 40)
	$CanvasLayer/Key.texture = get_tree().get_first_node_in_group("joke_system").get_key_texture()

func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(get_input_vector() * movement_speed * speed_mod, delta * acceleration * pow(speed_mod, 2.0))
	if velocity.length() > 10:
		if velocity.x > 1.0:
			sprite.flip_h = false
			sprite.play("walk")
		elif velocity.x < -1.0:
			sprite.flip_h = true
			sprite.play("walk")
		elif velocity.y > 1.0:
			sprite.flip_h = false
			sprite.play("walk")
		elif velocity.y < 1.0:
			sprite.flip_h = true
			sprite.play("walk")
	else:
		sprite.play("idle")

	move_and_slide()

## Returns the player's input vector
func get_input_vector() -> Vector2:
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
func say(line : String, time : float):
	speech.say(line, time)

## Hits the player with the hazard
func hit(impulse: Vector2, satisfaction: float, hitstun: float) -> void:
	if hitstun > 0 and satisfaction > 0:
		speech.say("Ouch!")
		get_tree().get_first_node_in_group("camera").shake(hitstun)
		$HitSounds.play()
	velocity += impulse
	stun(hitstun)
	got_hit.emit(satisfaction)


## Applies stun
func stun(stun_duration: float) -> void:
	if stun_duration == 0: return
	if stun_timer.is_stopped() or stun_duration > stun_timer.wait_time:
		stun_timer.stop()
		stun_timer.wait_time = stun_duration
		stun_timer.start()
		_on_stun_start()


## Stun period began
func _on_stun_start() -> void:
	speed_mod = 0.4


## Stun period ended
func _on_stun_end() -> void:
	speed_mod = 1.0
