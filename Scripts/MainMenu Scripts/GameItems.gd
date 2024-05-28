extends Node2D
@onready var wave_manager = $WaveManager
@onready var levels = $Levels

# deletes all enemies when going to main menu
func _on_main_menu_in_menu():
	for n in levels.get_children():
		levels.remove_child(n)
		n.queue_free()
	wave_manager.manageQuit()

func _on_pause_pressed():
	wave_manager.pauseTimer()

func _on_main_menu_instantiate_level(currlevel):
	levels.add_child(currlevel)
	currlevel.town_hall_destroyed.connect(_on_town_hall_destroyed)

signal town_hall_destroyed
func _on_town_hall_destroyed():
	town_hall_destroyed.emit()
	
func _on_main_menu_in_game():
	wave_manager.playTimer()

func _on_options_menu_play():
	wave_manager.playTimer()
