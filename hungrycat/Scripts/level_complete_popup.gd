extends CanvasLayer

@onready var actual_score_label = $ColorRect/TextureRect/HBoxContainer/ActualScore
@onready var menu_button = $ColorRect/TextureRect/VBoxContainer/MenuButton
@onready var next_level_button = $ColorRect/TextureRect/VBoxContainer/NextLevelButton

# --- NEW NODES ---
@onready var star1: TextureRect = $ColorRect/TextureRect/StarsContainer/TextureRect
@onready var star2: TextureRect = $ColorRect/TextureRect/StarsContainer/TextureRect2
@onready var star3: TextureRect = $ColorRect/TextureRect/StarsContainer/TextureRect3

@onready var high_score_label: Label = $ColorRect/TextureRect/HBoxContainer/HighScoreLabel

# Define the points needed for each star
var one_star_score = 10000
var two_star_score = 30000
var three_star_score = 50000

func _ready():
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS
	menu_button.pressed.connect(_on_menu_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)
	
	# NEW: Listen for the exact signal name in your ScoreManager
	ScoreManager.level_completed.connect(_on_global_level_completed)

# NEW: This function catches the signal and the final_score, then opens the UI!
func _on_global_level_completed(final_score: int):
	open_level_complete(final_score)

func open_level_complete(final_score: int):
	actual_score_label.text = str(final_score)
	
	# 1. Handle the Stars Visuals
	# Darken the stars to grey first
	star1.modulate = Color(0.2, 0.2, 0.2, 1) 
	star2.modulate = Color(0.2, 0.2, 0.2, 1)
	star3.modulate = Color(0.2, 0.2, 0.2, 1)
	
	# Light them up based on the score!
	if final_score >= one_star_score:   star1.modulate = Color(1, 1, 1, 1)
	if final_score >= two_star_score:   star2.modulate = Color(1, 1, 1, 1)
	if final_score >= three_star_score: star3.modulate = Color(1, 1, 1, 1)

	# 2. Handle the High Score Saving
	# Get the name of the current level automatically (e.g., "Level1")
	var current_level = get_tree().current_scene.name 
	var is_new_record = SaveManager.save_high_score(current_level, final_score)
	
	if is_new_record:
		high_score_label.text = "NEW RECORD!"
	else:
		var best = SaveManager.get_high_score(current_level)
		high_score_label.text = "Best Score: " + str(best)

	self.show()
	get_tree().paused = true

func _on_next_level_pressed():
	get_tree().paused = false
	GameManager.load_next_level()

func _on_menu_pressed():
	get_tree().paused = false
	GameManager.go_to_main_menu()
