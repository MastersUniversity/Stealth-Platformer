class_name Interactor extends Area2D


signal interacted(body: Node2D)
signal disengaged(body: Node2D)

@export var interact_text = "F - Interact"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact(body):
	interacted.emit(body)


func disengage(body):
	disengaged.emit(body)


func get_interact_text():
	return interact_text
