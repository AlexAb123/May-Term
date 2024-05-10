extends Building

class_name DefenseBuilding

@export var health: int
@export var damage: int
@export var fire_rate: float
@export var range: float

var hasTarget: bool

func _ready():
	pass

func _process(delta):
	pass


func _on_detection_area_body_entered(body):
	hasTarget = true


func _on_detection_area_body_exited(body):
	hasTarget = false
