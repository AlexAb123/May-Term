extends Control

signal menu_emit
signal play
signal quit

func _on_resume_pressed():
	play.emit()

func _on_go_to_main_menu_pressed():
	menu_emit.emit()

func _on_quit_level_pressed():
	quit.emit()
