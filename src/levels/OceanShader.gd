tool
extends TextureRect


export var shader_size := Vector2(1280, 1280) setget set_shader_size
export var edge_radius := 0.9 setget set_edge_radius


func set_shader_size(new_size: Vector2):
	shader_size = new_size
	rect_size = new_size
	material.set_shader_param("texture_size", new_size)


func set_edge_radius(radius: float):
	edge_radius = clamp(radius, 0, 1)
	material.set_shader_param("edge_radius", edge_radius)

