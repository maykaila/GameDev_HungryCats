extends CanvasLayer

@onready var pause_overlay: ColorRect = $UIRoot/PauseOverlay

func _ready() -> void:
	# This guarantees the UI never freezes, even if you forget to set it in the Inspector!
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_pause_button_pressed() -> void:
	# Show the menu and freeze the game
	pause_overlay.visible = true
	get_tree().paused = true


func _on_btn_play_pressed() -> void:
	# Hide the menu and unfreeze the game
	pause_overlay.visible = false
	get_tree().paused = false


func _on_btn_exit_pressed() -> void:
	# 1. Unfreeze the game engine first so your menu buttons actually work!
	get_tree().paused = false
	
	# 2. Change the scene back to the Level Select screen
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
	

func _on_btn_settings_pressed() -> void:
	$SettingsPopup.show()
