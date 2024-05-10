extends CharacterBody2D
@onready var animated_sprite = get_node("AnimatedSprite2D")
var hasTarget;

func _on_detection_area_body_entered(body):
	hasTarget = true


func _on_detection_area_body_exited(body):
	hasTarget = false

func _physics_process(delta):
	if hasTarget:
		print("TARGET")
	else:
		pass
		
