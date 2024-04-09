extends Node3D

@onready var player: Player = $Player
@onready var camera_shaker: CameraShaker = $CameraShaker

@export var velocity: Vector3 = Vector3.ZERO
@onready var boundaries: AnimatableBody3D = $Boundaries

func _process(delta: float):
	position += basis * velocity * delta #FIXME FIX ROTATION (If rotated it doesn't behave as expected)
	player.path_velocity = basis * velocity

func _physics_process(delta: float):
	boundaries.position = Vector3.ZERO
	boundaries.constant_linear_velocity = velocity

func _on_player_damaged() -> void:
	camera_shaker.shake(1)
