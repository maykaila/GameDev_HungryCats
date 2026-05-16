extends CanvasLayer # Or whatever your root node type is

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	# 1. Sync the buttons the moment the level loads
	sync_toggles()
	
	# 2. Tell Godot to listen for whenever this menu opens or closes
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	# 3. Every single time the popup becomes visible, check the audio again!
	if visible:
		sync_toggles()

func sync_toggles() -> void:
	# Check the global master audio state
	var is_music_muted = AudioServer.is_bus_mute(music_bus_index)
	var is_sfx_muted = AudioServer.is_bus_mute(sfx_bus_index)
	
	# Using the % symbol means Godot will instantly find it no matter where it is!
	%MusicToggle.set_pressed_no_signal(not is_music_muted)
	%SoundToggle.set_pressed_no_signal(not is_sfx_muted)
	
func _on_music_toggle_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(music_bus_index, not toggled_on)
	AudioManager.play_click()

func _on_sound_toggle_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus_index, not toggled_on)
	if toggled_on:
		AudioManager.play_click()

func _on_close_button_pressed() -> void:
	AudioManager.play_click()
	hide()
