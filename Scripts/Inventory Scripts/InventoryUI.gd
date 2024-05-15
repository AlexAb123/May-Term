extends GridContainer

class_name Inventory_UI

var selected_item: Item

@export var slot_scene: PackedScene

@export var slot_count: int = 9

var slots: Array[Inventory_UI_Slot] = []
var items: Array[Item]
var counts: Array[int]

func _ready():
	
	for i in slot_count:
		items.append(null)
		counts.append(0)
		
		var new_slot: Inventory_UI_Slot = slot_scene.instantiate()
		new_slot.slot_id = i
		add_child(new_slot)
		
		slots.append(new_slot)
	print(slot_count/columns)
	pivot_offset.x = (16*columns+get_theme_constant("h_separation")*(columns-1))/2
	var tempy = (int(float(slot_count)/columns))
	pivot_offset.y = (16*tempy+get_theme_constant("v_separation")*(tempy-1))/2
	anchors_preset = PRESET_CENTER
	print(pivot_offset)
	
	close()
	
func slot_input_event(slot_id, inputEvent):
	pass
	
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
