extends Enemy

@onready var movement_animation_player: AnimationPlayer = $MovementAnimationPlayer
@onready var property_animation_player: AnimationPlayer = $PropertyAnimationPlayer
@onready var attack_timer: Timer = $AttackTimer
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var mesh: Node3D = $Mesh

@export var speed := 32

var start_position: Vector3

func _enter_tree() -> void:
	if start_position == Vector3.ZERO:
		start_position = global_position
		print(start_position)

func _ready() -> void:
	add_new_parent.call_deferred()

func add_new_parent() -> void:
	var new_parent := Node3D.new()
	add_sibling(new_parent)
	new_parent.reparent(get_parent())
	reparent(new_parent)
	new_parent.global_position = start_position
	position = Vector3.ZERO

func _on_awake_state_entered() -> void:
	get_parent().reparent(player_controller.path_follow)
	property_animation_player.play("RESET")
	movement_animation_player.play("appear")
	velocity = Vector3.ZERO
	attack_timer.start()
	print("HO")

func _on_attack_timer_timeout() -> void:
	var final_velocity := (player.global_position - global_position).normalized() * speed
	var tween := create_tween().tween_property(self, "velocity", final_velocity, 1)
	state_chart.send_event("charge")

func _on_appear_state_processing(delta: float) -> void:
	mesh.look_at(player.global_position)

func _on_charge_state_physics_processing(delta: float) -> void:
	move_and_slide()
	if not visible_on_screen_notifier_3d.is_on_screen():
		queue_free()
