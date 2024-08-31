class_name Hazard
extends Area2D
## Hazard class

signal spawn_lingering(hazard)

@export var speed: float
@export var force: float
@export var satisfaction: float
@export var hitstun: float
@export var lingering_spawn: PackedScene
@export var lingering: bool

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
	
	if lingering: direction = body.position.direction_to(position)
	(body as Player).hit(direction * force * 1000, satisfaction, hitstun)
	if lingering_spawn:
		var hazard: Hazard = lingering_spawn.instantiate()
		hazard.position = position
		spawn_lingering.emit(hazard)
	if not lingering: queue_free()


## Lifetime ended (bruh)
func _on_lifetime_timeout() -> void:
	queue_free()
