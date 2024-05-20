extends Control

@onready var play : bool
signal menu_emit

func _on_resume_pressed():
	play = true

func _on_go_to_main_menu_pressed():
	menu_emit.emit()

func _on_quit_level_pressed():
	pass
