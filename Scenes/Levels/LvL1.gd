extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MainGame.is_alarm_triggered():
		$Player/LevelAudioPlayer.stream_paused = true
		$Player/AlarmAudioPlayer.stream_paused = false
	else:
		$Player/LevelAudioPlayer.stream_paused = false
		$Player/AlarmAudioPlayer.stream_paused = true
