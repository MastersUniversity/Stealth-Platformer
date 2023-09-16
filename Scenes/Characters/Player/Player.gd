extends CharacterBody2D


const SPEED = 100.0
const WALK_SOUND = 3.0
const CROUCH_SPEED = 50.0
const CROUCH_SOUND = 1.5
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed = SPEED
var current_sound = 0


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_key_pressed(KEY_S):
		current_speed = CROUCH_SPEED
		current_sound = CROUCH_SOUND
		$Sprite2D.scale.y = 0.5
		$WalkingColider.disabled = true
		$CrouchingCollider.disabled = false
		
	else:
		current_speed = SPEED
		current_sound = WALK_SOUND
		$Sprite2D.scale.y = 1
		$WalkingColider.disabled = false
		$CrouchingCollider.disabled = true
		
	# Handles making the sound based on what the player is doing
	if velocity.y < JUMP_VELOCITY * .9:
		current_sound = WALK_SOUND

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * current_speed, current_speed/10)
		$Sound.sound_radius = current_sound
		$Sound.set_global_location_vector(self.global_position)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Sound.sound_radius = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/30)
		$Sound.sound_radius = 0
	
	
	move_and_slide()
