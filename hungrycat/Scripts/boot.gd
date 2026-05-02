extends Control

# The path where Godot safely saves data on ANY device (PC, Android, iOS)
const SAVE_PATH = "user://player_data.cfg"

# --- IMPORTANT: Change these to match your EXACT file paths in the FileSystem dock ---
const INTRO_SCENE = "res://Scenes/story_intro.tscn" 
const MAIN_MENU_SCENE = "res://Scenes/main_menu_hybrid.tscn"

func _ready():
	# The moment the game boots, check our save file
	if has_played_before():
		# Use call_deferred to safely change the scene AFTER the tree is unlocked
		get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE)
	else:
		mark_as_played()
		get_tree().call_deferred("change_scene_to_file", INTRO_SCENE)

func has_played_before() -> bool:
	var config = ConfigFile.new()
	# Try to load the save file
	var error = config.load(SAVE_PATH)
	
	if error == OK:
		# If the file exists, get our saved "has_seen_intro" boolean.
		# If it can't find it for some reason, it defaults to false.
		return config.get_value("Progress", "has_seen_intro", false)
	
	# If the file doesn't exist at all (error != OK), it's their first time.
	return false

func mark_as_played():
	var config = ConfigFile.new()
	# Set a variable called "has_seen_intro" to true inside a "Progress" category
	config.set_value("Progress", "has_seen_intro", true)
	# Save this to the player's hard drive/phone storage
	config.save(SAVE_PATH)
