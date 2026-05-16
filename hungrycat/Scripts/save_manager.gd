extends Node

# One unified save file for everything in the game!
var save_path = "user://hungry_cat_save.cfg"
var config = ConfigFile.new()

func _ready():
	# Check if the file actually loads successfully!
	var err = config.load(save_path)
	if err == OK:
		print("✅ Save file loaded successfully!")
	else:
		print("⚠️ No save file found yet. A new one will be created.")

# --- HIGH SCORE FUNCTIONS ---

func save_high_score(level_name: String, score: int) -> bool:
	var current_high = get_high_score(level_name)
	
	# Print the exact math it is doing to the console
	print("--- SAVE MANAGER LOG ---")
	print("Level Name: ", level_name)
	print("Old Best Score: ", current_high)
	print("Score Just Earned: ", score)
	
	if score > current_high:
		print("🏆 NEW RECORD ACHIEVED! Saving to hard drive...")
		config.set_value("HighScores", level_name, score)
		config.save(save_path)
		return true 
		
	print("❌ Did not beat the high score.")
	return false

func get_high_score(level_name: String) -> int:
	return config.get_value("HighScores", level_name, 0)

# --- PROGRESSION FUNCTIONS ---

func has_seen_intro() -> bool:
	# Looks for the setting. If it can't find it (first time playing), it defaults to FALSE.
	return config.get_value("Progression", "seen_intro", false)

func mark_intro_as_seen() -> void:
	# Changes the setting to TRUE and saves the file permanently!
	config.set_value("Progression", "seen_intro", true)
	config.save(save_path)
