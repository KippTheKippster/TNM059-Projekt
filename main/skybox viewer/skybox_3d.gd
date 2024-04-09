extends Node3D

@export var game_viewport: Viewport
@export var camera: Camera3D

@export var speed_scale: float = 0.1 

func _process(delta: float) -> void:
	var game_camera = game_viewport.get_camera_3d()
	camera.global_rotation = game_camera.global_rotation
	camera.global_position = game_camera.global_position * speed_scale
	
