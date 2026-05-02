extends CanvasLayer # Or whatever your root node type is

# Get the specific ID numbers for our buses so Godot can find them instantly
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _on_music_toggle_toggled(toggled_on: bool) -> void:
	# toggled_on is TRUE when the switch is to the right (active)
	# We want to MUTE the bus if the switch is OFF (false)
	# So we set mute to the OPPOSITE of our toggle state
	AudioServer.set_bus_mute(music_bus_index, not toggled_on)

func _on_sound_toggle_toggled(toggled_on: bool) -> void:
	# Do the exact same thing for the SFX bus
	AudioServer.set_bus_mute(sfx_bus_index, not toggled_on)

func _on_close_button_pressed() -> void:
	# Assuming you already have this to close the menu!
	hide()
