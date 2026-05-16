extends AudioStreamPlayer

# We call this function whenever a scene wants to make sure music is playing
func play_music():
	if not playing:
		play()

func stop_music():
	stop()
