extends Node2D

@onready var axle = $axle
@onready var launch_point = $axle/spoon/launchPoint

var max_pull_back_degrees = -30.0
var pull_speed = 1.5
var release_speed = 8.0

var is_pulling = false
var pull_power = 0.0
var loaded_cat = null 
var is_recovering = false # Prevents immediate reloading during animation

func _process(delta):
	if is_instance_valid(loaded_cat):
		if Input.is_action_pressed("ui_select"):
			is_pulling = true
			pull_power = move_toward(pull_power, 1.0, delta * pull_speed)
			axle.rotation = deg_to_rad(pull_power * max_pull_back_degrees)
		elif is_pulling:
			launch()
	
	# Smoothly return to 0 rotation if not pulling
	if not is_pulling:
		axle.rotation = lerp_angle(axle.rotation, 0.0, delta * release_speed)
		# Allow reloading only when the spoon is mostly reset
		if abs(axle.rotation) < 0.01:
			is_recovering = false

func _physics_process(_delta):
	if is_instance_valid(loaded_cat):
		loaded_cat.global_position = launch_point.global_position
		loaded_cat.global_rotation = launch_point.global_rotation

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Only load if:
	# 1. It's a cat
	# 2. We don't have a cat loaded
	# 3. We aren't currently pulling back/launching
	# 4. The catapult is NOT in recovery (swinging back)
	# 5. The cat isn't already flying/hit a target
	if body.is_in_group("cats") and loaded_cat == null:
		if not is_pulling and not is_recovering and not body.was_thrown:
			loaded_cat = body
			body.load_into_catapult()

func launch():
	is_recovering = true
	
	# 1. Change angle to -60 for a higher, more curved "lob"
	var launch_dir = Vector2.RIGHT.rotated(deg_to_rad(-60))
	
	# 2. Lower the force significantly (adjusted for your 2.5 gravity)
	# Try these numbers first. If it's still too far, lower the 1200 to 1000.
	var launch_force = 1200.0 + (1000.0 * pull_power)
	
	var cat_to_launch = loaded_cat
	loaded_cat = null 
	
	if is_instance_valid(cat_to_launch):
		cat_to_launch.throw(launch_dir * launch_force)
	
	is_pulling = false
	pull_power = 0.0
