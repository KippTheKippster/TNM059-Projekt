extends Node3D

@export var speed: float

func _process(delta):
	position += basis * Vector3.FORWARD * speed * delta

func _on_timer_timeout():
	queue_free()
