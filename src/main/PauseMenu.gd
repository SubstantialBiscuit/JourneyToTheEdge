extends CanvasLayer


const level_select := "res://src/main/LevelSelect.tscn"
var message := "Paused" setget set_message
onready var allow_unpause := true
onready var container = get_node("VBoxContainer")

func _ready():
	container.hide()


func set_message(text: String):
	get_node("VBoxContainer/Label").text = text
	message = text


func pause(allow: bool):
	get_tree().paused = true
	container.show()
	print("Allowed %s" % allow)
	allow_unpause = allow


func unpause():
	container.hide()
	get_tree().paused = false


func _input(event):
	if event.is_action_pressed("pause"):
		if not allow_unpause:
			pass
		elif get_tree().paused:
			unpause()
		else:
			pause(true)
		get_tree().set_input_as_handled()


func _on_LevelSelectButton_pressed():
	unpause()
	get_tree().change_scene(level_select)


func _on_RestartButton_pressed():
	unpause()
	get_tree().reload_current_scene()
