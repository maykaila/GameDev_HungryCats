extends CanvasLayer

# --- CONFIGURATION ---
# @export makes this show up in the Inspector on the right!
@export_file("*.tscn") var next_level_path: String
const MAIN_MENU_PATH = "res://Scenes/level_select.tscn"

# --- NODES ---
@onready var actual_score_label = $ColorRect/TextureRect/HBoxContainer/ActualScore
@onready var menu_button = $ColorRect/TextureRect/VBoxContainer/MenuButton
@onready var next_level_button = $ColorRect/TextureRect/VBoxContainer/NextLevelButton

func _ready():
	self.hide()
	process_mode = PROCESS_MODE_ALWAYS
	
	# Connect signals
	menu_button.pressed.connect(_on_menu_pressed)
	next_level_button.pressed.connect(_on_next_level_pressed)

func open_level_complete(final_score: int):
	actual_score_label.text = str(final_score)
	
	# If we forgot to set a next level path, hide the 'Next Level' button
	if next_level_path == "":
		next_level_button.hide()
	else:
		next_level_button.show()
	
	self.show()
	get_tree().paused = true

func _on_next_level_pressed():
	get_tree().paused = false
	if next_level_path != "" and ResourceLoader.exists(next_level_path):
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("No next level set or file missing!")

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
