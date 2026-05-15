extends Node2D

@onready var level_complete_ui = $levelComplete_popup
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

	# Setup Rats/Forts
	for i in range(rat_containers.size()):
		if rat_containers[i] == null: continue
		if i == 0:
			activate_container(rat_containers[i], "rats")
		else:
			rat_containers[i].hide()
			# Keep physics aware but sleeping to prevent explosions
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
			# HARD FREEZE future cats so they don't walk off-screen
			for child in cat_containers[i].get_children():
				if child is RigidBody2D:
					child.freeze = true

	update_catapult_system()
	await get_tree().create_timer(0.6).timeout 
	can_check_win = true

func _process(_delta: float) -> void:
	if game_over or not can_check_win: return
	check_conditions()

func check_conditions():
	var rats_in_group = get_tree().get_nodes_in_group("rats")
	if rats_in_group.size() == 0:
		if section_markers.size() > 0 and current_section_index < section_markers.size() - 1:
			advance_to_next_section()
		else:
			trigger_end_game(true)
		return

	# LOSS Logic
	var cats_left = get_tree().get_nodes_in_group("cats")
	var catapults = get_tree().get_nodes_in_group("catapult_group")
	var any_catapult_has_cat = false
	
	for c in catapults:
		if "is_active" in c:
			if c.is_active and c.loaded_cat != null:
				any_catapult_has_cat = true
				break
	
	if cats_left.size() == 0 and not any_catapult_has_cat:
		await get_tree().create_timer(3.5).timeout
		if get_tree().get_nodes_in_group("rats").size() > 0:
			trigger_end_game(false)

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
	
	for body in all_physics_stuff:
		body.sleeping = false
		body.freeze = false # Unfreeze cats so they start walking
		
		if body.has_method("take_damage") or group_name == "cats":
			body.add_to_group(group_name)

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
		ScoreManager.trigger_level_complete(get_tree())
		if level_complete_ui:
			level_complete_ui.open_level_complete(ScoreManager.current_score)
	else:
		get_tree().reload_current_scene()
