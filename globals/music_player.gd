extends AudioStreamPlayer

func fade_to_song(music: AudioStream, time: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(self, "volume_db", -80, time)
	await tween.finished
	stream = music
	tween = create_tween()
	tween.tween_property(self, "volume_db", 0, time)
	
