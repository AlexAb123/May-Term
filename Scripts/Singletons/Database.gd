extends Node

var item_database: Dictionary
var item_directory = "res://Resources/Items/"

var enemy_database: Dictionary
var enemy_directory = "res://Scenes/Enemy Scenes/"

# Called when the node enters the scene tree for the first time.
func _ready():
	item_database = read_files(item_directory, "ITEM_", ".tres")
	enemy_database = read_files(enemy_directory, "", ".tscn")
	print(item_database)
	print(enemy_database)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func read_files(directory: String, prefix: String, suffix: String):
	var database = {}
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				pass
			else:
				#print("Found file: " + file_name)
				database[file_name.trim_prefix(prefix).trim_suffix(suffix)] = load(directory + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("DATABASE SINGLETON: An error occurred when trying to access path " + directory)
		
	return database
