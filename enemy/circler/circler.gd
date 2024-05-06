extends Enemy

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shoot_timer: Timer = $ShootTimer
const ENEMY_BULLET = preload("res://enemy/enemy_bullet.tscn")

@export var speed: float = 10

func _ready() -> void:
	visible = false

func _on_awake_state_entered() -> void:
	path_3d.reparent(player_controller.path_follow)
	reparent(path_follow_3d)
	position = Vector3.ZERO
	visible = true
	animation_player.play("RESET")
	shoot_timer.start()


func _on_awake_state_processing(delta: float) -> void:
	path_follow_3d.progress += speed * delta
	if path_follow_3d.progress_ratio == 1:
		path_3d.queue_free()


func _on_shoot_timer_timeout() -> void:
	create_bullet()
	await get_tree().create_timer(0.2).timeout
	create_bullet()
	await get_tree().create_timer(0.2).timeout
	create_bullet()

func create_bullet() -> void:
	var bullet = ENEMY_BULLET.instantiate() as Projectile
	add_sibling(bullet)
	bullet.global_position = global_position
	bullet.set_direction_towards_position(bullet.predict_position(player, player.path_velocity))
