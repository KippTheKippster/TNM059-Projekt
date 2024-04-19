extends CanvasLayer

signal transition_started
signal screen_covered
signal transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start(type: String = "Fade", pause: bool = true) -> void:
	transition_started.emit()
	animation_player.play(type)
	#if pause: #TODO Fix pause!
	#	PauseMaster.set_group_paused("Transition", true)
	
func change_scene_to_file(path: String, type: String = "Fade", pause: bool = true) -> void:
	start(type, pause)
	await screen_covered
	get_tree().change_scene_to_file(path)

func change_scene_to_packed(scene: PackedScene, type: String = "Fade", pause: bool = true) -> void:
	start(type, pause)
	await screen_covered
	get_tree().change_scene_to_packed(scene)

func _on_screen_covered() -> void:
	pass

#func _on_transition_finished() -> void:
	#PauseMaster.set_group_paused("Transition", false)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	transition_finished.emit()
