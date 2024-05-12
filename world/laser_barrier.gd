@tool
extends Node3D

@onready var laser: Laser = $Laser
@onready var path_activator: PathActivator = $PathActivator

@export var max_height: float = 2: 
	get: return max_height
	set(value):
		max_height = value
		if Engine.is_editor_hint() and is_node_ready():
			laser.height = max_height

@export var extend_time: float = 1

@export var activation_distance: float = 1

func _ready() -> void:
	path_activator.activation_distance = activation_distance
	if Engine.is_editor_hint(): 
		max_height = max_height
	else:
		laser.height = 0

func _on_path_activator_in_range() -> void:
	var tween := create_tween()
	tween.tween_property(laser, "height", max_height, extend_time)
