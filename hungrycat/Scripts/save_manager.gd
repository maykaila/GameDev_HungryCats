extends Node

# This creates a file directly in the player's hidden AppData/Application Support folder
var save_path = "user://highscores.cfg"
var config = ConfigFile.new()

func _ready():
	# Load the file when the game boots up
	config.load(save_path)

func save_high_score(level_name: String, score: int) -> bool:
	var current_high = get_high_score(level_name)
	
	# Only save if the new score is better!
	if score > current_high:
		config.set_value("HighScores", level_name, score)
		config.save(save_path)
		return true # Returns true so we know to display "NEW RECORD!"
		
	return false

func get_high_score(level_name: String) -> int:
	# Returns the saved score, or 0 if they haven't played this level yet
	return config.get_value("HighScores", level_name, 0)
