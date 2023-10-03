extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_collisions(body, old, new):
	body.set_collision_layer_value(new, true)
	body.set_collision_mask_value(new, true)
	body.set_collision_layer_value(old, false)
	body.set_collision_mask_value(old, false)
	if old < new:
		body.show_behind_parent = true
	else:
		body.show_behind_parent = false

func _on_interactor_right_interacted(body):
	change_collisions(body, 1, 3)
	MainGame.set_player_visibility(0, 1)
	body.global_position.x = $InteractorRight.global_position.x


func _on_interactor_right_disengaged(body):
	change_collisions(body, 3, 1)
	MainGame.set_player_visibility(1, 1)


func _on_interactor_left_interacted(body):
	change_collisions(body, 1, 3)
	MainGame.set_player_visibility(1, 0)
	body.global_position.x = $InteractorLeft.global_position.x


func _on_interactor_left_disengaged(body):
	change_collisions(body, 3, 1)
	MainGame.set_player_visibility(1, 1)
