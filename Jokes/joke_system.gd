class_name JokeSystem extends Node

var jokes : Array[JokeResource]
var joke : JokeResource
var prompt : KeypressPrompt
@export var keypress_prompt_container : CenterContainer
@export var dialogue_container : DialogueContainer

signal joke_success
signal joke_failed

@onready var panel: Panel = $MarginContainer/Panel


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
	Globals.jokes_told += 1
	
	get_tree().get_first_node_in_group("player").say("...", 2.)
	get_tree().create_timer(2.).timeout.connect(
		func (): 
		get_tree().get_first_node_in_group("player").say(joke.punchline, 2.0)
		$Success.play()
		$"../../HazardManager/Boo".play()
		)
	$Punchline.play()

func joke_finished(joke : JokeResource) -> void:
	self.joke = null
	var t = create_tween()
	t.tween_interval(0.2)
	t.tween_property(prompt, "position:y", prompt.position.y + 50, 0.2)
	get_tree().create_timer(3.5).timeout.connect(new_joke)

func new_joke() -> void:
	if not joke:
		joke = jokes.pick_random().duplicate()
		for child in keypress_prompt_container.get_children():
			keypress_prompt_container.remove_child(child)
		prompt = joke.make_prompt()
		keypress_prompt_container.add_child(prompt)
		panel.self_modulate = Color.WHITE
		joke.success.connect(make_player_say_punchline)
		joke.success.connect(func (x): joke_success.emit())
		joke.fail.connect(_on_joke_failed)
		dialogue_container.set_joke(joke)
		joke.success.connect(joke_finished)
		joke.fail.connect(joke_finished)
		joke.progress.connect(play_progress_audio)
		create_tween().tween_property(prompt, "position:y", prompt.position.y - 50, 0.3)

## Joke failed
func _on_joke_failed(throwout) -> void:
	Globals.laughs_got += 1
	joke_failed.emit()
	panel.self_modulate = Color.RED
	$"../../HazardManager/Laugh".play()

func play_progress_audio(throwout) -> void:
	$Progress.play()
