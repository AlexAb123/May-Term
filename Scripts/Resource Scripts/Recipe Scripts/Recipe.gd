extends Resource

class_name Recipe

@export var name : String

@export var craftingTime : float

@export_group("Inputs")
@export var input_item_stacks: Array[ItemStack] = []

@export_group("Outputs")
@export var output_item_stacks: Array[ItemStack] = []

func _to_string():
	return resource_path.get_file().trim_suffix('.tres')

func _init(n: String, ct: float, iis: Array[ItemStack], ois: Array[ItemStack]):
	name = n
	craftingTime = ct
	input_item_stacks = iis
	output_item_stacks = ois
