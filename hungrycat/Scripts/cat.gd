extends RigidBody2D

var is_loading = false
var was_thrown = false
var has_hit_target = false
var walk_speed = 130.0
var stop_distance = 60.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	if is_loading or was_thrown or has_hit_target:
		return

	if is_path_blocked():
		linear_velocity.x = 0
	else:
		linear_velocity.x = walk_speed

func is_path_blocked() -> bool:
	var catapult_nodes = get_tree().get_nodes_in_group("catapult_group")
	var target_catapult = null
	
	for c in catapult_nodes:
		# SAFETY: Check if it's a catapult and if it's active
		if "is_active" in c and c.is_active:
			# Only care if the catapult is within 500 pixels (same section)
			if abs(c.global_position.x - global_position.x) < 500.0:
				target_catapult = c
				break
	
	if target_catapult:
		var dist_x = target_catapult.global_position.x - global_position.x
		if target_catapult.loaded_cat != null or target_catapult.is_recovering:
			# Stop walking if we are right in front of the active machine
			if dist_x > 0 and dist_x < 110.0:
				return true

	# Stop for other cats in line
	var all_cats = get_tree().get_nodes_in_group("cats")
	for other in all_cats:
		if other == self or other.was_thrown: continue
		var x_dist = other.global_position.x - global_position.x
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
	collision_layer = 0
	collision_mask = 0
	apply_central_impulse(velocity_vector)
	angular_velocity = randf_range(-5, 5)
	await get_tree().create_timer(0.1).timeout
	collision_layer = 1
	collision_mask = 1

func _on_body_entered(_body):
	if was_thrown and not has_hit_target:
		has_hit_target = true
		await get_tree().create_timer(3.0).timeout
		queue_free()
