class_name Player extends CharacterBody2D

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

var stealth_objects = 0
var interactables = []

@onready var torso_animations = $TorsoAnimationPlayer

func _ready():
	$LegAnimationTree.active = true

func _physics_process(delta):
	
	if $GameOverArea.collision_layer != collision_layer:
		$GameOverArea.collision_layer = collision_layer
		$GameOverArea.collision_mask = collision_mask
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		torso_animations.play("Jump")
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
		$TorsoAnimationTree.set("parameters/Throwing/transition_request", "throw")
		torso_animations.play("Throw")
		await get_tree().create_timer(0.2).timeout
		var rock = preload("res://Scenes/Items/Rock/rock.tscn").instantiate()
		rock.position = self.global_position + Vector2(0,-10)
		rock.launch = Vector2(clamped_x*7 + velocity.x, clamped_y*7 + velocity.y)
		self.get_parent().add_child(rock)
		await get_tree().create_timer(0.1).timeout
		$TorsoAnimationTree.set("parameters/Throwing/transition_request", "no")
	

	handle_animations()
	
	if Input.is_action_just_pressed("Interact"):
		interact()
				
	if len(interactables) != 0:
		$Label.show()
		var nearest = get_nearest_interactable()
		if nearest.get_interacting():
			$Label.text = nearest.get_disengage_text()
		else:
			$Label.text = nearest.get_interact_text()
	else:
		$Label.hide()
	
	if stealth_objects > 0:
		MainGame.set_player_visibility(50, 50)
	elif MainGame.get_player_visibility() == [50, 50]:
		MainGame.set_player_visibility(100,100)
	
	#Makes the player move around
	move_and_slide()


func get_nearest_interactable():
	var nearest = interactables[0]
	for i in interactables:
		if abs(nearest.global_position.x - global_position.x) > abs(i.global_position.x - global_position.x):
			nearest = i
	return nearest

func interact():
	if len(interactables) != 0:
		get_nearest_interactable().interact(self)
	

func disengage():
	if len(interactables) != 0:
		get_nearest_interactable().disengage(self)
	

func crouch():
	$LegAnimationTree.set("parameters/IHeight/transition_request", "crouch")
	$LegAnimationTree.set("parameters/WHeight/transition_request", "sneak")
	$TorsoAnimationTree.set("parameters/IHeight/transition_request", "crouch")
	$TorsoAnimationTree.set("parameters/WHeight/transition_request", "sneak")
	current_speed = CROUCH_SPEED
	current_sound = CROUCH_SOUND
	#$Sprite2D.scale.y = 0.5
	$WalkingColider.disabled = true
	$CrouchingCollider.disabled = false


func stand_up():
	$LegAnimationTree.set("parameters/IHeight/transition_request", "idle")
	$LegAnimationTree.set("parameters/WHeight/transition_request", "walk")
	$TorsoAnimationTree.set("parameters/IHeight/transition_request", "idle")
	$TorsoAnimationTree.set("parameters/WHeight/transition_request", "walk")
	current_speed = SPEED
	current_sound = WALK_SOUND
	#$Sprite2D.scale.y = 1
	$WalkingColider.disabled = false
	$CrouchingCollider.disabled = true
	

func walk(direction):
	if direction:
		disengage()
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
		$LegAnimationTree.set("parameters/InAir/transition_request", "air")
		$TorsoAnimationTree.set("parameters/InAir/transition_request", "air")
		if velocity.y < 0:
			$LegAnimationTree.set("parameters/YDirection/transition_request", "jump")
			$TorsoAnimationTree.set("parameters/YDirection/transition_request", "jump")
		else:
			$LegAnimationTree.set("parameters/YDirection/transition_request", "fall")
			$TorsoAnimationTree.set("parameters/YDirection/transition_request", "fall")
	elif $LegAnimationTree.get("parameters/InAir/current_state") == "air":
		$LegAnimationTree.set("parameters/InAir/transition_request", "ground")
		$LegAnimationTree.set("parameters/Landing/transition_request", "land")
		$TorsoAnimationTree.set("parameters/InAir/transition_request", "ground")
		$TorsoAnimationTree.set("parameters/Landing/transition_request", "land")
		await get_tree().create_timer(0.1).timeout
		$LegAnimationTree.set("parameters/Landing/transition_request", "grounded")
		$TorsoAnimationTree.set("parameters/Landing/transition_request", "grounded")
	else:
		if int(velocity.x) != 0:
			$LegAnimationTree.set("parameters/Movement/transition_request", "move")
			$TorsoAnimationTree.set("parameters/Movement/transition_request", "move")
		else:
			$LegAnimationTree.set("parameters/Movement/transition_request", "still")
			$TorsoAnimationTree.set("parameters/Movement/transition_request", "still")



func _on_game_over_area_body_entered(body):
	if body.is_in_group("Enemies"):
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")


func _on_game_over_area_area_entered(area):
	if area.get_script() == Interactor:
		interactables.append(area)


func _on_game_over_area_area_exited(area):
	if area.get_script() == Interactor:
		interactables.remove_at(interactables.find(area))
