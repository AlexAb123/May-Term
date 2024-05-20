extends Resource

class_name Item

@export var name : String
@export var sprite : Texture2D
@export var id: int

func _to_string():
	return resource_path.get_file().trim_suffix('.tres')

func _init(n: String = "", s: Texture2D = null, i: int = -1):
	name = n
	sprite = s
	id = i
