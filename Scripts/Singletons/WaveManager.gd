extends Node2D

#@onready var positions = [$Marker2D, $Marker2D2, $Marker2D3, $Marker2D4]
@onready var positions = [$TestMarker]
@onready var enemies = [preload("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn")]
@onready var wavelist = [1, 2, 0, 2, 0] 
var wave : int = 0
# must edit when adding more enemies


func getRandPosition():
	var node = positions[randi() % positions.size()]
	#print(node)
	return node.global_position
	


func spawner():
	print("wave", wave)
	for i in wavelist[wave - 1]:
		var enemy_instance = enemies[0].instantiate() # must edit when adding more enmemies
		add_child(enemy_instance)
		print("enemy spawned")
		enemy_instance.position = getRandPosition()

	#pass # Replace with function body.

func _on_spawn_timer_timeout():
	if wave < wavelist.size() - 1:
		wave += 1
		spawner()
	



