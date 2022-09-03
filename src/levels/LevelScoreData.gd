extends Node


const data_file := "user://level_scores.dat"

var level_data : Dictionary


class LevelScore:
	var time: float
	var completed := false
	var chest := false
	
	func _to_string():
		return "Time: %.2f, Completed: %s, Chest: %s" % [time, completed, chest]


func _ready():
	load_data()
	print(level_data)


func save_data():
	print(level_data)
	var file = File.new()
	file.open(data_file, File.WRITE_READ)
	file.store_var(level_data, true)
	file.seek(begin)
	print("Read: %s" % file.get_var(true))
	file.close()


func load_data():
	var file = File.new()
	if file.file_exists(data_file):
		file.open(data_file, File.READ)
		level_data = file.get_var(true)
		file.close()


func update_score(level_name: String, time: float, chest: bool):
	var lvl = level_data.get(level_name, LevelScore.new())
	print(lvl)
	if not lvl.completed:
		lvl.time = time
		lvl.completed = true
	else:
		if time < lvl.time:
			lvl.time = time
	if not lvl.chest and chest:
		lvl.chest = chest
	level_data[level_name] = lvl
	print(lvl)
	print(level_data)
	save_data()


func get_score(level_name: String):
	return level_data.get(level_name, LevelScore.new())
