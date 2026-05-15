extends Node2D

@onready var axle = $axle
@onready var launch_point = $axle/spoon/launchPoint
@onready var trajectory_line: Line2D = $TrajectoryLine

var max_pull_back_degrees = -30.0
var release_speed = 8.0

var is_pulling = false
var pull_power = 0.0
var loaded_cat = null 
var is_recovering = false 

### NEW: Variables for mouse dragging
var max_drag_distance: float = 200.0 # Adjust this to change how far back you have to pull for max power
var current_drag_vector: Vector2 = Vector2.ZERO

var trajectory_points: int = 50 
var trajectory_time_step: float = 0.05 

func _process(delta):
	if is_instance_valid(loaded_cat):
		# Check if the Left Mouse Button is being held down
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_pulling = true
			
			# 1. Calculate the vector from the mouse to the catapult base
			# (Pulling down-left makes the vector point up-right)
			var mouse_pos = get_global_mouse_position()
			current_drag_vector = global_position - mouse_pos
			
			# 2. Calculate pull power based on how far we dragged (Clamped between 0.0 and 1.0)
			var drag_distance = current_drag_vector.length()
			pull_power = clamp(drag_distance / max_drag_distance, 0.0, 1.0)
			
			# 3. Visually rotate the catapult arm so it still looks like it's pulling back
			axle.rotation = deg_to_rad(pull_power * max_pull_back_degrees)
			
			update_trajectory() 
			
		elif is_pulling:
			# The moment the left mouse button is released, launch!
			launch()
	
	if not is_pulling:
		axle.rotation = lerp_angle(axle.rotation, 0.0, delta * release_speed)
		trajectory_line.clear_points()
		
		if abs(axle.rotation) < 0.01:
			is_recovering = false

func _physics_process(_delta):
	if is_instance_valid(loaded_cat):
		loaded_cat.global_position = launch_point.global_position
		loaded_cat.global_rotation = launch_point.global_rotation

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("cats") and loaded_cat == null:
		if not is_pulling and not is_recovering and not body.was_thrown:
			loaded_cat = body
			body.load_into_catapult()

func launch():
	is_recovering = true
	
	# Default launch direction (just in case they click without dragging at all)
	var launch_dir = Vector2.RIGHT.rotated(deg_to_rad(-60))
	
	# If they actually dragged the mouse, use that angle for the trajectory!
	if current_drag_vector.length() > 10.0:
		launch_dir = current_drag_vector.normalized()
	
	var launch_force = 1200.0 + (1000.0 * pull_power)
	
	var cat_to_launch = loaded_cat
	loaded_cat = null 
	
	if is_instance_valid(cat_to_launch):
		cat_to_launch.throw(launch_dir * launch_force)
	
	is_pulling = false
	pull_power = 0.0
	trajectory_line.clear_points()

func update_trajectory() -> void:
	trajectory_line.clear_points()
	
	if loaded_cat == null:
		return

	# Copying the exact same aiming logic from launch() for a perfect preview
	var launch_dir = Vector2.RIGHT.rotated(deg_to_rad(-60))
	if current_drag_vector.length() > 10.0:
		launch_dir = current_drag_vector.normalized()
		
	var launch_force = 1200.0 + (1000.0 * pull_power)
	
	var initial_velocity = (launch_dir * launch_force) / loaded_cat.mass
	
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	var gravity_dir = ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	var actual_gravity = (gravity_dir * gravity) * loaded_cat.gravity_scale
	
	var start_pos = launch_point.global_position
	
	for i in range(trajectory_points):
		var t = i * trajectory_time_step
		var future_pos = start_pos + (initial_velocity * t) + (0.5 * actual_gravity * t * t)
		trajectory_line.add_point(trajectory_line.to_local(future_pos))
