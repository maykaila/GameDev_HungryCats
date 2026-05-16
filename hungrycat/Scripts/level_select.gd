extends Control

@onready var grid = $GridContainer

func _ready():
	update_level_buttons()

func update_level_buttons():
	var buttons = grid.get_children()
	
	for i in range(buttons.size()):
		var button = buttons[i]
		# If the button index (0, 1, 2...) is less than unlocked_levels (1, 2, 3...)
		if i < GameManager.unlocked_levels:
			button.disabled = false
			button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			button.disabled = true
			button.mouse_default_cursor_shape = Control.CURSOR_ARROW

# Update your button presses to use the GameManager indices
func _on_level_1_pressed():
	GameManager.load_level(0)

func _on_level_2_pressed():
	GameManager.load_level(1)

func _on_level_3_pressed():
	GameManager.load_level(2)

func _on_level_4_pressed():
	GameManager.load_level(3)

func _on_level_5_pressed():
	GameManager.load_level(4)

func _on_level_6_pressed():
	GameManager.load_level(5)
