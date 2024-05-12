class_name Game
extends Node2D

@export var game_timer: Timer
@export var spawn_timer: Timer
var submarine: PackedScene = preload("res://scenes/submarine.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	_summon_submarine()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _summon_submarine():
	var spawn_region: int = randi_range(0, 3)
	var spawn_position: Vector2 = Vector2()
	var pos_x: float
	var pos_y: float
	if spawn_region % 2 == 0:
		pos_x = spawn_region / 2 * get_viewport_rect().size.x + 100 * (spawn_region - 1)
		pos_y = randf_range(-100, get_viewport_rect().size.y + 100)
	else:
		pos_x = randf_range(-100, get_viewport_rect().size.x + 100)
		pos_y = (spawn_region - 1) / 2 * get_viewport_rect().size.y + 100 * (spawn_region - 2)
	var sub = submarine.instantiate()
	add_child(sub)
	sub.position = Vector2(pos_x, pos_y)
	sub.missile_spawned.connect(func(x): add_child(x))
