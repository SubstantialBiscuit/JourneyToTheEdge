tool
extends Node2D


export var map_size := 2560 setget set_map_size


func set_map_size(new_size: int):
	map_size = new_size
	$Ocean.ocean_size = map_size
	var vec_size = Vector2(map_size, map_size)
	$CloudsShader.rect_size = vec_size
	$Player.position = vec_size / 2


func _on_Ocean_reached_edge():
	$PauseMenu.message = "Congratulations, you've reached paradise!"
	LevelScoreData.update_score(name, $PlayerHUD.level_time, $Player.chest)
	var lvl = LevelScoreData.get_score(name)
	if lvl.completed and $PlayerHUD.level_time < lvl.time:
		$PauseMenu.message += "\nNew Best Time!"
	$PauseMenu.pause(false)


func _on_Player_died():
	$PauseMenu.message = "Too much damage!\nYou're shipwrecked!"
	$PauseMenu.pause(false)


func _on_Player_mutiny():
	$PauseMenu.message = "Crew Mutiny!"
	$PauseMenu.pause(false)
