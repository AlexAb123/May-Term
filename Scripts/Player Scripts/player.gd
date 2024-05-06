extends CharacterBody2D

@export_category("Movement")
@export var moveSpeed = 500

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
