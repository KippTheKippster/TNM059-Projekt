extends Camera3D

@export var player: Player
@export var max_rotation_degrees: Vector3 = Vector3(90, 90, 45): 
	get:
		return max_rotation_degrees
	set(value):
		max_rotation_degrees = value
		max_rotation = Vector3(deg_to_rad(value.x), deg_to_rad(value.y), deg_to_rad(value.z))

var max_rotation: Vector3
@export var rotation_weight: float = 1.0
#@export var rotation_deceleration: float = 5.0


func _process(delta: float):
	var target: Vector3 = max_rotation * Vector3(
		player.velocity.y / player.speed,
		-player.velocity.x / player.speed,
		-player.velocity.x / player.speed
	)
	
	rotation = rotation.lerp(target, rotation_weight * delta)
