extends TextureProgressBar

@export var building : Building


func _ready():
	building.healthChanged.connect(update)
	update()

func update():
	value = building.current_health * 100 / building.max_health
