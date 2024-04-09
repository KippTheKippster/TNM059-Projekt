extends Node3D

@onready var animation_player = $AnimationPlayer

func explode() -> void:
	reparent(get_parent().get_parent()) #FIXME Make not as ugly?
	animation_player.play("explode")
