extends Node2D

@onready var options : Control = $MenuLayer/OptionsMenu
@onready var menu_layer : CanvasLayer = $MenuLayer


func _on_pause_pressed():
	get_tree().paused = true
	options.show()

func _on_wave_manager_win():
	print("AKSDJAKSDJKASJDKASJDKDASJ")
	get_node("EndScreen").visible = true

func _on_continue_button_pressed():
	get_node("EndScreen").visible = false

func _on_town_hall_destroyed():
	get_node("LoseScreen").visible = true
	
func _on_restart_button_pressed():
	get_node("LoseScreen").visible = false
