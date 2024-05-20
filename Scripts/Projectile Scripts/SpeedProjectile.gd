extends Projectile

class_name SpeedProjectile
var start: bool = false
var max_time: int = 10
var my_timer: float = 0.0

func _process(delta):
	if start:
		my_timer += delta
	if my_timer >= max_time:
		start = false 
		my_timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
func _delta():
	velocity = direction.normalized() * (speed * .5) 

