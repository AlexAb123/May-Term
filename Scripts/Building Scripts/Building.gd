extends Node2D

class_name Building

@export var deconstruct_time : float = 0
@export var size : Vector2 = Vector2(1,1)
@export var sprite: Texture2D
@onready var sprite2D: Sprite2D = get_node("Sprite2D")

var deconstruct_timer = 0

func _physics_process(delta):
	
	if right_click_down:
		deconstruct_timer += delta
		
		if deconstruct_timer >= deconstruct_time:
			deconstruct_timer = 0
			deconstruct()
	else:
		deconstruct_timer = 0
	
func _ready():
	sprite2D.texture = sprite

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
				right_click_down = true

func deconstruct():
	print("Add item to player inventory")
	BuildingManager.remove_building(self)
	queue_free()
