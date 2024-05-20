extends Control
@onready var levels = $"../../GameItems/Levels"


signal play
signal menu_emit

func _on_resume_pressed():
	play.emit()

func _on_go_to_main_menu_pressed():
	for n in levels.get_children():
		levels.remove_child(n)
		n.queue_free()
	menu_emit.emit()

func _on_quit_level_pressed():
	pass


