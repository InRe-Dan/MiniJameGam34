class_name Hazard
extends Area2D
## Hazard class

signal spawn_lingering(hazard)
signal create_status(status)
signal hit_player(hazard : Hazard)

@export var speed: float
@export var force: float
@export var satisfaction: float
@export var hitstun: float
@export var lingering_spawn: PackedScene
@export var lingering: bool
@export var status_effect: PackedScene

var collided: bool = false
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var target : Vector2


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene_center : Marker2D = get_tree().get_first_node_in_group("main").scene_center
	if randf() < Globals.hazard_accuracy:
		target = get_tree().get_first_node_in_group("player").global_position
	else:
		target.y = scene_center.global_position.y
		target.x = scene_center.global_position.x + randf_range(-1, 1) * scene_center.gizmo_extents
	direction = position.direction_to(target).rotated(randf_range(-0.5, 0.5) * deg_to_rad(Globals.accuracy_cone_angle))
	velocity = direction * speed
	rotation = randf() * 2 * PI


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mod: float = 1.0
	var ultra_mod: float = 1.0
	if Globals.time_slowed: mod = 0.25
	if Globals.ultra_instinct: ultra_mod = 0.6
	position += velocity * delta * mod * ultra_mod
	rotation += (speed * mod) / 4000


## Collided with player
func _on_body_entered(body: Node2D) -> void:
	if not body is Player or collided: return
	
	collided = true
	
	if lingering: direction = body.position.direction_to(position)
	(body as Player).hit(direction * force * 200, satisfaction, hitstun)
	hit_player.emit(self)
	if lingering_spawn:
		var hazard: Hazard = lingering_spawn.instantiate()
		hazard.position = position
		spawn_lingering.emit(hazard)
	if status_effect:
		var effect: Status = status_effect.instantiate()
		create_status.emit(effect)
	if not lingering: queue_free()


## Nearly missed player
func _on_near_miss(body: Node2D) -> void:
	if not body is Player or collided: return
	
	Globals.near_misses += 1
	#(body as Player).say("Close one!", 1.0)
	(body as Player).activate_ultra_instinct()


## Lifetime ended (bruh)
func _on_lifetime_timeout() -> void:
	queue_free()
