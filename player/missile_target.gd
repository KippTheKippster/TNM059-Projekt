@tool
extends Area3D
class_name MissileTarget

@onready var marker_sprite: Sprite3D = $MarkerSprite

@export var max_targets: int = 1
@export var sprite_scale: float = 5:
	get: 
		return marker_sprite.scale.x
	set(value):
		if not is_node_ready(): return
		marker_sprite.scale = Vector3.ONE * value

@export var target_timeout: float = 0.25
var can_target: bool = true

var is_active: bool

func _ready() -> void:
	sprite_scale = sprite_scale
	marker_sprite.visible = false

func activate() -> void:
	#if is_active: return
	if not can_target: return
	is_active = true
	marker_sprite.visible = true
	can_target = false
	await get_tree().create_timer(target_timeout).timeout
	can_target = true

func deactivate() -> void:
	if !is_active: return
	is_active = false
	marker_sprite.visible = false
