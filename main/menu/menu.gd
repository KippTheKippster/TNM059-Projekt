extends Control

@onready var loading_layer: CanvasLayer = $"../../LoadingLayer"

func _ready() -> void:
	loading_layer.visible = false

func _on_start_pressed() -> void:
	TransitionScreen.change_scene_to_file("res://main/game/game.tscn")
	await get_tree().create_timer(0.3).timeout
	loading_layer.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()
