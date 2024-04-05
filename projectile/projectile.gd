extends Node3D
class_name Projectile

@export var speed: float = 1

func _process(delta):
	position += basis * Vector3.FORWARD * speed * delta

func _on_remove_timer_timeout():
	queue_free()
