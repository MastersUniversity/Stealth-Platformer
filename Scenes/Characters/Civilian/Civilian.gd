extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pursuing : bool = false
var faceLeft = true
@onready var player: Node2D = get_node("/root/LvL1/Player")

#Navigation variables
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready():
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	call_deferred("agent_setup")
	
func agent_setup():
	await get_tree().physics_frame
	"""Replace with patrol NavTargets instead
	set_navigation_target(player.get_global_location())
	"""
	
func set_navigation_target(target_position: Vector2):
	nav_agent.target_position = target_position


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	"""if pursuing:
		if faceLeft:
			velocity.x = move_toward(velocity.x, -SPEED, 1)
		else:
			velocity.x = move_toward(velocity.x, SPEED, 1)
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
	"""
	var current_position:= global_position as Vector2
	var next_path_position := nav_agent.get_next_path_position() as Vector2
	
	var new_velocity:= next_path_position - current_position
	new_velocity = new_velocity.normalized()
	new_velocity *= SPEED
	
	velocity = new_velocity
	move_and_slide()


func set_pursuit(state):
	pursuing = state

func _on_sound_listener_heard_sound(body):
	pursuing = true
	check_direction(body.get_global_location())
	set_navigation_target(body.get_global_location())
	
		
		
		
func check_direction(soundLocation):
	if soundLocation < get_global_position() and faceLeft == false:
		scale.x *= -1
		faceLeft = true
	elif soundLocation > get_global_position() and faceLeft == true:
		scale.x *= -1
		faceLeft = false
		
	
