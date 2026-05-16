extends CanvasLayer

@onready var pause_overlay: ColorRect = $UIRoot/PauseOverlay
# Grab the specific Label node for the score
@onready var score_label: Label = $UIRoot/MarginContainer/HBoxContainer/Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# NEW: Wipe the slate clean every time this level loads!
	ScoreManager.reset_score()
	
	# Connect the HUD to the global ScoreManager
	ScoreManager.score_changed.connect(update_score_display)
	update_score_display(ScoreManager.current_score)

func update_score_display(new_score: int) -> void:
	# Update the text on screen! 
	score_label.text = str(new_score)

func _on_pause_button_pressed() -> void:
	AudioManager.play_click()
	pause_overlay.visible = true
	get_tree().paused = true

func _on_btn_play_pressed() -> void:
	AudioManager.play_click()
	pause_overlay.visible = false
	get_tree().paused = false

func _on_btn_settings_pressed() -> void:
	$SettingsPopup.show()

func _on_close_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_select.tscn")
