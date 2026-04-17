extends Control



func _on_settings_button_pressed() -> void:
	$SettingsPopup.show()


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_3.tscn")
