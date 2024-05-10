extends CharacterBody2D

@export_category("Movement")
@export var moveSpeed = 150
@onready var animated_sprite = $AnimatedSprite2D
@onready var selected_item_sprite: Sprite2D = $SelectedItemSprite

@export var selected_item: Item

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
	selected_item_sprite.global_position.x = snapped(get_global_mouse_position().x, 16)
	selected_item_sprite.global_position.y = snapped(get_global_mouse_position().y, 16)
	if Input.is_action_just_pressed("z"):
		select_item(null)
	if Input.is_action_just_pressed("x"):
		select_item(Database.item_database["Furnace"])
	
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if left_click_down:
		if selected_item is PlaceableItem and not BuildingManager.check_position_occupied(get_global_mouse_position()):
			var building: Building = selected_item.buildingScene.instantiate()
			building.global_position = snapped(get_global_mouse_position(), Vector2(16, 16))
			BuildingManager.add_building(building)
			BuildingManager.add_building(building)
			get_owner().add_child(building)
	
func select_item(new_item: Item):
	selected_item = new_item
	if new_item:
		selected_item_sprite.texture = selected_item.sprite
	else:
		selected_item_sprite.texture = null

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				_on_left_click_pressed()
			if event.button_index == 2:
				_on_right_click_pressed()
		else:
			if event.button_index == 1:
				_on_left_click_released()
			if event.button_index == 2:
				_on_right_click_released()
				
var left_click_down = false
var right_click_down = false

func _on_left_click_pressed():
	left_click_down = true
	
func _on_left_click_released():
	left_click_down = false
	
func _on_right_click_pressed():
	right_click_down = true

func _on_right_click_released():
	right_click_down = false
