extends Enemy

@onready var animation_player: AnimationPlayer = $boss/AnimationPlayer
@onready var laser: Laser = $MissileTarget/Laser
@onready var laser_2: Laser = $MissileTarget2/Laser2
@onready var mouth_marker: Marker3D = $boss/Armature/MouthMarker
@onready var missile_target: MissileTarget = $MissileTarget
@onready var missile_target_2: MissileTarget = $MissileTarget2
@onready var smoke_thruster: GPUParticles3D = $HealthArea/SmokeThruster
@onready var smoke_thruster_2: GPUParticles3D = $HealthArea2/SmokeThruster2
@onready var small_explosion: Node3D = $HealthArea/SmallExplosion
@onready var small_explosion_2: Node3D = $HealthArea2/SmallExplosion2
const SMALL_EXPLOSION = preload("res://assets/explosions/small_explosion.tscn")
@onready var initial_position := global_position
@onready var final_explosion: MeshInstance3D = $boss/Armature/FinalExplosion

@onready var whiteout: CanvasLayer = $Whiteout
@onready var armature: Node3D = $boss/Armature


const BULLET = preload("res://enemy/enemy_bullet.tscn")

var idle_time: float
var spray_time: float
var dead_time: float
var shoot_count: int

var prev_attack_id: int = 2

var eye_1_destroyed := false
var eye_2_destroyed := false

func _ready() -> void:
	visible = false
	armature.position = Vector3.UP * 100

func _on_start_state_entered() -> void:
	#visible = true
	player.health_area.health = 10
	await get_tree().create_timer(0.05).timeout
	set_deferred("visible", true)

func _on_idle_state_entered() -> void:
	state_chart.send_event("attack_idle")

func _on_idle_state_processing(delta: float) -> void:
	global_position = initial_position
	global_position += Vector3.RIGHT * 10 * sin(idle_time)
	global_position += Vector3.UP * 3 * sin(2 * idle_time)
	idle_time += delta

func _on_laser_state_entered() -> void:
	if is_instance_valid(laser):
		var tween := create_tween()
		tween.tween_property(laser, "height", 64, 1.0)
	if is_instance_valid(laser_2):
		var tween_2 := create_tween()
		tween_2.tween_property(laser_2, "height", 64, 1.0)

func _on_laser_state_exited() -> void:
	if is_instance_valid(laser):
		var tween := create_tween()
		tween.tween_property(laser, "height", 0, 0.4)
	if is_instance_valid(laser_2):
		var tween_2 := create_tween()
		tween_2.tween_property(laser_2, "height", 0, 0.4)

func _on_spray_state_entered() -> void:
	spray_time = 999

func _on_spray_state_processing(delta: float) -> void:
	spray_time += delta
	if spray_time < 0.5: return
	var shoot_type = shoot_count % 6
	if shoot_type == 0:
		var spread := 0.1
		create_bullet((Vector3.RIGHT + Vector3.DOWN).normalized() * spread)
		create_bullet((Vector3.LEFT + Vector3.DOWN).normalized() * spread)
		create_bullet(Vector3.UP * spread)
	elif shoot_type == 1:
		create_bullet()
	elif shoot_type == 2:
		var spread := 0.1
		create_bullet()
		create_bullet(Vector3.LEFT * spread)
		create_bullet(Vector3.RIGHT * spread)
	elif shoot_type == 3:
		create_bullet()
	elif shoot_type == 4:
		var spread := 0.1
		create_bullet()
		create_bullet(Vector3.UP * spread)
		create_bullet(Vector3.DOWN * spread)
	else:
		create_bullet()
	
	shoot_count += 1
	spray_time = 0

func create_bullet(offset: Vector3 = Vector3.ZERO) -> Projectile:
	var bullet := BULLET.instantiate() as Projectile
	add_sibling(bullet)
	bullet.speed *= 1.3
	bullet.global_position = mouth_marker.global_position
	bullet.set_direction_towards_position(bullet.predict_position(player, player.path_velocity))
	bullet.direction += offset
	bullet.global_rotation = Vector3.ZERO
	bullet.top_level = true
	return bullet


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"chomp":
			state_chart.send_event("chomp_end")


func _on_attack_idle_state_entered() -> void:
	await get_tree().create_timer(1.5).timeout
	var attack_id := randi() % 3
	print("random: ", attack_id)
	if prev_attack_id == attack_id:
		attack_id += 1
		attack_id = attack_id % 3
	
	print("final: ", attack_id)
	
	prev_attack_id = attack_id
	
	match attack_id:
		0:
			state_chart.send_event("laser")
		1:
			state_chart.send_event("spray")
		2:
			state_chart.send_event("chomp")
			
func _on_health_area_died() -> void:
	print("Oh no 1!")
	if eye_1_destroyed: 
		return
	if is_instance_valid(missile_target):
		missile_target.queue_free()
		remove_child(missile_target)
	smoke_thruster.emitting = true
	small_explosion.explode()
	eye_1_destroyed = true
	die()
	
func _on_health_area_2_died() -> void:
	print("Oh no 2!")
	if eye_2_destroyed: 
		return
	if is_instance_valid(missile_target_2):
		missile_target_2.queue_free()
		remove_child(missile_target_2)
	smoke_thruster_2.emitting = true
	small_explosion_2.explode()
	eye_2_destroyed = true
	die()
	
func die() -> void:
	if not eye_1_destroyed or not eye_2_destroyed:
		return
		
	print("Im dead 'skull emoji'")
	state_chart.send_event("dead")


func _on_die_state_processing(delta: float) -> void:
	dead_time += delta
	if dead_time < 1 + randf_range(-0.2, 0.05):
		var explosion := SMALL_EXPLOSION.instantiate() as Node3D
		add_sibling(explosion)
		explosion.global_position = global_position + 3 * Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
		explosion.explode()
		dead_time = 0


func _on_die_state_entered() -> void:
	await get_tree().create_timer(3.0).timeout
	#final_explosion.reparent(get_parent())
	whiteout.reparent(get_parent())
	var tween := create_tween()
	tween.tween_property(final_explosion, "scale", 96 * Vector3.ONE, 3.0)
	await get_tree().create_timer(0.5).timeout
	whiteout.start(1.7)
	await get_tree().create_timer(1.7).timeout
	queue_free()
	#queue_free()
