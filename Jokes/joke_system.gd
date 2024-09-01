class_name JokeSystem extends Node

var jokes : Array[JokeResource]
var joke : JokeResource
@export var keypress_prompt_container : CenterContainer
@export var dialogue_container : DialogueContainer

signal joke_success
signal joke_failed

func _unhandled_input(event: InputEvent) -> void:
	if not joke or joke.terminated:
		return
	if event.is_action_pressed("qte_down"):
		joke.give_input(JokeResource.Direction.DOWN)
	elif event.is_action_pressed("qte_left"):
		joke.give_input(JokeResource.Direction.LEFT)
	elif event.is_action_pressed("qte_right"):
		joke.give_input(JokeResource.Direction.RIGHT)
	elif event.is_action_pressed("qte_up"):
		joke.give_input(JokeResource.Direction.UP)


func _ready() -> void:
	var dir : DirAccess = DirAccess.open("res://Jokes/JokeList/")
	for filename : String in dir.get_files():
		jokes.append(load("res://Jokes/JokeList/" + filename))
	new_joke()
	
	
func joke_finished() -> void:
	joke = null
	get_tree().create_timer(3).timeout.connect(new_joke)

func new_joke() -> void:
	if not joke:
		joke = jokes.pick_random().duplicate()
		for child in keypress_prompt_container.get_children():
			keypress_prompt_container.remove_child(child)
		keypress_prompt_container.add_child(joke.make_prompt())
		joke.success.connect(joke_finished)
		joke.success.connect(func (): joke_success.emit())
		joke.fail.connect(joke_finished)
		joke.fail.connect(func (): joke_failed.emit())
		dialogue_container.set_joke(joke)
