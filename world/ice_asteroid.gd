@tool
extends "res://world/asteroid.gd"

func _on_health_area_damaged(hurt_area: HurtArea) -> void:
	queue_free()
