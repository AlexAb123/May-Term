extends RotatingProjectile

class_name PoisonProjectile
# Called when the node enters the scene tree for the first time.
@export var poison_cooldown: float = 1
var poison_cooldown_timer = 0
var is_poisoned: bool = false
var poison_damage = 2
func _ready():
	super() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func poison(body):
	if body is Enemy:
		body.takedamage(poison_damage)
