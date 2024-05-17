extends Building

class_name RecipeBuilding

@export var recipes : Array[Recipe]

@onready var timer: Timer = $Timer

@export var on_sprite: Texture2D


var selectedRecipe : Recipe

func _ready():
	super()
	#selectRecipe(0)
func _physics_process(delta):
	super(delta)
	
	if right_click_down:
		pass
	if left_click_down and not Global.player.selected_item_stack:
		#inventory.open()
		Global.player.inventory.open()
