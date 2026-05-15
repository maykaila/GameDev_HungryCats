extends RigidBody2D

# We are now balancing based on SPEED, not pressure!
@export var max_hp: float = 100.0 
@export var velocity_damage_threshold: float = 150.0 
@export var damage_multiplier: float = 1.0
@export var score_value: int = 500

var current_hp: float
var can_take_damage: bool = false 
var is_invincible: bool = false

func _ready() -> void:
	# Add this rat to a group so we can count them later for level completion
	add_to_group("rats")
	
	current_hp = max_hp
	contact_monitor = true
	max_contacts_reported = 3
	
	# Wait for 1.5 seconds to let the physics settle, then turn on vulnerability
	await get_tree().create_timer(1.5).timeout
	can_take_damage = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Don't calculate damage if we are in the grace period
	if not can_take_damage:
		return

	for i in range(state.get_contact_count()):
		# Find out how fast the objects crashed into each other
		var collider_vel = state.get_contact_collider_velocity_at_position(i)
		var crash_speed = (collider_vel - linear_velocity).length()

		# If the crash speed is higher than our threshold, take damage!
		if crash_speed > velocity_damage_threshold:
			var damage = crash_speed * damage_multiplier
			take_damage(damage)

func take_damage(amount: float) -> void:
	# If we just got hit, ignore the damage!
	if is_invincible:
		return
		
	current_hp -= amount
	
	# Turn on the invincibility shield for 0.1 seconds so we don't take multi-hits
	is_invincible = true
	get_tree().create_timer(0.1).timeout.connect(func(): is_invincible = false)
	
	if current_hp <= 0:
		die()

func die() -> void:
	ScoreManager.add_score(score_value)
	
	# Check how many rats are left in the entire game
	var remaining_rats = get_tree().get_nodes_in_group("rats").size()
	
	# If the size is 1 or less, this is the last rat!
	if remaining_rats <= 1:
		ScoreManager.trigger_level_complete(get_tree())
	
	# Remove the rat from the game
	queue_free()
