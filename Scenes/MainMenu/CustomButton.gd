extends TextureButton

@onready var label = $Label

func _on_button_down():
	label.global_position.y = label.global_position.y + size.y/16

func _on_button_up():
	label.global_position.y = label.global_position.y - size.y/16
