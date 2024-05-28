extends Node2D

signal win

@onready var enemies = [preload("res://Scenes/Enemy Scenes/Base Enemy Scenes/Enemy.tscn")]
@onready var wavelist : Array
var wave : int = 0
# must edit when adding more enemies
@onready var OptionsMenu : Control = $"../../MenuLayer/OptionsMenu"
@onready var spawn_timer : Timer = $SpawnTimer
@onready var main_menu = $"../../../MainMenu"
@onready var game_over = true

func _ready():
	spawn_timer.autostart = false
	spawn_timer.paused = true


func _process(_delta):
	if not game_over:
		checkWin()

func getRandPosition():
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
	print(wavelist[wave])
	spawn_timer.set_wait_time(wavelist[wave][1])
	print("WAIT TIME", spawn_timer.wait_time)
	spawn_timer.start()
	spawn_timer.paused = false
	print("time left", spawn_timer.time_left)
	for i in wavelist[wave][0]:
		var enemy_instance = enemies[0].instantiate() # must edit when adding more enmemies
		get_node("enemies").add_child(enemy_instance)
		enemy_instance.position = getRandPosition()
		await get_tree().process_frame

func checkWin():
	if wave == wavelist.size():
		if get_node("enemies").get_child_count() == 0:
			print("YOU PASSED")
			win.emit()
			game_over = true


func _on_spawn_timer_timeout():
	spawn_timer.paused = true
	if wave < wavelist.size() - 1:
		wave += 1
		spawner()

#func _physics_process(_delta):
	#print(spawn_timer.time_left)
	
func _on_levels_child_entered_tree(node):
	game_over = false
	await get_tree().process_frame
	wavelist = node.wavelist
	print(wavelist)
	spawner()


