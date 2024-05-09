extends Node2D

class_name Building

@export var build_time : float
@export var deconstruct_time : float
@export var size : Vector2


var deconstruct_timer = 0
func _physics_process(delta):
	if right_click_down:
		deconstruct_timer += delta
	else:
		deconstruct_timer = 0
	
	if deconstruct_timer >= deconstruct_time:
		deconstruct_timer = 0
		deconstruct()

var mouse_hover = false

func _on_area_2d_mouse_entered():
	mouse_hover = true

func _on_area_2d_mouse_exited():
	mouse_hover = false
	left_click_down = false
	right_click_down = false
	
func _on_area_2d_input_event(viewport, event, shape_idx):
	
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
	

func deconstruct():
	print("Add item to player inventory")
	queue_free()
