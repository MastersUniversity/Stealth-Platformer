class_name Sound extends Area2D

# Store the radius of the collider
@export var sound_radius = 0.0

# Store the position as relates to the overall scene
var global_location = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Resizes the collider to be the correct size
	$CollisionShape2D.scale = Vector2(sound_radius, sound_radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Resizes the collider to be the correct size
	$CollisionShape2D.scale = Vector2(sound_radius, sound_radius)

# Get the global location
func get_global_location():
	return global_location

# Set the global location to x and y
func set_global_location(x, y):
	global_location = Vector2(x,y)

# Set the global location to a vector
func set_global_location_vector(loc):
	global_location = loc
