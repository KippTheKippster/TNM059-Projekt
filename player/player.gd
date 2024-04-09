extends CharacterBody3D
class_name Player

@onready var rotation_container: Node3D = $RotationContainer
@onready var ship_animation_player = %ShipAnimationPlayer
@onready var health_area: HealthArea = $RotationContainer/HealthArea
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var shoot_marker_3d: Marker3D = $RotationContainer/ShootMarker3D

const BULLET = preload("res://player/player_bullet.tscn")

@export var speed: float = 6.0
@export var acceleration: float = 10.0
@export var deceleration: float = 8.0
@export var max_rotation_degrees: Vector3 = Vector3(90, 90, 45): 
	get:
		return max_rotation_degrees
	set(value):
		max_rotation_degrees = value
		max_rotation = Vector3(deg_to_rad(value.x), deg_to_rad(value.y), deg_to_rad(value.z))

var max_rotation: Vector3
@export var rotation_acceleration: float = 9.0
@export var rotation_deceleration: float = 5.0

var path_velocity: Vector3
var true_velocity: Vector3

func _ready() -> void:
	max_rotation_degrees = max_rotation_degrees

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and shoot_cooldown_timer.is_stopped():
		var bullet = BULLET.instantiate()
		add_sibling(bullet)
		bullet.global_position = shoot_marker_3d.global_position
		bullet.global_rotation = shoot_marker_3d.global_rotation
		shoot_cooldown_timer.start()
	
	if Input.is_action_just_pressed("lean_left"):
		ship_animation_player.play("spin_left")
	elif Input.is_action_just_pressed("lean_right"):
		ship_animation_player.play("spin_right")

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "down", "up")
	var velocity_2d: Vector2 = Vector2(velocity.x, velocity.y)
	var weight: float = acceleration
	if input_dir == Vector2.ZERO:
		weight = deceleration
		
	velocity_2d = velocity_2d.move_toward(input_dir * speed, weight * delta)
	
	velocity = Vector3(velocity_2d.x , velocity_2d.y, 0)
	true_velocity = velocity + path_velocity
	
	#print(max_rotation)
	#var rotation_2d = Vector2(rotation_container.rotation.x, rotation_container.rotation.y)
	var rotaion_target = Vector3(
		max_rotation.x * input_dir.y,
		-max_rotation.y * input_dir.x,
		-max_rotation.z * input_dir.x
		)
	var horizontal_rotation_target = Vector2(
		rotaion_target.y,
		rotaion_target.z
	)
		
	var rotation_weight: Vector2 = Vector2.ONE * rotation_acceleration
	if input_dir.x == 0:
		rotation_weight.x = rotation_deceleration
	if input_dir.y == 0:
		rotation_weight.y = rotation_deceleration
	
	#Horizontal Rotation
	var horizontal_rotation: Vector2 = Vector2(rotation_container.rotation.y, rotation_container.rotation.z) 
	horizontal_rotation = horizontal_rotation.lerp(horizontal_rotation_target, rotation_weight.x * delta)
	rotation_container.rotation.y = horizontal_rotation.x
	rotation_container.rotation.z = horizontal_rotation.y
	
	#Vertical Rotation
	rotation_container.rotation.x = lerp(rotation_container.rotation.x, rotaion_target.x, rotation_weight.y * delta)
	
	move_and_slide()
