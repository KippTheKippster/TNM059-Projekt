extends Area3D

@onready var player_controller: Node3D = $".."

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		if enemy.awake_on_collision:
			enemy.wake_up(player_controller)


func _on_body_exited(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		if enemy.awake_on_collision:
			enemy.sleep(player_controller)
