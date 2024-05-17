extends Building

class_name RecipeBuilding

@export var recipes : Array[Recipe]

@onready var timer: Timer = $Timer

@export var on_sprite: Texture2D

@onready var input_inventory: Inventory = $CanvasLayer/InputInventory
@onready var output_inventory: Inventory = $CanvasLayer/OutputInventory

var selected_recipe : Recipe

func _ready():
	super()
	
	input_inventory.slot_input.connect(_on_input_inventory_slot_input)
	output_inventory.slot_input.connect(_on_output_inventory_slot_input)
	Global.player.inventory.slot_input.connect(_on_player_inventory_slot_input)
	
	input_inventory.position.x = input_inventory.position.x + Global.player.inventory_xshift*0.75
	output_inventory.position.x = output_inventory.position.x + Global.player.inventory_xshift*1.25
	select_recipe(0)


var time_elapsed: float = 0
func _physics_process(delta):
	super(delta)
	
	
	if right_click_down:
		pass
		
	if player_in_range:
		if left_click_down and not Global.player.selected_item_stack:
			input_inventory.open()
			output_inventory.open()
			Global.player.inventory.open()
	
	if Input.is_action_just_pressed("e"):
		input_inventory.close()
		output_inventory.close()
	
	
	if timer.is_stopped() and _has_enough_resources():
		for item_stack in selected_recipe.input_item_stacks:
			input_inventory.item_stacks[input_inventory.position_in_inventory(item_stack.item)].count -= item_stack.count
		input_inventory.update_slots()

func select_recipe(index: int):
	print(recipes[0].name)
	print(recipes[0].craftingTime)
	selected_recipe = recipes[index]
	print(selected_recipe.input_item_stacks)
	input_inventory.slot_count = selected_recipe.input_item_stacks.size()
	input_inventory.initialize_slots()
	
	output_inventory.slot_count = selected_recipe.output_item_stacks.size()
	output_inventory.initialize_slots()
	
	for item_stack in selected_recipe.input_item_stacks:
		input_inventory.add_item_stack(item_stack)

	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(item_stack)
		
	timer.wait_time = selected_recipe.craftingTime

func _on_timer_timeout():
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(item_stack)

func _has_enough_resources():
	for item_stack in selected_recipe.input_item_stacks:
		if input_inventory.amount_in_inventory(item_stack.item) < item_stack.count:
			return false
	return true
	

func _on_input_inventory_slot_input(slot_id, event):
	if Input.is_action_just_pressed("shift_left_click"):
		Global.player.inventory.add_item_stack(ItemStack.new(input_inventory.item_stacks[slot_id].item, input_inventory.item_stacks[slot_id].count))
		input_inventory.item_stacks[slot_id].count = 0
		input_inventory.update_slots()
		
func _on_output_inventory_slot_input(slot_id, event):
	if Input.is_action_just_pressed("shift_left_click"):
		Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[slot_id].item, output_inventory.item_stacks[slot_id].count))
		output_inventory.item_stacks[slot_id].count = 0
		output_inventory.update_slots()
		
func _on_player_inventory_slot_input(slot_id, event):
	var clicked_item_stack = Global.player.inventory.item_stacks[slot_id]

	if clicked_item_stack and Input.is_action_just_pressed("shift_left_click"):
		if input_inventory.position_in_inventory(clicked_item_stack.item) != -1:
			input_inventory.add_item_stack(clicked_item_stack)
			input_inventory.update_slots()
			Global.player.inventory.item_stacks[slot_id] = null
			Global.player.inventory.update_slots()


var player_in_range: bool = false

func _on_inventory_reach_body_entered(body):
	player_in_range = true

func _on_inventory_reach_body_exited(body):
	player_in_range = false
	input_inventory.close()
	output_inventory.close()


