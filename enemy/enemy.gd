extends CharacterBody3D

#const BULLET = preload("res://player/bullet.tscn")
@onready var shoot_marker_3d = $ShootMarker3D



#func _on_shoot_cooldown_timer_timeout():
#	var bullet = BULLET.instantiate()
#	add_sibling(bullet)
#	bullet.global_position = shoot_marker_3d.global_position
#	bullet.global_rotation = global_rotation


func _on_health_area_died():
	queue_free()
