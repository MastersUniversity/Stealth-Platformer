extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handles making the sound based on what the player is doing
	# (Could use refinement)
	if velocity.x != 0:
		$Sound.sound_radius = 3
		$Sound.set_global_location_vector(self.global_position)
	elif velocity.y < JUMP_VELOCITY * .9:
		$Sound.sound_radius = 3
	else:
		$Sound.sound_radius = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED/10)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/30)
	
	
	move_and_slide()
