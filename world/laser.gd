@tool
extends Node3D
class_name Laser

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $MeshInstance3D/HurtArea/CollisionShape3D

@export var height: float = 1:
	get: return height
	set(value):
		height = max(0, value)
		if not is_node_ready():
			return
		
		var mesh = mesh_instance_3d.mesh as QuadMesh
		mesh.size.y = height
		var shape = collision_shape_3d.shape as BoxShape3D
		shape.size.y = height
		mesh_instance_3d.position.y = height / 2

func _ready() -> void:
	height = height
	mesh_instance_3d.mesh = mesh_instance_3d.mesh.duplicate()
	collision_shape_3d.shape = collision_shape_3d.shape.duplicate()
