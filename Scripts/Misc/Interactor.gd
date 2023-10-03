class_name Interactor extends Area2D


signal interacted(body: Node2D)
signal disengaged(body: Node2D)

var interacting = false

@export var interact_text = "F - Interact"
@export var disengage_text = "A/D - Leave"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact(body):
	interacting = true
	interacted.emit(body)


func disengage(body):
	interacting = false
	disengaged.emit(body)


func get_interact_text():
	return interact_text


func get_disengage_text():
	return disengage_text


func get_interacting():
	return interacting
