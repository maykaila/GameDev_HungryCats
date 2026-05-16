extends Node

# --- CONFIGURATION ---
const SAVE_PATH = "user://save_data.save"

# List your level scene paths here in the exact order they should be played
const LEVELS: Array[String] = [
	"res://Scenes/level_1.tscn",
	"res://Scenes/level_2.tscn",
	"res://Scenes/level_3.tscn",
	"res://Scenes/level_4.tscn",
	"res://Scenes/level_5.tscn",
	"res://Scenes/level_6.tscn"
]

const MAIN_MENU_PATH = "res://Scenes/level_select.tscn"

# --- DATA ---
var current_level_index: int = 0
var unlocked_levels: int = 1 # Starts at 1 (only Level 1 unlocked)

func _ready():
	# Load progress as soon as the game starts
	load_data()

# --- NAVIGATION FUNCTIONS ---

## Loads a specific level (used by Level Select screen)
func load_level(index: int):
	if index >= 0 and index < LEVELS.size():
		current_level_index = index
		get_tree().change_scene_to_file(LEVELS[current_level_index])
	else:
		print("Error: Level index out of bounds!")

## Loads the next level in the list (used by 'Next Level' button)
func load_next_level():
	current_level_index += 1
	
	if current_level_index < LEVELS.size():
		get_tree().change_scene_to_file(LEVELS[current_level_index])
	else:
		print("All levels complete! Returning to menu.")
		go_to_main_menu()

## Returns to Level Select
func go_to_main_menu():
	get_tree().change_scene_to_file(MAIN_MENU_PATH)

# --- PROGRESSION LOGIC ---

## Unlocks the next level if the player just beat their highest reached level
func unlock_next_level(completed_index: int):
	# index 0 (Lvl 1) unlocks 2, index 1 (Lvl 2) unlocks 3, etc.
	var unlock_target = completed_index + 2 
	
	if unlock_target > unlocked_levels:
		unlocked_levels = unlock_target
		save_data()
		print("Progress saved! Levels unlocked: ", unlocked_levels)

# --- SAVE/LOAD SYSTEM ---

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# We only need to save the number of unlocked levels
		file.store_var(unlocked_levels)
		file.close()

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			unlocked_levels = file.get_var()
			file.close()
		else:
			unlocked_levels = 1 # Fallback if file is corrupted
	else:
		unlocked_levels = 1 # New game
