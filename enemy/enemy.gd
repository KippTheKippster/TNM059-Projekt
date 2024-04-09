extends CharacterBody3D
class_name Enemy

var player: Player

func _on_enemy_ready():
	player = get_tree().get_first_node_in_group("player") as Player

func die():
	queue_free()

func _on_health_area_died():
	die()
