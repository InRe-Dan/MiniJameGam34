extends Control

@onready var one : Label = $Thing1
@onready var two : Label = $Thing2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.current_level != 1: return
	var t1 : Tween = get_tree().create_tween()
	var t2 : Tween = get_tree().create_tween()
	t1.tween_interval(2)
	t1.tween_property(one, "global_position:y", 80, 0.4)
	t1.tween_interval(7.6)
	t1.tween_property(one, "modulate:a", 0, 0.4)
	t2.tween_interval(5)
	t2.tween_property(two, "global_position:y", 110, 0.4)
	t2.tween_interval(4.6)
	t2.tween_property(two, "modulate:a", 0, 0.4)
