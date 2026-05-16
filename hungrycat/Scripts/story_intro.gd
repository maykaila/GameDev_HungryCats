extends Control

@export var comic_panels: Array[Texture2D]
@export var fade_duration: float = 1.0 
@export var read_time: float = 2.5     
@export var main_menu_scene: PackedScene 

@onready var comic_display = $ComicDisplay
@onready var bgm_player = $BGMPlayer
@onready var start_button = $StartScreen/StartButton
@onready var start_screen: TextureRect = %StartScreen

func _ready():
	comic_display.modulate.a = 0
	start_screen.modulate.a = 0
	start_button.pressed.connect(_on_start_button_pressed)
	
	# Ensure the volume starts at normal level (0 decibels)
	bgm_player.volume_db = 0.0 
	
	var start_fade_tween = create_tween()
	start_fade_tween.tween_property(start_screen, "modulate:a", 1.0, 1.5)

# This function runs exactly when the player clicks the button
func _on_start_button_pressed():
	AudioManager.play_click()
	# Hide the "Wanna play?" screen and the button
	start_screen.hide()
	
	# Start the music
	bgm_player.play()
	
	# Begin the comic panel sequence
	play_sequence()

func play_sequence():
	for panel in comic_panels:
		comic_display.texture = panel
		
		var fade_in_tween = create_tween()
		fade_in_tween.tween_property(comic_display, "modulate:a", 1.0, fade_duration)
		await fade_in_tween.finished 
		
		await get_tree().create_timer(read_time).timeout
		
		var fade_out_tween = create_tween()
		fade_out_tween.tween_property(comic_display, "modulate:a", 0.0, fade_duration)
		await fade_out_tween.finished 
		
		await get_tree().create_timer(0.2).timeout 

	# --- NEW FADE OUT CODE STARTS HERE ---
	
	# Create a tween for the audio
	var audio_tween = create_tween()
	
	# Fade the volume down to -80 (silent) over 1.5 seconds
	audio_tween.tween_property(bgm_player, "volume_db", -80.0, 1.5)
	
	# Wait for the audio fade to finish completely
	await audio_tween.finished
	
	# --- NEW FADE OUT CODE ENDS HERE ---

	# Finally, change the scene
	if main_menu_scene != null:
		get_tree().change_scene_to_packed(main_menu_scene)
	else:
		print("Error: You forgot to assign the Main Menu Scene in the Inspector!")
