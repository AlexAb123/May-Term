extends DefenseBuilding

class_name RangedDefenseBuilding

@export var projectile: PackedScene

func attack():
	var proj: Projectile = projectile.instantiate()
	proj.start_position = global_position
	proj.direction = (target.global_position - global_position).normalized()
	get_parent().add_child(proj)
