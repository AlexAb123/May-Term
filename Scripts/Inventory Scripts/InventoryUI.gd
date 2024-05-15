extends Control

class_name Inventory_UI

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if visible:
			close()
		else:
			open()
func open():
	visible = true

func close():
	visible = false
