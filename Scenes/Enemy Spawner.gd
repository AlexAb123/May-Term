extends Node2D

@onready var positions = [$Marker2D, $Marker2D2, $Marker2D3, $Marker2D4]
@onready var enemies = [preload("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn")] 
# must edit when adding more enemies

#func getRandPosition():
	#var node = positions[randi() % positions.size()]
	##print(node)
	#return node.global_position
	#
#
#
#func _on_spawn_timer_timeout():
	#var enemy_instance = enemies[0].instantiate() # must edit when adding more enmemies
	#add_child(enemy_instance)
	#enemy_instance.position = getRandPosition()
#
	##pass # Replace with function body.
