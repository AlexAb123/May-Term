extends CharacterBody2D

class_name Enemy

signal healthChanged
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_shape = $DetectionArea2D/DetectionArea2DCollisionShape2D
@onready var damage_shape = $DamageArea2D/DamageCollisionShape2D
@onready var hit = $hit
@onready var death_timer = $DeathTimer


@export var speed: int = 25
@export var damage: int = 5
@export var attack_cooldown: float = 1
@export var max_health: int = 20
@onready var current_health: int = max_health
@export var armor: int
@export var detection_range: int = 25
@export var damage_range: int = 8
@onready var dying = false

var target

var detection_targets: Array
var damage_targets: Array



func _ready():
	detection_shape.shape.radius = detection_range
	damage_shape.shape.radius = damage_range

func _on_detection_area_2d_body_entered(body):
	if body is Building or body is Player:
		detection_targets.append(body)
		detection_targets.sort_custom(compare_distance)
		
func _on_detection_area_2d_body_exited(body):
	detection_targets.erase(body)
	
func _on_damage_area_2d_body_entered(body):
	if body is Building or body is Player:
		damage_targets.append(body)
		
func _on_damage_area_2d_body_exited(body):
	damage_targets.erase(body)
	
var attack_cooldown_timer = 0
var is_attacking: bool = false

func take_damage(dmg):
	if current_health > 0:
		current_health -= dmg
		healthChanged.emit()
		if current_health <= 0:
			death()
		else:
			animated_sprite.play("hit")
			hit.start()

func death():
	$CollisionShape2D.queue_free()
	dying = true
	animated_sprite.play("death")
	death_timer.start()

func _on_timer_timeout():
	queue_free()
	
func _physics_process(delta):
	if not dying:
		find_target()

		if target in damage_targets:
			is_attacking = true
			if attack_cooldown_timer <= 0:
				target.take_damage(damage)
				attack_cooldown_timer = attack_cooldown
			else:
				attack_cooldown_timer -= delta
		else:
			is_attacking = false	
			attack_cooldown_timer -= delta
		
		if target:
			if target is TownHall:
				velocity = (target.global_position + Vector2(8,8) - global_position).normalized() * speed
			else:
				velocity = (target.global_position - global_position).normalized() * speed
		else:
			velocity = (Vector2(0, 0) - global_position).normalized() * speed
		
		if not is_attacking:
			move_and_slide()

func find_target():
	if detection_targets:
		target = detection_targets[0]
	else:
		target = null
		
func compare_distance(body1, body2):
	return (global_position - body1.global_position).length() < (global_position - body2.global_position).length()


func _on_hit_timeout():
	if not dying:
		animated_sprite.play("idle")
