extends PathActivator


func _on_in_range() -> void:
	MusicPlayer.fade_to_song(null, 4.0)
