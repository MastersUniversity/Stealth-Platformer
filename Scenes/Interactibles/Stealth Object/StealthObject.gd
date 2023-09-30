extends Area2D

@export var new_stealth = [0.5,0.5]
var old_visibility

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.get_parent().get_script() == Player:
		old_visibility = MainGame.get_player_visibility()
		MainGame.set_player_visibility(new_stealth[0], new_stealth[1])
		print("stealthy")
		print(MainGame.get_player_visibility())


