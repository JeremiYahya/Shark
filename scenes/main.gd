class_name Main
extends Node

@export var game: Game
@export var ui: UI
var menu_ui: PackedScene = preload("res://scenes/menu_ui.tscn")
var game_over_ui: PackedScene = preload("res://scenes/game_over_ui.tscn")
var credit_ui: PackedScene = preload("res://scenes/credit_ui.tscn")
var time_passed: float = 0
var sub_counter: int = 0:
	set(value):
		sub_counter = value
		ui.set_sub_counter_display(sub_counter)
var start: bool = false


func _init():
	pass


func _ready():
	var menu = menu_ui.instantiate()
	ui.add_child(menu)
	menu.start_game.connect(start_game)
	menu.credit.connect(show_credit)
	game.eat_sub.connect(func(): sub_counter += 1)
	game.level_up.connect(func(x): ui.set_level_display(x))
	game.hp_changed.connect(on_shark_hp_changed)


func _process(delta):
	if start:
		time_passed += delta
		ui.set_time_display(time_passed)


func start_game():
	start = true
	time_passed = 0
	sub_counter = 0
	game.start_game()
	ui.start_game()


func show_credit():
	var credit = credit_ui.instantiate()
	ui.add_child(credit)


func on_shark_hp_changed(max_hp: int, hp: int):
	ui.set_hp_indicator(max_hp, hp)
	if hp <= 0:
		var game_over = game_over_ui.instantiate()
		ui.add_child(game_over)
		start = false
		var shark = get_node("/root/Main/Game/EntityContainers/Shark")
		game_over.set_ui(shark.level, sub_counter, time_passed)
		game_over.retry.connect(start_game)
		game_over.title.connect(func(): get_tree().change_scene_to_file("res://scenes/main.tscn"))
		game.sub_spawn_timer.stop()
		game.mine_spawn_timer.stop()
		game.jelly_spawn_timer.stop()
