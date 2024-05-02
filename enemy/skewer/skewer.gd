extends Enemy

@onready var movement_animation_player: AnimationPlayer = $MovementAnimationPlayer
@onready var awake: AtomicState = $StateChart/Active/Awake

func _ready() -> void:
	var new_parent := Node3D.new()
	new_parent.position = position
	add_sibling.call_deferred(new_parent)
	reparent.call_deferred(new_parent)

func _process(delta: float) -> void:
	var dif = player.global_position - global_position
	if dif.length() < 16:
		wake_up(null)

func wake_up(player_controller: PlayerController) -> void:
	if awake.active: return
	
	movement_animation_player.play("appear")
	super.wake_up(player_controller)
