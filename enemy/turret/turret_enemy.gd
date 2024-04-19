extends Enemy

const ENEMY_BULLET = preload("res://enemy/enemy_bullet.tscn")
@onready var shoot_marker: Marker3D = $ShootMarker
@onready var small_explosion: Node3D = $SmallExplosion
@onready var shoot_timer: Timer = $ShootTimer

func shoot() -> void:
	var bullet = ENEMY_BULLET.instantiate() as Projectile
	add_sibling(bullet)
	bullet.global_position = shoot_marker.global_position
	#bullet.set_direction_towards(player)
	#bullet.shoot_at_player(player)
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
