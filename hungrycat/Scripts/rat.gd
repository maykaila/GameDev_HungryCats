extends RigidBody2D

@export var max_hp: float = 100.0 
@export var velocity_damage_threshold: float = 150.0 
@export var damage_multiplier: float = 1.0
@export var score_value: int = 500

var current_hp: float
var can_take_damage: bool = false 
var is_invincible: bool = false

func _ready() -> void:
	# ONLY join the group if we aren't hidden inside the Section 2 container
	#if is_visible_in_tree():
		#add_to_group("rats")
	
	current_hp = max_hp
	contact_monitor = true
	max_contacts_reported = 3
	
	await get_tree().create_timer(1.5).timeout
	can_take_damage = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not can_take_damage: return

	for i in range(state.get_contact_count()):
		var collider_vel = state.get_contact_collider_velocity_at_position(i)
		var crash_speed = (collider_vel - linear_velocity).length()

		if crash_speed > velocity_damage_threshold:
			take_damage(crash_speed * damage_multiplier)

func take_damage(amount: float) -> void:
	if is_invincible: return
	current_hp -= amount
	is_invincible = true
	get_tree().create_timer(0.1).timeout.connect(func(): is_invincible = false)
	
	if current_hp <= 0:
		die()

func die() -> void:
	ScoreManager.add_score(score_value)
	AudioManager.play_rat_destroy()
	var remaining_rats = get_tree().get_nodes_in_group("rats").size()
	
	if remaining_rats <= 1:
		ScoreManager.trigger_level_complete(get_tree())

	queue_free()
