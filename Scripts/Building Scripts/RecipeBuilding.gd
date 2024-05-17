extends Building

class_name RecipeBuilding

@export var recipes : Array[Recipe]

@onready var timer: Timer = $Timer

@export var on_sprite: Texture2D

@onready var inventory: Recipe_Building_Inventory_UI = $CanvasLayer/InventoryUI

var selectedRecipe : Recipe

func _ready():
	super()
	#selectRecipe(0)
func _physics_process(delta):
	super(delta)
	
	if right_click_down:
		pass
	if left_click_down and not Global.player.selected_item_stack:
		inventory.open()
		Global.player.inventory.open()
		
	
	#if haveEnoughResources():
		#for i in selectedRecipe.inputItems.size():
			#inventory.remove_item_stack(ItemStack.new(selectedRecipe.inputItems[i], selectedRecipe.inputAmounts[i]))
		#timer.start()
		
		
func selectRecipe(recipeIndex : int):
	
	if recipeIndex == -1:
		selectedRecipe = null
		return
	selectedRecipe = recipes[recipeIndex]
	
	var sc = selectedRecipe.inputItems.size() + selectedRecipe.outputItems.size()
	inventory.columns = sc
	inventory.slot_count = sc
	inventory.initialize()
	
	for i in selectedRecipe.inputItems.size():
		inventory.add_item_stack(ItemStack.new(selectedRecipe.inputItems[i], 0))
	
	for i in inventory.slots.size():
		inventory.update_slot(i)


func haveEnoughResources():
	return true


func _on_timer_timeout():
	for i in selectedRecipe.outputItems.size():
		inventory.add_item_stack(ItemStack.new(selectedRecipe.outputItems[i], selectedRecipe.outputAmounts[i]))
