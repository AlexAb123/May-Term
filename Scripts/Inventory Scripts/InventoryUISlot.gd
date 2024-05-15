extends Panel

class_name Inventory_UI_Slot

@onready var itemSprite2D = $ItemSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	itemSprite2D.texture = Database.item_database["Coal"].sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
