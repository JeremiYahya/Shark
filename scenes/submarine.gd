class_name Submarine
extends CharacterBody2D

signal missile_spawned(_missile)

@export var speed: float = 200
@export var ammo: int = 1
@export var missile_timer: Timer
var missile: PackedScene = preload("res://scenes/missile.tscn")
var target_pos: Vector2
var is_moving: bool = true


func _ready():
	target_pos = set_random_destination()
	missile_timer.timeout.connect(shoot_missile)


func _process(delta):
	if !is_moving && ammo > 0 && missile_timer.is_stopped():
		ammo -= 1
		missile_timer.start()


func _physics_process(delta):
	var distance = target_pos - position
	if distance.length() >= 2:
		is_moving = true
		var direction = distance.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		position = target_pos
		is_moving = false


func set_random_destination():
	var pos_x: float = randf_range(100, get_viewport_rect().size.x - 100)
	var pos_y: float = randf_range(100, get_viewport_rect().size.y - 100)
	return Vector2(pos_x, pos_y)


func shoot_missile():
	var _missile = missile.instantiate()
	missile_spawned.emit(_missile)
	_missile.position = position
