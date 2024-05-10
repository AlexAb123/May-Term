extends Node

var buildings: Array[Array]
var map_size = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 100:
		var temp: Array = []
		for j in 100:
			temp.append(null)
		buildings.append(temp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_building(pos: Vector2) -> Building:
	#Pos is an unsnapped position in world coordinates
	return buildings[snapped(pos.x, 16)/16+map_size/2][snapped(pos.y, 16)/16+map_size/2]

func add_building(building: Building):
	buildings[snapped(building.global_position.x, 16)/16+map_size/2][snapped(building.global_position.y, 16)/16+map_size/2] = building

func remove_building(building: Building):
	buildings[snapped(building.global_position.x, 16)/16+map_size/2][snapped(building.global_position.y, 16)/16+map_size/2] = null

	
func check_position_occupied(pos: Vector2) -> bool:
	#Pos is an unsnapped position in world coordinates 
	return buildings[snapped(pos.x, 16)/16+map_size/2][snapped(pos.y, 16)/16+map_size/2] != null
