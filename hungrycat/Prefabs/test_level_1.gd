# Example logic for level.gd
extends Node2D

@export var cat_prefab: PackedScene # Drag cat.tscn into this slot in Inspector

func _input(event):
	# Just for testing: Press 'R' to spawn a new cat at the start
	if event.is_action_pressed("ui_focus_next"): # Usually Tab or custom key
		var new_cat = cat_prefab.instantiate()
		new_cat.position = Vector2(0, 400) # Adjust to your start line
		add_child(new_cat)
