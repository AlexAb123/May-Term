extends DefenseBuilding

class_name RangedDefenseBuilding

@export var projectile: PackedScene

func attack():
	var proj: Projectile = projectile.instantiate()
	proj.start_position = global_position + Vector2(8,8)
	proj.direction = (target.global_position - global_position).normalized()
	get_parent().add_child(proj)
