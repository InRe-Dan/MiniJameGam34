extends Control

@onready var start : Button = %Start
@onready var level2 : Button = %Night2
@onready var level3 : Button = %Night3
@onready var guide : Button = %Guide
@onready var vol_button : Button = %Volume
@onready var vol_slider : HSlider = %Volumeslider
@onready var screen_button : Button = %Screenshake
@onready var screen_slider : HSlider = %Screenslider
@onready var fullscreen : Button = %Fullscreen
@onready var x1 : Button = %"1x"
@onready var x2 : Button = %"2x"
@onready var x3 : Button = %"3x"
var base_size : Vector2i = Vector2i(720, 540)

func _ready() -> void:
	if Globals.level_reached > 1:
		level2.disabled = false
	if Globals.level_reached > 2:
		level3.disabled = false
	vol_slider.value = 0.3
	screen_slider.value = 1.0

func _on_start_pressed() -> void:
	Globals.setup_level_1()
	get_tree().change_scene_to_file("res://Main/main.tscn")


func _on_night_2_pressed() -> void:
	Globals.setup_level_2()
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _on_night_3_pressed() -> void:
	Globals.setup_level_3()
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _on_volumeslider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_screenshake_toggled(toggled_on: bool) -> void:
	screen_slider.visible = toggled_on
	if toggled_on:
		guide.button_pressed = false


func _on_volume_toggled(toggled_on: bool) -> void:
	vol_slider.visible = toggled_on
	if toggled_on:
		guide.button_pressed = false

func _on_screenslider_changed() -> void:
	Globals.screen_shake = screen_slider.value

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
func _on_1x_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_viewport().size = (base_size * 1)
func _on_2x_toggled(toggled_on : bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_viewport().size = (base_size * 2)
func _on_3x_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		get_viewport().size = (base_size * 3)

func _on_guide_toggled(toggled_on: bool) -> void:
	$PanelContainer.visible = toggled_on
	if toggled_on:
		vol_button.button_pressed = false
		screen_button.button_pressed = false
