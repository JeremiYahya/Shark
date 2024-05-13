class_name Submarine
extends CharacterBody2D

signal missile_spawned(_missile)

@export var speed: float = 300
@export var radius_min: float = 300
@export var radius_max: float = 400
@export var ammo: int = 5
@export var missile_timer: Timer
@export var move_timer: Timer
var missile: PackedScene = preload("res://scenes/missile.tscn")
var target_pos: Vector2
var is_moving: bool = true
var is_shooting: bool = false


func _ready():
	missile_timer.timeout.connect(shoot_missile)
	move_timer.timeout.connect(func(): target_pos = set_random_destination())


func _process(delta):
	if !is_moving && ammo > 0 && missile_timer.is_stopped() && !is_shooting:
		ammo -= 1
		missile_timer.start()


func _physics_process(delta):
	var distance = target_pos - position
	if distance.length() >= 3:
		var direction = distance.normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		position = target_pos
		is_moving = false


func set_random_destination():
	is_moving = true
	is_shooting = false
	while true:
		var pos_x: float = randf_range(100, get_viewport_rect().size.x - 100)
		var pos_y: float = randf_range(100, get_viewport_rect().size.y - 100)
		var dist_squared = pow(pos_x - position.x, 2) + pow(pos_y - position.y, 2)
		if dist_squared >= pow(radius_min, 2) && dist_squared <= pow(radius_max, 2):
			return Vector2(pos_x, pos_y)


func shoot_missile():
	var _missile = missile.instantiate()
	missile_spawned.emit(_missile)
	_missile.position = position
	is_shooting = true
	
	if ammo > 0:
		move_timer.start()
