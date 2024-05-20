extends Resource

class_name ItemStack

@export var item: Item = null
@export var count: int = 1

func _init(i: Item = null, c: int = 0):
	item = i
	count = c

func _to_string():
	print(item._to_string() + " " + str(count))
