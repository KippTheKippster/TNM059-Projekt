extends Projectile

func _on_hurt_area_damaged_health_area(_health_area: HealthArea):
	queue_free()
