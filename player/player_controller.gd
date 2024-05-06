extends Node3D
class_name PlayerController

@onready var player: Player = $Player
@onready var camera_shaker: CameraShaker = $CameraShaker
@onready var player_camera: Camera3D = $CameraShaker/PlayerCamera
@onready var speed_lines_particles: GPUParticles3D = %SpeedLinesParticles

@export var path_follow: PathFollow3D
@export var path_speed: float = 5.0
@onready var boundaries: AnimatableBody3D = $Boundaries

@onready var initial_fov = player_camera.fov

var fov_scale: float = 1.0
@export var boost_fov_scale: float = 1.1
@export var brake_fov_scale: float = 0.9

var prev_position: Vector3

func _process(delta: float):
	path_follow.progress += path_speed * player.path_speed_scale * delta
	player.path_velocity = (global_position - prev_position) / delta
	prev_position = global_position
	
	if player.boost.active:
		fov_scale = boost_fov_scale
		camera_shaker.trauma = max(0.4, camera_shaker.trauma)
	elif player.brake.active:
		fov_scale = brake_fov_scale
	else:
		fov_scale = 1.0
		
	speed_lines_particles.emitting = player.boost.active
	#speed_lines_particles.visible = player.boost.active
	
	player_camera.fov = lerp(player_camera.fov, initial_fov * fov_scale, 5 * delta)

func _physics_process(_delta: float):
	boundaries.position = Vector3.ZERO
	boundaries.rotation = Vector3.ZERO

func _on_player_damaged() -> void:
	camera_shaker.shake(1)
