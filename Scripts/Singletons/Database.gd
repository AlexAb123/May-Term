extends Node

var item_database: Dictionary
var item_id_database: Array
var item_directory = "res://Resources/Items/"

var enemy_id_database: Array
var enemy_database: Dictionary
var enemy_directory = "res://Scenes/Enemy Scenes/"

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = read_files(item_directory, "ITEM_", ".tres")
	item_database = i[0]
	item_id_database = i[1]
	var e = read_files(enemy_directory, "", ".tscn")
	item_database = i[0]
	item_id_database = i[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#Returns a dictionary. {Item_Name : [Item_File, Item_id]
func read_files(directory: String, prefix: String, suffix: String):
	
	var database = {}
	var id_database = []
	
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				print("Found file: " + file_name)
				var item: Item = load(directory + file_name)
				database[file_name.trim_prefix(prefix).trim_suffix(suffix)] = [item, item.id]
				id_database.append(load(directory + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("DATABASE SINGLETON: An error occurred when trying to access path " + directory)
		
	id_database.sort_custom(compare_item_id)
	return [database, id_database]

func compare_item_id(item1, item2):
	return item1.id < item2.id
