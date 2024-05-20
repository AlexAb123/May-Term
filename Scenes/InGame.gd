extends Node2D

@onready var options : Control = $MenuLayer/OptionsMenu
@onready var menu_layer : CanvasLayer = $MenuLayer


func _on_menu_layer_play():
	
	get_tree().paused = false
	options.hide()


func _on_pause_pressed():
	get_tree().paused = true
	options.show()


func _on_options_menu_play():
	pass # Replace with function body.
