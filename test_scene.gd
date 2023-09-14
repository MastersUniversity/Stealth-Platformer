extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sound_listener_heard_sound(area):
	print(area.get_script() == Sound)
	#area.set_global_location_vector($Player.position)
	print(area.get_global_location())
