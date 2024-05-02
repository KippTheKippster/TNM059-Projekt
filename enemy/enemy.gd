extends CharacterBody3D
class_name Enemy

@onready var enemy_activator := get_tree().get_first_node_in_group("enemy_activator") as Node3D
@onready var player := get_tree().get_first_node_in_group("player") as Player

@onready var state_chart: StateChart = $StateChart

@export var awake_on_collision := true

#func _on_enemy_ready() -> void:
#	player = get_tree().get_first_node_in_group("player") as Player

func wake_up(_player_controller: PlayerController) -> void:
	state_chart.send_event("awake")
	
func sleep(_player_controller: PlayerController) -> void:
	state_chart.send_event("sleep")

func die() -> void:
	SignalMaster.camera_shake_requested.emit()
	queue_free()

func _on_health_area_died() -> void:
	die()
