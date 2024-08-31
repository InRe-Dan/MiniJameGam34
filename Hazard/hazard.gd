class_name Hazard
extends Area2D
## Hazard class

@export var speed: float
@export var force: float

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = position.direction_to(Globals.stage_center)
	velocity = direction * speed


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta


## Collided with player
func _on_body_entered(body: Node2D) -> void:
	if not body is Player: return
	
	(body as Player).hit(direction * speed * force * 5)
