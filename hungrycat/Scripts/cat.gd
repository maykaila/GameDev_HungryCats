extends RigidBody2D

# Reference to your AnimatedSprite2D node
@onready var anim = $AnimatedSprite2D
@onready var sfx_meow = get_node_or_null("SfxMeow")

var is_loading = false
var was_thrown = false
var has_hit_target = false
var walk_speed = 130.0
var stop_distance = 60.0

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	# Start with walking
	anim.play("walking")

func _physics_process(_delta):
	# 1. If it hit the target, keep the 'land' or 'idle' state
	if has_hit_target:
		# If 'land' is a one-shot animation, it will stop on its last frame
		# Otherwise, we just let it be.
		return

	# 2. Handle Thrown/Airborne state
	if was_thrown:
		anim.play("airborne")
		return
	
	# 3. Handle Loading state
	if is_loading:
		anim.play("in_catapult")
		return

	# 4. Handle Walking/Idle state (Ground movement)
	if is_path_blocked():
		linear_velocity.x = 0
		anim.play("idle")
	else:
		linear_velocity.x = walk_speed
		anim.play("walking")

func is_path_blocked() -> bool:
	var catapult_nodes = get_tree().get_nodes_in_group("catapult_group")
	var target_catapult = null
	
	for c in catapult_nodes:
		if "is_active" in c and c.is_active:
			if abs(c.global_position.x - global_position.x) < 500.0:
				target_catapult = c
				break
	
	if target_catapult:
		var dist_x = target_catapult.global_position.x - global_position.x
		if target_catapult.loaded_cat != null or target_catapult.is_recovering:
			if dist_x > 0 and dist_x < 110.0:
				return true

	var all_cats = get_tree().get_nodes_in_group("cats")
	for other in all_cats:
		if other == self or other.was_thrown: continue
		var x_dist = other.global_position.x - global_position.x
		if x_dist > 0 and x_dist < stop_distance:
			return true
			
	return false

func load_into_catapult():
	is_loading = true
	anim.play("in_catapult")
	set_deferred("freeze", true)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

func throw(velocity_vector: Vector2):
	is_loading = false
	was_thrown = true
	anim.play("airborne")
	freeze = false
	# NEW: Only play the sound if the node was successfully found!
	if sfx_meow:
		sfx_meow.play()
	else:
		print("Warning: This specific cat is missing its SfxMeow node!")
	collision_layer = 0
	collision_mask = 0
	apply_central_impulse(velocity_vector)
	angular_velocity = randf_range(-5, 5)
	
	# Short delay before re-enabling collision so it doesn't hit the catapult itself
	await get_tree().create_timer(0.1).timeout
	collision_layer = 1
	collision_mask = 1

func _on_body_entered(_body):
	# Only trigger landing logic if we were actually flying
	if was_thrown and not has_hit_target:
		has_hit_target = true
		was_thrown = false # No longer "airborne"
		
		anim.play("land")
		
		# Optional: If your 'land' animation isn't a loop, 
		# you could wait for it to finish then play 'idle'
		#await anim.animation_finished 
		#anim.play("idle")

		# Wait before removing the cat from the scene
		await get_tree().create_timer(3.0).timeout
		queue_free()
