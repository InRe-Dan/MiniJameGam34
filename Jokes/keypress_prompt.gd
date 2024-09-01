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

@export var joke_container : Container

var joke : JokeResource
var current_index = 0

func initialize(joke : JokeResource) -> void:
	self.joke = joke
	joke.success.connect(finish)
	joke.fail.connect(fail)
	joke.progress.connect(progress)
	reset()

func reset() -> void:
	for child in joke_container.get_children():
		joke_container.remove_child(child)
	for keypress : JokeResource.Keypress in joke.sequence:
		add(keypress)
	joke_container.get_children().front().modulate = Color.WHITE
	current_index = 0
	
func progress(joke : JokeResource) -> void:
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
	if current_index < joke_container.get_child_count():
		joke_container.get_children()[current_index].modulate = Color.WHITE

func finish(joke : JokeResource) -> void:
	pass
func fail(joke : JokeResource) -> void:
	pass

func get_key_texture() -> Texture2D:
	if current_index < joke_container.get_child_count():
		return joke_container.get_children()[current_index].texture
	else: return null

func add(keypress : JokeResource.Keypress) -> void:
	var new : TextureRect = template.duplicate()
	#new.modulate = Color.TRANSPARENT
	if keypress.dir == JokeResource.Direction.RIGHT:
		new.texture = right
	if keypress.dir == JokeResource.Direction.LEFT:
		new.texture = left
	if keypress.dir == JokeResource.Direction.UP:
		new.texture = up
	if keypress.dir == JokeResource.Direction.DOWN:
		new.texture = down
	new.modulate = 0.3 * Color.TRANSPARENT + 0.7 * Color.WHITE
	joke_container.add_child(new)
