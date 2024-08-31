class_name Status extends Node2D

signal ended(status)

@export var duration: float


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if duration > 0.0:
		var duration_timer = Timer.new()
		duration_timer.wait_time = duration
		duration_timer.timeout.connect(_on_duration_ended)
		add_child(duration_timer)
		duration_timer.start()


## Status ended
func _on_duration_ended() -> void:
	ended.emit(self)
