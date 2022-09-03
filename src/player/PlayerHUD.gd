extends CanvasLayer


onready var health_bar := get_node("VBoxContainer/HealthBox/HealthBar")
onready var morale_bar := get_node("VBoxContainer/MoraleBox/MoraleBar")
onready var time_label := get_node("LevelTimer")
onready var level_time := 0.0


func _ready():
	set_health(100)
	set_morale(100)
	update_time()


func _process(delta):
	level_time += delta
	update_time()


func set_health(amount):
	health_bar.value = clamp(amount, 0, 100)


func set_morale(amount):
	morale_bar.value = clamp(amount, 0, 100)


func update_time():
	if level_time >= 60:
		var mins = floor(level_time / 60.0)
		var secs = fmod(level_time, 60)
		time_label.text = "%02d:%05.2f" % [mins, secs]
	else:
		time_label.text = "%05.2f" % level_time
