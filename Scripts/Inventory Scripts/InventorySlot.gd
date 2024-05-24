extends Control

class_name InventorySlot

var slot_id: int

@onready var itemSprite2D = $ItemSprite2D
@onready var itemCountLabel: Label = $ItemCountLabel

signal slot_input(slot_id, event)


func _on_area_2d_input_event(_viewport, event, _shape_idx):
	slot_input.emit(slot_id, event)

func set_sprite(sprite: Texture2D):
	itemSprite2D.texture = sprite
func set_count_label(text: String):
	itemCountLabel.text = str(text)

var mouse_hover: bool = false
func _on_area_2d_mouse_entered():
	mouse_hover = true

func _on_area_2d_mouse_exited():
	mouse_hover = true
