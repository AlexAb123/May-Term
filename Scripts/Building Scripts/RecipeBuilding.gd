extends Building

class_name RecipeBuilding

var selectedRecipe : Recipe

var recipes : Array[Recipe]

var inputInventory : Dictionary
var outputInventory : Dictionary

var inProgress = false

func _ready():
	pass

var timeElapsed = 0
func _process(delta):
	
	print(inputInventory)
	print(outputInventory)
	
	#If we are currently crafting then either add to elapsed time or finish crafting if time is up.
	if inProgress:
		
		if timeElapsed > selectedRecipe.craftingTime:
			endCraft()
		else:
			timeElapsed += delta
		
	if !inProgress and enoughResources():
		startCraft()
	
func selectRecipe(recipeIndex : int):
	
	selectedRecipe = recipes[recipeIndex]
	
	#HAVE TO MOVE WHAT WAS IN INVENTORY TO THE PLAYERS INVENTORY
	# OR KEEP THE ITEMS IF YOU SELECT A RECIPE THAT TAKES SAME ITEMS
	# CANT JUST CLEAR THE INVENTORY, THIS IS TEMPORARY SOLUTION
	inputInventory.clear()
	for item in selectedRecipe.inputs:
		inputInventory[item] = 0
		
	outputInventory.clear()
	for item in selectedRecipe.outputs:
		outputInventory[item] = 0

func startCraft():
	inProgress = true
	
	
func endCraft():
	inProgress = false
	timeElapsed = 0
	
func addItems(newItem : Item, count : int):
	#Add items into the building.
	for item in inputInventory:
		inputInventory[item] = inputInventory[item] + count
	
func enoughResources() -> bool:
	#Checks if there are enough resources in inputInventory to satisfy the recipe one time
	for item in inputInventory:
		if inputInventory[item] < selectedRecipe.inputs[item]:
			return false
	return true
	
