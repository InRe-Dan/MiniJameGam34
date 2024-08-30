class_name JokeResource extends Resource

## Struct to contain a part of an input sequence
class Keypress:
	var complete : bool = false
	var dir : Direction
	var words : Array[String]

enum Direction {UP, DOWN, LEFT, RIGHT}

@export_multiline var setup : String
@export_multiline var punchline : String

signal fail
signal success
signal progress

## Input sequence of this joke.
var sequence : Array[Keypress]:
	get:
		if not sequence:
			return _generate_sequence()
		else:
			return sequence

# Give the joke an input to process. Fires one of three signals depending on result.
func give_input(dir : Direction) -> void:
	var current : Keypress = null
	for keypress : Keypress in sequence:
		if keypress.complete:
			current = keypress
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

# Private method only called once. Do not call manually.
func _generate_sequence() -> Array[Keypress]:
	assert(setup)
	assert(punchline)
	var seq : Array[Keypress]
	var words : Array[String] = setup.split(" ")
	while words:
		var keypress : Keypress = Keypress.new()
		keypress.dir = Direction.keys().pick_random()
		var words_to_use : int = ceil(1 / Globals.joke_difficulty)
		while words and words_to_use > 0:
			words_to_use -= 1
			keypress.words.append(words.pop_front())
	return seq
