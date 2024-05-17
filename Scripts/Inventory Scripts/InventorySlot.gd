extends Control

class_name InventorySlot

var slot_id: int

@onready var itemSprite2D = $ItemSprite2D
@onready var itemCountLabel: Label = $ItemCountLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_input_event(viewport, event, shape_idx):
	get_parent().slot_input_event(slot_id, event)

func set_sprite(sprite: Texture2D):
	itemSprite2D.texture = sprite
func set_count_label(text: String):
	itemCountLabel.text = str(text)
