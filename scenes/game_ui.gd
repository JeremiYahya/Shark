class_name GameUI
extends Control

@export var level_label: Label
@export var sub_destroyed_label: Label
@export var time_label: Label
@export var hp_container: BoxContainer
var hp_indicator: PackedScene = preload("res://scenes/hp_indicator.tscn")


func set_level_display(level: int):
	level_label.text = "Level: " + str(level)


func set_sub_counter_display(sub: int):
	sub_destroyed_label.text = "Sub Destroyed: " + str(sub)


func set_time_display(time: float):
	var minutes: int = floori(time / 60)
	var seconds: int = (int)(time) % 60
	var second_txt: String = str(seconds) if floori(seconds / 10) > 0 else "0" + str(seconds)
	time_label.text = "Time: " + str(minutes) + ":" + second_txt


func set_hp_indicator(max_hp: int, hp: int):
	if max_hp > hp_container.get_child_count():
		var amount = max_hp - hp_container.get_child_count()
		for i in amount:
			var indicator = hp_indicator.instantiate()
			hp_container.add_child(indicator)
			indicator.texture = indicator.texture.duplicate()
	
	for i in max_hp:
		hp_container.get_child(i).texture.region = Rect2(0, 0, 32, 32) if i < hp else Rect2(32, 0, 32, 32)
