extends Resource

class_name Recipe

@export var name : String

@export var craftingTime : float

@export_group("Inputs")
@export var inputItems : Array[Item]
@export var inputAmounts : Array[int]

@export_group("Outputs")
@export var outputItems : Array[Item]
@export var outputAmounts : Array[int]

func _to_string():
	return "RECIPE_" + resource_path.get_file().trim_suffix('.tres')
