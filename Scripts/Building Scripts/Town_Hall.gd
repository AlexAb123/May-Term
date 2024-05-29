class_name TownHall

extends RecipeBuilding

func _ready():
	super()
	BuildingManager.add_building(self)
	
	# Have to take up 4 tiles, 2x2
	var b1 = Building.new()
	b1.global_position = global_position + Vector2(16,0)
	var b2 = Building.new()
	b2.global_position = global_position + Vector2(0,16)
	var b3 = Building.new()
	b3.global_position = global_position + Vector2(16,16)
	BuildingManager.add_building(b1)
	BuildingManager.add_building(b2)
	BuildingManager.add_building(b3)
	
	
func _physics_process(delta):
	super(delta)

func deconstruct():
	return

signal town_hall_destroyed
func destroy():
	print("town hall destroyed")
	town_hall_destroyed.emit()
	super()
