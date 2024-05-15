extends Node3D

@export_group("Music")
@export var play_on_ready := true
@export var music_stream: AudioStream 
@export var volume_db: float 

func _ready() -> void:
	if play_on_ready:
		MusicPlayer.stream = music_stream
		MusicPlayer.volume_db = volume_db
		MusicPlayer.play()
