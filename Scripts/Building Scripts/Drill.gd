class_name Drill
extends Building

@onready var output_inventory = $CanvasLayer/OutputInventory
@onready var canvas_layer = $CanvasLayer
@onready var timer: Timer = $Timer

@onready var current_output_sprite = $CurrentOutputSprite
@onready var current_output_count = $CurrentOutputSprite/CurrentOutputCount
@onready var adjacent : Array[RecipeBuilding]

var recipe: Recipe
var selected_recipe: Recipe

func _ready():
	super()
	output_inventory.position.x = output_inventory.position.x + Global.player.inventory_xshift*1
	# have to select here so that its instiatied before trying to call select recipe
	select_recipe(recipe)
	
func check_two_arrays_have_same_values(a1, a2): # Not necessarily in same order
	if a1.size() != a2.size():
		return false
	for i in a1:
		if not i in a2:
			return false
	return true

func distribute_ore():
	var get_adj = BuildingManager.get_adjacent(global_position)
	if not check_two_arrays_have_same_values(get_adj, adjacent):
		adjacent = get_adj

	for building: RecipeBuilding in adjacent:
		if not building.selected_recipe:
			continue
		if output_inventory.item_stacks[0].count <= 0:
			break
		for item_stack in building.selected_recipe.input_item_stacks:
			if output_inventory.item_stacks[0].item == item_stack.item:
				# Then we have an item that the adjacent building needs, add it to the building
				var one_item = ItemStack.new(output_inventory.item_stacks[0].item, output_inventory.item_stacks[0].count)
				building.input_inventory.add_item_stack(one_item)
				output_inventory.remove_item_stack(one_item)
				
	if adjacent.size() >= 1:
		var temp = adjacent[0]
		adjacent.remove_at(0)
		adjacent.append(temp)
		
func _physics_process(delta):
	super(delta)
	
	if right_click_down:
		pass
		
	if player_in_range:
		if left_click_down and Input.is_action_pressed("shift_left_click"):
			if output_inventory.item_stacks and output_inventory.item_stacks[0].count > 0:
				Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[0].item, output_inventory.item_stacks[0].count))
				output_inventory.remove_at(0)
				update_current_output_sprite()
				
		elif left_click_down and Input.is_action_just_pressed("left_click") and not Global.player.selected_item_stack:
			BuildingManager.close_all_open_inventories()
			output_inventory.open()
			BuildingManager.open_inventories.append(output_inventory)
			Global.player.inventory.open()
	
	if Input.is_action_just_pressed("e"):
		output_inventory.close()
		BuildingManager.close_all_open_inventories()
	
	if Input.is_action_just_pressed("detailed_mode"):
		current_output_sprite.visible = not current_output_sprite.visible
	
		
	if selected_recipe and timer.is_stopped():
		start_craft()

func _on_timer_timeout():
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(item_stack)
	start_craft()
	distribute_ore()
	update_current_output_sprite()
	
var player_in_range: bool = false

func _on_inventory_reach_body_entered(_body):
	player_in_range = true

func _on_inventory_reach_body_exited(_body):
	player_in_range = false
	output_inventory.close()

func _on_output_inventory_slot_input(slot_id, _event):
	
	if Input.is_action_just_pressed("shift_left_click"):
		Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[slot_id].item, output_inventory.item_stacks[slot_id].count))
		output_inventory.remove_at(slot_id)
		
	# Remove one item
	elif Input.is_action_just_pressed("right_click"):
		if output_inventory.item_stacks[slot_id] and output_inventory.item_stacks[slot_id].count > 0:
			Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[slot_id].item, 1))
			output_inventory.item_stacks[slot_id].count -= 1
			output_inventory.update_slots()
			
	update_current_output_sprite()

func update_current_output_sprite():
		
	if output_inventory.item_stacks[0]:
		current_output_sprite.texture = output_inventory.item_stacks[0].item.sprite
		current_output_count.text = str(output_inventory.item_stacks[0].count)
	else:
		current_output_sprite.texture = null
		current_output_count.text = ""

func start_craft():
	timer.start()

func destroy():
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	super()
	
func deconstruct():
	for item_stack in output_inventory.item_stacks:
		Global.player.inventory.add_item_stack(item_stack)
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	super()

func select_recipe(curr: Recipe):
	if curr == selected_recipe:
		return
		
	if not timer.is_stopped():
		timer.stop()
		sprite2D.texture = sprite
		for item_stack in selected_recipe.input_item_stacks:
			Global.player.inventory.add_item_stack(item_stack)
			
	selected_recipe = curr
	
	output_inventory.slot_count = selected_recipe.output_item_stacks.size()
	output_inventory.initialize_slots()
	
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(ItemStack.new(item_stack.item, 0))
		
	timer.wait_time = selected_recipe.craftingTime
