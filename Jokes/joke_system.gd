class_name JokeSystem extends Node

var jokes : Array[JokeResource]
var joke : JokeResource

func _ready() -> void:
	Globals.joke_system = self
	var dir : DirAccess = DirAccess.open("res://Jokes/JokeList/")
	for filename : String in dir.get_files():
		jokes.append(load("res://Jokes/JokeList/" + filename))
	new_joke()
	
# demo function
func new_joke() -> void:
	joke = jokes.pick_random().duplicate()
	for child in $CenterContainer.get_children():
		$CenterContainer.remove_child(child)
	$CenterContainer.add_child(joke.make_prompt())
	joke.success.connect(new_joke)
	joke.fail.connect(new_joke)
