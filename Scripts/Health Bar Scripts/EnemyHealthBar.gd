extends TextureProgressBar

@export var enemy : Enemy


func _ready():
	enemy.healthChanged.connect(update)
	update()

func update():
	value = enemy.current_health * 100 / enemy.max_health
