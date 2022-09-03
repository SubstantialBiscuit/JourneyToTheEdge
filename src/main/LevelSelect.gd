extends "res://src/main/MenuBase.gd"


export(Array, String, FILE, "*.tscn") var levels
var LevelButton = preload("res://src/main/LevelButton.tscn")
onready var level_grid = get_node("VBoxContainer/LevelGrid")


func _ready():
	level_buttons()


func level_buttons():
	for i in range(0, levels.size()):
		var lvl = LevelButton.instance()
		lvl.level_num = i + 1
		lvl.level_scene = levels[i]
		level_grid.add_child(lvl)
		
