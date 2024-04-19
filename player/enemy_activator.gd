extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		enemy.state_chart.send_event("awake")


func _on_body_exited(body: Node3D) -> void:
	if body is Enemy:
		var enemy := body as Enemy
		enemy.state_chart.send_event("sleep")
