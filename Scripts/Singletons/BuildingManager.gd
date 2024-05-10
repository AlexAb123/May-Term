extends Node

var buildings: Array[Array]

#How many tiles can we can have in the map. If this is 100, then the map is 100x100 tiles
const map_size: int = 100 #DO NOT GO TOO HIGH -- 1000 SHOULD BE MAXIMUM

func _ready():
	for i in map_size:
		var temp: Array = []
		for j in map_size:
			temp.append(null)
		buildings.append(temp)

func _process(delta):
	print(Engine.get_frames_per_second())
	
func get_building(pos: Vector2) -> Building:
	#Pos is an unsnapped position in world coordinates
	var i = snapped(pos.x, 16)/16+map_size/2
	var j = snapped(pos.y, 16)/16+map_size/2
	
	if i < 0 or i > buildings.size()-1 or j < 0 or j > buildings.size()-1:
		print("ERROR: BuildingManager: Tried to get_building outside of map limits")
		return
		
	return buildings[i][j]

func add_building(building: Building):
	var i = snapped(building.global_position.x, 16)/16+map_size/2
	var j = snapped(building.global_position.y, 16)/16+map_size/2
	
	if i < 0 or i > buildings.size()-1 or j < 0 or j > buildings.size()-1:
		print("ERROR: BuildingManager: Tried to add_building outside of map limits")
		return
		
	buildings[i][j] = building

func remove_building(building: Building):
	var i = snapped(building.global_position.x, 16)/16+map_size/2
	var j = snapped(building.global_position.y, 16)/16+map_size/2
	
	if i < 0 or i > buildings.size()-1 or j < 0 or j > buildings.size()-1:	
		print("ERROR: BuildingManager: Tried to remove_building outside of map limits")
		return
		
	buildings[i][j] = null
	
func check_position_occupied(pos: Vector2) -> bool:
	#Pos is an unsnapped position in world coordinates 
	var i = snapped(pos.x, 16)/16+map_size/2
	var j = snapped(pos.y, 16)/16+map_size/2
	
	if i < 0 or i > buildings.size()-1 or j < 0 or j > buildings.size()-1:
		print("ERROR: BuildingManager: Tried to check_position_occupied outside of map limits")
		return true
		
	return buildings[i][j] != null
