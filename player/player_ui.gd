extends Control

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar

func _process(delta):
	health_bar.value = player.health_area.health
