extends CharacterBody3D
class_name Player

signal damaged

@onready var rotation_container: Node3D = $RotationContainer
@onready var ship_animation_player = %ShipAnimationPlayer
@onready var health_area: HealthArea = $RotationContainer/HealthArea
@onready var shoot_marker_3d: Marker3D = $RotationContainer/ShootMarker3D
@onready var missle_target_ray_cast: MissileTargetRayCast = $RotationContainer/MissleTargetRayCast
@onready var crosshair_1: Sprite3D = $RotationContainer/Crosshair1
@onready var crosshair_2: Sprite3D = $RotationContainer/Crosshair2
@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var state_chart: StateChart = $StateChart
@onready var boost: AtomicState = $StateChart/Root/Movement/Boost
@onready var brake: AtomicState = $StateChart/Root/Movement/Brake

const PLAYER_BULLET = preload("res://player/player_bullet.tscn")
const PLAYER_MISSILE = preload("res://player/player_missile.tscn")

@export_group("Movement")
var speed: float
@export var move_speed: float = 6.0
@export var boost_speed: float = 10.0
@export var brake_speed: float = 3.5
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
@export_group("Path")
var path_speed_scale: float 
@export var path_boost_scale: float = 2.0
@export var path_brake_scale: float = 0.5

var path_velocity: Vector3
var true_velocity: Vector3

var is_firing_missiles: bool
var active_missiles_count: int:
	get: return active_missiles_count
	set(value):
		active_missiles_count = value
		state_chart.set_expression_property("active_missiles", value)

func _ready() -> void:
	speed = move_speed
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
		
	if Input.is_action_just_pressed("boost"):
		state_chart.send_event("boost")
	if Input.is_action_just_released("boost"):
		state_chart.send_event("boost_release")
		
	if Input.is_action_just_pressed("brake"):
		state_chart.send_event("brake")
	if Input.is_action_just_released("brake"):
		state_chart.send_event("brake_release")

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "down", "up")
	var velocity_2d := Vector2(velocity.x, velocity.y)
	var weight := acceleration
	if input_dir == Vector2.ZERO:
		weight = deceleration
	
	velocity_2d = velocity_2d.move_toward(input_dir * speed, weight * delta)
	
	velocity = Vector3(velocity_2d.x , velocity_2d.y, 0)
	true_velocity = velocity + path_velocity
	
	#var rotation_2d = Vector2(rotation_container.rotation.x, rotation_container.rotation.y)
	var rotaion_target := Vector3(
		max_rotation.x * input_dir.y,
		-max_rotation.y * input_dir.x,
		-max_rotation.z * input_dir.x
		)
	
	var horizontal_rotation_target := Vector2(
		rotaion_target.y,
		rotaion_target.z
	)
		
	var rotation_weight := Vector2.ONE * rotation_acceleration
	if input_dir.x == 0:
		rotation_weight.x = rotation_deceleration
	if input_dir.y == 0:
		rotation_weight.y = rotation_deceleration
	
	#Horizontal Rotation
	var horizontal_rotation := Vector2(rotation_container.rotation.y, rotation_container.rotation.z) 
	horizontal_rotation = horizontal_rotation.lerp(horizontal_rotation_target, rotation_weight.x * delta)
	rotation_container.rotation.y = horizontal_rotation.x
	rotation_container.rotation.z = horizontal_rotation.y
	
	#Vertical Rotation
	rotation_container.rotation.x = lerp(rotation_container.rotation.x, rotaion_target.x, rotation_weight.y * delta)
	
	#Move
	var prev_velocity := velocity
	velocity *= global_transform.basis.inverse() #Fixes so that the rotation of PlayerController doesn't affect movement of player
	move_and_slide()
	velocity = prev_velocity

func _on_health_area_damaged(_hurt_area: HurtArea) -> void:
	damaged.emit()

func _on_missile_active_state_entered():
	missle_target_ray_cast.is_active = true
	crosshair_1.frame = 2
	crosshair_2.frame = 3
	crosshair_2.visible = false

func _on_missile_inactive_state_entered():
	missle_target_ray_cast.is_active = false
	crosshair_1.frame = 0
	crosshair_2.frame = 1
	crosshair_2.visible = true

func _on_missile_active_state_exited() -> void:
	if missle_target_ray_cast.missile_targets.size() == 0: return
	
	while missle_target_ray_cast.missile_targets.size() > 0:
		var target := missle_target_ray_cast.missile_targets[0]
		missle_target_ray_cast.missile_targets.remove_at(0)
		if not is_instance_valid(target): 
			continue
		var missile := PLAYER_MISSILE.instantiate() as PlayerMissile
		missile.missile_target = target
		missile.direction = global_basis * Vector3.FORWARD
		active_missiles_count += 1
		missile.tree_exited.connect(func(): 
			active_missiles_count -= 1
			if is_instance_valid(missile.missile_target):
				missile.missile_target.deactivate()
		)
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

func _on_boost_state_entered() -> void:
	path_speed_scale = path_boost_scale
	speed = boost_speed

func _on_brake_state_entered() -> void:
	path_speed_scale = path_brake_scale
	speed = brake_speed

func _on_movement_idle_state_entered() -> void:
	path_speed_scale = 1
	speed = move_speed
