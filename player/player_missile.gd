extends Projectile
class_name PlayerMissile

@export var max_speed: float = 25.0
@export var acceleration: float = 4.0
@export var turn_speed: float = 10.0
@onready var small_explosion: Node3D = $SmallExplosion


var turn_strength: float = 0.05

var missile_target: MissileTarget
var direction_target: Vector3

func _ready() -> void:
	speed = 0

func _process(delta: float) -> void:
	if not is_instance_valid(missile_target): 
		queue_free()
		return
	
	direction_target = missile_target.global_position - global_position
	if direction_target.length() < 3:
		turn_strength = 10.0
	
	direction = direction.move_toward(direction_target, turn_speed * turn_strength * delta)
	speed = move_toward(speed, max_speed, acceleration * delta)
	look_at(global_position + direction)
	position += direction * speed * delta


func _on_target_timer_timeout() -> void:
	turn_strength = 1.0


func _on_hurt_area_damaged_health_area_2(health_area: HealthArea) -> void:
	small_explosion.explode()
