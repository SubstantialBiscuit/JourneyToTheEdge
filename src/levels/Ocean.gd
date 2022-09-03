tool
extends Area2D


export var ocean_size := 1280 setget set_ocean_size
const RADIUS_RATIO := 0.4

signal reached_edge


func set_ocean_size(new_size: int):
	var shader = get_node("OceanShader")
	var collision = get_node("CollisionShape2D")
	var vec_size = Vector2(new_size, new_size)
	shader.shader_size = vec_size
	collision.position = vec_size / 2
	collision.shape.radius = new_size * RADIUS_RATIO
	shader.edge_radius = RADIUS_RATIO
	ocean_size = new_size


func _on_Ocean_body_exited(body):
	if body.name == "Player":
		emit_signal("reached_edge")
