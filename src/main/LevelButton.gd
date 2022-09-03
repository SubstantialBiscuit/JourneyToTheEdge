extends Control


export var level_num : int
export(String, FILE, "*.tscn") var level_scene
var best_time : float
onready var time_label := get_node("VBoxContainer/TimeLabel")
onready var chest_icon := get_node("VBoxContainer/ChestIcon")
onready var level_button := get_node("VBoxContainer/LevelButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_time(null)
	set_chest(false)
	level_button.text = "Level %d" % level_num


func set_time(time):
	if time == null or time == 0:
		time_label.text = "Best Time: ??"
	elif time >= 60:
		var mins = floor(time / 60.0)
		var secs = fmod(time, 60)
		time_label.text = "Best Time: %02d:%05.2f" % [mins, secs]
	else:
		time_label.text = "Best Time: %05.2f" % time


func set_chest(chest):
	if chest:
		chest_icon.modulate = Color(1, 1, 1, 1)
	else:
		chest_icon.modulate = Color(0, 0, 0, 1)


func _on_LevelButton_pressed():
	get_tree().change_scene(level_scene)
