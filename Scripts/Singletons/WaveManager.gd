extends Node2D

signal win

@onready var enemies = [preload("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn")]
@onready var wavelist = [0, 0, 0, 0, 1, 2, 7, 10, 0] 
var wave : int = 0
# must edit when adding more enemies
@onready var OptionsMenu : Control = $"../../MenuLayer/OptionsMenu"
@onready var spawn_timer = $SpawnTimer
@onready var main_menu = $"../../../MainMenu"


func _process(_delta):
	checkWin()

func getRandPosition():
	#var node = positions[randi() % positions.size()]
	#return node.global_position
	var node = Marker2D.new()
	node.position.x = randi() % 200 * (((randi() % 2) * 2) - 1)
	node.position.y = pow( (pow(200, 2)   -   pow(node.position.x, 2)),    0.5) * ((randi() % 2)* 2 - 1)
	#print(node.global_position)
	return node.global_position
	

func manageQuit():
	pauseTimer()
	for n in get_node("enemies").get_children():
		get_node("enemies").remove_child(n)
		n.queue_free()
	wave = 0

func pauseTimer():
	spawn_timer.stop()
	
func playTimer():
	spawn_timer.start()
	
func spawner():
	#print("wave", wave)
	for i in wavelist[wave - 1]:
		var enemy_instance = enemies[0].instantiate() # must edit when adding more enmemies
		get_node("enemies").add_child(enemy_instance)
		#print("enemy spawned")
		enemy_instance.position = getRandPosition()

func checkWin():
	if wave == wavelist.size():
		if get_node("enemies").get_child_count() == 0:
			print("YOU PASSED")
			win.emit()

func _on_spawn_timer_timeout():
	if wave < wavelist.size():
		wave += 1
		spawner()


func _on_levels_child_entered_tree(node):
	await get_tree().process_frame
	#print(node.wavelist)
	wavelist = node.wavelist

