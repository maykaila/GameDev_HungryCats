extends Node

@onready var sfx_click = $SfxClick
@onready var sfx_destroy = $SfxDestroy
@onready var sfx_rat_destroy: AudioStreamPlayer = $SfxRatDestroy

func play_click() -> void:
	sfx_click.play()

func play_destroy() -> void:
	# Because multiple blocks of wood might break at the exact same time, 
	# we duplicate the player so the sounds can overlap perfectly!
	var new_sound = sfx_destroy.duplicate()
	add_child(new_sound)
	new_sound.play()
	
	# Delete the temporary sound node as soon as the audio finishes
	new_sound.finished.connect(new_sound.queue_free)

func play_rat_destroy() -> void:
	var new_sound = sfx_rat_destroy.duplicate()
	add_child(new_sound)
	new_sound.play()
	new_sound.finished.connect(new_sound.queue_free)
