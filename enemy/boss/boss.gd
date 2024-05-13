extends Enemy

@onready var animation_player: AnimationPlayer = $boss/AnimationPlayer

func _ready() -> void:
	visible = false

func _on_start_state_entered() -> void:
	visible = true
	animation_player.play("laugh")

func _on_idle_state_entered() -> void:
	animation_player.play("idle")
