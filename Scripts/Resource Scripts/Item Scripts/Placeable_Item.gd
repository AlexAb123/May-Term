extends Item

class_name PlaceableItem

@export var buildingScene : PackedScene

func _init(n: String = "", s: Texture2D = null, i: int = -1, scene: PackedScene = null):
	name = n
	sprite = s
	id = i
	buildingScene = scene
