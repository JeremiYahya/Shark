class_name Game
extends Node2D

signal eat_sub
signal hp_changed(max_hp: int, hp: int)
signal level_up(level: int)

@export var sub_spawn_timer: Timer
@export var mine_spawn_timer: Timer
@export var jelly_spawn_timer: Timer
@export var entity_containers: Node2D
var shark: PackedScene = preload("res://scenes/shark.tscn")
var submarine: PackedScene = preload("res://scenes/submarine.tscn")
var mine: PackedScene = preload("res://scenes/mine.tscn")
var jelly: PackedScene = preload("res://scenes/jellyfish.tscn")
var sub_spawn_chance: Array[float] = [1]


func _init():
	pass


func _ready():
	sub_spawn_timer.timeout.connect(set_submarine_spawned)
	mine_spawn_timer.timeout.connect(summon_mine)
	jelly_spawn_timer.timeout.connect(summon_jelly)


func start_game():
	for i in entity_containers.get_children():
		i.queue_free()
	var _shark = shark.instantiate()
	_shark.name = "Shark"
	entity_containers.add_child(_shark, true)
	_shark.hp_changed.connect(func(x, y): hp_changed.emit(x, y))
	_shark.level_up.connect(on_level_up)
	_shark.eat_sub.connect(func(): eat_sub.emit())
	sub_spawn_timer.wait_time = 5
	mine_spawn_timer.wait_time = 5
	jelly_spawn_timer.wait_time = 5
	sub_spawn_timer.start()


func on_level_up(level: int):
	if level % 5 == 1:
		sub_spawn_chance.append(0)
	var reduced_chance_pos: int
	for i in sub_spawn_chance.size():
		if sub_spawn_chance[i] > 0:
			reduced_chance_pos = i
			break
	for i in range(sub_spawn_chance.size(), reduced_chance_pos, -1):
		sub_spawn_chance[i - 1] += 0.05
		sub_spawn_chance[reduced_chance_pos] -= 0.05
	if sub_spawn_chance[reduced_chance_pos] < 0:
		sub_spawn_chance[reduced_chance_pos + 1] += sub_spawn_chance[reduced_chance_pos]
		sub_spawn_chance[reduced_chance_pos] = 0
	sub_spawn_timer.wait_time *= 0.99
	if level == 10:
		mine_spawn_timer.start()
	if level >= 11:
		mine_spawn_timer.wait_time *= 0.98
	if level == 15:
		jelly_spawn_timer.start()
	if level >= 16:
		jelly_spawn_timer.wait_time *= 0.98
	level_up.emit(level)


func set_submarine_spawned():
	var sub_spawned: int
	var chance: float = randf()
	var acc_chance: float = 0
	var start: int
	for i in sub_spawn_chance.size():
		if sub_spawn_chance[i] > 0:
			start = i;
			break
	for i in range(start, sub_spawn_chance.size()):
		acc_chance += sub_spawn_chance[i]
		if chance <= acc_chance:
			sub_spawned = i + 1
			break
	for i in sub_spawned:
		summon_submarine()


func summon_submarine():
	var spawn_region: int = randi_range(0, 3)
	var pos_x: float
	var pos_y: float
	if spawn_region % 2 == 0:
		pos_x = spawn_region / 2 * get_viewport_rect().size.x + 100 * (spawn_region - 1)
		pos_y = randf_range(-100, get_viewport_rect().size.y + 100)
	else:
		pos_x = randf_range(-100, get_viewport_rect().size.x + 100)
		pos_y = (spawn_region - 1) / 2 * get_viewport_rect().size.y + 100 * (spawn_region - 2)
	var sub = submarine.instantiate()
	entity_containers.add_child(sub)
	sub.position = Vector2(pos_x, pos_y)
	sub.target_pos = sub.set_random_destination()
	sub.missile_spawned.connect(func(x): entity_containers.add_child(x))


func summon_mine():
	var pos_x: float = randf_range(50, get_viewport_rect().size.x - 50)
	var pos_y: float = -100
	var _mine = mine.instantiate()
	entity_containers.add_child(_mine)
	_mine.position = Vector2(pos_x, pos_y)
	_mine.target_pos = _mine.set_random_destination()


func summon_jelly():
	var pos_x: float = randf_range(50, get_viewport_rect().size.x - 50)
	var pos_y: float = get_viewport_rect().size.y + 100
	var _jelly = jelly.instantiate()
	entity_containers.add_child(_jelly)
	_jelly.position = Vector2(pos_x, pos_y)
