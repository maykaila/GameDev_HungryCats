extends AudioStreamPlayer2D

# We call this function whenever a scene wants to make sure music is playing
func play_music():
	# If the music is ALREADY playing, do nothing. 
	# If it's not playing, start it.
	if not playing:
		play()

# We can call this if we ever need the music to stop (like a boss fight or ending)
func stop_music():
	stop()
