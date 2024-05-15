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
	
	close()
	
func slot_input_event(slot_id, event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				left_click_slot(slot_id)
			if event.button_index == 2:
				right_click_slot(slot_id)

func left_click_slot(slot_id):
	print("left " + str(slot_id))
	
	var selected_item_stack: ItemStack = Global.player.selected_item_stack
	var selected_item_count: int = 0
	var selected_item: Item = null
	if selected_item_stack:
		selected_item_count = Global.player.selected_item_stack.count
		selected_item = Global.player.selected_item_stack.item
	
	#If slot is empty and holding item, place that item into the slot
	if not item_stacks[slot_id] and selected_item:
		item_stacks[slot_id] = selected_item_stack
		Global.player.selected_item_stack = null
		return
	
	#If slot is not empty and holding same item, add that item into the slot
	if item_stacks[slot_id] and item_stacks[slot_id].item == selected_item:
		var remainder = (item_stacks[slot_id].count + selected_item_count) % selected_item.stack_size
		item_stacks[slot_id].count = item_stacks[slot_id].count + selected_item_count - remainder
		if remainder > 0:
			Global.player.selected_item_stack.count = remainder
		else:
			Global.player.selected_item_stack = null
	
	
	update_slot(slot_id)
	
	
func right_click_slot(slot_id):
	print("right " + str(slot_id))
	
func update_slot(slot_id):
	
	if item_stacks[slot_id]:
		slots[slot_id].set_sprite(item_stacks[slot_id].item.sprite)
		slots[slot_id].set_count_label(str(item_stacks[slot_id].count))
		
	else:
		slots[slot_id].set_sprite(null)
		slots[slot_id].set_count_label("")

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
