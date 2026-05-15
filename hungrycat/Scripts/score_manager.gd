extends Node

signal score_changed(new_score)
signal level_completed(final_score) # New megaphone to announce a win!

var current_score: int = 0
var cat_bonus_value: int = 10000 # 10k points per unused cat!

func add_score(points: int) -> void:
	current_score += points
	score_changed.emit(current_score)

func reset_score() -> void:
	current_score = 0
	score_changed.emit(current_score)

func trigger_level_complete(tree: SceneTree) -> void:
	# 1. Find all cats in the level
	var remaining_cats = tree.get_nodes_in_group("cats")
	var unused_cats = 0
	
	# 2. Count only the ones that are still waiting in line
	for cat in remaining_cats:
		if not cat.was_thrown:
			unused_cats += 1
			
	# 3. Apply the massive bonus!
	var bonus_points = unused_cats * cat_bonus_value
	if bonus_points > 0:
		add_score(bonus_points)
		print("Bonus Applied! " + str(unused_cats) + " cats left = " + str(bonus_points) + " points!")
		
	# 4. Announce that the level is officially won
	level_completed.emit(current_score)
