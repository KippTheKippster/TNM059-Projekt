extends Area3D
class_name HealthArea

signal damaged(hurt_area: HurtArea)
signal health_changed(new_health: float, old_health: float) 
signal died()

var is_dead: bool = false

@export var health: float = 1:
	set(value):
		if (health != value):
			var old_health : float = health
			health = value
			health_changed.emit(health, old_health)
			if health <= 0:
				is_dead = true
				died.emit()
	get:
		return health

@export_flags("Player", "Enemy", "World") var layer: int = 4
