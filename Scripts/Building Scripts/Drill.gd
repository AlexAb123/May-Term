class_name Drill
extends Building

@onready var output_inventory = $CanvasLayer/OutputInventory
@onready var canvas_layer = $CanvasLayer
@onready var timer: Timer = $Timer

var recipe: Recipe
var selected_recipe: Recipe

func _ready():
	super()
	output_inventory.position.x = output_inventory.position.x + Global.player.inventory_xshift*1
	print(output_inventory)
	select_recipe(recipe)
	
func _physics_process(delta):
	super(delta)
	
	if right_click_down:
		pass
		
	if player_in_range:
		if left_click_down and not Global.player.selected_item_stack:
			BuildingManager.close_all_open_inventories()
			output_inventory.open()
			BuildingManager.open_inventories.append(output_inventory)
			Global.player.inventory.open()
	
	if Input.is_action_just_pressed("e"):
		output_inventory.close()
		BuildingManager.close_all_open_inventories()
		
	if selected_recipe and timer.is_stopped():
		start_craft()

func _on_timer_timeout():
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(item_stack)
	start_craft()
	
var player_in_range: bool = false

func _on_inventory_reach_body_entered(body):
	player_in_range = true

func _on_inventory_reach_body_exited(body):
	player_in_range = false
	output_inventory.close()

func _on_output_inventory_slot_input(slot_id, event):
	if Input.is_action_just_pressed("shift_left_click"):
		Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[slot_id].item, output_inventory.item_stacks[slot_id].count))
		output_inventory.remove_at(slot_id)
		
	# Remove one item
	elif Input.is_action_just_pressed("right_click"):
		if output_inventory.item_stacks[slot_id] and output_inventory.item_stacks[slot_id].count > 0:
			Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[slot_id].item, 1))
			output_inventory.item_stacks[slot_id].count -= 1
			output_inventory.update_slots()

func start_craft():
	timer.start()

func destroy():
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	super()
	
func deconstruct():
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	super()

func select_recipe(recipe: Recipe):
	if recipe == selected_recipe:
		return
		
	if not timer.is_stopped():
		timer.stop()
		sprite2D.texture = sprite
		for item_stack in selected_recipe.input_item_stacks:
			Global.player.inventory.add_item_stack(item_stack)
			
	selected_recipe = recipe
	
	output_inventory.slot_count = selected_recipe.output_item_stacks.size()
	output_inventory.initialize_slots()
	
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(ItemStack.new(item_stack.item, 0))
		
	timer.wait_time = selected_recipe.craftingTime
