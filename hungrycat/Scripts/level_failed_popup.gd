extends CanvasLayer

@onready var actual_score_label = $ColorRect/TextureRect/HBoxContainer/ActualScore
@onready var menu_button = $ColorRect/TextureRect/VBoxContainer/MenuButton

# FIXED: Node path updated to match your scene tree (RetryLevelButton)
@onready var retry_level_button = $ColorRect/TextureRect/VBoxContainer/RetryLevelButton

func _ready():
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS
	
	menu_button.pressed.connect(_on_menu_pressed)
	retry_level_button.pressed.connect(_on_retry_level_pressed)
	
	# NEW: Listen for the global fail signal from anywhere in the game!
	ScoreManager.level_failed.connect(_on_global_level_failed)

# NEW: This runs when the signal is triggered
func _on_global_level_failed():
	# Pass the current score directly into your existing open function
	open_level_failed(ScoreManager.current_score)

# FIXED: Renamed so it makes sense for failing
func open_level_failed(final_score: int):
	actual_score_label.text = str(final_score)
	self.show()
	get_tree().paused = true

# FIXED: This now reloads the exact same level instead of moving forward
func _on_retry_level_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	GameManager.go_to_main_menu()
