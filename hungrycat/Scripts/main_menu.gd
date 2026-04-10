extends Control


func _on_start_button_pressed() -> void:
	# This transitions to the Level Select screen!
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn") # Make sure this path is correct!


func _on_settings_button_pressed() -> void:
	# This pops open the settings menu you dropped into the scene
	$SettingsPopup.show()
