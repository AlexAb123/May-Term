extends Projectile
class_name HomingProjectile
var target: Enemy
func _physics_process(delta: float):
	if is_instance_valid(target) and target is Enemy:
		look_at(target.global_position)
	super(delta)

