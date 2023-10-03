extends CharacterBody2D


var SPEED = 125
const JUMP_VELOCITY = -400.0
var acceleration = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pursuing : bool = false
var faceLeft = true
@onready var player: Node2D = get_node("/root/LvL1/Player")


#Navigation variables
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
var nav_target
var spawn_point 

#Animator variable
@onready var animation_player = $AnimationPlayer

func _ready():
	spawn_point = global_position
	nav_agent.path_desired_distance = 20
	nav_agent.target_desired_distance = 20
	animation_player.play("Walking")
	call_deferred("agent_setup")
	
func agent_setup():
	await get_tree().physics_frame
	"""Replace with patrol NavTargets instead
	set_navigation_target(player.get_global_location())
	"""
	
func set_navigation_target(target_position: Vector2):
	nav_agent.target_position = target_position

func alarm_reaction(alarm):
	if alarm:
		pursuing = true
		nav_target = player
		if $Timer.time_left == 0: 
			$Timer.start() 
		else:
			$Timer.paused = false
	else:
		nav_target = spawn_point
		set_navigation_target(nav_target)
		$Timer.paused = true
		pursuing = false
	
func _physics_process(delta):
	#Listening for alarm if it has been triggered by another enemy
	alarm_reaction(MainGame.alarm_triggered)
	
	var current_position:= global_position as Vector2
	var next_path_position := nav_agent.get_next_path_position() as Vector2
	
	var new_velocity:= next_path_position - current_position
	new_velocity = new_velocity.normalized()
	new_velocity *= SPEED
	
	#velocity = velocity.lerp(new_velocity, acceleration * delta)
	if (velocity == new_velocity) and (animation_player.current_animation == "Walking"):
		animation_player.play("Idle")
	else:
		velocity = new_velocity
		animation_player.play("Walking")
	
	#Applying gravity as last step
	if not is_on_floor():
		velocity.y += gravity * (10*delta)
	
	move_and_slide()

	

	#create two raycasts --> one pointing downward and one pointing toward civilian facing
	#if patrol: if frontward raycast detects object in front of it OR downward raycast STOPS detecting object, turn around and go the other way
	#if pursuit: if frontward raycast detects object, enemy jumps. if downward raycast STOPS detecting object, do nothing.
	#doing nothing with downward raycast preserves positions of enemies that are on ledges --> prevents them 
	#from falling down and never getting back up
	




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
