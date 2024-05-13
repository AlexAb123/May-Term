extends Building

class_name DefenseBuilding

@export var health: int
@export var damage: int
@export var fire_rate: float
@export var range: float

@onready var detection_area: Area2D = $DetectionArea2D
@onready var detection_shape: CollisionShape2D = $DetectionArea2D/DetectionArea2DCollisionShape2D

var hasTarget: bool

func _ready():
	super()
	detection_shape.shape.radius = range

func _process(delta):
	
	pass

func _on_detection_area_2d_body_entered(body):
	hasTarget = true
	print(body)
	print("enter")


func _on_detection_area_2d_body_exited(body):
	hasTarget = false
	print(body)
	print("exit")


