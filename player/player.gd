extends CharacterBody3D
class_name Player

signal damaged

@onready var rotation_container: Node3D = $RotationContainer
@onready var ship_animation_player = %ShipAnimationPlayer
@onready var health_area: HealthArea = $RotationContainer/HealthArea
@onready var shoot_marker_3d: Marker3D = $RotationContainer/ShootMarker3D
@onready var missle_target_ray_cast: MissileTargetRayCast = $RotationContainer/MissleTargetRayCast
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var state_chart: StateChart = $StateChart

const PLAYER_BULLET = preload("res://player/player_bullet.tscn")
const PLAYER_MISSILE = preload("res://player/player_missile.tscn")

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

var is_firing_missiles: bool
var active_missiles_count: int:
	get: return active_missiles_count
	set(value):
		active_missiles_count = value
		state_chart.set_expression_property("active_missiles", value)

func _ready() -> void:
	max_rotation_degrees = max_rotation_degrees
	active_missiles_count = active_missiles_count

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and shoot_cooldown_timer.is_stopped() and not is_firing_missiles:
		var bullet := PLAYER_BULLET.instantiate() as Projectile
		add_sibling(bullet)
		bullet.global_position = shoot_marker_3d.global_position
		bullet.global_rotation = shoot_marker_3d.global_rotation
		shoot_cooldown_timer.start()
	
	if Input.is_action_pressed("shoot"):
		state_chart.send_event("fire_press")
	else:
		state_chart.send_event("fire_release")
	
	if Input.is_action_just_pressed("lean_left"):
		state_chart.send_event("roll_left")
	elif Input.is_action_just_pressed("lean_right"):
		state_chart.send_event("roll_right")

func _physics_process(delta: float) -> void:
	var input_dir = Input.get_vector("left", "right", "down", "up")
	var velocity_2d: Vector2 = Vector2(velocity.x, velocity.y)
	var weight: float = acceleration
	if input_dir == Vector2.ZERO:
		weight = deceleration
		
	velocity_2d = velocity_2d.move_toward(input_dir * speed, weight * delta)
	
	velocity = Vector3(velocity_2d.x , velocity_2d.y, 0)
	true_velocity = velocity + path_velocity
	
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


func _on_health_area_damaged(hurt_area: HurtArea) -> void:
	damaged.emit()

func _on_missile_active_state_physics_processing(delta: float) -> void: #TODO change to state_entered!
	missle_target_ray_cast.is_active = true

func _on_missile_inactive_state_physics_processing(delta: float) -> void:
	missle_target_ray_cast.is_active = false

func _on_missile_active_state_exited() -> void:
	if missle_target_ray_cast.missile_targets.size() == 0: return
	
	for target in missle_target_ray_cast.missile_targets:
		if not is_instance_valid(target): continue
		var missile := PLAYER_MISSILE.instantiate() as PlayerMissile
		missile.missile_target = target
		missile.direction = Vector3.DOWN
		active_missiles_count += 1
		missile.tree_exited.connect(func(): active_missiles_count -= 1)
		owner.add_sibling(missile)
		missile.global_position = shoot_marker_3d.global_position
		await get_tree().create_timer(0.1).timeout
	
	missle_target_ray_cast.missile_targets.clear()


func _on_ship_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"spin_right":
			state_chart.send_event("roll_end")
		"spin_left":
			state_chart.send_event("roll_end")
