extends RayCast3D
class_name MissileTargetRayCast

@export var max_target_count: int = 3

var missile_targets: Array[MissileTarget] = []
var is_active: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_active: return
	if missile_targets.size() >= max_target_count: return
	var collider = get_collider()
	if collider is MissileTarget and not missile_targets.has(collider):
		var target := collider as MissileTarget
		missile_targets.push_back(collider)
		target.activate()
