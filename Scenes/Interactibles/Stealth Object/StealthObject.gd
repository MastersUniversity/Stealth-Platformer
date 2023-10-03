extends Area2D

var old_visibility

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.get_parent().get_script() == Player:
		area.get_parent().stealth_objects += 1


func _on_area_exited(area):
	if area.get_parent().get_script() == Player:
		area.get_parent().stealth_objects -= 1
