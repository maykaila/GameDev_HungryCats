extends Node2D

@onready var parallax_bg = $ParallaxBackground

# Control the speed of the background scrolling (higher numbers are faster)
@export var scroll_speed: float = 100.0

func _process(delta):
	# Increment the overall scroll_offset, making the city move right-to-left
	# We modify the overall offset, not the layer, so the ground stays still relative to it.
	parallax_bg.scroll_offset.x -= scroll_speed * delta

func _ready():
	# Start the global background music!
	GlobalMusic.play_music()

func _on_start_button_pressed() -> void:
	AudioManager.play_click()
	# This transitions to the Level Select screen!
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn") # Make sure this path is correct!


func _on_settings_button_pressed() -> void:
	AudioManager.play_click()
	# This pops open the settings menu you dropped into the scene
	%SettingsPopup.show()
