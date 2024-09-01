extends Control

@onready var time_stat: RichTextLabel = %TimeStat
@onready var jokes_stat: RichTextLabel = %JokesStat
@onready var laughs_stat: RichTextLabel = %LaughsStat
@onready var tomatos_stat: RichTextLabel = %TomatosStat
@onready var near_miss_stat: RichTextLabel = %NearMissStat



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_stat.text = "[center]Time: [color=yellow]" + str(int(Globals.time_played)) + "[/color][/center]"
	jokes_stat.text = "[center]Jokes told: [color=green]" + str(Globals.jokes_told) + "[/color][/center]"
	laughs_stat.text = "[center]Laughs received: [color=orange]" + str(Globals.laughs_got) + "[/color][/center]"
	tomatos_stat.text = "[center]Tomatos sold: [color=red]" + str(Globals.tomatos_sold) + "[/color][/center]"
	near_miss_stat.text = "[center]Near misses: [color=gray]" + str(Globals.near_misses) + "[/color][/center]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
