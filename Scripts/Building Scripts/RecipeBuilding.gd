extends Building

class_name RecipeBuilding

@export var recipes : Array
var selectedRecipe : Recipe


var inProgress = false

	
func _ready():
	pass

var timeElapsed = 0
func _process(delta):
	
	#If we are currently crafting then either add to elapsed time or finish crafting if time is up.
	if inProgress:
		
		if timeElapsed > selectedRecipe.craftingTime:
			endCraft()
		else:
			timeElapsed += delta
		
	if !inProgress and enoughResources():
		startCraft()
	

func startCraft():
	inProgress = true
	
	
func endCraft():
	inProgress = false
	timeElapsed = 0
	
func addItems(item : Item, count : int):
	#Add items into the building
	pass
	
func enoughResources():
	#CHECK IF WE HAVE ENOUGH RESOURCES TO START CRAFTING THE SELECTED RECIPE
	pass
	
	
