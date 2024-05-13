extends Node3D
class_name PathActivator

signal in_range

@export var activation_distance: float = 1.0

@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var player_controller := get_tree().get_first_node_in_group("player_controller") as PlayerController 
@onready var path := player_controller.path_follow.get_parent() as Path3D
@onready var point := path.curve.get_closest_point(global_position - path.global_position)

func _process(delta: float) -> void:
	var player_point := player_controller.player_point 
	var dif := player_point - point
	if dif.length() < activation_distance:
		in_range.emit()
		queue_free()
