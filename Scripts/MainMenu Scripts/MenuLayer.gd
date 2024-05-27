extends CanvasLayer

@onready var pause_button = $pause
@onready var options_menu = $OptionsMenu

	
func pauseview():
	pause_button.visible = false
	options_menu.visible = true
	
func playview():
	pause_button.visible = true
	options_menu.visible = false

func _on_pause_pressed():
	pauseview()

func _on_main_menu_in_game():
	visible = true
	playview()

func _on_main_menu_in_menu():
	hide()


func _on_options_menu_play():
	playview()
	get_tree().paused = false
