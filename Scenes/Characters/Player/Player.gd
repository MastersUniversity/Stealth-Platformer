extends CharacterBody2D

# Constants for player movement
const SPEED = 100.0
const WALK_SOUND = 4.0
const CROUCH_SPEED = 35.0
const CROUCH_SOUND = 2.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed = SPEED
var current_sound = 0
var throwing = false
var crouching = false
var jumping = false

@onready var leg_animations = $LegAnimationPlayer
@onready var torso_animations = $TorsoAnimationPlayer

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		jumping = true

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		leg_animations.play("Jump")
		torso_animations.play("Jump")
		await get_tree().create_timer(0.05).timeout
		velocity.y = JUMP_VELOCITY
	
	# Handle whether or not the player is crouching
	if Input.is_action_pressed("Crouch"):
		crouch()
		
	else:
		stand_up()
		
	# Handles making the sound based on what the player is doing
	if velocity.y < JUMP_VELOCITY * .9:
		current_sound = WALK_SOUND

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move_Left", "Move_Right")
	
	# Make the player walk
	walk(direction)
	
	if Input.is_action_just_released("Throw"):
		var mouse_location = get_local_mouse_position()
		var magnitude = sqrt(mouse_location.x**2 + mouse_location.y**2)
		var clamped_x = mouse_location.x/magnitude * min(magnitude, 60)
		var clamped_y = mouse_location.y/magnitude * min(magnitude, 60)
		throwing = true
		torso_animations.play("Throw")
		await get_tree().create_timer(0.2).timeout
		var rock = preload("res://Scenes/Items/Rock/rock.tscn").instantiate()
		rock.position = self.global_position + Vector2(0,-10)
		rock.launch = Vector2(clamped_x*7 + velocity.x, clamped_y*7 + velocity.y)
		self.get_parent().add_child(rock)
		await get_tree().create_timer(0.1).timeout
		throwing = false
		
	handle_animations()
	
	#Makes the player move around
	move_and_slide()


func crouch():
	crouching = true
	current_speed = CROUCH_SPEED
	current_sound = CROUCH_SOUND
	$Sprite2D.scale.y = 0.5
	$WalkingColider.disabled = true
	$CrouchingCollider.disabled = false


func stand_up():
	crouching = false
	current_speed = SPEED
	current_sound = WALK_SOUND
	$Sprite2D.scale.y = 1
	$WalkingColider.disabled = false
	$CrouchingCollider.disabled = true

func walk(direction):
	if direction:
		if direction < 0:
			$PlayerLegs.flip_h = true
			$PlayerTorso.flip_h = true
		else:
			$PlayerLegs.flip_h = false
			$PlayerTorso.flip_h = false
		velocity.x = move_toward(velocity.x, direction * current_speed, current_speed/10)
		$Sound.set_global_location_vector(self.global_position)
		$Sound.sound_radius = current_sound
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Sound.sound_radius = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/30)
		$Sound.sound_radius = 0

func handle_animations():
	if not is_on_floor():
		if velocity.y > 0:
			leg_animations.play("Fall")
			if not throwing:
				torso_animations.play("Fall")
	elif jumping:
		leg_animations.play("Land")
		torso_animations.play("Land")
		jumping = false
		await get_tree().create_timer(0.3).timeout
	elif int(velocity.x) != 0:
		if crouching:
			leg_animations.play("Sneak")
			torso_animations.play("Sneak")
		else:
			leg_animations.play("Walk")
			if not throwing:
				torso_animations.play("Walk")
	else:
		if crouching:
			leg_animations.play("Crouch")
			torso_animations.play("Crouch")
		else:
			leg_animations.play("Idle")
			if not throwing:
				torso_animations.play("Idle")
