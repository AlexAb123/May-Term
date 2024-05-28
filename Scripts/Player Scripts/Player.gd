extends CharacterBody2D
class_name Player

signal healthChanged

@export var max_health = 100
@export var moveSpeed: int = 100
@onready var current_health: int = max_health
@export var inventory_reach_distance: int = 10
@onready var animated_sprite = $AnimatedSprite2D
@onready var selected_item_sprite: Sprite2D = $CanvasLayer2/SelectedItemSprite
@onready var selected_item_label: Label = $CanvasLayer2/SelectedItemSprite/SelectedItemCount
@onready var inventory: Inventory = $CanvasLayer/Inventory
@onready var tile_map: TileMap = $"../../TileMap"

var is_detailed_mode_on: bool = true

@export var drill_mining_time: int = 2

var selected_item_stack: ItemStack

var is_deconstructing: bool = false

var inventory_xshift

func _ready():
	Global.set_player(self)
	healthChanged.emit()
	
	inventory_xshift = (16*inventory.columns+inventory.get_theme_constant("h_separation")*(inventory.columns-1))*3
	inventory.position.x = inventory.position.x - inventory_xshift
	selected_item_sprite.modulate = Color(1, 1, 1, 0.8)
	


func take_damage(damage):
	current_health -= damage
	healthChanged.emit()
	if current_health <= 0:
		current_health = max_health
		death()
		
func death():
	print("Player Died")

func _physics_process(_delta):
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
	
func _process(_delta):
	
	var mouse_position: Vector2 = get_global_mouse_position() - Vector2(8,8)
	
	selected_item_sprite.global_position = mouse_position + Vector2(8,8)

	attempt_place_building()
	
	if Input.is_action_just_pressed("e"):
		if inventory.visible:
			inventory.close()
		else:
			inventory.open()
	
	if Input.is_action_just_pressed("q"):
		set_item_stack(null)
	
	if Input.is_action_just_pressed("detailed_mode"):
		is_detailed_mode_on = not is_detailed_mode_on
		
	if Input.is_action_just_pressed("x"):
		inventory.add_item_stack(ItemStack.new(Database.item_database["Iron_Ore"][0], 10))
	if Input.is_action_just_pressed("g"):
		inventory.add_item_stack(ItemStack.new(Database.item_database["Coal"][0], 10))
	if Input.is_action_just_pressed("v"):
		inventory.add_item_stack(ItemStack.new(Database.item_database["Archer_Tower"][0], 10))
	if Input.is_action_just_pressed("c"):
		inventory.add_item_stack(ItemStack.new(Database.item_database["Furnace"][0], 10))
	if Input.is_action_just_pressed("y"):
		var enemy = load("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn").instantiate()
		enemy.global_position = mouse_position
		owner.add_child(enemy)
	
func attempt_place_building():
	var mouse_position: Vector2 = get_global_mouse_position() - Vector2(8,8)
	if not inventory.visible and left_click_down:
		if selected_item_stack and selected_item_stack.item is PlaceableItem and selected_item_stack.count > 0 and not BuildingManager.check_position_occupied(mouse_position):
			var building: Building = selected_item_stack.item.buildingScene.instantiate()
			building.global_position = snapped(mouse_position, Vector2(16, 16))
			var cell_layer_0 = tile_map.get_cell_tile_data(0, building.global_position/16)
			var cell_layer_1 = tile_map.get_cell_tile_data(1, building.global_position/16)

			if cell_layer_0 == null:
				return
			var is_placeable_tile = cell_layer_0.get_custom_data("Placeable")
			if not is_placeable_tile:
				return
				
			if building is Drill:
				if cell_layer_1 == null:
					return
				var ore = cell_layer_1.get_custom_data("Ore")
				if not ore:
					return
				var new_recipe = Recipe.new("Mining", drill_mining_time, [], [ItemStack.new(ore, 1)])
				building.recipe = new_recipe
				
			BuildingManager.add_building(building)
			get_owner().add_child(building)
			selected_item_stack.count = selected_item_stack.count - 1
			if selected_item_stack.count <= 0:
				selected_item_stack = null
			inventory.update_slots()
			update_selected_item_sprite_and_label()



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

func update_selected_item_sprite_and_label():
	if selected_item_stack and selected_item_stack.count >= 0:
		selected_item_label.text = str(selected_item_stack.count)
		selected_item_sprite.texture = selected_item_stack.item.sprite
	else:
		selected_item_sprite.texture = null
		selected_item_label.text = ""

func _on_inventory_slot_input(slot_id, _event):
	if Input.is_action_just_pressed("left_click") and not Input.is_action_just_pressed("shift_left_click"):
		set_item_stack(inventory.item_stacks[slot_id])
