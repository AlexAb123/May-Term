extends Projectile
class_name HomingProjectile
var target: Enemy
func _physics_process(delta: float):
	if is_instance_valid(target):
		direction = target.global_position - global_position
		velocity = direction.normalized() * speed
	super(delta)
