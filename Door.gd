extends Area2D

@export var destination = "res://Scenes/Levels/LvL1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactor_interacted(body):
	get_tree().change_scene_to_file(destination)
