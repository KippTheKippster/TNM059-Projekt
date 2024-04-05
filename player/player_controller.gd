extends Node3D

@export var velocity: Vector3

func _process(delta):
	position += basis * velocity * delta #TODO FIX ROTATION
