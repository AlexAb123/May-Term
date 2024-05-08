extends Node2D

@export var furnace_item: PlaceableItem
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("g"):
		#print("instance")
		#var new = furnace_item.buildingScene.instantiate()
		#new.position
		#add_child(new)
		print(Database.item_database["Coal"])
