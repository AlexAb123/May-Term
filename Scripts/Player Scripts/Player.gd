extends CharacterBody2D
class_name Player

signal healthChanged

@export_category("Movement")
@export var max_health = 100
@export var moveSpeed: int = 100
@onready var current_health: int = max_health
@onready var animated_sprite = $AnimatedSprite2D
@onready var selected_item_sprite: Sprite2D = $CanvasLayer2/SelectedItemSprite
@onready var selected_item_label: Label = $CanvasLayer2/SelectedItemSprite/SelectedItemCount
@onready var inventory: Inventory_UI = $CanvasLayer/InventoryUI

var selected_item_stack: ItemStack

var is_deconstructing: bool = false

func _ready():
	Global.set_player(self)
	
	selected_item_sprite.modulate = Color(1, 1, 1, 0.8)

func take_damage(damage):
	current_health -= damage
	healthChanged.emit()
	if current_health <= 0:
		current_health = max_health
		death()
		
func death():
	print("Player Died")

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
	
	if not is_deconstructing:
		move_and_slide()
	
func _process(delta):
	
	var mouse_position: Vector2 = get_global_mouse_position()
	
	selected_item_sprite.global_position.x = get_global_mouse_position().x
	selected_item_sprite.global_position.y = get_global_mouse_position().y
	
	if not inventory.visible and left_click_down:
		if selected_item_stack and selected_item_stack.item is PlaceableItem and not BuildingManager.check_position_occupied(get_global_mouse_position()):
			var building: Building = selected_item_stack.item.buildingScene.instantiate()
			selected_item_stack.count = selected_item_stack.count - 1
			if selected_item_stack.count <= 0:
				selected_item_stack = null
			update_selected_item_sprite_and_label()
			building.global_position = snapped(get_global_mouse_position(), Vector2(16, 16))
			BuildingManager.add_building(building)
			get_owner().add_child(building)
		
		
		
	if Input.is_action_just_pressed("q"):
		set_item_stack(null)
	if Input.is_action_just_pressed("x"):
		set_item_stack(ItemStack.new(Database.item_database["Furnace"], 10))
	if Input.is_action_just_pressed("g"):
		set_item_stack(ItemStack.new(Database.item_database["Archer_Tower"], 10))
	if Input.is_action_just_pressed("y"):
		var enemy = load("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn").instantiate()
		enemy.global_position = mouse_position
		owner.add_child(enemy)
	

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


func set_item_stack(item_stack: ItemStack):
	selected_item_stack = item_stack
	update_selected_item_sprite_and_label()

func set_item_stack_count(count: int):
	selected_item_stack.count = count
	update_selected_item_sprite_and_label()
	
func update_selected_item_sprite_and_label():
	if selected_item_stack:
		selected_item_label.text = str(selected_item_stack.count)
		selected_item_sprite.texture = selected_item_stack.item.sprite
	else:
		selected_item_sprite.texture = null
		selected_item_label.text = ""
