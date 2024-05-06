extends Node3D

@export_group("Music")
@export var play_on_ready := true
@export var music_stream: AudioStream 

func _ready() -> void:
	if play_on_ready:
		MusicPlayer.stream = music_stream
		MusicPlayer.play()
