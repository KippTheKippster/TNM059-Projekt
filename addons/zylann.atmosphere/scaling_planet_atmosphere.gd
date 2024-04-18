@tool
extends "res://addons/zylann.atmosphere/planet_atmosphere.gd"

@export var initial_radius: float:
	get: return initial_radius
	set(value):
		initial_radius = value
		if planet == null: return
		set_planet_scale(planet.global_transform)
		
@export var initial_athmosphere_height: float:
	get: return initial_athmosphere_height
	set(value):
		initial_athmosphere_height = value
		if planet == null: return
		set_planet_scale(planet.global_transform)

@export var planet: Node3D

func set_planet_scale(planet_transform: Transform3D) -> void:
	var s = (Vector3.ONE * planet_transform.basis).x
	planet_radius = initial_radius * s
	atmosphere_height = initial_athmosphere_height * s
	global_position = planet_transform.origin
	
	#planet_radius = initial_radius * exp(s - 1)
	print("Final: ", planet_radius, " s: ", s, " trans: ", planet_transform, " i_r:", initial_radius, " i_a: ", initial_athmosphere_height)
