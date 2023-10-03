extends CharacterBody2D


var SPEED = 125
const JUMP_VELOCITY = -400.0
var acceleration = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pursuing : bool = false
var faceLeft = true
@onready var player: Node2D = get_node("/root/LvL1/Player")

#Navigation variables
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
var nav_target

func _ready():
	nav_agent.path_desired_distance = 10
	nav_agent.target_desired_distance = 10
	
	call_deferred("agent_setup")
	
func agent_setup():
	await get_tree().physics_frame
	"""Replace with patrol NavTargets instead
	set_navigation_target(player.get_global_location())
	"""
	
func set_navigation_target(target_position: Vector2):
	nav_agent.target_position = target_position


func _physics_process(delta):
	
	var current_position:= global_position as Vector2
	var next_path_position := nav_agent.get_next_path_position() as Vector2
	
	var new_velocity:= next_path_position - current_position
	new_velocity = new_velocity.normalized()
	new_velocity *= SPEED
	
	#velocity = velocity.lerp(new_velocity, acceleration * delta)
	velocity = new_velocity
	
	#Applying gravity as last step
	"""if not is_on_floor():
		velocity.y += gravity * delta
		"""
	move_and_slide()

	

	#create two raycasts --> one pointing downward and one pointing toward civilian facing
	#if patrol: if frontward raycast detects object in front of it OR downward raycast STOPS detecting object, turn around and go the other way
	#if pursuit: 




	#turn on collision layer and collision mask level 3 when alarm is triggered (BACKBURNER)

func set_pursuit(state):
	pursuing = state

#Reconfigures enemy orientation and sets target to object that generates sound and reaches enemy's ear.
func _on_sound_listener_heard_sound(body):
	#Sound will not distract enemy if alarm has been triggered (enemy is actively pursuing player instead)
	if !MainGame.alarm_triggered:
		pursuing = true
		check_direction(body.get_global_location())
		nav_target = body
		set_navigation_target(body.get_global_location())
		

func check_direction(targetLocation):
	if targetLocation < get_global_position() and faceLeft == false:
		scale.x *= -1
		faceLeft = true
	elif targetLocation > get_global_position() and faceLeft == true:
		scale.x *= -1
		faceLeft = false
		
#Timeout function is used to update target's position for enemy, whether it's moving or not
#
func _on_timer_timeout():
	check_direction(nav_target.get_global_position())
	set_navigation_target(nav_target.get_global_position())
