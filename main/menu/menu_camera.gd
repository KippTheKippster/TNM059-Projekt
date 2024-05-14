extends Camera3D

@export var direction: Vector3 = Vector3.RIGHT

func _process(delta: float) -> void:
	rotation += direction * delta
