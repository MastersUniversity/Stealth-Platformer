extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pursuing = false
var faceLeft = true
@export var player = Node2D

func _physics_process(delta):
	
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if pursuing:
		if faceLeft:
			velocity.x = move_toward(velocity.x, -SPEED, 1)
		else:
			velocity.x = move_toward(velocity.x, SPEED, 1)
	else:
		velocity.x = move_toward(velocity.x, 0, 2)
	
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body == player:
		pursuing = true


func _on_area_2d_body_exited(body):
	if body == player:
		pursuing = false


func _on_sound_listener_heard_sound(body):
	pursuing = true
	check_direction(body.get_global_location())
		
func check_direction(soundLocation):
	if soundLocation < get_global_position() and faceLeft == false:
		scale.x *= -1
		faceLeft = true
	elif soundLocation > get_global_position() and faceLeft == true:
		scale.x *= -1
		faceLeft = false
		
	
