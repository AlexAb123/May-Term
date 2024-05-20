extends CanvasLayer

@export var OptionsMenu : Control
@export var Main : Node
@onready var pause_button = $pause
@onready var options_menu = $OptionsMenu
@onready var main_menu = $"../../MainMenu"


signal pause

func _ready():
	#OptionsMenu.play.connect(playview)
	pass
	
func pauseview():
	pause_button.visible = false
	options_menu.visible = true
	
func playview():
	pause_button.visible = true
	options_menu.visible = false

func process(delta):
	pass

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
