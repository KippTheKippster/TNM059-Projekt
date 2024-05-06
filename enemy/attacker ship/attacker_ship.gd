extends Enemy

@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D
@onready var awake_state: AtomicState = $StateChart/Active/Awake

@export var path_follow_speed: float = 8.0

func _ready() -> void:
	path_3d.reparent.call_deferred(get_parent())

func wake_up() -> void:
	super.wake_up()
	path_3d.reparent(player_controller.path_follow)
	reparent(path_follow_3d)

#func wake_up(player_controller: PlayerController) -> void:
	#if awake_state.active: return
	#super.wake_up(player_controller)
	#var remote := RemoteTransform3D.new()
	#remote.update_rotation = false
	#remote.update_scale = false
	#remote.remote_path = path_follow_3d.get_path()
	#player_controller.path_follow.add_child(remote)
	#remote.global_position = global_position
	#reparent(path_follow_3d)

func sleep() -> void:
	#super.sleep(player_controller)
	#print("SLEEP")
	pass

func _on_awake_state_physics_processing(delta: float) -> void:
	#var old := path_follow_3d.position
	path_follow_3d.progress += path_follow_speed * delta
	#var dif = path_follow_3d.position - old
	#position += dif
