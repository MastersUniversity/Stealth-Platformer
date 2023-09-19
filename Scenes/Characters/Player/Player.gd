extends CharacterBody2D

# Constants for player movement
const SPEED = 100.0
const WALK_SOUND = 4.0
const CROUCH_SPEED = 50.0
const CROUCH_SOUND = 2.0
const JUMP_VELOCITY = -300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_speed = SPEED
var current_sound = 0
var throwing = false

@onready var leg_animations = $LegAnimationPlayer
@onready var torso_animations = $TorsoAnimationPlayer

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
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
		mouse_location.x = clamp(mouse_location.x, -100, 100)
		mouse_location.y = clamp(mouse_location.y, -100, 100)
		throwing = true
		torso_animations.play("Throw")
		await get_tree().create_timer(0.2).timeout
		var rock = preload("res://Scenes/Items/Rock/rock.tscn").instantiate()
		rock.position = self.global_position + Vector2(0,-10)
		rock.launch = Vector2(mouse_location.x*5 + velocity.x, mouse_location.y*5 + velocity.y)
		self.get_parent().add_child(rock)
		await get_tree().create_timer(0.1).timeout
		throwing = false
	
	#Makes the player move around
	move_and_slide()


func crouch():
	current_speed = CROUCH_SPEED
	current_sound = CROUCH_SOUND
	$Sprite2D.scale.y = 0.5
	$WalkingColider.disabled = true
	$CrouchingCollider.disabled = false


func stand_up():
	current_speed = SPEED
	current_sound = WALK_SOUND
	$Sprite2D.scale.y = 1
	$WalkingColider.disabled = false
	$CrouchingCollider.disabled = true

func walk(direction):
	if direction:
		leg_animations.play("Walk")
		if not throwing:
			torso_animations.play("Walk")
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
		leg_animations.play("Idle")
		if not throwing:
			torso_animations.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Sound.sound_radius = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/30)
		$Sound.sound_radius = 0
