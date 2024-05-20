extends Node2D

@onready var options : Control = $MenuLayer/OptionsMenu
@onready var menu_layer : CanvasLayer = $MenuLayer

func _ready():
	options.play.connect(play)
	menu_layer.pause.connect(pause)
	pass


func play():
	get_tree().paused = false
	options.hide()


func pause():
	get_tree().paused = true
	options.show()
