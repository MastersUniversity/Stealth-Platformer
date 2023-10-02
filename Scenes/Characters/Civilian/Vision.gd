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
#Check pladyer's stealth, depending on the whether enemy is on the left or right of player. 
func _on_body_entered(body):
	player = get_parent().player
	
	if body == player:
		var rightVisible = MainGame.get_player_right_visibility()
		var leftVisible = MainGame.get_player_left_visibility()
		
		if body.get_global_position() < get_parent().get_global_position():
			if rightVisible > minVisibility:
				MainGame.set_alarm_triggered(true)
				get_parent().set_pursuit(true)
				get_parent().nav_target = player
				
				#Set the enemy's target to pursue the player
				get_parent().set_navigation_target(body.get_global_position())
				#Starts the timer to update the player's position for enemies every "Wait time" interval
				get_parent().get_node("Timer").start()
				
				print("ALARM TRIGGERED")
		elif leftVisible > minVisibility:
				MainGame.set_alarm_triggered(true)
				get_parent().set_pursuit(true)
				get_parent().nav_target = player
				get_parent().set_navigation_target(body.get_global_position())
				get_parent().get_node("Timer").start()
				
				print("ALARM TRIGGERED")
		else:
			return
			
			
