extends Control

class_name InventorySlot

var slot_id: int

@onready var itemSprite2D = $ItemSprite2D
@onready var itemCountLabel: Label = $ItemCountLabel

func _on_area_2d_input_event(viewport, event, shape_idx):
	get_parent().slot_input_event(slot_id, event)

func set_sprite(sprite: Texture2D):
	itemSprite2D.texture = sprite
func set_count_label(text: String):
	itemCountLabel.text = str(text)

var mouse_hover: bool = false
func _on_area_2d_mouse_entered():
	mouse_hover = true

func _on_area_2d_mouse_exited():
	mouse_hover = true
