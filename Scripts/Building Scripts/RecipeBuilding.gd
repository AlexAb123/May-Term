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
	input_inventory.position.x = input_inventory.position.x + Global.player.inventory_xshift*0.75
	output_inventory.position.x = output_inventory.position.x + Global.player.inventory_xshift*1.25
	select_recipe(0)
	
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

func select_recipe(index: int):
	selected_recipe = recipes[index]
	
	input_inventory.slot_count = selected_recipe.inputItems.size()
	input_inventory.initialize_slots()
	
	output_inventory.slot_count = selected_recipe.outputItems.size()
	output_inventory.initialize_slots()
	
	for item in selected_recipe.inputItems:
		input_inventory.add_item_stack(ItemStack.new(item, 0))

	for item in selected_recipe.outputItems:
		output_inventory.add_item_stack(ItemStack.new(item, 0))


var player_in_range: bool = false

func _on_inventory_reach_body_entered(body):
	player_in_range = true

func _on_inventory_reach_body_exited(body):
	player_in_range = false
	input_inventory.close()
	output_inventory.close()
	Global.player.inventory.close()
