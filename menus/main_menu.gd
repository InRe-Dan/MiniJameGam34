extends Control

@onready var start : Button = %Start
@onready var level2 : Button = %Night2
@onready var level3 : Button = %Night3
@onready var vol_button : Button = %Volume
@onready var vol_slider : HSlider = %Volumeslider
@onready var screen_button : Button = %Screenshake
@onready var screen_slider : HSlider = %Screenslider


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")


func _on_night_2_pressed() -> void:
	# TODO set values in Globals
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _on_night_3_pressed() -> void:
	# TODO set values in Globals
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _on_volumeslider_changed() -> void:
	# TODO
	pass # Replace with function body.


func _on_screenshake_toggled(toggled_on: bool) -> void:
	screen_slider.visible = toggled_on


func _on_volume_toggled(toggled_on: bool) -> void:
	vol_slider.visible = toggled_on


func _on_screenslider_changed() -> void:
	# TODO
	pass # Replace with function body.
