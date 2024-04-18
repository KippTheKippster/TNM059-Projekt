@tool
extends Node3D

@export var target: Node

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			set_notify_transform(true)
			if target != null:
				target.set_planet_scale(global_transform)
		NOTIFICATION_TRANSFORM_CHANGED:
			if target != null:
				target.set_planet_scale(global_transform)
