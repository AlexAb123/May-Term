extends Resource

class_name Item

@export var name : String
@export var stackSize : int
@export var sprite : Texture2D

func _to_string():
	return "ITEM_" + resource_path.get_file().trim_suffix('.tres')
