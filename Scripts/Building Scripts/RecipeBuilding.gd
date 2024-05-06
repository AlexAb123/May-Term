extends Building

class_name RecipeBuilding

var selectedRecipe : Recipe

var recipes : Array[Recipe]

var inputInventoryItems : Array[Item]
var inputInventoryAmounts : Array[int]

var outputInventoryItems : Array[Item]
var outputInventoryAmounts : Array[int]

var inProgress = false

func _ready():
	pass

var timeElapsed = 0
func _process(delta):
	
	print(inputInventoryItems)
	print(inputInventoryAmounts)
	
	print(outputInventoryItems)
	print(outputInventoryAmounts)
	
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
	inputInventoryItems.clear()
	inputInventoryAmounts.clear()
	for item in selectedRecipe.inputItems:
		inputInventoryItems.append(item)
		inputInventoryAmounts.append(0)
		
	outputInventoryItems.clear()
	outputInventoryAmounts.clear()
	for item in selectedRecipe.outputItems:
		outputInventoryItems.append(item)
		outputInventoryAmounts.append(0)

func startCraft():
	inProgress = true
	
	
func endCraft():
	inProgress = false
	timeElapsed = 0
	
func addItems(newItem : Item, count : int):
	#Add items into the building.
	for i in len(inputInventoryItems):
		if inputInventoryItems[i] == newItem:
			inputInventoryAmounts[i] = inputInventoryAmounts[i] + count
	
func enoughResources() -> bool:
	#Checks if there are enough resources in inputInventory to satisfy the recipe one time
	for i in len(inputInventoryItems):
		if inputInventoryAmounts[i] < selectedRecipe.inputsAmounts[i]:
			return false
	return true
	
