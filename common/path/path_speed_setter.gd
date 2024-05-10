extends PathActivator

@export var speed: float = 10

func _on_in_range() -> void:
	player_controller.path_speed = speed
