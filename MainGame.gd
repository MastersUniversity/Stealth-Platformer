extends Node2D

@export var player = Node2D

var player_invisibility = [0,0]

var alarm_triggered : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_player_invisibility():
	return player_invisibility
	
func get_player_left_invisibility():
	return player_invisibility[0]
	
func get_player_right_invisibility():
	return player_invisibility[1]


func set_player_invisibility(left, right):
	player_invisibility = [left, right]
	
func set_player_left_invisibility(left):
	player_invisibility[0] = left
	
func set_player_right_invisibility(right):
	player_invisibility[1] = right
	
	
func is_alarm_triggered():
	return alarm_triggered
	
func set_alarm_triggered(state):
	alarm_triggered = state
