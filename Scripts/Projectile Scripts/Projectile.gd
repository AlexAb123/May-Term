extends CharacterBody2D

class_name Projectile

var start_position: Vector2
var direction: Vector2
@export var damage: int = 10
@export var speed: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = start_position
	velocity = direction.normalized() * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.take_damage(damage)
		queue_free()


func _on_timer_timeout():
	queue_free()
