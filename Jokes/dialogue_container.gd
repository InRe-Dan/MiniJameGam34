class_name DialogueContainer extends CenterContainer

@onready var setup : Label = %Setup
@onready var punchline : Label = %Punchline

var joke : JokeResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup.text = ""
	punchline.text = ""

func progress(joke : JokeResource) -> void:
	if not joke:
		return
	setup.text = ""
	for keypress : JokeResource.Keypress in joke.sequence:
		if not keypress.complete:
			break
		setup.text += keypress.letters

func set_joke(joke : JokeResource) -> void:
	clear_joke(null)
	self.joke = joke
	joke.fail.connect(clear_joke)
	joke.success.connect(success)
	joke.progress.connect(progress)
	
func success(joke : JokeResource) -> void:
	# punchline.text = joke.punchline
	setup.label_settings.font_color = Color.LAWN_GREEN
	punchline.label_settings.font_color = Color.LAWN_GREEN
	
func clear_joke(joke : JokeResource) -> void:
	joke = null
	setup.text = ""
	punchline.text = ""
	setup.label_settings.font_color = Color.WHITE
	punchline.label_settings.font_color = Color.WHITE
