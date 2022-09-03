extends Control


onready var ocean_shader = get_node("OceanShader")


func _ready():
	ocean_shader.shader_size = OS.window_size


func _on_MenuBase_resized():
	if ocean_shader != null:
		ocean_shader.shader_size = OS.window_size


func _on_BackButton_pressed():
	get_tree().change_scene("res://src/main/MainMenu.tscn")
