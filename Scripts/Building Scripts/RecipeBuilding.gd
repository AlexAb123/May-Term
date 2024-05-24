extends Building

class_name RecipeBuilding

@export var recipes : Array[Recipe]

@onready var timer: Timer = $Timer

@onready var sprite_2d = $Sprite2D
@onready var input_inventory: Inventory = $CanvasLayer/InputInventory
@onready var output_inventory: Inventory = $CanvasLayer/OutputInventory
@onready var recipe_selector = $CanvasLayer/RecipeSelector
@onready var open_recipe_selector_button = $CanvasLayer/OpenRecipeSelector
@onready var canvas_layer = $CanvasLayer
@onready var recipe_description: Label = $CanvasLayer/OpenRecipeSelector/RecipeDescription
@onready var current_output_sprite = $CurrentOutputSprite
@onready var current_output_count = $CurrentOutputSprite/CurrentOutputCount

@export var on_sprite: Texture2D

var selected_recipe : Recipe

func _ready():
	super()
	
	Global.player.inventory.slot_input.connect(_on_player_inventory_slot_input)
	
	input_inventory.position.x = input_inventory.position.x + Global.player.inventory_xshift*0.75
	output_inventory.position.x = output_inventory.position.x + Global.player.inventory_xshift*1.25
	
	recipe_selector.position.x = recipe_selector.position.x +  Global.player.inventory_xshift*1
	recipe_selector.slot_count = recipes.size()
	recipe_selector.initialize_slots()
	
	
	for recipe in recipes:
		recipe_selector.add_item_stack(ItemStack.new(recipe, 1))
		
	for slot in recipe_selector.slots:
		slot.itemCountLabel.visible = false
		
		
func _physics_process(delta):

	super(delta)
	input_inventory.update_slots()
	output_inventory.update_slots()
	
	if right_click_down:
		pass
		
	if player_in_range:
		if left_click_down and Input.is_action_just_pressed("shift_left_click"):
			if output_inventory.item_stacks and output_inventory.item_stacks[0].count > 0:
				Global.player.inventory.add_item_stack(ItemStack.new(output_inventory.item_stacks[0].item, output_inventory.item_stacks[0].count))
				output_inventory.remove_at(0)
				update_current_output_sprite()
			
			
		elif left_click_down and Input.is_action_just_pressed("left_click") and not Global.player.selected_item_stack:
			BuildingManager.close_all_open_inventories()
			input_inventory.open()
			BuildingManager.open_inventories.append(input_inventory)
			output_inventory.open()
			BuildingManager.open_inventories.append(output_inventory)
			Global.player.inventory.open()
			open_recipe_selector_button.visible = true
	
	if Input.is_action_just_pressed("e"):
		input_inventory.close()
		output_inventory.close()
		BuildingManager.close_all_open_inventories()
		open_recipe_selector_button.visible = false
		
	if Input.is_action_just_pressed("detailed_mode"):
		current_output_sprite.visible = not current_output_sprite.visible
	
	if selected_recipe and timer.is_stopped() and has_enough_resources():
		start_craft()
		
func select_recipe(recipe: Recipe):
	
	if recipe == selected_recipe:
		return
	
	
	for stack in input_inventory.reset_and_return_stacks():
		Global.player.inventory.add_item_stack(stack)
		
	for stack in output_inventory.reset_and_return_stacks():
		Global.player.inventory.add_item_stack(stack)
		
	if not timer.is_stopped():
		timer.stop()
		sprite2D.texture = sprite
		for item_stack in selected_recipe.input_item_stacks:
			Global.player.inventory.add_item_stack(item_stack)
			
	selected_recipe = recipe
	
	input_inventory.slot_count = selected_recipe.input_item_stacks.size()
	input_inventory.initialize_slots()
	
	output_inventory.slot_count = selected_recipe.output_item_stacks.size()
	output_inventory.initialize_slots()
	
	for item_stack in selected_recipe.input_item_stacks:
		input_inventory.add_item_stack(ItemStack.new(item_stack.item, 0))

	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(ItemStack.new(item_stack.item, 0))
		
	timer.wait_time = selected_recipe.craftingTime
	
	var string = "Inputs:"
	for stack in selected_recipe.input_item_stacks:
		string += "\n" + str(stack.count) + " " + stack.item.name 
	
	string += "\n\nOutputs:"
	for stack in selected_recipe.output_item_stacks:
		string += "\n" + str(stack.count) + " " + stack.item.name 
	
	recipe_description.text = string
	

func start_craft():
	sprite_2d.texture = on_sprite
	timer.start()
	for its in selected_recipe.input_item_stacks:
		input_inventory.remove_item_stack(its)

func _on_timer_timeout():
	for item_stack in selected_recipe.output_item_stacks:
		output_inventory.add_item_stack(item_stack)
	update_current_output_sprite()
	
	if has_enough_resources():
		start_craft()
	else:
		sprite_2d.texture = sprite
		timer.stop()

func has_enough_resources():
	for item_stack in selected_recipe.input_item_stacks:
		if input_inventory.amount_in_inventory(item_stack.item) < item_stack.count:
			return false
	return true

func _on_input_inventory_slot_input(slot_id, _event):
	if Input.is_action_just_pressed("shift_left_click"):
		Global.player.inventory.add_item_stack(input_inventory.item_stacks[slot_id])
		input_inventory.remove_at(slot_id)
	
	# Remove one item
	elif Input.is_action_just_pressed("right_click"):
		if input_inventory.item_stacks[slot_id] and input_inventory.item_stacks[slot_id].count > 0:
			Global.player.inventory.add_item_stack(ItemStack.new(input_inventory.item_stacks[slot_id].item, 1))
			input_inventory.item_stacks[slot_id].count -= 1
			input_inventory.update_slots()

		
func update_current_output_sprite():
		
	if output_inventory.item_stacks[0]:
		current_output_sprite.texture = output_inventory.item_stacks[0].item.sprite
		current_output_count.text = str(output_inventory.item_stacks[0].count)
	else:
		current_output_sprite.texture = null
		current_output_count.text = ""
			
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

func _on_player_inventory_slot_input(slot_id, _event):
	#If inventories are not open, don't take any input from the player
	if not input_inventory.visible and not output_inventory.visible:
		return
		
	# Ad the full stack to the input inventory
	var clicked_item_stack = Global.player.inventory.item_stacks[slot_id]
	if clicked_item_stack and Input.is_action_just_pressed("shift_left_click"):
		if input_inventory.position_in_inventory(clicked_item_stack.item) != -1:
			input_inventory.add_item_stack(clicked_item_stack)
			Global.player.inventory.remove_at(slot_id)
			Global.player.update_selected_item_sprite_and_label()
	
	# Add one item to the input inventory
	elif Input.is_action_just_pressed("right_click"):
		if clicked_item_stack and clicked_item_stack.count > 0 and input_inventory.position_in_inventory(clicked_item_stack.item) != -1:
			input_inventory.add_item_stack(ItemStack.new(clicked_item_stack.item, 1))
			Global.player.inventory.remove_item_stack(ItemStack.new(clicked_item_stack.item, 1))
			Global.player.update_selected_item_sprite_and_label()

var player_in_range: bool = false

func _on_inventory_reach_body_entered(_body):
	player_in_range = true

func _on_inventory_reach_body_exited(_body):
	player_in_range = false
	input_inventory.close()
	output_inventory.close()
	recipe_selector.close()
	open_recipe_selector_button.visible = false

func destroy():
	input_inventory.close()
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	open_recipe_selector_button.visible = false
	super()
	
func deconstruct():
	for item_stack in input_inventory.item_stacks:
		Global.player.inventory.add_item_stack(item_stack)
	for item_stack in output_inventory.item_stacks:
		Global.player.inventory.add_item_stack(item_stack)
	input_inventory.close()
	output_inventory.close()
	BuildingManager.close_all_open_inventories()
	open_recipe_selector_button.visible = false
	super()

func _on_recipe_selector_slot_input(slot_id, _event):
	if Input.is_action_just_pressed("left_click"):
		select_recipe(recipe_selector.item_stacks[slot_id].item)
		recipe_selector.close()
		input_inventory.open()
		output_inventory.open()
		open_recipe_selector_button.visible = true

func _on_open_recipe_selector_pressed():
	
	if input_inventory.visible:
		BuildingManager.open_inventories.append(recipe_selector)
		recipe_selector.open()
		input_inventory.close()
		output_inventory.close()
		open_recipe_selector_button.visible = false
		
	elif not input_inventory.visible:
		recipe_selector.close()
		input_inventory.open()
		output_inventory.open()
		open_recipe_selector_button.visible = true
		
func _on_input_inventory_closed():
	open_recipe_selector_button.visible = false
