extends CharacterBody2D
@onready var animated_sprite = get_node("AnimatedSprite2D")

@export var speed: int
@export var damage: int
@export var health: int
@export var armor: int
var hasTarget = false
var targets: Array[int]
var curr: Node


func _on_detection_area_body_entered(body):
	print(body.name)
	if "Building" in body.name:
		var temp = []
		#currTargets = get_node("Tower").get_overlapping_bodies()
		hasTarget = true


func _on_detection_area_body_exited(body):
	hasTarget = false

func _physics_process(delta):
	if hasTarget:
		print("TARGET")
	else:
		pass
		
