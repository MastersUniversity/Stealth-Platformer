extends Node

var player
var minVisibility

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if self.name == "FarSight":
		minVisibility = 50
	else:
		minVisibility = 0


#From using the _on_body_entered, which sends a signal to the node itself, detect if node is player
#if node is player, first check enemy's position in relation to player's position. 
#Check player's stealth, depending on the whether enemy is on the left or right of player. 
func _on_body_entered(body):
	player = get_parent().player
	if body == player:
		var rightVisible = MainGame.get_player_right_visibility()
		var leftVisible = MainGame.get_player_left_visibility()
		
		if body.get_global_position() < get_parent().get_global_position():
			print("Right side is being seen")
			if rightVisible > minVisibility:
				if !MainGame.alarm_triggered: MainGame.set_alarm_triggered(true)
				#Only increments number_of_alarmed_enemies once, instead of doublecounting when player enters
				#enemy's NearSight
				if self.name == "FarSight": MainGame.number_of_alarmed_enemies += 1
				get_parent().set_pursuit(true)
				
				
				#Set the enemy's target to pursue the player
				get_parent().nav_target = player
				#Starts the timer to update the player's position for enemies every "Wait time" interval
				get_parent().get_node("Timer").start()
				
				print("ALARM TRIGGERED")
		elif leftVisible > minVisibility:
			print("Left side is being seen")
			if !MainGame.alarm_triggered: MainGame.set_alarm_triggered(true) 
			if self.name == "FarSight": MainGame.number_of_alarmed_enemies += 1
			print(MainGame.number_of_alarmed_enemies)
			
			get_parent().set_pursuit(true)
			get_parent().nav_target = player
			get_parent().get_node("Timer").start()
				
			print("ALARM TRIGGERED")
					

func _on_body_exited(body):
	player = get_parent().player
	if body == player:
		if self.name == "FarSight": MainGame.number_of_alarmed_enemies -= 1
		print(MainGame.number_of_alarmed_enemies)
		if MainGame.number_of_alarmed_enemies == 0: MainGame.set_alarm_triggered(false)
		print(MainGame.alarm_triggered)
