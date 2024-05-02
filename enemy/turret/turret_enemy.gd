extends Enemy

const ENEMY_BULLET = preload("res://enemy/enemy_bullet.tscn")
@onready var shoot_marker: Marker3D = %ShootMarker
@onready var small_explosion: Node3D = $SmallExplosion
@onready var shoot_timer: Timer = $ShootTimer

@onready var head: Node3D = $Sattelite/Body/Head

func _process(delta: float) -> void:
	var dif := player.global_position - global_position
	#if name == "TurretEnemy":
		
	var horizontal := Vector2(dif.z, dif.x)
	var vertical := Vector2(dif.y, horizontal.length())
	
	var angle_x := clamp(vertical.angle(), -PI / 2, PI / 2) as float
	
	head.rotation = Vector3(angle_x, horizontal.angle(), 0)

func shoot() -> void:
	create_bullet()
	await get_tree().create_timer(0.2).timeout
	create_bullet()
	await get_tree().create_timer(0.2).timeout
	create_bullet()

func create_bullet() -> void:
	var bullet = ENEMY_BULLET.instantiate() as Projectile
	add_sibling(bullet)
	bullet.global_position = shoot_marker.global_position
	bullet.set_direction_towards_position(bullet.predict_position(player, player.path_velocity))

func die() -> void:
	queue_free()
	small_explosion.explode()

func _on_shoot_timer_timeout() -> void:
	shoot()

func _on_asleep_state_entered() -> void:
	shoot_timer.stop()

func _on_awake_state_entered() -> void:
	shoot_timer.start()
	shoot()
