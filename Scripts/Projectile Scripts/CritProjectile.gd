extends RotatingProjectile

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.

func _on_area_2d_body_entered(body):
	var my_random_number = rng.randf_range(0, 5)
	if my_random_number >= 4.5:
		damage = damage * 5
	if body is Enemy:
		body.take_damage(damage)
		current_pierce_count = current_pierce_count - 1
		if current_pierce_count <= 0:
			queue_free()
