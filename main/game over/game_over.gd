extends Control

func _on_restart_pressed() -> void:
	#get_tree().change_scene_to_file("res://main/game/game.tscn")
	TransitionScreen.change_scene_to_file("res://main/game/game.tscn")

func _on_menu_pressed() -> void:
	#get_tree().change_scene_to_file("res://main/menu/menu.tscn")
	TransitionScreen.change_scene_to_file("res://main/menu/menu.tscn")
