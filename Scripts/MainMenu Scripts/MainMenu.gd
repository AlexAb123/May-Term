extends Control

#this file handles the signals checking if the player is in game or not
# also handles level selection 

@onready var levels = [	preload("res://Scenes/Levels/Level_1.tscn"),
						preload("res://Scenes/Levels/Level_2.tscn"),]
						#preload("res://Scenes/Levels/Level_3.tscn")]

@onready var currlevel


signal in_game
signal in_menu
signal quit_game
signal instantiate_level

func _on_options_menu_menu_emit(): # going from paused ingame to menu
	in_menu.emit()
	get_tree().paused = false
	visible = true
	

func _on_level_1_pressed():
	#get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")
	print("LEVEL 1")
	currlevel = levels[0].instantiate()
	instantiate_level.emit(currlevel)
	in_game.emit()
	visible = false
	#print("INGAME")

func _on_level_2_pressed():
	print("LEVEL 2")
	currlevel = levels[1].instantiate()
	instantiate_level.emit(currlevel)
	in_game.emit()
	visible = false
	#print("INGAME")

func _on_level_3_pressed():
	print("LEVEL 3")
	currlevel = levels[2].instantiate()
	instantiate_level.emit(currlevel)
	in_game.emit()
	visible = false


func _on_quit_game_pressed():
	print("QUIT GAME")
	quit_game.emit()


func _on_continue_button_pressed():
	in_menu.emit()
	get_tree().paused = false
	visible = true

