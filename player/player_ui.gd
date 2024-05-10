extends Control

@export var player: Player

@onready var health_bar: ProgressBar = %HealthBar
@onready var fps_label: Label = $FPSLabel
@onready var time_label: Label = $TimeLabel

var time: float

func _process(delta: float):
	health_bar.value = player.health_area.health
	fps_label.text = str(Engine.get_frames_per_second())
	time_label.text = str(int(time))
	time += delta
