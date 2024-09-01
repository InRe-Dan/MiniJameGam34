class_name CustomCamera extends Camera2D
# Code adapted from https://www.reddit.com/r/godot/comments/eu5eyv/sprite_jittering/
# More potential solutions https://github.com/godotengine/godot/issues/35606
# r/godot, u/forbjok

@export var SMOOTHING_DURATION : float = 0.2
# https://gamedev.stackexchange.com/questions/1828/realistic-camera-screen-shake-from-explosion
@export var shake_radius : float = 2

var is_shaking : bool = false
var shake_duration  : float = 0.0
var shake_time_elapsed : float = 0.0

func _physics_process(delta: float) -> void:
	if is_shaking:
		position = ((shake_duration - shake_time_elapsed) / shake_duration) * shake_radius * Vector2.RIGHT.rotated(randf() * TAU) * Globals.screen_shake
		shake_time_elapsed += delta
		if shake_time_elapsed > shake_duration:
			is_shaking = false
	else:
		position = lerp(position, Vector2.ZERO, delta)

func shake(duration : float) -> void:
	is_shaking = true
	shake_duration = duration
	shake_time_elapsed = 0.0
