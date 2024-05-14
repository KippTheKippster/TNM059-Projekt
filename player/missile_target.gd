@tool
extends Area3D
class_name MissileTarget

@onready var marker_sprite: MeshInstance3D = $MarkerSprite
@onready var marker_sprite_2: MeshInstance3D = $MarkerSprite2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var max_targets: int = 1
@export var sprite_scale: float = 5:
	get: 
		var shader := marker_sprite.material_override as ShaderMaterial
		return shader.get_shader_parameter("size")
	set(value):
		if not is_node_ready(): return
		set_sprite_size(marker_sprite, value)
		set_sprite_size(marker_sprite_2, value)

func set_sprite_size(sprite: MeshInstance3D, value: float) -> void:
	var shader := sprite.material_override as ShaderMaterial
	shader.set_shader_parameter("size", value)

@export var target_timeout: float = 0.25
var can_target: bool = true

var is_active: bool

func _ready() -> void:
	sprite_scale = sprite_scale
	#marker_sprite.visible = false

func activate() -> void:
	#if is_active: return
	if not can_target: return
	is_active = true
	marker_sprite.visible = true
	can_target = false
	animation_player.stop()
	animation_player.play("appear")
	await get_tree().create_timer(target_timeout).timeout
	can_target = true

func deactivate() -> void:
	if !is_active: return
	is_active = false
	marker_sprite.visible = false
	marker_sprite_2.visible = false
