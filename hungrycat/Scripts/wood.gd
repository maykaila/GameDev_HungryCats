extends RigidBody2D

# We are now balancing based on SPEED, not pressure!
@export var max_hp: float = 100.0 
@export var velocity_damage_threshold: float = 150.0 # How FAST something must hit to cause damage
@export var damage_multiplier: float = 0.5
@export var score_value: int = 500 

var current_hp: float
var can_take_damage: bool = false 
var is_invincible: bool = false

func _ready() -> void:
	current_hp = max_hp
	contact_monitor = true
	max_contacts_reported = 3
	
	await get_tree().create_timer(1.5).timeout
	can_take_damage = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not can_take_damage:
		return

	for i in range(state.get_contact_count()):
		# Find out how fast the two objects crashed into each other
		var collider_vel = state.get_contact_collider_velocity_at_position(i)
		var crash_speed = (collider_vel - linear_velocity).length()
		
		# THE FIX: If the crash speed is higher than our threshold, take damage!
		if crash_speed > velocity_damage_threshold:
			# Damage is now calculated strictly by how fast the impact was
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
	queue_free()
