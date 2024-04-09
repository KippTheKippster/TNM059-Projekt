extends Node

@export var enabled: bool = false

func _process(_delta: float) -> void:
	if not enabled: return
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
