extends CanvasLayer

const MAIN_MENU_PATH = "res://Scenes/level_select.tscn"

# --- NODES ---
# Make sure this path ($ColorRect/...) matches your actual scene tree!
@onready var actual_score_label = $ColorRect/TextureRect/HBoxContainer/ActualScore

func _ready() -> void:
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS

# Update this function to accept the score argument
func open_level_failed(final_score: int) -> void:
	if actual_score_label:
		actual_score_label.text = str(final_score)
	
	self.show()
	get_tree().paused = true 

func _on_retry_level_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene() 

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	# Use your new GameManager for consistency!
	GameManager.go_to_main_menu()
