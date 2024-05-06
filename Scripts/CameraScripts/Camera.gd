extends Camera2D

@onready var playerNode : Node2D = owner.get_node("Player")

# if followPlayerDirectly is on, camera will always be exactly on the player. No smoothing or catching up
@export var followPlayerDirectly = false

@export var cameraMoveSpeed = 7.5
@export var deadzoneDistance = 10

func _physics_process(delta):
	print(delta)
	if followPlayerDirectly:
		global_position = playerNode.global_position
	else:
		if (playerNode.global_position - global_position).length() > deadzoneDistance:
			global_position = global_position.lerp(playerNode.global_position, delta * cameraMoveSpeed)
