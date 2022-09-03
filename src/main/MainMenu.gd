extends "res://src/main/MenuBase.gd"


const level_select := "res://src/main/LevelSelect.tscn"
const about_menu := "res://src/main/AboutMenu.tscn"


func _on_PlayButton_pressed():
	get_tree().change_scene(level_select)


func _on_AboutButton_pressed():
	get_tree().change_scene(about_menu)
