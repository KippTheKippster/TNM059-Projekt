extends "res://enemy/circler/circler.gd"

@onready var awake: AtomicState = $StateChart/Active/Awake

@onready var effects_animation_player: AnimationPlayer = $Mesh/EffectsAnimationPlayer

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if awake.active:
		queue_free()
		path_3d.queue_free()


func _on_health_area_damaged(hurt_area: HurtArea) -> void:
	effects_animation_player.play("shake")
