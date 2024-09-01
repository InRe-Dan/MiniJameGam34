class_name Speech extends Node2D

@onready var template : Label = $Template

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remove_child(template)

func say(string : String, time : float = 0.5) -> void:
	var new : Label = template.duplicate()
	new.text = string
	get_tree().create_timer(time).timeout.connect(new.queue_free)
	new.global_position = global_position
	add_child(new)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child : Label in get_children():
		child.position.y -= 30 * delta
		
