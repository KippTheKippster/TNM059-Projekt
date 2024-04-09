extends Node3D
class_name CameraShaker

@export var trauma_reduction_rate: float = 1.0
@export var max_trauma: float = 2.0
@export var max_rotation: Vector3 = Vector3(10, 10, 5)
@export var noise_speed: float = 50.0
@export var noise: FastNoiseLite

var trauma: float = 0
var time: float = 0

func _process(delta: float) -> void:
	time += delta
	trauma = move_toward(trauma, 0, trauma_reduction_rate * delta)
	rotation_degrees = get_noise_as_vector3() * max_rotation * pow(trauma, 2)

func get_noise_as_vector3() -> Vector3:
	var noise_vector: Vector3
	noise.seed = 1
	noise_vector.x = noise.get_noise_1d(noise_speed * time)
	noise.seed = 2
	noise_vector.y = noise.get_noise_1d(noise_speed * time)
	noise.seed = 3
	noise_vector.z = noise.get_noise_1d(noise_speed * time)
	return noise_vector

func shake(amount: float) -> void:
	trauma += amount
	trauma = min(trauma, max_trauma)
