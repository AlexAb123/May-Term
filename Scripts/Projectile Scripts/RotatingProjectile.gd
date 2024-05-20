extends Projectile

class_name RotatingProjectile

# Called when the node enters the scene tree for the first time.
	
func _ready():
	super() # Replace with function body.
	rotation = direction.angle()
