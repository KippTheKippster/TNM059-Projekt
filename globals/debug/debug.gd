extends Node

@export var enabled: bool = false

func _process(_delta: float) -> void:
	if not enabled: return
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("fast_forward"):
		Engine.time_scale = 3.0
	elif Input.is_action_just_released("fast_forward"):
		Engine.time_scale = 1.0
	
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
