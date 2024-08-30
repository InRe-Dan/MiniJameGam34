class_name KeypressPrompt extends MarginContainer

@export var template : TextureRect

@export var down : Texture2D
@export var down_pressed : Texture2D
@export var right : Texture2D
@export var right_pressed : Texture2D
@export var up : Texture2D
@export var up_pressed : Texture2D
@export var left : Texture2D
@export var left_pressed : Texture2D

var joke_container : Container

var joke : JokeResource
var current_index = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("qte_down"):
		joke.give_input(JokeResource.Direction.DOWN)
	elif event.is_action_pressed("qte_left"):
		joke.give_input(JokeResource.Direction.LEFT)
	elif event.is_action_pressed("qte_right"):
		joke.give_input(JokeResource.Direction.RIGHT)
	elif event.is_action_pressed("qte_up"):
		joke.give_input(JokeResource.Direction.UP)

func initialize(joke : JokeResource) -> void:
	self.joke = joke
	joke.success.connect(finish)
	joke.fail.connect(reset)
	joke.progress.connect(progress)
	joke_container = $HBoxContainer
	reset()

func reset() -> void:
	for child in joke_container.get_children():
		joke_container.remove_child(child)
	for keypress : JokeResource.Keypress in joke.sequence:
		add(keypress)
	current_index = 0
	
func progress() -> void:
	var current : TextureRect = joke_container.get_children()[current_index]
	if current.texture == left:
		current.texture = left_pressed
	if current.texture == right:
		current.texture = right_pressed
	if current.texture == down:
		current.texture = down_pressed
	if current.texture == up:
		current.texture = up_pressed
	current_index += 1

func finish() -> void:
	pass

func add(keypress : JokeResource.Keypress) -> void:
	var new : TextureRect = template.duplicate()
	if keypress.dir == JokeResource.Direction.RIGHT:
		new.texture = right
	if keypress.dir == JokeResource.Direction.LEFT:
		new.texture = left
	if keypress.dir == JokeResource.Direction.UP:
		new.texture = up
	if keypress.dir == JokeResource.Direction.DOWN:
		new.texture = down
	joke_container.add_child(new)
