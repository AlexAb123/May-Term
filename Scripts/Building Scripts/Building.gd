extends Node2D

class_name Building

@export var item_name: String
@export var deconstruct_time : float = 0.1
@export var sprite: Texture2D
@onready var sprite2D: Sprite2D = get_node("Sprite2D")
@export var max_health: int = 50
@onready var current_health: int = max_health
@onready var health_bar: TextureProgressBar = $HealthBar

signal healthChanged

var deconstruct_timer = 0

func _ready():
	sprite2D.texture = sprite
	
func _physics_process(delta):
	
	if current_health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	
	if right_click_down:
		deconstruct_timer += delta
		Global.player.is_deconstructing = true
		
	elif deconstruct_timer > 0:
		deconstruct_timer = 0
		Global.player.is_deconstructing = false
		
	if deconstruct_timer >= deconstruct_time:
		deconstruct_timer = 0
		
		Global.player.is_deconstructing = false
		deconstruct()
		
var mouse_hover = false

func _on_area_2d_mouse_entered():
	mouse_hover = true
	if Input.is_mouse_button_pressed(1):
		left_click_down = true
	if Input.is_mouse_button_pressed(2):
		right_click_down = true
		

func _on_area_2d_mouse_exited():
	mouse_hover = false
	left_click_down = false
	right_click_down = false
	
var left_click_down = false
var right_click_down = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				left_click_down = true
			if event.button_index == 2:
				right_click_down = true
		else:
			if event.button_index == 1:
				left_click_down = false
			if event.button_index == 2:
				right_click_down = false

func take_damage(damage):
	current_health -= damage
	healthChanged.emit()
	if current_health <= 0:
		destroy()

func destroy():
	queue_free()
	
func deconstruct():
	print("Add item to player inventory")
	Global.player.inventory.add_item_stack(ItemStack.new(Database.item_database[item_name][0], 1))
	Global.player.update_selected_item_sprite_and_label()
	BuildingManager.remove_building(self)
	queue_free()
