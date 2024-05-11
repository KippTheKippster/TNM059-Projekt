@tool
extends Node3D

@export var rotation_speed: float = 0.0
@export var rotation_direction: Vector3 = Vector3.ONE:
	get: return rotation_direction
	set(value): rotation_direction = value.normalized()
	
@export var randomize_direction: bool:
	get: return false
	set(value): 
		if value:
			rotation_direction = Vector3(randf(), randf(), randf())

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	rotation += rotation_direction * rotation_speed* delta

