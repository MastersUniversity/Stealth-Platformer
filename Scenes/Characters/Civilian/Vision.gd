extends Node

@export var player = Node2D
var minStealth

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "FarSight":
		minStealth = 50
	elif self.name == "NearSight":
		minStealth = 100


#From using the _on_body_entered, which sends a signal to the node itself, detect if node is player
#if node is player, first check enemy's position in relation to player's position. 
#Check player's stealth, depending on the whether enemy is on the left or right of player. 
func _on_body_entered(body):
	print("Body detected")
	if body == player:
		var rightVisible = MainGame.get_player_right_invisibility()
		var leftVisible = MainGame.get_player_left_invisibility()

		if body.get_global_position() < get_parent().get_global_position():
			if rightVisible > minStealth:
				MainGame.set_alarm_triggered(true)
				get_parent().set_pursuit(true)
		else:
			if leftVisible > minStealth:
				MainGame.set_alarm_triggered(true)
				get_parent().set_pursuit(true)
