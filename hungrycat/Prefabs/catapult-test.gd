extends Node2D

@onready var axle = $axle
@onready var launch_point = $axle/spoon/launchPoint

var rotation_speed = 2.0
#var max_pull_back = -1.2  # more far back
#var max_pull_back = -0.6  # slightly not that back, looks more stiff
var max_pull_back_degrees = -28.0
var is_pulling = false
var current_rotation = 0.0

# for the regular max_pull_back
#func _process(delta):
	#if Input.is_action_pressed("ui_select"): # Spacebar
		#is_pulling = true
		## Slowly rotate back
		#current_rotation = lerp(current_rotation, max_pull_back, delta * rotation_speed)
	#else:
		#if is_pulling:
			#launch()
		#is_pulling = false
		## Return to idle with a slight bounce (lerp back to 0)
		#current_rotation = lerp(current_rotation, 0.0, delta * 10.0)
#
	#axle.rotation = current_rotation

# This is for the degrees one
func _process(delta):
	if Input.is_action_pressed("ui_select"):
		is_pulling = true
		# Use degrees for your brain, but deg_to_rad() for Godot's engine
		var _target_rad = deg_to_rad(max_pull_back_degrees)
		current_rotation = lerp(current_rotation, _target_rad, delta * rotation_speed)
		#current_rotation = lerp(current_rotation, max_pull_back_degrees, delta * 2.0) # DONT EVER USE THISS
	else:
		if is_pulling:
			launch()
		is_pulling = false
		#current_rotation = lerp(current_rotation, 0.0, delta * 10.0)
		current_rotation = lerp(current_rotation, 0.0, delta * 25.0)
		#current_rotation = move_toward(current_rotation, 0.0, delta * 15.0) # DONT EVER USE THIS

	axle.rotation = current_rotation

func launch():
	print("Fire!")
	# Here is where you'd spawn your Rock at launch_point.global_position
	# and give it a velocity based on current_rotation
