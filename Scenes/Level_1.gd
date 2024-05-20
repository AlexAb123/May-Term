extends Node2D

func _ready():
	if not visible:
		get_tree().paused = true

func _process(delta):
	checkActive()
	
	
func checkActive():
	if visibility_changed:
		if visible:
			get_tree().paused = false
		else:
			get_tree().paused = true
