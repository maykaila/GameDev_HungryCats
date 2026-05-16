extends CPUParticles2D

func _ready():
	# Force the explosion to play the moment it enters the game
	emitting = true
	
	# When the particle finishes its lifetime, delete it!
	finished.connect(queue_free)
