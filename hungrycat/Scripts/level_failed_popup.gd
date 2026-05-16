extends CanvasLayer

# UPDATE THESE PATHS to match your actual folder structure!
const MAIN_MENU_PATH = "res://Scenes/level_select.tscn"

func _ready() -> void:
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS

# This is the function called by your globalLevel.gd script
func open_level_failed() -> void:
	self.show()
	get_tree().paused = true # Pause everything else in the background

func _on_retry_level_button_pressed() -> void:
	# Unpause the game before reloading, otherwise the new scene starts paused!
	get_tree().paused = false
	get_tree().reload_current_scene() # 

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
