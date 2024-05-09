extends Node2D

var recipeBuildings : Array[RecipeBuilding]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for recipeBuilding in recipeBuildings:
		recipeBuilding.process(delta)

func addRecipeBuilding(recipeBuilding : RecipeBuilding):
	recipeBuildings.append(recipeBuilding)
