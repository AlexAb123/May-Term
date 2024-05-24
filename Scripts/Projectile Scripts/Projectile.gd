extends CharacterBody2D

class_name Projectile

var start_position: Vector2
var direction: Vector2
@export var damage: int = 50
@export var speed: int = 50
@export var pierce_count: int = 1
@onready var current_pierce_count: int = pierce_count

@onready var despawn_timer = $DespawnTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = start_position
	velocity = direction.normalized() * speed
	despawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.take_damage(damage)
		current_pierce_count = current_pierce_count - 1
		if current_pierce_count <= 0:
			queue_free()
		

func _on_timer_timeout():
	queue_free()
