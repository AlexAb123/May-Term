extends Node2D
@onready var wave_manager = $WaveManager
@onready var levels = $Levels

# deletes all enemies when going to main menu
func _on_main_menu_in_menu():
	for n in get_children():
			remove_child(n)
			n.queue_free()
	wave_manager.manageQuit()

func _on_pause_pressed():
	wave_manager.pauseTimer()

func _on_main_menu_instantiate_level(currlevel):
	levels.add_child(currlevel)

func _on_main_menu_in_game():
	wave_manager.playTimer()

func _on_menu_layer_play():
	print("PLAY")
	wave_manager.playTimer()
