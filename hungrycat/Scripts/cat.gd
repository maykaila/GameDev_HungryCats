extends RigidBody2D

var is_loading = false
var was_thrown = false
var has_hit_target = false
var walk_speed = 130.0
var stop_distance = 60.0 # Tighter queueing

func _ready():
	add_to_group("cats")
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	# If the cat is in the spoon, flying, or finished, don't move
	if is_loading or was_thrown or has_hit_target:
		return

	if is_path_blocked():
		linear_velocity.x = 0
	else:
		linear_velocity.x = walk_speed

func is_path_blocked() -> bool:
	var catapult = get_tree().get_first_node_in_group("catapult_group")
	
	# 1. STOP for the Catapult machine
	if catapult:
		# If there is a cat already in the spoon OR the arm is swinging back
		if catapult.loaded_cat != null or catapult.is_recovering:
			var dist_to_catapult_x = catapult.global_position.x - global_position.x
			# If we are close to the machine's front, stop
			if dist_to_catapult_x > 0 and dist_to_catapult_x < 110.0:
				return true

	# 2. STOP for other cats in line
	var all_cats = get_tree().get_nodes_in_group("cats")
	for other in all_cats:
		# REMOVED: "or other.is_loading" - we SHOULD stop if the cat ahead is loading!
		if other == self or other.was_thrown: 
			continue
		
		var x_dist = other.global_position.x - global_position.x
		# If the cat in front is within the stop distance, stop walking
		if x_dist > 0 and x_dist < stop_distance:
			return true
			
	return false

func load_into_catapult():
	is_loading = true
	set_deferred("freeze", true)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

func throw(velocity_vector: Vector2):
	is_loading = false
	was_thrown = true
	
	freeze = false
	
	# Give it a tiny headstart to clear the catapult before turning on collisions
	# This avoids the "bonk" without needing collision exceptions
	collision_layer = 0
	collision_mask = 0
	
	apply_central_impulse(velocity_vector)
	angular_velocity = randf_range(-5, 5)
	
	# Wait 0.1 seconds (just enough to leave the spoon) then turn collisions back on
	await get_tree().create_timer(0.1).timeout
	collision_layer = 1
	collision_mask = 1

func _on_body_entered(_body):
	if was_thrown and not has_hit_target:
		has_hit_target = true
		# Optional: freeze on impact or just let it tumble
		# set_deferred("freeze", true)
