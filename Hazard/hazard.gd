class_name Hazard
extends Area2D
## Hazard class

@export var speed: float
## Minimum speed in relation to speed (ex. 0.5 means this hazard will not move slower than half its starting speed)
@export var minimum_speed_factor: float

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var minimum_velocity: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = position.direction_to(Globals.stage_center)
	minimum_velocity = direction * speed * minimum_speed_factor
	velocity = direction * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(minimum_velocity, delta)
	
	position += velocity * delta
