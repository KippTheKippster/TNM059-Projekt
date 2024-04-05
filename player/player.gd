extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const BULLET = preload("res://player/bullet.tscn")

@onready var shoot_cooldown_timer = $ShootCooldownTimer
@onready var shoot_marker_3d = $ShootMarker3D

var can_shoot: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	if Input.is_action_just_pressed("shoot") and can_shoot:
		var bullet = BULLET.instantiate()
		add_sibling(bullet)
		bullet.global_position = shoot_marker_3d.global_position
		bullet.global_rotation = global_rotation
		can_shoot = false
		shoot_cooldown_timer.start()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_shoot_cooldown_timer_timeout():
	can_shoot = true
