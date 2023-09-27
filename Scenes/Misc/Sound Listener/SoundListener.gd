extends Node

# A signal that is sent when a sound is first heard
signal heard_sound

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_node("Civilian"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called when the listener 
func _on_area_2d_area_entered(area):
	
	# Make sure area is a sound
	if area.get_script() == Sound:
		
		# Make sure the area is making any sound
		if area.sound_radius != 0:
			
			# Send the sound as a signal
			heard_sound.emit(area)
