extends Resource

class_name Item

@export var name : String
@export var sprite : Texture2D
@export var id: int

func _to_string():
	return resource_path.get_file().trim_suffix('.tres')
