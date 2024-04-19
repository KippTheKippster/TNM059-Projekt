extends Node3D

@onready var player: Player = $Player
@onready var camera_shaker: CameraShaker = $CameraShaker

@export var path_follow: PathFollow3D
@export var speed: float = 5.0
@onready var boundaries: AnimatableBody3D = $Boundaries

var prev_position: Vector3

func _process(delta: float):
	prev_position = global_position
	path_follow.progress += speed * delta
	player.path_velocity = global_position - prev_position

func _physics_process(_delta: float):
	boundaries.position = Vector3.ZERO
	boundaries.rotation = Vector3.ZERO

func _on_player_damaged() -> void:
	camera_shaker.shake(1)
