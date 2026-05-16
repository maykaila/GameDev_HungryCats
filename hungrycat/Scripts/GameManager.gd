extends Node

# --- LEVEL CONFIGURATION ---
# List your level scene paths here in the exact order you want them played
const LEVELS: Array[String] = [
	"res://Scenes/level_1.tscn",
	"res://Scenes/level_2.tscn",
	"res://Scenes/level_3.tscn",
	"res://Scenes/level_4.tscn",
	"res://Scenes/level_5.tscn",
	"res://Scenes/level_6.tscn"
]

const MAIN_MENU_PATH = "res://Scenes/level_select.tscn"

# Track the index of the level currently being played
var current_level_index: int = 0


# --- LEVEL NAVIGATION FUNCTIONS ---

## Call this from your Level Selection Menu to start a specific level
func load_level(index: int) -> void:
	if index >= 0 and index < LEVELS.size():
		current_level_index = index
		get_tree().change_scene_to_file(LEVELS[current_level_index])
	else:
		print("Error: Level index ", index, " out of bounds!")

## Call this when the "Next Level" button is pressed
func load_next_level() -> void:
	current_level_index += 1
	
	# Check if there is another level in the array
	if current_level_index < LEVELS.size():
		get_tree().change_scene_to_file(LEVELS[current_level_index])
	else:
		# No more levels left! Send them back to the main menu/level select
		print("Game Complete! Returning to menu.")
		go_to_main_menu()

## Helper to quickly head back to the main menu
func go_to_main_menu() -> void:
	current_level_index = 0 # Reset progression tracker
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
