extends Control

# --- IMPORTANT: Double check these file paths match your project! ---
const INTRO_SCENE = "res://Scenes/story_intro.tscn" 
const MAIN_MENU_SCENE = "res://Scenes/main_menu_hybrid.tscn"

func _ready():
	# 1. Ask the global SaveManager if they've seen the story
	if SaveManager.has_seen_intro():
		# 2. If true, skip right to the main menu
		get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE)
	else:
		# 3. If false, send them to the story (but don't mark it as seen yet!)
		get_tree().call_deferred("change_scene_to_file", INTRO_SCENE)
