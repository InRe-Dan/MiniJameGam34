class_name JokeSystem extends Node

var jokes : Array[JokeResource]
var joke : JokeResource
var prompt : KeypressPrompt
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

func get_key_texture() -> Texture2D:
	return prompt.get_key_texture()

func _ready() -> void:
	var dir : DirAccess = DirAccess.open("res://Jokes/JokeList/")
	for filename : String in dir.get_files():
		jokes.append(load("res://Jokes/JokeList/" + filename))
	new_joke()
	
func make_player_say_punchline(joke : JokeResource) -> void:
	get_tree().get_first_node_in_group("player").say("...", 2.)
	get_tree().create_timer(2.).timeout.connect(func (): get_tree().get_first_node_in_group("player").say(joke.punchline, 2.0))

	
func joke_finished(joke : JokeResource) -> void:
	self.joke = null
	get_tree().create_timer(3).timeout.connect(new_joke)

func new_joke() -> void:
	if not joke:
		joke = jokes.pick_random().duplicate()
		for child in keypress_prompt_container.get_children():
			keypress_prompt_container.remove_child(child)
		prompt = joke.make_prompt()
		keypress_prompt_container.add_child(prompt)
		joke.success.connect(make_player_say_punchline)
		joke.success.connect(func (x): joke_success.emit())
		joke.fail.connect(func (x): joke_failed.emit())
		dialogue_container.set_joke(joke)
		joke.success.connect(joke_finished)
		joke.fail.connect(joke_finished)
