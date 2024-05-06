extends Area3D

@onready var player_controller: Node3D = $".."

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		if enemy.awake_on_collision:
			pass
			#enemy.wake_up()


func _on_body_exited(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		if enemy.awake_on_collision:
			pass
			#enemy.sleep()
