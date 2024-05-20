extends CanvasLayer

@onready var pause_button = $pause
@onready var options_menu = $OptionsMenu

signal pause
signal play

func _ready():
	pass
	
func pauseview():
	pause_button.visible = false
	options_menu.visible = true
	
func playview():
	pause_button.visible = true
	options_menu.visible = false

func _on_pause_pressed():
	pauseview()
	pause.emit()
	print("PAUSE")

func _on_options_menu_play():
	playview()

func _on_main_menu_in_game():
	visible = true
	playview()

func _on_main_menu_in_menu():
	hide()
