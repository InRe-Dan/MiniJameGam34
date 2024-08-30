class_name JokeResource extends Resource

## Struct to contain a part of an input sequence
class Keypress:
	var complete : bool = false
	var dir : Direction
	var words : Array[String]

enum Direction {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}

@export_multiline var setup : String
@export_multiline var punchline : String

signal fail
signal success
signal progress

## Input sequence of this joke.
var sequence : Array[Keypress]:
	get:
		if not sequence:
			sequence = _generate_sequence()
		return sequence
var prompt_scene : PackedScene = preload("res://Jokes/keypress_prompt.tscn")

# Give the joke an input to process. Fires one of three signals depending on result.
func give_input(dir : Direction) -> void:
	var current : Keypress = null
	for keypress : Keypress in sequence:
		if not keypress.complete:
			current = keypress
			break
	# Shouldn't be giving inputs if the sequence is finished
	assert(current)
	if current.dir == dir:
		current.complete = true
		progress.emit()
		if current == sequence.back():
			success.emit()
	else:
		for keypress : Keypress in sequence:
			keypress.complete = false
		fail.emit()

# Makes a control node linked to this one which can keep track of player inputs
func make_prompt() -> KeypressPrompt:
	var prompt : KeypressPrompt = prompt_scene.instantiate()
	prompt.initialize(self)
	return prompt

# Private method only called once. Do not call manually.
func _generate_sequence() -> Array[Keypress]:
	print("New joke =============")
	assert(setup)
	assert(punchline)
	var seq : Array[Keypress]
	var words : Array = Array(setup.split(" "))
	while words:
		var keypress : Keypress = Keypress.new()
		keypress.dir = Direction.values().pick_random()
		var words_to_use : int = ceil(1 / Globals.joke_difficulty)
		while words and words_to_use > 0:
			words_to_use -= 1
			keypress.words.append(words.pop_front())
		seq.append(keypress)
		print(Direction.keys()[keypress.dir], keypress.words)
	return seq
