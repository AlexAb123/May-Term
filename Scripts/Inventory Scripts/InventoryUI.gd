extends Control

var isOpen = false

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if isOpen:
			close()
		else:
			open()
func open():
	isOpen = true 
	self.visible = true

func close():
	isOpen = false
	visible = false
