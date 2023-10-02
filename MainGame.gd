extends Node2D

@export var player = Node2D

var player_visibility = [51, 51]

var alarm_triggered = false


func get_player_visibility():
	return player_visibility
	
func get_player_left_visibility():
	return player_visibility[0]
	
func get_player_right_visibility():
	return player_visibility[1]


func set_player_visibility(left, right):
	player_visibility = [left, right]
	
func set_player_left_visibility(left):
	player_visibility[0] = left
	
func set_player_right_visibility(right):
	player_visibility[1] = right
	
	
func is_alarm_triggered():
	return alarm_triggered
	
func set_alarm_triggered(state):
	alarm_triggered = state
