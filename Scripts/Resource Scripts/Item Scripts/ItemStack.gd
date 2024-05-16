extends Resource

class_name ItemStack

@export var item: Item = null
@export var count: int = 1

func _init(i: Item, c: int):
	item = i
	count = c
