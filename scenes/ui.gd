class_name UI
extends Control

var game_ui_packed: PackedScene = preload("res://scenes/game_ui.tscn")
var pre_game_ui_packed: PackedScene = preload("res://scenes/pre_game_ui.tscn")
var game_ui: GameUI

func start_game():
	if game_ui != null:
		game_ui.queue_free()
	var ui = game_ui_packed.instantiate()
	add_child(ui)
	game_ui = ui
	game_ui.set_hp_indicator(3, 3)
	game_ui.set_level_display(0)
	game_ui.set_sub_counter_display(0)
	var pre_game = pre_game_ui_packed.instantiate()
	add_child(pre_game)


func set_level_display(level: int):
	game_ui.set_level_display(level)


func set_sub_counter_display(sub: int):
	if game_ui != null:
		game_ui.set_sub_counter_display(sub)


func set_time_display(time: float):
	game_ui.set_time_display(time)


func set_hp_indicator(max_hp: int, hp: int):
	game_ui.set_hp_indicator(max_hp, hp)
