extends CharacterBody2D

@export_category("Movement")
@export var moveSpeed = 500

@onready var furnace : Furnace = owner.get_node("Furnace")

func _physics_process(delta):

	#Get inputs and move up down left and right.
	#Normalize vector so that diagnoal isn't faster
	
	var horizontal = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal
	
	var vertical = Input.get_axis("move_up", "move_down")
	velocity.y = vertical
	
	velocity = velocity.normalized()
	
	velocity = velocity * moveSpeed
	
	move_and_slide()
	
func _process(delta):
	
	if Input.is_action_just_pressed("z"):
		furnace.addItems(load("res://Items/Iron_Ore.tres"), 1)
		
	if Input.is_action_just_pressed("x"):
		furnace.addItems(load("res://Items/Coal.tres"), 1)
		
	if Input.is_action_just_pressed("c"):
		if furnace.selectedRecipe:
			furnace.selectRecipe(-1)
		else:
			furnace.selectRecipe(0)
