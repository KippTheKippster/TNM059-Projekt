extends ShapeCast3D
class_name MissileTargetRayCast

@export var max_missile_target_count: int = 3
@export var length: float = 100
@export var target_delay: float = 0.25
var can_target: bool = true
@export var target_node: Node3D
var camera: Camera3D

var missile_targets: Array[MissileTarget] = []
var is_active: bool

func _ready() -> void:
	camera = get_viewport().get_camera_3d()

func _process(_delta: float) -> void:
	if not can_target: return
	global_transform = Transform3D()
	var target_node_viewport_position = camera.unproject_position(target_node.global_position)
	global_position = camera.project_ray_origin(target_node_viewport_position)
	target_position = camera.project_ray_normal(target_node_viewport_position) * length
	if not is_active: return
	if missile_targets.size() >= max_missile_target_count: return
	for rest_info in collision_result:
		var collider = instance_from_id(rest_info.collider_id)
		if collider is MissileTarget:
			var target := collider as MissileTarget
			if target.can_target and missile_targets.count(target) <= target.max_targets:
				print(missile_targets.count(target))
				missile_targets.push_back(collider)
				target.activate()
				can_target = false
				await get_tree().create_timer(target_delay).timeout
				can_target = true
