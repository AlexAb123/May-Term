extends GridContainer

class_name Recipe_Building_Inventory_UI

@onready var slot_scene: PackedScene = preload("res://Scenes/Inventory Scenes/InventoryUISlot.tscn")

@export var slot_count: int = 9

var slots: Array[Inventory_UI_Slot] = []
var item_stacks: Array[ItemStack] = []

func _ready():
	initialize()
	close()
	return

func initialize():
	for i in slot_count:
		item_stacks.append(null)
	
		var new_slot: Inventory_UI_Slot = slot_scene.instantiate()
		new_slot.slot_id = i
		add_child(new_slot)
	
		slots.append(new_slot)
		
	#CENTERING THE INVENTORY ON THE SCREEN
	
	pivot_offset.x = (16*columns+get_theme_constant("h_separation")*(columns-1))/2
	var tempy = (int(float(slot_count)/columns))
	pivot_offset.y = (16*tempy+get_theme_constant("v_separation")*(tempy-1))/2
	anchors_preset = PRESET_CENTER
	position.x = position.x + Global.player.inventory.xshift
	
func slot_input_event(slot_id, event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				left_click_slot(slot_id)
			if event.button_index == 2:
				right_click_slot(slot_id)

var current_slot: int = 0
func left_click_slot(slot_id):
	
	Global.player.selected_item_stack = item_stacks[slot_id]
	Global.player.update_selected_item_sprite_and_label()
	current_slot = slot_id
	return

func right_click_slot(slot_id):
	pass
	
func update_slot(slot_id):
	
	if item_stacks[slot_id] and item_stacks[slot_id].count > 0:
		slots[slot_id].set_sprite(item_stacks[slot_id].item.sprite)
		slots[slot_id].set_count_label(str(item_stacks[slot_id].count))
		
	else:
		slots[slot_id].set_sprite(null)
		slots[slot_id].set_count_label("")
		
func add_item_stack(item_stack):
	item_stacks[item_stack.item.id].count = item_stacks[item_stack.item.id].count + item_stack.count
	update_slot(item_stack.item.id)
	return
	
func remove_item_stack(item_stack):
	item_stacks[item_stack.item.id].count = item_stacks[item_stack.item.id].count - item_stack.count
	update_slot(item_stack.item.id)
	return

func _process(delta):
	if Input.is_action_just_pressed("e"):
		if visible:
			close()
		else:
			pass
			
func open():
	visible = true

func close():
	visible = false
