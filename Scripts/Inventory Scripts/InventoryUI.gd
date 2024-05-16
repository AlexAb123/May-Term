extends GridContainer

class_name Inventory_UI

@export var slot_scene: PackedScene

@export var slot_count: int = 9

var slots: Array[Inventory_UI_Slot] = []
var item_stacks: Array[ItemStack] = []

func _ready():
	
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
	
	for i in Database.item_id_database.size():
		item_stacks[i] = ItemStack.new(Database.item_id_database[i], 0)
	
	for i in slot_count:
		update_slot(i)
	
	
	close()
	
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
	#var selected_item_stack: ItemStack = Global.player.selected_item_stack
	#var selected_item_count: int = 0
	#var selected_item: Item = null
	#if selected_item_stack:
		#selected_item_count = Global.player.selected_item_stack.count
		#selected_item = Global.player.selected_item_stack.item
	#
	##If slot is empty and holding item, place that item into the slot
	#if not item_stacks[slot_id] and selected_item:
		#item_stacks[slot_id] = selected_item_stack
		#Global.player.set_item_stack(null)
	#
	##If slot is not empty and holding same item, add that item into the slot
	#elif item_stacks[slot_id] and item_stacks[slot_id].item == selected_item:
		#var total_count: int = item_stacks[slot_id].count + selected_item_count
		#var remainder = total_count % selected_item.stack_size
		#
		#if total_count < selected_item.stack_size:
			#item_stacks[slot_id].count = remainder
			#Global.player.set_item_stack(null)
			#
		#elif total_count > selected_item.stack_size:
			#item_stacks[slot_id].count = total_count - remainder
			#Global.player.set_item_stack_count(remainder)
		#
		#elif total_count == selected_item.stack_size:
			#item_stacks[slot_id].count = total_count
			#Global.player.set_item_stack(null)
		#
			#
	##If slot is not empty and not holding item, pick up the item
	#elif item_stacks[slot_id] and not selected_item_stack:
		#Global.player.set_item_stack(item_stacks[slot_id])
		#item_stacks[slot_id] = null
	#
	#update_slot(slot_id)
	#compress_and_stack()
	#
func right_click_slot(slot_id):
	pass
	#
	#var selected_item_stack: ItemStack = Global.player.selected_item_stack
	#var selected_item_count: int = 0
	#var selected_item: Item = null
	#
	#if selected_item_stack:
		#selected_item_count = Global.player.selected_item_stack.count
		#selected_item = Global.player.selected_item_stack.item
		#
	##If slot is not empty and hand is empty, split the stack into hand
	#if item_stacks[slot_id] and not selected_item_stack:
		#var inv_count = item_stacks[slot_id].count / 2
		#Global.player.set_item_stack(ItemStack.new(item_stacks[slot_id].item, item_stacks[slot_id].count - inv_count))
		#if inv_count > 0:
			#item_stacks[slot_id].count = inv_count
		#else:
			#item_stacks[slot_id] = null
		#
	#update_slot(slot_id)
	#compress_and_stack()
	#
	#
	#
#func compress_and_stack():
	#
		#
	#for i in range(item_stacks.size()-2,-1,-1):
		#print(i)
		#if item_stacks[i] and item_stacks[i+1] and item_stacks[i].item == item_stacks[i+1].item:
			#var combined = combine_stack(item_stacks[i], item_stacks[i+1])
			#item_stacks[i] = combined[0]
			#item_stacks[i+1] = combined[1]
		#elif not item_stacks[i] and item_stacks[i+1]:
			#item_stacks[i] = item_stacks[i+1]
			#item_stacks[i+1] = null
		#
		#
	#for i in slots.size():
		#update_slot(i)
		#
	#
#
		#
#func combine_stack(s1: ItemStack, s2: ItemStack):
	#
	#var total: int = s1.count + s2.count
	#var r1: ItemStack
	#var r2: ItemStack
	#if total <= s1.item.stack_size:
		#r2 = null
		#r1 = ItemStack.new(s1.item, total)
	#else:
		#r1 = ItemStack.new(s1.item, s1.item.stack_size)
		#r2 = ItemStack.new(s1.item, total-s1.item.stack_size)
	#
	#return [r1, r2]
	
func update_slot(slot_id):
	
	if item_stacks[slot_id]:
		slots[slot_id].set_sprite(item_stacks[slot_id].item.sprite)
		slots[slot_id].set_count_label(str(item_stacks[slot_id].count))
		
	else:
		slots[slot_id].set_sprite(null)
		slots[slot_id].set_count_label("")
		
func add_item_stack(item_stack):
	for i in item_stacks.size():
		if item_stacks[i].item == item_stack.item:
			item_stacks[i].count = item_stacks[i].count + item_stack.count
			update_slot(i)
			return

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
