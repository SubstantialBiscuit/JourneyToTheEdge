extends "res://src/main/MenuBase.gd"



func _on_RichTextLabel_meta_clicked(meta):
	print(meta)
	OS.shell_open(meta)
