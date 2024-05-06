extends CharacterBody3D
class_name Enemy

@onready var enemy_activator := get_tree().get_first_node_in_group("enemy_activator") as Node3D
@onready var player := get_tree().get_first_node_in_group("player") as Player
@onready var player_controller := get_tree().get_first_node_in_group("player_controller") as PlayerController 

@onready var state_chart: StateChart = $StateChart

@export var awake_on_collision := true
@export var activation_distance: float = 32

#func _on_enemy_ready() -> void:
#	player = get_tree().get_first_node_in_group("player") as Player

func wake_up() -> void:
	state_chart.send_event("awake")
	
func sleep() -> void:
	state_chart.send_event("sleep")

func die() -> void:
	SignalMaster.camera_shake_requested.emit()
	queue_free()

func _on_health_area_died() -> void:
	die()

func _on_asleep_state_processing(delta: float) -> void:
	#var dif = enemy_activator.global_position - global_position
	#global_position.project(player_controller.global_position 
	#	+ player_controller.path_follow.basis * Vector3.FORWARD)
	var path := player_controller.path_follow.get_parent() as Path3D
	var point := path.curve.get_closest_point(global_position - path.global_position)
	var player_point := path.curve.get_closest_point(player_controller.global_position - path.global_position)
	var dif := player_point - point
	if dif.length() < activation_distance:
		wake_up()
