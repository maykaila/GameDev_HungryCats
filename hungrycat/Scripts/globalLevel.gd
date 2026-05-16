extends Node2D

@onready var level_complete_ui = $CanvasLayer/levelComplete_popup
@onready var level_failed_ui = $CanvasLayer/levelFailed_popup
@onready var camera = $Camera2D

@export var section_markers: Array[Marker2D] = []
@export var rat_containers: Array[Node2D] = []
@export var cat_containers: Array[Node2D] = []

var current_section_index: int = 0
var game_over = false
var can_check_win = false

func _ready() -> void:
	if level_complete_ui:
		level_complete_ui.hide()
	
	if camera and section_markers.size() > 0:
		camera.global_position = section_markers[0].global_position

	print("--- STARTING LEVEL INITIALIZATION ---")

	# Setup Rats/Forts
	for i in range(rat_containers.size()):
		if rat_containers[i] == null: 
			print("⚠️ WARNING: Rat container slot ", i, " is empty in the Inspector!")
			continue
		if i == 0:
			print("Activating Section 1 Rats...")
			activate_container(rat_containers[i], "rats")
		else:
			rat_containers[i].hide()
			var bodies = rat_containers[i].find_children("*", "RigidBody2D", true)
			for b in bodies:
				b.sleeping = true

	# Setup Cats
	for i in range(cat_containers.size()):
		if cat_containers[i] == null: continue
		if i == 0:
			activate_container(cat_containers[i], "cats")
		else:
			cat_containers[i].hide()
			for child in cat_containers[i].get_children():
				if child is RigidBody2D:
					child.freeze = true

	update_catapult_system()
	
	# Let's check how many rats were successfully registered before we turn on the win-checker
	print("Final count before gameplay starts - Rats in group: ", get_tree().get_nodes_in_group("rats").size())
	print("-------------------------------------")
	
	await get_tree().create_timer(0.6).timeout 
	can_check_win = true
	
func _process(_delta: float) -> void:
	if game_over or not can_check_win: return
	check_conditions()

func check_conditions():
	# Note: We do NOT subtract 1 here anymore, because this runs continuously in _process!
	var rats_alive = get_tree().get_nodes_in_group("rats").size()
	var cats_left = get_tree().get_nodes_in_group("cats").size()
	
	# --- 1. SECTION CLEAR CONDITION (WIN) ---
	if rats_alive <= 0:
		can_check_win = false # Lock it! Stop checking 60 times a second.
		await get_tree().create_timer(1.5).timeout # Wait for the final poof explosion
		
		# Are there more forts left in the level?
		if current_section_index < rat_containers.size() - 1:
			advance_to_next_section()
		else:
			trigger_end_game(true) # We beat the final section!
		return

	# --- 2. OUT OF AMMO CONDITION (FAIL) ---
	if cats_left <= 0 and rats_alive > 0:
		can_check_win = false # Lock it! Prevent thousands of timers from spawning.
		await get_tree().create_timer(4.0).timeout
		
		# Check the dust one last time
		var final_rats = get_tree().get_nodes_in_group("rats").size()
		if final_rats > 0:
			trigger_end_game(false) # You officially lost
		else:
			# The last piece of wood killed the last rat!
			can_check_win = true # Unlock it so the WIN condition above triggers on the next frame

func advance_to_next_section():
	can_check_win = false 
	current_section_index += 1
	
	var tween = create_tween()
	tween.tween_property(camera, "global_position", section_markers[current_section_index].global_position, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	if current_section_index < rat_containers.size():
		activate_container(rat_containers[current_section_index], "rats")
	if current_section_index < cat_containers.size():
		activate_container(cat_containers[current_section_index], "cats")
	
	update_catapult_system()
	
	await get_tree().create_timer(0.5).timeout
	can_check_win = true

func activate_container(container: Node2D, group_name: String):
	if container == null: return
	container.show()
	
	var all_physics_stuff = container.find_children("*", "RigidBody2D", true)
	print("Found ", all_physics_stuff.size(), " total physics bodies inside ", container.name)
	
	var added_count = 0
	for body in all_physics_stuff:
		body.sleeping = false
		body.freeze = false 
		
		if body.has_method("take_damage") or group_name == "cats":
			body.add_to_group(group_name)
			added_count += 1
			print("   -> Success! Added ", body.name, " to group: ", group_name)
			
	print("Finished activating ", container.name, ". Total added to group '", group_name, "': ", added_count)

func update_catapult_system():
	var all_nodes = get_tree().get_nodes_in_group("catapult_group")
	var actual_catapults = []
	for node in all_nodes:
		if "is_active" in node:
			actual_catapults.append(node)
	
	actual_catapults.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)
	
	for i in range(actual_catapults.size()):
		actual_catapults[i].is_active = (i == current_section_index)

func trigger_end_game(is_win: bool):
	if game_over: return
	game_over = true
	
	if is_win:
		GameManager.unlock_next_level(GameManager.current_level_index)
		ScoreManager.trigger_level_complete(get_tree())
		if level_complete_ui:
			level_complete_ui.open_level_complete(ScoreManager.current_score)
	else:
		# INSTEAD OF: get_tree().reload_current_scene()
		# WE DO THIS:
		if level_failed_ui:
			level_failed_ui.open_level_failed(ScoreManager.current_score)
		else:
			# Fallback just in case you forgot to add the UI to a level
			get_tree().reload_current_scene()
