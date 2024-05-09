extends Building

class_name RecipeBuilding

@export var recipes : Array[Recipe]

var selectedRecipe : Recipe

var inputInventoryItems : Array[Item]
var inputInventoryAmounts : Array[int]

var outputInventoryItems : Array[Item]
var outputInventoryAmounts : Array[int]

var inProgress = false


var timer = 0
var timeElapsed = 0
func process(delta):
	
	timer += delta
	if timer > 1:
		#DEBUGGING
		print("Input Items:", inputInventoryItems)
		print("Input Amounts:", inputInventoryAmounts)
		print()
		print("Output Items:", outputInventoryItems)
		print("Output Amounts:", outputInventoryAmounts)
		print()
		print("Selected Recipe:", selectedRecipe)
		print("In Progress:", inProgress)
		print()
		print("Have enough:", haveEnoughResources())
		print()
		print("------------------------------------------")
		#DEBUGGING
		timer = 0
	
	
	if selectedRecipe == null:
		return
	
	#If we are currently crafting then either add to elapsed time or finish crafting if time is up.
	if inProgress:
		
		if timeElapsed > selectedRecipe.craftingTime:
			endCraft()
		else:
			timeElapsed += delta
		
	if !inProgress and haveEnoughResources():
		startCraft()
	
func selectRecipe(recipeIndex : int):
	
	#HAVE TO MOVE WHAT WAS IN INVENTORY TO THE PLAYERS INVENTORY
	# OR KEEP THE ITEMS IF YOU SELECT A RECIPE THAT TAKES SAME ITEMS
	# CANT JUST CLEAR THE INVENTORY, THIS IS TEMPORARY SOLUTION

	inputInventoryItems.clear()
	inputInventoryAmounts.clear()
	
	outputInventoryItems.clear()
	outputInventoryAmounts.clear()
	
	#------------------------------
	
	if recipeIndex == -1:
		selectedRecipe = null
		return
		
	selectedRecipe = recipes[recipeIndex]
	
	for item in selectedRecipe.inputItems:
		inputInventoryItems.append(item)
		inputInventoryAmounts.append(0)
		
	for item in selectedRecipe.outputItems:
		outputInventoryItems.append(item)
		outputInventoryAmounts.append(0)

func startCraft():
	inProgress = true
	for i in len(inputInventoryAmounts):
		inputInventoryAmounts[i] = inputInventoryAmounts[i] - selectedRecipe.inputAmounts[i]
	
func endCraft():
	inProgress = false
	for i in len(outputInventoryAmounts):
		outputInventoryAmounts[i] = outputInventoryAmounts[i] + selectedRecipe.outputAmounts[i]
	timeElapsed = 0
	
func addItems(newItem : Item, count : int):
	#Add items into the building.
	print("add: ", newItem)
	for i in len(inputInventoryItems):
		if inputInventoryItems[i] == newItem:
			inputInventoryAmounts[i] = inputInventoryAmounts[i] + count
	
func haveEnoughResources() -> bool:
	#Checks if there are enough resources in inputInventory to satisfy the recipe one time
	for i in len(inputInventoryItems):
		if inputInventoryAmounts[i] < selectedRecipe.inputAmounts[i]:
			return false
	return true
	
