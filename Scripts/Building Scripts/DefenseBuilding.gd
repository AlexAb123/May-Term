extends Building

class_name DefenseBuilding

@export var health: int = 100
@export var detection_range: int = 25

var targets: Array[Enemy]
var target: Enemy

@onready var detection_area: Area2D = $DetectionArea2D
@onready var detection_shape: CollisionShape2D = $DetectionArea2D/DetectionArea2DCollisionShape2D


func _ready():
	super()
	detection_shape.shape.radius = detection_range
	
@export var attack_cooldown: float = 1
var attack_cooldown_timer = 0
var is_attacking: bool = false

func _physics_process(delta):
	super(delta)
	find_target()
	if target:
		if attack_cooldown_timer <= 0:
			attack()
			attack_cooldown_timer = attack_cooldown
		else:
			attack_cooldown_timer -= delta
			
func attack():
	pass
	
func find_target():
	if targets:
		target = targets[0]
	else:
		target = null
		
func _on_detection_area_2d_body_entered(body):
	if body is Enemy:
		targets.append(body)
		targets.sort_custom(compare_distance)


func _on_detection_area_2d_body_exited(body):
	if body is Enemy:
		targets.erase(body)
	
func compare_distance(body1, body2):
	return (global_position - body1.global_position).length() < (global_position - body2.global_position).length()

