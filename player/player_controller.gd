extends Node3D

@onready var player: Player = $Player

@export var velocity: Vector3 = Vector3.ZERO
@onready var boundaries = $Boundaries

func _process(delta):
	position += basis * velocity * delta #TODO FIX ROTATION
	player.path_velocity = basis * velocity

func _physics_process(delta):
	boundaries.position = Vector3.ZERO
	boundaries.constant_linear_velocity = velocity
