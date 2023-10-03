extends RigidBody2D

# The starting velocity of the rock
@export var launch = Vector2(0,0)

# If the rock will despawn
var despawn_next = false


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = launch


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Stop despawn process if the rock has started to move
	if int(linear_velocity.x) != 0 or int(linear_velocity.y) != 0:
		despawn_next = false
	
	# If the rock should despawn, despawn it
	if despawn_next:
		self.queue_free()
	
	# If the rock stops moving, wait 5 seconds and then prepare it for despawning
	if int(linear_velocity.x) == 0 and int(linear_velocity.y) == 0:
		await get_tree().create_timer(5.0).timeout
		despawn_next = true




func _on_body_entered(body):
	
	# Make a sound when the rock hits something, then stop the sound
	$Sound.set_global_location_vector(self.global_position)
	$Sound.sound_radius = 20
	await get_tree().create_timer(0.25).timeout
	$Sound.sound_radius = 0
