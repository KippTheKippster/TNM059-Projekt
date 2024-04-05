extends Area3D
class_name HurtArea

signal damaged_health_area(health_area: HealthArea)

@export var damage : float = 1.0
##Deal damge to layer-
@export_flags("Player", "Enemy", "World") var layer: int = 4

var is_in_shield: bool = false

func _on_area_entered(area: Area3D):
	if area is HealthArea:
		handle_health_area(area)
		
func handle_health_area(area: HealthArea):
	print("1")
	if is_in_shield:
		return
	
	if layer & area.layer == 0:
		return
	
	print("3")
	area.health -= damage
	area.damaged.emit(self)
	damaged_health_area.emit(area)
