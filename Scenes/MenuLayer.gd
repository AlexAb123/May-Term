extends CanvasLayer

@onready var pause_button = $pause
@onready var options_menu = $OptionsMenu

signal play

func _physics_process(delta):
	if options_menu.play == true:
		print("playing")
		play.emit()
		playview()
		get_tree().paused = false
	
func pauseview():
	pause_button.visible = false
	options_menu.visible = true
	
func playview():
	pause_button.visible = true
	options_menu.visible = false

func _on_pause_pressed():
	pauseview()
	print("PAUSE")

func _on_main_menu_in_game():
	visible = true
	playview()

func _on_main_menu_in_menu():
	hide()
