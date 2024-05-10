extends Node3D
class_name PathActivator

@export var activation_distance: float = 1.0

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var player_controller := get_tree().get_first_node_in_group("player_controller") as PlayerController 

signal in_range

func _process(delta: float) -> void:
	var path := player_controller.path_follow.get_parent() as Path3D
	var point := path.curve.get_closest_point(global_position - path.global_position)
	var player_point := path.curve.get_closest_point(player_controller.global_position - path.global_position)
	var dif := player_point - point
	if dif.length() < activation_distance:
		in_range.emit()
		queue_free()
