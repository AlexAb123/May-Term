extends GridContainer

class_name Inventory

@onready var slot_scene: PackedScene = preload("res://Scenes/Inventory Scenes/InventorySlot.tscn")

@export var slot_count: int = 9

var slots: Array[InventorySlot] = []
var item_stacks: Array[ItemStack] = []

var xshift = 0

func _ready():
	
	initialize_slots()
		
	#CENTERING THE INVENTORY ON THE SCREEN
	pivot_offset.x = (16*columns+get_theme_constant("h_separation")*(columns-1))/2
	var tempy = (int(float(slot_count)/columns))
	pivot_offset.y = (16*tempy+get_theme_constant("v_separation")*(tempy-1))/2
	anchors_preset = PRESET_CENTER
	
	close()
	
func initialize_slots():
	
	item_stacks = []
	slots = []
	for n in get_children():
		remove_child(n)
		n.queue_free()
		
	for i in slot_count:
		item_stacks.append(null)
		
		var new_slot: InventorySlot = slot_scene.instantiate()
		new_slot.slot_id = i
		add_child(new_slot)
		
		slots.append(new_slot)
	
	update_slots()
	
	var tempy = (int(float(slot_count)/columns))
	pivot_offset.y = (16*tempy+get_theme_constant("v_separation")*(tempy-1))/2

signal slot_input

func slot_input_event(slot_id, event):
	slot_input.emit(slot_id, event)
	if not Input.is_action_just_pressed("shift_left_click") and Input.is_action_just_pressed("left_click"): 
		left_click_slot(slot_id)
	if Input.is_action_just_pressed("right_click"):
		right_click_slot(slot_id)

func left_click_slot(slot_id):
	if owner is Player:
		Global.player.selected_item_stack = item_stacks[slot_id]
		Global.player.update_selected_item_sprite_and_label()
	return
	
func right_click_slot(slot_id):
	pass

func z_pressed(slot_id):
	slot_input.emit(slot_id, null)

func update_slots():

	item_stacks.sort_custom(compare_item_stack_id)
	
	for slot_id in slot_count:
	
		if item_stacks[slot_id] and item_stacks[slot_id].count >= 0:
			slots[slot_id].set_sprite(item_stacks[slot_id].item.sprite)
			slots[slot_id].set_count_label(str(item_stacks[slot_id].count))
		
		else:
			slots[slot_id].set_sprite(null)
			slots[slot_id].set_count_label("")
				
				
		
func compare_item_stack_id(is1: ItemStack, is2: ItemStack):
	if is1 and is2:
		return is1.item.id < is2.item.id
	elif is1 and not is2:
		return true
	elif not is1 and is2:
		return false
	return true
		
func add_item_stack(item_stack):
	var pos = position_in_inventory(item_stack.item)
	if pos != -1:
		item_stacks[pos].count += item_stack.count
		update_slots()
		return
	else:
		for i in item_stacks.size():
			if not item_stacks[i]:
				item_stacks[i] = item_stack
				update_slots()
				return
				
func remove_item_stack(item_stack):
	var pos = position_in_inventory(item_stack.item)
	if pos == -1:
		print("Inventory does not contain item: " + item_stack.item)
		return
	item_stacks[pos].count -= item_stack.count
	update_slots()
	return
func remove_at(slot_id):
	item_stacks[slot_id].count = 0
	update_slots()
	return
	
	
func position_in_inventory(item: Item) -> int:
	for i in item_stacks.size():
		if item_stacks[i] and item_stacks[i].item == item:
			return i
	return -1
	
func amount_in_inventory(item: Item) -> int:
	var pos = position_in_inventory(item)
	if pos == -1:
		return -1
	return item_stacks[pos].count
	
func open():
	visible = true

func close():
	visible = false

func mouse_hovering_slot() -> int:
	for i in slots.size():
		if slots[i].mouse_hover:
			return i
	return -1
