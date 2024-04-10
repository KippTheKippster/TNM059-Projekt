extends Projectile
class_name PlayerMissile

@export var max_speed: float = 25.0
@export var acceleration: float = 4.0
@export var turn_speed: float = 10.0

var missile_target: MissileTarget
var direction_target: Vector3

func _ready() -> void:
	speed = 0

func _process(delta: float) -> void:
	super._process(delta)
	if not is_instance_valid(missile_target): return
	direction_target = missile_target.global_position - global_position
	direction = direction.move_toward(direction_target, turn_speed * delta)
	speed = move_toward(speed, max_speed, acceleration * delta)
