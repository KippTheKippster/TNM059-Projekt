extends "res://enemy/circler/circler.gd"

@onready var awake: AtomicState = $StateChart/Active/Awake

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	print("off screen!")
	if awake.active:
		queue_free()
		path_3d.queue_free()
