extends CharacterBody2D

@export_category("Movement")
@export var moveSpeed = 150
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):

	#Get inputs and move up down left and right.
	#Normalize vector so that diagonal isn't faster
	
	var horizontal = Input.get_axis("move_left", "move_right")
	velocity.x = horizontal
	
	var vertical = Input.get_axis("move_up", "move_down")
	velocity.y = vertical
	
	velocity = velocity.normalized()
	
	velocity = velocity * moveSpeed
	
	#flip sprite
	if horizontal > 0:
		animated_sprite.flip_h = false
	elif horizontal < 0:
		animated_sprite.flip_h = true
	
	#play run vs idle animation
	if velocity.length() == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")
	
	move_and_slide()
	
func _process(delta):
	
	#if Input.is_action_just_pressed("z"):
		#furnace.addItems(load("res://Items/Iron_Ore.tres"), 1)
		#
	#if Input.is_action_just_pressed("x"):
		#furnace.addItems(load("res://Items/Coal.tres"), 1)
		#
	#if Input.is_action_just_pressed("c"):
		#if furnace.selectedRecipe:
			#furnace.selectRecipe(-1)
		#else:
			#furnace.selectRecipe(0)
	pass
